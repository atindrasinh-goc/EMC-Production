/**
@author Natavar Ghodasara
@date 29th March 2019
@description DriverManagerDetailsController is used to show/edit Employee details.
*/
public with sharing class DriverManagerDriverDetailsController 
{
    public static String query;
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String contactDataAsString {get; set;}
    public static String gaspriceforpreviosmonth {get; set;}
    public static List<contact> obj_currect_contact {get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public static String obj_current_contact_details {get;set;}
    public List<Attachment> obj_driver_insurance {get;set;}
    public List<Attachment> obj_driver_driverpacket {get;set;}
    public Integer obj_attachementsize {get;set;}
    public Integer obj_driverpacket_attachementsize {get;set;}
    public static Boolean showlastyear {get;set;}
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description RosterController is Default Constructor.    
    */
    public DriverManagerDriverDetailsController() 
    {
        obj_currect_contact = new List<contact>();
        obj_current_contact_details = getDriverDetails();
        setEmployeeName();
        System.debug('obj_currect_contact:--'+obj_currect_contact);
        if(obj_currect_contact.size()>0)
        {
            gaspriceforpreviosmonth = getDriverGasPrice(obj_currect_contact[0].MailingState,obj_currect_contact[0].MailingCity);
            System.debug('gaspriceforpreviosmonth:--'+gaspriceforpreviosmonth);
        }
        obj_driver_insurance = new List<Attachment>();
        obj_driver_driverpacket = new List<Attachment>();
        obj_driver_insurance = [SELECT id, Body, Name FROM Attachment WHERE ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Insurance%' limit 1];
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
    public static String getManagerid()
    {
        
        if(ApexPages.currentPage().getParameters().containsKey('manid'))
        {
           return ApexPages.currentPage().getParameters().get('manid');
        }
        else
        {
            return '';
        } 
    }
    public static PageReference getRedirected()
    {
        
        if(getAccountid()!='' && getDriverid()!='' && getManagerid()!='')
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
        Contact employee= [SELECT Name, External_Email__c FROM Contact WHERE id =: getManagerid()];
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
        // getpastYearReimbursement();
        // return WrapperUtils.getLast2Years();
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
        obj_currect_contact = [SELECT Id, Name, MailingPostalCode, MailingState, MailingCity, 
                                        Fixed_Amount__c, compliancestatus__c, Car_Image__c,
                                        Account.Name, Account.Logo_Document_Id__c, Vehicle_Type__c 
                                    FROM Contact 
                                    WHERE id =: getDriverid()];
        System.debug('obj_currect_contact:--'+obj_currect_contact);
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
    public static String getReimbursementsListClone(String driverid)
    {
       return String.escapeSingleQuotes(WrapperUtils.getReimbursementsListClone(driverid));
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
   /* @RemoteAction
    public static List<Attachment> getPacketAttachment(String did)
    {
        return WrapperUtils.getPacketAttachments(did);
    }*/
}