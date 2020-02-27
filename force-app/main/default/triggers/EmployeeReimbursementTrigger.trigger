trigger EmployeeReimbursementTrigger on Employee_Reimbursement__c (after update) {
   /*if(Trigger.isAfter && Trigger.isInsert) {
    	EmployeeReimbursementTriggerHandler.populateFields(Trigger.New);
    }else*/
     if(Trigger.isUpdate && checkRecursive.runOnce()) {
    	EmployeeReimbursementTriggerHandler.mileagefieldupdate(Trigger.New, Trigger.oldMap, Trigger.newMap);
    }
}