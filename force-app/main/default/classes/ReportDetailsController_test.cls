@isTest
public class ReportDetailsController_test {
    public static boolean flag {get;set;}
     public static testmethod void TestMethod1() 
     {        
         flag= false;
        List<Contact> driverlist = insertrecords();
        insertReimbursements(driverlist);
        Account obj_account = RecordUtilityClass.getAccount();
        Contact obj_admin =RecordUtilityClass.getAdminContact();
        Contact obj_manager =RecordUtilityClass.getManagerContact();
        Custom_Report__c rep = createReport('Select id from Contact','Contact Created Between 2 Dates');
        insert rep;

        Test.startTest();
        Test.setCurrentPage(Page.reportdetail);
        String reportid = ApexPages.currentPage().getParameters().put('reportid',rep.Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_account.Id);
        String conid = ApexPages.currentPage().getParameters().put('id',obj_admin.Id);
        ReportDetailsController obj_ReportDetailsController = new ReportDetailsController();
        ReportDetailsController.getAllReportHeaders(rep.id);
        ReportDetailsController.getRedirected();
        ReportDetailsController.getAllManagers('Driver');
        ReportDetailsController.getAllManagers('Manager');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Driver');
        Custom_Report__c rep1 = createReport('Select id from Contact','Contact Activation Between 2 Dates');
        insert rep1;
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Driver');
        
        Custom_Report__c rep3 =createReport('Select id from Contact','Without Date Range');
        insert rep3;
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        Custom_Report__c rep4 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Created Between 2 Dates');
        insert rep4;
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Driver');
        Custom_Report__c rep5 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Dates For Month Range');
        insert rep5;
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Driver');
        
        Custom_Report__c rep6 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Deactivation Dates');
        insert rep6;
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Driver');

        Custom_Report__c rep7 =createReport('Select id from Employee_Reimbursement__c','Without Date Range');
        insert rep7;
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Driver');

        Custom_Report__c rep8 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Dates For Month Range');
        insert rep8;
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Driver');

        Custom_Report__c rep9 =createReport('Select id from Employee_Reimbursement__c','Without Date Range');
        insert rep9;
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Driver');

        Custom_Report__c rep10 =createReport('Select id from Employee_Mileage__c','Without Date Range');
        insert rep10;
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Driver');
        
        Custom_Report__c rep11 =createReport('Select id from Employee_Mileage__c','Mileages Created Between 2 Dates');
        insert rep11;
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Driver');

        Custom_Report__c rep12 =createReport('Select id from Employee_Mileage__c','Mileages Between 2 Deactivation Dates');
        insert rep12;
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Driver');

        Custom_Report__c rep13 =createReport('Select id from Employee_Mileage__c','Mileages Between 2 Dates for Month Range');
        insert rep13;
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Driver');
        ReportDetailsController.getAllReportSoqlForDriver();
        
        Custom_Report__c rep14 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Deactivation Dates');
        insert rep14;        
        Contact drivercontact = RecordUtilityClass.getDriverContact();
        drivercontact.Deactivated_Date__c = System.today();
        update drivercontact;
        Custom_Report__c rep2 = createReport('Select id from Contact','Contact Deactivation Between 2 Dates');
        insert rep2;
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,'',String.valueOf(System.today().month())+'/'+String.valueOf(System.today().Day())+'/'+String.valueOf(System.today().year()).right(2),System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),obj_admin.Id,obj_account.Id,rep2.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,obj_manager.id,System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),obj_admin.Id,obj_account.Id,rep2.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep14.Report_Soql__c,rep14.Report_Type__c,'','01/08/19','09/27/19',obj_admin.Id,obj_account.Id,rep14.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep14.Report_Soql__c,rep14.Report_Type__c,obj_manager.id,'01/08/19','09/27/19',obj_admin.Id,obj_account.Id,rep14.Id,'Driver');
        Test.stopTest();

        
     }
     public static testmethod void TestMethod2() 
     {      
          flag= false;  
        List<Contact> driverlist = insertrecords();
        insertReimbursements(driverlist);
        Account obj_account = RecordUtilityClass.getAccount();
        Contact obj_admin =RecordUtilityClass.getAdminContact();
        Contact obj_manager =RecordUtilityClass.getManagerContact();
        Custom_Report__c rep = createReport('Select id from Contact','Contact Created Between 2 Dates');
        insert rep;

        Test.startTest();
        Test.setCurrentPage(Page.reportdetail);
        String reportid = ApexPages.currentPage().getParameters().put('reportid',rep.Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_account.Id);
        String conid = ApexPages.currentPage().getParameters().put('id',obj_admin.Id);
        ReportDetailsController obj_ReportDetailsController = new ReportDetailsController();
        ReportDetailsController.getAllReportHeaders(rep.id);
        ReportDetailsController.getRedirected();
        ReportDetailsController.getAllManagers('Driver');
        ReportDetailsController.getAllManagers('Manager');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Manager');
        Custom_Report__c rep1 = createReport('Select id from Contact','Contact Activation Between 2 Dates');
        insert rep1;
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Manager');
        Custom_Report__c rep2 = createReport('Select id from Contact','Contact Deactivation Between 2 Dates');
        insert rep2;
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep2.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep2.Id,'Manager');
        Custom_Report__c rep3 =createReport('Select id from Contact','Without Date Range');
        insert rep3;
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        Custom_Report__c rep4 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Created Between 2 Dates');
        insert rep4;
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Manager');
        Custom_Report__c rep5 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Dates For Month Range');
        insert rep5;
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Manager');
        
        Custom_Report__c rep6 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Deactivation Dates');
        insert rep6;
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Manager');

        Custom_Report__c rep7 =createReport('Select id from Employee_Reimbursement__c','Without Date Range');
        insert rep7;
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Manager');

        Custom_Report__c rep8 =createReport('Select id from Employee_Reimbursement__c','Reimbursements Between 2 Dates For Month Range');
        insert rep8;
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Manager');

        Custom_Report__c rep9 =createReport('Select id from Employee_Reimbursement__c','Without Date Range');
        insert rep9;
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Manager');

        Custom_Report__c rep10 =createReport('Select id from Employee_Mileage__c','Without Date Range');
        insert rep10;
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Manager');
        
        Custom_Report__c rep11 =createReport('Select id from Employee_Mileage__c','Mileages Created Between 2 Dates');
        insert rep11;
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Manager');

        Custom_Report__c rep12 =createReport('Select id from Employee_Mileage__c','Mileages Between 2 Deactivation Dates');
        insert rep12;
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Manager');

        Custom_Report__c rep13 =createReport('Select id from Employee_Mileage__c','Mileages Between 2 Dates for Month Range');
        insert rep13;
       
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Manager');
        ReportDetailsController.getAllReportSoqlForDriver();
        Test.stopTest();

        
     }
     public static testmethod void TestMethod3() 
     { 
         ReportDetailsController.getAllManagers('Driver');
         ReportDetailsController.getAllManagers('Manager');
     }
     public static testmethod void TestMethod4() 
     {      
          flag= false;  
        List<Contact> driverlist = insertrecords();
        
        Account obj_account = RecordUtilityClass.getAccount();
        Contact obj_admin =RecordUtilityClass.getAdminContact();
        Contact obj_manager =RecordUtilityClass.getManagerContact();
        Custom_Report__c rep = createReport('Select id from Contact','Contact Created Between 2 Dates');
        insert rep;

        Test.startTest();
        Test.setCurrentPage(Page.reportdetail);
        String reportid = ApexPages.currentPage().getParameters().put('reportid',rep.Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_account.Id);
        String conid = ApexPages.currentPage().getParameters().put('id',obj_admin.Id);
        ReportDetailsController obj_ReportDetailsController = new ReportDetailsController();
        ReportDetailsController.getAllReportHeaders(rep.id);
        ReportDetailsController.getRedirected();
        ReportDetailsController.getAllManagers('Driver');
        ReportDetailsController.getAllManagers('Manager');
        

        Custom_Report__c rep13 =createReport('Select id from Employee_Mileage__c','Mileages Between 2 Dates for Month Range');
        insert rep13;
       
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,'','01/08/19','01/08/19',obj_admin.Id,obj_account.Id,rep13.Id,'Manager');
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,obj_manager.id,'01/08/19','01/08/19',obj_admin.Id,obj_account.Id,rep13.Id,'Manager');
        ReportDetailsController.getAllReportSoqlForDriver();
        Test.stopTest();

        
     }
     public static testmethod void TestMethod5() 
     {        
         flag= false;
        List<Contact> driverlist = insertrecords();
        insertReimbursements(driverlist);
        Account obj_account = RecordUtilityClass.getAccount();
        Contact obj_admin =RecordUtilityClass.getAdminContact();
        Contact obj_manager =RecordUtilityClass.getManagerContact();
        Custom_Report__c rep = createReport('Select id from Contact','Contact Created Between 2 Dates');
        insert rep;

        Test.startTest();
        Test.setCurrentPage(Page.reportdetail);
        String reportid = ApexPages.currentPage().getParameters().put('reportid',rep.Id);
        String accId = ApexPages.currentPage().getParameters().put('accid',obj_account.Id);
        String conid = ApexPages.currentPage().getParameters().put('id',obj_admin.Id);
        ReportDetailsController obj_ReportDetailsController = new ReportDetailsController();
        ReportDetailsController.getAllReportHeaders(rep.id);
        ReportDetailsController.getRedirected();
        ReportDetailsController.getAllManagers('Driver');
        ReportDetailsController.getAllManagers('Manager');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep.Report_Soql__c,rep.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep.Id,'Driver');
        Custom_Report__c rep1 = createReport('Select id from Contact where Accountid=\''+obj_account.Id+'\'','Contact Activation Between 2 Dates');
        insert rep1;
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep1.Report_Soql__c,rep1.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep1.Id,'Driver');
        
        Custom_Report__c rep3 =createReport('Select id from Contact where Accountid=\''+obj_account.Id+'\'','Without Date Range');
        insert rep3;
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep3.Report_Soql__c,rep3.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep3.Id,'Driver');
        Custom_Report__c rep4 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Reimbursements Created Between 2 Dates');
        insert rep4;
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep4.Report_Soql__c,rep4.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep4.Id,'Driver');
        Custom_Report__c rep5 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Reimbursements Between 2 Dates For Month Range');
        insert rep5;
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep5.Report_Soql__c,rep5.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep5.Id,'Driver');
        
        Custom_Report__c rep6 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Reimbursements Between 2 Deactivation Dates');
        insert rep6;
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep6.Report_Soql__c,rep6.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep6.Id,'Driver');

        Custom_Report__c rep7 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Without Date Range');
        insert rep7;
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,'','12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep7.Report_Soql__c,rep7.Report_Type__c,obj_manager.id,'12/12/18','1/12/19',obj_admin.Id,obj_account.Id,rep7.Id,'Driver');

        Custom_Report__c rep8 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Reimbursements Between 2 Dates For Month Range');
        insert rep8;
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep8.Report_Soql__c,rep8.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep8.Id,'Driver');

        Custom_Report__c rep9 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Without Date Range');
        insert rep9;
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep9.Report_Soql__c,rep9.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep9.Id,'Driver');

        Custom_Report__c rep10 =createReport('Select id from Employee_Mileage__c where EmployeeReimbursement__r.Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Without Date Range');
        insert rep10;
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep10.Report_Soql__c,rep10.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep10.Id,'Driver');
        
        Custom_Report__c rep11 =createReport('Select id from Employee_Mileage__c where EmployeeReimbursement__r.Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Mileages Created Between 2 Dates');
        insert rep11;
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep11.Report_Soql__c,rep11.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep11.Id,'Driver');

        Custom_Report__c rep12 =createReport('Select id from Employee_Mileage__c where EmployeeReimbursement__r.Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Mileages Between 2 Deactivation Dates');
        insert rep12;
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep12.Report_Soql__c,rep12.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep12.Id,'Driver');

        Custom_Report__c rep13 =createReport('Select id from Employee_Mileage__c where EmployeeReimbursement__r.Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Mileages Between 2 Dates for Month Range');
        insert rep13;
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,'','01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep13.Report_Soql__c,rep13.Report_Type__c,obj_manager.id,'01/08/19','01/09/19',obj_admin.Id,obj_account.Id,rep13.Id,'Driver');
        ReportDetailsController.getAllReportSoqlForDriver();
        
        Custom_Report__c rep14 =createReport('Select id from Employee_Reimbursement__c where Contact_Id__r.Accountid=\''+obj_account.Id+'\'','Reimbursements Between 2 Deactivation Dates');
        insert rep14;        
        Contact drivercontact = RecordUtilityClass.getDriverContact();
        drivercontact.Deactivated_Date__c = System.today();
        update drivercontact;
        Custom_Report__c rep2 = createReport('Select id from Contact where Accountid=\''+obj_account.Id+'\'','Contact Deactivation Between 2 Dates');
        insert rep2;
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,'',String.valueOf(System.today().month())+'/'+String.valueOf(System.today().Day())+'/'+String.valueOf(System.today().year()).right(2),System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),obj_admin.Id,obj_account.Id,rep2.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep2.Report_Soql__c,rep2.Report_Type__c,obj_manager.id,System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),System.today().month()+'/'+System.today().Day()+'/'+String.valueOf(System.today().year()).right(2),obj_admin.Id,obj_account.Id,rep2.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep14.Report_Soql__c,rep14.Report_Type__c,'','01/08/19','09/27/19',obj_admin.Id,obj_account.Id,rep14.Id,'Driver');
        ReportDetailsController.getAllReportSoql(rep14.Report_Soql__c,rep14.Report_Type__c,obj_manager.id,'01/08/19','09/27/19',obj_admin.Id,obj_account.Id,rep14.Id,'Driver');
        Test.stopTest();

        
     }
     public static List<Contact> insertrecords()
     {
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        obj_admincontact.Activation_Date__c = System.today();
        insert obj_admincontact;

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        List<Contact> obj_Manager_list1 = new List<Contact>();
        for(Contact obj:obj_Manager_list)
        {
            obj.Activation_Date__c = System.today();
            obj_Manager_list1.add(obj);
        }
        insert obj_Manager_list1;
        RecordUtilityClass.vehicleUrlMapping();
        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        List<Contact> obj_Driver_list1 = new List<Contact>();
        for(Contact obj:obj_Driver_list)
        {
            obj.Activation_Date__c = System.today();
            obj_Driver_list1.add(obj);
        }
        insert obj_Driver_list1;
        return obj_Driver_list1;
       
     }
     public static void insertReimbursements(List<Contact> driverList)
     {
        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;
        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(driverList);
        insert obj_Employee_Reimbursement_list;
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;
        
     }
     public static Custom_Report__c createReport(String reportsoql,String reporttype)
     {
        Custom_Report__c rep = new Custom_Report__c();
        rep.Name = 'Test Productivity Report';
        rep.Report_Category__c = 'My Custom Reports';
        rep.Report_For__c = '';
        if(flag==false)
        {
            rep.Use_Manager_List__c = true;
            flag=true;
        }
        else
        {
        
            rep.Use_Driver_List__c = true;
             flag=false;
        }
        
        rep.Report_Soql__c = reportsoql;
        rep.Report_Type__c = reporttype;
        rep.Sort_By__c = 'asc';
        rep.Sort_From__c = '2';
        return rep;
     }
}