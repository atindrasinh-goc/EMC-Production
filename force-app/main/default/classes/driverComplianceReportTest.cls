@isTest
private class driverComplianceReportTest{
    public static testmethod void test1(){
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;
        
        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        IRS_Mileage_Rate__c mileageRateObj = new IRS_Mileage_Rate__c();
        mileageRateObj.IRS_Rate__c = 12.9;
        mileageRateObj.year__c = String.valueOf((System.today().year()));
        insert mileageRateObj;
        
        IRS_Mileage_Rate__c mileageRateObj1 = new IRS_Mileage_Rate__c();
        mileageRateObj1.IRS_Rate__c = 12.9;
        mileageRateObj1.year__c = String.valueOf((System.today().year()-1));
        insert mileageRateObj1;

        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;

        Account accs = new Account();
        accs.Name = 'Delta';
        accs.Triplog_API__c = 'test1';
        accs.isUsingTriplog__c = true;
        accs.Motor_Vehicle_Record_Check_Document__c = true;
        insert accs;

        Contact con1 = new Contact();
        con1.LastName = 'testsdfsdfs';
        con1.Triplog_UserID__c = 'test';
        con1.Deactivated_Date__c =  system.now();
        con1.isCommunityUser__c = true;
        con1.Vehicle_Type__c = '2019 Full-Size Sedan';
        con1.External_Email__c = 'test.patel143478@gmail.com';
        con1.IsDeactivated__c = false;
        con1.AccountId = accs.Id;
        con1.Role__c = 'Admin';
       
        insert con1;

        Contact con = new Contact();
        con.LastName = 'test';
        con.Triplog_UserID__c = 'test';
        con.Vehicle_Type__c = '2019 Full-Size Sedan';
        con.isCommunityUser__c = true;
        con.External_Email__c = 'test.patel1478@gmail.com';
        con.IsDeactivated__c = false;
        con.AccountId = accs.Id;
        con.Role__c = 'Driver';
        con.compliancestatus__c = 'Yes';
        insert con;

        Attachment att = new Attachment();
        att.parentID = con.Id;
        att.name = 'test';
        att.body = blob.valueOf('Test');
        insert att;

        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        //er.isDriver = true;
        er.Contact_Id__c = con.Id;
        er.month__c = '12-2018';
        er.Name = con.lastname+':system.today()';
        er.Status__c = 'Approved';
        er.Fuel_Price__c = 1; 
        er.MPG__c = 10.00;
        er.Approved_Date__c = system.Today();
        er.Maintenance_and_Tires__c = 24;
        er.MPG__c = 10;
        er.Maintenance_and_Tires__c = 10;
        er.Fixed_Amount__c = 10.10;
        er.Triplog_Status__c = 'U';
        insert er;

        Employee_Reimbursement__c er1 = new Employee_Reimbursement__c();
        er1.Contact_Id__c = con.Id;
        
        er1.month__c = '01-2019';
        er1.Name = con.lastname+':system.today()';
        er1.Status__c = 'Approved';
        er1.Fuel_Price__c = 1; 
        er1.MPG__c = 10.00;
        er1.Maintenance_and_Tires__c = 24;
        er1.MPG__c = 10;
        er1.Approved_Date__c = system.Today();
        er1.Maintenance_and_Tires__c = 10;
        er1.Fixed_Amount__c = 10.10;
        er1.Triplog_Status__c = 'U';
        insert er1;

        Employee_Reimbursement__c er2 = new Employee_Reimbursement__c();
        er2.Contact_Id__c = con.Id;
        
        er2.month__c = '09-2019';
        er2.Name = con.lastname+':system.today()';
        er2.Status__c = 'Approved';
        er2.Fuel_Price__c = 1; 
        er2.MPG__c = 10.00;
        er2.Maintenance_and_Tires__c = 24;
        er2.MPG__c = 10;
        er2.Approved_Date__c = system.Today();
        er2.Maintenance_and_Tires__c = 10;
        er2.Fixed_Amount__c = 10.10;
        er2.Triplog_Status__c = 'U';
        insert er2;

        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.Contact_Email_Id__c = 'test_Managr101@test99.com';
        emp.Name = 'Test Mileage Record';
        emp.EmployeeReimbursement__c = er.id;
        emp.Mileage__c = 10000;
        insert emp;

        Employee_Mileage__c emp1 = new Employee_Mileage__c();
        emp1.Contact_Email_Id__c = 'test_Managr101@test99.com';
        emp1.Name = 'Test Mileage Record';
        emp1.EmployeeReimbursement__c = er1.id;
        emp1.Mileage__c = 10000;
        insert emp1;

        Employee_Mileage__c emp2 = new Employee_Mileage__c();
        emp2.Contact_Email_Id__c = 'test_Managr101@test99.com';
        emp2.Name = 'Test Mileage Record';
        emp2.EmployeeReimbursement__c = er2.id;
        emp2.Mileage__c = 10000;
        insert emp2;

        Test.StartTest();
        
        ApexPages.currentPage().getParameters().put('manid', String.valueOf(con1.Id));
        ApexPages.currentPage().getParameters().put('drid', String.valueOf(con.Id));
        driverComplianceReport drivertest = new driverComplianceReport();
        drivertest.TotalActualReimbursements  = 10.10;
        drivertest.MaximumAllowable = 10.25;
        drivertest.AnnualTaxLiability = 25.10;
        drivertest.totalmileages  =29.10;
        //drivertest.complianceStatus();
        //drivertest.getComplianceContacts();
    }
}