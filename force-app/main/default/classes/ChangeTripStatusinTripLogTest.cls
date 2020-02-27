@isTest
public with sharing class ChangeTripStatusinTripLogTest {
   
    public static testmethod void method1() {

        SendEmailToMe__c sendemailme = new SendEmailToMe__c();
        sendemailme.name = 'ChangeTripStatusinTripLog';
        sendemailme.Send_email_to_me__c = true;
        insert sendemailme;

        RecordUtilityClass.createRecordsAdminDashboardController();
            Test.setMock(HttpCalloutMock.class, new ChangeTripStatusinTripLogTestMock());
            Account currentAccount = RecordUtilityClass.getAccount(); // retriving the Accounts EmployeeMileagesForCalculation
            Contact currentAdmin = RecordUtilityClass.getAdminContact(); // Retriving the Admin with limit 1
            Contact selectedDriver = RecordUtilityClass.getDriverContact();
            List<String> approvedIdList = new List<String>();
            List<String> rejectedIdList = new List<String>();   
            List<Employee_Reimbursement__c> empReimbursementList = RecordUtilityClass.getEmployee_Reimbursement(currentAccount.id);
            List<EmployeeReimbursementDetailsAdmin> selectedReimList = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(empReimbursementList);
            List<Employee_Mileage__c> driverMileagesList =  RecordUtilityClass.getMileagesList();
            driverMileagesList[0].Trip_Id__c = 104976448;
            update driverMileagesList;
            system.debug('selected List'+selectedReimList);
            approvedIdList.add(driverMileagesList[0].id);
            
            
            System.debug('approvedIdList'+approvedIdList);
            Test.startTest();
            
            Database.executeBatch(new ChangeTripStatusinTripLog(approvedIdList ,rejectedIdList,'test','test@gmail.com') );
            //ChangeTripStatusinTripLog.getMileages();
            Test.stopTest();



    }
    public static testmethod void method2() {

        SendEmailToMe__c sendemailme = new SendEmailToMe__c();
        sendemailme.name = 'ChangeTripStatusinTripLog';
        sendemailme.Send_email_to_me__c = true;
        insert sendemailme;

        RecordUtilityClass.createRecordsAdminDashboardController();
            Test.setMock(HttpCalloutMock.class, new ChangeTripStatusinTripLogTestMock());
            Account currentAccount = RecordUtilityClass.getAccount(); // retriving the Accounts EmployeeMileagesForCalculation
            Contact currentAdmin = RecordUtilityClass.getAdminContact(); // Retriving the Admin with limit 1
            Contact selectedDriver = RecordUtilityClass.getDriverContact();
            List<String> approvedIdList = new List<String>();
            List<String> rejectedIdList = new List<String>();   
            List<Employee_Reimbursement__c> empReimbursementList = RecordUtilityClass.getEmployee_Reimbursement(currentAccount.id);
            List<EmployeeReimbursementDetailsAdmin> selectedReimList = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(empReimbursementList);
            List<Employee_Mileage__c> driverMileagesList =  RecordUtilityClass.getMileagesList();
            driverMileagesList[0].Trip_Id__c = 104976448;
            update driverMileagesList;
            system.debug('selected List'+selectedReimList);
            rejectedIdList.add(driverMileagesList[0].id);
            
            
            System.debug('approvedIdList'+approvedIdList);
            Test.startTest();
            
            Database.executeBatch(new ChangeTripStatusinTripLog(approvedIdList ,rejectedIdList,'test','test@gmail.com') );
            //ChangeTripStatusinTripLog.getMileages();
            Test.stopTest();



    }
}