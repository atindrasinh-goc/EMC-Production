global class DeActivatedUserBatchMileage implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    
    String query;
    private static final String URL = System.Label.Triplog_URL_For_Trips;
    private static final String TRIP_STATUS = System.Label.Triplog_URL_For_TripStatus;
    //private static final String User_Deactivate = System.Label.Triplog_URL_For_Trips;
    private static Http newHttp, updateHttp, nHttp, uHttp;
    private static HttpRequest newRequest, updateRequest, nRequest, uRequest;
    private static HttpResponse newResponse, updateResponse, nResponse, uResponse;
    private static TripLogJSONClass.TripLogJSONClassInner tripLog;
    //private static TriplogJSONUserClass userList;
    private static Set<Integer> tripIds;
    private static String endPoint;
    private static String strStartDate;
    private static String strEndDate;
    public Integer decider;
    public List<String> deActivatedConIds;
    public String userid;
    
   
    private static HttpCalloutMock httpMock = null;
    
    global DeActivatedUserBatchMileage() {
        
        String monthquery = getEditQuery();
        decider = 0;
        if(!Test.isRunningTest())
        {            
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c FROM Employee_Reimbursement__c WHERE Contact_Id__r.Deactivated_Date__c = Today AND Month__c IN '+ monthquery +' and Contact_Id__r.IsDeactivated__c = false';    
        } 
        else
        {            
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c FROM Employee_Reimbursement__c WHERE Contact_Id__r.Deactivated_Date__c = Today AND Month__c IN '+ monthquery +' and Contact_Id__r.IsDeactivated__c = false Limit 1';
        }
        System.debug('query :- '+query);
       
    }
    global DeActivatedUserBatchMileage(List<String> passeddeActivatedConIds) {
        
        system.debug('DeActivatedUserBatchMileage');
        deActivatedConIds = passeddeActivatedConIds;
        String monthquery = getEditQuery();
        decider = 1;
        String editedquery = '( ';
        for(String currentContactID : deActivatedConIds)
        {
            editedquery = editedquery + '\''+currentContactID+ '\','; 
        }
        if(editedquery.endsWith(','))
        {
            editedquery = editedquery.removeEnd(',');
        }
        editedquery = editedquery+' )';

        if(!Test.isRunningTest())
        {            
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c,Contact_Id__r.AccountId FROM Employee_Reimbursement__c WHERE Contact_Id__c In '+editedquery + ' AND Month__c IN '+ monthquery;    
           
        } 
        else
        {            
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c,Contact_Id__r.AccountId FROM Employee_Reimbursement__c WHERE Contact_Id__r.AccountId In'+editedquery+' Limit 1';
        }
        System.debug('query :- '+query);
       
    }
    global DeActivatedUserBatchMileage(String passuserid) {
        
        String monthquery = getEditQuery();
        decider = 2;
        userid = passuserid;
        String identifier = userid.left(3);
        if(identifier == '001' && (!Test.isRunningTest())){
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c, Contact_Id__r.AccountId, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c FROM Employee_Reimbursement__c WHERE Contact_Id__r.AccountId  = \''+userid+'\' '+ 'AND Month__c IN '+ monthquery;
        } 
        else if(!Test.isRunningTest()){
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c,Contact_Id__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c FROM Employee_Reimbursement__c WHERE Contact_Id__c = \''+userid+'\' '+ 'AND Month__c IN '+ monthquery;
            system.debug('query'+query);
        }
        else {
            query = 'SELECT Id,Fuel_Price__c,MPG__c,Maintenance_and_Tires__c,Contact_Id__c, Contact_Id__r.Triplog_UserID__c,Contact_Id__r.Deactivated_Date__c,Contact_Id__r.External_Email__c, Contact_Id__r.IsDeactivated__c, Contact_Id__r.Account.Triplog_API__c,Contact_Id__r.Employee_ID__c,Month__c,Contact_Id__r.Account.Timezone__c FROM Employee_Reimbursement__c Limit 1';
        }
        
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('start');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        
        if((list<Employee_Reimbursement__c>)scope!=null)
        {
            makeCallOut((list<Employee_Reimbursement__c>)scope);
        }       
    }

    webservice static void makeCallOut(list<Employee_Reimbursement__c> reimbursementList) {
        system.debug('makecalout');
        List<Tripslog__c> triplogList = new List<Tripslog__c>();
        tripIds = new Set<Integer>();
        List<Employee_Mileage__c> mileageList = new List<Employee_Mileage__c>();
        Set<Employee_Mileage__c> mileageset = new Set<Employee_Mileage__c>();
        List<String> callOutTripStatus = new List<String>{'S','U'};      
        Double totalmileages = 0;
        for(Employee_Reimbursement__c currentReimbursement : reimbursementList)
        {
            
           
            Tripslog__c triplogRecord;
            if(currentReimbursement.Contact_Id__r.Account.Triplog_API__c!=null)
            {
                if(currentReimbursement.Contact_Id__r.Deactivated_Date__c != null && currentReimbursement.Contact_Id__r.Deactivated_Date__c.Month()==Integer.valueOf(currentReimbursement.month__c.split('-')[0]))
                {
                    strStartDate = currentReimbursement.Contact_Id__r.Deactivated_Date__c.Year() + '-' + currentReimbursement.Contact_Id__r.Deactivated_Date__c.Month() + '-1';
                    strEndDate = currentReimbursement.Contact_Id__r.Deactivated_Date__c.Year() + '-' + currentReimbursement.Contact_Id__r.Deactivated_Date__c.Month() + '-' + currentReimbursement.Contact_Id__r.Deactivated_Date__c.day(); 
                    System.debug('strStartDate in if condition :- '+strStartDate);
                    System.debug('strEndDate in if condition :- '+strEndDate);
                }
                else if(currentReimbursement.Contact_Id__r.Deactivated_Date__c != null && currentReimbursement.Contact_Id__r.Deactivated_Date__c.Month()!=Integer.valueOf(currentReimbursement.month__c.split('-')[0]))
                {
                    if(Integer.valueOf(currentReimbursement.month__c.split('-')[0])==12)
                    {
                        strStartDate = String.valueOf((System.today().year()-1))+'-12-1'; 
                        strEndDate = String.valueOf((System.today().year()-1))+'-12-31';
                        System.debug('strStartDate in else with if condition :- '+strStartDate);
                        System.debug('strEndDate in else with if condition :- '+strEndDate);
                    }
                    else
                    {
                        strStartDate = String.valueOf((System.today().year()))+'-'+String.valueOf(currentReimbursement.month__c.split('-')[0])+'-1';
                        strEndDate = String.valueOf(System.today().year())+'-'+String.valueOf(currentReimbursement.month__c.split('-')[0])+'-'+ String.valueOf(date.newInstance(Integer.valueOf(System.today().year()),Integer.valueOf(currentReimbursement.month__c.split('-')[0])+1,1).addDays(-1).day());
                        System.debug('strStartDate in else with else condition :- '+strStartDate);
                        System.debug('strEndDate in else with else condition :- '+strEndDate);                        
                    }
                }
                for(String singleTrip : callOutTripStatus) 
                {
                    newHttp = new Http();
                    newRequest = new HttpRequest();
                    newResponse = new HttpResponse();
                    endPoint = 'startDate='+strStartDate+'&userEmail='+currentReimbursement.Contact_Id__r.External_Email__c+'&endDate='+strEndDate+'&status='+singleTrip+'&activity=Business';
                    System.debug('endPoint'+endPoint);
                    newRequest.setEndpoint(URL.trim()+endPoint.trim());
                    //newRequest.setEndpoint('https://triplogmileage.com/web/api/trips?'+endPoint.trim());
                    System.debug('endPointset'+URL);
                    newRequest.setMethod('GET');
                    newRequest.setTimeout(120000);
                    newRequest.setHeader('Authorization', 'apikey '+currentReimbursement.Contact_Id__r.Account.Triplog_API__c);
                    if(!Test.isRunningTest()) 
                    {
                        newResponse = newHttp.send(newRequest); 
                        system.debug('newResponse'+newResponse);                        
                    }
                    else 
                    {
                        newResponse = GetTripCalloutMock.respond(newRequest);   
                    }
                    if(newResponse.getStatusCode() == 200) 
                    {
                        System.debug('response200');
                        List<TripLogJSONClass.Trips> listofTrips = new List<TripLogJSONClass.Trips>();
                         system.debug('newResponse.getBody()'+newResponse.getBody());   
                        tripLog = TripLogJSONClass.parse(newResponse.getBody());
                        system.debug('tripLog'+tripLog);
                        listofTrips = tripLog.trips;
                        system.debug('listofTrips'+listofTrips);
                        for(TripLogJSONClass.Trips singleTrips : listofTrips)
                        {
                            system.debug('singleTrips'+singleTrips);
                            Employee_Mileage__c singleMileage = new Employee_Mileage__c();
                            singleMileage.Name = 'New Trip';
                            singleMileage.Approved_Date__c = null;
                            singleMileage.Trip_Status__c =StaticValues.noApprovedYet;
                            singleMileage.EmployeeReimbursement__c = currentReimbursement.Id;
                            singleMileage.Contact_Email_Id__c = currentReimbursement.Contact_Id__r.External_Email__c;
                            singleMileage.Trip_Id__c = singleTrips.Id;
                            singleMileage.Mileage__c = singleTrips.mileage;
                            singleMileage.Fuel_price__c = currentReimbursement.Fuel_Price__c;
                            singleMileage.MPG__c = currentReimbursement.MPG__c;
                            singleMileage.Maintenance_and_Tires__c = currentReimbursement.Maintenance_and_Tires__c;
                            if(singleTrips.fromLocation != null && singleTrips.fromLocation.display != null) 
                            {
                                singleMileage.Trip_Origin__c = singleTrips.fromLocation.display;
                                if(singleTrips.fromLocation.display.contains(','))
                                {
                                   singleMileage.Origin_Name__c = (singleTrips.fromLocation.display.split(','))[0];  
                                }
                                else if(singleTrips.fromLocation.display.contains(' '))
                                {
                                    singleMileage.Origin_Name__c = (singleTrips.fromLocation.display.split(' '))[0];
                                }
                                else
                                {
                                   singleMileage.Origin_Name__c =  singleTrips.fromLocation.display;
                                }
                            }
                            if(singleMileage.Mileage__c != null ){
                                totalmileages = totalmileages+Double.valueOf(singleMileage.Mileage__c);
                            }
                            if(singleTrips.toLocation != null && singleTrips.toLocation.display != null)
                            {
                                singleMileage.Trip_Destination__c = singleTrips.toLocation.display;
                                if(singleTrips.toLocation.display.contains(','))
                                {
                                   singleMileage.Destination_Name__c = (singleTrips.toLocation.display.split(','))[0];  
                                }
                                else if(singleTrips.toLocation.display.contains(' '))
                                {
                                    singleMileage.Destination_Name__c = (singleTrips.toLocation.display.split(' '))[0];
                                }
                                else
                                {
                                   singleMileage.Destination_Name__c =  singleTrips.toLocation.display;
                                }
                            }
                            if(singleMileage.Mileage__c == null || singleMileage.Mileage__c == 0) 
                            {
                                singleMileage.Trip_Status__c = 'Approved';
                                singleMileage.Approved_Date__c = System.Today();
                            }
                            if(singleTrips.startTime != null && singleTrips.startTime != '') 
                            {
                                string dateda = singleTrips.startTime;
                                dateda = dateda.replace(':','-');
                                dateda = dateda.replace('T','-');
                                DateTime myDateTime = DateTime.newInstance(integer.valueof(dateda.split('-')[0]), integer.valueof(dateda.split('-')[1]), integer.valueof(dateda.split('-')[2]), integer.valueof(dateda.split('-')[3]), integer.valueof(dateda.split('-')[4]), integer.valueof(dateda.split('-')[5].removeEnd('.000Z')));
                                //singleMileage.StartTime__c = myDateTime;
                                singleMileage.Day_Of_Week__c = myDateTime.format('EEEE');
                                /*if(currentReimbursement.Contact_Id__r.Account.Timezone__c!=null)
                                {
                                    String convertedZone = myDateTime.format('MM/dd/yyyy HH:mm:ss',currentReimbursement.Contact_Id__r.Account.Timezone__c);    
                                    singleMileage.StartTime__c =DateTime.newInstance(Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[2]),Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[0]),Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[1]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[0]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[1]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[2]));
                                }
                                else
                                {
                                    singleMileage.StartTime__c = myDateTime;
                                }*/
                                
                            }
                            else
                            {
                                singleMileage.StartTime__c = null;
                            }
                            if(singleTrips.endTime != null && singleTrips.endTime != '') 
                            {
                               // singleMileage.EndTime__c = str1;
                                string dateda = singleTrips.endTime;
                                dateda = dateda.replace(':','-');
                                dateda = dateda.replace('T','-');
                                DateTime myDateTime = DateTime.newInstance(integer.valueof(dateda.split('-')[0]), integer.valueof(dateda.split('-')[1]), integer.valueof(dateda.split('-')[2]), integer.valueof(dateda.split('-')[3]), integer.valueof(dateda.split('-')[4]), integer.valueof(dateda.split('-')[5].removeEnd('.000Z')));
                                //singleMileage.EndTime__c = myDateTime;
                               /* if(currentReimbursement.Contact_Id__r.Account.Timezone__c!=null)
                                {
                                    String convertedZone = myDateTime.format('MM/dd/yyyy HH:mm:ss',currentReimbursement.Contact_Id__r.Account.Timezone__c);    
                                    singleMileage.EndTime__c =DateTime.newInstance(Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[2]),Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[0]),Integer.valueOf(convertedZone.split(' ')[0].trim().split('/')[1]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[0]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[1]),Integer.valueOf(convertedZone.split(' ')[1].trim().split(':')[2]));
                                }
                                else
                                {
                                    singleMileage.EndTime__c = myDateTime;
                                }*/
                            } 
                            else 
                            {
                                singleMileage.EndTime__c = null;
                            }
                            if(singleTrips.notes != null && singleTrips.notes != '') 
                            {
                                singleMileage.Notes__c = singleTrips.notes;
                            } 
                            else 
                            {
                                singleMileage.Notes__c = null;
                            }
                            if(singleTrips.trackingMethod != null && singleTrips.trackingMethod != '') 
                            {
                                singleMileage.Tracing_Style__c = singleTrips.trackingMethod;
                            } 
                            else 
                            {
                                singleMileage.Tracing_Style__c = null;
                            }
                            String startDateMileage = singleTrips.startTime;
                            String[] splitDate = startDateMileage.split('T');
                            singleMileage.Trip_Date__c = Date.valueof(splitDate[0]);
                            System.debug('singleMileage'+singleMileage);
                            mileageset.add(singleMileage);
                        }
                        triplogRecord = new TripsLog__c();
                        triplogRecord.Contact__c = currentReimbursement.Contact_Id__c;
                        triplogRecord.Employee_Reimbursement__c = currentReimbursement.Id;
                        triplogRecord.Endpoint__c = URL.trim()+endPoint.trim();
                        triplogRecord.Response__c = String.valueOf(newResponse.getStatusCode())+' ### ' +newResponse.getStatus();
                        triplogRecord.Status__c = 'Success';
                        triplogRecord.Total_Trips__c= mileageset.size();
                        triplogRecord.Total_Mileages__c = totalmileages;
                        triplogList.add(triplogRecord);
                    }
                    else 
                    {
                        triplogRecord = new TripsLog__c();
                        triplogRecord.Contact__c = currentReimbursement.Contact_Id__c;
                        triplogRecord.Employee_Reimbursement__c = currentReimbursement.Id;
                        triplogRecord.Endpoint__c = URL.trim()+endPoint.trim();
                        triplogRecord.Response__c = String.valueOf(newResponse.getStatusCode())+' ### ' +newResponse.getStatus();
                        triplogRecord.Status__c = 'Fail';
                        triplogRecord.Total_Trips__c= mileageset.size();
                        triplogList.add(triplogRecord);
                    }
                }
                if(!triplogList.isEmpty()) 
                {
                    System.debug('triplogList'+triplogList);
                    insert triplogList;
                }
                System.debug('mileageset'+mileageset.size());
                System.debug('mileageset'+mileageset);
                if(mileageset.size() > 0)
                {
                    for(Employee_Mileage__c mil : mileageset)
                    {
                        mileagelist.add(mil);
                    }    
                }
                System.debug('mileagelist'+mileagelist.size());
                if(mileagelist.size() > 0) 
                {
                    System.debug('mileagelist'+mileagelist);
                    //insert mileagelist;
                    Schema.SObjectField f = Employee_Mileage__c.Fields.Trip_Id__c;
                    Database.UpsertResult[] result = Database.upsert(mileagelist,f, false);
                }                
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('decider is :- '+ decider);
       /* DeActivatedUsermileageTransfer transferMileageBatch = new DeActivatedUsermileageTransfer(reimbursmentIdList);
        Database.executeBatch(transferMileageBatch, 1); */
           
        //DeActivatedUsermileageTransfer transferMileageBatch = new DeActivatedUsermileageTransfer();
        if(!Test.isRunningTest() && decider==0) {
            DeActivatedUsermileageTransfer transferMileageBatch = new DeActivatedUsermileageTransfer();
            Database.executeBatch(transferMileageBatch, 1);
        }
        else if(!Test.isRunningTest() && decider==1) {
            DeActivatedUsermileageTransfer transferMileageBatch = new DeActivatedUsermileageTransfer(deActivatedConIds);
            Database.executeBatch(transferMileageBatch, 1);
        }
        else if(!Test.isRunningTest() && decider==2) {
            DeActivatedUsermileageTransfer transferMileageBatch = new DeActivatedUsermileageTransfer(userid);
            Database.executeBatch(transferMileageBatch, 1);
        }
    }
    public static String getReimbursementMonth(List<String> last2Months)
    {       
        String editedquery = '( ';
        for(String s:last2Months)
        {
            editedquery = editedquery + '\''+s+ '\','; 
        }
        if(editedquery.endsWith(','))
        {
            editedquery = editedquery.removeEnd(',');
        }
        editedquery = editedquery+' )';
        
        return editedquery;
    }
    public static String getEditQuery()
    {
        List<String> last2Months = new List<String>();
        last2Months.add(DeActivatedUserBatch.currentMonth(-1));
        last2Months.add(DeActivatedUserBatch.currentMonth(0));
        return getReimbursementMonth(last2Months);
    }
}