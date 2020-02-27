@isTest
public with sharing class UpdateTripIdControllerTest {
   static testmethod void myUnitTest() {
        
        Test.startTest();

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
        Account acc = TestUtilityClass.getTestSingleAccount();
       
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
        con.External_Email__c = 'test.patel14232378@gmail.com';
        con.Deactivated_Date__c = null;
        con.isCommunityUser__c = true;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 100;
        con.IsCreatedFromCommunity__c = true; 
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';
        insert con;
        
		PageReference pageRef = Page.UpdateTripId;	
		
		pageRef.getParameters().put('Id',String.valueOf(acc.Id)); 
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.standardController(acc);		
		UpdateTripIdController udpateTrip = new UpdateTripIdController(sc);
        udpateTrip.backMethod();
        udpateTrip.tripUserUpdatebatch();

        Test.StopTest();
   }
   static testmethod void myUnitTest2() {
        
        Test.startTest();

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
        List<Account> accList = TestUtilityClass.getTestMultipleAccount();
       
        //Insert Contact data 
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = accList[0].Id;
        con.MailingStreet = 'Test Street';
        con.MailingCity = 'Test City';
        con.MailingState = 'ON';
        con.MailingPostalCode = '123';
        con.MailingCountry = 'USA';
        con.Phone = '1232434445';
        con.External_Email__c = 'test.patel14232378@gmail.com';
        con.Deactivated_Date__c = Null;
        con.isCommunityUser__c = True;
        con.Role__c = 'Driver';
        con.Monthly_Mileage_Limit__c = 100;
        con.IsCreatedFromCommunity__c = true; 
        con.Vehicle_Type__c  = '2019 Full-Size Sedan';
        insert con;

        Test.SetMock(HttpCalloutMock.class, new TriplogUserIdUpdateBatchTestMock());   
        
		PageReference pageRef = Page.UpdateTripId;	
		
		pageRef.getParameters().put('Id',String.valueOf(accList[0].Id)); 
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.standardController(accList[0]);		
		UpdateTripIdController udpateTrip = new UpdateTripIdController(sc);
        udpateTrip.backMethod();
       

        Test.StopTest();
   }
}