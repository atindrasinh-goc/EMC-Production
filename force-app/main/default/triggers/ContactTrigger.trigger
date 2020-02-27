// AuditTrailCreate and SendEmailWhenContactInserted
trigger ContactTrigger on Contact (after Update, after insert, before insert, before update) {
    public string name;
    public string accountId;
    // try{
        if(Trigger.isUpdate && Trigger.isAfter && checkRecursive.runOnce()) {
        // List<Contact> contactList = new List<Contact>();
        /* Map<String,String> contactWiseRoleMap = new Map<String,String>();*/
            Map<String,String> managerNames = new Map<String,String>();
            set<String> contactOldIdList = new set<String>();
            //List<Id> contactIds = new List<Id>();
            Map<String,String> contactInfo = new Map<String,String>();
           
            Map<String,String> accountInfo = new Map<String,String>();
        // contactList = [Select id,Name,Role__c,FirstName,LastName,Manager__c,Manager__r.Name from Contact where ID IN: Trigger.New];
            for(Contact currentContact : Trigger.New)
            {
                if(currentContact.Manager__c!=Trigger.oldMap.get(currentContact.id).Manager__c)
                {
                    name = currentContact.FirstName + ' '+ currentContact.FirstName;
                    accountId = currentContact.AccountId;
                    contactOldIdList.add(currentContact.Manager__c);
                    contactOldIdList.add(Trigger.oldMap.get(currentContact.id).Manager__c);
                }
                
                if(currentContact.Phone != Trigger.oldMap.get(currentContact.id).Phone && String.isNotBlank(currentContact.Triplog_UserID__c)) {
                    
                    contactInfo.put(currentContact.Triplog_UserID__c, currentContact.Phone);
                }
            }   
            for(Contact currentContact : [Select id,Triplog_UserID__c,Account.Triplog_API__c from Contact where Triplog_UserID__c =: contactInfo.keySet() and Account.isUsingTriplog__c=true])     
            {
                accountInfo.put(currentContact.Triplog_UserID__c,currentContact.Account.Triplog_API__c);
            }

            if(contactOldIdList.size()>0)
            {
                for(Contact currentContact : [Select id,name from Contact where ID IN:contactOldIdList])
                {
                    // this Is specially for Old Managers of Current Contact.
                    managerNames.put(currentContact.id,currentContact.name);
                }
            }        
            ContactTriggerHelper.TrackHistory(Trigger.oldMap,Trigger.new,managerNames);

            if(contactInfo.size() > 0 && accountInfo.size()>0){
                ContactTriggerHelper.putHTTPUpdateUserPhoneTriplog(contactInfo,accountInfo);
            }
            /*Set<Id> conIds = new Set<Id>();
            Set<Id> contactIds = new Set<Id>();
            Set<Id> contactNameChange = new Set<Id>();
            for(Contact singleContact : Trigger.New) {
                if(singleContact.Role__c != Trigger.oldMap.get(singleContact.Id).Role__c) {
                    conIds.add(singleContact.Id);  
                }             
                if(singleContact.External_Email__c != Trigger.oldMap.get(singleContact.Id).External_Email__c) {
                    contactIds.add(singleContact.Id);
                }
                if((singleContact.FirstName != Trigger.oldMap.get(singleContact.Id).FirstName) || (singleContact.LastName != Trigger.oldMap.get(singleContact.Id).LastName)) {
                    contactNameChange.add(singleContact.Id);
                }
            }
        if(!conIds.isEmpty()) {
                ContactTriggerHelper.changeProfileRole(conIds,contactWiseRoleMap);
            } 
            if(!contactIds.isEmpty()) {
                ContactTriggerHelper.updateUserEmail(contactIds);
            }
            if(!contactNameChange.isEmpty()) {
                ContactTriggerHelper.updateUserData(contactNameChange);
            } */
            ContactTriggerHelper.updateComplianceStatus(Trigger.New, Trigger.oldMap);
        // ContactTriggerHelper.sendEmailToAdmin(Trigger.New, Trigger.oldMap, Trigger.Old);
        }
        
        if(Trigger.isInsert && trigger.isAfter) {
            //helper class for single email but bulk messages
            // ContactTriggerHelper.sendEmail(trigger.new);

        // ContactTriggerHelper.setAdminAsManager(Trigger.New);
            if(Trigger.isAfter) {
                ContactTriggerHelper.CommunityUserCreate(Trigger.new);
                
            }
        }
        
        if(Trigger.isBefore && checkRecursive.runSecondFlag()) {
            ContactTriggerHelper.populatestaticValue(Trigger.New);
        }
        
        if(Trigger.isInsert && Trigger.isBefore) 
        {
        for(Contact currentContact : Trigger.new)
            {
                name = currentContact.FirstName + ' '+ currentContact.FirstName;
                accountId = currentContact.AccountId;
                if(currentContact.External_Email__c != null)
                {
                    name = currentContact.FirstName + ' '+ currentContact.FirstName;
                    accountId = currentContact.AccountId;
                    currentContact.Email = currentContact.External_Email__c.toLowerCase();
                }
            }
            
            ContactTriggerHelper.CheckVehicalYearAndModel(Trigger.new);
            ContactTriggerHelper.updateTimeZone(Trigger.new);
        }
        else if(Trigger.isBefore && Trigger.isUpdate)
        {
            List<Contact> updateContactList = new List<Contact>();
            for(Contact currentContact : Trigger.New)
            {
                name = currentContact.FirstName + ' '+ currentContact.FirstName;
                accountId = currentContact.AccountId;
                if(currentContact.Role__c=='Driver' || currentContact.Role__c=='Driver/Manager' || currentContact.Role__c == StaticValues.roleAdminDriver)
                {
                    if((String.isNotBlank(Trigger.oldMap.get(currentContact.id).Vehicle_Type__c) && String.isNotBlank(currentContact.Vehicle_Type__c) && (currentContact.Vehicle_Type__c!=Trigger.oldMap.get(currentContact.id).Vehicle_Type__c)))
                    {
                        updateContactList.add(currentContact);
                    }
                    else if(String.isBlank(currentContact.Vehicle_Type__c))
                    {
                        currentContact.addError('Please Enter Valid Standard Vehicle Make Model and Year');
                    }
                    else 
                    {
                        updateContactList.add(currentContact);
                    }
                    name = currentContact.FirstName + ' '+ currentContact.FirstName;
                    accountId = currentContact.AccountId;
                }            
            }
            if(updateContactList.size()>0)
            {
                ContactTriggerHelper.CheckVehicalYearAndModel(updateContactList);
            }
            updateContactList = new List<Contact>();
            for(Contact currentContact : Trigger.New)
            {
                name = currentContact.FirstName + ' '+ currentContact.FirstName;
                accountId = currentContact.AccountId;
                if(currentContact.External_Email__c!=Trigger.oldMap.get(currentContact.id).External_Email__c)
                {
                    name = currentContact.FirstName + ' '+ currentContact.FirstName;
                    accountId = currentContact.AccountId;
                    currentContact.Email = currentContact.External_Email__c.toLowerCase();
                }
                if(currentContact.MailingState!=Trigger.oldMap.get(currentContact.id).MailingState || currentContact.Driving_States__c!=Trigger.oldMap.get(currentContact.id).Driving_States__c)
                {
                    updateContactList.add(currentContact);
                }
            }
            System.Debug(updateContactList);
            if(updateContactList.size()>0)
            {
                ContactTriggerHelper.updateTimeZone(updateContactList);
            }
        }
    /*} catch(Exception e){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        EmailTemplate templateId = [Select id, subject, body, HTMLValue from EmailTemplate where name = 'ExceptionEmailTemplate' Limit 1];

        String addressLabel = Label.Test_emailAddress;
        List<String> obj_toaddresses = new List<String>();
        if(addressLabel.contains(',')){
            List<String> addresslist = new List<String>();
            addresslist = addressLabel.split(',');
            for(String s : addresslist)
            {
                obj_toaddresses.add(s);
            }
        }
        else
        {
            obj_toaddresses.add(addressLabel);
        }


        email.setToAddresses(obj_toaddresses);
        string bodyOftemp = templateId.body;
        bodyOftemp = bodyOftemp.replace('{!exceptionmessage}', e.getmessage()+' '+e.getlinenumber());
        bodyOftemp = bodyOftemp.replace('{!convertedexceptionmessage}', 'While inserting or updating'+' '+name);
       
        email.setTemplateID(templateId.Id); 
        email.setSubject(templateId.subject); 
        email.setPlainTextBody(bodyOftemp); 
        if(!Test.isRunningTest()) 
        {
            Messaging.SendEmailResult [] sendSinglemail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }*/
    
}