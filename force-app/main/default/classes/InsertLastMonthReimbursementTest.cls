@istest
public class InsertLastMonthReimbursementTest {
    
    public static testmethod void testMethod1(){
        Account acc = TestUtilityClass.getTestSingleAccount();
        
        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
        
        IRS_Mileage_Rate__c objIRS = new IRS_Mileage_Rate__c();
        objIRS.IRS_Rate__c = 0.580;
        objIRS.year__c = '2019';
        insert objIRS;
        
        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'CA';
        con.Phone = '1232434445';
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 0; 
        con.compliancestatus__c ='Yes';
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';       
        insert con;
        
        Batch_Configuration__c bat = TestUtilityClass.getTestBatchConfig();
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        Gas_Prices__c gas = TestUtilityClass.getTestGasPrices();
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);
        RG_InsertLastMonthReimbursement Ins = new RG_InsertLastMonthReimbursement();
        Database.executeBatch(Ins, 1);
    }

     public static testmethod void testMethod2(){
        Account acc = TestUtilityClass.getTestSingleAccount();
        
        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

         Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
        
        IRS_Mileage_Rate__c objIRS = new IRS_Mileage_Rate__c();
        objIRS.IRS_Rate__c = 0.580;
        objIRS.year__c = '2019';
        insert objIRS;
        
        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'CA';
        con.Phone = '1232434445';
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 0; 
        con.compliancestatus__c ='Yes';
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';       
        insert con;
        
        Batch_Configuration__c bat = TestUtilityClass.getTestBatchConfig();
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        Gas_Prices__c gas = TestUtilityClass.getTestGasPrices();
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);     
        String month = date.today().addMonths(-1).month() + '-'+ date.today().addMonths(-1).year();
        RG_InsertLastMonthReimbursement Ins = new RG_InsertLastMonthReimbursement(month);
        Database.executeBatch(Ins, 1);
    }

    public static testmethod void testMethod3(){
        Account acc = TestUtilityClass.getTestSingleAccount();
        
        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

         Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
        
        IRS_Mileage_Rate__c objIRS = new IRS_Mileage_Rate__c();
        objIRS.IRS_Rate__c = 0.580;
        objIRS.year__c = '2019';
        insert objIRS;
        
        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'CA';
        con.Phone = '1232434445';
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 0; 
        con.compliancestatus__c ='Yes';
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';       
        insert con;
        
        Batch_Configuration__c bat = TestUtilityClass.getTestBatchConfig();
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        Gas_Prices__c gas = TestUtilityClass.getTestGasPrices();
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);     
        String month = date.today().addMonths(-1).month() + '-'+ date.today().addMonths(-1).year();
        RG_InsertLastMonthReimbursement Ins = new RG_InsertLastMonthReimbursement(month,'test123@gmail.com,test23@gmail.com');
        Database.executeBatch(Ins, 1);
    }

    public static testmethod void testMethod4(){
        Account acc = TestUtilityClass.getTestSingleAccount();
        
        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

         Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
        
        IRS_Mileage_Rate__c objIRS = new IRS_Mileage_Rate__c();
        objIRS.IRS_Rate__c = 0.580;
        objIRS.year__c = '2019';
        insert objIRS;
        
        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'CA';
        con.Phone = '1232434445';
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 0; 
        con.compliancestatus__c ='Yes';
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';       
        insert con;
        
        Batch_Configuration__c bat = TestUtilityClass.getTestBatchConfig();
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        Gas_Prices__c gas = TestUtilityClass.getTestGasPrices();
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);     
        String month = date.today().addMonths(-1).month() + '-'+ date.today().addMonths(-1).year();
        RG_InsertLastMonthReimbursement Ins = new RG_InsertLastMonthReimbursement(month,'test123@gmail.com');
        Database.executeBatch(Ins, 1);

        scheduledRG_InsertLastMonthReimbursement m = new scheduledRG_InsertLastMonthReimbursement();
        String sch = '  0 0 6 2 1/1 ? *';        
        String jobID = system.schedule('Checking Missing Fuel Price for '+month, sch, m);
    }
    
}