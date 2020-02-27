/*
***************************************************
Description : Test calss for UpdateEmpReimFuelPrice
***************************************************
*/
@isTest
public class UpdateEmpReimFuelPriceTest {
    public static testMethod Void updateFuelPriceTestMethod() {

        Account account = new Account();
        account.name = 'Test Account';
        insert account;
           
        Contact contact = new Contact();
        contact.lastname = 'Test Contact';
        contact.AccountId = account.Id;
        contact.External_Email__c = 'test@test.com';
        contact.Fixed_Amount__c = 0.0;
        contact.MailingState = 'CA';
        contact.MailingCity = 'Canyon';
        insert contact;
        
        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = contact.Id;
        er.month__c = '02-2018';
        er.Name = contact.lastname+':'+er.month__c;
        er.Status__c = 'Pending';
        er.Fuel_Price__c = null;
        er.MPG__c = 10;
        er.Maintenance_and_Tires__c = 24;
        er.Fixed_Amount__c = 10.10;
        insert er;
        
        Gas_Prices__c gas = new Gas_Prices__c();
        gas.City__c = 'Canyon';
        gas.State__c = 'CA';
        gas.Fuel_Price__c = 3.33;
        gas.Month_Year__c = date.newInstance(2018,02,01);
        insert gas;
        
        Test.startTest();
        UpdateEmpReimFuelPrice.updateFuelPrice(er.month__c);
        Test.stopTest();
    }
}