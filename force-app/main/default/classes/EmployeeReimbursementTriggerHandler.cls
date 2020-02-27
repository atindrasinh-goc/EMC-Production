/*Description: Trigger populates Fuel Price and Fixed Amount values of Employee Reimbersment object.
Fuel Price is populated from Gas Price record having same City, State as Contact Mailing Address AND
having same month and year in Month Year field as Employee Reimbersment's Month field.
Fixed Price is populated from Contact's Fixed Price.
*/
public with sharing class EmployeeReimbursementTriggerHandler {
    /*public static Void populateFields(List<Employee_Reimbursement__c> newEmpReimbursements) {
        Set<Id> empReimIds = new Set<Id>();
        Set<String> cityNames = new Set<String>();
        Set<String> stateNames = new Set<String>();
        Set<Date> monthYears = new Set<Date>();
        Map<String, List<Employee_Reimbursement__c>> keyToReimbersment = new Map<String, List<Employee_Reimbursement__c> >();
        String month, year;
        List<Employee_Reimbursement__c> updateReimbersments = new List<Employee_Reimbursement__c>();
        for(Employee_Reimbursement__c reimbers : [SELECT Id, Month__c, City_State__c, Fixed_Amount__c, Fuel_Price__c,
            Contact_Id__c, Contact_Id__r.Fixed_Amount__c FROM Employee_Reimbursement__c WHERE Fixed_Amount__c = NULL AND Fuel_Price__c = NULL AND Id IN : newEmpReimbursements]) {
            if(reimbers.Contact_Id__r.Fixed_Amount__c != null) {
                reimbers.Fixed_Amount__c = reimbers.Contact_Id__r.Fixed_Amount__c;
            }
            if(reimbers.City_State__c.length() > 1) {
                cityNames.add(reimbers.City_State__c.split('-')[0]);
                stateNames.add(reimbers.City_State__c.split('-')[1]);
            }
            String tempStrDate = '';
            if(!String.isBlank(reimbers.Month__c)) {
                month = reimbers.Month__c.split('-')[0];
                if(month.substring(0,1).contains('0')) {
                    month = month.replace('0', '');
                }
                year = reimbers.Month__c.split('-')[1];
                date monthYear = date.parse(month  +  '/1/'  +  year);
                tempStrDate = monthYear.format();
                monthYears.add(monthYear);
            }
            
            String temp = '';
            if(!String.isBlank(reimbers.City_State__c)) {
                temp = reimbers.City_State__c  +  '-'  +  tempStrDate;
            }
            if(!keyToReimbersment.containsKey(temp)) {
                keyToReimbersment.put(temp, new List<Employee_Reimbursement__c>{reimbers});
            } else {
                keyToReimbersment.get(temp).add(reimbers);
            }
        }
        
        for(Gas_Prices__c gasPrice : [SELECT City__c, State__c, Fuel_Price__c, Month_Year__c FROM Gas_Prices__c
            WHERE City__c IN : cityNames AND State__c IN : stateNames AND Month_Year__c IN : monthYears]) {
            String tempStrDateGP = gasPrice.Month_Year__c.format();
            String key = gasPrice.City__c  +  '-' +  gasPrice.State__c  +  '-'  +  gasPrice.Month_Year__c;
            if(keyToReimbersment.containsKey(key) && gasPrice.Fuel_Price__c != null) {
                for(Employee_Reimbursement__c er : keyToReimbersment.get(key)) {
                    er.Fuel_Price__c = gasPrice.Fuel_Price__c;
                    updateReimbersments.add(er);
                }
            }
        }
        if(!updateReimbersments.isEmpty()) {
            update updateReimbersments;
        }
    }*/

    public static Void mileagefieldupdate(List<Employee_Reimbursement__c> empReimbursList, Map<Id,Employee_Reimbursement__c> empReimburseOld, Map<Id,Employee_Reimbursement__c> empReimburseNew) {         
        //Set<Id> empReimbursId = new Set<Id>();
        /*for(Employee_Reimbursement__c empreimbuseobj : empReimbursList) {
            if(empreimbuseobj.Status__c != empReimburseOld.get(empreimbuseobj.Id).Status__c && empreimbuseobj.Status__c == 'Approved') {
                empReimbursId.add(empreimbuseobj.Id);
            }
        }*/

        List<Employee_Mileage__c> mileageUpdatelist = new List<Employee_Mileage__c>();
        Employee_Reimbursement__c reimForMil = new Employee_Reimbursement__c();
        for(Employee_Mileage__c empmilege : [Select id, name, Trip_Status__c, Rejected__c, EmployeeReimbursement__c,EmployeeReimbursement__r.Status__c, Approved_Date__c 
            from Employee_Mileage__c where EmployeeReimbursement__c in : empReimbursList]) {
            if(empmilege.EmployeeReimbursement__r.Status__c == 'Approved'){

                reimForMil = empReimburseNew.get(empmilege.EmployeeReimbursement__c);
                    
                if(empmilege.Approved_Date__c == null) {
                    empmilege.Approved_Date__c = reimForMil.Approved_Date__c;
                }
                if(empmilege.Trip_Status__c == StaticValues.noApprovedYet && (empmilege.Trip_Status__c != 'Rejected' || empmilege.Rejected__c == false) ) {
                    empmilege.Trip_Status__c = 'Approved';
                }
                if(empmilege.Rejected__c == true){
                    empmilege.Trip_Status__c = 'Rejected';
                }
                mileageUpdatelist.add(empmilege);
            }
        }
        if(!mileageUpdatelist.isEmpty()) {
            update mileageUpdatelist;    
        }     
    }
}