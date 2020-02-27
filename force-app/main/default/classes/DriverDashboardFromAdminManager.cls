public  class DriverDashboardFromAdminManager 
{
    public static String query;
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String contactDataAsString {get; set;}
    public static String gaspriceforpreviosmonth {get; set;}
    public static List<contact>  obj_currect_contact {get;set;}
    public static String obj_current_contact_details {get;set;}
    public List<Attachment>  obj_driver_insurance {get;set;}
    public List<Attachment>  obj_driver_driverpacket {get;set;}
    public Integer obj_attachementsize {get;set;}
    public Integer obj_driverpacket_attachementsize {get;set;}
    public static Boolean showlastyear {get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public DriverDashboardFromAdminManager() 
    {
        obj_currect_contact = new List<contact>();
        obj_driver_insurance = new List<Attachment>();
        obj_driver_driverpacket = new List<Attachment>();
        
        obj_driver_driverpacket = [SELECT Id, Body, Name FROM Attachment WHERE ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Driver_Packet%' limit 1];
        obj_driverpacket_attachementsize = obj_driver_driverpacket.size();
        obj_current_contact_details = getDriverDetails();
        setEmployeeName();
        obj_driver_insurance = [SELECT id, Body, Name FROM Attachment WHERE id=:obj_currect_contact[0].Insurance_Attachment_Id__c limit 1];
        obj_attachementsize = obj_driver_insurance.size();
        if(obj_currect_contact.size() > 0)
        {
            gaspriceforpreviosmonth = getDriverGasPrice(obj_currect_contact[0].MailingState,obj_currect_contact[0].MailingCity);
        }
        //getpastYearReimbursement();

    }
    public static String getAccountid()
    {
        if(ApexPages.currentPage().getParameters().containsKey('accid') && String.isNotEmpty(ApexPages.currentPage().getParameters().get('accid')))
        {
           return ApexPages.currentPage().getParameters().get('accid');
        }
        else
        {
            return '';
        } 
    }    
    public static String getAdminid()
    {
        // manager id
        if(ApexPages.currentPage().getParameters().containsKey('adminid') && String.isNotEmpty(ApexPages.currentPage().getParameters().get('adminid')))
        {
           return ApexPages.currentPage().getParameters().get('adminid');
        }
        else
        {
            return '';
        } 
    }
    public static void setEmployeeName() {
        Contact employee= [SELECT Name, External_Email__c FROM Contact WHERE id =: getAdminid()];
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
    public static String getDriverid()
    {
        
        if(ApexPages.currentPage().getParameters().containsKey('id') && String.isNotEmpty(ApexPages.currentPage().getParameters().get('id')))
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
        
        if(getAdminid()!=''&& getAccountid()!='' && getDriverid()!='')
        {
            return null;
        }
        else
        {
            // redirect to error page
            return null;
        }
        
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

     public static String getLast2Years()
    {
        //getpastYearReimbursement();
        //return WrapperUtils.getLast2Years();
        return String.escapeSingleQuotes(WrapperUtils.getpastYearReimbursement(getDriverid()));
    }
    
    @RemoteAction
    public Static String getAllReimbursements(String year,String did,String accid) 
    {       
         System.debug('year'+year);
        return String.escapeSingleQuotes(WrapperUtils.getAllReimbursements(year,did,accid));
    }
    
    public static String getReimbursementsList()
    {   
         return String.escapeSingleQuotes(WrapperUtils.getReimbursementsList(getDriverid(),'Approved'));
    }
    @RemoteAction
    public static String getReimbursementsListClone(String driverid)
    {
        return String.escapeSingleQuotes(WrapperUtils.getReimbursementsListClone(driverid));
    }
    public static String getDriverDetails()
    {   
        obj_currect_contact = [SELECT id, Name, MailingPostalCode, MailingState, MailingCity, 
                                        Fixed_Amount__c, compliancestatus__c, Car_Image__c, Account.Name, Account.Logo_Document_Id__c, 
                                        Vehicle_Type__c,Insurance_Attachment_Id__c 
                                    FROM Contact 
                                    WHERE id =: getDriverid()];
        return String.escapeSingleQuotes(JSON.serialize(obj_currect_contact));
    }
    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {   
        return WrapperUtils.getDriverGasPrice(MailingState,MailingCity);
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
    @RemoteAction
    public static List<String> getCompliance(String did)
    {
    System.debug('getCompliance'+did);
        return WrapperUtils.getComplianceCalculation(did,String.valueOf(System.today().year()));
       
    }
    @RemoteAction
    public static List<String > getPacketandMeeting(String did)
    {
        return WrapperUtils.getPacketandMeetingDetails(did);
    }   
}