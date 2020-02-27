@isTest
public class RG_AutoApprovedEmailClassTest {
    public static testmethod void approvedEmailTestMethod() {

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'RG_AutoApprovedEmailClass';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        SendEmail__c customSetting2 =  new SendEmail__c();
        customSetting2.Name = 'Send Email For Compliance';
        customSetting2.Send_email_from_code__c= true;
        insert customSetting2;

        SendEmailToMe__c  objSendEmailToMe = new SendEmailToMe__c();
        objSendEmailToMe.Name = 'RG_AutoApprovedEmailClass';
        objSendEmailToMe.Send_email_to_me__c = true;
        insert objSendEmailToMe;

        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;
        
        Account portalAccount = new Account(
            Name = 'Excelligence Learning Corporation',Enable_Email_For_Managers__c = true);
        insert portalAccount;

        List<Id> conList = new List<Id>();
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount.Id,
        Email = 'test_Admin1@test089.com',
        External_Email__c = 'test_Admin1@test089.com',
        Fixed_Amount__c = 5000,
        Maintenance_and_Tires__c = 2000,
        Vehicle2Odometer__c = 150,
        Vehicle1Odometer__c = 120,
        MailingStreet = 'testMailingCity',
        MPG__c = 12,
        Monthly_Mileage_Limit__c = 400,
        Vehicle_Type__c = 'TestVechleType',
        Role__c = 'Admin',
        IsCommunityUser__c = true
        );
        insert contact1;
        conList.add(contact1.Id);
        
        Contact con = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount.Id,
        Email = 'test_manager@test089.com',
        External_Email__c = 'test_manager@test089.com',
        Fixed_Amount__c = 5000,
        Maintenance_and_Tires__c = 2000,
        Vehicle2Odometer__c = 150,
        Vehicle1Odometer__c = 120,
        MailingStreet = 'testMailingCity',
        MPG__c = 12,
        Monthly_Mileage_Limit__c = 200.00,
        Vehicle_Type__c = 'TestVechleType',
        Role__c = 'Manager',
        Manager__c = contact1.Id,
        IsCommunityUser__c = true
        );
        insert con;
        conList.add(con.Id);
        
        Contact co = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount.Id,
        Email = 'test_driver@test089.com',
        External_Email__c = 'test_driver@test089.com',
        Fixed_Amount__c = 5000,
        Maintenance_and_Tires__c = 2000,
        Vehicle2Odometer__c = 150,
        Vehicle1Odometer__c = 120,
        MailingStreet = 'testMailingCity',
        MPG__c = 12,
        Vehicle_Type__c = 'TestVechleType',
        Role__c = 'Driver',
        Manager__c = con.Id,
        IsCommunityUser__c = true
        );
        insert co;
        conList.add(co.Id);
        
        List<User> user = [SELECT Id, Name, Email, Contact.External_Email__c FROM User WHERE ContactId =: conList];
    
        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = con.Id;
        er.month__c = getLastMonthValue(-1);
        er.Name = contact.lastname+':'+er.month__c;
        er.Status__c = 'Pending';
        er.Fuel_Price__c = 1;  //String.valueof(er.Fuel_Price__c); // 
        er.MPG__c = 10.00;
        er.Maintenance_and_Tires__c = 24;//String.valueof(er.Maintenance_and_Tires__c);
        er.Fuel_Price__c = 1;
        er.MPG__c = 10;
        er.Maintenance_and_Tires__c = 10;
        er.Fixed_Amount__c = 10.10;
        er.Triplog_Status__c = 'U';
        insert er;
        
        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.Contact_Email_Id__c = 'test@test.gmail.com';
        emp.Name = 'Test Mileage Record';
        emp.Mileage__c = 150.00;
        emp.EmployeeReimbursement__c = er.id;
        insert emp;
        
        Test.startTest();
            System.runAs(user[0]) {
                RG_AutoApprovedEmailClass appEmail = new RG_AutoApprovedEmailClass();
                Database.executeBatch(appEmail, 1);
            }
        Test.stopTest();
    }
    public static String getLastMonthValue(Integer value) {
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