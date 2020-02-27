@isTest
public with sharing class EmployeeReimbursementTriggerHandlerTest {
    
    public static testMethod Void employeeReimbursementTriggerHandlerTestSecondMethod() {
    TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;
        
        SendEmail__c customSetting2 =  new SendEmail__c();
        customSetting2.Name = 'Send Email For Compliance';
        customSetting2.Send_email_from_code__c= true;
        insert customSetting2;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'TestContact';
        con.AccountId = acc.Id;
        con.External_Email__c = 'test@email.com';
        con.Fixed_Amount__c = 371.28;
        con.MailingCity = 'Fremont';
        con.MailingState = 'CA';
        con.Monthly_Mileage_Limit__c = 100.00;
        insert con;
        Test.startTest();
        //List<Employee_Reimbursement__c> empList = new List<Employee_Reimbursement__c>();
        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = con.Id;
        er.Name = 'Reimbersment Test';
        er.Month__c = '09-2017';
        er.Status__c = 'Approved';
        insert er;
        
        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.EmployeeReimbursement__c = er.id;
        emp.Contact_Email_Id__c = con.External_Email__c;
        emp.Name = 'Test Mileage Record';
        emp.Trip_Status__c = StaticValues.noApprovedYet;
        emp.Rejected__c = true;
        emp.Mileage__c = 150.00;
        insert emp;
        
        //er.Status__c = 'Approved';
        //er.Approved_Date__c = system.today();
        //update er;
        Test.stopTest();
    }
}