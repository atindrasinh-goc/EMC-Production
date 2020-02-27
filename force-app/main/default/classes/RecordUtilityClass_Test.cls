@isTest
public with sharing class RecordUtilityClass_Test {
    public RecordUtilityClass_Test() {
        
    }
    public static Testmethod void RecordUtilityClass_TestMethod1()
    {
        RecordUtilityClass obj = new RecordUtilityClass();
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();
        
        Account acc = RecordUtilityClass.buildAccount();
        insert acc;
        Contact con = RecordUtilityClass.buildAdminContact(acc);
        insert con;
        RecordUtilityClass.buildDriverManagerContact(acc,con);
        
    }
    public static Testmethod void RecordUtilityClass_TestMethod2()
    {
        RecordUtilityClass obj = new RecordUtilityClass();
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.createRecordsAdminDashboardController();
    }
    public static Testmethod void RecordUtilityClass_TestMethod3()
    {
        RecordUtilityClass obj = new RecordUtilityClass();
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.createRecordsforManagerDashboard();
    }
    public static Testmethod void RecordUtilityClass_TestMethod4()
    {   
        RecordUtilityClass obj = new RecordUtilityClass();
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();
        
        Account acc = RecordUtilityClass.buildAccount();
        insert acc;

        Contact con = RecordUtilityClass.buildAdminContact(acc);
        insert con;

        List<Contact> listContactManager = RecordUtilityClass.buildManagerContact(acc,con);
        insert listContactManager;

        List<Contact> listContactDriver = RecordUtilityClass.buildDriverContact(acc,listContactManager[0]);
        insert listContactDriver;

        List<Employee_Reimbursement__c> listEmp = RecordUtilityClass.buildPendingEmployee_Reimbursement(listContactDriver);
        insert listEmp;

        RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(listEmp);
        
    }
    

    public static Testmethod void RecordUtilityClass_TestMethod5(){
            RecordUtilityClass obj = new RecordUtilityClass();
            RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account acc = RecordUtilityClass.buildAccount();
        insert acc;

        Contact con = RecordUtilityClass.buildAdminContact(acc);
        insert con;

        List<Contact> listContactManager = RecordUtilityClass.buildManagerContact(acc,con);
        insert listContactManager;

        List<Contact> listContactDriver = RecordUtilityClass.buildDriverContact(acc,listContactManager[0]);
        insert listContactDriver;
            List<Employee_Reimbursement__c> listemp = RecordUtilityClass.buildPendingEmployee_Reimbursement(listContactDriver);
            insert listemp;

            RecordUtilityClass.getEmployeeReimbursements(listemp);
            //RecordUtilityClass.getallEmployeeMileages(obj_Employee_Mileage_list);
            //RecordUtilityClass.createRecordsAdminManagerDriverDashboardCon();
            //RecordUtilityClass.createRecordsforDriverDashboardFromAdminManager();
            //RecordUtilityClass.getManagerContact();
    }

    public static Testmethod void RecordUtilityClass_TestMethod6(){
        RecordUtilityClass obj = new RecordUtilityClass();
        RecordUtilityClass.exceptionEmail();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account acc = RecordUtilityClass.buildAccount();
        insert acc;

        Contact con = RecordUtilityClass.buildAdminContact(acc);
        insert con;

        List<Contact> listContactManager = RecordUtilityClass.buildManagerContact(acc,con);
        insert listContactManager;

        List<Contact> listContactDriver = RecordUtilityClass.buildDriverContact(acc,listContactManager[0]);
        insert listContactDriver;
        List<Employee_Reimbursement__c> listemp = RecordUtilityClass.buildPendingEmployee_Reimbursement(listContactDriver);
        insert listemp;
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(listemp);
        obj_Employee_Mileage_list[0].Approved_Date__c = Date.today();
        obj_Employee_Mileage_list[0].Trip_Status__c = StaticValues.noApprovedYet;
        insert obj_Employee_Mileage_list;

        
        RecordUtilityClass.getMileagesOfReimbursement(obj_Employee_Mileage_list[0]);
        //RecordUtilityClass.getMileagesList();
            
    }

}