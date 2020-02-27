global class GetTripCallout {

    public static final String URL = System.Label.Triplog_URL_For_Trips;//'https://triplogmileage.com/web/api/trips?';
    public static final String changeURL = System.Label.Triplog_URL_For_TripStatus;//'https://triplogmileage.com/web/api/tripStatus';
    public static HttpRequest req, putReq;
    public static HttpResponse res, putRes;
    public static Http h,putHTTP;
    public static TripLogJSONClass.TripLogJSONClassInner tripLog;
    public static String body, apiToken;
    public static Set<Integer> trip_IDs;
    public static String  finalstr;

    webservice static void GetTripCalloutForMileage(ID empReID, String contactEmail, ID contactid, String priMin, String priMax, String fuel, String mpg, String maintenansAndTires, String apiToken, String tripStatus) 
    {
        System.debug(tripStatus);
        List<Tripslog__c> obj_Tripslog_list = new List<Tripslog__c>();
        Integer sizeoftrips=0;        
        String endPoint;
        finalstr ='';
        List<Employee_Mileage__c> empList = new List<Employee_Mileage__c>();
        Set<Employee_Mileage__c> empSet = new Set<Employee_Mileage__c>();
        List<Employee_Mileage__c> result = new List<Employee_Mileage__c>();
        Double totalmileages =0;
        Employee_Mileage__c emp;        
        h = new Http();
        req = new HttpRequest();
        endPoint = 'startDate='+priMin+'&userEmail='+contactEmail+'&endDate='+priMax+'&status='+tripStatus+'&activity=Business';
        req.setEndpoint(URL.trim()+endPoint);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'apikey ' + apiToken);
        res = h.send(req);

            trip_IDs = new Set<Integer>();
            if(res.getStatusCode() == 200) 
            {                
                tripLog = TripLogJSONClass.parse(res.getBody());
                List<TripLogJSONClass.Trips> listTrips = tripLog.trips;
                
                /**** Create Employee Mileage Record ****/
                for(TripLogJSONClass.Trips lt : listTrips) 
                {   
                    emp = new Employee_Mileage__c();
                    emp.Name = 'Test ';
                    emp.Trip_Status__c = StaticValues.noApprovedYet;
                    emp.Trip_Id__c = lt.id;
                    emp.Mileage__c = lt.mileage;
                    if(emp.Mileage__c == null || emp.Mileage__c == 0) {
                        emp.Trip_Status__c = 'Approved';
                        emp.Approved_Date__c = System.Today();
                    }
                    emp.EmployeeReimbursement__c = empReID;
                    emp.Contact_Email_Id__c = contactEmail;
                    //Datetime str  = Datetime.valueOf(lt.startTime);
                    //Datetime str1  = Datetime.valueOf(lt.endTime);
                    if(lt.startTime != null && lt.startTime != '') {
                        string dateda = lt.startTime;
                        dateda = dateda.replace(':','-');
                        dateda = dateda.replace('T','-');
                        DateTime myDateTime = DateTime.newInstance(integer.valueof(dateda.split('-')[0]), integer.valueof(dateda.split('-')[1]), integer.valueof(dateda.split('-')[2]), integer.valueof(dateda.split('-')[3]), integer.valueof(dateda.split('-')[4]), integer.valueof(dateda.split('-')[5].removeEnd('.000Z')));
                        emp.StartTime__c = myDateTime;
                        emp.Day_Of_Week__c = myDateTime.format('EEEE');
                    } else {
                        emp.StartTime__c = null;
                    }
                    if(lt.endTime != null && lt.endTime != '') {
                       // emp.EndTime__c = str1;
                        string dateda = lt.endTime;
                        dateda = dateda.replace(':','-');
                        dateda = dateda.replace('T','-');
                        DateTime myDateTime = DateTime.newInstance(integer.valueof(dateda.split('-')[0]), integer.valueof(dateda.split('-')[1]), integer.valueof(dateda.split('-')[2]), integer.valueof(dateda.split('-')[3]), integer.valueof(dateda.split('-')[4]), integer.valueof(dateda.split('-')[5].removeEnd('.000Z')));
                        emp.EndTime__c = myDateTime;
                    } else {
                        emp.EndTime__c = null;
                    }
                    if(fuel != null && fuel != '') {
                        emp.Fuel_price__c = decimal.valueof(fuel);
                    } else {
                        emp.Fuel_price__c = null;
                    }
                    if(mpg != null && mpg != '') {
                        emp.MPG__c = decimal.valueof(mpg);
                    } else {
                        emp.MPG__c = null;
                    }
                    if(maintenansAndTires != null && maintenansAndTires != '') {
                        emp.Maintenance_and_Tires__c = decimal.valueof(maintenansAndTires);
                    } else {
                        emp.Maintenance_and_Tires__c = null;
                    }
                    if(lt.fromLocation != null && lt.fromLocation.display != null) {
                        emp.Trip_Origin__c = lt.fromLocation.display;
                        if(lt.fromLocation.display.contains(','))
                        {
                           emp.Origin_Name__c = (lt.fromLocation.display.split(','))[0];  
                        }
                        else if(lt.fromLocation.display.contains(' '))
                        {
                            emp.Origin_Name__c = (lt.fromLocation.display.split(' '))[0];
                        }
                        else
                        {
                           emp.Origin_Name__c =  lt.fromLocation.display;
                        }
                    }
                    if(lt.toLocation != null && lt.toLocation.display != null) {
                        emp.Trip_Destination__c = lt.toLocation.display;
                        if(lt.toLocation.display.contains(','))
                        {
                           emp.Destination_Name__c = (lt.toLocation.display.split(','))[0];  
                        }
                        else if(lt.toLocation.display.contains(' '))
                        {
                            emp.Destination_Name__c = (lt.toLocation.display.split(' '))[0];
                        }
                        else
                        {
                           emp.Destination_Name__c =  lt.toLocation.display;
                        }
                    }
                    if(lt.notes != null && lt.notes != '') {
                        emp.Notes__c = lt.notes;
                    } else {
                        emp.Notes__c = null;
                    }
                    if(lt.trackingMethod != null && lt.trackingMethod != '') {
                        emp.Tracing_Style__c = lt.trackingMethod;
                    } else {
                        emp.Tracing_Style__c = null;
                    }
                    String myDate = lt.startTime;
                    String[] d = myDate.split('T');
                    emp.Trip_Date__c = Date.valueof(d[0]);
                    empList.add(emp);
                    trip_IDs.add(Integer.valueOf(lt.id));
                    totalmileages = totalmileages+Double.valueOf(emp.Mileage__c);                    
                }
                if(!empList.isEmpty()) 
                {
                    SendEmailToMe__c objSendEmailToMe = SendEmailToMe__c.getValues('GetTripCallOutApprovePutCall');
                    if(objSendEmailToMe.Send_email_to_me__c == true){
                        GetTripCallout.putHTTP(apiToken,contactid,empReID); 
                    }
                   // Database.SaveResult[] insertedTrips = Database.insert(empList, false);
                    Database.UpsertResult[] insertedTrips = Database.upsert(empList,Employee_Mileage__c.Fields.Trip_Id__c, false);
                    sizeoftrips =0;
                    if(insertedTrips.size()>0)
                    {                        
                        
                        for(Database.UpsertResult srresult : insertedTrips)
                        {
                            if(srresult.isSuccess())
                            {
                                sizeoftrips++;
                            }
                        }
                    }                    
                   /* try
                    {                  
                        insert empList;
                    }
                    catch(Exception e)
                    {
                        
                    }
                    sizeoftrips = empList.size();*/
                }
                Tripslog__c obj = new Tripslog__c();
                obj.Contact__c = contactid;
                obj.Employee_Reimbursement__c = empReID;
                obj.Endpoint__c = URL.trim()+endPoint;
                obj.Response__c = String.valueOf(res.getStatusCode())+' ### ' +res.getStatus();
                obj.Status__c ='Success'; 
                obj.Total_Trips__c= sizeoftrips;
                obj.Total_Mileages__c = totalmileages;
                obj_Tripslog_list.add(obj); 
            }
            else
            {
                Tripslog__c obj = new Tripslog__c();
                obj.Contact__c = contactid;
                obj.Employee_Reimbursement__c = empReID;
                obj.Endpoint__c = URL.trim()+endPoint;
                obj.Response__c = String.valueOf(res.getStatusCode())+' ### ' +res.getStatus();
                obj.Status__c ='Fail'; 
                obj.Total_Trips__c= sizeoftrips;
                obj.Total_Mileages__c = totalmileages;
                obj_Tripslog_list.add(obj); 
            }
            if(obj_Tripslog_list.size()>0)
            {
                insert obj_Tripslog_list;
            }
       // return empList;
    }

    public static void putHTTP(String apiToken,String contactid,String empReID) {
       List<Tripslog__c> obj_Tripslog_list = new List<Tripslog__c>();
            String part = '';
            putReq = new HttpRequest();
            putHTTP = new Http();
            putRes = new HttpResponse();
            body = '{"status":"Approved","ids":[';
            for (Integer i : trip_IDs) {
                part = part + String.valueof(i) +',';
            }
            part = part.removeEnd(',');
            body = body + part +']}';
            putReq.setEndpoint(changeURL);
            putReq.setMethod('PUT');                 
            putReq.setBody(body);
            putReq.setTimeout(120000);
            putReq.setHeader('Authorization', 'apikey ' + apiToken);
            putRes = putHTTP.send(putReq);
            Tripslog__c obj = new Tripslog__c();
            obj.Body__c = body;
            obj.Contact__c = contactid;
            obj.Employee_Reimbursement__c = empReID;
            obj.Endpoint__c = changeURL;
            if(!Test.IsRunningTest())
            {
                 obj.Response__c = String.valueOf(putRes.getStatusCode())+' ######## ' +putRes.getStatus();
            }
           
            obj.Total_Trips__c= 0;
            obj.Total_Mileages__c = 0;
            
            if(putRes.getStatusCode() == 200)
            {               
                obj.Status__c ='Success';
            }
            else
            {
                obj.Status__c ='Fail';
            }
            obj_Tripslog_list.add(obj);
            if(obj_Tripslog_list.size()>0)
            {
                insert obj_Tripslog_list;
            }
            System.debug('putRes.getBody(): '+putRes.getBody());
    }
}