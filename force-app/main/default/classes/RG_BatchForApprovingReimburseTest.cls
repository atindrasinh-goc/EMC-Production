@isTest
Public class RG_BatchForApprovingReimburseTest{
    public static testmethod void approvtest(){


        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';                            
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;


        Account acc = new Account();
        acc.Name = 'Excelligence Learning Corporation';
        acc.Vehicle_Types__c = '2016 Chevrolet Malibu';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        con.External_Email__c = 'test123@gmail.com';
        con.Vehicle_Type__c = '2016 Chevrolet Malibu';
        insert con;

        RG_InsertLastMonthReimbursement insRe = new RG_InsertLastMonthReimbursement();
        String lastMonth = insRe.getLastMonthValue(-1);
        List<Employee_Reimbursement__c> remList = new List<Employee_Reimbursement__c>();
        Employee_Reimbursement__c emp = new Employee_Reimbursement__c();
        emp.Contact_Id__c = con.Id;
        emp.Approved_Date__c = null;
        emp.month__c = lastMonth;
        emp.Name =  emp.Contact_Id__r.name + ':' +emp.month__c;
        remList.add(emp);
        //insert emp;
        insert remList;

        Employee_Mileage__c empMile  = new Employee_Mileage__c();
        
        empMile.Name = 'Test';
        empMile.EmployeeReimbursement__c = emp.id;
        empMile.Contact_Email_Id__c = 'test@gmail.com';
        empMile.Mileage__c = 0;
        empMile.Approved_Date__c = null;
        empMile.Trip_Status__c = StaticValues.noApprovedYet;
        empMile.Rejected__c = false;
        
        insert empMile;
        RG_BatchForApprovingReimburse batchobj = new RG_BatchForApprovingReimburse();
        DataBase.executeBatch(batchobj,1);

       
      }
     public static testmethod void approvtest1(){
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        Account acc = new Account();
        acc.Name = 'Excelligence Learning Corporation';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        con.External_Email__c = 'test123@gmail.com';
        con.Monthly_Mileage_Limit__c = 0;
        insert con;


        RG_InsertLastMonthReimbursement insRe = new RG_InsertLastMonthReimbursement();
        String lastMonth = insRe.getLastMonthValue(-1);

        Employee_Reimbursement__c emp = new Employee_Reimbursement__c();
        emp.Contact_Id__c = con.Id;
        emp.Approved_Date__c = null;
        emp.month__c = lastMonth;
        emp.Name =  emp.Contact_Id__r.name + ':' +emp.month__c;
        insert emp;

        Employee_Mileage__c empMile  = new Employee_Mileage__c();
        
        empMile.Name = 'Test';
        empMile.EmployeeReimbursement__c = emp.id;
        empMile.Contact_Email_Id__c = 'test@gmail.com';
        empMile.Mileage__c = 15;
        empMile.Approved_Date__c = Null;
        empMile.Trip_Status__c = StaticValues.noApprovedYet;
        empMile.Rejected__c = False;
        
        insert empMile;


        RG_BatchForApprovingReimburse batchobj = new RG_BatchForApprovingReimburse();
        DataBase.executeBatch(batchobj, 1);



    } 
}