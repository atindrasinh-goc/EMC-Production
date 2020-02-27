global class GetTripfromTriplogBatchClass implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    
    public String query;
    public String TripStatus; 
    public Integer constructor;
    public Id accId;
    public List<Id> contactIds;  
    /*global GetTripfromTriplogBatchClass() 
    {
         constructor=1;
         TripStatus='U';
         query = 'Select id from contact limit 1';
    }*/
    global GetTripfromTriplogBatchClass(String trips)
    {
        List<String> obj_accountnames = new List<String>();
       
        String querybuilding ='';
        if(System.Label.TripstobeLogged!=null)
        {
            if(System.Label.TripstobeLogged.contains(','))
            {
                obj_accountnames= System.Label.TripstobeLogged.split(',');
            }
            Integer i=0;    
            for(String s:obj_accountnames)
            {
                s = s.trim();
                if(s.contains(','))
                {
                    s = s.replace(',','');
                }
                if(i==0)
                {
                    querybuilding = ' ( Account.Name = \''+s+'\'';    
                }
                else
                {
                    querybuilding = querybuilding+ ' OR '+ 'Account.Name = \''+s+'\'';
                }        
                i++;
            }
            querybuilding = querybuilding+' ) AND ';
              
        }
        constructor=2;
        //TripStatus = 'U';
        TripStatus = trips;
        if(Test.isRunningTest()) 
        {
            query = 'SELECT Id, Name,Account.Name, External_Email__c, Email, Account.Triplog_API__c FROM Contact WHERE External_Email__c = \'minkesh.patel1478@gmail.com\' LIMIT 1';
        } 
        else 
        {
            query = 'SELECT Id, Name,Account.Name, External_Email__c, Email, Account.Triplog_API__c FROM Contact WHERE '+querybuilding+' (Deactivated_Date__c = NULL OR Deactivated_Date__c >= LAST_N_DAYS:90) AND Account.isUsingTriplog__c = true AND (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c = \'Driver\' OR Role__c = \'Driver/Manager\')';
        }
    }
     global GetTripfromTriplogBatchClass(ID accountId, String trips)
    {
       
        String querybuilding ='';
        querybuilding = ' ( AccountId = \''+accountId+'\') AND ';
              
        //TripStatus = 'U';
        TripStatus = trips;
        if(Test.isRunningTest()) 
        {
            query = 'SELECT Id, Name,Account.Name, External_Email__c, Email, Account.Triplog_API__c FROM Contact WHERE External_Email__c = \'minkesh.patel1478@gmail.com\' LIMIT 1';
        } 
        else 
        {
            query = 'SELECT Id, Name,Account.Name, External_Email__c, Email, Account.Triplog_API__c FROM Contact WHERE '+querybuilding+' (Deactivated_Date__c = NULL OR Deactivated_Date__c >= LAST_N_DAYS:90) AND Account.isUsingTriplog__c = true AND (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c = \'Driver\' OR Role__c = \'Driver/Manager\')';
        }
    }
   /* global GetTripfromTriplogBatchClass(Id accId, String TripStatus)
    {
         constructor=3;
         accId = accId;         
         TripStatus = TripStatus;
         query = 'Select id from contact limit 1';
    } 
    global GetTripfromTriplogBatchClass(List<Id> contactIds, String TripStatus)
    {
         constructor=4;
         contactIds = new List<Id>();
         contactIds = contactIds;
         TripStatus = TripStatus;
         query = 'Select id from contact limit 1';
    }*/   
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        Map<String,Employee_Reimbursement__c> contactEmployeeReimbursementMap= new Map<String,Employee_Reimbursement__c>();
        Map<String,List<Employee_Mileage__c>> contactEmployeeMileagesMap = new Map<String,List<Employee_Mileage__c>>();
        Map<String,Employee_Reimbursement__c> contactgetfuelpriceMap= new Map<String,Employee_Reimbursement__c>();
        List<String> obj_month = new List<String>();
        List<String> obj_monthformileages = new List<String>();
        String lastMonth='';
       // Integer lastMonth,lastYear;
        String lastMonthDate;
        String lastdateofmonth;
        List<String> contactIdList = new List<String>();

        for(Contact currentContact : (List<Contact>) scope)
        {
            contactIdList.add(currentContact.id);
        }
        Get_Trip_Date_Settings__c rep = Get_Trip_Date_Settings__c.getInstance('Date Settings');
        if(rep!=null)
        {
            lastMonthDate = rep.Start_Date__c;
            lastdateofmonth = rep.End_Date__c;
            
        }
        else
        {
            /*lastMonthDate = Date.Today().addMonths(-1);
            lastMonth = lastMonthDate.Month();
            lastYear = lastMonthDate.Year();
            firstDateOfLastMonth = String.valueOf(lastMonthDate.toStartOfMonth());
            LastDateOfLastMonth = String.valueOf(lastMonthDate.toStartOfMonth().addDays(date.daysInMonth(Integer.valueOf(lastYear), Integer.valueOf(lastMonth))));*/
            
        }
        /*if(System.Label.reimbursements.contains(','))
        {
          obj_month = System.Label.reimbursements.split(',');
        }*/
        obj_month.add(System.Label.reimbursement);
        obj_monthformileages.add(getLastMonthValue(-1));       
        
//contactEmployeeMileagesMap
        for(Employee_Reimbursement__c empReim : [SELECT Id,Contact_Id__c, Total_Mileage_WithOut_Previous__c, Contact_Id__r.Monthly_Mileage_Limit__c,Contact_Email__c,Month__c,Fuel_price__c, MPG__c, Maintenance_and_Tires__c FROM Employee_Reimbursement__c WHERE month__c =: obj_monthformileages AND Contact_Id__c IN: contactIdList]) 
        {
            contactEmployeeReimbursementMap.put(empReim.Contact_Email__c+'-'+empReim.Month__c,empReim);            
        }
        for(Employee_Reimbursement__c empReim : [SELECT Id,Fuel_price__c,Contact_Email__c FROM Employee_Reimbursement__c WHERE month__c =: obj_month AND Contact_Id__c IN: contactIdList]) 
        {
            contactgetfuelpriceMap.put(empReim.Contact_Email__c,empReim);            
        }
        for(Contact con : (List<Contact>)Scope) 
        {
            Double totalmileages=0;
            if(con.Account.Triplog_API__c != null && con.Account.Triplog_API__c != '') 
            {
                if(contactEmployeeReimbursementMap.containsKey(con.External_Email__c+'-'+getLastMonthValue(-1))) 
                {
                    Employee_Reimbursement__c reim = contactEmployeeReimbursementMap.get(con.External_Email__c+'-'+getLastMonthValue(-1));
                   
                    String reimFuel = String.valueof(reim.Fuel_price__c) != null ? String.valueof(reim.Fuel_price__c):'';
                    String reimMPG = String.valueof(reim.MPG__c) != null ? String.valueof(reim.MPG__c):'';
                    String reimMAT = String.valueof(reim.Maintenance_and_Tires__c) != null ? String.valueof(reim.Maintenance_and_Tires__c):'';
                    if(reim != null && con.Email != null) 
                    {
                        GetTripCallout.GetTripCalloutForMileage(reim.id, con.Email,con.id,lastMonthDate, lastdateofmonth, reimFuel, reimMPG, reimMAT, con.Account.Triplog_API__c, TripStatus);
                    }
                }
            }
        }
    }    
    global void finish(Database.BatchableContext BC) 
    {
         
    }
    global String getLastMonthValue(Integer value) {
        String tempDate = date.today().addMonths(value).Month() + '-' + date.today().addMonths(value).Year();
        String lastMonth = tempDate.left(2);
        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
        return lastMonth;
    }
    
}