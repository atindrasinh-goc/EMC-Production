/**
@author Natavar Ghodasara
@date 26th Feb 2019
@group Wrapper
@group-content WrapperDetails.html
@description WrapperUtils is used to show/edit Employee details and other Utility features.
Before deploy to production uncomment this batch ChangeTripStatusinTripLog.
*/
public with sharing class WrapperUtils 
{
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description Default Constructor.
    */
    public WrapperUtils() 
    {
        
    }
    public static string getChartData(String contactId,boolean showTeamRecord,String accountId,String role)
    {
       
        List<Employee_Reimbursement__c> reimbursementList = new List<Employee_Reimbursement__c>();
        if(showTeamRecord == true && (role == 'Admin' || role == StaticValues.roleAdminDriver)) // || role=='Admin/Driver'
        {
            reimbursementList =[Select ID,Total_Mileage__c,Status__c,Month__c from Employee_Reimbursement__c where Contact_Id__r.Accountid =:accountId  and (Month__c=:WrapperUtils.getLastMonthValue(-1) OR Month__c=:WrapperUtils.getLastMonthValue(-2) OR Month__c=:WrapperUtils.getLastMonthValue(-3))];
        }
        else if(showTeamRecord == false && (role=='Admin' || role == StaticValues.roleAdminDriver)) // || role=='Admin/Driver'
        {
            reimbursementList =[Select ID,Total_Mileage__c,Status__c,Month__c from Employee_Reimbursement__c where (Contact_Id__r.Manager__c =:contactId OR (Contact_Id__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId)) and (Month__c=:WrapperUtils.getLastMonthValue(-1) OR Month__c=:WrapperUtils.getLastMonthValue(-2) OR Month__c=:WrapperUtils.getLastMonthValue(-3))];
            
        }
        else if(showTeamRecord == true && (role=='Manager' || role=='Driver/Manager'))
        {
            reimbursementList =[Select ID,Total_Mileage__c,Status__c,Month__c from Employee_Reimbursement__c where (Contact_Id__r.Manager__c =:contactId OR (Contact_Id__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId)) and (Month__c=:WrapperUtils.getLastMonthValue(-1) OR Month__c=:WrapperUtils.getLastMonthValue(-2) OR Month__c=:WrapperUtils.getLastMonthValue(-3))];
        }
        else if(showTeamRecord == false && (role=='Manager' || role=='Driver/Manager'))
        {
            reimbursementList =[Select ID,Total_Mileage__c,Status__c,Month__c from Employee_Reimbursement__c where Contact_Id__r.Manager__c =:contactId and (Month__c=:WrapperUtils.getLastMonthValue(-1) OR Month__c=:WrapperUtils.getLastMonthValue(-2) OR Month__c=:WrapperUtils.getLastMonthValue(-3))];
           
        }  

        return JSON.serialize(reimbursementList);
      
    }

    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getEmployeeDetails is used to built EmployeeDetails Wrapper object from Contact.
    @param currentContact currentContact is the Single Contact from which you want to Built Wrapper. 
    @return EmployeeDetails built by the method.
    */
    public static EmployeeDetails getEmployeeDetails(Contact currentContact)
    {
        system.debug('getEmployeeDetails');
        EmployeeDetails currentEmployeeDetail = new EmployeeDetails();
        if(currentContact.id  !=  null) {
            currentEmployeeDetail.userid=currentContact.id;    
        } else {
            currentEmployeeDetail.userid= '';
        }

        if(currentContact.firstName  !=  null) {
            system.debug('currentContact.firstName'+currentContact.firstName);
            currentEmployeeDetail.firstName=currentContact.firstName;  
            currentEmployeeDetail.name = currentEmployeeDetail.firstName;  
        } else {
            currentEmployeeDetail.firstName= '';
            currentEmployeeDetail.name = '';
        }
        currentEmployeeDetail.IsDeactivated=currentContact.IsDeactivated__c;
        if(currentContact.lastName  !=  null) {
            currentEmployeeDetail.lastName=currentContact.lastName;
            currentEmployeeDetail.name = currentEmployeeDetail.name + ' '+ currentContact.lastName;   
        } else {
            currentEmployeeDetail.lastName= '';
            
        }
        if(currentContact.Phone  !=  null) {
            currentEmployeeDetail.cellphone=currentContact.Phone;
               
        } else {
            currentEmployeeDetail.cellphone= '';
            
        }
        if(String.IsNotBlank(currentContact.Branch_Name__c)) {
            currentEmployeeDetail.branchName=currentContact.Branch_Name__c;
               
        } else {
            currentEmployeeDetail.branchName= '';
            
        }
        if(String.IsNotBlank(String.valueOf(currentContact.Branch_Number__c))) {
            currentEmployeeDetail.branchNumber=String.valueOf(currentContact.Branch_Number__c);
               
        } else {
            currentEmployeeDetail.branchNumber= '';
            
        }
        if(currentContact.MobilePhone  !=  null) {
            currentEmployeeDetail.cellphone=currentContact.MobilePhone;
               
        } else {
            currentEmployeeDetail.cellphone= '';
            
        }
        if(currentContact.App__c!=null)
        {
            currentEmployeeDetail.appVersion = currentContact.App__c;
        }
        else
        {
            currentEmployeeDetail.appVersion ='';
        }
        if(currentContact.compliancestatus__c!=null)
        {
            currentEmployeeDetail.compliancestatus = currentContact.compliancestatus__c;
        }
        else {
            currentEmployeeDetail.compliancestatus ='';
        }

        if(String.isNotBlank(String.valueOf(currentContact.Monthly__c)))
        {
            currentEmployeeDetail.monthlymileage = String.valueOf(currentContact.Monthly__c);
        }
        else {
            currentEmployeeDetail.monthlymileage ='';
        }

        if(currentContact.Sage_100_ID__c!=null)
        {
            currentEmployeeDetail.sage100ID = currentContact.Sage_100_ID__c;
        }
        else {
            currentEmployeeDetail.sage100ID ='';
        }

        if(currentContact.GL_Code__c != null)
        {
            currentEmployeeDetail.glcode = currentContact.GL_Code__c;
        }
        else {
            currentEmployeeDetail.glcode ='';
        }

        if(currentContact.Total_Reimbursement__c!=null)
        {
            currentEmployeeDetail.totalreimbursement=String.valueOf(currentContact.Total_Reimbursement__c);
        }
        else 
        {
            currentEmployeeDetail.totalreimbursement='';
        }
        if(String.isNotBlank(String.valueOf(currentContact.Monthly_Mileage_Limit__c)))
        {
            currentEmployeeDetail.monthlymileageLimit =String.valueOf(currentContact.Monthly_Mileage_Limit__c);
            currentEmployeeDetail.approvalThreshold = String.valueOf(currentContact.Monthly_Mileage_Limit__c);
        }
        else {
            currentEmployeeDetail.monthlymileageLimit = '';
            currentEmployeeDetail.approvalThreshold = '';
        }
        if(String.isNotBlank(String.valueOf(currentContact.Fixed_Amount__c)))
        {
            currentEmployeeDetail.fixedamount =String.valueOf(currentContact.Fixed_Amount__c);
        }
        else {
            currentEmployeeDetail.fixedamount = '';
        }
        if(currentContact.MailingPostalCode  !=  null) {
            currentEmployeeDetail.zipCode = String.valueOf(currentContact.MailingPostalCode);
        } 

        if(currentContact.MailingCity  !=  null) {
            currentEmployeeDetail.city=currentContact.MailingCity;    
        } else {
            currentEmployeeDetail.city= '';
        }

        if(currentContact.MailingState  !=  null) {
            currentEmployeeDetail.state=currentContact.MailingState;    
        } else {
            currentEmployeeDetail.state= '';
        }

        if(currentContact.Employee_ID__c  !=  null && currentContact.Employee_ID__c  !=  '') {
            currentEmployeeDetail.employeeId=currentContact.Employee_ID__c;    
        } else {
            currentEmployeeDetail.employeeId= '';
        }

        if(currentContact.Role__c  !=  null && currentContact.Role__c  !=  '') {
            currentEmployeeDetail.role=currentContact.Role__c;    
        }
        
        currentEmployeeDetail.managerId=currentContact.Manager__c;    
        //currentEmployeeDetail.managerId=currentContact.Manager__c;    
        
        if(currentContact.email != null)
        {
            currentEmployeeDetail.email =currentContact.email;
        }
        else
        {
            currentEmployeeDetail.email =currentContact.External_Email__c;
        }
        
        if(currentContact.Manager__r.Name  !=  null) {
            currentEmployeeDetail.managerName=currentContact.Manager__r.Name;    
        } else {
            currentEmployeeDetail.managerName= '';
        }

        currentEmployeeDetail.activationDate = currentContact.Activation_Date__c  !=  null ? currentContact.Activation_Date__c.format() : '';
        currentEmployeeDetail.vehicalType =currentContact.Vehicle_Type__c;
        if(currentContact.Deactivated_Date__c  !=  null)
        {
            currentEmployeeDetail.deactivaedDate = String.valueOf(currentContact.Deactivated_Date__c.month())+'/'+String.valueOf(currentContact.Deactivated_Date__c.day())+'/'+String.valueOf(currentContact.Deactivated_Date__c.year());
        }
        else
        {
            currentEmployeeDetail.deactivaedDate = null;
        }
        if(currentContact.Last_Pay_Date__c  !=  null)
        {
            currentEmployeeDetail.lastPayDate = String.valueOf(currentContact.Last_Pay_Date__c.month())+'/'+String.valueOf(currentContact.Last_Pay_Date__c.day())+'/'+String.valueOf(currentContact.Last_Pay_Date__c.year());
        }
        else
        {
            currentEmployeeDetail.lastPayDate = null;
        }

        if(currentContact.Added_Date__c  !=  null)
        {
            currentEmployeeDetail.addedDate = String.valueOf(currentContact.Added_Date__c.month())+'/'+String.valueOf(currentContact.Added_Date__c.day())+'/'+String.valueOf(currentContact.Added_Date__c.year());
        }
        else
        {
            currentEmployeeDetail.addedDate = null;
        }

        // if(String.isNotBlank(String.valueOf(currentContact.Monthly_Mileage_Limit__c) ))
        // {
        //     currentEmployeeDetail.approvalThreshold = String.valueOf(currentContact.Monthly_Mileage_Limit__c);
        // }
        if(currentContact.Driving_States__c != null)
        {
            List<String> drivingStatesSplitted = new list<String>();
            if(currentContact.Driving_States__c.contains(';'))
            {                   
                for(String objdrivingstate:currentContact.Driving_States__c.split(';'))
                {
                    drivingStatesSplitted.add(objdrivingstate.trim());
                }
            }
            else
            {                   
                drivingStatesSplitted.add(currentContact.Driving_States__c);
            }
            currentEmployeeDetail.drivingStates = drivingStatesSplitted; 
        }
        else
        {
            currentEmployeeDetail.drivingStates =null;
        }
        currentEmployeeDetail.resetReimbursementLink=false;
        return currentEmployeeDetail;       
    }

    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getContact is used to built Contact from EmployeeDetails Wrapper object.
    @param currentEmployeeDetail currentEmployeeDetail is the Single EmployeeDetails from which you want to Built Contact. 
    @return Contact built by the method.
    */
    public static Contact getContact(EmployeeDetails currentEmployeeDetail)
    {
        Contact currentContact = new Contact();
        currentContact.id=currentEmployeeDetail.userid;
        currentContact.firstname=currentEmployeeDetail.firstName;
        currentContact.lastname = currentEmployeeDetail.lastName;
        currentContact.email =currentEmployeeDetail.email;
        currentContact.External_Email__c = currentEmployeeDetail.email;
        currentContact.MailingPostalCode =String.valueOf(currentEmployeeDetail.zipCode);
        currentContact.MailingCity = currentEmployeeDetail.city;
        currentContact.MailingState = currentEmployeeDetail.state;
        currentContact.Employee_ID__c = currentEmployeeDetail.employeeId;
        if(currentEmployeeDetail.appVersion!=null)
        {    
            currentContact.App__c = currentEmployeeDetail.appVersion;
        }
        if(currentEmployeeDetail.cellphone!=null)
        {
            currentContact.Phone = currentEmployeeDetail.cellphone;
        }
        
        if(currentEmployeeDetail.activationDate != null)
        {
           // currentContact.Activation_Date__c = currentEmployeeDetail.activationDate;    
        }
        if(currentEmployeeDetail.compliancestatus!=null)
        {
            currentContact.compliancestatus__c = currentEmployeeDetail.compliancestatus;
        }
        if(String.isNotBlank(String.valueOf(currentEmployeeDetail.monthlymileageLimit)))
        {
            currentContact.Monthly_Mileage_Limit__c =Decimal.valueOf(currentEmployeeDetail.monthlymileageLimit);
        }
        if(String.isNotBlank(String.valueOf(currentEmployeeDetail.fixedamount)))
        {
            currentContact.Fixed_Amount__c =Decimal.valueOf(currentEmployeeDetail.fixedamount);
        }
        currentContact.IsDeactivated__c = currentEmployeeDetail.IsDeactivated;
        currentContact.Role__c = currentEmployeeDetail.role;
        currentContact.Manager__c = currentEmployeeDetail.managerId;
        currentContact.Vehicle_Type__c = currentEmployeeDetail.vehicalType;
        if(currentEmployeeDetail.lastPayDate  !=  null)
        {
            List<String> lastPaydateSplitted = new List<String>();
            if((String.valueOf(currentEmployeeDetail.lastPayDate).contains('-')))
            {
                lastPaydateSplitted = String.valueOf(currentEmployeeDetail.lastPayDate).split('-');                
            }
            else if(String.valueOf(currentEmployeeDetail.lastPayDate).contains('/'))
            {
                lastPaydateSplitted = String.valueOf(currentEmployeeDetail.lastPayDate).split('/');                
            }
            currentContact.Last_Pay_Date__c = Date.newInstance(Integer.valueOf(lastPaydateSplitted[2]), Integer.valueOf(lastPaydateSplitted[0]), Integer.valueOf(lastPaydateSplitted[1]));       
            //currentContact.Last_Pay_Date__c = date.parse(currentEmployeeDetail.lastPayDate);
        }
        else
        {
            currentContact.Last_Pay_Date__c =null;
        }

        if(currentEmployeeDetail.monthlymileage !=null && currentEmployeeDetail.monthlymileage != '')
        {
            //currentEmployeeDetail.monthlymileage = String.valueOf(currentContact.Monthly__c);
            currentContact.Monthly__c = Decimal.valueOf(currentEmployeeDetail.monthlymileage);
        }

        if(currentEmployeeDetail.sage100ID != null && currentEmployeeDetail.sage100ID != '')
        {
            currentContact.Sage_100_ID__c = currentEmployeeDetail.sage100ID;
        }

        if(currentEmployeeDetail.glcode != null && currentEmployeeDetail.glcode != '')
        {
            currentContact.GL_Code__c = currentEmployeeDetail.glcode;
        }

        if(currentEmployeeDetail.deactivaedDate  !=  null)
        {
            List<String> deactivationDateSplitted = new List<String>();
            if(String.valueOf(currentEmployeeDetail.deactivaedDate).contains('-'))
            {
                deactivationDateSplitted = String.valueOf(currentEmployeeDetail.deactivaedDate).split('-');
            }
            else if((String.valueOf(currentEmployeeDetail.deactivaedDate).contains('/')))
            {
                deactivationDateSplitted = String.valueOf(currentEmployeeDetail.deactivaedDate).split('/');                
            }
            currentContact.Deactivated_Date__c = Datetime.newInstance(Integer.valueOf(deactivationDateSplitted[2]), Integer.valueOf(deactivationDateSplitted[0]), Integer.valueOf(deactivationDateSplitted[1]),0,0,0);           
            //currentContact.Deactivated_Date__c = date.parse(currentEmployeeDetail.deactivaedDate);
        }
        else
        {
            currentContact.Deactivated_Date__c =null;
        }
        if(currentEmployeeDetail.drivingStates != null && currentEmployeeDetail.drivingStates.size()>0)
        {
            String state='';
            for(String currentState:currentEmployeeDetail.drivingStates)
            {
                if(state != '')
                {
                   state=state+ ';'+currentState;
                }
                else
                {
                   state = currentState;
                }
            }
            currentContact.Driving_States__c =state; 
        }
        return currentContact;      
    }
    /*public static Employee_Mileage__c getMileagesfromEmployeeMileages(EmployeeMileages employeeMileage)
    {
        Employee_Mileage__c currentEmployeeMileage = new Employee_Mileage__c();
        currentEmployeeMileage.id=employeeMileage.id;
        if(employeeMileage.isSelected == true)
        {
            currentEmployeeMileage.Approved_Date__c = System.today();
            currentEmployeeMileage.Trip_Status__c = 'Approved';
            currentEmployeeMileage.Rejected__c = false;
        }
        if(employeeMileage.isChecked == true)
        {
            currentEmployeeMileage.Trip_Status__c ='Rejected';
            currentEmployeeMileage.Approved_Date__c =null;
            currentEmployeeMileage.Rejected__c = true;
        }        
        return currentEmployeeMileage;
    }*/

    public static EmployeeMileages getMileagesOfReimbursement(Employee_Mileage__c employeeMileage)
    {
        EmployeeMileages currentEmployeeMileage = new EmployeeMileages();
        currentEmployeeMileage.id=employeeMileage.id;
        currentEmployeeMileage.isSelected = false;
        currentEmployeeMileage.isChecked = false;
        if(employeeMileage.Trip_Status__c != null)
        {
            currentEmployeeMileage.status = employeeMileage.Trip_Status__c;    
        }

        if(employeeMileage.Maintenance_and_Tires__c != null){
            currentEmployeeMileage.maintTyre = string.valueof(employeeMileage.Maintenance_and_Tires__c);
        }

        if(employeeMileage.Fuel_price__c != null){
            currentEmployeeMileage.fuelRate = string.valueof(employeeMileage.Fuel_price__c);
        }

        if(employeeMileage.EmployeeReimbursement__r.Total_Variable_Rate__c != null){
            currentEmployeeMileage.variablerate = string.valueof(employeeMileage.EmployeeReimbursement__r.Total_Variable_Rate__c);
        }

        currentEmployeeMileage.dayofweek='';
        currentEmployeeMileage.starttime='';
        currentEmployeeMileage.endtime='';
        currentEmployeeMileage.originname='';
        currentEmployeeMileage.destinationname='';
        currentEmployeeMileage.tracingstyle='';
        currentEmployeeMileage.emailaddress='';
        if(employeeMileage.Origin_Name__c != null)
        {
            currentEmployeeMileage.originname= employeeMileage.Origin_Name__c;
        }
        if(employeeMileage.Notes__c != null){ 
            currentEmployeeMileage.notes = employeeMileage.Notes__c;
        }
        if(employeeMileage.Tracing_Style__c != null)
        {
            currentEmployeeMileage.tracingstyle=employeeMileage.Tracing_Style__c;
        }
        if(employeeMileage.StartTime__c != null)
        {
           
           DateTime startTime = employeeMileage.StartTime__c;
           currentEmployeeMileage.starttime=startTime.formatGMT('h:mm a');
        }
        if(employeeMileage.EndTime__c != null)
        {
           //currentEmployeeMileage.endtime=employeeMileage.EndTime__c;
           DateTime endTime = employeeMileage.EndTime__c;
           currentEmployeeMileage.endtime=endTime.formatGMT('h:mm a');
        }
        if(employeeMileage.Day_Of_Week__c != null)
        {
            currentEmployeeMileage.dayofweek=employeeMileage.Day_Of_Week__c;
        }
        if(employeeMileage.Destination_Name__c != null)
        {
            currentEmployeeMileage.destinationname=employeeMileage.Destination_Name__c;
        }
        /* if(employeeMileage.EmployeeReimbursement__r.Contact_Id__r.External_Email__c != null)
        {*/
            currentEmployeeMileage.emailaddress=employeeMileage.EmployeeReimbursement__r.Contact_Id__r.External_Email__c;
        /* }     */  
        if(employeeMileage.Trip_Status__c != null && employeeMileage.Trip_Status__c == 'Rejected')
        {
             currentEmployeeMileage.isChecked = true;
        }        
        currentEmployeeMileage.origin = employeeMileage.Trip_Origin__c;
        currentEmployeeMileage.destination = employeeMileage.Trip_Destination__c;
        if(employeeMileage.Trip_Date__c != null)
        {
            if(String.valueOf(employeeMileage.Trip_Date__c).contains('-'))
            {
                List<String> tripDateSplitted = new List<String>();
                tripDateSplitted = String.valueOf(employeeMileage.Trip_Date__c).split('-');
                currentEmployeeMileage.tripdate  = tripDateSplitted[1]+'/'+tripDateSplitted[2]+'/'+tripDateSplitted[0].substring(2,4);
            }
        }
        currentEmployeeMileage.mileage  = String.valueOf(employeeMileage.Mileage__c);

        if(employeeMileage.Approved_Date__c != null)
        {
           if(String.valueOf(employeeMileage.Approved_Date__c).contains('-'))
           {
                List<String> approveDateSplitted = new List<String>();
                approveDateSplitted = String.valueOf(employeeMileage.Approved_Date__c).split('-');
                currentEmployeeMileage.approveddate  = approveDateSplitted[1]+'/'+approveDateSplitted[2]+'/'+approveDateSplitted[0].substring(2,4);
           }
        }
        Date createddate = Date.valueOf(employeeMileage.CreatedDate);
        if(String.valueOf(createddate).contains('-'))
        {
            List<String> createdDateSplitted = new List<String>();
            createdDateSplitted = String.valueOf(createddate).split('-');
            /*List<String> obj_dates = new List<String>();
            obj_dates = obj_List[0].split('-');*/
            currentEmployeeMileage.submitteddate =  createdDateSplitted[1]+'/'+createdDateSplitted[2]+'/'+createdDateSplitted[0].substring(2,4);
        }
        currentEmployeeMileage.totalrejected = String.valueOf(employeeMileage.EmployeeReimbursement__r.Total_Rejected__c);
        currentEmployeeMileage.totalMileages = String.valueOf(employeeMileage.EmployeeReimbursement__r.Total_Mileage__c);
        currentEmployeeMileage.totalpending = String.valueOf(employeeMileage.EmployeeReimbursement__r.Total_Pending__c);
        currentEmployeeMileage.variableamount  = String.valueOf(employeeMileage.Variable__c);
        currentEmployeeMileage.month  = employeeMileage.EmployeeReimbursement__r.month__c;
        currentEmployeeMileage.reimbursementid  = employeeMileage.EmployeeReimbursement__c;
        currentEmployeeMileage.driverid = employeeMileage.EmployeeReimbursement__r.Contact_Id__c;
        return currentEmployeeMileage;
    }
    public static Contact getNewContact(EmployeeDetails currentEmployeeDetail)
    {
        Contact currentContact = new Contact();       
        currentContact.firstname=currentEmployeeDetail.firstName;
        currentContact.lastname = currentEmployeeDetail.lastName;
        currentContact.email =currentEmployeeDetail.email;
        currentContact.External_Email__c = currentEmployeeDetail.email;
        currentContact.MailingPostalCode =String.valueOf(currentEmployeeDetail.zipCode);
        currentContact.MailingCity = currentEmployeeDetail.city;
        currentContact.MailingState = currentEmployeeDetail.state;
        currentContact.Employee_ID__c = currentEmployeeDetail.employeeId;
        currentContact.Pay_Number__c = '3';
        currentContact.Batch_ID_Fixed__c = 'M351';
        currentContact.Adjust_Ded_Code_Fixed__c = 'MR';
        currentContact.Batch_Variable_ID__c = 'M352';
        currentContact.Adjust_Ded_Code_Variable__c = 'VR';
        currentContact.Special_Action__c = 'W';
        currentContact.IsCreatedFromCommunity__c = true;
        if(String.IsNotBlank(currentEmployeeDetail.branchName))
        {
            currentContact.Branch_Name__c =currentEmployeeDetail.branchName;
        }
        else 
        {
            currentContact.Branch_Name__c ='';
        }
         if(String.IsNotBlank(currentEmployeeDetail.branchNumber))
        {
            currentContact.Branch_Number__c = String.valueOf(currentEmployeeDetail.branchNumber);
        }
        else 
        {
            currentContact.Branch_Number__c ='';
        } 
        if(currentEmployeeDetail.cellphone!=null)
        {
            currentContact.Phone = currentEmployeeDetail.cellphone;
            currentContact.MobilePhone = currentEmployeeDetail.cellphone;
        }
        if(currentEmployeeDetail.activationDate != null && currentEmployeeDetail.activationDate != '')
        {
            List<String> activationDateSplitted = new List<String>();
            if(String.valueOf(currentEmployeeDetail.activationDate).contains('-'))
            {
                activationDateSplitted = String.valueOf(currentEmployeeDetail.activationDate).split('-');
            }
            else if((String.valueOf(currentEmployeeDetail.activationDate).contains('/')))
            {
                activationDateSplitted = String.valueOf(currentEmployeeDetail.activationDate).split('/');                
            }
            currentContact.Activation_Date__c =  Date.newInstance(Integer.valueOf(activationDateSplitted[2]), Integer.valueOf(activationDateSplitted[0]), Integer.valueOf(activationDateSplitted[1]));
        }
        if(currentEmployeeDetail.addedDate != null && currentEmployeeDetail.addedDate != '')
        {
            List<String> addedDateSplitted = new List<String>();
            if(String.valueOf(currentEmployeeDetail.addedDate).contains('-'))
            {
                addedDateSplitted = String.valueOf(currentEmployeeDetail.addedDate).split('-');
            }
            else if((String.valueOf(currentEmployeeDetail.addedDate).contains('/')))
            {
                addedDateSplitted = String.valueOf(currentEmployeeDetail.addedDate).split('/');                
            }
            currentContact.Added_Date__c =  Date.newInstance(Integer.valueOf(addedDateSplitted[2]), Integer.valueOf(addedDateSplitted[0]), Integer.valueOf(addedDateSplitted[1]));              
            
        }
        system.debug('currentEmployeeDetail.approvalThreshold'+currentEmployeeDetail.approvalThreshold);
        if((String.isNotBlank(currentEmployeeDetail.approvalThreshold) && currentEmployeeDetail.approvalThreshold.isNumeric()) || (String.isNotBlank(currentEmployeeDetail.approvalThreshold) && currentEmployeeDetail.approvalThreshold.contains('.') && (currentEmployeeDetail.approvalThreshold.countMatches('.') == 1 ) ))
        {
            system.debug('currentEmployeeDetail.approvalThreshold'+currentEmployeeDetail.approvalThreshold);
            currentContact.Monthly_Mileage_Limit__c = Decimal.valueOf(currentEmployeeDetail.approvalThreshold);    
        }
        currentContact.Role__c = currentEmployeeDetail.role;
        if(String.isNotBlank(currentEmployeeDetail.managerId))
        {
            currentContact.Manager__c = currentEmployeeDetail.managerId;   
        }
        
        if(currentEmployeeDetail.vehicalType!=null)
        {
            
            currentContact.Vehicle_Type__c = currentEmployeeDetail.vehicalType;
        }
        
        if(currentEmployeeDetail.accountId  !=  null && currentEmployeeDetail.accountId  !=  '') {
            currentContact.AccountID = currentEmployeeDetail.accountId;    
        }
        system.debug('currentEmployeeDetail.monthlymileagebefore'+currentEmployeeDetail.monthlymileage);
        if((String.isNotBlank(currentEmployeeDetail.monthlymileage) && currentEmployeeDetail.monthlymileage.isNumeric()) || (String.isNotBlank(currentEmployeeDetail.monthlymileage) && currentEmployeeDetail.monthlymileage.contains('.') && (currentEmployeeDetail.monthlymileage.countMatches('.') == 1 ) ))
        {
            system.debug('currentEmployeeDetail.monthlymileage'+currentEmployeeDetail.monthlymileage);
            //currentEmployeeDetail.monthlymileage = String.valueOf(currentContact.Monthly__c);
            currentContact.Monthly__c = Decimal.valueOf(currentEmployeeDetail.monthlymileage);
        }
    
        if(currentEmployeeDetail.sage100ID != null && currentEmployeeDetail.sage100ID != '')
        {
            currentContact.Sage_100_ID__c = currentEmployeeDetail.sage100ID;
        }
        
        if(currentEmployeeDetail.glcode != null && currentEmployeeDetail.glcode != '')
        {
            currentContact.GL_Code__c = currentEmployeeDetail.glcode;
        }

        if(currentEmployeeDetail.drivingStates != null && currentEmployeeDetail.drivingStates.size()>0)
        {
            String state='';
            for(String currentState : currentEmployeeDetail.drivingStates)
            {
                if(state != '')
                {
                   state=state+ ';'+currentState;
                }
                else
                {
                   state = currentState;
                }
            }
            currentContact.Driving_States__c =state; 
        }
        return currentContact;      
    }
   /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getEmployeeReimbursements is used to built EmployeeReimbursements from Employee_Reimbursement__c object.
    @param currentEmployeeReimbursement currentEmployeeReimbursement is the Single Employee_Reimbursement__c from which you want to Built EmployeeReimbursements. 
    @return EmployeeReimbursements built by the method.
    */
    public static EmployeeReimbursements getEmployeeReimbursements(Employee_Reimbursement__c currentEmployeeReimbursement)
    {
        EmployeeReimbursements employeeReimbursement = new EmployeeReimbursements();
        employeeReimbursement.employeeReimbursementId = currentEmployeeReimbursement.id;
        if(currentEmployeeReimbursement.Approved_Date__c != null)
        {
            if(String.valueOf(currentEmployeeReimbursement.Approved_Date__c).contains('-'))
            {
                List<String> approvedDateSplitted = new List<String>();
                approvedDateSplitted = String.valueOf(currentEmployeeReimbursement.Approved_Date__c).split('-');
                employeeReimbursement.approveddate  = approvedDateSplitted[1]+'/'+approvedDateSplitted[2]+'/'+approvedDateSplitted[0].substring(2,4);
            }            
        }
        if(currentEmployeeReimbursement.Status__c != null)
        {
            employeeReimbursement.status = currentEmployeeReimbursement.Status__c; 
        }
        employeeReimbursement.isSelected = false;       
        employeeReimbursement.variableRate  = String.valueOf(currentEmployeeReimbursement.Total_Variable_Rate__c);
        employeeReimbursement.month  = getMonthName(currentEmployeeReimbursement.Month__c);
        employeeReimbursement.intmonth  = getMonthInteger(currentEmployeeReimbursement.Month__c);
        employeeReimbursement.fuel  =String.valueOf(currentEmployeeReimbursement.Fuel_Price__c);
        employeeReimbursement.mileage  =String.valueOf(currentEmployeeReimbursement.Total_Mileage__c);
        String fixedandvariable ='';
        if(currentEmployeeReimbursement.Fixed_Amount__c != null)
        {
            fixedandvariable = '$' + String.valueOf(currentEmployeeReimbursement.Fixed_Amount__c)+' + ';
        }
        else
        {
            fixedandvariable = '$0 + ';
        }
        if(currentEmployeeReimbursement.Monthly_Variable_Amount__c != null)
        {
            fixedandvariable = fixedandvariable + ' $' + String.valueOf(currentEmployeeReimbursement.Monthly_Variable_Amount__c);
        }
        else
        {
            fixedandvariable  = fixedandvariable + '$0';
        }
        employeeReimbursement.varibleAndFixedReimbursements  = fixedandvariable;
        employeeReimbursement.totalReimbursements  =String.valueOf(currentEmployeeReimbursement.Total_Monthly_Reimbursement__c);
        return employeeReimbursement;
    }

    public static EmployeeReimbursementDetailsAdmin getEmployeeReimbursementDetails(Employee_Reimbursement__c currentEmployeeReimbursement)
    {   
        Double totalrejected =0;    
        EmployeeReimbursementDetailsAdmin employeeReimbursement = new EmployeeReimbursementDetailsAdmin();
        employeeReimbursement.id= currentEmployeeReimbursement.id;
        employeeReimbursement.contactid=currentEmployeeReimbursement.Contact_Id__c;
        employeeReimbursement.name = currentEmployeeReimbursement.Contact_Id__r.Name;
        employeeReimbursement.month = currentEmployeeReimbursement.Month__c;
        employeeReimbursement.threshold =String.valueOf( currentEmployeeReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c);
        employeeReimbursement.totalMileages = String.valueOf(currentEmployeeReimbursement.Total_Mileage__c);
        employeeReimbursement.approvedMileages = String.valueOf(currentEmployeeReimbursement.Total_Approved__c);
        employeeReimbursement.managerName = currentEmployeeReimbursement.Contact_Id__r.Manager__r.Name;
        employeeReimbursement.status = currentEmployeeReimbursement.Status__c;
        if(currentEmployeeReimbursement.Approved_Date__c != null)
        {
            // 2019-03-28
            if(String.valueOf(currentEmployeeReimbursement.Approved_Date__c).contains('-'))
            {
                List<String> approvedDateSplitted = new List<String>();
                approvedDateSplitted = String.valueOf(currentEmployeeReimbursement.Approved_Date__c).split('-');
                employeeReimbursement.approvedDate = approvedDateSplitted[1]+'/'+approvedDateSplitted[2]+'/'+approvedDateSplitted[0].substring(2,4);
            }
        }
        else
        {
            employeeReimbursement.approvedDate = '';
        }
        /*for(Employee_Mileage__c currentMileage:currentEmployeeReimbursement.Employees_Mileage__r)
        {
            totalrejected  = totalrejected+ Double.valueOf(currentMileage.Mileage__c);             
        }*/
        employeeReimbursement.rejectedMileages = String.valueOf(currentEmployeeReimbursement.Total_Rejected__c);
        employeeReimbursement.isSelected = false;
        return employeeReimbursement;
    }

    public static Employee_Reimbursement__c approveReimbursementofDriver(EmployeeReimbursements currentEmployeeReimbursement)
    {       
        Employee_Reimbursement__c currentReimbursement = new Employee_Reimbursement__c();
        currentReimbursement.id= currentEmployeeReimbursement.employeeReimbursementId;
        currentReimbursement.Status__c = 'Approved';
        currentReimbursement.Approved_Date__c = system.today();
        return currentReimbursement;
    }
     /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getMonthName is used get Month's name. Ex: 01 =>January.
    @param monthname monthname is the String value which is passed as string value of 01. 
    @return String as January.
    */
    public static String getMonthNamefromno(Integer monthname)
    {
        Map<Integer,String> monthNameMap=new Map<Integer, String>{01 =>'January', 02=>'February', 03=>'March', 04=>'April', 05=>'May',
                                                                    06=>'June', 07=>'July', 08=>'August', 09=>'September',10=>'October',
                                                                    11=>'November', 12=>'December'};
        return monthNameMap.get(monthname);
    }
    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getMonthName is used get Month's name. Ex: 01 =>January.
    @param monthname monthname is the String value which is passed as string value of 01. 
    @return String as January.
    */
    public static String getMonthName(String monthname)
    {
        Map<Integer,String> monthNameMap=new Map<Integer, String>{01 =>'January', 02=>'February', 03=>'March', 04=>'April', 05=>'May',
                                                                    06=>'June', 07=>'July', 08=>'August', 09=>'September',10=>'October',
                                                                    11=>'November', 12=>'December'};
        if(monthname.contains('-'))
        {
           return monthNameMap.get(Integer.valueOf((monthname.split('-')[0]))); 
        }
        return '';
    }
    
    
    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getMonthName is used get Month's Integer.
    @param monthname monthname is the String value which is passed as string value of 01. 
    @return String as January.
    */
    public static Integer getMonthInteger(String monthname)
    {
        
        if(monthname.contains('-'))
        {
           return Integer.valueOf( monthname.split('-')[0]); 
        }
        return 0;
    }
    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getMonthno is used get Month's No. Ex: January => 01.
    @param monthname monthname is the String value which is passed as January. 
    @return String as 01.
    */
    public static String getMonthno(String monthname)
    {
        Map<String,String> monthNameMap=new Map<String,String>{'January'=>'01', 'February'=>'02', 'March'=>'03', 'April'=>'04', 'May'=>'05',
                                                                    'June'=>'06', 'July'=>'07', 'August'=>'08', 'September'=>'09','October'=>'10',
                                                                    'November'=>'11', 'December'=>'12'};
        if(monthNameMap.containsKey(monthname))
        {
           return String.valueOf(monthNameMap.get(monthname));    
        }                                                            
        return '';
    }
    /**
    @author Natavar Ghodasara
    @date 22nd Jan 2019
    @description getMonthandYear is used get Month's No. Ex: January => 01 and then Proccess it with current year. Ex. : Current year is 2019 and you are passing month as parameter as string value Of 01
    @param clickedMonth clickedMonth is the String value which is passed as January. 
    @return String as 01-2019 where 2019 is the current year.
    */
    public static String getMonthandYear(String clickedMonth)
    {
        String month = getMonthno(clickedMonth);
        if(((month == '12') && (Date.today().month() == 12))||((month == '11')&&((Date.today().month() == 11) || (Date.today().month() == 12)))||((Integer.valueOf(month)<11)&&(Date.today().month()<11)))
        {
            month=month+'-'+String.valueOf(Date.today().year());
        }
        else if(((month == '12'|| month == '11') && (Date.today().month()<11)))
        {
            month=month+'-'+String.valueOf(Date.today().year()-1);
        }
        return month;
    }

    public static String getLastMonthValue(Integer value) {
        String todaysDate= date.today().addMonths(value).Month() + '-' + date.today().addMonths(value).Year();
        String lastMonth = todaysDate.left(2);
        if(lastMonth.contains('-')) {
            lastMonth = '0' + todaysDate;
        } else {
            lastMonth = todaysDate;
        }
        return lastMonth;
    }
    public static List<String> getPacketandMeetingDetails(String did)
    {
        List<String> driverPlanInfoList = new List<String>();
        List<Contact> currentDriver = new List<Contact>();
        currentDriver = [Select id,name,Meeting__c,Packet__c from Contact where id =:did];
        if(currentDriver.size()>0)
        {
           driverPlanInfoList.add(JSON.serialize(currentDriver));
        }
        return driverPlanInfoList;
    }

     public static List<string> getComplianceCalculation(String did,String year) 
    {
        system.debug('getComplianceCalculation'+did+ 'year'+year);
        Decimal totalmileages1=0;
        Double TotalActualReimbursements=0;
        Double MaximumAllowable=0;
        Double AnnualTaxLiability=0;

        Contact currentDriver=[SELECT id, name,FirstName, account.Motor_Vehicle_Record_Check_Document__c, email, Insurance_Attachment_Id__c, 
                                MVR_Attachment_Id__c,compliancestatus__c  FROM contact WHERE id =: did limit 1];   
      
        Map<integer,WrappperTax>  quaterWiseWrapperTaxMap = new map<integer,WrappperTax>();
        List<WrapperTaxReport> quaterWiseWrapperTaxList = new List<WrapperTaxReport>();
        Map<Integer,WrapperTaxReport> quaterWiseTaxReportMap = new Map<Integer,WrapperTaxReport>();
        List<WrapperTaxReport> taxSummaryReport = new List<WrapperTaxReport>();
        WrapperTaxReport currentDriverTaxReport = new WrapperTaxReport();
       
         List<String> complinceMonthList =  new List<String>();
        if(year == String.valueOf(System.today().Year()))
        {
            Integer month = System.Today().Month();
            complinceMonthList.add(String.valueOf(12)+'-'+(System.Today().year()-1));
            if(month==12)
            {
                month=11;
            }
            for(Integer i=1;i<=month;i++)
            {
                if(i<10)
                {
                    complinceMonthList.add('0'+String.valueOf(i)+'-'+year); 
                } 
                else if((i == 10)||(i == 11))
                {
                    complinceMonthList.add(String.valueOf(i)+'-'+year);
                }          
            }

        }
        else
        {
            complinceMonthList.add(String.valueOf(12)+'-'+(Integer.valueOf(year)-1));
            Integer month =11;
            for(Integer i=1;i<=month;i++)
            {
                if(i<10)
                {
                    complinceMonthList.add('0'+String.valueOf(i)+'-'+year); 
                } 
                else if((i == 10)||(i == 11))
                {
                    complinceMonthList.add(String.valueOf(i)+'-'+year);
                }          
            }

        }
        if(Test.isRunningTest())
        {
            complinceMonthList = null;
            complinceMonthList = new List<String>();
            for(Integer i=1;i<13;i++)
            {
                if(i<10)
                {
                    complinceMonthList.add('0'+String.valueOf(i)+'-'+System.Today().year());                    
                }
                else if(i==10 || i==11)
                {
                    complinceMonthList.add(String.valueOf(i)+'-'+System.Today().year());
                }
                else
                {
                    complinceMonthList.add('0'+String.valueOf(i)+'-'+String.valueOf((System.Today().year()-1)));
                }
            }            
        }
         
          WrappperTax wrapppertaxQuater1 = new WrappperTax();
          WrappperTax wrapppertaxQuater2 = new WrappperTax();
          WrappperTax wrapppertaxQuater3 = new WrappperTax();
          WrappperTax wrapppertaxQuater4 = new WrappperTax();

          List<WrappperTax> wrapppertaxList = new List<WrappperTax>();

          System.debug(complinceMonthList); 
          List<Employee_Reimbursement__c> reimbursementList= new List<Employee_Reimbursement__c>();
          reimbursementList=[SELECT id,Total_Mileage__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Contact_Id__r.Name,
                                    Contact_Id__r.Employee_ID__c,Contact_Id__r.External_Email__c,Month__c,Approved_Date__c,IRS_Mileage_Rate__c,IRS_Mileage_Rate__r.IRS_Rate__c,IRS_Mileage_Rate__r.year__c  
                            FROM Employee_Reimbursement__c 
                            WHERE Contact_Id__c =: currentDriver.id AND Month__c =: complinceMonthList AND Approved_Date__c != null];
           System.debug(reimbursementList); 
          for(Employee_Reimbursement__c currentReimbursement:reimbursementList)
          {
              List<String> riembursementMonthSplitted = new List<String>();
              if((currentReimbursement.Month__c != null)&&(currentReimbursement.Month__c.contains('-')) && currentReimbursement.IRS_Mileage_Rate__c !=null)
              {
                  riembursementMonthSplitted = currentReimbursement.Month__c.split('-');
                  if((Integer.valueOf(riembursementMonthSplitted[0]) == 12)||(Integer.valueOf(riembursementMonthSplitted[0])<=2))
                  {
                     if(quaterWiseWrapperTaxMap.containsKey(1))
                     {
                        wrapppertaxQuater1 =  quaterWiseWrapperTaxMap.get(1);
                     }
                      wrapppertaxQuater1.quarterno = 1;
                      if((wrapppertaxQuater1.Mileages != null))
                      {
                        Double mileageinDouble = wrapppertaxQuater1.Mileages;
                        if(currentReimbursement.Total_Mileage__c != null)
                        {
                            mileageinDouble = mileageinDouble + currentReimbursement.Total_Mileage__c;
                        }                                                   
                        Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                        mileageinDouble = mileageinDecimal.setScale(2);
                        wrapppertaxQuater1.Mileages = mileageinDouble; 
                      }
                      else
                      {  
                          if(currentReimbursement.Total_Mileage__c != null)
                          {
                              wrapppertaxQuater1.Mileages = currentReimbursement.Total_Mileage__c.setScale(2);
                          }                      
                      }
                      if((wrapppertaxQuater1.Reimbursements != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater1.Reimbursements;
                          if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                          {
                              mileageinDouble = mileageinDouble + currentReimbursement.Total_Monthly_Reimbursement__c;    
                          }                          
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater1.Reimbursements = mileageinDouble; 
                      }
                      else
                      {    
                        if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                        {
                            wrapppertaxQuater1.Reimbursements= currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2);
                        }                                            
                      }
                      if((wrapppertaxQuater1.MaxIRSrate != null))
                      {
                          Decimal mileageinDouble = wrapppertaxQuater1.MaxIRSrate;
                          if((currentReimbursement.Total_Mileage__c != null))
                          {
                              mileageinDouble = mileageinDouble + (((currentReimbursement.Total_Mileage__c)*(Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c))));                         
                          }                          
                          mileageinDouble = mileageinDouble.setScale(2);                          
                          wrapppertaxQuater1.MaxIRSrate = mileageinDouble; 
                      }
                      else
                      {
                        if((currentReimbursement.Total_Mileage__c != null))
                        {
                            wrapppertaxQuater1.MaxIRSrate = ((currentReimbursement.Total_Mileage__c)* Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));
                        }
                      }

                      Double imputedAmountinDouble = 0;
                      if(wrapppertaxQuater1.ImputedAmount != null)
                      {
                          imputedAmountinDouble =wrapppertaxQuater1.ImputedAmount;                      
                      }
                      if((currentReimbursement.Total_Monthly_Reimbursement__c != null) && (currentReimbursement.Total_Mileage__c != null))
                      {
                          imputedAmountinDouble = imputedAmountinDouble+ currentReimbursement.Total_Monthly_Reimbursement__c-((currentReimbursement.Total_Mileage__c)* Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));                          
                      }                      
                      Decimal imputedAmountinDecimal= Decimal.valueOf(imputedAmountinDouble);
                      imputedAmountinDouble = imputedAmountinDecimal.setScale(2);
                      wrapppertaxQuater1.ImputedAmount = imputedAmountinDouble;                       
                      quaterWiseWrapperTaxMap.put(1,wrapppertaxQuater1);
                     // quaterWiseWrapperTaxList.add(objw);
                  }
                  else if((Integer.valueOf(riembursementMonthSplitted[0])>=3)&&(Integer.valueOf(riembursementMonthSplitted[0])<=5))
                  {
                     if(quaterWiseWrapperTaxMap.containsKey(2))
                     {
                        wrapppertaxQuater2 =  quaterWiseWrapperTaxMap.get(2);
                     }
                      wrapppertaxQuater2.quarterno = 2;                      
                      if((wrapppertaxQuater2.Mileages != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater2.Mileages;
                          if(currentReimbursement.Total_Mileage__c != null)
                            {
                                mileageinDouble = mileageinDouble + currentReimbursement.Total_Mileage__c;
                            } 
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater2.Mileages = mileageinDouble;  
                      }
                      else
                      {
                        if(currentReimbursement.Total_Mileage__c != null)
                          {
                              wrapppertaxQuater2.Mileages = currentReimbursement.Total_Mileage__c.setScale(2);
                          }
                      }
                      if((wrapppertaxQuater2.Reimbursements != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater2.Reimbursements;
                          if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                          {
                              mileageinDouble = mileageinDouble + currentReimbursement.Total_Monthly_Reimbursement__c;    
                          }
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater2.Reimbursements = mileageinDouble; 
                      }
                      else
                      {
                         if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                        {
                            wrapppertaxQuater2.Reimbursements= currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2);
                        }
                      }
                      if((wrapppertaxQuater2.MaxIRSrate != null))
                      {
                          Decimal mileageinDouble =wrapppertaxQuater2.MaxIRSrate;
                          if((currentReimbursement.Total_Mileage__c != null))
                          {
                              mileageinDouble = mileageinDouble + (((currentReimbursement.Total_Mileage__c)*(Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c))));                         
                          }
                          mileageinDouble = mileageinDouble.setScale(2);                          
                          wrapppertaxQuater2.MaxIRSrate = mileageinDouble; 
                      }
                      else
                      {
                        wrapppertaxQuater2.MaxIRSrate = ((currentReimbursement.Total_Mileage__c)*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));
                      }
                      Double imputedAmountinDouble = 0;
                      if(wrapppertaxQuater2.ImputedAmount != null)
                      {
                          imputedAmountinDouble =wrapppertaxQuater2.ImputedAmount;                      
                      }
                      if((currentReimbursement.Total_Monthly_Reimbursement__c != null) && (currentReimbursement.Total_Mileage__c != null))
                      {
                          imputedAmountinDouble = imputedAmountinDouble+ currentReimbursement.Total_Monthly_Reimbursement__c-((currentReimbursement.Total_Mileage__c)*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));                          
                      }
                      Decimal imputedAmountinDecimal= Decimal.valueOf(imputedAmountinDouble);
                      imputedAmountinDouble = imputedAmountinDecimal.setScale(2);
                      wrapppertaxQuater2.ImputedAmount = imputedAmountinDouble;
                      quaterWiseWrapperTaxMap.put(2,wrapppertaxQuater2);
                  }
                  else if((Integer.valueOf(riembursementMonthSplitted[0])>=6)&&(Integer.valueOf(riembursementMonthSplitted[0])<=8))
                  {
                      if(quaterWiseWrapperTaxMap.containsKey(3))
                     {
                        wrapppertaxQuater3 =  quaterWiseWrapperTaxMap.get(3);
                     }
                      wrapppertaxQuater3.quarterno = 3;                      
                      if((wrapppertaxQuater3.Mileages != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater3.Mileages;
                          if(currentReimbursement.Total_Mileage__c != null)
                            {
                                mileageinDouble = mileageinDouble + currentReimbursement.Total_Mileage__c;
                            } 
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater3.Mileages = mileageinDouble; 
                      }
                      else
                      {
                        if(currentReimbursement.Total_Mileage__c != null)
                          {
                              wrapppertaxQuater3.Mileages = currentReimbursement.Total_Mileage__c.setScale(2);
                          }
                      }
                      if((wrapppertaxQuater3.Reimbursements != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater3.Reimbursements;
                          if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                          {
                              mileageinDouble = mileageinDouble + currentReimbursement.Total_Monthly_Reimbursement__c;    
                          }
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater3.Reimbursements = mileageinDouble; 
                      }
                      else
                      {
                        if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                        {
                            wrapppertaxQuater3.Reimbursements= currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2);
                        }
                      }
                      if((wrapppertaxQuater3.MaxIRSrate != null))
                      {
                          Decimal mileageinDouble =wrapppertaxQuater3.MaxIRSrate;
                          if((currentReimbursement.Total_Mileage__c != null))
                          {
                              mileageinDouble = mileageinDouble + (((currentReimbursement.Total_Mileage__c)*(Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c))));                         
                          }
                          mileageinDouble = mileageinDouble.setScale(2);                          
                          wrapppertaxQuater3.MaxIRSrate = mileageinDouble;  
                      }
                      else
                      {
                        wrapppertaxQuater3.MaxIRSrate = ((currentReimbursement.Total_Mileage__c)*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));
                      }
                      Double imputedAmountinDouble = 0;
                      if(wrapppertaxQuater3.ImputedAmount != null)
                      {
                          imputedAmountinDouble =wrapppertaxQuater3.ImputedAmount;                      
                      }
                      if((currentReimbursement.Total_Monthly_Reimbursement__c != null) && (currentReimbursement.Total_Mileage__c != null))
                      {
                          imputedAmountinDouble = imputedAmountinDouble+ currentReimbursement.Total_Monthly_Reimbursement__c-((currentReimbursement.Total_Mileage__c)* Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));                          
                      }
                      Decimal imputedAmountinDecimal= Decimal.valueOf(imputedAmountinDouble);
                      imputedAmountinDouble = imputedAmountinDecimal.setScale(2);
                      wrapppertaxQuater3.ImputedAmount = imputedAmountinDouble;
                      quaterWiseWrapperTaxMap.put(3,wrapppertaxQuater3);
                  }
                  else if((Integer.valueOf(riembursementMonthSplitted[0])>=9)&&(Integer.valueOf(riembursementMonthSplitted[0])<=11))
                  {
                      if(quaterWiseWrapperTaxMap.containsKey(4))
                     {
                        wrapppertaxQuater4 =  quaterWiseWrapperTaxMap.get(4);
                     }
                      wrapppertaxQuater4.quarterno = 4;                      
                      if((wrapppertaxQuater4.Mileages != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater4.Mileages;
                         if(currentReimbursement.Total_Mileage__c != null)
                          {
                            mileageinDouble = mileageinDouble + currentReimbursement.Total_Mileage__c;
                          } 
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater4.Mileages = mileageinDouble; 
                      }
                      else
                      {
                          if(currentReimbursement.Total_Mileage__c != null)
                          {
                              wrapppertaxQuater4.Mileages = currentReimbursement.Total_Mileage__c.setScale(2);
                          }
                      }
                      if((wrapppertaxQuater4.Reimbursements != null))
                      {
                          Double mileageinDouble = wrapppertaxQuater4.Reimbursements;
                          if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                          {
                              mileageinDouble = mileageinDouble + currentReimbursement.Total_Monthly_Reimbursement__c;    
                          }
                          Decimal mileageinDecimal= Decimal.valueOf(mileageinDouble);
                          mileageinDouble = mileageinDecimal.setScale(2);
                          wrapppertaxQuater4.Reimbursements = mileageinDouble; 
                      }
                      else
                      {
                        if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                        {
                            wrapppertaxQuater4.Reimbursements= currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2);
                        }
                      }
                      if((wrapppertaxQuater4.MaxIRSrate != null))
                      {
                          Decimal mileageinDouble =wrapppertaxQuater4.MaxIRSrate;
                          if((currentReimbursement.Total_Mileage__c != null))
                          {
                              mileageinDouble = mileageinDouble + (((currentReimbursement.Total_Mileage__c)*(Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c))));                         
                          }  
                          mileageinDouble = mileageinDouble.setScale(2);                          
                          wrapppertaxQuater4.MaxIRSrate = mileageinDouble; 
                      }
                      else
                      {
                        wrapppertaxQuater4.MaxIRSrate = ((currentReimbursement.Total_Mileage__c)*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));
                      }
                      Double imputedAmountinDouble = 0;
                      if(wrapppertaxQuater4.ImputedAmount != null)
                      {
                          imputedAmountinDouble =wrapppertaxQuater4.ImputedAmount;                      
                      }
                      if((currentReimbursement.Total_Monthly_Reimbursement__c != null) && (currentReimbursement.Total_Mileage__c != null))
                      {
                          imputedAmountinDouble = imputedAmountinDouble+ currentReimbursement.Total_Monthly_Reimbursement__c-((currentReimbursement.Total_Mileage__c)*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));                          
                      }
                      Decimal imputedAmountinDecimal= Decimal.valueOf(imputedAmountinDouble);
                      imputedAmountinDouble = imputedAmountinDecimal.setScale(2);
                      wrapppertaxQuater4.ImputedAmount = imputedAmountinDouble;
                      quaterWiseWrapperTaxMap.put(4,wrapppertaxQuater4);
                  }
                  if(currentReimbursement.Approved_Date__c != null)
                  {
                      WrapperTaxReport currentTaxReport = new WrapperTaxReport();
                      currentTaxReport.drivername= currentReimbursement.Contact_Id__r.Name;
                      currentTaxReport.employeeid =currentReimbursement.Contact_Id__r.Employee_ID__c;
                      currentTaxReport.emailid = currentReimbursement.Contact_Id__r.External_Email__c;
                      if(currentReimbursement.Total_Mileage__c != null)
                      {
                          currentTaxReport.approvedmileages = currentReimbursement.Total_Mileage__c.setScale(2);
                      }
                      else
                      {
                           currentTaxReport.approvedmileages = 0;
                      }
                      if(currentReimbursement.Total_Monthly_Reimbursement__c != null)
                      {
                          currentTaxReport.totalreim = currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2);
                      }
                      else
                      {
                           currentTaxReport.totalreim = 0;
                      }
                      if((currentReimbursement.Total_Mileage__c != null))
                      {
                          currentTaxReport.iRSallowable =(((currentReimbursement.Total_Mileage__c.setScale(2))*(Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c))));
                      }                      
                      if((currentReimbursement.Total_Monthly_Reimbursement__c  != null)&&(currentReimbursement.Total_Mileage__c != null))
                      {
                          currentTaxReport.imputedincome=(currentReimbursement.Total_Monthly_Reimbursement__c.setScale(2))-((currentReimbursement.Total_Mileage__c.setScale(2))*Double.valueOf(currentReimbursement.IRS_Mileage_Rate__r.IRS_Rate__c));
                      }
                      currentTaxReport.month =Integer.valueOf(riembursementMonthSplitted[0]);
                      currentTaxReport.year =String.valueOf(riembursementMonthSplitted[1]);
                      currentTaxReport.monthyear = getMonthNamefromno(Integer.valueOf(riembursementMonthSplitted[0]))+' '+String.valueOf(riembursementMonthSplitted[1]);
                      quaterWiseTaxReportMap.put(Integer.valueOf(riembursementMonthSplitted[0]),currentTaxReport);
                      //quaterWiseWrapperTaxList.add(objw);  

                      currentDriverTaxReport.drivername = currentReimbursement.Contact_Id__r.Name;
                      if(currentReimbursement.Contact_Id__r.Employee_ID__c != null)
                      {
                          currentDriverTaxReport.employeeid = currentReimbursement.Contact_Id__r.Employee_ID__c;
                      }
                      if(currentReimbursement.Contact_Id__r.External_Email__c != null)
                      {
                          currentDriverTaxReport.emailid = currentReimbursement.Contact_Id__r.External_Email__c;
                      }
                  }
              }
          }
          String message='';
          if(quaterWiseWrapperTaxMap.containsKey(1))
          {
              TotalActualReimbursements =quaterWiseWrapperTaxMap.get(1).Reimbursements;
              MaximumAllowable =  quaterWiseWrapperTaxMap.get(1).MaxIRSrate;
              AnnualTaxLiability =quaterWiseWrapperTaxMap.get(1).ImputedAmount; 
              if(quaterWiseWrapperTaxMap.get(1).Mileages != null)
              {
                 totalmileages1 = quaterWiseWrapperTaxMap.get(1).Mileages;
              } 
              if(totalmileages1>5000)
              {
                wrapppertaxQuater1 = quaterWiseWrapperTaxMap.get(1);
                wrapppertaxQuater1.ImputedAmount = 0;
                quaterWiseWrapperTaxMap.put(1,wrapppertaxQuater1);
                AnnualTaxLiability =0;
                if(quaterWiseTaxReportMap.containsKey(12))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(12);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(12,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(1))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(1);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(1,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(2))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(2);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(2,currentReimbursement);
                }
              }
          }
         
          if(quaterWiseWrapperTaxMap.containsKey(2))
          {
              TotalActualReimbursements =TotalActualReimbursements+quaterWiseWrapperTaxMap.get(2).Reimbursements;
              MaximumAllowable = MaximumAllowable  +quaterWiseWrapperTaxMap.get(2).MaxIRSrate;
              AnnualTaxLiability =AnnualTaxLiability+quaterWiseWrapperTaxMap.get(2).ImputedAmount;
              if(quaterWiseWrapperTaxMap.get(2).Mileages != null)
              {
                 totalmileages1 =totalmileages1+quaterWiseWrapperTaxMap.get(2).Mileages;
              }
              if(totalmileages1>5000)
              {
                if(quaterWiseWrapperTaxMap.containsKey(1))
                {
                  wrapppertaxQuater1 = quaterWiseWrapperTaxMap.get(1);
                  wrapppertaxQuater1.ImputedAmount = 0;
                  quaterWiseWrapperTaxMap.put(1,wrapppertaxQuater1);
                }
               
                wrapppertaxQuater2 = quaterWiseWrapperTaxMap.get(2);
                wrapppertaxQuater2.ImputedAmount = 0;
                quaterWiseWrapperTaxMap.put(2,wrapppertaxQuater2);
                AnnualTaxLiability =0;

                if(quaterWiseTaxReportMap.containsKey(12))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(12);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(12,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(1))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(1);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(1,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(2))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(2);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(2,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(3))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(3);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(3,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(4))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(4);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(4,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(5))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(5);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(5,currentReimbursement);
                }
              }  
          }
         
          if(quaterWiseWrapperTaxMap.containsKey(3))
          {
              TotalActualReimbursements =TotalActualReimbursements+quaterWiseWrapperTaxMap.get(3).Reimbursements;
              MaximumAllowable = MaximumAllowable  +quaterWiseWrapperTaxMap.get(3).MaxIRSrate;
              AnnualTaxLiability =AnnualTaxLiability+quaterWiseWrapperTaxMap.get(3).ImputedAmount; 
              if(quaterWiseWrapperTaxMap.get(3).Mileages != null)
              {
                totalmileages1 =totalmileages1+quaterWiseWrapperTaxMap.get(3).Mileages; 
              }
              
              if(totalmileages1>5000)
              {
                if(quaterWiseWrapperTaxMap.containsKey(1))
                {
                    wrapppertaxQuater1 = quaterWiseWrapperTaxMap.get(1);
                    wrapppertaxQuater1.ImputedAmount = 0;
                    quaterWiseWrapperTaxMap.put(1,wrapppertaxQuater1);
                }
                if(quaterWiseWrapperTaxMap.containsKey(2))
                {
                    wrapppertaxQuater2 = quaterWiseWrapperTaxMap.get(2);
                    wrapppertaxQuater2.ImputedAmount = 0;
                    quaterWiseWrapperTaxMap.put(2,wrapppertaxQuater2);
                }
                wrapppertaxQuater3 = quaterWiseWrapperTaxMap.get(3);
                wrapppertaxQuater3.ImputedAmount = 0;
                quaterWiseWrapperTaxMap.put(3,wrapppertaxQuater3);
                AnnualTaxLiability =0;

                if(quaterWiseTaxReportMap.containsKey(12))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(12);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(12,currentReimbursement);

                }
                if(quaterWiseTaxReportMap.containsKey(1))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(1);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(1,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(2))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(2);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(2,currentReimbursement);
                }

                if(quaterWiseTaxReportMap.containsKey(3))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(3);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(3,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(4))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(4);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(4,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(5))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(5);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(5,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(6))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(6);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(6,currentReimbursement);

                }
                if(quaterWiseTaxReportMap.containsKey(7))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(7);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(7,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(8))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(8);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(8,currentReimbursement);
                }
              }
          }
         
          if(quaterWiseWrapperTaxMap.containsKey(4))
          {
              TotalActualReimbursements =TotalActualReimbursements+quaterWiseWrapperTaxMap.get(4).Reimbursements;
              MaximumAllowable = MaximumAllowable  +quaterWiseWrapperTaxMap.get(4).MaxIRSrate;
              AnnualTaxLiability =AnnualTaxLiability+quaterWiseWrapperTaxMap.get(4).ImputedAmount;
              if(quaterWiseWrapperTaxMap.get(4).Mileages != null)
              {
                totalmileages1 =totalmileages1+quaterWiseWrapperTaxMap.get(4).Mileages; 
              } 
              if(totalmileages1>5000)
              {
                if(quaterWiseWrapperTaxMap.containsKey(1))
                {        
                    wrapppertaxQuater1 = quaterWiseWrapperTaxMap.get(1);
                    wrapppertaxQuater1.ImputedAmount = 0;
                    quaterWiseWrapperTaxMap.put(1,wrapppertaxQuater1);
                }
                if(quaterWiseWrapperTaxMap.containsKey(2))
                {
                    wrapppertaxQuater2 = quaterWiseWrapperTaxMap.get(2);
                    wrapppertaxQuater2.ImputedAmount = 0;
                    quaterWiseWrapperTaxMap.put(2,wrapppertaxQuater2);
                }
                if(quaterWiseWrapperTaxMap.containsKey(3))
                {
                    wrapppertaxQuater3 = quaterWiseWrapperTaxMap.get(3);
                    wrapppertaxQuater3.ImputedAmount = 0;
                    quaterWiseWrapperTaxMap.put(3,wrapppertaxQuater3);
                }
                wrapppertaxQuater4 = quaterWiseWrapperTaxMap.get(4);
                wrapppertaxQuater4.ImputedAmount = 0;
                quaterWiseWrapperTaxMap.put(4,wrapppertaxQuater4);
                AnnualTaxLiability =0;

                if(quaterWiseTaxReportMap.containsKey(12))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(12);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(12,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(1))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(1);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(1,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(2))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(2);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(2,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(3))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(3);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(3,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(4))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(4);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(4,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(5))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(5);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(5,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(6))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(6);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(6,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(7))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(7);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(7,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(8))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(8);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(8,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(9))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(9);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(9,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(10))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(10);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(10,currentReimbursement);
                }
                if(quaterWiseTaxReportMap.containsKey(11))
                {
                    WrapperTaxReport currentReimbursement = quaterWiseTaxReportMap.get(11);
                    currentReimbursement.imputedincome = 0;
                    quaterWiseTaxReportMap.put(11,currentReimbursement);
                }
              }              
          }
          if(currentDriver.compliancestatus__c==null)
          {
               if(quaterWiseWrapperTaxMap.containsKey(1))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(1));
                }
                if(quaterWiseWrapperTaxMap.containsKey(2))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(2));
                }
                if(quaterWiseWrapperTaxMap.containsKey(3))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(3));
                }
                if(quaterWiseWrapperTaxMap.containsKey(4))
                {
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(4));
                }
               message=label.waitingfordocumentation;
          }
          else 
          {
              if(currentDriver.compliancestatus__c =='Yes')
              {
                if(totalmileages1<5000)
                {
                    message=label.compliancenotmeeting;
                    if(quaterWiseWrapperTaxMap.containsKey(1))
                    {            
                        wrapppertaxList.add(quaterWiseWrapperTaxMap.get(1));
                    }
                    if(quaterWiseWrapperTaxMap.containsKey(2))
                    {            
                        wrapppertaxList.add(quaterWiseWrapperTaxMap.get(2));
                    }
                    if(quaterWiseWrapperTaxMap.containsKey(3))
                    {            
                        wrapppertaxList.add(quaterWiseWrapperTaxMap.get(3));
                    }
                    if(quaterWiseWrapperTaxMap.containsKey(4))
                    {
                        wrapppertaxList.add(quaterWiseWrapperTaxMap.get(4));
                    }
                }
                else 
                {
                    // you are in Compliance
                    message=Label.compliance;
                }
              }
              else 
              {
                if(quaterWiseWrapperTaxMap.containsKey(1))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(1));
                }
                if(quaterWiseWrapperTaxMap.containsKey(2))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(2));
                }
                if(quaterWiseWrapperTaxMap.containsKey(3))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(3));
                }
                if(quaterWiseWrapperTaxMap.containsKey(4))
                {
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(4));
                }
                if(currentDriver.compliancestatus__c =='No – Vehicle Age')
                {
                   message=Label.insuranceisnotmeeting;
                   message = message.replace('Name',currentDriver.FirstName);
                }  
                else if(currentDriver.compliancestatus__c =='No – Insurance not meeting minimum'){
                    message=Label.noInsurancenotmeetingminimum;
                    message = message.replace('Name',currentDriver.FirstName);
                }
                else if(currentDriver.compliancestatus__c =='No – Vehicle Value'){
                    message=Label.novehiclevalue;
                    message = message.replace('Name',currentDriver.FirstName);
                }
                else if(currentDriver.compliancestatus__c =='Resubmit Insurance – you submitted an insurance card')
                {
                    message=Label.Insurancecard;
                }
              }
          }
         /* if(currentDriver.compliancestatus__c!=null && currentDriver.compliancestatus__c =='Yes')
          {
                if(quaterWiseWrapperTaxMap.containsKey(1) && totalmileages1<5000)
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(1));
                }
                if(quaterWiseWrapperTaxMap.containsKey(2) && totalmileages1<5000)
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(2));
                }
                if(quaterWiseWrapperTaxMap.containsKey(3) && totalmileages1<5000)
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(3));
                }
                if(quaterWiseWrapperTaxMap.containsKey(4) && totalmileages1<5000)
                {
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(4));
                }
          } 
          else if(currentDriver.compliancestatus__c!=null && currentDriver.compliancestatus__c !='Yes')
          {
              if(quaterWiseWrapperTaxMap.containsKey(1))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(1));
                }
                if(quaterWiseWrapperTaxMap.containsKey(2))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(2));
                }
                if(quaterWiseWrapperTaxMap.containsKey(3))
                {            
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(3));
                }
                if(quaterWiseWrapperTaxMap.containsKey(4))
                {
                    wrapppertaxList.add(quaterWiseWrapperTaxMap.get(4));
                }
          }*/
          
          if(quaterWiseTaxReportMap.containsKey(12))
          {
              WrapperTaxReport currentTaxReport = quaterWiseTaxReportMap.get(12);              
              currentTaxReport.approvedmileages = Decimal.valueOf(quaterWiseTaxReportMap.get(12).approvedmileages).setScale(2);
              currentTaxReport.totalreim = Decimal.valueOf(quaterWiseTaxReportMap.get(12).totalreim).setScale(2);
              currentTaxReport.iRSallowable= Decimal.valueOf(quaterWiseTaxReportMap.get(12).iRSallowable).setScale(2);
              currentTaxReport.imputedincome = Decimal.valueOf(quaterWiseTaxReportMap.get(12).imputedincome).setScale(2);
              quaterWiseTaxReportMap.put(12,currentTaxReport);
              quaterWiseWrapperTaxList.add(quaterWiseTaxReportMap.get(12));
          }
          Set<Integer> uniqueMonthSet = new Set<Integer>();
          List<Integer> monthList = new List<Integer>();
          if(quaterWiseTaxReportMap.size()>0)
          {
            uniqueMonthSet = quaterWiseTaxReportMap.keySet();
            monthList.addAll(uniqueMonthSet);
            monthList.sort();
          }
          for(Integer i : monthList)
          {
              if(i != 12)
              {
                WrapperTaxReport currentTaxReport = quaterWiseTaxReportMap.get(i);              
                currentTaxReport.approvedmileages = Decimal.valueOf(quaterWiseTaxReportMap.get(i).approvedmileages).setScale(2);
                currentTaxReport.totalreim = Decimal.valueOf(quaterWiseTaxReportMap.get(i).totalreim).setScale(2);
                currentTaxReport.iRSallowable= Decimal.valueOf(quaterWiseTaxReportMap.get(i).iRSallowable).setScale(2);
                currentTaxReport.imputedincome = Decimal.valueOf(quaterWiseTaxReportMap.get(i).imputedincome).setScale(2);
                quaterWiseTaxReportMap.put(i,currentTaxReport);
                quaterWiseWrapperTaxList.add(quaterWiseTaxReportMap.get(i));
              }
          }
          
          currentDriverTaxReport.imputedincome=AnnualTaxLiability;
          taxSummaryReport.add(currentDriverTaxReport);
        //  quarters = wrapppertaxList.size(); 
     // } 
     system.debug('wrapppertaxList'+wrapppertaxList);
     system.debug('quaterWiseWrapperTaxList'+quaterWiseWrapperTaxList);
     system.debug('taxSummaryReport'+taxSummaryReport);
     system.debug('TotalActualReimbursements'+TotalActualReimbursements);
     system.debug('MaximumAllowable'+MaximumAllowable);
      system.debug('AnnualTaxLiability'+AnnualTaxLiability);
      List<String> complianceCalculationList = new List<String>();
      complianceCalculationList.add(JSON.serialize(String.valueOf(currentDriver.name)));
      complianceCalculationList.add(JSON.serialize(message));        
      if(wrapppertaxList.size()>0)
      { 
        complianceCalculationList.add(JSON.serialize(wrapppertaxList));
        complianceCalculationList.add(JSON.serialize(quaterWiseWrapperTaxList));
        complianceCalculationList.add(JSON.serialize(taxSummaryReport));         
        complianceCalculationList.add(JSON.serialize(String.valueOf(Decimal.valueOf(TotalActualReimbursements).setScale(2)))); 
        complianceCalculationList.add(JSON.serialize(String.valueOf(Decimal.valueOf(MaximumAllowable).setScale(2))));          
        complianceCalculationList.add(JSON.serialize(String.valueOf(Decimal.valueOf(AnnualTaxLiability).setScale(2))));  
      }   
      system.debug('complianceCalculationList'+complianceCalculationList);    
      return complianceCalculationList;
    }
    public static String approveMileagesForAdminDash(String checked,String selected,String name,String emailaddress)
    {                 
        system.debug('approveMileagesForAdminDash');
        List<EmployeeMileages> employeeMileagesList = new List<EmployeeMileages>();
        List<String> approvedIdList = new List<String>();
        List<String> rejectedIdList = new List<String>();
    
        if(selected!=null)
        {
            List<EmployeeMileages> employeeMileagesListApprove = new List<EmployeeMileages>();
            employeeMileagesListApprove = (List<EmployeeMileages>)JSON.deserialize(selected,List<EmployeeMileages>.Class);
            employeeMileagesList.addAll(employeeMileagesListApprove);
        } 
        if(checked!=null)
        {
            List<EmployeeMileages> employeeMileagesListRejected = new List<EmployeeMileages>();
            employeeMileagesListRejected = (List<EmployeeMileages>)JSON.deserialize(checked,List<EmployeeMileages>.Class);
            employeeMileagesList.addAll(employeeMileagesListRejected);
        }
        if(employeeMileagesList.size()>0)
        {
            for(EmployeeMileages currentMileage : employeeMileagesList)
            {
                if(currentMileage.isSelected==true)
                {
                    approvedIdList.add(currentMileage.id);
                }
                else
                {
                    rejectedIdList.add(currentMileage.id);
                }
            }
            SendEmailToMe__c customSetValue = SendEmailToMe__c.getValues('ChangeTripStatusinTripLogBatch');
            if(customSetValue!=null && customSetValue.Send_email_to_me__c==true)
            {
                Database.executeBatch(New ChangeTripStatusinTripLog(approvedIdList,rejectedIdList,name,emailaddress),1);
            } 
            //Database.executeBatch(New ChangeTripStatusinTripLog(approvedIdList,rejectedIdList,name,emailaddress),1);
            return 'success';
        }               
        return 'success';
    }

  
    // AdminDashboard Class Methods Started 
    
    
    public static String getManager(String did, String accid) 
    {        
        List<Contact> managerList = new List<Contact>();
        managerList = [SELECT id, Name, Email,Accountid FROM Contact WHERE Accountid =: accid and (Deactivated_Date__c = null OR Deactivated_Date__c > TODAY) and (Role__c='Manager' OR Role__c='Driver/Manager')];
        return JSON.serialize(managerList);
    }
    
    public static String getadminname(String did) 
    {
        Contact adminContact = [select Id,Name from Contact where id =: did];
        return JSON.serialize(adminContact.Name);
    }
    // AdminDashboard Class Methods END
    // ManagerDashboard Class Methods Starts
        
    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {   
       
        String gaspriceyearmonth = '';
        if(System.today().month() == 1)
        {
            gaspriceyearmonth = MailingCity + MailingState + 12+ String.valueOf(System.today().year()-1); 
        }
        else
        {
            gaspriceyearmonth = MailingCity + MailingState + String.valueOf(System.today().month()-1) + String.valueOf(System.today().year()); 
        }
        List<Gas_Prices__c> gasPriceList = new List<Gas_Prices__c>();
        gasPriceList = [SELECT id,Fuel_Price__c FROM Gas_Prices__c WHERE Month_State_City__c =: gaspriceyearmonth];
        return JSON.serialize(gasPriceList);
    }
    public Static String getAllReimbursements(String year,String did,String accid) 
    { 
            String query=''; 
            List<String> monthList = new List<String>();
            integer month = 12;
            if(Integer.valueOf(year)==System.today().year())
            {
                month = System.today().month();
                
            }
            for(Integer i=1;i<=month;i++)
            {
                if(i<10)
                {
                    monthList.add('0'+String.valueOf(i)+'-'+year);
                }
                else
                {
                    monthList.add(String.valueOf(i)+'-'+year);
                }
            }
                
            System.debug('monthList'+monthList);
            query ='';
            String editedquery = '';
            if(monthList.size()>0)
            {
                
                editedquery = setQueryParameters(monthList);
                query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+did+'\' and Month__c IN '+ editedquery;
            }
            else
            {
                query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+did+'\'';
            }              
            List<EmployeeReimbursements> reimbursementList =  new List<EmployeeReimbursements>();
            System.debug('query'+query);
            for(Employee_Reimbursement__c currentReimbursement : (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query))
            {
                reimbursementList.add(WrapperUtils.getEmployeeReimbursements(currentReimbursement));
            }  
            
            return JSON.serialize(reimbursementList);
    }
    /*public static String getReimbursementsList(String driverid,String status)
    {   
        String query ='';
        List<String> monthList = new List<String>();
        
        for(Integer i=1;i<=System.today().month();i++)
        {
            if(i<10)
            {
                if(i == 1){
                    monthList.add('12-'+String.valueOf(System.today().year()-1));
                }
                else {
                    monthList.add('0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()));
                }
                
            }
            else if(i==10 || i==11 || i == 12)
            {
                monthList.add(String.valueOf(i)+'-'+String.valueOf(System.today().year()));
            }
            // else
            // {
            //    monthList.add(String.valueOf(i)+'-'+String.valueOf((System.today().year()-1)));
            // }
        }
        //}
        system.debug('monthList'+monthList);
        String editedquery ='';
        if(monthList.size()>0)
        {
            editedquery = setQueryParameters(monthList);
        }        
        if(String.isEmpty(status) && String.isNotBlank(editedquery))
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Month__c IN '+ editedquery ;
        }
        else if(String.isNotBlank(editedquery))
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Status__c != \''+status+'\' and Total_Pending__c > 0 and Month__c IN '+ editedquery ;
            system.debug('query======='+query);
        }
        else
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\''; 
        }
        List<Employee_Reimbursement__c> reimbursementList =  new List<Employee_Reimbursement__c>();
        reimbursementList = (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query);
        system.debug('reimbursementList===='+reimbursementList);
        if(reimbursementList.size()>0)
        {
            return JSON.serialize(reimbursementList);
        }
        else
        {            
            return JSON.serialize(0);
        }
     
    }*/
    public static String getReimbursementsList(String driverid,String status)
    {   
        String query ='';
        if(String.isNotEmpty(status))
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Status__c != \''+status+'\' and Total_Pending__c > 0' ;
        }
        else
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Total_Pending__c > 0 '; 
        }

        List<Employee_Reimbursement__c> reimbursementList =  new List<Employee_Reimbursement__c>();
        reimbursementList = (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query);
        system.debug('reimbursementList===='+reimbursementList);
        if(reimbursementList.size()>0)
        {
            system.Debug('reimbursementList'+JSON.serialize(reimbursementList));
            return JSON.serialize(reimbursementList);
        }
        else
        {            
            return JSON.serialize(0);
        }
    }
    
    public static String getMileages(String clickedMonth,string clickedYear,String did)
    {              
        String monthno = WrapperUtils.getMonthno(clickedMonth);
        String month = monthno + '-'+clickedYear;
        List<EmployeeMileages> employeeMileageList = new List<EmployeeMileages>();
        for(Employee_Mileage__c currentMileage : [SELECT id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,
                                                            Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,
                                                            EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,
                                                            EmployeeReimbursement__r.Total_Variable_Rate__c,EmployeeReimbursement__r.Total_Pending__c,
                                                            Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,
                                                            EmployeeReimbursement__r.Contact_Id__r.External_Email__c,EmployeeReimbursement__r.Monthly_Variable_Amount__c,
                                                            Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Mileage__c,
                                                            EmployeeReimbursement__r.Total_Rejected__c,Notes__c 
                                                FROM Employee_Mileage__c 
                                                WHERE EmployeeReimbursement__r.Month__c =: month AND EmployeeReimbursement__r.Contact_Id__c =: did ])
        {
            employeeMileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
        }        
        if(employeeMileageList.size() > 0) 
        {
            return JSON.serialize(employeeMileageList).unescapeHtml4();
        }
        else
        {
            return '';
        }
    }
    public static List<String> getMileages1(String clickedMonth,String year,String did)
    {
       
        String month = WrapperUtils.getMonthno(clickedMonth);      
        month = month +'-'+year;
        String query = 'SELECT id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c, EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,EmployeeReimbursement__r.Total_Variable_Rate__c,EmployeeReimbursement__r.Total_Pending__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,EmployeeReimbursement__r.Monthly_Variable_Amount__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Mileage__c,EmployeeReimbursement__r.Total_Rejected__c,Notes__c FROM Employee_Mileage__c WHERE EmployeeReimbursement__r.Month__c = \''+month+'\' AND EmployeeReimbursement__r.Contact_Id__c =\''+did+'\'';      
        
        List<Employee_Mileage__c> employeeMileageList =  (List<Employee_Mileage__c>)ExecuteQueryUtil.getRecordListFromsObject(query);
        System.Debug(employeeMileageList);
        List<String> mileagesList = new List<String>();    
        double mileages=0;
        double variableamount=0;
        List<EmployeeMileages> reimbursementList = new List<EmployeeMileages>();
        for(Employee_Mileage__c currentMileage : employeeMileageList)
        {
            mileages = mileages + (currentMileage.Mileage__c != null ? currentMileage.Mileage__c : 0);
            variableamount = variableamount + (currentMileage.Variable__c != null ? currentMileage.Variable__c : 0);
            reimbursementList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
        }
        mileagesList.add(JSON.serialize(reimbursementList));
        mileagesList.add(String.valueOf(mileages));
        mileagesList.add(String.valueOf(variableamount)); 
        system.Debug(mileagesList[0]);       
        if(mileagesList.size() > 0) 
        {
            return mileagesList;
        }
        else
        {
            return mileagesList;
        }
    }
    public static String readFromFileInchunk(String attachmentBody, String attachmentName, String attachmentId,String did,String accid,String contactattachementid)
    {
        if(attachmentBody != null) {
            Attachment insuranceAttachment = getAttachment(attachmentId);
            String newBody = '';
            if(insuranceAttachment.Body != null) {
                newBody = EncodingUtil.base64Encode(insuranceAttachment.Body);
            }
            newBody += attachmentBody;
            insuranceAttachment.Body = EncodingUtil.base64Decode(newBody);
            if(attachmentId == null) {
                insuranceAttachment.Name = attachmentName;
                insuranceAttachment.parentId = did;
            }
            upsert insuranceAttachment;
            if(String.isNotBlank(contactattachementid))
            {
                 
                if(String.isNotBlank(insuranceAttachment.Id) && insuranceAttachment.Id!= contactattachementid)
                {
                    
                    contact currentDriver = new contact();
                    currentDriver.id= did;
                    currentDriver.Insurance_Attachment_Id__c = insuranceAttachment.id;
                    update currentDriver;
                }
            }
            else
            {
                if(insuranceAttachment.Id!=null)
                {
                    
                    contact currentDriver = new contact();
                    currentDriver.id= did;
                    currentDriver.Insurance_Attachment_Id__c = insuranceAttachment.id;
                    update currentDriver;
                    
                }
            }
            return insuranceAttachment.Id;           
        }
        else 
        {
            return 'Attachment Body was null';
        }        
    }

    public static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    public static String setQueryParameters(List<String> stringlist)
    {
        String editedquery = '( ';
        for(String currentMonthName : stringlist)
        {
            editedquery = editedquery + '\''+currentMonthName+ '\','; 
        }
        if(editedquery.endsWith(','))
        {
            editedquery = editedquery.removeEnd(',');
        }
        editedquery = editedquery+' )';
        return editedquery;
    }
    /*public static integer getpastYearReimbursement(String drid)
    {
        List<String> lastYear = new List<String>();
        lastYear.add('12-'+String.valueOf((System.today().year()-1)));
        String query ='';
        String editedquery = setQueryParameters(lastYear);
        query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c ,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+drid+'\' and Month__c IN '+ editedquery ;      
        List<Employee_Reimbursement__c> employeeReimbursementList =  new List<Employee_Reimbursement__c>();
        employeeReimbursementList = (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query);
        if(employeeReimbursementList!=null)
        {
            return employeeReimbursementList.size();
        }
        return 0; 
           
    }*/

    public static String getpastYearReimbursement(String drid)
    {
        List<String> lastYear = new List<String>();
        for(Integer i=1;i<13;i++)
        {
            if(i<=system.today().month())
            {
                if(i<10)
                {
                    lastYear.add('0'+i+'-'+String.valueOf((System.today().year())));                   
                }
                else
                {
                    lastYear.add(i+'-'+String.valueOf((System.today().year())));                    
                }                 
            }
            if(i<10)
            {
                lastYear.add('0'+i+'-'+String.valueOf((System.today().year()-1)));
                lastYear.add('0'+i+'-'+String.valueOf((System.today().year()-2)));
            }
            else
            {
                lastYear.add(i+'-'+String.valueOf((System.today().year()-1)));
                lastYear.add(i+'-'+String.valueOf((System.today().year()-2)));
            }
        }
        String query ='';
        Set<String> years = new Set<String>();
        List<String> yearsTobeReturned = new List<String>();
        String editedquery = setQueryParameters(lastYear);
        system.debug('editedquery'+editedquery);
        query = 'Select id,Year__c from Employee_Reimbursement__c where Contact_Id__c=\''+drid+'\' and Month__c IN '+ editedquery ;
        system.debug('query'+query);
        for(Employee_Reimbursement__c currentReimbursement : (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query))
        {
            
            years.add(String.valueOf(currentReimbursement.Year__c));
            
        }
        if(years.size()>0)
        {   
            yearsTobeReturned.addAll(years);
        }
        system.debug('yearsTobeReturned'+yearsTobeReturned);
        return JSON.serialize(yearsTobeReturned);
    }

    public static String getLast2Years()
    {        
        List<String> last2Years = new List<String>();
        last2Years.add(String.valueOf(System.today().year()));
        last2Years.add(String.valueOf(System.today().year()-1));
        last2Years.add(String.valueOf(System.today().year()-2));
        return JSON.serialize(last2Years);
    }
    public static String getReimbursementsListClone(String driverid)
    {
        system.debug('inside getReimbursementsListClone');
        List<String> monthList = new List<String>();
        if(System.today().month()==12)
        {
            monthList.add('11-'+System.today().year());
            monthList.add('12-'+System.today().year());            
        }
        else if(System.today().month()==11)
        {
            monthList.add('11-'+System.today().year());
        }
        else
        {
            for(Integer i=1;i<=12;i++)
            {
                if(i<10)
                {
                    monthList.add('0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()));
                }
                else if(i==10)
                {
                    monthList.add(String.valueOf(i)+'-'+String.valueOf(System.today().year()));
                }
                else
                {
                    monthList.add(String.valueOf(i)+'-'+String.valueOf((System.today().year()-1)));
                }
            }
        }
        system.debug('---------------monthList'+monthList);
        String editedquery ='';
        String query = '';
        String status = 'Approved';     
        if(monthList.size()>0)
        {
            editedquery = setQueryParameters(monthList);            
        }
        system.debug('---------------editedquery'+editedquery);
        if(String.isNotBlank(editedquery))
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Status__c != \''+status+'\' and Total_Pending__c > 0 and Month__c IN '+ editedquery ;
        }
        else
        {
            query = 'Select id,Month__c,Total_Variable_Rate__c,Fuel_Price__c,Total_Mileage__c,Fixed_Amount__c,Variable_Rate__c,Total_Monthly_Reimbursement__c,Contact_Id__c,Approved_Date__c,Status__c,Total_Pending__c,Monthly_Variable_Amount__c from Employee_Reimbursement__c where Contact_Id__c=\''+driverid+'\' and Status__c != \''+status+'\''; 
        }
        List<Employee_Reimbursement__c> reimbursementList =  new List<Employee_Reimbursement__c>();
        reimbursementList = (List<Employee_Reimbursement__c>)ExecuteQueryUtil.getRecordListFromsObject(query);       
        if(reimbursementList.size()>0)
        {
            return JSON.serialize(reimbursementList);
        }
        else
        {   
            return JSON.serialize(0);
        }
    }
    public static String approveReimbursements(String year,String did,String accid,String reimbursements)
    {       
        List<EmployeeReimbursements> reimbursementList = new List<EmployeeReimbursements>();
        List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>();
        if(reimbursements!=null)
        {
           reimbursementList = (List<EmployeeReimbursements>)JSON.deserialize(reimbursements,List<EmployeeReimbursements>.Class); 
           for (EmployeeReimbursements obj_current_reimbursment : reimbursementList) 
           {
                employeeReimbursementList.add(WrapperUtils.approveReimbursementofDriver(obj_current_reimbursment));
            }
            if(employeeReimbursementList.size() > 0) 
            {
                update employeeReimbursementList;
                return getAllReimbursements(year,did,accid);
            }
        }
        return '';
    }
    // my New methods
    public static string getUnapprovedReimbursements(String contactId, String accountId,boolean showteam,String role) 
    {
       // its replacement of getAllDriversLastMonthUpdatedUnapprovedReimburseClone and getAllDriversLastMonthUnapprovedReimbursementsClone
       Map<String,EmployeeMileagesForCalculation> employeeReimbursementMap = new Map<String,EmployeeMileagesForCalculation>();
        
        List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>();
        if(showteam!=null && showteam == true && (role=='Admin' || role == StaticValues.roleAdminDriver)) // || role == 'Admin/Driver'
        {
            employeeReimbursementList =[SELECT id,
                                               Name, 
                                               Month__c, 
                                               Total_Rejected__c, 
                                               Approved_Date__c,
                                               Contact_Id__r.Accountid,
                                               Contact_Id__r.Manager__r.Name,
                                               Contact_Id__c, 
                                               Contact_Id__r.name, 
                                               Contact_Id__r.Monthly_Mileage_Limit__c, 
                                               Total_Approved__c, 
                                               Total_Mileage__c, 
                                               Status__c, 
                                               Total_Variable_Rate__c,
                                               Total_Pending__c 
                                        FROM Employee_Reimbursement__c 
                                        WHERE Approved_Date__c = null AND Status__c='Pending' 
                                        AND Contact_Id__r.Accountid =: accountId];
            //employeeReimbursementList =[select id,Name, Month__c, Total_Rejected__c, Approved_Date__c,Contact_Id__r.Accountid, Contact_Id__c, Contact_Id__r.name, Contact_Id__r.Monthly_Mileage_Limit__c, Total_Approved__c, Total_Mileage__c, Status__c, Total_Variable_Rate__c,(select id,Name,Trip_Status__c,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Approved_Date__c,Mileage__c,Variable__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Total_Pending__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Variable_Rate__c from Employees_Mileage__r where Trip_Status__c =: StaticValues.noApprovedYet and Approved_Date__c = null) from Employee_Reimbursement__c where Approved_Date__c = null and Contact_Id__r.Accountid =: accountId];
        }
        else if(showteam!=null && showteam == false && (role=='Admin' || role == StaticValues.roleAdminDriver)) // || role == 'Admin/Driver'
        {
            employeeReimbursementList =[SELECT id,
                                               Name, 
                                               Month__c, 
                                               Total_Rejected__c, 
                                               Approved_Date__c,
                                               Contact_Id__r.Accountid, 
                                               Contact_Id__c,
                                               Contact_Id__r.Manager__r.Name,
                                               Contact_Id__r.name, 
                                               Contact_Id__r.Monthly_Mileage_Limit__c, 
                                               Total_Approved__c, 
                                               Total_Mileage__c, 
                                               Status__c, 
                                               Total_Variable_Rate__c,
                                               Total_Pending__c 
                                        FROM Employee_Reimbursement__c 
                                        where Approved_Date__c = null 
                                        and Status__c='Pending' 
                                        and Contact_Id__r.Accountid =: accountId 
                                        and ((Contact_Id__r.Manager__c =:contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__c =:contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId))];
           // employeeReimbursementList =[select id,Name, Month__c, Total_Rejected__c, Approved_Date__c,Contact_Id__r.Accountid, Contact_Id__c, Contact_Id__r.name, Contact_Id__r.Monthly_Mileage_Limit__c, Total_Approved__c, Total_Mileage__c, Status__c, Total_Variable_Rate__c,(select id,Name,Trip_Status__c,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Approved_Date__c,Mileage__c,Variable__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Total_Pending__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Variable_Rate__c from Employees_Mileage__r where Trip_Status__c =: StaticValues.noApprovedYet and Approved_Date__c = null) from Employee_Reimbursement__c where Approved_Date__c = null and Contact_Id__r.Accountid =: accountId and ((Contact_Id__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId))];
        }
        else if(showteam!=null && showteam == true && (role=='Manager' || role=='Driver/Manager'))
        {
            employeeReimbursementList =[SELECT id,
                                               Name, 
                                               Month__c, 
                                               Total_Rejected__c, 
                                               Approved_Date__c,
                                               Contact_Id__r.Accountid, 
                                               Contact_Id__c, 
                                               Contact_Id__r.name, 
                                               Contact_Id__r.Manager__r.Name, 
                                               Contact_Id__r.Monthly_Mileage_Limit__c, 
                                               Total_Approved__c, 
                                               Total_Mileage__c, 
                                               Status__c, 
                                               Total_Variable_Rate__c,
                                               Total_Pending__c 
                                        FROM Employee_Reimbursement__c 
                                        where Approved_Date__c = null 
                                        and Status__c='Pending' 
                                        and Contact_Id__r.Accountid =: accountId 
                                        and ((Contact_Id__r.Manager__c =: contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__c =: contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =: contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =: contactId) 
                                        OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =: contactId))];
            //employeeReimbursementList =[select id,Name, Month__c, Total_Rejected__c, Approved_Date__c,Contact_Id__r.Accountid, Contact_Id__c, Contact_Id__r.name, Contact_Id__r.Monthly_Mileage_Limit__c, Total_Approved__c, Total_Mileage__c, Status__c, Total_Variable_Rate__c,(select id,Name,Trip_Status__c,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Approved_Date__c,Mileage__c,Variable__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Total_Pending__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Variable_Rate__c from Employees_Mileage__r where Trip_Status__c =:StaticValues.noApprovedYet and Approved_Date__c = null) from Employee_Reimbursement__c where Approved_Date__c = null and Contact_Id__r.Accountid =: accountId and ((Contact_Id__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId))];
        }
        else if(showteam != null && showteam == false && (role == 'Manager' || role =='Driver/Manager'))
        {
            employeeReimbursementList = [SELECT id,
                                               Name, 
                                               Month__c, 
                                               Total_Rejected__c, 
                                               Approved_Date__c,
                                               Contact_Id__r.Accountid, 
                                               Contact_Id__c, 
                                               Contact_Id__r.name, 
                                               Contact_Id__r.Manager__r.Name, 
                                               Contact_Id__r.Manager__c,
                                               Contact_Id__r.Monthly_Mileage_Limit__c, 
                                               Total_Approved__c, 
                                               Total_Mileage__c, 
                                               Status__c, 
                                               Total_Variable_Rate__c,
                                               Total_Pending__c 
                                        FROM Employee_Reimbursement__c 
                                        where Approved_Date__c = null 
                                        and Status__c='Pending' 
                                        and Contact_Id__r.Accountid =: accountId 
                                        and (Contact_Id__r.Manager__c =: contactId)]; 
           // employeeReimbursementList =[select id,Name, Month__c, Total_Rejected__c, Approved_Date__c,Contact_Id__r.Accountid, Contact_Id__c, Contact_Id__r.name, Contact_Id__r.Monthly_Mileage_Limit__c, Total_Approved__c, Total_Mileage__c, Status__c, Total_Variable_Rate__c,(select id,Name,Trip_Status__c,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Approved_Date__c,Mileage__c,Variable__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Total_Pending__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Variable_Rate__c from Employees_Mileage__r where Trip_Status__c =:StaticValues.noApprovedYet and Approved_Date__c = null) from Employee_Reimbursement__c where Approved_Date__c = null and Contact_Id__r.Accountid =: accountId and (Contact_Id__r.Manager__c =:contactId)];
        }       
        for(Employee_Reimbursement__c currentReimbursement : employeeReimbursementList)
        {
            EmployeeMileagesForCalculation reimbursement = new EmployeeMileagesForCalculation();
            if(employeeReimbursementMap.containsKey(currentReimbursement.Contact_Id__c))
            {
                if(employeeReimbursementMap.get(currentReimbursement.Contact_Id__c).reimbursementIdList != null && employeeReimbursementMap.get(currentReimbursement.Contact_Id__c).reimbursementIdList.size() > 0)
                {                    
                    reimbursement = employeeReimbursementMap.get(currentReimbursement.Contact_Id__c);
                    reimbursement.totalMileages =(currentReimbursement.Total_Pending__c!=null) ? String.valueOf(double.valueOf((reimbursement.totalMileages!=null) ? reimbursement.totalMileages : '0')+double.valueOf(currentReimbursement.Total_Pending__c)):'0';                    
                    if(reimbursement.reimbursementIdList != null && reimbursement.reimbursementIdList.size() >0)
                    {                        
                       List<String> reimbursementIdList = new List<String>();
                       reimbursementIdList = reimbursement.reimbursementIdList;
                       reimbursementIdList.add(currentReimbursement.id);
                       reimbursement.reimbursementIdList = reimbursementIdList; 
                    }
                    employeeReimbursementMap.put(currentReimbursement.Contact_Id__c,reimbursement);
                    
                }                
            }
            else
            {
                //reimbursement.managerName = currentReimbursement.Contact_Id__r.Manager__r.Name;
                reimbursement.contactid = currentReimbursement.Contact_Id__c;
                reimbursement.reimbursementid = currentReimbursement.Id;
                reimbursement.name = currentReimbursement.Contact_Id__r.Name;
                reimbursement.month = currentReimbursement.Month__c;
                reimbursement.threshold = String.valueOf(currentReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c);
                reimbursement.totalMileages = (currentReimbursement.Total_Pending__c!=null) ? String.valueOf(currentReimbursement.Total_Pending__c) : '0';
                reimbursement.approvedMileages = String.valueOf(currentReimbursement.Total_Approved__c);             
                reimbursement.isSelected = false;
                reimbursement.isSelectedEmailReminder = false;
                List<String> reimbursementIdList = new List<String>();
                reimbursementIdList.add(currentReimbursement.Id);
                reimbursement.reimbursementIdList = reimbursementIdList;
                /*for(Employee_Mileage__c currentMileage : currentReimbursement.Employees_Mileage__r)
                {
                    mileageListToAdd.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
                }                    
                reimbursement.mileagesList = mileageListToAdd;*/
                employeeReimbursementMap.put(currentReimbursement.Contact_Id__c,reimbursement);                   
                                    
            }
            
        }    
        return JSON.serialize((List<EmployeeMileagesForCalculation>)employeeReimbursementMap.values()).unescapeHtml4();
    }
    public static string getLastMonthReimbursements(String contactId, String accountId,boolean showteam,String role)
    {
        // its replacement of 
        List<EmployeeReimbursementDetailsAdmin> reimbursementList = new List<EmployeeReimbursementDetailsAdmin>();
        Account currentAccount = new Account();
        if(String.isNotBlank(accountId))
        {
            currentAccount = [SELECT id,Last_Reimbursement_Created__c FROM Account WHERE ID =: accountId];
        }
        if(currentAccount != null && String.isNotBlank(currentAccount.Last_Reimbursement_Created__c))
        {
           
            List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>();
        
            if(showteam != null && showteam == true && (role=='Admin' || role == StaticValues.roleAdminDriver)) // || role == 'Admin/Driver'
            {
                system.debug('----->');
                employeeReimbursementList =[SELECT ID, 
                                                   Name, 
                                                   Month__c, 
                                                   Total_Rejected__c, 
                                                   Approved_Date__c, 
                                                   Contact_Id__c, 
                                                   Contact_Id__r.name, 
                                                   Contact_Id__r.Monthly_Mileage_Limit__c,
                                                   Contact_Id__r.Manager__r.Name, 
                                                   Total_Approved__c, 
                                                   Total_Mileage__c, 
                                                   Status__c 
                                            FROM Employee_Reimbursement__c 
                                            WHERE Contact_Id__r.Accountid = :accountId 
                                            AND Month__c = :currentAccount.Last_Reimbursement_Created__c];
            }
            else if(showteam!=null && showteam == false && (role=='Admin' || role == StaticValues.roleAdminDriver)) //|| role == 'Admin/Driver'
            {
                system.debug('----->');
                employeeReimbursementList = [SELECT ID, 
                                                    Name, 
                                                    Month__c, 
                                                    Total_Rejected__c, 
                                                    Approved_Date__c, 
                                                    Contact_Id__c, 
                                                    Contact_Id__r.name, 
                                                    Contact_Id__r.Monthly_Mileage_Limit__c,
                                                    Contact_Id__r.Manager__r.Name, 
                                                    Total_Approved__c, 
                                                    Total_Mileage__c, 
                                                    Status__c 
                                            FROM Employee_Reimbursement__c 
                                                WHERE Contact_Id__r.Accountid = :accountId 
                                                and Month__c = :currentAccount.Last_Reimbursement_Created__c 
                                                and ((Contact_Id__r.Manager__c =:contactId) 
                                                OR (Contact_Id__r.Manager__r.Manager__c =:contactId) 
                                                OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                                OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                                OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId))];
            }
            else if(showteam!=null && showteam == true && (role=='Manager' || role=='Driver/Manager'))
            {
                system.debug('----->');
                employeeReimbursementList = [SELECT ID, 
                                                    Name, 
                                                    Month__c, 
                                                    Total_Rejected__c, 
                                                    Approved_Date__c, 
                                                    Contact_Id__c, 
                                                    Contact_Id__r.name, 
                                                    Contact_Id__r.Monthly_Mileage_Limit__c,
                                                    Contact_Id__r.Manager__c,
                                                    Contact_Id__r.Manager__r.Name,
                                                    Total_Approved__c, 
                                                    Total_Mileage__c, 
                                                    Status__c 
                                            FROM Employee_Reimbursement__c 
                                            WHERE Contact_Id__r.Accountid = :accountId 
                                            and Month__c = :currentAccount.Last_Reimbursement_Created__c 
                                            and ((Contact_Id__r.Manager__c =:contactId) 
                                            OR (Contact_Id__r.Manager__r.Manager__c =:contactId) 
                                            OR (Contact_Id__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                            OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId) 
                                            OR (Contact_Id__r.Manager__r.Manager__r.Manager__r.Manager__r.Manager__c =:contactId))];
            }
            else if(showteam != null && showteam == false && (role == 'Manager' || role == 'Driver/Manager'))
            {
                system.debug('----->');
                employeeReimbursementList = [SELECT ID, 
                                                    Name, 
                                                    Month__c, 
                                                    Total_Rejected__c, 
                                                    Approved_Date__c, 
                                                    Contact_Id__c, 
                                                    Contact_Id__r.name, 
                                                    Contact_Id__r.Monthly_Mileage_Limit__c, 
                                                    Contact_Id__r.Manager__c,
                                                    Contact_Id__r.Manager__r.Name,
                                                    Total_Approved__c, 
                                                    Total_Mileage__c, 
                                                    Status__c 
                                            FROM Employee_Reimbursement__c 
                                            where Contact_Id__r.Accountid = :accountId 
                                            and Month__c = :currentAccount.Last_Reimbursement_Created__c 
                                            and (Contact_Id__r.Manager__c =:contactId)];
            }        
            for (Employee_Reimbursement__c currentReimbursement : employeeReimbursementList) 
            {
                reimbursementList.add(getEmployeeReimbursementDetails(currentReimbursement));
            }
            
        }        
         return JSON.serialize(reimbursementList).unescapeHtml4();
    }
    public static void updateContactThresholdLimit(String thresholdLimitList)
    {  
        System.debug(thresholdLimitList);          
        List<updateThresholdWrapper> employeeDetailList = new List<updateThresholdWrapper>();        
        if(thresholdLimitList != null)
        {
            employeeDetailList = (List<updateThresholdWrapper>)Json.deserialize(thresholdLimitList,List<updateThresholdWrapper>.class);
        }
        List<contact> driverList = new List<contact>();        
        if(employeeDetailList!= null)
        {
            for(updateThresholdWrapper currentEmployee : employeeDetailList)
            {
                System.debug(currentEmployee);
                Contact driver = new Contact();
                if(String.isNotBlank(String.valueOf(currentEmployee.contactid))  && String.isNotBlank(String.valueOf(currentEmployee.threshold)))
                {
                    driver.id = currentEmployee.contactid; 
                    driver.Monthly_Mileage_Limit__c = Decimal.valueOf(currentEmployee.threshold);  
                    driverList.add(driver);                    
                }
                else if(String.isNotBlank(String.valueOf(currentEmployee.contactid)))
                {
                    driver.id = currentEmployee.contactid; 
                    driver.Monthly_Mileage_Limit__c = null;  
                    driverList.add(driver);
                }
                
            }
            if(driverList.size()>0)
            {              
                update driverList;
            }   
        }        
    }
    public static Employee_Reimbursement__c approveReimbursement(String currentReimbursementid)
    {       
        Employee_Reimbursement__c currentReimbursement = new Employee_Reimbursement__c();
        currentReimbursement.id= currentReimbursementid;
        currentReimbursement.Status__c = 'Approved';
        currentReimbursement.Approved_Date__c = system.today();
        return currentReimbursement;
    }
    public static void updateReimbursements(String reimbursements)
    {       
        System.debug('reimbursements'+reimbursements);
        if(reimbursements!=null && reimbursements!='')
        {
            List<String> employeeReimbursementList = new List<String>();
            employeeReimbursementList = (List<String>)Json.deserialize(reimbursements,List<String>.class);
            List<Employee_Reimbursement__c> reimbursementList = new List<Employee_Reimbursement__c>();
            for(String currentReimbursement : employeeReimbursementList)
            {
                reimbursementList.add(approveReimbursement(currentReimbursement));              
            }
            if(reimbursementList.size()>0)
            {
                update reimbursementList;
            }
        }       
    }
    public static String getUnapprovedMileages(String reimbursementDetails)
    {
        EmployeeMileagesForCalculation reimbursement = new EmployeeMileagesForCalculation();
        if(reimbursementDetails!=null && reimbursementDetails!='')
        {
            reimbursement = (EmployeeMileagesForCalculation)Json.deserialize(reimbursementDetails,EmployeeMileagesForCalculation.class);
            List<EmployeeMileages> employeeMileagesList = new List<EmployeeMileages>();
            for(Employee_Mileage__c currentMileage : [SELECT id,Name,Trip_Status__c,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,
                                                            Approved_Date__c,Mileage__c,Variable__c,EmployeeReimbursement__c,
                                                            EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Total_Pending__c,
                                                            EmployeeReimbursement__r.Total_Mileage__c,EmployeeReimbursement__r.Contact_Id__c,
                                                            CreatedDate,Rejected__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,
                                                            Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,
                                                            Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Variable_Rate__c,
                                                            EmployeeReimbursement__r.Total_Rejected__c,Notes__c
                                                    FROM Employee_Mileage__c 
                                                    WHERE Trip_Status__c =: StaticValues.noApprovedYet 
                                                    AND Approved_Date__c = null AND EmployeeReimbursement__c IN : reimbursement.reimbursementIdList])
            {
                employeeMileagesList.add(getMileagesOfReimbursement(currentMileage));
            }
            reimbursement.mileagesList = employeeMileagesList;            
        }
        System.debug('reimbursement'+reimbursement);
        return JSON.serialize(reimbursement).unescapeHtml4();

    }
    public static void approveMileagesClone1(String mileages)
    {
        List<String> updatedlist = new List<String>();
        if(mileages!=null)
        {            
             List<String> reimbursementIdList = new List<String>();
             reimbursementIdList = (List<String>)(JSON.deserialize(mileages,List<String>.class));
             List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>();
             for(String currentMileage : reimbursementIdList) 
             {
                Employee_Reimbursement__c currentReimbursement = new Employee_Reimbursement__c();
                currentReimbursement.id= String.valueOf(currentMileage);
                currentReimbursement.Status__c = 'Approved';
                currentReimbursement.Approved_Date__c = System.today();
                employeeReimbursementList.add(currentReimbursement);
             }
             if(employeeReimbursementList.size()>0)
             {
                update employeeReimbursementList;                              
             }
        }
    }
    /* public static void emailReminderUnappAdmin(String unapprovedRemIds) {
        if(unapprovedRemIds!=null) {
            List<String> reimbursementIdsList = new List<String>();
            reimbursementIdsList = (List<String>)(JSON.deserialize(unapprovedRemIds,List<String>.class));
            List<Employee_Reimbursement__c> ReimList = [select id,Contact_Id__c from Employee_Reimbursement__c where Id IN : reimbursementIdsList ];
            List<String> contactIdsOfReim = new List<String>();
            for(Employee_Reimbursement__c rem :ReimList) {
                contactIdsOfReim.add(rem.Id);
            }
            List<String> contactIdsOfManagers = new List<String>();
            for(Employee_Reimbursement__c rem :ReimList) {
                contactIdsOfManagers.add(rem.Contact_Id__r.Manager__c);
            }
            
            //executing batch using selected reimbursement ids and managerids
            EmailReminderForAdminDashbordBatch objBatch = new EmailReminderForAdminDashbordBatch(contactIdsOfReim,contactIdsOfManagers); 
            database.executeBatch(objBatch,1);
        }
    } */
    /*public static String getUnapprovedMileagesforDownload(String reimbursements)
    {
        List<String> reimbursementsIdList = new List<String>();
        if(reimbursements!=null)
        {
            reimbursementsIdList = (List<String>)(JSON.deserialize(reimbursements,List<String>.class));
        }              
        
        List<EmployeeMileages> employeeMileageList = new List<EmployeeMileages>();
        if(reimbursementsIdList.size()>0)
        {
            for(Employee_Mileage__c currentMileage : [Select id,Name,Trip_Date__c,Trip_Origin__c,Trip_Destination__c,Mileage__c,Variable__c,Trip_Status__c,Approved_Date__c,EmployeeReimbursement__c,EmployeeReimbursement__r.month__c,EmployeeReimbursement__r.Contact_Id__c,CreatedDate,Rejected__c,EmployeeReimbursement__r.Total_Variable_Rate__c,EmployeeReimbursement__r.Total_Pending__c,Origin_Name__c,Tracing_Style__c,StartTime__c,EndTime__c,Day_Of_Week__c,Destination_Name__c,EmployeeReimbursement__r.Contact_Id__r.External_Email__c,EmployeeReimbursement__r.Monthly_Variable_Amount__c,Maintenance_and_Tires__c,Fuel_price__c,EmployeeReimbursement__r.Total_Mileage__c,EmployeeReimbursement__r.Total_Rejected__c FROM Employee_Mileage__c WHERE EmployeeReimbursement__c IN: reimbursementsIdList and Trip_Status__c=: StaticValues.noApprovedYet])
            {
                employeeMileageList.add(WrapperUtils.getMileagesOfReimbursement(currentMileage));
            } 
        }       
        if(employeeMileageList.size() > 0) 
        {
            return JSON.serialize(employeeMileageList).unescapeHtml4();
        }
        else
        {
            return '';
        }
    }*/ 
    
}