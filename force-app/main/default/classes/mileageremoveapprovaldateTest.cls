@isTest
public class mileageremoveapprovaldateTest {
    public static testmethod void test1() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.mileageremoveapprovaldate__c = true;
        insert customSetting;

        TriggerConfig__c customSetting1 =  new TriggerConfig__c();
        customSetting1.Name = 'Defaulttrigger';
        customSetting1.MappingGasPriceTrigger__c = false;
        insert customSetting1;

        TriggerConfig__c customSetting2 =  new TriggerConfig__c();
        customSetting2.Name = 'Defaulttrigger';
        customSetting2.MappingGasPriceTriggerUpdateConvertedDat__c = false;
        insert customSetting2;

        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'TestContact';
        con.AccountId = acc.Id;
        con.External_Email__c = 'test@email.com';
        con.Fixed_Amount__c = 371.28;
        con.MailingCity = 'Abilene';
        con.MailingState = 'TX';
        con.Driving_States__c = 'TX';
        con.Time_Zone__c = 'America/Chicago';
        con.Monthly_Mileage_Limit__c = 100.00;
        insert con;
        
        list<Gas_Prices__c> gaslist = new  list<Gas_Prices__c>();
        for(integer i = 0; i < 5; i++) 
        {
            gaslist.add(new  Gas_Prices__c(City__c = 'Delhi' + i, Fuel_Price__c = 65, Month_Year__c = date.today().adddays(-i), State__c = 't' + i));
        }
        Insert gaslist;

        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = con.Id;
        er.Name = 'Reimbersment Test';
        er.Month__c = '09-2017';
        er.Status__c = 'Pending';
        er.Fuel_Price__c = 10.00;
        insert er;

        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.EmployeeReimbursement__c = er.id;
        emp.Contact_Email_Id__c = con.External_Email__c;
        emp.Name = 'Test Mileage Record';
        emp.Trip_Status__c = 'Not Approved Yet';
        emp.Mileage__c = 10.00;
        emp.Fuel_price__c = 10.00;
        emp.StartTime__c = system.now();
        emp.EndTime__c =  system.now();
        emp.Trip_Date__c =date.today().adddays(-1);
        insert emp;
    }
}