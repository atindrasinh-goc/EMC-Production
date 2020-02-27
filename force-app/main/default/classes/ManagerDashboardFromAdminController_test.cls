@isTest
public class ManagerDashboardFromAdminController_test {
    public static testmethod void ManagerDashboardFromAdminTestMethod() {
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        insert obj_Driver_list;

        List<Employee_Reimbursement__c> listEmp = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        //listEmp[0].Contact_Id__c = obj_Account.Id;
        insert listEmp;

        List<Employee_Mileage__c> listMileage_obj = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(listEmp);
        insert listMileage_obj;
        List<String> reimbursementIdList = new List<String>();
        reimbursementIdList.add(listEmp[0].id);
        Test.startTest();
        Test.setCurrentPage(Page.managerdashboardfromadmin);
        String driverId = ApexPages.currentPage().getParameters().put('id', obj_admincontact.Id);
        String managerid = ApexPages.currentPage().getParameters().put('managerid', obj_Manager_list[0].Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_Account.Id);
        ManagerDashboardFromAdminController mddc = new ManagerDashboardFromAdminController();
        ManagerDashboardFromAdminController.getAllDriversLastMonthUpdatedUnapprovedReimburseClone1(obj_Manager_list[0].Id,obj_Account.Id,'false');

        ManagerDashboardFromAdminController.getAdminid();
        ManagerDashboardFromAdminController.totalmileages='';
        ManagerDashboardFromAdminController.totalvariableamount='';
        ManagerDashboardFromAdminController.nameofEmployee='';
        ManagerDashboardFromAdminController.showTeamRecord = false;
        ManagerDashboardFromAdminController.getRedirected();
        ManagerDashboardFromAdminController.getAccountid();
        ManagerDashboardFromAdminController.getContactid();
        ManagerDashboardFromAdminController.getChartData();
       // ManagerDashboardFromAdminController.getChartLabels();
        ManagerDashboardFromAdminController.getAllDriversLastMonthReimbursements();
        ManagerDashboardFromAdminController.getAllDriversLastMonthUpdatedReimbursements(managerid, obj_Account.Id,'false');
        
        ManagerDashboardFromAdminController.getAllDriversLastMonthUnapprovedReimbursementsclone();

        ManagerDashboardFromAdminController.getAllDriversLastMonthUpdatedUnapprovedReimburseClone(obj_Manager_list[0].Id,obj_Account.Id,'false');
        
        ManagerDashboardFromAdminController.approveReimbursements(JSON.serialize(reimbursementIdList),obj_admincontact.Id,obj_Account.Id,'false');

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();

       // ManagerDashboardFromAdminController.approveMileagesClone(JSON.serialize(obj_Employee_Reimbursement_List),obj_Manager_list[0].Id,obj_Account.Id);
        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list!=null && obj_EmployeeMileages_list.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
    

                }
                else
                {
                    i--;
                    obj.isChecked = true;
                }
                obj_EmployeeMileages_list1.add(obj);
            }
        }
       // ManagerDashboardFromAdminController.approveMileages(JSON.serialize(obj_EmployeeMileages_list1));
       // ManagerDashboardFromAdminController.getUnapprovedMileages(JSON.serialize(obj_list_mileages),obj_Driver_list[0].Id); // obj_list_mileages
       
        Test.stopTest();
    }
    public static testmethod void ManagerDashboardFromAdminTestMethod2(){
        ManagerDashboardFromAdminController mddc = new ManagerDashboardFromAdminController();
        ManagerDashboardFromAdminController.getAccountid();
        ManagerDashboardFromAdminController.getAdminid();
        ManagerDashboardFromAdminController.getContactid();
        ManagerDashboardFromAdminController.getRedirected();
        //ManagerDashboardFromAdminController.approveReimbursements(JSON.serialize(listEmp), managerid, obj_Account.Id);
    }
}