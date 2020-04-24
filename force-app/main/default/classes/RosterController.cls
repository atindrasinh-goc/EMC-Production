/**
@author Natavar Ghodasara
@date 26th Feb 2019
@description RosterController is used to show/edit Employee details.
*/
global without sharing class RosterController 
{
    public static String query;
    /*public static Contact currentLoggedInContact{get;set;}*/
    /*public static String file;*/
    /*public static EmployeeDetails wrapperEmployeeDetails {get;set;}*/
    /*public static String contactDataAsString {get; set;}*/
    /*public static Blob csvFileBody {get;set;}*/
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description RosterController is Default Constructor.    
    */
    
    public RosterController() 
    {
        query='';
        
    }
    public static String getAccountid() {
        if (ApexPages.currentPage().getParameters().containsKey('accid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('accid'))) {
            return ApexPages.currentPage().getParameters().get('accid');
        } else {
            return '';
        }
    }
    public static String getContactid() {
        if (ApexPages.currentPage().getParameters().containsKey('id') && String.isNotBlank(ApexPages.currentPage().getParameters().get('id'))) {
            return ApexPages.currentPage().getParameters().get('id');
        } else {
            return '';
        }
    }
    public static PageReference getRedirected() {

        if (getContactid() != '' && getAccountid() != '') {
            return null;
        } else {
// redirect to error page
            return null;
        }

    }   
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description editNewEmployee is used to edit Employee to the system.
    @param String employee details. 
    */
    @RemoteAction
    public static ResultResponse editInlineNewEmployee(String listofemployee,String accid,String contactid)
    {
        //System.debug(listofemployee);
        ResultResponse result = new ResultResponse();
        result.hasError = false;
        result.message = '';

        if(listofemployee!=null)
        {
            system.debug('inside roster controller');
            query='';
            List<EmployeeDetails> employeeList = new List<EmployeeDetails>();
            employeeList = (List<EmployeeDetails>)Json.deserialize(listofemployee,List<EmployeeDetails>.class);
            //System.debug('currentEmployee:- '+employeeList);
            List<Contact> updateEmployeeList = new List<Contact>();
            List<String> deactivatedEmployees = new List<String>();
            for(EmployeeDetails currentEmployee:employeeList)
            {
                //System.debug('currentEmployee in for Loop :- '+currentEmployee);
                Contact currentContact = new Contact();
                currentContact = WrapperUtils.getContact(currentEmployee);
               
                if(currentContact.Deactivated_Date__c != null && currentContact.IsDeactivated__c!=true && currentContact.Deactivated_Date__c.date()<=System.today())
                {
                    deactivatedEmployees.add(currentContact.id);
                }
                updateEmployeeList.add(currentContact);
            }
            if(updateEmployeeList.size()>0)
            {
                //System.debug('Went for update :- ' +updateEmployeeList);
                 try{
                    System.debug('updateEmployeeList'+updateEmployeeList);
                    update updateEmployeeList;
                } catch (Exception e){
                    //string type = name;
                    system.debug('-------++++++++++++++++');
                    result.hasError = true;
                    result.message = getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                    return result;
                }
               
                
                //result.result = getlistAllEmployees(accid,contactid);  
                //System.debug('updated employee list :- ' +emplist);
            
            }
            system.debug('deactivatedEmployees.size()'+deactivatedEmployees.size());
            system.debug('deactivatedEmployees.size()'+deactivatedEmployees);
            if(deactivatedEmployees.size()>0)
            {
                 Database.executeBatch(new DeActivatedUserBatch(deactivatedEmployees),1);
            }
        }
        return result;
    }

    public static void sendExceptionMails(String message,string convertedmsg){
        System.debug('inside email method');
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
        bodyOftemp = bodyOftemp.replace('{!exceptionmessage}',message);
        bodyOftemp = bodyOftemp.replace('{!convertedexceptionmessage}',convertedmsg);
       
        email.setTemplateID(templateId.Id); 
        email.setSubject(templateId.subject); 
        email.setPlainTextBody(bodyOftemp); 
        if(!Test.isRunningTest()) 
        {
            System.debug('inside email send');
            Messaging.SendEmailResult [] sendSinglemail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }

    public static String getPickListValuesIntoList()
    {         
        List<String> vehicleList = new List<String>();
        List<Account> currentAccountList = [select id,Vehicle_Types__c,CreatedDate from Account where id=:getAccountid() Limit 1];
        
        vehicleList.add(String.valueOf(currentAccountList[0].CreatedDate));
        for(Account currentAccount : currentAccountList)
        {
            if(currentAccount.Vehicle_Types__c!=null && currentAccount.Vehicle_Types__c!='')
            {
                vehicleList.add(currentAccount.Vehicle_Types__c);
            }
        }
        
        return Json.serialize(vehicleList);
    }
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description editNewEmployee is used to edit Employee to the system.
    @param String employee details. 
    */
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description editNewEmployee is used to edit Employee to the system.
    @param String employee details. 
    */
    @RemoteAction
    public static ResultResponse manageEmployee(String addNewEmployee,String accid,String contactid)
    {
        ResultResponse result = new ResultResponse();
        result.hasError = false;
        result.message = '';

        List<EmployeeDetails> employeeList = new List<EmployeeDetails>();
        System.debug('employeeList:--'+addNewEmployee);
        System.debug('employeeList:--+++'+(List<EmployeeDetails>)Json.deserialize(addNewEmployee,List<EmployeeDetails>.class));
        employeeList = (List<EmployeeDetails>)Json.deserialize(addNewEmployee,List<EmployeeDetails>.class);
        
        System.debug('employeeList:--'+employeeList.size());

            if(employeeList.size() > 0) 
            {
                system.debug('inside size check');
                employeeList[0].accountId = accid;
                Contact newContact = new Contact();
                newContact = WrapperUtils.getNewContact(employeeList[0]);
              
                if(employeeList[0].userid!=null)
                {
                    //update
                    newContact.id = employeeList[0].userid;
                    try
                    {   system.debug('inside try');
                        update newContact;
                    }
                    catch(Exception e)
                    {
                        system.debug('inside catch');
                        // return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        result.hasError = true;
                        result.message = getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        return result;
                        //sendExceptionMails(e.getMessage()+String.valueOf(e.getlinenumber()),getCustomExceptionMessage('2'));
                    }
                    if(employeeList[0].resetReimbursementLink==true)
                    {
                        System.ResetPasswordResult currectUserResult = System.resetPassword(((User)(getUser(newContact.id))).id, true);     
                    }
                }
                else
                {
                    system.debug('inside else conn');
                    newContact.AccountId = accid;
                    try
                    {   
                       insert newContact; 
                    }
                    catch(Exception e)
                    {
                        // return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        result.hasError = true;
                        result.message = getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        return result;
                        //return getExcetionTypes(e);                        
                    }
                    // New Code added by natavar on 21/11/2019
                    List<id> newListContactids = new List<id>();
                    if(newContact.role__c != null && newContact.role__c != 'Admin' && newContact.role__c !='Manager')
                    {
                        newListContactids.add(newContact.id);
                    }
                    
                    if(newListContactids.size()>0 && !Test.isRunningTest())
                    {
                        postHTTPCreateNewUserTriplog(newListContactids); 
                    }
                    /*List<User> createUser = new List<User>();
                    list<Profile> profileList = new list<Profile>();
                    if(newContact.Role__c!=null && newContact.Role__c=='Driver')
                    {
                        profileList = [SELECT Id,Name FROM Profile WHERE Name = 'Customer Community Login User - Driver'];                        
                    }
                    else if(newContact.Role__c!=null &&newContact.Role__c=='Manager')
                    {
                        profileList = [SELECT Id,Name FROM Profile WHERE Name = 'Customer Community Login User - Manager'];
                    }
                    else if(newContact.Role__c!=null &&newContact.Role__c=='Driver/Manager')
                    {
                        profileList = [SELECT Id,Name FROM Profile WHERE Name = 'Customer Community Login User - Manager/Driver'];
                    }
                    else if(newContact.Role__c!=null &&newContact.Role__c=='Admin')
                    {
                        profileList = [SELECT Id,Name FROM Profile WHERE Name = 'Customer Community Login User - Super Manager'];
                    }
                    if(profileList.size()>0)
                    {
                        User newuser = new user();
                        newuser.FirstName = newContact.FirstName; 
                        newuser.LastName = newContact.LastName; 
                        newuser.Email = newContact.External_Email__c; 
                        newuser.EmailEncodingKey = 'UTF-8'; 
                        newuser.LanguageLocaleKey = 'en_US';
                        newuser.LocaleSidKey = 'en_US'; 
                        newuser.TimeZoneSidKey = 'America/Los_Angeles'; 
                        newuser.UserName = newContact.External_Email__c; 
                        newuser.ProfileId = profileList[0].Id;
                        if(!Test.isRunningTest()) 
                        {
                            newuser.Alias = newContact.External_Email__c.left(8);     
                        }
                        else
                        {
                            newuser.Alias = 'testi';        
                        }
                        newuser.ContactId = newContact.id;
                        createUser.add(newuser);  
                    }                  
                    if(createUser.Size() > 0 && !Test.isRunningTest())
                    {
                        Insert createUser;
                        List<id> newListContactids = new List<id>();
                        newListContactids.add(newContact.id);
                        postHTTPCreateNewUserTriplog(newListContactids);
                        
                    }*/  
                }
                system.debug('outside');
                // return getlistAllEmployees(accid,contactid);
                result.result = getlistAllEmployees(accid,contactid); 
            }
        // return 'Fail';
        return result;
    }

    public static string getExcetionTypes(String name,String message, Integer lineNumber ){
        
        if(name == 'TypeException'){
            system.debug('inside type exception');
            if(message.trim().toUpperCase() == ('Invalid decimal: .').trim().toUpperCase()){
                sendExceptionMails(message+String.valueOf(lineNumber),getCustomExceptionMessage('1'));
                return getCustomExceptionMessage('1');
            }
        }
        else if (name == 'System.DmlException') {
           
            if(message.trim().toUpperCase().Contains('UPDATE FAILED') || message.trim().toUpperCase().Contains('INSERT FAILED')){
                String msg = message.trim().toUpperCase();
                if(msg.Contains('[')){
                    string fied = msg.substringBetween('[',']');
                }
                
                sendExceptionMails(message+String.valueOf(lineNumber),getCustomExceptionMessage('2'));
                return getCustomExceptionMessage('2');
            }
        }
        else if (name == 'QueryException') {
            if(message.trim().toUpperCase().Contains('List has no rows')){
                String msg = message.trim().toUpperCase();
                if(msg.Contains('[')){
                    string fied = msg.substringBetween('[',']');
                }
                 sendExceptionMails(message+String.valueOf(lineNumber),getCustomExceptionMessage('3'));
                return getCustomExceptionMessage('3');
            }
        }
        else if(name == 'NullPointerException'){
            if(message.trim().toUpperCase().Contains('Attempt to de-reference')){
                String msg = message.trim().toUpperCase();
                if(msg.Contains('[')){
                    string fied = msg.substringBetween('[',']');
                }
                sendExceptionMails(message+String.valueOf(lineNumber),getCustomExceptionMessage('4'));
                return getCustomExceptionMessage('4');
            }
        }

        return Label.ExceptionLabel;
    }

    public static string getCustomExceptionMessage(String namevalue){
        system.debug('getCustomExceptionMessage');
        EmailExceptionMessages__c customSetValue = EmailExceptionMessages__c.getValues(namevalue); 
        if(customSetValue != null){
            return customSetValue.Message__c;
        }
        else{
            return Label.ExceptionLabel;
        }
    }

    public static User getUser(String passedContactId)
    {
        User currentUser = [Select id from User where ContactId=:passedContactId limit 1];
        return currentUser;
    }
    @Future(callout = true)
    webservice static void postHTTPCreateNewUserTriplog(List<Id> newListContact) 
    {
        String url = 'https://triplogmileage.com/web/api/users';
        Http h;
        HttpRequest req;
        HttpResponse res;
        List<Contact> contacts = new List<Contact>([SELECT Id, 
                                                        FirstName,
                                                        LastName,
                                                        Phone,
                                                        External_Email__c,
                                                        Triplog_UserID__c,
                                                        Driving_States__c,
                                                        isCommunityUser__c,
                                                        Account.Triplog_API__c 
                                                        FROM Contact 
                                                        WHERE Id IN: newListContact]);
        List<Contact> listToUpdate = new List<Contact>();
        for(Contact newContact : contacts) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('firstName', newContact.FirstName);
            gen.writeStringField('lastName', newContact.LastName);
            gen.writeStringField('email', newContact.External_Email__c);
            gen.writeStringField('phone', (newContact.Phone != null) ? newContact.Phone :'');
            gen.writeStringField('isDriver', 'true');
            if(newContact.Driving_States__c != null || newContact.Driving_States__c == '') {
                String x = newContact.Driving_States__c;
                x = x.replaceAll(';', ',');
                gen.writeStringField('territory', (x != null) ? x :'');
            }
            gen.writeEndObject();
            String jsonstringconvert = gen.getAsString();
            // HTTP request
            h = new Http();
            req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setbody(jsonstringconvert);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'apikey '+ newContact.Account.Triplog_API__c);
            if(!Test.isRunningTest()){
                res = h.send(req);
                if(res.getStatusCode() == 200) {
                    TripLogJSONPost tripLogRes = TripLogJSONPost.parse(res.getBody());
                    newContact.isCommunityUser__c = true;
                    newContact.Triplog_UserID__c = String.valueOf(tripLogRes.user.id);                   
                    listToUpdate.add(newContact);
                } else {
                    ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'User not create in Triplog');
                }
            }
        }
        if(!listToUpdate.isEmpty()){
            
            try{
                update listToUpdate;
            } catch (Exception e){
                //string type = name;
               //String message = return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
               
            }
        }
    }
    public static string getAllManagers()
    {
        query='';       
        query = 'Select id,Name from Contact where ( accountid=\''+getAccountid()+'\'and Deactivated_Date__c = null and (Role__c=\'Manager'+'\' OR Role__c=\'Driver/Manager'+'\' OR Role__c=\'Admin'+'\' OR Role__c = \''+StaticValues.roleAdminDriver+'\' ))';
        List<Contact> managerlist = (List<Contact>)ExecuteQueryUtil.getListFromMap(ExecuteQueryUtil.getRecordMapWithSinglesObject(query));
        return JSON.serialize(managerlist);
    }
    @RemoteAction   
    public static String getlistAllEmployees(String accid,String contactid)
    {   
       
        List<EmployeeDetails> employeeList = new List<EmployeeDetails>();
        for(Contact currentContact:[SELECT id,Accountid,FirstName,Lastname,Email,External_Email__c,Deactivated_Date__c,Role__c,Manager__c,Manager__r.Name,MailingPostalCode,Driving_States__c,MailingState,MailingCity,Employee_ID__c,Activation_Date__c,Vehicle_Type__c,Last_Pay_Date__c,Monthly_Mileage_Limit__c,Added_Date__c,Fixed_Amount__c,compliancestatus__c,Total_Reimbursement__c,IsDeactivated__c,Monthly__c,Sage_100_ID__c,GL_Code__c,App__c,MobilePhone,Phone,Branch_Number__c,Branch_Name__c,Freeze__c  
                                            FROM Contact 
                                            WHERE Accountid=:accid]) //Branch_Number__c,Branch_Name__c 
        {              
            //system.debug('currentContact'+currentContact);     
            employeeList.add(WrapperUtils.getEmployeeDetails(currentContact));
        }
       
        return JSON.serialize(employeeList);     
    }
    public static String getRoles()
    {
        List<String> roleList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Role__c.getDescribe();
        List<Schema.PicklistEntry> pickListEntries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry currentEntries : pickListEntries)
        {
            roleList.add(currentEntries.getValue());
        }
        return JSON.serialize(roleList);     
    }
    public static String getDrivingStates()
    {
        List<String> drivingStateList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Driving_States__c.getDescribe();
        List<Schema.PicklistEntry> pickListEntries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry currentPickListEntry : pickListEntries)
        {
            drivingStateList.add(currentPickListEntry.getValue());
        }
        return JSON.serialize(drivingStateList);     
    }
    @RemoteAction
    public static String readFromFile(String file,String accountId) {
        //system.debug('file'+file);
        String headerCSV = 'Employee_ID__c,Firstname,LastName,External_Email__c,' + 
                            'Vehicle_Type__c,Role__c,MailingCity,MailingState,' + 
                            'MailingPostalCode,AccountId,Activation_Date__c,Manager__c,MobilePhone,Driving_States__c\n';
        String sucessDocumentName;
        String failDocumentName;
        String result = '';
        //Get current User
        //String resultMessage = '';
        User currentuser = [SELECT profile.name,
                              contactid,
                              Contact.FirstName,
                              contact.account.Vehicle_Types__c, 
                              Contact.External_Email__c,
                              Contact.Account.Name,
                              Contact.AccountId,
                              Contact.Account.Triplog_API__c,
                              Contact.Role__c
                              /*Give_Other_Admin_Access__c*/
                       FROM User 
                       WHERE Id =: UserInfo.getUserId()];   
        List<Document> sucessDocument = new List<Document>();
        List<Document> duplicateDocument = new List<Document>();
        List<Contact> finalInsertContact = new List<Contact>();
        List<Contact> finalDuplicateContact = new List<Contact>();
        Set<String> externalEmail = new Set<String>();
        List<Id> contactListId = new List<Id>();
        Boolean isSuccessFile =  false;
        Boolean isDuplicateFile =  false; 
        Map<String, Integer> fieldNumberMap = new Map<String, Integer> ();
        List<String> lstFieldNames = new List<String>();
        Set<String>contactEmail = new Set<String>();
        Contact conObj = new Contact();
        List<Contact> lstContacts = new List<Contact>();
        Integer fieldNumber;
        String fieldValue;
        String contactDataAsString = file;//String.valueOf(file);
        String[] contactDataLines = new String[] {};
        contactDataLines = contactDataAsString.split('\n');
        String[] csvFieldNames = contactDataLines[0].split(',');
        Map<Id, Account> accNameToIdMap = new Map<Id, Account>([SELECT Id, Name FROM Account where id=:accountId]);
        Map<Id, Contact> manNameToIdMap = new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE (Role__c ='Manager' OR Role__c ='Driver/Manager') and Account.id =:accountId]);
        for(Integer i = 0; i < csvFieldNames.size(); i++) {
            fieldNumberMap.put(csvFieldNames[i].trim(), i);
            lstFieldNames.add(csvFieldNames[i].trim());
        }
        Boolean isError = false;
        List<FileError> fileErrors = new List<FileError>();

       /* try {*/
            for(Integer i = 1; i <contactDataLines.size(); i++) 
            {
                conObj = new Contact();
                String[] csvRecordData = contactDataLines[i].split(',');
                isError = false;
                
                for(String fieldName: csvFieldNames) 
                {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    //System.debug(fieldNumber);
                    //System.debug(fieldName);
                    if(csvRecordData.size() > fieldNumber && fieldNumber == 10 && fieldValue != null) {

                        string d = csvRecordData[fieldNumber];
                        //System.debug(d);
                        string data;

                        Date activationDate;
                        if ( d.Contains('/') ) {
                            try {
                                activationDate =  Date.valueOf( d.Split('/')[2] + '-' + d.Split('/')[0] + '-' + d.Split('/')[1] );
                            } catch (Exception e ) {
                                fileErrors.add(new FileError(csvRecordData[0], 'Wrong date format: ' + d));
                                isError = true;
                                continue;
                            }
                        }
                        else {
                            fileErrors.add(new FileError(csvRecordData[0], 'Wrong date format: ' + d));
                            isError = true;
                            continue;
                        }
                        conObj.put(fieldName.trim(), activationDate);
                        system.debug('conObj'+conObj);

                    } else if( csvRecordData.size() > fieldNumber && fieldNumber == 9 && fieldValue != null ) {
                        
                        fieldValue = csvRecordData[fieldNumber].trim();
                        //System.debug(fieldValue);
                        accountId = '';

                        for(Id singleId : accNameToIdMap.keySet()) {
                            if( fieldValue == accNameToIdMap.get(singleId).Name ) {
                               accountId = accNameToIdMap.get(singleId).Id;
                               break;
                            }
                        }

                        if(accountId != '') {
                            conObj.put(fieldName.trim() , accountId );
                        } else {
                            //fileErrors.add(new FileError(csvRecordData[0], 'Account ' + fieldValue + ' not available' ));
                            fileErrors.add(new FileError(csvRecordData[0], 'There is no Account named ' + fieldValue + ',Please add ' + fieldValue +'first and then upload the document again'));
                            isError = true;
                            continue;
                        }

                    } else if( csvRecordData.size() > fieldNumber && fieldNumber == 11 && fieldValue != null) {
                        fieldValue = csvRecordData[fieldNumber].trim();
                        String managerId = '';

                        for(Id singleId : manNameToIdMap.keySet()) {
                            if(fieldValue == manNameToIdMap.get(singleId).Name) {
                                managerId = manNameToIdMap.get(singleId).Id;
                                break;
                            }
                        }
                        if(managerId != '') {
                            conObj.put( fieldName.trim() , managerId );
                        } else {
                            //fileErrors.add(new FileError(csvRecordData[0], 'Manager ' + fieldValue + ' not available' ));
                            fileErrors.add(new FileError(csvRecordData[0], 'There is no manager named ' + fieldValue + ',Please add ' + fieldValue +'first and then upload the document again'));
                            isError = true;
                            continue;
                        }
                    } else if( csvRecordData.size() > fieldNumber ) {               
                        fieldValue = csvRecordData[fieldNumber];
                        conObj.put( fieldName.trim(), fieldValue.trim() );
                    }
                    conObj.put('isCommunityUser__c', true);               
                }
                system.debug('isError'+isError);
                if(!isError || Test.isRunningTest()){
                    system.debug('isError'+isError);
                    lstContacts.add(conObj);  
                }
                   
            }
            if( !fileErrors.isEmpty() && !Test.isRunningTest())
                return 'Error::' +   String.escapeSingleQuotes(JSON.serialize(fileErrors) ); 
        /*} catch (Exception e) {
            return 'Error::Please upload file in proper format.';
        }*/
        
        for(Contact newContact : lstContacts) {
           contactEmail.add(newContact.External_Email__c);
        }
        for(Contact contactKey : [SELECT Id, External_Email__c FROM Contact 
                                    WHERE External_Email__c IN: contactEmail]) {
            externalEmail.add(contactKey.External_Email__c);    
        }
        for(Contact singleContactCSV : lstContacts) {
            if(!externalEmail.contains(singleContactCSV.External_Email__c)) {
                singleContactCSV.IsCreatedFromCommunity__c = true;
                singleContactCSV.isCommunityUser__c = true;
                singleContactCSV.Activation_Date__c = system.today();
                finalInsertContact.add(singleContactCSV);
            } else {
                finalDuplicateContact.add(singleContactCSV);
            }
        }
        if(finalInsertContact.size() > 0) {
                if(!Test.isRunningTest()) {
                   
                    try{
                        insert finalInsertContact;
                    } catch (Exception e){
                        //string type = name;
                        //String messageOfException = return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                    }
                }
                String valueString;
                List<String> listString = new List<String>();
                for(Contact finalContact : finalInsertContact) {
                    if(finalContact.role__c != null && finalContact.role__c != 'Admin' && finalContact.role__c !='Manager')
                    {
                        contactListId.add(finalContact.Id);    
                    }
                    valueString = finalContact.Employee_ID__c + ',' + finalContact.FirstName + ',' + 
                                    finalContact.LastName + ',' + finalContact.External_Email__c + ',';
                    valueString += finalContact.Vehicle_Type__c + ',' + finalContact.Role__c + ',' + 
                                    finalContact.MailingCity + ',' + finalContact.MailingState+',';
                    valueString += finalContact.MailingPostalCode + ',' + finalContact.AccountId + ',' + 
                                    finalContact.Activation_Date__c + ',' + finalContact.Manager__c;
                    listString.add(valueString);
                }
        
                String sucessFile = headerCSV + String.join(listString,'\n');
                sucessDocumentName = Label.doc_Success;
                
                sucessDocument = [SELECT Id, Name, Body, contenttype, developername, type FROM Document 
                                    WHERE  Name =: sucessDocumentName LIMIT 1];
        
                if(sucessDocument.size() > 0) {
                    sucessDocument[0].Body = Blob.valueOf(sucessFile);
                     try{
                       update sucessDocument;
                    } catch (Exception e){
                        //string type = name;
                        //String messageOfException = return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                        return getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                    }
                    
                }
                isSuccessFile = true;
                postHTTPCreateNewUserTriplog(contactListId);
                //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.INFO, Label.msg_after_succes+finalInsertContact.size());
                //ApexPages.addMessage(errorMessage);
                result = 'Success::' + Label.msg_after_succes + finalInsertContact.size() + '<br/>';
                //resultMessage = 'true';
        }
        if(finalDuplicateContact.size() > 0 || Test.isRunningTest()) {
           
            String valueString;
            List<String> listString = new List<String>();              
            for(Contact duplicateContact : finalDuplicateContact) {
                valueString = duplicateContact.Employee_ID__c + ',' + duplicateContact.FirstName + ',' + 
                                duplicateContact.LastName + ',' + duplicateContact.External_Email__c + ',';
                valueString += duplicateContact.Vehicle_Type__c + ',' + duplicateContact.Role__c + ',' + 
                                duplicateContact.MailingCity + ',' + duplicateContact.MailingState + ',';
                valueString += duplicateContact.MailingPostalCode + ',' + duplicateContact.AccountId + ',' + 
                                duplicateContact.Activation_Date__c + ',' + duplicateContact.Manager__c;
                listString.add(valueString);
            }
            String duplicateFile = headerCSV + String.join(listString,'\n');
            failDocumentName = Label.doc_Fail;

            duplicateDocument = [SELECT Id, Name, Body, contenttype, developername, type FROM Document 
                                    WHERE Name =: failDocumentName LIMIT 1];
            if(duplicateDocument.size() > 0){
                duplicateDocument[0].Body = Blob.valueOf(duplicateFile);
                update duplicateDocument;
            }
            isDuplicateFile = true;
            //resultMessage = 'false';
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,Label.msg_After_Fail+finalDuplicateContact.size());
            ApexPages.addMessage(errorMessage);
            result += Label.msg_After_Fail + finalDuplicateContact.size();
            
        }
        if(finalDuplicateContact.size() > 0 || finalInsertContact.size() > 0) {
            //senEmailToAdminWithCsv(sucessDocument,duplicateDocument);
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
            if(sucessDocument.size() > 0 && sucessDocument[0].Body != null) {
                attach.setContentType(sucessDocument[0].contentType);
                attach.setFileName(sucessDocument[0].developerName + '.' + sucessDocument[0].type);
                attach.setInline(false);
                attach.setBody(test.isRunningtest() ? blob.valueof('test') : sucessDocument[0].Body);
                emailFileAttachments.add(attach);
            }
            //System.debug(attach.getBody());
            Messaging.EmailFileAttachment attach2 = new Messaging.EmailFileAttachment();
            if(duplicateDocument.size() > 0 && duplicateDocument[0].Body != null) {    
                attach2.setContentType(duplicateDocument[0].contentType);
                attach2.setFileName(duplicateDocument[0].developerName + '.' + duplicateDocument[0].type);
                attach2.setInline(false);
                attach2.setBody(test.isRunningtest() ? blob.valueof('test') : duplicateDocument[0].Body);
                emailFileAttachments.add(attach2);
            }

            //System.debug(attach2.getBody());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            string htmlBodycsv = 'Hi ' + currentuser.Contact.FirstName + ',<br/><br/>';        
            if(finalInsertContact.size() == 0) {
                htmlBodycsv += 'No drivers have been created.<br/><br/>';
            } else {
                htmlBodycsv += '<b>' + finalInsertContact.size() + 
                                '</b> new drivers have been successfully created.<br/><br/>';        
            }
            htmlBodycsv += 'Unfortunately there were <b>' + finalDuplicateContact.size() + 
                            '</b> errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';

            htmlBodycsv += 'Please review the attached files.<br/><br/>';
            if(finalInsertContact.size()>0) {
                htmlBodycsv += 'The system will update in 48 business hours and newly created drivers will be notified then for training.';
            }
            mail.setUseSignature(false);if(Test.isRunningTest()) {
                    mail.setToAddresses(new String[] { 'sanket.goc@gmail.com','natavar.goc@gmail.com','minkesh.patel@getoncrm.com' });
                }
                else {
                    mail.setToAddresses(new String[] { 'sanket.goc@gmail.com','natavar.goc@gmail.com','minkesh.patel@getoncrm.com'});//(new String[] { currentuser.contact.External_Email__c});
                }
            mail.setSubject('New driver create using Csv');
            mail.setHtmlBody(htmlBodycsv);
            if(!test.isRunningtest()) {
                if(!emailFileAttachments.isEmpty()) {
                    mail.setFileAttachments(emailFileAttachments);
                }
                //System.debug(mail.getFileAttachments());
                SendEmail__c  objSendEmail1 = SendEmail__c.getValues('RG_CreateNewUserPageClass1');

                if((objSendEmail1!=null) && objSendEmail1.Send_email_from_code__c==true  )
                {
                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
                }
            }
        }
        /*System.debug('===contactDataAsString==='+contactDataAsString);
        System.debug('===file==='+file);
        contactDataLines = file*/
        /*String[] contactDataLines = new String[] {};
        contactDataLines = */
        
        /*Attachment newInsuranceFile = new Attachment();
        newInsuranceFile.Body = EncodingUtil.base64Decode(file);
        newInsuranceFile.parentId=*/
        /*try {
            contactDataAsString = 'Success';    
            //contactDataAsString = csvFileBody.toString();
            System.debug('===contactDataAsString==='+contactDataAsString);
        //    readCSVFile();
        } catch(exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error In reading CSV file');
            ApexPages.addMessage(errorMessage);
            contactDataAsString = 'fail';   
        }*/

        String resultMessage = '';
        if(finalInsertContact.size() == 0) {
                resultMessage = 'Error::No drivers have been created.<br/><br/>';
        } else {
            resultMessage += 'Success::<b>' + finalInsertContact.size() + 
                            '</b> new drivers have been successfully created.<br/><br/>';        
        }

        if(finalDuplicateContact.size() > 0) {
            resultMessage += 'Unfortunately there were <b>' + finalDuplicateContact.size() + 
                            '</b> errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';

            for(Contact duplicateContact : finalDuplicateContact) {
                fileErrors.add(new FileError(duplicateContact.Employee_ID__c, duplicateContact.External_Email__c ));
            }

            //System.debug('duplicateContact');
            if(!fileErrors.isEmpty())
                return resultMessage + '::Duplicate::' + String.escapeSingleQuotes(JSON.serialize(fileErrors) ); 
        }

        /*if(finalInsertContact.size() == 0 && finalInsertContact.isEmpty()) {
            resultMessage = '';
            //resultMessage += 'No drivers have been created.<br/><br/>';     
            //resultMessage += 'errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';
            


            //resultMessage += 'Unfortunately there were <b>' + finalDuplicateContact.size() + 
              //          '</b> errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';          
        } else {
            resultMessage = 'true';
            //resultMessage += ' ' + finalInsertContact.size() +' new drivers have been successfully created.<br/><br/>';  
            //resultMessage += 'Your Import process successfully.'  ;         
           


           // resultMessage += 'Unfortunately there were <b>' + finalDuplicateContact.size() + 
        //'</b> errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';         
        }
        */

        //resultMessage += 'Please review the attached files in email.<br/><br/>';

        return resultMessage;
    }

    //AI-000433
    @RemoteAction
    public static ResultResponse massFreeze(String listofemployee,Boolean freezeProperty){
        ResultResponse result = new ResultResponse();
        result.hasError = false;
        result.message = '';

        List<String> contactIds = new List<String>();
        List<Contact> conList = new List<Contact>();
        Set<Id> UserIds = new Set<ID> ();
        List<UserLogin> userLogins = new List<UserLogin>();
        contactIds = (List<String>) System.JSON.deserialize(listofemployee, List<String>.class);
        
        for(User currentUser: [SELECT id,ContactId FROM User WHERE ContactId IN: contactIds]) {
            UserIds.add(currentUser.Id);
        }

        for(UserLogin ulogin : [SELECT Id, IsFrozen, UserId From UserLogin Where UserId =: UserIds]){
            if(freezeProperty == true){
                system.debug('freezeProperty'+freezeProperty);
                ulogin.IsFrozen = true;
            }
            else {
                system.debug('freezeProperty'+freezeProperty);
                ulogin.IsFrozen = false;
            }
            userLogins.add(ulogin);
        }
        
        for(Contact conObj : [SELECT id,Freeze__c 
                                        FROM Contact WHERE ID =: contactIds ]){
            if(freezeProperty == true){
                system.debug('freezeProperty'+freezeProperty);
                conObj.Freeze__c = System.today();
            }
            else {
                system.debug('freezeProperty'+freezeProperty);
                conObj.Freeze__c = null;
            }
            conList.add(conObj);
        }

        if(userLogins.size() > 0 && conList.size() > 0)
        {
            try{
                System.debug('userLogins'+userLogins);
                System.debug('conList'+conList);
                update userLogins;
                update conList;
            } catch (Exception e){
                result.hasError = true;
                result.message = getExcetionTypes(e.getTypeName(),e.getMessage(),e.getlinenumber());
                return result;
            }
        }
        
        return result ;
    }
    //Send Email to Admin
    /*public void senEmailToAdminWithCsv(List<Document> successDoc, List<Document> duplicateDoc) {
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        if(successDoc.size() > 0) {
            attach.setContentType(successDoc[0].contentType);
            attach.setFileName(successDoc[0].developerName + '.' + successDoc[0].type);
            attach.setInline(false);
            attach.Body = test.isRunningtest() ? blob.valueof('test') : successDoc[0].Body;
        }
        Messaging.EmailFileAttachment attach2 = new Messaging.EmailFileAttachment();
        if(duplicateDoc.size() > 0) {    
            attach2.setContentType(duplicateDoc[0].contentType);
            attach2.setFileName(duplicateDoc[0].developerName + '.' + duplicateDoc[0].type);
            attach2.setInline(false);
            attach2.Body = test.isRunningtest() ? blob.valueof('test') : duplicateDoc[0].Body;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string htmlBodycsv = 'Hi ' + currentuser.Contact.FirstName + ',<br/><br/>';        
        if(finalInsertContact.size() == 0) {
            htmlBodycsv += 'No drivers have been created.<br/><br/>';
        } else {
            htmlBodycsv += '<b>' + finalInsertContact.size() + 
                            '</b> new drivers have been successfully created.<br/><br/>';        
                }
        htmlBodycsv += 'Unfortunately there were <b>' + finalDuplicateContact.size() + 
                        '</b> errors with your data upload. Please correct and resubmit by uploading again.<br/><br/>';

        htmlBodycsv += 'Please review the attached files.<br/><br/>';
        if(finalInsertContact.size()>0) {
            htmlBodycsv += 'The system will update in 48 business hours and newly created drivers will be notified then for training.';
        }
        mail.setUseSignature(false);if(Test.isRunningTest()) {
                mail.setToAddresses(new String[] { 'minkesh.patel@gmail.com' });
            }
            else {
                mail.setToAddresses(new String[] { currentuser.contact.External_Email__c});
            }
        mail.setSubject('New driver create using Csv');
        mail.setHtmlBody(htmlBodycsv);
        if(!test.isRunningtest()) {
            if(attach != null && attach2 != null) {
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach, attach2 });
            } else if(attach != null) {
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            } else if(attach2 != null) {
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach2 });
            }
            
            SendEmail__c  objSendEmail1 = SendEmail__c.getValues('RG_CreateNewUserPageClass1');
            if(objSendEmail1.Send_email_from_code__c==true  &&(objSendEmail1!=null))
            {
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
            }
        }
    }*/

    @RemoteAction
    public static String editEmployeeDetails(String editUserID) {
        system.debug('editEmployeeDetails');
        Contact loggedinContact = new Contact();
        query = 'Select id,Name,FirstName,Lastname,Email,External_Email__c,Deactivated_Date__c,Role__c,Manager__c,Manager__r.Name,MailingPostalCode,Driving_States__c,MailingState,MailingCity,Employee_ID__c,Activation_Date__c,Vehicle_Type__c,Last_Pay_Date__c,Monthly_Mileage_Limit__c,Added_Date__c,Fixed_Amount__c,compliancestatus__c,Total_Reimbursement__c,IsDeactivated__c,Monthly__c,Sage_100_ID__c,GL_Code__c,App__c,MobilePhone,Phone,Branch_Name__c,Branch_Number__c,Freeze__c from Contact where id=\''+editUserID+'\''; //
        system.debug('query'+query);
        List<EmployeeDetails> employeeList = new List<EmployeeDetails>();
        List<Contact> managerlist = (List<Contact>)ExecuteQueryUtil.getRecordListFromsObject(query);
       
        
        for(Contact currentManager : managerlist)
        {           
            system.debug('currentManager'+currentManager);        
            employeeList.add(WrapperUtils.getEmployeeDetails(currentManager));
        }
        system.debug('employeeList'+employeeList);
        return JSON.serialize(employeeList).replace('null','""');
    }

    @RemoteAction
    public static String getCity(String city,String zipcode) {
        /*Decimal zipcode = Decimal.valueOf(zip);*/
        if(city != null && city != '' && zipcode != null && zipcode != ''){
            List<Address__c> addressList  = new List<Address__c>();
            addressList = [SELECT id,name,State__c,City__c,Abbreviation__c,ZIP_Code__c FROM Address__c WHERE City__c =: city AND ZIP_Code__c =: zipcode];
            if(addressList.size() > 0) {
                //System.debug('obj_Address:--'+addressList);
                return JSON.serialize(addressList); 
            }
        }
        return '';
    }

    @RemoteAction
    public static String getCountryStateCity(String zipcode)
    {
        /*Decimal zip = Decimal.valueOf(zipcode);*/
        if(zipcode != null && zipcode != '')
        {
            List<Address__c> addressList  = new List<Address__c>();
            addressList = [SELECT id,name,State__c,City__c,Abbreviation__c,ZIP_Code__c FROM Address__c WHERE ZIP_Code__c =: zipcode];
            if(addressList.size() > 0) {
                //System.debug('obj_Address:--'+addressList);
                return JSON.serialize(addressList); 
            }
        }
        return '';
    }
    @RemoteAction
    public static String getContactByEmailAddress(String emailId)
    {
        List<Contact> queryContactbyemailaddress = new List<Contact>();
        String query = 'Select id,FirstName,Lastname,accountid from Contact where email=\''+emailid+'\'';
        queryContactbyemailaddress = ((List<Contact>)ExecuteQueryUtil.getRecordListFromsObject(query));
        //System.debug('queryContactbyemailaddress:- '+queryContactbyemailaddress);
        if(queryContactbyemailaddress.size()>0)
        {
            //System.debug('getContactByEmailAddress:---'+queryContactbyemailaddress[0].id);
            return queryContactbyemailaddress[0].id;
        }
        return 'Fail';
    }


    public class ResultResponse {
        public Boolean hasError { get; set;}
        public string message { get; set;}
        public String result { get; set;}
    }
}