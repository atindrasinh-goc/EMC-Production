public class DriverManagerDashboardController 
{
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String nameofEmployee{get;set;}
    public static boolean showTeamRecord{get;set;}
    public static String emailofEmployee{get;set;}
    public DriverManagerDashboardController() 
    {
        
    }
    public static String getAccountid()
    {
        if(ApexPages.currentPage().getParameters().containsKey('accid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('accid')))
        {
           return ApexPages.currentPage().getParameters().get('accid');
        }
        else
        {
            return '';
        } 
    }
    public static String getContactid()
    {
        if(ApexPages.currentPage().getParameters().containsKey('id') && String.isNotBlank(ApexPages.currentPage().getParameters().get('id')))
        {
           return ApexPages.currentPage().getParameters().get('id');
        }
        else
        {
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
    public static PageReference getRedirected()
    {
        
        if(getContactid()!=''&& getAccountid()!='' && getShowTeam() != '')
        {
            setEmployeeName(); // sets the Name of the Employee name and Show team record Values according to Database.
            return null;
        }
        else
        {
            // redirect to error page
            return null;
        }
        
    }
    public static string getChartData()
    {        
        return WrapperUtils.getChartData(getContactid(),boolean.valueOf(getShowTeam()),getAccountid(),'Driver/Manager');
    }
    
    public static void setEmployeeName() {
        Contact employee= [select Id,Name,showTeamRecord__c,External_Email__c from Contact where id =: getContactid()];
        if(employee!=null)
        {
            nameofEmployee= String.escapeSingleQuotes(employee.Name); // Name of the Employee
            emailofEmployee = employee.External_Email__c;
        }
        else
        {
            nameofEmployee='';
            emailofEmployee ='';
            
        }       
    }
    @RemoteAction
    public static string getAllDriversLastMonthUpdatedReimbursements(String did,String accid,String showTeamRecord)
    {   
         return String.escapeSingleQuotes(WrapperUtils.getLastMonthReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Driver/Manager'));
    }
    public static string getAllDriversLastMonthReimbursements()
    {                       
        return String.escapeSingleQuotes(WrapperUtils.getLastMonthReimbursements(getContactid(),getAccountid(),boolean.valueOf(getShowTeam()),'Driver/Manager'));        
    }
    /*public static string getAllDriversLastMonthUpdatedUnapprovedReimburse(String did,String accid)
    {               
        List<EmployeeReimbursementDetailsAdmin> employeeReimbursementList = new List<EmployeeReimbursementDetailsAdmin>();
        double mileages=0;
        double variableamount=0;
        for(Employee_Reimbursement__c currentReimbursement : [Select ID,Name,Month__c,Approved_Date__c,Contact_Id__c,Contact_Id__r.name,Contact_Id__r.Monthly_Mileage_Limit__c,Total_Approved__c,Total_Mileage__c,Status__c,Total_Variable_Rate__c,Total_Rejected__c from Employee_Reimbursement__c where Contact_Id__r.Accountid =:accid and (Contact_Id__r.Deactivated_Date__c = null OR Contact_Id__r.Deactivated_Date__c > TODAY) and (Contact_Id__r.Manager__c =:did OR (Contact_Id__r.Manager__r.Manager__c =:did) OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:did) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:did) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:did)) and Month__c=:WrapperUtils.getLastMonthValue(-1) and Status__c='Pending' and Approved_Date__c=null])
        {
            mileages = mileages+currentReimbursement.Total_Mileage__c;
            if(currentReimbursement.Total_Variable_Rate__c!=null)
            {
                variableamount = variableamount +currentReimbursement.Total_Variable_Rate__c;
            }
            employeeReimbursementList.add(WrapperUtils.getEmployeeReimbursementDetails(currentReimbursement));          
        }
        totalmileages = String.valueOf(mileages);
        totalvariableamount = String.valueOf(variableamount);
        return String.escapeSingleQuotes(JSON.serialize(employeeReimbursementList));
    }*/
    public static string getAllDriversLastMonthUnapprovedReimbursementsclone()
    {                       
         return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(getContactid(),getAccountid(),boolean.valueOf(getShowTeam()),'Driver/Manager'));
    }
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseClone(String did, String accid,String showTeamRecord) 
    {                       
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Driver/Manager'));
    }
    @RemoteAction
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseClone1(String did, String accid,string showTeamRecord) 
    {
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Driver/Manager'));
    }    
    @RemoteAction    
    public static List<String> approveReimbursements(String reimbursements,String did,String accid,String showTeamRecord,String updateThreshold)
    {
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
        updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,showTeamRecord));
        return updatedlist;
        
    }

    @RemoteAction
    public static List<String> approveMileagesClone(String mileages, String did, String accid,String showTeamRecord)
    {
        List<String> updatedlist = new List<String>();
        if(mileages!=null)
        {
            /*mileages=WrapperUtils.replaceAllJson(mileages);
            List<ReimbursementAndMileages> employeeReimbursementList = new List<ReimbursementAndMileages>();
            employeeReimbursementList = ReimbursementAndMileages.parse(mileages);            
            List<Employee_Reimbursement__c> reimbursementList = new List<Employee_Reimbursement__c>(); 
            Set<String> reimbursementIdSet = new Set<String>();

            if(employeeReimbursementList.size()>0)
            {
                for(ReimbursementAndMileages currentReimbursement : employeeReimbursementList)
                {
                    if(currentReimbursement.mileagesList!=null)
                    {
                        for(ReimbursementAndMileages.MileagesList currentMileage : currentReimbursement.mileagesList)
                        {
                            reimbursementIdSet.add(currentMileage.Employee_Reimbursement);
                        }
                    }
                    
                }   
                if(reimbursementIdSet.size() > 0) {
                    for(String reimbursementId : reimbursementIdSet) {
                        Employee_Reimbursement__c currentReimbursement = new Employee_Reimbursement__c();
                        currentReimbursement.id= String.valueOf(reimbursementId);
                        currentReimbursement.Status__c = 'Approved';
                        currentReimbursement.Approved_Date__c = System.today();
                        reimbursementList.add(currentReimbursement);
                    }   
                }

                if(reimbursementList.size()>0)
                {
                    update reimbursementList;
                    updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,showTeamRecord));
                    updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,showTeamRecord));
                    return updatedlist;
                   
                }                
             }*/
             WrapperUtils.approveMileagesClone1(mileages);
             updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,showTeamRecord));
             updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,showTeamRecord));
             return updatedlist;
        }       
        return null;

    }

    @RemoteAction
    public static String getUnapprovedMileages(String reimbursementDetails)
    {
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
                if(currentMileage.Mileage__c!=null)
                {
                    mileages = mileages+currentMileage.Mileage__c;
                    variableamount = variableamount +currentMileage.Variable__c;
                    mileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
                }               
            }
        }
        else
        {
            for(Employee_Mileage__c currentMileage:[Select id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,EmployeeReimbursement__r.Total_Pending__c FROM Employee_Mileage__c WHERE ((Trip_Status__c =:StaticValues.noApprovedYet) and Approved_Date__c = null) AND EmployeeReimbursement__r.Contact_Id__c =:did])
            {
                mileages = mileages+currentMileage.Mileage__c;
                variableamount = variableamount +currentMileage.Variable__c;
                mileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            }   
        }
        return JSON.serialize(mileageList).unescapeHtml4();*/
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedMileages(reimbursementDetails));
    }
    @RemoteAction
    public static String approveMileages(String checked,String selected,String name,String emailaddress)
    {        
        return WrapperUtils.approveMileagesForAdminDash(checked,selected,name,emailaddress);
    }
    
}