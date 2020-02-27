@isTest
public with sharing class LoginRedirection_Test {

	public static testmethod void utilMethod1()
	{
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
        
		Account obj_account = new Account();
    	obj_account.name='Test';
    	insert obj_account;

    	Contact obj_contact = new Contact();
        obj_contact.Vehicle_Type__c = '2019 Full-Size Sedan';
        obj_contact.firstname='test';
        obj_contact.lastname='testlastname2';
        obj_contact.email = 'testlastname2@gmail.com';
        obj_contact.External_Email__c = 'testlastname2@gmail.com';
        obj_contact.Role__c ='Manager';
        obj_contact.Accountid=obj_account.id;        
        obj_contact.isCommunityUser__c = true;
        obj_contact.IsCreatedFromCommunity__c = true;
        insert obj_contact;


    	//Test.setCurrentPage(Page.loginredirector);
        
        
        List<User> u = [Select id from User WHERE Profile.name='Customer Community Login User - Manager' and IsActive = true limit 1];
        Test.startTest();
        System.runAs(u[0]) {
            /*List<profile> obj_profile = [select id from profile where name='Customer Community Login User - Manager'];
        u[0].profileid =obj_profile[0].id;
        update u; */
            Contact obj = [select id from contact limit 1];
            ApexPages.currentPage().getParameters().put('id',obj.Id);
            LoginRedirection obj_LoginRedirection = new LoginRedirection();
            obj_LoginRedirection.redirectOnPage();
              
          }
    Test.stopTest();
	}
	public static testmethod void utilMethod2()
    {
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;
       
        Account obj_account = new Account();
        obj_account.name='Test';
        insert obj_account;

        Contact obj_contact = new Contact();
        obj_contact.Vehicle_Type__c = '2019 Full-Size Sedan';
        obj_contact.firstname='test';
        obj_contact.lastname='testlastname2';
        obj_contact.email = 'testlastname2@gmail.com';
        obj_contact.External_Email__c = 'testlastname2@gmail.com';
        obj_contact.Role__c ='Admin';
        obj_contact.Accountid=obj_account.id;        
        obj_contact.isCommunityUser__c = true;
        obj_contact.IsCreatedFromCommunity__c = true;
        insert obj_contact;


        //Test.setCurrentPage(Page.loginredirector);
        
         Test.startTest();
       List<User> u = [Select id from User WHERE Profile.name='Customer Community Login User - Super Manager' and IsActive = true limit 1];
        /*List<profile> obj_profile = [select id from profile where name='Customer Community Login User - Super Manager'];
        u[0].profileid =obj_profile[0].id;
        update u; */
        System.runAs(u[0]) {
            
            Contact obj = [select id from contact limit 1];
            ApexPages.currentPage().getParameters().put('id',obj.Id);
            LoginRedirection obj_LoginRedirection = new LoginRedirection();
            obj_LoginRedirection.redirectOnPage();
              
          }
    Test.stopTest();
    }
    public static testmethod void utilMethod3()
    {
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;

        Test.startTest();

        Account obj_account = new Account();
        obj_account.name='Test';
        insert obj_account;

        Contact obj_contact = new Contact();
        obj_contact.Vehicle_Type__c = '2019 Full-Size Sedan';
        obj_contact.firstname='test';
        obj_contact.lastname='testlastname2';
        obj_contact.email = 'testlastname2@gmail.com';
        obj_contact.External_Email__c = 'testlastname2@gmail.com';
        obj_contact.Role__c ='Driver/Manager';
        obj_contact.Accountid=obj_account.id;        
        obj_contact.isCommunityUser__c = true;
        obj_contact.IsCreatedFromCommunity__c = true;
        insert obj_contact;


        //Test.setCurrentPage(Page.loginredirector);
        
        
        List<User> u = [Select id from User WHERE Profile.name='Customer Community Login User - Manager/Driver' and IsActive = true limit 1];
        
        System.runAs(u[0]) {
            
            Contact obj = [select id from contact limit 1];
            ApexPages.currentPage().getParameters().put('id',obj.Id);
            LoginRedirection obj_LoginRedirection = new LoginRedirection();
            obj_LoginRedirection.redirectOnPage();
              
          }
    Test.stopTest();
    }
    public static testmethod void utilMethod4()
    {
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c =  'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;

        Test.startTest();
        Account obj_account = new Account();
        obj_account.name='Test';
        insert obj_account;

        Contact obj_contact = new Contact();
        obj_contact.Vehicle_Type__c = '2019 Full-Size Sedan';
        obj_contact.firstname='test';
        obj_contact.lastname='testlastname2';
        obj_contact.email = 'testlastname2@gmail.com';
        obj_contact.External_Email__c = 'testlastname2@gmail.com';
        obj_contact.Role__c ='Driver';
        obj_contact.Accountid=obj_account.id;        
        obj_contact.isCommunityUser__c = true;
        obj_contact.IsCreatedFromCommunity__c = true;
        insert obj_contact;


        //Test.setCurrentPage(Page.loginredirector);
        
        
        List<User> u = [Select id from User where profile.name='Customer Community Login User - Driver' and IsActive = true limit 1];
        
        System.runAs(u[0]) {
            
            Contact obj = [select id from contact limit 1];
            ApexPages.currentPage().getParameters().put('id',obj.Id);
            LoginRedirection obj_LoginRedirection = new LoginRedirection();
            obj_LoginRedirection.redirectOnPage();
              
          }
    Test.stopTest();
    }
}