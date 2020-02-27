public with sharing class ManagerDriverDashboardController 
{
    public static String query;
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String contactDataAsString {get; set;}
    public static String gaspriceforpreviosmonth {get; set;}
    public static List<contact> obj_currect_contact {get;set;}
    public static String obj_current_contact_details {get;set;}
    public List<Attachment> obj_driver_insurance {get;set;}
    public List<Attachment> obj_driver_driverpacket {get;set;}
    public Integer obj_attachementsize {get;set;}
    public Integer obj_driverpacket_attachementsize {get;set;}
    public static Boolean showlastyear {get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public ManagerDriverDashboardController() 
    {
        obj_currect_contact = new List<contact>();
        obj_current_contact_details = getDriverDetails();
        setEmployeeName();
        if(obj_currect_contact.size()>0)
        {
            gaspriceforpreviosmonth = getDriverGasPrice(obj_currect_contact[0].MailingState,obj_currect_contact[0].MailingCity);
        }
        obj_driver_insurance = new List<Attachment>();
        obj_driver_driverpacket = new List<Attachment>();
        obj_driver_insurance = [select id,Body,Name from Attachment where ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Insurance%' limit 1];
        obj_attachementsize = obj_driver_insurance.size();
        obj_driver_driverpacket = [select id,Body,Name from Attachment where ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Driver_Packet%' limit 1];
        obj_driverpacket_attachementsize = obj_driver_driverpacket.size();
    }
    public static String getAccountid()
    {
        if(ApexPages.currentPage().getParameters().containsKey('accid'))
        {
           return ApexPages.currentPage().getParameters().get('accid');
        }
        else
        {
            return '';
        } 
    }    
    public static String getManagerid()
    {
        // manager id
        if(ApexPages.currentPage().getParameters().containsKey('manid'))
        {
           return ApexPages.currentPage().getParameters().get('manid');
        }
        else
        {
            return '';
        } 
    }
    public static String getDriverid()
    {
        
        if(ApexPages.currentPage().getParameters().containsKey('id'))
        {
           return ApexPages.currentPage().getParameters().get('id');
        }
        else
        {
            return '';
        } 
    }
    public static PageReference getRedirected()
    {
        
        if(getManagerid()!=''&& getAccountid()!='' && getDriverid()!='')
        {
            return null;
        }
        else
        {
            // redirect to error page
            return null;
        }
        
    }
    public static void setEmployeeName() {
        Contact employee= [select Name,External_Email__c from Contact where id =: getManagerid()];
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
    public static String getLast2Years()
    {
      //  getpastYearReimbursement();
        return String.escapeSingleQuotes(WrapperUtils.getpastYearReimbursement(getDriverid()));
    }
    // public static void getpastYearReimbursement(){
        
    //     if(WrapperUtils.getpastYearReimbursement(getDriverid()) > 0)
    //     {
    //         showlastyear = true;
    //     }
    //     else
    //     {
    //         showlastyear = false;
    //     }   
    // }
    @RemoteAction
    public Static String getAllReimbursements(String year,String did,String accid) 
    {       
       return String.escapeSingleQuotes(WrapperUtils.getAllReimbursements(year,did,accid));
    }
    public static String getReimbursementsList()
    {       
         return String.escapeSingleQuotes(WrapperUtils.getReimbursementsList(getDriverid(),''));     
    }
    public static String getDriverDetails()
    {
            
        //List<contact> obj_currect_contact = new List<contact>();
        obj_currect_contact = [Select id,Name,MailingPostalCode,MailingState,MailingCity,Fixed_Amount__c,compliancestatus__c,Car_Image__c,Account.Name,Account.Logo_Document_Id__c,Vehicle_Type__c from Contact where id=:getDriverid()];
        return String.escapeSingleQuotes(JSON.serialize(obj_currect_contact));
    }
    @RemoteAction
    public static String approveReimbursements(String year,String did,String accid,String reimbursements)
    {       
        return WrapperUtils.approveReimbursements(year,did,accid,reimbursements);
    }
    @RemoteAction
    public static String approveMileages(String checked,String selected,String name,String emailaddress)
    {        
        return WrapperUtils.approveMileagesForAdminDash(checked,selected,name,emailaddress);
    }
    @RemoteAction
    public static String getMileages(String clickedMonth,String clickedYear,String did)
    {
         return String.escapeSingleQuotes(WrapperUtils.getMileages(clickedMonth,clickedYear,did));
    }
    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {   
        return WrapperUtils.getDriverGasPrice(MailingState,MailingCity);
    }
    @RemoteAction
    public static String getReimbursementsListClone(String driverid)
    {
        return String.escapeSingleQuotes(WrapperUtils.getReimbursementsListClone(driverid));   
    }
    @RemoteAction
    public static List<String> getPacketandMeeting(String did)
    {
        return WrapperUtils.getPacketandMeetingDetails(did);
    }  
    @RemoteAction
    public static List<String> getCompliance(String did)
    {
        return WrapperUtils.getComplianceCalculation(did,String.valueOf(System.today().year()));
       
    }
}