@isTest
public class RosterControllerTest {
    public static testmethod void RosterControllerTestMethod(){
       
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();
        RecordUtilityClass.exceptionEmail();

       /* Address__c obj_Address = new Address__c();
        obj_Address.State__c ='Alabama';
        obj_Address.City__c ='Abbeville';
        obj_Address.Abbreviation__c ='AL';
        obj_Address.ZIP_Code__c ='36310'; 
        
        List<Address__c> obj_list_Address = new List<Address__c>();
        obj_list_Address.add(obj_Address);
        insert obj_list_Address;*/
        
        Vehicle_URL_Mapping__c veh2 = new Vehicle_URL_Mapping__c();
        veh2.URL__c = 'https://cdn3.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh2.vehicle__c = 'Dodge Charger';
        veh2.Year__c = '2020';
        insert veh2;
        
        Account obj_Account = RecordUtilityClass.buildAccount();
        obj_Account.Vehicle_Types__c ='2020 Dodge Charger';
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;
        
        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;
        
        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        Contact obj_Contact2 = obj_Driver_list[0];
        List<Contact> obj_Driver_list1 = new List<Contact>();

        for(Integer i=1;i<obj_Driver_list.size();i++)
        {
            obj_Driver_list1.add(obj_Driver_list[i]);
        }
        insert obj_Driver_list1;
        
        Contact obj_Manager_list1 = new Contact();
        obj_Manager_list1 = RecordUtilityClass.getManagerContact();

        EmployeeDetails empDetail = WrapperUtils.getEmployeeDetails(obj_Driver_list1[0]);
        EmployeeDetails empDetail1 = WrapperUtils.getEmployeeDetails(obj_Contact2);
         String str = 'Employee_ID__c,Firstname,LastName,External_Email__c,' + 
                            'Vehicle_Type__c,Role__c,MailingCity,MailingState,' + 
                            'MailingPostalCode,AccountId,Activation_Date__c,Manager__c,MobilePhone, Driving_States__c\n'+
                            '1,Tesdfsdfsts,Testidfdsfsdng1,test1932434230@testing.com,' + 
                            '2020 Dodge Charger,Driver,CA,USA,' + 
                            '12834,'+obj_Account.Name+',03/03/2018,'+'Test Contact Manager0'+',34323,CA;\n' +
                            '2,Secdfsdfond,Testindfdfsg1,atfdgdfg324ssddsfsd32423424h.goc@gmail.com,' + 
                            '2020 Dodge Charger,Driver,CA,USA,' + 
                            '12586,'+obj_Account.Name+',03/03/2018,'+'Test Contact Manager0'+'34323,CA;';
            Blob csvFileBody = Blob.valueOf(str);
            String csvAsString = csvFileBody.toString();

        empDetail.FirstName = 'test';
        empDetail.activationDate = '12/12/2018';
        List<EmployeeDetails> obj_list_EmployeeDetails = new List<EmployeeDetails>();
        obj_list_EmployeeDetails.add(empDetail);
        Test.startTest();
        Test.setCurrentPage(Page.roster);
        String conId = ApexPages.currentPage().getParameters().put('id',obj_admincontact.Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_Account.Id);
        RosterController ros = new RosterController();
        RosterController.getAccountid();
        RosterController.getContactid();
        RosterController.getRedirected();
        RosterController.editInlineNewEmployee(JSON.serialize(obj_list_EmployeeDetails),String.valueOf(obj_Account.Id),String.valueOf(obj_admincontact.Id));
        RosterController.getAllManagers();
        RosterController.getlistAllEmployees(obj_Account.Id,obj_admincontact.Id);
        RosterController.getRoles();
        RosterController.getDrivingStates();
        //RosterController.getUser(obj_admincontact.Id);
        RosterController.sendExceptionMails('Insert Failed','1');
        RosterController.getCustomExceptionMessage('1');
        RosterController.readFromFile(csvAsString,accId);
        RosterController.editEmployeeDetails(obj_Manager_list[0].Id);
        RosterController.getContactByEmailAddress(obj_Manager_list[0].External_Email__c);
        RosterController.manageEmployee(JSON.serialize(obj_list_EmployeeDetails),String.valueOf(obj_Account.id),String.valueOf(obj_admincontact.Id));
        RosterController.getCountryStateCity('36310');
        RosterController.getCity('Abbeville','36310');
        RosterController.getPickListValuesIntoList();
               
        /*RosterController.wrapperEmployeeDetails = empDetail;
        RosterController.currentLoggedInContact = obj_admincontact;
        RosterController.csvFileBody = csvFileBody;*/
        RosterController.editInlineNewEmployee(NULL,'','');
       // RosterController.getCountryStateCity('');
       // RosterController.getCity('','');
      //  RosterController.getContactByEmailAddress('testtinghhhh@gmail.com');
        empDetail.lastname='sdhshdgsag21212';
        empDetail1.userid =NULL;
        empDetail.email ='rghgfhgf21212@gmail.com';
        System.debug('empDetail' + empDetail);
        List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
        obj_list_EmployeeDetails1.add(empDetail1);
        RosterController.manageEmployee(JSON.serialize(obj_list_EmployeeDetails1),String.valueOf(obj_Account.id),String.valueOf(obj_admincontact.Id));
        List<id> insertedContactIDList = new List<id>();
        for(Contact currentcontact:obj_Driver_list1)
        {
            insertedContactIDList.add(currentcontact.id);
        }        
        RosterController.postHTTPCreateNewUserTriplog(insertedContactIDList);
        RosterController.getExcetionTypes('System.DmlException','UPDATE FAILED',12);
        RosterController.getExcetionTypes('TypeException','UPDATE FAILED',12);
        RosterController.getExcetionTypes('QueryException','UPDATE FAILED',12);
        Test.stopTest();
    }
    public static testmethod void RosterControllerTestMethod1(){
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.createRecordsAdminDashboardController();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        Test.startTest();
        RosterController ros = new RosterController();
        RosterController.getAccountid();
        RosterController.getContactid();
        RosterController.getRedirected();    
       
        Test.stopTest();
    }
}