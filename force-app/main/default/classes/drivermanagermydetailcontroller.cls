public with sharing class drivermanagermydetailcontroller {
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
    public static String logoDocument_id {get;set;}
    public drivermanagermydetailcontroller() {
        obj_currect_contact = new List<contact>();
        obj_current_contact_details = getDriverDetails();
        List<contact> currentDriverList = new List<contact>();
        obj_current_contact_details= getDriverDetails();
        if(obj_current_contact_details!=null)
        {
            obj_currect_contact = (List<Contact>)JSON.deserialize(obj_current_contact_details,List<Contact>.Class);
        }
        if(obj_currect_contact.size()>0)
        {
            gaspriceforpreviosmonth = getDriverGasPrice(obj_currect_contact[0].MailingState,obj_currect_contact[0].MailingCity);
        }
        obj_driver_insurance = new List<Attachment>();
        obj_driver_driverpacket = new List<Attachment>();
        if(obj_currect_contact!=null && obj_currect_contact[0].Insurance_Attachment_Id__c!=null)
        {
            obj_driver_insurance = [SELECT id, Body, Name FROM Attachment WHERE id =: obj_currect_contact[0].Insurance_Attachment_Id__c limit 1];    
        }
        obj_attachementsize = obj_driver_insurance.size();
        obj_driver_driverpacket = [SELECT id, Body, Name FROM Attachment WHERE ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Driver_Packet%' limit 1];
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
    public static String getContactid()
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
        
        if(getContactid()!=''&& getAccountid()!='')
        {
            return null;
        }
        else
        {
            // redirect to error page
            return null;
        }
        
    }
    public static String getLast2Years()
    {
        // getpastYearReimbursement();
        return String.escapeSingleQuotes(WrapperUtils.getpastYearReimbursement(getContactid()));
        // return WrapperUtils.getLast2Years();
    }
    // public static void getpastYearReimbursement(){
        
    //     if(WrapperUtils.getpastYearReimbursement(getContactid()) > 0)
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
          return String.escapeSingleQuotes(WrapperUtils.getReimbursementsList(getContactid(),'Approved'));
    }
    public static String getDriverDetails()
    {
            
    //  List<contact> obj_currect_contact = new List<contact>();
        string contactid=getContactid();
       return getDriverDetailsClone(contactid);

        
        
    }
    @RemoteAction
    public static String getDriverDetailsClone(String contactid)
    {
            
     for(Contact currentContact : [Select id,Name,MailingPostalCode,MailingState,MailingCity,Fixed_Amount__c,compliancestatus__c,Car_Image__c,Accountid,Account.Name,Account.Logo_Document_Id__c,Vehicle_Type__c,Insurance_Attachment_Id__c from Contact where id=:contactid])
        {
            contactDataAsString = String.escapeSingleQuotes(currentContact.Name);
            
            Account newAccount = new Account();
            newAccount.id = currentContact.Accountid;
            newAccount.Name = currentContact.Account.Name;
            newAccount.Logo_Document_Id__c = currentContact.Account.Logo_Document_Id__c;
            logoDocument_id = currentContact.Account.Logo_Document_Id__c;
            Contact newContact = new Contact();
            newContact.id = currentContact.id;
            newContact.MailingPostalCode = currentContact.MailingPostalCode;
            newContact.MailingState = currentContact.MailingState;
            newContact.MailingCity = currentContact.MailingCity;
            newContact.Fixed_Amount__c = currentContact.Fixed_Amount__c;
            newContact.compliancestatus__c = currentContact.compliancestatus__c;
            newContact.Car_Image__c = currentContact.Car_Image__c;
            newContact.Accountid = newAccount.id;
            newContact.Vehicle_Type__c = currentContact.Vehicle_Type__c;
            newContact.Insurance_Attachment_Id__c = currentContact.Insurance_Attachment_Id__c;
            obj_currect_contact.add(newContact);
        }
                
        return JSON.serialize(obj_currect_contact).unescapeHtml4();
    }
    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {   
         return WrapperUtils.getDriverGasPrice(MailingState,MailingCity);
    }
    @RemoteAction
    public static List<String> getMileages(String clickedMonth,String year,String did)
    {
         return WrapperUtils.getMileages1(clickedMonth,year,did);
         //return null;
    }  
    @RemoteAction
    public static String getdriverInsurance(String drid,string attachmentid) {
        List<Attachment> obj_driver_insurance = [select id,Body,Name from Attachment where id=:attachmentid];
        
        return String.escapeSingleQuotes(JSON.serialize(obj_driver_insurance));
    }
    @RemoteAction
    public static List<String> getCompliance(String did)
    {
         return WrapperUtils.getComplianceCalculation(did,String.valueOf(System.today().year()));
        //return null;
    }
    @RemoteAction
    public static List<String> getPacketandMeeting(String did)
    {
        return WrapperUtils.getPacketandMeetingDetails(did);
    }   

    @RemoteAction
    public static String readFromFileInchunk(String attachmentBody, String attachmentName, String attachmentId,String did,String accid,String contactattachementid)
    {
         return  WrapperUtils.readFromFileInchunk(attachmentBody,attachmentName,attachmentId,did,accid,contactattachementid); 
    }  
}