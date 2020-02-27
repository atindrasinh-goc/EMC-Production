@isTest
public class TriplogUserIdUpdateBatchTest {
       @isTest static void myUnitTest() {
        
        //Insert Custom setting data
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;

        SendEmail__c customSetting =  new SendEmail__c();
        customSetting.Name = 'Send Email For Compliance';
        customSetting.Send_email_from_code__c= true;
        insert customSetting;

        //Insert Account data Using Utility class
        Account acc = new Account();
        
        acc.Name = 'Delta';
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'ON';
        acc.BillingPostalCode = '123';
        acc.BillingCountry = 'CA';
        acc.Type='Analyst';
        acc.isUsingTriplog__c = True;
        acc.Triplog_API__c= 'abc';        
        acc.Enable_Email_For_Managers__c = True;
        insert acc;
       
        //Insert Contact data 
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'USA';
        con.Phone = '1232434445';
        con.External_Email__c = 'test@gmail.com';
        con.Deactivated_Date__c = null;
        con.Triplog_UserID__c = null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 100;
        con.IsCreatedFromCommunity__c = true; 
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';
        insert con;

        contact con2 = new contact();
        con2.FirstName = 'Test';
        con2.LastName = 'contact2';
        con2.AccountId = acc.Id;
        con2.MailingStreet = 'Test Street';
        con2.MailingCity = 'Test City';
        con2.MailingState = 'ON';
        con2.MailingPostalCode = '123';
        con2.MailingCountry = 'USA';
        con2.Phone = '1232434445';
        con2.External_Email__c = 'test2@gmail.com';
        con2.Deactivated_Date__c = null;
        con2.Triplog_UserID__c = null;
        con2.isCommunityUser__c = True;
        con2.Role__c = 'Driver';
        con2.Monthly_Mileage_Limit__c = 100;
        con2.IsCreatedFromCommunity__c = true; 
        con2.Vehicle_Type__c  = '2019 Full-Size Sedan';
        insert con2;

        Map<String,Contact> contactMap = new Map<String,Contact>();
        for(Contact currentContact : [Select id,Name,Triplog_UserID__c,External_Email__c,Deactivated_Date__c From Contact Where Account.id =: acc.Id])
        {
            contactMap.put(currentContact.External_Email__c.toLowerCase(),currentContact);
        }
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new TriplogUserIdUpdateBatchTestMock());
        TriplogUserIdUpdateBatch batchobj = new TriplogUserIdUpdateBatch(acc.Id,acc.Triplog_API__c,contactMap);
        TriplogUserIdUpdateBatch.getTripIds(acc.Triplog_API__c);  
        batchobj.responseOfAPICall = TriplogUserIdUpdateBatch.getTripIds(acc.Triplog_API__c);  
         
        Database.executeBatch(batchobj,10);
        Test.StopTest();
   }
}