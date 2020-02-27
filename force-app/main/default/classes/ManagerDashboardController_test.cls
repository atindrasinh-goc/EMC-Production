@isTest
public class ManagerDashboardController_test {
    public static testmethod void ManagerDashboardControllerTestMethod() {
        Test.startTest();

        RecordUtilityClass.createRecordsforManagerDashboard(); // inserting the records for ManagerDashboardController class
        Account currentAccount = RecordUtilityClass.getAccount(); // retriving the Accounts 
        Contact currentAdmin = RecordUtilityClass.getManagerContact(); // Retriving the Manager with limit 1
        List<Employee_Reimbursement__c> empReimbursementList = RecordUtilityClass.getEmployee_Reimbursement(currentAccount.id);
        List<EmployeeReimbursementDetailsAdmin> selectedReimList =new List<EmployeeReimbursementDetailsAdmin>();
        for(Employee_Reimbursement__c obj:empReimbursementList)
        {
            selectedReimList.add(RecordUtilityClass.getEmployeeReimbursementDetails(obj));
        }
        String reimbursement = RecordUtilityClass.getUnapprovedReimbursements(currentAdmin.id,currentAccount.id,false,'Manager');        
        List<EmployeeMileagesForCalculation> employeereimbursementList = new List<EmployeeMileagesForCalculation>();
        employeereimbursementList = (List<EmployeeMileagesForCalculation>)JSON.deserialize(reimbursement,List<EmployeeMileagesForCalculation>.Class);       
        List<String> reimbursementIdList = new List<String>();
        reimbursementIdList.add(empReimbursementList[0].id);
        Test.setCurrentPage(Page.managerdashboard);
        ApexPages.currentPage().getParameters().put('id',currentAdmin.Id);
        ApexPages.currentPage().getParameters().put('accid',currentAccount.Id);                
        
        ManagerDashboardController managerDashboard = new ManagerDashboardController();
        ManagerDashboardController.getRedirected();
        ManagerDashboardController.getAllDriversLastMonthReimbursements();
        
        ManagerDashboardController.getChartData();
        //ManagerDashboardController.getChartLabels();
        ManagerDashboardController.getAllDriversLastMonthUpdatedReimbursements(currentAdmin.Id, currentAccount.Id,true);
        ManagerDashboardController.getAllDriversLastMonthUnapprovedReimbursementsclone();
        ManagerDashboardController.getAllDriversLastMonthUpdatedUnapprovedReimburseclone(currentAdmin.Id,currentAccount.Id,false);
        List<Employee_Mileage__c> driverMileagesList =  RecordUtilityClass.getMileagesList();
        Contact selectedDriver =RecordUtilityClass.getDriverContact();
        ManagerDashboardController.getUnapprovedMileages(JSON.serialize(employeereimbursementList[0]));
        updateThresholdWrapper currentupdateThresholdWrapper = new updateThresholdWrapper();
        List<updateThresholdWrapper> updateThresholdWrapperList = new List<updateThresholdWrapper>();
        currentupdateThresholdWrapper.contactid = selectedDriver.id;
        currentupdateThresholdWrapper.threshold = '20';
        updateThresholdWrapperList.add(currentupdateThresholdWrapper);
        List<String> result = ManagerDashboardController.approveReimbursements(JSON.serialize(reimbursementIdList),currentAdmin.Id,currentAccount.Id,'false',JSON.serialize(updateThresholdWrapperList));
        result =ManagerDashboardController.approveMileagesClone(JSON.serialize(reimbursementIdList),currentAdmin.Id,currentAccount.Id,'true');
        ManagerDashboardController.setEmployeeName();
        Test.stopTest();
    }
}