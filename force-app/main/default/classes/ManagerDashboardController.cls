public class ManagerDashboardController 
{
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public ManagerDashboardController() 
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
        return WrapperUtils.getChartData(getContactid(),boolean.valueOf(getShowTeam()),getAccountid(),'Manager');
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
    public static string getAllDriversLastMonthUpdatedReimbursements(String did,String accid,boolean showTeamRecord)
    {   
        
         return String.escapeSingleQuotes(WrapperUtils.getLastMonthReimbursements(did,accid,showTeamRecord,'Manager'));
    }
    public static string getAllDriversLastMonthReimbursements()
    { 
        return String.escapeSingleQuotes(WrapperUtils.getLastMonthReimbursements(getContactid(),getAccountid(),boolean.valueOf(getShowTeam()),'Manager'));        
    }
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseclone(String did,String accid,boolean showTeamRecord)
    {   
       return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,showTeamRecord,'Manager'));
    }
    @RemoteAction
    public static string getAllDriversLastMonthUpdatedUnapprovedReimburseClone1(String did, String accid,string showTeamRecord) 
    {
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(did,accid,boolean.valueOf(showTeamRecord),'Manager'));
    }
    public static string getAllDriversLastMonthUnapprovedReimbursementsclone()
    {   
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedReimbursements(getContactid(),getAccountid(),boolean.valueOf(getShowTeam()),'Manager'));
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
        updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,boolean.valueOf(showTeamRecord)));
        updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseclone(did,accid,boolean.valueOf(showTeamRecord)));
        return updatedlist;             
        
    }

    @RemoteAction
    public static List<String> approveMileagesClone(String mileages, String did, String accid,String showTeamRecord)
    {

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
             updatedlist.add(getAllDriversLastMonthUpdatedReimbursements(did,accid,boolean.valueOf(showTeamRecord)));
             updatedlist.add(getAllDriversLastMonthUpdatedUnapprovedReimburseClone(did,accid,boolean.valueOf(showTeamRecord)));
             return updatedlist;
    }
    return null;
 }       
        

    @RemoteAction
    public static String approveMileages(String checked,String selected,String name,String emailaddress)
    {        
        return WrapperUtils.approveMileagesForAdminDash(checked,selected,name,emailaddress);
    }

    @RemoteAction
    public static String getUnapprovedMileages(String reimbursementDetails)
    {
        /*double mileages=0;
        double variableamount=0;
        totalmileages =''; 
        totalvariableamount=''; 
        List<EmployeeMileages> employeeMileageList = new List<EmployeeMileages>();
        List<Employee_Mileage__c> mileageList = new List<Employee_Mileage__c>();
        if(unapprovemileagesList != null && unapprovemileagesList != '')
        {
            mileageList = (List<Employee_Mileage__c>)JSON.deserialize(unapprovemileagesList,List<Employee_Mileage__c>.class);    
            for(Employee_Mileage__c currentMileage : mileageList)
            {
                mileages = mileages+currentMileage.Mileage__c;
                variableamount = variableamount +currentMileage.Variable__c;
                employeeMileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            }
        }
        else
        {
            for(Employee_Mileage__c currentMileage:[Select id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,EmployeeReimbursement__r.Total_Pending__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c FROM Employee_Mileage__c WHERE ((Trip_Status__c =:StaticValues.noApprovedYet) and Approved_Date__c = null) AND EmployeeReimbursement__r.Contact_Id__c =:did])
            {
                mileages = mileages+currentMileage.Mileage__c;
                variableamount = variableamount + currentMileage.Variable__c;
                employeeMileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            }   
        }*/
        return String.escapeSingleQuotes(WrapperUtils.getUnapprovedMileages(reimbursementDetails));
    }    
}