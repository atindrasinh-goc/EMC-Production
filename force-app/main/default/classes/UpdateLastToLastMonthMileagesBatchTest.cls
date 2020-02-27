@istest
public class UpdateLastToLastMonthMileagesBatchTest {
    
    public static testmethod void testMethod3(){
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        Account acc = new Account();
        
        acc.Name = 'Community Account';
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'ON';
        acc.BillingPostalCode = '123';
        acc.BillingCountry = 'CA';
        acc.Type='Analyst';
        acc.isUsingTriplog__c = True;
        acc.Triplog_API__c= 'a';
        acc.Enable_Email_For_Managers__c = True;
        
        insert acc;
        
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
        
        insert con;
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);
        Contact cont =TestUtilityClass.getTestSingleContact2(acc);
        Employee_Reimbursement__c empr = TestUtilityClass.getTestEmployeeReimbursement3(cont);
        Employee_Mileage__c empMil = TestUtilityClass.getTestEmployeeMileage(emp);
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        UpdateLastToLastMonthMileagesBatch last = new UpdateLastToLastMonthMileagesBatch();
        Database.executeBatch(last, 1);
    } 
     public static testmethod void testMethod4(){
      TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;
        
        Account acc = TestUtilityClass.getTestSingleAccount();
        Contact con = TestUtilityClass.getTestSingleContact(acc);
        Employee_Reimbursement__c emp = TestUtilityClass.getTestEmployeeReimbursement(con);
        Contact cont =TestUtilityClass.getTestSingleContact2(acc);
         Employee_Reimbursement__c empr = TestUtilityClass.getTestEmployeeReimbursement3(cont);
        Employee_Mileage__c empMil = TestUtilityClass.getTestEmployeeMileage(emp);
        Batch_Setup__c batc = TestUtilityClass.getTestBatchSetup();
        UpdateLastToLastMonthMileagesBatch last = new UpdateLastToLastMonthMileagesBatch();
        Database.executeBatch(last, 1);
    } 
}