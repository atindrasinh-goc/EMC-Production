public without sharing class ContactTriggerHelper {
    public static Boolean isRecursive = false;
    public static Boolean isFirstTime = true;
    
    public static void CheckVehicalYearAndModel(List<Contact> contactList){
        Map<String,String> urlMap = new Map<String,String>();
        set<String> vehicleNamesset = new set<String>();

        for(Contact conRec : contactList)
        {
            if(conRec.Vehicle_Type__c!=null)
            {
                vehicleNamesset.add(conRec.Vehicle_Type__c.replace(' ','').toUpperCase());
            }            
        }
        for(Vehicle_URL_Mapping__c u : [SELECT Id, Year__c, Vehicle__c, URL__c,Vehicle_Mapping__c FROM Vehicle_URL_Mapping__c where Vehicle_Mapping__c IN: vehicleNamesset]){
            if((u.URL__c != null || u.URL__c != '') &&(!urlMap.containsKey(u.Vehicle_Mapping__c))){
                urlMap.put(u.Vehicle_Mapping__c,u.URL__c);
            }
        } 
        
        for(Contact conRec : contactList)
        {
            if(conRec.Role__c=='Driver' || conRec.Role__c=='Driver/Manager' || conRec.Role__c == StaticValues.roleAdminDriver )
            {
                if(conRec.Vehicle_Type__c != '')
                {
                    if(urlMap.containsKey(conRec.Vehicle_Type__c.replace(' ','').toUpperCase()))
                    {
                        conRec.Car_Image__c = urlMap.get(conRec.Vehicle_Type__c.replace(' ','').toUpperCase());
                    } 
                    else 
                    {
                        conRec.addError('Please Enter Valid Standard Vehicle Make Model and Year');
                    }
                }
            }
        }
        
    }

    public static void updateTimeZone(List<Contact> contactList){
        set<String> stateAbbrivationset = new set<String>();
        Map<String,String> timeZoneMap = new Map<String,String>();
        for(Contact conRec : contactList)
        {   
            

            if(conRec.MailingState != null)
            {
                stateAbbrivationset.add(conRec.MailingState);
            }   
            else{
                if(conRec.Driving_States__c!=null && conRec.Driving_States__c.contains(';')){
                    stateAbbrivationset.addAll(conRec.Driving_States__c.split(';'));
                }
                else if(conRec.Driving_States__c!=null){
                    stateAbbrivationset.add(conRec.Driving_States__c);
                }
            }         
        }
        for(Address__c objAdd : [SELECT Id, Time_Zone__c, State__c, Abbreviation__c FROM Address__c WHERE Abbreviation__c IN : stateAbbrivationset]){
            timeZoneMap.put(objAdd.Abbreviation__c, objAdd.Time_Zone__c);
        }
        for(Contact conRec : contactList){
            if(conRec.MailingState != null){
                if(timeZoneMap.containsKey(conRec.MailingState)){
                    conRec.Time_Zone__c = timeZoneMap.get(conRec.MailingState);
                }
            }            
            else {
                if(conRec.Driving_States__c != null){
                    if(timeZoneMap.containsKey(conRec.Driving_States__c)){
                        conRec.Time_Zone__c = timeZoneMap.get(conRec.Driving_States__c);
                    }
                }
            }
        }
    }
    
    @Future(callout = true)
    public static void putHTTPUpdateUserPhoneTriplog(Map<String,String> tripIdWisePhone,Map<String,String> triplogidwiseAPIkey) 
    {
        String url = 'https://triplogmileage.com/web/api/users/';
        Http h;
        HttpRequest req;
        HttpResponse res;

        for(String currentUserId : triplogidwiseAPIkey.keySet())
        {
            if(tripIdWisePhone.containsKey(currentUserId))
            {
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('phone',tripIdWisePhone.get(currentUserId));
                gen.writeEndObject();
                h = new Http();
                req = new HttpRequest();
                req.setEndpoint('https://triplogmileage.com/web/api/users/' + currentUserId);
                req.setMethod('PUT');
                req.setTimeout(120000);
                req.setbody(gen.getAsString());
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'apikey '+ triplogidwiseAPIkey.get(currentUserId));
                if(!Test.isRunningTest())
                {
                    res = h.send(req);            
                }
            }
           
        }
    }

    public static void  CommunityUserCreate(List<Contact> contactList) {
        List<User> createUserList = new List<User>();

        /*if(Trigger.isBefore) {
            map<string, Id> conemailtoid = new  map<string, ID>();

            for(Contact conObj: [SELECT
                                    id, 
                                    Manager__c, 
                                    External_Email__c, 
                                    Email
                                FROM
                                    Contact
                                WHERE External_Email__c != '']) {
                    conemailtoid.put(conObj.External_Email__c.touppercase(), conObj.id);
                
            }
            for(Contact cc: contactList) {
                if(string.isNotBlank(cc.Manager_External_Email__c)) {
                    if(conemailtoid.containsKey(cc.Manager_External_Email__c.touppercase())) {
                        cc.Manager__c = conemailtoid.get(cc.Manager_External_Email__c.touppercase());
                    }
                }
            }
        }*/

        // if(Trigger.isAfter) {
            list<Profile> profileList = [SELECT
                                            Id, 
                                            Name
                                        FROM
                                            Profile
                                        WHERE
                                            Name = 'Customer Community Login User - Driver' OR 
                                            Name = 'Customer Community Login User - Manager' OR 
                                            Name = 'Customer Community Login User - Super Manager' OR 
                                            Name = 'Customer Community Login User - Manager/Driver' OR 
                                            Name = 'Customer Community Login User - Super Manager/Driver'];
            
            Map<string,Id> profilemap = new Map<string,ID>();
            for(Profile profileObj : profileList){
                if(profileObj.Name == 'Customer Community Login User - Driver' ){
                   profilemap.put('Driver',profileObj.id);
                } 
                else if(profileObj.Name == 'Customer Community Login User - Manager'){
                   profilemap.put('Manager',profileObj.id);
                }
                else if(profileObj.Name == 'Customer Community Login User - Manager/Driver'){
                    profilemap.put('Driver/Manager',profileObj.id);
                }
                else if(profileObj.Name == 'Customer Community Login User - Super Manager/Driver'){
                   profilemap.put(StaticValues.roleAdminDriver ,profileObj.id); 
                }
                else if(profileObj.Name == 'Customer Community Login User - Super Manager'){
                   profilemap.put('Admin',profileObj.id);
                }
            }
            
            for(Contact conObj : contactList) {
                if(conObj.IsCreatedFromCommunity__c == true && profilemap.containskey(conObj.Role__c))  {
                    createUserList.add(CreateUserFromCommunity(conObj,profilemap.get(conObj.Role__c)));
                }
            }
            if(createUserList.size()>0)
            {
                insert createUserList;
            }            
        // }
    }

    public static User CreateUserFromCommunity(Contact contObj, Id profileId){
        User userObj = new User();
        userObj.FirstName = contObj.FirstName;
        userObj.LastName = contObj.LastName; 
        userObj.Email = contObj.External_Email__c; 
        userObj.EmailEncodingKey = 'UTF-8'; 
        userObj.LanguageLocaleKey = 'en_US'; 
        userObj.LocaleSidKey = 'en_US'; 
        userObj.TimeZoneSidKey = 'America/Los_Angeles'; 
        userObj.UserName = contObj.External_Email__c; 
        userObj.Profileid = profileId; 
        userObj.Alias = contObj.External_Email__c.left(8); 
        userObj.ContactId = contObj.id;
        return userObj;
    }
   /* 
    @future
    public static Void changeProfileRole(Set<Id> conIds,Map<String,String> conIdRole) {
        string str = 'true';
        if(str.equalsIgnoreCase(Label.Is_Update_User_Profile)) {
            
            Map<string, string> roleToProfileId = new  Map<string, string>();
            List<User> users = new  List<User>();            
            

            for(Profile profile: [SELECT Id, Name FROM Profile]) {
                if(profile.Name == 'Customer Community Login User - Driver') {
                    roleToProfileId.put('Driver', profile.Id);
                }
                if(profile.Name == 'Customer Community Login User - Manager') {
                    roleToProfileId.put('Manager', profile.Id);
                }
                if(profile.Name == 'Customer Community Login User - Manager/Driver') {
                    roleToProfileId.put('Driver/Manager', profile.Id);
                }
                if(profile.Name == 'Customer Community Login User - Super Manager') {
                    roleToProfileId.put('Admin', profile.Id);
                }
            }
            for(User user: [SELECT Id, ContactId, ProfileId FROM USER WHERE ContactId IN : conIds]) {
                if(conIdRole.containsKey(user.ContactId) && roleToProfileId.containsKey(conIdRole.get(user.ContactId))) {
                    user.profileId = roleToProfileId.get(conIdRole.get(user.ContactId));
                }
            }
            if(!users.isEmpty()) {
                Update users;
            }
        }
    }
    public static Void setAdminAsManager(List<Contact> newContacts) {
        Set<Id> accountIds = new  Set<Id>();
        //List<Contact> contacts = new  List<Contact>();
        List<Contact> contactsToInsert = new  List<Contact>();
        Map<Id, Id> accountToContact = new  Map<Id, Id>();
        for(Contact contact: newContacts) {
            if(contact.Manager__c == null && contact.Role__c != 'Admin') {
                accountIds.add(contact.AccountId);
                //contacts.add(contact);
            }
        }
        for(Contact contact: [SELECT Id, AccountId FROM Contact WHERE AccountId in: accountIds AND Role__c = 'Admin']) {
            accountToContact.put(contact.AccountId, contact.Id);
        }
        for(Contact contact: newContacts) {
            if(accountToContact.containsKey(contact.AccountId)) {
                Contact contactClone = contact.clone(false, false, false, false);
                contactClone.Id = contact.Id;
                contactClone.Manager__c = accountToContact.get(contact.AccountId);
                contactsToInsert.add(contactClone);
            }
        }
        if(!contactsToInsert.isEmpty()) {
            isRecursive = true;
            update contactsToInsert;
            isRecursive = false;
        }
    }*/
    
    public static void updateComplianceStatus(List<Contact> newCon, Map<ID, Contact> conOldMap) {
    System.Debug(newCon[0].compliancestatus__c);
    System.Debug(conOldMap.get(newCon[0].id).compliancestatus__c);
    
        List<String> emails = new List<String>();
        EmailTemplate emTmp = new EmailTemplate();
        Messaging.SingleEmailMessage mail;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        // Define Email Template
        Map<String,EmailTemplate> nameWithTemplate = new Map<String,EmailTemplate>();
        for(EmailTemplate e : [SELECT Id, Name, developerName, Subject, body FROM EmailTemplate Limit 1]) {
            nameWithTemplate.put(e.developerName, e);
        }
        OrgWideEmailAddress[] owea;
        owea = [select Id, address from OrgWideEmailAddress where Address = 'driverservices@mburse.com'];
        for(Contact con : newCon) {
            if(con.Role__c == 'Driver' && (conOldMap.get(con.id).compliancestatus__c != con.compliancestatus__c)) {
                emails.add(con.External_Email__c);
                if(con.compliancestatus__c == 'Yes' && nameWithTemplate.containskey('Driver_Compliance_Status_Yes')) {
                    emTmp = nameWithTemplate.get('Driver_Compliance_Status_Yes');
                } else if(con.compliancestatus__c == 'No – Vehicle Age' && nameWithTemplate.containskey('Driver_Compliance_Status_No_Vehicle_Age')) {
                    emTmp = nameWithTemplate.get('Driver_Compliance_Status_No_Vehicle_Age');
                } else if(con.compliancestatus__c == 'No – Vehicle Value' && nameWithTemplate.containskey('Driver_Compliance_Status_No_Vehicle_Value')) {
                    emTmp = nameWithTemplate.get('Driver_Compliance_Status_No_Vehicle_Value');
                } else if(con.compliancestatus__c == 'No – Insurance not meeting minimum' && nameWithTemplate.containskey('Driver_Compliance_Status_No_Insurance_not_meeting_minimum')) {
                    emTmp = nameWithTemplate.get('Driver_Compliance_Status_No_Insurance_not_meeting_minimum');
                } else if(con.compliancestatus__c == 'Resubmit Insurance – you submitted an insurance card' && nameWithTemplate.containskey('Driver_Compliance_Status_Resubmit_Insurance')) {
                    emTmp = nameWithTemplate.get('Driver_Compliance_Status_Resubmit_Insurance');
                }else{
                    emTmp = null;
                }
                system.debug('=====emTmp===>'+emTmp);
                //system.debug('=====emTmp===>'+emTmp);
                if(!emails.isEmpty() && emTmp != null) {
                    mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(emails);
                    //Set Email Subject
                    mail.setSubject(emTmp.Subject);
                    //Body of Email
                    mail.setPlainTextBody(emTmp.Body.replace('{!Contact.FirstName}', con.FirstName));
                    if(owea.size()>0) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setBccAddresses(new String[] {'natavar.goc@gmail.com','Minkesh.patel@getoncrm.com','sanket.goc@gmail.com'});
                    mails.add(mail);                    
                }
            }
        }
        //Sending the Email
        SendEmail__c  objSendEmail = SendEmail__c.getValues('Send Email For Compliance');
        if(objSendEmail.Send_email_from_code__c==true)
        {
            //Messaging.sendEmail(mails);
        }
           
    }
/* SHould shift in Batch Class :- UserRoleUpdateBatch
    @future
    public static void updateUserEmail (Set<Id> contactIds) {
        List<User> listofUsers = new List<User>();
        if(!contactIds.isEmpty()) {
            for(User singleUser : [SELECT Id,Email,UserName,ContactId,Contact.External_Email__c FROM User WHERE ContactId IN: contactIds]) {
                singleUser.UserName = singleUser.Contact.External_Email__c;
                singleUser.Email = singleUser.Contact.External_Email__c;
                listofUsers.add(singleUser);
            }
        }
        if(!listofUsers.isEmpty()) {
            try {
                update listofUsers;
            }catch (DmlException e) {
                System.debug('listofUsers:'+e.getMessage());
            }
        }
    }
    
    @future
    public static void updateUserData (Set<Id> contactNameChange) {
        List<User> updateUser = new List<User>();
        if(!contactNameChange.isEmpty()) {
            for(User userData : [SELECT Id,Contact.FirstName,Contact.LastName FROM User WHERE ContactId IN: contactNameChange]) {
                userData.FirstName = userData.Contact.FirstName;
                userData.LastName = userData.Contact.LastName;
                updateUser.add(userData);
            }
        }
        if(!updateUser.isEmpty()) {
            try {
                update updateUser;
            } catch (DmlException e) {
                System.debug('updateUser:' +e.getMessage());
            }
        }
    }*/
    /*public static Void sendEmailToAdmin(List<Contact> newContacts, Map<Id, Contact> oldContacts, List<Contact> oldCons) {
        OrgWideEmailAddress[] owea = [SELECT Id, address FROM OrgWideEmailAddress WHERE Address = 'driverservices@mburse.com'];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Map<Id, String> oldContactIdToName = new Map<Id, String>();
        //List<Contact> contacts = new List<Contact>();
        for(Contact oldCon : oldCons) {
            oldContactIdToName.put(oldCon.Id, oldCon.Name);
        }
        for(Contact contact : newContacts) {
            if(!owea.isEmpty() && contact.Deactivated_Date__c != oldContacts.get(contact.Id).Deactivated_Date__c ||
                contact.Role__c != oldContacts.get(contact.Id).Role__c ||
                contact.Vehicle_Type__c != oldContacts.get(contact.Id).Vehicle_Type__c ||
                contact.Manager__c != oldContacts.get(contact.Id).Manager__c ||
                contact.MailingPostalCode != oldContacts.get(contact.Id).MailingPostalCode ||
                contact.Employee_ID__c != oldContacts.get(contact.Id).Employee_ID__c ||
                contact.Email != oldContacts.get(contact.Id).Email ||
                contact.File_Number__c != oldContacts.get(contact.Id).File_Number__c) {
                string htmlBody = 'Hi, the following details of drivers have been changed. <br/><br/>';
                htmlBody += '<div style="border:2px border-radius:15px;">' + '<table style="border:3px solid black; border-collapse:collapse;">' + '<tr  bgcolor="#d4d4d4">' + '<th style="border:2px solid black;" width="5%">User</th>' + '<th style="border:2px solid black;" width="5%">Deactivation Date</th>' + '<th style="border:2px solid black;" width="5%">Role</th>' + '<th style="border:2px solid black;" width="5%">Standard Vehicle</th>' + '<th style="border:2px solid black;" width="5%">Home Zip Code</th>' + '<th style="border:2px solid black;" width="5%">Employee Id</th>' + '<th style="border:2px solid black;" width="5%">Email</th>' + '<th style="border:2px solid black;" width="5%">File Number</th>';
                htmlBody += +'</tr>';
                htmlBody += +'<tr align="center">' + '<td style="border:2px solid black;">' + contact.FirstName + ' ' +contact.LastName + '</td>';
                if(contact.Deactivated_Date__c != oldContacts.get(contact.Id).Deactivated_Date__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).Deactivated_Date__c + ' To ' + contact.Deactivated_Date__c + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                if(contact.Role__c != oldContacts.get(contact.Id).Role__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).Role__c + ' To ' + contact.Role__c + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                if(contact.Vehicle_Type__c != oldContacts.get(contact.Id).Vehicle_Type__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).Vehicle_Type__c + ' To ' + contact.Vehicle_Type__c + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }*/
                /*if(contact.Manager__c != oldContacts.get(contact.Id).Manager__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContactIdToName.get(oldContacts.get(contact.Id).Manager__c) + ' To ' + contact.Manager__r.FirstName +  ' ' + contact.Manager__r.LastName + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }*/
                /*if(contact.MailingPostalCode != oldContacts.get(contact.Id).MailingPostalCode) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).MailingPostalCode + ' To ' + contact.MailingPostalCode + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                if(contact.Employee_ID__c != oldContacts.get(contact.Id).Employee_ID__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).Employee_ID__c + ' To ' + contact.Employee_ID__c + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                if(contact.Email != oldContacts.get(contact.Id).Email ) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).Email + ' To ' + contact.Email + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                if(contact.File_Number__c != oldContacts.get(contact.Id).File_Number__c) {
                    htmlBody += +'<td style="border:2px solid black;"> From ' + oldContacts.get(contact.Id).File_Number__c + ' To ' + contact.File_Number__c + '</td>';
                } else {
                    htmlBody += +'<td style="border:2px solid black;"> None </td>';
                }
                htmlBody += +'</tr>';
                htmlBody += '</table>';
                messaging.singleEmailMessage mail = new  messaging.singleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                //Setting user email in to address con.External_Email__c
                string[] toAddresses;
                toAddresses = new string[]{System.Label.DriverServicesEmail};
                // Assign the addresses for the To and CC lists to the mail object
                mail.setToAddresses(toAddresses);
                //Email subject to be changed
                mail.setSubject('Updated User Details');
                //Body of email
                mail.setHtmlBody(htmlBody);
                mail.setBccAddresses(new String[] {'natavar.goc@gmail.com','Minkesh.patel@getoncrm.com'});
                mails.add(mail);
            }
        }
        if(!mails.isEmpty()) {
            //Messaging.sendEmail(mails);
        }
    }*/
    
    //Send Email regarding New Drivers
    /*public static void sendEmail(List<Contact> contactList) {
    
        EmailTemplate templateId = [Select id, subject, body, HTMLValue from EmailTemplate where name = 'welcomeEmailforapp' Limit 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Contact contObj : contactList){
            if(contObj.IsCreatedFromCommunity__c == true){
                //For New Driver Send E-Mail
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(contObj.OwnerId);
                string[] toAddresses = new string[]{System.Label.DriverServicesEmail};
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('mburse@driverservices.com');
                mail.setSenderDisplayName('The mBurse Team');
                mail.setTemplateID(templateId.Id); 
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
        }      
        if(!Test.isRunningTest()){  
        //Messaging.sendEmail(mails);
        }
    }*/
    
    
    //Track History of Contact
    public static void TrackHistory(Map<ID,Contact> conOld,List<Contact> contactListNew,Map<String,String> managerNames){
        
        //Map for Manager Name
        
        //Audit Trial
        list<AuditTrail__c> newAuditTrialCreate=new list<AuditTrail__c>();
        for(Contact c:contactListNew){
            if(c.id==conOld.get(c.id).id){
                if(c.Fixed_Amount__c!=conOld.get(c.id).Fixed_Amount__c)
                newAuditTrialCreate.add(new AuditTrail__c(Field__c='Fixed Amount',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=string.valueof(c.Fixed_Amount__c),OldValue__c=String.Valueof(conOld.get(c.id).Fixed_Amount__c),Contact__c=c.id));
                if(c.Maintenance_and_Tires__c!=conOld.get(c.id).Maintenance_and_Tires__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Maintenance and Tires',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=String.valueof(c.Maintenance_and_Tires__c),OldValue__c=string.valueof(conOld.get(c.id).Maintenance_and_Tires__c),Contact__c=c.id));
                if(c.Vehicle1Odometer__c!=conOld.get(c.id).Vehicle1Odometer__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Vehicle 1 Odometer',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=String.Valueof(c.Vehicle1Odometer__c),OldValue__c=String.Valueof(conOld.get(c.id).Vehicle1Odometer__c),Contact__c=c.id));
                if(c.Vehicle2Odometer__c!=conOld.get(c.id).Vehicle2Odometer__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Vehicle 2 Odometer',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=String.Valueof(c.Vehicle2Odometer__c),OldValue__c=String.Valueof(conOld.get(c.id).Vehicle2Odometer__c),Contact__c=c.id));
                if(c.MailingStreet!=conOld.get(c.id).MailingStreet || c.MailingCity!=conOld.get(c.id).MailingCity || c.MailingState!=conOld.get(c.id).MailingState || c.MailingPostalCode!=conOld.get(c.id).MailingPostalCode || c.MailingCountry!=conOld.get(c.id).MailingCountry ){
                    string newval=(c.MailingStreet!=null?c.MailingStreet:'') +' '+ (c.MailingCity!=null?c.MailingCity:'') +' '+ (c.MailingState!=null?c.MailingState:'') +' '+ (c.MailingPostalCode!=null?c.MailingPostalCode:'') +' '+ (c.MailingCountry!=null?c.MailingCountry:'');
                    string oldVal=(conOld.get(c.id).MailingStreet!=null?conOld.get(c.id).MailingStreet:'') +' '+ (conOld.get(c.id).MailingCity!=null?conOld.get(c.id).MailingCity:'') +' '+ (conOld.get(c.id).MailingState!=null?conOld.get(c.id).MailingState:'') +' '+ (conOld.get(c.id).MailingPostalCode!=null?conOld.get(c.id).MailingPostalCode:'') +' '+ (conOld.get(c.id).MailingCountry!=null?conOld.get(c.id).MailingCountry:'');
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Address',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=newval,OldValue__c=oldVal,Contact__c=c.id));
                }
                if(c.MPG__c!=conOld.get(c.id).MPG__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Miles per Gallon',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=String.Valueof(c.MPG__c),OldValue__c=String.Valueof(conOld.get(c.id).MPG__c),Contact__c=c.id));
                if(c.Manager__c!=conOld.get(c.id).Manager__c) 
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Manager',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=managerNames.get(c.Manager__c),OldValue__c=managerNames.get(conOld.get(c.id).Manager__c),Contact__c=c.id));
                if(c.compliancestatus__c!=conOld.get(c.id).compliancestatus__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Compliance Status',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=String.Valueof(c.compliancestatus__c),OldValue__c=String.Valueof(conOld.get(c.id).compliancestatus__c),Contact__c=c.id));
                if(c.Vehicle_Type__c!=conOld.get(c.id).Vehicle_Type__c)
                    newAuditTrialCreate.add(new AuditTrail__c(Field__c='Standard Vehicle Make Model and Year',Timestamp__c=Datetime.now(),Modifiedby__c=UserInfo.getFirstName()+' '+UserInfo.getLastName(),NewValue__c=c.Vehicle_Type__c,OldValue__c=conOld.get(c.id).Vehicle_Type__c,Contact__c=c.id));
                }
            //for(String ConOldMap:conOld.keySet()){
                
           // }
        }
    
        if(newAuditTrialCreate.Size()>0)
            upsert newAuditTrialCreate; 
    }
    
    //Populate Contact Fields
    public static void populatestaticValue(List<Contact> conList){
        Boolean isEMCUser = [select UserRole.name from User where Id=:userinfo.getUserId()].UserRole.Name == 'EMC' ? true : false;

        for(Contact c : conList) {
            if(!isEMCUser){
                c.Pay_Number__c = '3';
                c.Batch_ID_Fixed__c = 'M351';
                c.Adjust_Ded_Code_Fixed__c = 'MR';
                c.Batch_Variable_ID__c = 'M352';
                c.Adjust_Ded_Code_Variable__c = 'VR';
                c.Special_Action__c = 'W';  
            }  else {
                c.Pay_Number__c = String.IsBlank(c.Pay_Number__c) ? '3' : c.Pay_Number__c;
                c.Batch_ID_Fixed__c = String.IsBlank(c.Batch_ID_Fixed__c) ? 'M351' : c.Batch_ID_Fixed__c;
                c.Adjust_Ded_Code_Fixed__c = String.IsBlank(c.Adjust_Ded_Code_Fixed__c) ? 'MR' : c.Adjust_Ded_Code_Fixed__c;
                c.Batch_Variable_ID__c = String.IsBlank(c.Batch_Variable_ID__c) ? 'M352' : c.Batch_Variable_ID__c;
                c.Adjust_Ded_Code_Variable__c = String.IsBlank(c.Adjust_Ded_Code_Variable__c) ? 'VR' : c.Adjust_Ded_Code_Variable__c;
                c.Special_Action__c = String.IsBlank(c.Special_Action__c) ? 'W' : c.Special_Action__c;  
            } 
        }
    }
}