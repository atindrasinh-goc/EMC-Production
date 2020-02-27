public with sharing class AdminDashboardController {

    public static String query;
    public static String totalmileages{get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public static Boolean showTeamRecord{get;set;}
    public static String totalvariableamount{get;set;}
   
    public AdminDashboardController() {
    }
    public static String getAccountid() {
        if (ApexPages.currentPage().getParameters().containsKey('accid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('accid'))) {
            return ApexPages.currentPage().getParameters().get('accid');
        } else {
            return '';
        }
    }
    public static String getContactid() {
        if (ApexPages.currentPage().getParameters().containsKey('id') && String.isNotBlank(ApexPages.currentPage().getParameters().get('id'))) {
            return ApexPages.currentPage().getParameters().get('id');
        } else {
            return '';
        }
    }
    public static String getShowTeam() {
        if (ApexPages.currentPage().getParameters().containsKey('showteam') && String.isNotBlank(ApexPages.currentPage().getParameters().get('showteam'))) {
            return ApexPages.currentPage().getParameters().get('showteam');
        } else {
            return '';
        }
    }
    public static PageReference getRedirected() {

        if (getContactid() != '' && getAccountid() != '' && getShowTeam() != '') {
            showTeamRecord = boolean.valueOf(getShowTeam());            
            setEmployeeName(); // sets the Name of the Employee name and Show team record Values according to Database.

            return null;
        } else {
            // redirect to error page
            return null;
        }

    }
    public static string getChartData() {
        System.debug('AdmindashgetChartData');
        return WrapperUtils.getChartData(getContactid(),boolean.valueOf(getShowTeam()),getAccountid(),'Admin');
    }
    

    public static void setEmployeeName() {
        Contact employee= [SELECT Id, Name, showTeamRecord__c, External_Email__c FROM Contact WHERE id =: getContactid()];
        if(employee!=null)
        {
            emailofEmployee = employee.External_Email__c;
            nameofEmployee= String.escapeSingleQuotes(employee.Name); // Name of the Employee            
        }
        else
        {
            nameofEmployee=''; 
            emailofEmployee ='';           
        }       
    }
    public static string getAllDriversLastMonthReimbursements() 
    {    
        return String.escapeSingleQuotes(getAllDriversLastMonthUpdatedReimbursements(getContactid(),getAccountid(),getShowTeam()));        
    }    
    public static string getAllDriversLastMonthUnapprovedReimbursementsClone() 
    {        
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(getContactid(),getAccountid(),boolean.valueOf(getShowTeam()),'Admin'));
    }    
    @RemoteAction
    public static string getAllDriversLastMonthUpdatedReimbursements(String did, String accid,String showTeamRecord) {
        return String.escapeSingleQuotes(WrapperUtils.getLastMonthReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Admin'));
    }    
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseClone(String did, String accid,boolean showTeamRecord) 
    {
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,showTeamRecord,'Admin'));
    }
    @RemoteAction
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseClone1(String did, String accid,string showTeamRecord) 
    {
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Admin'));
    }
    @RemoteAction
    public static List<String> approveReimbursements(String reimbursements,String did,String accid,String showTeamRecord,String updateThreshold) {
        List<String> updatedlist = new List<String>();
        if(updateThreshold!=null && String.isNotBlank(updateThreshold))
        {            
            WrapperUtils.updateContactThresholdLimit(updateThreshold);
        }
        if(reimbursements!=null && String.isNotBlank(reimbursements))
        {
            WrapperUtils.updateReimbursements(reimbursements);
        }
        updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,showTeamRecord));
        updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,boolean.valueOf(showTeamRecord)));
        return updatedlist;   
    }
    @RemoteAction
    public static List<String> approveMileagesClone(String mileages, String did, String accid,String showTeamRecord)
    {
        system.debug('approveMileagesClone');
        List<String> updatedlist = new List<String>();
        if(mileages!=null)
        {
            /*mileages=WrapperUtils.replaceAllJson(mileages);
            List<ReimbursementAndMileages> reimbursementList = new List<ReimbursementAndMileages>();
            reimbursementList = ReimbursementAndMileages.parse(mileages);            
            List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>(); 
            Set<String> milelist = new Set<String>();

            if(reimbursementList.size()>0)
            {
                for(ReimbursementAndMileages currentReimbursement : reimbursementList)
                {
                    if(currentReimbursement.mileagesList!=null && currentReimbursement.mileagesList.size()>0)
                    {
                        for(ReimbursementAndMileages.MileagesList currentMileage : currentReimbursement.mileagesList) 
                        {
                            milelist.add(currentMileage.Employee_Reimbursement);
                        }   
                    }
                    
                }   
                if(milelist.size() > 0) {
                    for(String currentMileage : milelist) {
                        Employee_Reimbursement__c currentReimbursement = new Employee_Reimbursement__c();
                        currentReimbursement.id= String.valueOf(currentMileage);
                        currentReimbursement.Status__c = 'Approved';
                        currentReimbursement.Approved_Date__c = System.today();
                        employeeReimbursementList.add(currentReimbursement);
                    }   
                }

                if(employeeReimbursementList.size()>0)
                {
                    update employeeReimbursementList;
                    updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,showTeamRecord));
                    updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,boolean.valueOf(showTeamRecord)));
                    return updatedlist;
                   
                }                
             }*/
             WrapperUtils.approveMileagesClone1(mileages);
             updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,showTeamRecord));
             updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,boolean.valueOf(showTeamRecord)));
             return updatedlist;
        }       
        return null;
    }
    @RemoteAction
    public static void invokeSendEmailForAdmin(String reimbursements) {
            System.debug('data'+reimbursements);
            List<String> dataList =(List<String>)(JSON.deserialize(reimbursements,List<String>.class));
            System.debug('datalist'+dataList);
            
            System.debug('data'+reimbursements.length());
           // System.debug('data'+idlist);
           // System.debug('data'+idlist.size());

            //List<String> data = JSON.deserialize(reimbursements, String);
            
      /*   List<Messaging.SingleEmailMessage> singleEmailMessageList = new List<Messaging.SingleEmailMessage>();
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<EmailTemplate> emailTemplate = new List<EmailTemplate>([SELECT Id, Subject,HtmlValue, body FROM EmailTemplate WHERE developerName = 'year_to_date_reimbursement_statement_template']);
            List<String> myEmail = new List<String>();
            myEmail.add('nikhil.goc@gmail.com');
            mail.setToAddresses(myEmail); 
            mail.setSubject(emailTemplate[0].Subject); 
            singleEmailMessageList.add(mail);
            Messaging.sendEmail(singleEmailMessageList); 
           */
       // EmailReminderForAdminDashbordBatch objbatch = new EmailReminderForAdminDashbordBatch();
        //Database.executeBatch(batchable,1);

    }


    @RemoteAction
    public static String approveMileages(String checked,String selected,String name,String emailaddress)
    { 
        System.debug('selected :- '+selected);
        System.debug('checked :- '+checked);
        System.Debug('name :-'+name);  
        System.Debug('emailaddress :-'+emailaddress);                          
        return WrapperUtils.approveMileagesForAdminDash(checked,selected,name,emailaddress);
        
        
    }
    @RemoteAction
    public static String getUnapprovedMileages(String reimbursementDetails) // Please change the method body,UI Dev require to pass the several parameters
    {
        system.debug('inside getUnapprovedMileages'+reimbursementDetails);
        /*double mileages=0;
        double variableamount=0;
        totalmileages =''; 
        totalvariableamount=''; 
        List<EmployeeMileages> mileageList = new List<EmployeeMileages>();
        List<Employee_Mileage__c> employeeMileageList = new List<Employee_Mileage__c>();
        if(unapprovemileagesList != null && unapprovemileagesList != '')
        {
            employeeMileageList = (List<Employee_Mileage__c>)JSON.deserialize(unapprovemileagesList,List<Employee_Mileage__c>.class);    
            for(Employee_Mileage__c currentMileage : employeeMileageList)
            {
                mileages = mileages+currentMileage.Mileage__c;
                variableamount = variableamount +currentMileage.Variable__c;
                mileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            }
        }
        else
        {
            for(Employee_Mileage__c currentMileage:[Select id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,EmployeeReimbursement__r.Total_Pending__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c FROM Employee_Mileage__c WHERE ((Trip_Status__c =:StaticValues.noApprovedYet) and Approved_Date__c = null) AND EmployeeReimbursement__r.Contact_Id__c =:did])
            {
                mileages = mileages+currentMileage.Mileage__c;
                variableamount = variableamount +currentMileage.Variable__c;
                mileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            }   
        }*/
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedMileages(reimbursementDetails));
    }
    /*@RemoteAction
    public static String getUnapprovedMileagesforDownload(String reimbursement)
    {
        return WrapperUtils.getUnapprovedMileagesforDownload(reimbursement);
    }*/
    @RemoteAction
    public static String getManager(String did, String accid) {

        List<Contact> adminContact = new List<Contact>();
        adminContact = [SELECT id, Name, Email, Accountid FROM Contact WHERE Accountid =: accid AND (Deactivated_Date__c = null OR Deactivated_Date__c > TODAY) AND (Role__c='Manager' OR Role__c='Driver/Manager')];
        return String.escapeSingleQuotes(JSON.serialize(adminContact));
    }    
    /*public static String getLastMonthValueForMyTeamMil(Integer value) {
        String tempDate = '';
        if(System.Today().day() >= 1 && system.today().day() <= 4){
            if(value == -1){
                tempDate = date.today().addMonths(-2).Month() + '-' + date.today().addMonths(-2).Year();
            }else{
                tempDate = date.today().addMonths(value).Month() + '-' + date.today().addMonths(value).Year();
            }
        } else {
            tempDate = date.today().addMonths(value).Month() + '-' + date.today().addMonths(value).Year();
        }
        String lastMonth = tempDate.left(2);
        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
        return lastMonth;
    }*/
    
}