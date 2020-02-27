/*
    @Description: Test class for UpdateTripsStatusBatch
*/

@isTest
public class UpdateTripsStatusBatchTest {
    
    public static testmethod void updateTripStatustest() {
        List<Id> contactids = new List<Id>();
        Map<Id, Employee_Reimbursement__c> conReim = new Map<Id, Employee_Reimbursement__c>();
        
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        insert customSetting;
        
        Get_Trip_Date_Settings__c obj_Get_Trip_Date_Settings = new Get_Trip_Date_Settings__c();
        obj_Get_Trip_Date_Settings.Name ='Date Settings';
        obj_Get_Trip_Date_Settings.Start_Date__c ='2019-01-01';
        obj_Get_Trip_Date_Settings.End_Date__c ='2019-01-31';
        obj_Get_Trip_Date_Settings.Last_N_Days__c ='31';
        insert obj_Get_Trip_Date_Settings;

        Account acc = new Account();           
        acc.Name = 'Delta account';
        acc.Triplog_API__c = '123456789';
        Acc.Triplog_Status__c = 'U';
        insert Acc;
        
        Contact contact = new Contact();
        contact.lastname = 'Test Contact';
        contact.AccountId = Acc.Id;
        contact.External_Email__c = 'minkesh.patel1478@gmail.com';
        contact.Email = 'minkesh.patel1478@gmail.com';
        contact.isCommunityUser__c = true;
        insert contact;
        contactids.add(contact.Id);
        
        Contact con = new Contact();
        con.lastname = 'Test Con';
        con.AccountId = Acc.Id;
        con.External_Email__c = 'minkesh.patel1357@gmail.com';
        con.Email = 'minkesh.patel1357@gmail.com';
        con.Triplog_Status__c = 'U';
        con.isCommunityUser__c = true;
        insert con;
        contactids.add(con.Id);
        
        Employee_Reimbursement__c er = new Employee_Reimbursement__c();
        er.Contact_Id__c = contact.Id;
        
        er.month__c = '12-2018';
        er.Name = contact.lastname+':'+er.month__c;
        er.Status__c = 'Pending';
        er.Fuel_Price__c = 1; 
        er.MPG__c = 10.00;
        er.Maintenance_and_Tires__c = 24;
        er.Fuel_Price__c = 1;
        er.MPG__c = 10;
        er.Maintenance_and_Tires__c = 10;
        er.Fixed_Amount__c = 10.10;
        er.Triplog_Status__c = 'U';
        insert er;
        conReim.put(con.Id,er);
        
        Employee_Mileage__c emp = new Employee_Mileage__c();
        emp.Contact_Email_Id__c = 'test@test.gmail.com';
        emp.Name = 'Test Mileage Record';
        emp.EmployeeReimbursement__c = er.id;
        insert emp;
        
        Test.startTest();
        
            Test.SetMock( HttpCalloutMock.class, new updateTripsStatusBatchMock() );
            UpdateTripsStatusBatch updateStatusObj = new UpdateTripsStatusBatch( new List<String> { '12-2018' }, Acc.Id);
            DataBase.executeBatch( updateStatusObj );
        
            UpdateTripsStatusBatch updateStatusObj2 = new UpdateTripsStatusBatch( er.Id);
            DataBase.executeBatch( updateStatusObj2 );
            
            UpdateTripsStatusBatch updateStatusObj3 = new UpdateTripsStatusBatch( new List<String> { emp.Id });
            DataBase.executeBatch( updateStatusObj3 );
        Test.stopTest();
    }
    
}