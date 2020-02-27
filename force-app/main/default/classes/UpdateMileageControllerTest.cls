@isTest
public class UpdateMileageControllerTest {
    public static testMethod Void UpdateMileageConTestMethod() {
        
         TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

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
        
        Employee_Reimbursement__c erRec = new Employee_Reimbursement__c();
        erRec.Contact_Id__c = contact.Id;
        erRec.month__c = '01-2018';
        erRec.Name = contact.lastname+':'+erRec.month__c;
        erRec.Status__c = 'Pending';
        erRec.Fuel_Price__c = 2.22;
        erRec.Approved_Date__c = system.today() - 3;
        erRec.Fixed_Amount__c = 10.10;
        insert erRec;
        
        Employee_Mileage__c empMileageRec = new Employee_Mileage__c();
        empMileageRec.Contact_Email_Id__c = 'test1@test1.gmail.com';
        empMileageRec.Name = 'Test Mileage Record';
        empMileageRec.EmployeeReimbursement__c = erRec.id;
        empMileageRec.Fuel_price__c = erRec.Fuel_Price__c;
        empMileageRec.Trip_Status__c = 'Approved';
        empMileageRec.Approved_Date__c = system.today() - 1;
        insert empMileageRec;
        
        Test.startTest();
        PageReference pageRef = Page.Update_Mileages;
        pageRef.getParameters().put('Id',erRec.id);
        Test.setCurrentPage(pageRef);
        UpdateMileageController controller = new UpdateMileageController();
        controller.getMileagesList();
        for(UpdateMileageController.MileageWrapper wrapper : controller.mileageWrapper) {
            wrapper.isSelected = true;
        }
        controller.updateMileages();
        controller.setCookie();
        controller.Beginning();
        controller.Previous();
        controller.Next();
        controller.End();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.getTotal_size();
        controller.getPageNumber();
        controller.getTotalPages();
        Test.stopTest();
    }
}