/**
@author Natavar Ghodasara
@date 26th Feb 2019
@description DriverDashboardController is used to show/edit Employee details.
*/
public class DriverDashboardController 
{
    public static String query;
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String contactDataAsString {get; set;}
    public static String gaspriceforpreviosmonth {get; set;}
   
    public static String currentDriverDetails {get;set;}
    public List<Attachment> driverInsuranceAttachmentList {get;set;}
    public List<Attachment> driverPacketAttachmentList {get;set;}
    public Integer insuranceSize {get;set;}
    public Integer packetSize {get;set;}
    public static Boolean showlastyear {get;set;}
    public static String logoDocument_id {get;set;}
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description RosterController is Default Constructor.    
    */
    public DriverDashboardController() 
    {
        List<contact> currentDriverList = new List<contact>();
        currentDriverDetails = getDriverDetails();
        if(currentDriverDetails!=null)
        {
            System.debug('sdhjahsdhaksh'+JSON.deserialize(currentDriverDetails,List<Contact>.Class));
            currentDriverList = (List<Contact>)JSON.deserialize(currentDriverDetails,List<Contact>.Class);
        }
        if(currentDriverList.size()>0)
        {
            gaspriceforpreviosmonth = WrapperUtils.getDriverGasPrice(currentDriverList[0].MailingState,currentDriverList[0].MailingCity);
        }
        driverInsuranceAttachmentList = new List<Attachment>();
        driverPacketAttachmentList = new List<Attachment>();
        if(currentDriverList!=null && currentDriverList[0]!=null && currentDriverList[0].Insurance_Attachment_Id__c!=null)
        {
            driverInsuranceAttachmentList = [select id,Body,Name from Attachment where id=:currentDriverList[0].Insurance_Attachment_Id__c limit 1];    
        }        
        insuranceSize = driverInsuranceAttachmentList.size();
        driverPacketAttachmentList = [select id,Body,Name from Attachment where ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Driver_Packet%' limit 1];
        packetSize = driverPacketAttachmentList.size();
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
        //getpastYearReimbursement();
       return String.escapeSingleQuotes(WrapperUtils.getpastYearReimbursement(getContactid()));
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
    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {         
        return String.escapeSingleQuotes(WrapperUtils.getDriverGasPrice(MailingState,MailingCity));
    }
    public static String getDriverDetails()
    {
        return getDriverDetailsClone(getContactid());
    }
    @RemoteAction
    public static String getDriverDetailsClone(String contactid)
    {            
        List<contact> driverDataList = new List<contact>();

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
            driverDataList.add(newContact);
        }
                
        return JSON.serialize(driverDataList).unescapeHtml4();
    }
    @RemoteAction
    public static List<String> getMileages(String clickedMonth,String year,String did)
    {
        return WrapperUtils.getMileages1(clickedMonth,year,did);
       //return null;
    }    
   
    @RemoteAction
    public static String readFromFileInchunk(String attachmentBody, String attachmentName, String attachmentId,String did,String accid,String contactattachementid)
    {
        return  WrapperUtils.readFromFileInchunk(attachmentBody,attachmentName,attachmentId,did,accid,contactattachementid);   
    }
    @RemoteAction
    public static List<String> getCompliance(String did)
    {
        return WrapperUtils.getComplianceCalculation(did,String.valueOf(System.today().year()));
        
    }
    @RemoteAction
    public static List<String> getPacketandMeeting(String did)
    {
        return WrapperUtils.getPacketandMeetingDetails(did);
    }   


    @RemoteAction
    public static String getdriverInsurance(string attachmentid) {        
        query = 'select id,Body,Name from Attachment where id= \''+attachmentid+'\'';      
        return String.escapeSingleQuotes(JSON.serialize((List<Attachment>)ExecuteQueryUtil.getRecordListFromsObject(query)));
    }
   
}