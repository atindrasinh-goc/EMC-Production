global class AutoApprovedEmailClass implements Database.Batchable<sObject>, Database.Stateful{
    global Map<Id, Employee_Reimbursement__c> conIdToReimMap;
    global Map<Id, list<contact>> manToDriverMap;
    global Map<Id, decimal> emReimToTotalMileagemap; 
    global List<Contact> conlist;
    
    /*
        Constructor
    */ 
    global AutoApprovedEmailClass(){
        String tempDate = date.today().addMonths(-1).Month() + '-' + date.today().addMonths(-1).Year();
        String lastMonth = tempDate.left(2);

        if(lastMonth.contains('-')) {
            lastMonth = '0' + tempDate;
        } else {
            lastMonth = tempDate;
        }
        
        List<String> obj_accountnames1 = new List<String>();

        if(System.Label.TripstobeLogged != null || System.Label.TripstobeLogged != '') {   
            List<String> labelAcc = new List<String>();

            if(System.Label.TripstobeLogged.contains(',')) {
                labelAcc = System.Label.TripstobeLogged.split(',');
            }
            
            for(String s : labelAcc) {
                s = s.trim();
                if(s.contains(',')) { 
                    s = s.replace(',','');
                }
                obj_accountnames1.add(s);                
            }   
        }   
        
        conIdToReimMap = new  Map<Id, Employee_Reimbursement__c> ();
        manToDriverMap = new Map<Id, list<Contact>> ();
        emReimToTotalMileagemap = new Map<Id, decimal>();
        conlist = new List<Contact>();

        if(obj_accountnames1.size() > 0){
            Datetime currentDate = System.now();
            list<user> userlist;
            if(obj_accountnames1.size() > 0) {
                userlist = [SELECT email,contactid FROM user WHERE IsActive = : true AND contactid != null AND contact.accountid != null AND contact.account.Enable_Email_For_Managers__c = true and contact.account.Name =:obj_accountnames1];
            } else {
                userlist = [SELECT email,contactid FROM user WHERE IsActive = : true AND contactid != null AND contact.accountid != null AND contact.account.Enable_Email_For_Managers__c = true]; 
            }
            
            list<id> cIdList = new  list<id>();
            for(user u: userlist)  {
                cIdList.add(u.contactid);
            }

            if(obj_accountnames1.size()>0 && !Test.isRunningTest()) {
                conlist = [SELECT id,Role__c,account.Enable_Email_For_Managers__c,Deactivated_Date__c,External_Email__c,Account.Approval_Template_Message__c,Monthly_Mileage_Limit__c,name,(SELECT Role__c,id,name, Monthly_Mileage_Limit__c FROM drivers__r) FROM contact WHERE id in: cIdList AND accountid != null AND account.Enable_Email_For_Managers__c = true AND Role__c != ''  and account.Name =:obj_accountnames1 AND (Deactivated_Date__c = NULL OR Deactivated_Date__c <=: currentDate)];            
            }
            else if(obj_accountnames1.size()==0 && !Test.isRunningTest()) {
                conlist = [SELECT id,Role__c,account.Enable_Email_For_Managers__c,Deactivated_Date__c,External_Email__c,Account.Approval_Template_Message__c,Monthly_Mileage_Limit__c,name,(SELECT Role__c,id,name, Monthly_Mileage_Limit__c FROM drivers__r) FROM contact WHERE id in: cIdList AND accountid != null AND account.Enable_Email_For_Managers__c = true AND Role__c != '' AND (Deactivated_Date__c = NULL OR Deactivated_Date__c <=: currentDate)];
            } else {
                conlist = [SELECT id,Role__c,account.Enable_Email_For_Managers__c,Deactivated_Date__c,External_Email__c,Account.Approval_Template_Message__c,Monthly_Mileage_Limit__c,name,(SELECT Role__c,id,name, Monthly_Mileage_Limit__c FROM drivers__r) FROM contact WHERE id in: cIdList AND accountid != null AND account.Enable_Email_For_Managers__c = true AND Role__c != '' LIMIT 1];
            }
            
            if(!conlist.isEmpty()){
                list<id> caIdList = new  list<id>();
                for(Contact c : conlist){
                    for(contact co : c.Drivers__r) {
                        caIdList.add(co.id);
                    }
                }

                for(Contact c : [SELECT Id, Role__c, Account.Enable_Email_For_Managers__c, Manager__c, Manager__r.Manager__r.External_Email__c, Manager__r.External_Email__c, Name, External_Email__c,  (SELECT Id,  month__c, status__c,Total_Mileage__c FROM Employee_Reimbursements__r WHERE month__c = : lastmonth),  Monthly_Mileage_Limit__c, Deactivated_Date__c FROM Contact WHERE Manager__c in: caIdList]){
                    list<Contact> con = new list<Contact>();
                    if(manToDriverMap.get(c.Manager__c) != null) {
                        con.addAll(manToDriverMap.get(c.Manager__c));
                    }
                    con.add(c);
                    manToDriverMap.put(c.Manager__c, con);
                }         
                
                for(Employee_Reimbursement__c ri : [SELECT Id, Name, Month__c, status__c, Total_Mileage__c, Contact_id__c FROM Employee_Reimbursement__c WHERE Contact_id__c in: caIdList AND Month__c = : lastmonth]){
                    conIdToReimMap.put(ri.Contact_id__c, ri);
                }
            }
        }
    }

    /*
        Start Method
    */ 
    global list<contact> start(Database.BatchableContext BC){ 
        return conlist;
    }
    
    /*
        Execute Method
    */ 
    global void execute(Database.BatchableContext BC, list<contact> conlist){
        List<OrgWideEmailAddress> owea = [SELECT Id, 
                                                Address
                                        FROM OrgWideEmailAddress
                                        WHERE Address = 'driverservices@mburse.com' ];
        EmailTemplate emailTemplate = [SELECT Id, HtmlValue, Name, Subject FROM EmailTemplate WHERE DeveloperName =: 'Auto_Approval_Template'];

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        string month = string.valueOf(Date.today().addMonths(-1).month());
        string m = (month == '1') ? 'January' : (month == '2') ? 'February' : (month == '3') ? 'March' : (month == '4') ? 'April' : (month == '5') ? 'May' : (month == '6') ? 'June' : (month == '7') ? 'July' : (month == '8') ? 'August' : (month == '9') ? 'September' : (month == '01') ? 'January' : (month == '02') ? 'February' : (month == '03') ? 'March' : (month == '04') ? 'April' : (month == '05') ? 'May' : (month == '06') ? 'June' : (month == '07') ? 'July' : (month == '08') ? 'August' : (month == '09') ? 'September' : (month == '10') ? 'October' : (month == '11') ? 'November' : (month == '12') ? 'December' : 'Invalid Month';

        for(Contact con: conlist) {
            String html = '';
           
            String newBody = emailTemplate.HtmlValue;
            if(!String.isBlank(con.Account.Approval_Template_Message__c)) {
                String accountMessage = con.Account.Approval_Template_Message__c;
                accountMessage = accountMessage.replace('{month}', m);
                newBody = newBody.replace('{account.Approval_Template_Message__c}',accountMessage);
            }else {
                newBody = newBody.replace('{account.Approval_Template_Message__c}','');
            }
            if(con.role__c == 'Admin' || con.role__c == 'Driver/Admin') {
                String reportTo = '<th style="border:2px solid black;" width="5%">Report To</th>';
                newBody = newBody.replace('{reportToTR}',reportTo);
            }else {
                newBody = newBody.replace('{reportToTR}','');
            }

            for(contact co: con.drivers__r) {
                if(conIdToReimMap.get(co.id) != null) {
                    decimal mileage = 0;
                    decimal monthlyLimit = 0;
                    if(co.Monthly_Mileage_Limit__c != null) {
                        monthlyLimit = co.Monthly_Mileage_Limit__c;
                    }
                    if(conIdToReimMap.get(co.id).Total_Mileage__c != Null && conIdToReimMap.get(co.id).Total_Mileage__c > 0){
                        html = '<tr align="center">' + '<td style="border:2px solid black;">' + co.Name + '</td>' + '<td style="border:2px solid black;">' + conIdToReimMap.get(co.id).Month__c + '</td>' + '<td style="border:2px solid black;">' + monthlyLimit + '</td>' + '<td style="border:2px solid black;">' + conIdToReimMap.get(co.id).Total_Mileage__c + '</td>' + '<td style="border:2px solid black;">' + conIdToReimMap.get(co.id).status__c + '</td>';
                        if(con.role__c == 'Admin' || con.role__c == 'Driver/Admin') {
                            html += +'<td style="border:2px solid black;" width="5%">' + con.Name + '</td>';
                        }
                        html += +'</tr>';
                    }
                }

                if(manToDriverMap.get(co.id) != null) {
                    for(contact c: manToDriverMap.get(co.id)) {
                        if(c.Employee_Reimbursements__r.size() > 0) {
                            decimal mileage = 0;
                            decimal monthlyLimit = 0;
                            if(c.Monthly_Mileage_Limit__c != null) {
                                monthlyLimit = c.Monthly_Mileage_Limit__c;
                            }
                            if(c.Employee_Reimbursements__r[0].Total_Mileage__c != Null && c.Employee_Reimbursements__r[0].Total_Mileage__c > 0){
                                html += +'<tr align="center">' + '<td style="border:2px solid black;">' + c.Name + '</td>' + '<td style="border:2px solid black;">' + c.Employee_Reimbursements__r[0].Month__c + '</td>' + '<td style="border:2px solid black;">' + monthlyLimit + '</td>' + '<td style="border:2px solid black;">' + c.Employee_Reimbursements__r[0].Total_Mileage__c + '</td>' + '<td style="border:2px solid black;">' + c.Employee_Reimbursements__r[0].status__c + '</td>';
                                if(con.role__c == 'Admin' || con.role__c == 'Driver/Admin') {
                                    html += +'<td style="border:2px solid black;" width="5%">' + co.Name + '</td>';
                                }
                                html += +'</tr>';    
                            }
                        }
                    }
                }

                system.debug(html);
                newBody = newBody.replace('{tableDynamicData}',html);
            }

            if(con.drivers__r.size() > 0 && con.External_Email__c != null && con.account.Enable_Email_For_Managers__c) {
                messaging.singleEmailMessage mail = new  messaging.singleEmailMessage();
                if(owea.size() > 0)  {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                string[] toAddresses;
                SendEmailToMe__c  objSendEmailToMe = SendEmailToMe__c.getValues('AutoApprovedEmailClass');
                if(objSendEmailToMe.Send_email_to_me__c == true) {
                    toAddresses = new string[]{'sanket.goc@gmail.com'};
                } else {
                    toAddresses = new string[]{con.External_Email__c};
                }
               
                // Assign the addresses for the To and CC lists to the mail object
                mail.setToAddresses(toAddresses);
                //Email subject to be changed
                mail.setSubject(emailTemplate.Subject);
                if(objSendEmailToMe.SetBccAddress__c == true){
                    mail.setBCCAddresses(new string[]{'minkesh.patel@getoncrm.com'});
                }
                
                mail.setHtmlBody(newBody);
                if(newBody.contains('</td>')){
                    mails.add(mail);    
                }
            }
        }

        SendEmail__c  objSendEmail = SendEmail__c.getValues('AutoApprovedEmailClass');
        if(!mails.isEmpty() && !Test.isRunningTest()  &&(objSendEmail!=null) && (objSendEmail.Send_email_from_code__c==true)) {
            if(!mails.isEmpty() ){
                Messaging.sendEmail(mails);
            } 
        }

    }

    /*
        Finish Method
    */ 
    global void finish(Database.BatchableContext BC){

    }
}