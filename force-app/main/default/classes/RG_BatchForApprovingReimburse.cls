global class RG_BatchForApprovingReimburse implements Database.Batchable<sObject> 
{
    List<Employee_Reimbursement__c> updateReimbursement = new List<Employee_Reimbursement__c>();
    Map<String, List<String>> contactIdToReimbursements = new Map<String, List<String>>();
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        List<String> obj_accountnames = new List<String>();
        List<String> obj_accountnames1 = new List<String>();
        String querybuilding ='';
        if(System.Label.TripstobeLogged!=null)
        {
            if(System.Label.TripstobeLogged.contains(','))
            {
                obj_accountnames= System.Label.TripstobeLogged.split(',');
            }
            Integer i=0;    
            for(String s:obj_accountnames)
            {
                s = s.trim();
                if(s.contains(','))
                {
                    s = s.replace(',','');
                }
                if(i==0)
                {
                    querybuilding = ' ( Contact_Id__r.Account.Name = \''+s+'\'';    
                }
                else
                {
                    querybuilding = querybuilding+ ' OR '+ 'Contact_Id__r.Account.Name = \''+s+'\'';
                }        
                i++;
            }
            querybuilding = querybuilding+' ) AND ';
            System.debug(querybuilding);    
        }
        RG_InsertLastMonthReimbursement insRe = new RG_InsertLastMonthReimbursement();
        String lastMonth = insRe.getLastMonthValue(-1);
        string query = 'select id, Name, Contact_Id__r.Name, Total_Mileage_WithOut_Previous__c, Contact_Id__r.FirstName, Contact_Id__r.account.Enable_Email_For_Driver__c, Contact_Id__r.External_Email__c, Contact_Id__r.Monthly_Mileage_Limit__c, Contact_Id__r.Manager__r.External_Email__c, Contact_Id__r.Manager__r.FirstName, Contact_Id__r.Manager__c, Monthly_Mileage__c, Total_Mileage__c from Employee_Reimbursement__c where '+querybuilding+' month__c=\'' + lastMonth + '\'  and Approved_Date__c=null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Employee_Reimbursement__c> empReimList) 
    {
        
        Map<String, List<String>> contactIdOfReimbursement = new Map<String, List<String>>();
        for(Employee_Reimbursement__c singleReimbursement : empReimList) 
        {
            //if((singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c >= singleReimbursement.Total_Mileage_WithOut_Previous__c) || (singleReimbursement.Total_Mileage__c == 0)) 
            if((singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c >= singleReimbursement.Total_Mileage__c) || (singleReimbursement.Total_Mileage__c == 0)) 
            {
                singleReimbursement.Status__c = 'Approved';
                singleReimbursement.Approved_Date__c = System.today();
                updateReimbursement.add(singleReimbursement);
            } 
           // else if(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c < singleReimbursement.Total_Mileage_WithOut_Previous__c) 
            else if(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c < singleReimbursement.Total_Mileage__c) 
            {
                if(!contactIdOfReimbursement.containsKey(singleReimbursement.Contact_Id__r.Manager__r.External_Email__c+'#'+singleReimbursement.Contact_Id__r.Manager__r.FirstName))
                {
                   // contactIdOfReimbursement.put(singleReimbursement.Contact_Id__r.Manager__r.External_Email__c+'#'+singleReimbursement.Contact_Id__r.Manager__r.FirstName, new List<String>{String.valueOf(singleReimbursement.Total_Mileage_WithOut_Previous__c)+'#'+String.valueOf(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c)+'#'+singleReimbursement.Contact_Id__r.Name});
                   contactIdOfReimbursement.put(singleReimbursement.Contact_Id__r.Manager__r.External_Email__c+'#'+singleReimbursement.Contact_Id__r.Manager__r.FirstName, new List<String>{String.valueOf(singleReimbursement.Total_Mileage__c)+'#'+String.valueOf(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c)+'#'+singleReimbursement.Contact_Id__r.Name});
                }
                else 
                {
                  //  contactIdOfReimbursement.get(singleReimbursement.Contact_Id__r.Manager__r.External_Email__c+'#'+singleReimbursement.Contact_Id__r.Manager__r.FirstName).add(String.valueOf(singleReimbursement.Total_Mileage_WithOut_Previous__c)+'#'+String.valueOf(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c)+'#'+singleReimbursement.Contact_Id__r.Name);
                   contactIdOfReimbursement.get(singleReimbursement.Contact_Id__r.Manager__r.External_Email__c+'#'+singleReimbursement.Contact_Id__r.Manager__r.FirstName).add(String.valueOf(singleReimbursement.Total_Mileage__c)+'#'+String.valueOf(singleReimbursement.Contact_Id__r.Monthly_Mileage_Limit__c)+'#'+singleReimbursement.Contact_Id__r.Name);
                }
            }
        }
        
        if(!updateReimbursement.isEmpty()) 
        {
            update updateReimbursement;
        }
        
        if(!contactIdOfReimbursement.isEmpty()) 
        {
            OrgWideEmailAddress[] owea = [select Id ,Address from OrgWideEmailAddress where Address = 'driverservices@mburse.com'];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemplate = [SELECT Id,HtmlValue,Name,Subject FROM EmailTemplate WHERE DeveloperName =:'Exceeding_Threshold_Template'];
            for(String singleId : contactIdOfReimbursement.keySet()) 
            {
                String managerEmail = singleId.split('#')[0];
                String managerName  = singleId.split('#')[1];
                String newBody = emailTemplate.HtmlValue;
                newBody = newBody.replace('{!Contact.FirstName}',managerName);
                String html = '';
                for(String value : contactIdOfReimbursement.get(singleId)) 
                {
                    Decimal totalMileage = Decimal.valueOf(value.split('#')[0]);
                    Decimal mileageLimit = Decimal.valueOf(value.split('#')[1]);
                    String driverName = value.split('#')[2];
                    html += '<tr align="center">'
                    +'<td style="border:2px solid black;">'+driverName+'</td>'
                    +'<td style="border:2px solid black;">'+totalMileage+'</td>'
                    +'<td style="border:2px solid black;">'+mileageLimit+'</td>';
                    html += + '</tr>';
                }
                newBody =  newBody.replace('{mileageThresholdTable}',html);
                messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                String[] toAddresses = new String[] {managerEmail}; //managerEmail
               // String[] toAddresses = new String[] {'natavar.goc@gmail.com'}; //managerEmail
                mail.setToAddresses(toAddresses);
                mail.setSubject(emailTemplate.Subject);
                mail.setHtmlBody(newBody);
                mail.setBCCAddresses(new string[]{'minkesh.patel@getoncrm.com','natavar.goc@gmail.com'});
                System.debug('mail :'+newBody);
                mails.add(mail);
            }
            if(!mails.isEmpty() && !Test.isRunningTest()) 
            {
                Messaging.sendEmail(mails);
            }
        }  
    }
    global void finish(Database.BatchableContext BC) 
    {
         RG_AutoApprovedEmailClass att = new  RG_AutoApprovedEmailClass();
            if(!Test.isRunningTest()) 
            {
            // Database.executeBatch(att, 2);
            }
        
        /*Batch_Setup__c batchsetupConfig = new Batch_Setup__c();
        batchsetupConfig = [Select AutoApprovedEmail__c, BatchForApprovingReimburse__c From Batch_Setup__c ];
        if(batchsetupConfig.BatchForApprovingReimburse__c == false)
        {
            batchsetupConfig.BatchForApprovingReimburse__c = true;
            update batchsetupConfig;
            
        }
        if(batchsetupConfig.AutoApprovedEmail__c == True)
        {
            batchsetupConfig.AutoApprovedEmail__c = false;
            update batchsetupConfig;
            RG_AutoApprovedEmailClass att = new  RG_AutoApprovedEmailClass();
            if(!Test.isRunningTest()) 
            {
               // Database.executeBatch(att, 2);
            }
        }*/
        
    }
}