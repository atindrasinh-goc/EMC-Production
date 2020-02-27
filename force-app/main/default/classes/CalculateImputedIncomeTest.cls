@isTest
public class CalculateImputedIncomeTest {
    public static testmethod void imputedIncomeMethod(){
        RecordUtilityClass.createRecordsAdminDashboardController();
        Account currentAccount = RecordUtilityClass.getAccount(); // retriving the Accounts EmployeeMileagesForCalculation        
        currentAccount.Tax_Calculation_Year__c = string.valueOf(System.Today().year());
        update currentAccount;
        Contact currentAdmin = RecordUtilityClass.getAdminContact(); // Retriving the Admin with limit 1
        Contact selectedDriver = RecordUtilityClass.getDriverContact();
        List<Employee_Reimbursement__c> empReimbursementList = RecordUtilityClass.getEmployee_Reimbursement(currentAccount.id);

        List<Id> contIdList = new List<Id>{currentAdmin.Id,selectedDriver.Id};
        CalculateImputedIncome.getImputedIncome(contIdList, currentAccount.Tax_Calculation_Year__c);
        


    }
    
}