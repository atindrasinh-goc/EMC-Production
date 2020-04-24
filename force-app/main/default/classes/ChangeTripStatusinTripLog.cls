global class ChangeTripStatusinTripLog implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts
{
    public String triplogStatusUrl;
    public Map<String,List<String>> reimbursementMileageMap;
    public Map<String,List<String>> approveReimbursmentwithTripidMap;
    public Map<String,List<String>> rejectReimbursmentwithTripidMap;
    public Map<String,List<String>> approveReimbursmentMap;
    public Map<String,List<String>> rejectReimbursmentMap;
    public List<String> approvedIdsList;
    public List<EmailTemplate> emailTemplateList1;
    public List<String> rejectedIdsList;
    public String nameofmanager;
    public String nameofdriver;
    public String emailaddressofmanager;
    public String emailaddressofdriver;
    public SendEmailToMe__c customSetValue;
    public ChangeTripStatusinTripLog(List<String> approvedIds,List<String> rejectedIds,String name,String emailaddress)
    {
        System.debug('ChangeTripStatusinTripLog');
        customSetValue = SendEmailToMe__c.getValues('ChangeTripStatusinTripLog'); 
        triplogStatusUrl = System.Label.Triplog_URL_For_TripStatus;
        nameofmanager= name;
        emailaddressofmanager = emailaddress;
        approveReimbursmentwithTripidMap = new Map<String,List<String>>();
        rejectReimbursmentwithTripidMap = new Map<String,List<String>>(); 
        approveReimbursmentMap = new Map<String,List<String>>();
        rejectReimbursmentMap = new Map<String,List<String>>(); 
        reimbursementMileageMap = new Map<String,List<String>>();
        approvedIdsList = new List<String>();
        rejectedIdsList = new List<String>();
        approvedIdsList = approvedIds;
        rejectedIdsList = rejectedIds;
        emailTemplateList1 = new List<EmailTemplate>([SELECT Id, Subject,HtmlValue, body FROM EmailTemplate WHERE developerName = 'flagmileageprocess']); 
        for(Employee_Mileage__c currentMileage : [Select id,EmployeeReimbursement__c,Trip_Id__c from Employee_Mileage__c where Trip_Id__c!=null and id IN: approvedIdsList])
        {            
            if(approveReimbursmentMap.size()>0 && approveReimbursmentMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = approveReimbursmentMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.id));
                approveReimbursmentMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.id));
                approveReimbursmentMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            if(approveReimbursmentwithTripidMap.size()>0 && approveReimbursmentwithTripidMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = approveReimbursmentwithTripidMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                approveReimbursmentwithTripidMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                approveReimbursmentwithTripidMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            if(reimbursementMileageMap.size()>0 && reimbursementMileageMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = reimbursementMileageMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                reimbursementMileageMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                reimbursementMileageMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }            
        }
        for(Employee_Mileage__c currentMileage : [Select id,EmployeeReimbursement__c,Contact_Email_Id__c,EmployeeReimbursement__r.Contact_Id__r.Manager__r.FirstName,EmployeeReimbursement__r.Contact_Id_Name__c,Trip_Id__c from Employee_Mileage__c where Trip_Id__c!=null and id IN: rejectedIdsList])
        {   
            emailaddressofdriver =  currentMileage.Contact_Email_Id__c;    
            nameofdriver = currentMileage.EmployeeReimbursement__r.Contact_Id_Name__c;
            nameofmanager = currentMileage.EmployeeReimbursement__r.Contact_Id__r.Manager__r.FirstName;
            if(rejectReimbursmentMap.size()>0 && rejectReimbursmentMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = rejectReimbursmentMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.id));
                rejectReimbursmentMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.id));
                rejectReimbursmentMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            if(rejectReimbursmentwithTripidMap.size()>0 && rejectReimbursmentwithTripidMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = rejectReimbursmentwithTripidMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                rejectReimbursmentwithTripidMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                rejectReimbursmentwithTripidMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            if(reimbursementMileageMap.size()>0 && reimbursementMileageMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                List<String> mileagesListofCurrentReimbursement = reimbursementMileageMap.get(currentMileage.EmployeeReimbursement__c);
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                reimbursementMileageMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }
            else
            {
                List<String> mileagesListofCurrentReimbursement = new List<String>();
                mileagesListofCurrentReimbursement.add(String.valueOf(currentMileage.Trip_Id__c));
                reimbursementMileageMap.put(currentMileage.EmployeeReimbursement__c,mileagesListofCurrentReimbursement);
            }            
        }
    }    
    global List<Employee_Reimbursement__c> start(Database.BatchableContext BC) 
    {
        return [Select id,Status__c,Contact_Id__r.FirstName,Contact_Id__r.External_Email__c,Contact_Id__r.Manager__r.Name,Contact_Id__r.Manager__r.FirstName,Contact_Id__c,Contact_Id__r.Account.Triplog_API__c,Month__c from Employee_Reimbursement__c where id IN:reimbursementMileageMap.keySet() and Contact_Id__r.Account.isUsingTriplog__c = true];
    }
    global void execute(Database.BatchableContext BC, List<Employee_Reimbursement__c> scope) 
    {
        List<Tripslog__c> triplogsList = new List<Tripslog__c>();
        List<Employee_Mileage__c> mileagesList = new List<Employee_Mileage__c>(); 
        List<Messaging.SingleEmailMessage> singleFlagEmailMessageList = new List<Messaging.SingleEmailMessage>();  
        OrgWideEmailAddress[] owea = [SELECT Id,Address from OrgWideEmailAddress where Address = 'driverservices@mburse.com'];     
        for(Employee_Reimbursement__c currentReimbursement : (List<Employee_Reimbursement__c>) scope)
        {
            String body ='';                       
            if(approveReimbursmentwithTripidMap.containsKey(currentReimbursement.id))
            {

                if(customSetValue != null && customSetValue.Send_email_to_me__c ){
                    body = buildBodyOfPutCall('Approved',approveReimbursmentwithTripidMap.get(currentReimbursement.id));
                    triplogsList.add(callPutApi(String.valueOf(currentReimbursement.Contact_Id__r.Account.Triplog_API__c),body,currentReimbursement.Contact_Id__c,currentReimbursement.id,approveReimbursmentwithTripidMap.get(currentReimbursement.id).size(),triplogStatusUrl));
                }
                
                List<Employee_Mileage__c> mileagestoUpdateList = new List<Employee_Mileage__c>();
                mileagestoUpdateList = getMileages(approveReimbursmentMap.get(currentReimbursement.id),'Approved');
                if(mileagestoUpdateList.size()>0)
                {
                   mileagesList.addAll(mileagestoUpdateList); 
                } 
                      
            }
            if(rejectReimbursmentwithTripidMap.containsKey(currentReimbursement.id))
            {
                if(customSetValue != null && customSetValue.Send_email_to_me__c){
                    body = buildBodyOfPutCall('Rejected',rejectReimbursmentwithTripidMap.get(currentReimbursement.id));
                    //triplogsList.add(callPutApi(String.valueOf(currentReimbursement.Contact_Id__r.Account.Triplog_API__c),body,currentReimbursement.Contact_Id__c,currentReimbursement.id,rejectReimbursmentwithTripidMap.get(currentReimbursement.id).size(),triplogStatusUrl)); 
                }
                List<Employee_Mileage__c> mileagestoUpdateList = new List<Employee_Mileage__c>();
                mileagestoUpdateList = getMileages(rejectReimbursmentMap.get(currentReimbursement.id),'Rejected');
                if(mileagestoUpdateList.size()>0)
                {
                    SendEmailonDeactivation__c customFlagSettings = SendEmailonDeactivation__c.getValues('flagmileagesemaildriver');                   
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String newemailBody = emailTemplateList1[0].HtmlValue;
                    List<String> emailsToSent = new List<String>();
                    List<String> toaddresse = new List<String>();
                    List<String> months = new List<String>();
                    Map<Integer,String> monthNameMap = new Map<Integer, String>{01 =>'January', 02=>'February', 03=>'March', 04=>'April', 05=>'May',
                                                                    06=>'June', 07=>'July', 08=>'August', 09=>'September',10=>'October',
                                                                    11=>'November', 12=>'December'};
                    if(customFlagSettings!=null && customFlagSettings.Send_to_Driver__c == true)
                    {
                        
                        toaddresse.add(currentReimbursement.Contact_Id__r.External_Email__c);                        
                        if(customFlagSettings!=null && String.isNotBlank(customFlagSettings.BCCEmailaddresses__c) && customFlagSettings.BCCEmailaddresses__c.contains(',') && customFlagSettings.Send_to_me__c==true)
                        {
                            emailsToSent = customFlagSettings.BCCEmailaddresses__c.split(',');                            
                        }
                        else if(customFlagSettings!=null && String.isNotBlank(customFlagSettings.BCCEmailaddresses__c) && (!customFlagSettings.BCCEmailaddresses__c.contains(',')) && customFlagSettings.Send_to_me__c==true)
                        {
                            emailsToSent.add(customFlagSettings.BCCEmailaddresses__c);
                        }
                        if(toaddresse.size()>0)
                        {
                            system.debug('toaddresses'+toaddresse);
                            email.setToAddresses(toaddresse);
                            email.setBccAddresses(emailsToSent);
                        }
                        else
                        {
                            system.debug('emailsToSent'+emailsToSent);
                            email.setToAddresses(emailsToSent);
                        }
                    }
                    else if(customFlagSettings!=null && customFlagSettings.Send_to_me__c == true)
                    {
                        if(customFlagSettings!=null && String.isNotBlank(customFlagSettings.BCCEmailaddresses__c) && customFlagSettings.BCCEmailaddresses__c.contains(','))
                        {
                            emailsToSent = customFlagSettings.BCCEmailaddresses__c.split(',');                            
                        }
                        else if(customFlagSettings!=null && String.isNotBlank(customFlagSettings.BCCEmailaddresses__c) && (!customFlagSettings.BCCEmailaddresses__c.contains(',')))
                        {
                            emailsToSent.add(customFlagSettings.BCCEmailaddresses__c);
                        }
                        email.setToAddresses(emailsToSent);
                    }
                    //AI-000422
                    if(currentReimbursement.Month__c != null ){
                        months = currentReimbursement.Month__c.split('-');
                    } 
                    newemailBody = newemailBody.replace('{Contact.Name}',currentReimbursement.Contact_Id__r.FirstName);  
                    newemailBody = newemailBody.replace('{!Contact.Manager__c}',currentReimbursement.Contact_Id__r.Manager__r.Name); 
                    newemailBody = newemailBody.replace('{!Contact.Manager__r}',currentReimbursement.Contact_Id__r.Manager__r.FirstName);
                    newemailBody = newemailBody.replace('{!Month__c}',monthNameMap.get(Integer.valueOf(months[0]) ));  
                    newemailBody = newemailBody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
                    email.setSubject(emailTemplateList1[0].Subject);
                    email.setHtmlBody(newemailBody);        
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                    System.debug('email'+email);
                    singleFlagEmailMessageList.add(email);
                    if(singleFlagEmailMessageList.size()>0 && !Test.IsRunningTest())
                    {                        
                        Messaging.sendEmail(singleFlagEmailMessageList);
                    }
                    mileagesList.addAll(mileagestoUpdateList); 
                }       
            }
        }
        if(triplogsList.size()>0)
        {
            insert triplogsList;
        }
        if(mileagesList.size()>0)
        {
            update mileagesList;
        }
    }
    global void finish(Database.BatchableContext BC) 
    {
        System.debug('inside final');
        List<Employee_Reimbursement__c> employeeReimbursementList = new List<Employee_Reimbursement__c>();
        List<Messaging.SingleEmailMessage> singleEmailMessageList = new List<Messaging.SingleEmailMessage>();
        for(Employee_Reimbursement__c currentReimbursement:[Select id,Total_Pending__c from Employee_Reimbursement__c where id IN:reimbursementMileageMap.keySet() and Total_Pending__c=0])
        {
            currentReimbursement.Status__c = 'Approved';
            currentReimbursement.Approved_Date__c = System.Today();
            employeeReimbursementList.add(currentReimbursement);
        }
        if(employeeReimbursementList.size()>0)
        {
            update employeeReimbursementList;
        }
        List<EmailTemplate> emailTemplateList = new List<EmailTemplate>([SELECT Id, Subject,HtmlValue, body FROM EmailTemplate WHERE developerName = 'mileageprocess']); 
        OrgWideEmailAddress[] owea = [SELECT Id,Address from OrgWideEmailAddress where Address = 'driverservices@mburse.com']; 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String newBody = emailTemplateList[0].HtmlValue;
        SendEmailonDeactivation__c customSettings = SendEmailonDeactivation__c.getValues('mileageprocess');       
        List<String> emailsToSend = new List<String>();
        List<String> toaddress = new List<String>();
        if(customSettings!=null && String.isNotBlank(customSettings.BCCEmailaddresses__c) && customSettings.BCCEmailaddresses__c.contains(',') && customSettings.Send_to_me__c==true)
        {
            emailsToSend = customSettings.BCCEmailaddresses__c.split(',');
            
        }
        else if(customSettings!=null && String.isNotBlank(customSettings.BCCEmailaddresses__c) && (!customSettings.BCCEmailaddresses__c.contains(',')) && customSettings.Send_to_me__c==true)
        {
            emailsToSend.add(customSettings.BCCEmailaddresses__c);
        }
        if(customSettings!=null && customSettings.Send_to_Admin__c == true)
        {
            toaddress.add(emailaddressofmanager);
        }
        else if(customSettings!=null && customSettings.Send_to_Manager__c == true)
        {
            toaddress.add(emailaddressofmanager);
        }
        if(toaddress.size()>0)
        {
            mail.setToAddresses(toaddress);
            mail.setBccAddresses(emailsToSend);
        }
        else
        {
            mail.setToAddresses(emailsToSend);
        }
        
        newBody = newBody.replace('{Contact.Name}',nameofmanager);    
        newBody = newBody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
        mail.setSubject(emailTemplateList[0].Subject);
        mail.setHtmlBody(newBody);        
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        singleEmailMessageList.add(mail);
        if(singleEmailMessageList.size()>0 && !Test.IsRunningTest())
        {
            Messaging.sendEmail(singleEmailMessageList);
        }
        // Send an email to Loggedin User that your request is Proccesed Successfully.
        /*send email to driver when mileage is flag by admin or manager */
        
    }
    public List<Employee_Mileage__c> getMileages(List<String> mileageIdsList,String status)
    {
        List<Employee_Mileage__c> mileagesList = new List<Employee_Mileage__c>();
        for(String mileageId : mileageIdsList)
        {
            Employee_Mileage__c currentMileage = new Employee_Mileage__c();
            currentMileage.id= mileageId;
            currentMileage.Trip_Status__c =status;
            currentMileage.Approved_Date__c = System.Today();
            if(status=='Approved')
            {
                currentMileage.Rejected__c = false;
            }
            else
            {
                currentMileage.Rejected__c = true;
            }
            mileagesList.add(currentMileage);
        }
        return mileagesList;
    }    
    public Tripslog__c callPutApi(String ApiKey,String bodyOfReq,String contactId,String reimbursementId,Integer totalTrips,String apiCallUrl)
    {
        Http putHTTP = new Http(); 
        HttpRequest putReq = new HttpRequest();               
        HttpResponse putRes = new HttpResponse();
        putReq.setEndpoint(apiCallUrl);
        putReq.setMethod('PUT');                 
        putReq.setBody(bodyOfReq);
        putReq.setTimeout(120000);
        putReq.setHeader('Authorization', 'apikey ' + ApiKey);
        if(!Test.IsRunningTest())
        {
            putRes = putHTTP.send(putReq);
        }
        
        
        Tripslog__c triplogobj = new Tripslog__c();
        triplogobj.Body__c = bodyOfReq;
        triplogobj.Contact__c = contactId;
        triplogobj.Employee_Reimbursement__c = reimbursementId;
        triplogobj.Endpoint__c = apiCallUrl;
        if(!Test.IsRunningTest())
        {
             triplogobj.Response__c = String.valueOf(putRes.getStatusCode())+' ######## ' +putRes.getStatus();
        }
        triplogobj.Total_Trips__c = totalTrips;
        triplogobj.Total_Mileages__c = 0;
        if(!Test.IsRunningTest() && putRes.getStatusCode()==200)
        {
            // Success
            triplogobj.Status__c ='Success';
        }
        else
        {
            // Fail
             triplogobj.Status__c ='Fail';
        }
        return triplogobj;
    }
    public static String buildBodyOfPutCall(String status,List<String> mileageIds)
    {
        String part = '';
        String body = '{"status":'+status+',"ids":[';
        for(String i : mileageIds) 
        {
            part = part +i+',';
        }
        part = part.removeEnd(',');
        body = body + part +']}';
        return body;
    }
    
}