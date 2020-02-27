@isTest
public Class MappingGasPriceTriggerTest{

    public static testmethod void test1(){
    
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'TestContact';
        con.AccountId = acc.Id;
        con.External_Email__c = 'test@email.com';
        con.Fixed_Amount__c = 371.28;
        con.MailingCity = 'Abilene';
        con.MailingState = 'TX';
        con.Driving_States__c = 'TX';
        con.Time_Zone__c = 'America/Chicago';
        con.Monthly_Mileage_Limit__c = 100.00;
        insert con;
        
        list<Gas_Prices__c> gaslist = new  list<Gas_Prices__c>();
        for(integer i = 0; i < 5; i++) 
        {
            gaslist.add(new  Gas_Prices__c(City__c = 'Delhi' + i, Fuel_Price__c = 65, Month_Year__c = date.today().adddays(-i), State__c = 't' + i));
        }
        Insert gaslist;
        
        
         

        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = con.Id;
        er.Name = 'Reimbersment Test';
        er.Month__c = '09-2017';
        er.Status__c = 'Pending';
        er.Fuel_Price__c = 10.00;
        insert er;

        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.EmployeeReimbursement__c = er.id;
        emp.Contact_Email_Id__c = con.External_Email__c;
        emp.Name = 'Test Mileage Record';
        emp.Trip_Status__c = StaticValues.noApprovedYet;
        emp.Mileage__c = 10.00;
        emp.Fuel_price__c = 10.00;
        emp.StartTime__c = system.now();
        emp.EndTime__c =  system.now();
        emp.Trip_Date__c =date.today().adddays(-1);
        insert emp;
        
        Employee_Reimbursement__c er1 = new Employee_Reimbursement__c();
        er1.Contact_Id__c = con.Id;
        er1.Name = 'Reimbersment Test';
        er1.Month__c = '09-2017';
        er1.Status__c = 'Pending';
        insert er1;
        
        Employee_Mileage__c emp1 = new Employee_Mileage__c();
        emp1.EmployeeReimbursement__c = er1.id;
        emp1.Contact_Email_Id__c = con.External_Email__c;
        emp1.Name = 'Test Mileage Record';
        emp1.Trip_Status__c = StaticValues.noApprovedYet;
        emp1.Mileage__c = 10.00;
        emp1.StartTime__c = system.now();
        emp1.EndTime__c =  system.now();
        emp1.Trip_Date__c =date.today().adddays(-1);
        insert emp1;
        
        emp1.StartTime__c = emp1.StartTime__c.addSeconds(4);
        update emp1;
    }
}