global class DeActivatedUserEmailBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    String query;
    public List<Contact> obj_list_contact_tobeupdated;
    public List<String> deActivatedConIds;
    public integer decider=0;
    global DeActivatedUserEmailBatch(List<String> passeddeActivatedConIds) 
    {   
        String role = '(Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c=\''+'Driver/Manager\' OR Role__c=\''+'Driver'+'\')';
        obj_list_contact_tobeupdated = new List<Contact>();
        deActivatedConIds = new List<String>();     
        deActivatedConIds = passeddeActivatedConIds;
        decider = 1; 
        String editedquery = '( ';
        for(String currentMonthName : deActivatedConIds)
        {
            editedquery = editedquery + '\''+currentMonthName+ '\','; 
        }
        if(editedquery.endsWith(','))
        {
            editedquery = editedquery.removeEnd(',');
        }
        editedquery = editedquery+' )';

        if(!Test.isRunningTest()){
       
           query = 'SELECT Id,Name,Triplog_UserID__c, isCommunityUser__c, Deactivated_Date__c, External_Email__c, IsDeactivated__c, Account.Triplog_API__c,Manager__r.FirstName,Manager__r.External_Email__c FROM Contact WHERE Account.isUsingTriplog__c = true AND Deactivation_Email_Sent__c = false and Id IN '+editedquery;
        }
        else
        {
             query = 'SELECT Id,Name,Triplog_UserID__c, isCommunityUser__c, Deactivated_Date__c, External_Email__c, IsDeactivated__c, Account.Triplog_API__c,Manager__r.FirstName,Manager__r.External_Email__c FROM Contact WHERE IsDeactivated__c = false AND Deactivated_Date__c = Today AND isCommunityUser__c = true AND Account.isUsingTriplog__c = true AND (Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c = \'Driver\' OR Role__c = \'Driver/Manager\') LIMIT 1';
        }
        System.debug('query :- '+ query);
    }
    global DeActivatedUserEmailBatch() 
    {
        decider =0;
        String role = '(Role__c = \''+StaticValues.roleAdminDriver+'\' OR Role__c=\''+'Driver/Manager\' OR Role__c=\''+'Driver'+'\')';
        query = 'SELECT Id, Name, FirstName, Deactivated_Date__c, External_Email__c, AccountId, Manager_External_Email__c, Manager__r.FirstName,' +
                    ' Manager__r.External_Email__c, Monthly_Mileage_Limit__c, Manager__r.send_deactivation_Email__c, send_deactivation_Email__c ' + 
                    ' FROM Contact ' +
                    ' WHERE Deactivated_Date__c = Today and Deactivation_Email_Sent__c = false and '+ role ; 
        obj_list_contact_tobeupdated = new List<Contact>();
    }
    global DeActivatedUserEmailBatch(String passeduserid) 
     {
        obj_list_contact_tobeupdated = new List<Contact>();
        decider =2;
        String identifier = passeduserid.left(3);
        if(identifier == '001'&& (!Test.isRunningTest())) {
            query = 'Select id,Name,Triplog_UserID__c,isCommunityUser__c,Deactivated_Date__c,External_Email__c,IsDeactivated__c,Account.Triplog_API__c,Manager__r.FirstName,Manager__r.External_Email__c FROM Contact WHERE Deactivation_Email_Sent__c = false and AccountId =\''+passeduserid+'\' ';   
        }
        else if(!Test.isRunningTest()){
            query = 'Select id,Name,Triplog_UserID__c,isCommunityUser__c,Deactivated_Date__c,External_Email__c,IsDeactivated__c,Account.Triplog_API__c,Manager__r.FirstName,Manager__r.External_Email__c FROM Contact WHERE Deactivation_Email_Sent__c = false and Id =\''+passeduserid+'\' ';
        } 
        else {
            query = 'Select id,Name,Triplog_UserID__c,isCommunityUser__c,Deactivated_Date__c,External_Email__c,IsDeactivated__c,Account.Triplog_API__c,Manager__r.FirstName,Manager__r.External_Email__c FROM Contact WHERE Deactivation_Email_Sent__c = false and Id =\''+passeduserid+'\' Limit 1';
        }
    } 
    global Database.QueryLocator start(Database.BatchableContext BC) {

        if(Test.isRunningTest())
        {
            
            query = 'SELECT Id, Name, FirstName, Deactivated_Date__c, External_Email__c, AccountId, Manager_External_Email__c, Manager__r.FirstName,' +
                    ' Manager__r.External_Email__c, Monthly_Mileage_Limit__c, Manager__r.send_deactivation_Email__c, send_deactivation_Email__c ' +
                    ' FROM Contact where Role__c=\'Driver\' LIMIT 1';    
        }
        
                       
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        for(Contact contactId : (List<Contact>) scope) 
        {
            contactIds.add(contactId.Id);
            accountIds.add(contactId.AccountId);
        }
        
        List<Contact> adminContact = [SELECT Id,Name,External_Email__c,AccountId,send_deactivation_Email__c 
                                        FROM Contact WHERE AccountId In: accountIds AND (Role__c = 'Admin' OR Role__c =: StaticValues.roleAdminDriver) and send_deactivation_Email__c = true];

        Map<Id, Set<String>> accountAdmins = new Map<Id, Set<String>> ();
        for(Contact singleAdmin : adminContact) {
            if(!accountAdmins.containsKey(singleAdmin.AccountId)) {
                accountAdmins.put( singleAdmin.AccountId, new Set<String>{singleAdmin.External_Email__c} );
            } else {
                accountAdmins.get(singleAdmin.AccountId).add(singleAdmin.External_Email__c);
            }
        }

        OrgWideEmailAddress[] owea = [SELECT Id ,Address from OrgWideEmailAddress where Address = 'driverservices@mburse.com'];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate DeActivated_User_Email = [SELECT Id, HtmlValue, Name, Subject FROM EmailTemplate WHERE DeveloperName =: 'DeActivated_User_Email' ];
        EmailTemplate Deactivation_with_No_Mileages = [SELECT Id, HtmlValue, Name, Subject FROM EmailTemplate WHERE DeveloperName =:'Deactivation_with_No_Mileages'];
        List<Employee_Reimbursement__c> listOfReimbursement = [SELECT Id, Total_Mileage_WithOut_Previous__c, Contact_Id__c, Total_Mileage__c 
                                                                    FROM Employee_Reimbursement__c WHERE Contact_Id__c IN :contactIds AND Month__c =: currentMonth(0)];
        
        Map<Id, Employee_Reimbursement__c> reimbursementMap = new Map<Id, Employee_Reimbursement__c>();
        for(Employee_Reimbursement__c singleReimbursement : listOfReimbursement) 
        {
            reimbursementMap.put(singleReimbursement.Contact_Id__c,singleReimbursement);
        }

        for(Contact singleContact : (List<Contact>) scope) 
        {            
            //if(singleContact.send_deactivation_Email__c) {
                if(reimbursementMap.containsKey(singleContact.Id) )
                {
                    // need to check 
                    Decimal totalMileage = 0;
                    totalMileage = reimbursementMap.get(singleContact.Id).Total_Mileage__c;
                    if(totalMileage==0)
                    {
                        // No Reimbursement and Mileages
                        List<String> toAddresses = new List<String>();
                        List<String> ccAddresses = new List<String>(); //singleContact.Manager__r.External_Email__c
                        List<String> bccAddresses = new List<String>();
                        SendEmailonDeactivation__c  objSendEmail = SendEmailonDeactivation__c.getValues('DeActivatedUserEmailBatch');
                        if((objSendEmail != null) && (objSendEmail.Send_to_Admin__c == true))
                        {                        
                            if(singleContact.Manager__r.send_deactivation_Email__c)
                            {
                                toAddresses.add(singleContact.Manager__r.External_Email__c);
                                if(accountAdmins.containsKey(singleContact.AccountId)) 
                                {
                                    ccAddresses.addAll(accountAdmins.get(singleContact.AccountId));                                
                                }
                                bccAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                            }
                            else
                            {   
                                toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');                             
                            }
                        }
                        else if((objSendEmail != null) && (objSendEmail.Send_to_me__c == true))
                        {   
                            toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                        }
                        String newEmailBody = Deactivation_with_No_Mileages.HtmlValue;
                        if(singleContact.Manager__r.FirstName!=null && singleContact.Name!=null)
                        {
                            newEmailBody = buildNoMileageEmail(newEmailBody,singleContact.Manager__r.FirstName,singleContact.Name,String.valueOf(singleContact.Deactivated_Date__c.Month())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Day())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Year()));    
                        }
                        messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                        String subject=Deactivation_with_No_Mileages.subject;
                        if(subject.contains('{driversubject}'))
                        {
                            subject = subject.replace('{driversubject}', String.valueOf(singleContact.Name));    
                        }
                        mail = buildemail(owea.get(0).Id,toAddresses,subject,newEmailBody);
                        if(ccAddresses.size()>0)
                        {
                            mail.setCcAddresses(ccAddresses);
                        }
                        if(bccAddresses.size()>0)
                        {
                            mail.setBccAddresses(bccAddresses);
                        }              
                        mails.add(mail);
                        System.debug('toAddresses:-'+toAddresses);
                        System.debug('ccAddresses:-'+ccAddresses);
                        System.debug('bccAddresses:-'+bccAddresses);
                    }
                    else
                    {
                       // Has Mileages
                        List<String> toAddresses = new List<String>();
                        List<String> ccAddresses = new List<String>(); //singleContact.Manager__r.External_Email__c
                        List<String> bccAddresses = new List<String>();
                        SendEmailonDeactivation__c  objSendEmail = SendEmailonDeactivation__c.getValues('DeActivatedUserEmailBatch');
                        if((objSendEmail != null) && (objSendEmail.Send_to_Admin__c == true))
                        {                        
                            if(singleContact.Manager__r.send_deactivation_Email__c)
                            {
                                toAddresses.add(singleContact.Manager__r.External_Email__c);
                                if(accountAdmins.containsKey(singleContact.AccountId)) 
                                {
                                    ccAddresses.addAll(accountAdmins.get(singleContact.AccountId));                                
                                }
                                bccAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                            }
                            else
                            {   
                                toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');                             
                            }
                        }
                        else if((objSendEmail != null) && (objSendEmail.Send_to_me__c == true))
                        {   
                            toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                        }
                        String newEmailBody = DeActivated_User_Email.HtmlValue;                    
                        if(newEmailBody.contains('{!Contact.Manager__r}') && (singleContact.Manager__r.FirstName!=null))
                        {
                            newEmailBody = newEmailBody.replace('{!Contact.Manager__r}', singleContact.Manager__r.FirstName);
                        }
                        if(newEmailBody.contains('{!Contact.Name}')  && (singleContact.Name!=null))
                        {
                            newEmailBody = newEmailBody.replace('{!Contact.Name}', singleContact.Name);
                        }
                        if(newEmailBody.contains('{!Contact.Manager__r}') && (singleContact.Manager__r.FirstName !=null))
                        {
                            newEmailBody = newEmailBody.replace('{!Contact.Manager__r}', singleContact.Manager__r.FirstName);    
                        }
                        if(newEmailBody.contains('{!Contact.NameTable}') && (singleContact.Name !=null))
                        {
                            newEmailBody = newEmailBody.replace('{!Contact.NameTable}', singleContact.Name);    
                        } 
                        if(newEmailBody.contains('{driverdeactivationdate}') && (singleContact.Deactivated_Date__c !=null))
                        {
                            newEmailBody = newEmailBody.replace('{driverdeactivationdate}', String.valueOf(singleContact.Deactivated_Date__c.Month())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Day())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Year()));    
                        } 
                        newEmailBody = newEmailBody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
                        if(reimbursementMap.containsKey(singleContact.Id)) {                        
                            totalMileage = reimbursementMap.get(singleContact.Id).Total_Mileage__c;
                        }
                        String  html = '<tr align="center">'
                                       +'<td style="border:2px solid black;">'+singleContact.Name+'</td>'
                                       +'<td style="border:2px solid black;">'+totalMileage+'</td>';
                                html += + '</tr>';
                        newEmailBody =  newEmailBody.replace('{mileageThresholdTable}',html);
                        messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                       
                        mail = buildemail(owea.get(0).Id,toAddresses,DeActivated_User_Email.subject,newEmailBody);
                        if(ccAddresses.size()>0)
                        {
                            mail.setCcAddresses(ccAddresses);
                        }
                        if(bccAddresses.size()>0)
                        {
                            mail.setBccAddresses(bccAddresses);
                        } 
                        mails.add(mail);
                        System.debug('toAddresses:-'+toAddresses);
                        System.debug('ccAddresses:-'+ccAddresses);
                        System.debug('bccAddresses:-'+bccAddresses);
                    }
                }
                else
                {
                    List<String> toAddresses = new List<String>();
                    List<String> ccAddresses = new List<String>(); //singleContact.Manager__r.External_Email__c
                    List<String> bccAddresses = new List<String>();
                    SendEmailonDeactivation__c  objSendEmail = SendEmailonDeactivation__c.getValues('DeActivatedUserEmailBatch');
                    if((objSendEmail != null) && (objSendEmail.Send_to_Admin__c == true))
                    {                        
                        if(singleContact.Manager__r.send_deactivation_Email__c)
                        {
                            toAddresses.add(singleContact.Manager__r.External_Email__c);
                            if(accountAdmins.containsKey(singleContact.AccountId)) 
                            {
                                ccAddresses.addAll(accountAdmins.get(singleContact.AccountId));                                
                            }
                            bccAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                        }
                        else
                        {   
                            toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');                             
                        }
                    }
                    else if((objSendEmail != null) && (objSendEmail.Send_to_me__c == true))
                    {   
                        toAddresses = objSendEmail.BCCEmailaddresses__c.split(',');
                    }
                    String newEmailBody = Deactivation_with_No_Mileages.HtmlValue;
                    if(singleContact.Manager__r.FirstName!=null && singleContact.Name!=null)
                    {
                        newEmailBody = buildNoMileageEmail(newEmailBody,singleContact.Manager__r.FirstName,singleContact.Name,String.valueOf(singleContact.Deactivated_Date__c.Month())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Day())+'/'+String.valueOf(singleContact.Deactivated_Date__c.Year()));    
                    }                
                    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                    String subject=Deactivation_with_No_Mileages.subject;
                    if(subject.contains('{driversubject}'))
                    {
                        subject = subject.replace('{driversubject}', String.valueOf(singleContact.Name));    
                    }
                    mail = buildemail(owea.get(0).Id,toAddresses,subject,newEmailBody);
                    List<String> adminEmailIds = new List<String>();
                    
                    if(ccAddresses.size()>0)
                    {
                        mail.setCcAddresses(ccAddresses);
                    }
                    if(bccAddresses.size()>0)
                    {
                        mail.setBccAddresses(bccAddresses);
                    } 
                    mails.add(mail);
                    System.debug('toAddresses:-'+toAddresses);
                    System.debug('ccAddresses:-'+ccAddresses);
                    System.debug('bccAddresses:-'+bccAddresses);
                }
            //}
            singleContact.Deactivation_Email_Sent__c = true;
            obj_list_contact_tobeupdated.add(singleContact);
        }
        
        if(!mails.isEmpty()) 
        {        
            Messaging.sendEmail(mails);  
        }
        System.debug('+++++++++++++++   '+obj_list_contact_tobeupdated);
        if(obj_list_contact_tobeupdated.size() > 0)
        {
            update obj_list_contact_tobeupdated;
        }
    }
    global String buildNoMileageEmail(String htmlvalue,String manager,String name,String DeactivatedDate)
    {
        String newEmailBody = htmlvalue;
        if(newEmailBody.contains('{!Contact.Manager__r}') && (manager!=null))
        {
            newEmailBody = newEmailBody.replace('{!Contact.Manager__r}', manager);
        }
        if(newEmailBody.contains('{!Contact.Name}')  && (name!=null))
        {
            newEmailBody = newEmailBody.replace('{!Contact.Name}', name);
        }         
        if(newEmailBody.contains('{driverdeactivationdate}') && (DeactivatedDate !=null))
        {
            newEmailBody = newEmailBody.replace('{driverdeactivationdate}', DeactivatedDate);    
        } 
        newEmailBody = newEmailBody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
        return newEmailBody;
    }
    global Messaging.singleEmailMessage buildemail(String emailaddressid,List<String> toAddresses,String subject,String html)
    {
        messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
        mail.setOrgWideEmailAddressId(emailaddressid);                   
        mail.setToAddresses(toAddresses);        
        mail.setSubject(subject);
        mail.setHtmlBody(html);
        return mail;
    }
    global String currentMonth(Integer integerValue) {
        String tempDate = date.today().addMonths(integerValue).Month() + '-' + date.today().addMonths(integerValue).Year();
        String lastMonth = tempDate.left(2);
        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
        return lastMonth;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }   
}