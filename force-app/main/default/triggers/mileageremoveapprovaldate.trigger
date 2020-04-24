trigger mileageremoveapprovaldate on Employee_Mileage__c (before insert , before update) {
    
    TriggerConfig__c customSetting = TriggerConfig__c.getInstance('Defaulttrigger');
     if(customSetting.mileageremoveapprovaldate__c == true){
         MileageTriggerHandler.MileageRemoveApprovalDateHandler(Trigger.new);
     }
    
}