Trigger MappingGasPriceTrigger on Employee_Mileage__c (before insert, before update) {
    
    TriggerConfig__c customSetting = TriggerConfig__c.getInstance('Defaulttrigger');
    system.debug('inside trigger');
   
    if((Trigger.isInsert)&&(Trigger.isBefore) && customSetting.MappingGasPriceTrigger__c == true)
    {
        Set<String> reimbursementSet = new Set<String>();
        Set<String> cityStateDate = new Set<String>();
        Map<String,Decimal> reimbursementWiseFuelMap = new Map<String,Decimal>();
        Map<String,Decimal> gasPriceFuelMap = new Map<String,Decimal>();
        Map<String,String> reimbursementWiseMonthMap = new Map<String,String>();
        Map<String,String> reimbursementWiseStateCityMap = new Map<String,String>();
        for(Employee_Mileage__c currentMileage : Trigger.New)
        {
            reimbursementSet.add(currentMileage.EmployeeReimbursement__c);                    
        }
        System.debug('reimbursementSet :----------- '+reimbursementSet);
      
        if(reimbursementSet.size()>0)
        {
            for(Employee_Reimbursement__c currentReimbursment : [Select id,Month__c,Fuel_Price__c,Contact_Id__r.MailingState,Contact_Id__r.MailingCity from Employee_Reimbursement__c where id =:reimbursementSet])
            {
               
                if(currentReimbursment.Month__c.contains('-') && (String.isNotBlank(currentReimbursment.Contact_Id__r.MailingCity) || String.isNotBlank(currentReimbursment.Contact_Id__r.MailingState)))
                {
                    reimbursementWiseStateCityMap.put(currentReimbursment.id,String.valueOf(currentReimbursment.Contact_Id__r.MailingCity)+String.valueOf(currentReimbursment.Contact_Id__r.MailingState.toUpperCase()));    
                }  
                if(currentReimbursment.Fuel_Price__c!=null && currentReimbursment.Fuel_Price__c>0)
                {
                     reimbursementWiseFuelMap.put(currentReimbursment.id,currentReimbursment.Fuel_Price__c);
                }
                if(String.isNotBlank(currentReimbursment.Month__c))
                {
                    reimbursementWiseMonthMap.put(currentReimbursment.id,currentReimbursment.Month__c);
                }
                
            }
        }
        System.debug('reimbursementWiseStateCityMap :----------- '+reimbursementWiseStateCityMap);
        System.debug('reimbursementWiseFuelMap :----------- '+reimbursementWiseFuelMap);
        System.debug('reimbursementWiseMonthMap :----------- '+reimbursementWiseMonthMap);       
        for(Employee_Mileage__c currentMileage : Trigger.New)
        {
            String month='';
            if(currentMileage.Trip_Date__c!=null && currentMileage.Trip_Date__c.month()<10)
            {
                month = '0'+String.valueOf(currentMileage.Trip_Date__c.month())+'-'+String.valueOf(currentMileage.Trip_Date__c.Year());
            }                 
            else if(currentMileage.Trip_Date__c!=null)
            {
                month = String.valueOf(currentMileage.Trip_Date__c.month())+'-'+String.valueOf(currentMileage.Trip_Date__c.Year());
            }
            if(reimbursementWiseMonthMap.containsKey(currentMileage.EmployeeReimbursement__c) && (month==reimbursementWiseMonthMap.get(currentMileage.EmployeeReimbursement__c)) && reimbursementWiseFuelMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                System.debug('It have same reimbursmeent and it is setting fuel price here for Month '+month);
                currentMileage.Fuel_Price__c = reimbursementWiseFuelMap.get(currentMileage.EmployeeReimbursement__c);
            }
            else if(reimbursementWiseStateCityMap.containsKey(currentMileage.EmployeeReimbursement__c) && currentMileage.Trip_Date__c!=null)
            {
                String getStateCity = reimbursementWiseStateCityMap.get(currentMileage.EmployeeReimbursement__c);
                System.debug('getStateCity for '+currentMileage.Trip_Date__c+' ---- State City :- '+getStateCity);
                getStateCity= getStateCity+String.valueOf(currentMileage.Trip_Date__c.Month())+String.valueOf(currentMileage.Trip_Date__c.Year());
                cityStateDate.add(getStateCity);
            } 
        }
        
        System.debug('cityStateDate has no of records '+cityStateDate);
        if(cityStateDate.size()>0)
        {
            for(Gas_Prices__c currentGasPrice : [Select id,Fuel_Price__c,Month_State_City__c from Gas_Prices__c where Month_State_City__c IN: cityStateDate])
            {
                gasPriceFuelMap.put(currentGasPrice.Month_State_City__c,currentGasPrice.Fuel_Price__c);
            }
        }
        System.debug('gas price records from gasPriceFuelMap '+gasPriceFuelMap.size());
        for(Employee_Mileage__c currentMileage : Trigger.New)
        {
            if((currentMileage.Trip_Date__c!=null) && (reimbursementWiseStateCityMap.containsKey(currentMileage.EmployeeReimbursement__c)))
            {
                String statecity=reimbursementWiseStateCityMap.get(currentMileage.EmployeeReimbursement__c);
                System.debug('Finally Settinig Fuel price with a part of a key having state and City :- '+statecity);
                statecity = statecity + String.valueOf(currentMileage.Trip_Date__c.Month())+String.valueOf(currentMileage.Trip_Date__c.Year());
                System.debug('Added dates in to it :- '+statecity);
                if(gasPriceFuelMap.containsKey(statecity))
                {
                    System.debug('Finally it is Setting here the fuel price.');
                    currentMileage.Fuel_Price__c = gasPriceFuelMap.get(statecity);
                }
            } 
        }
    }

    if(Trigger.isInsert && Trigger.isBefore) {
        MappingGasPriceTriggerHelper.updateConvertedDates(Trigger.new);
    }
    else if(Trigger.isBefore && Trigger.isUpdate){
        List<Employee_Mileage__c> updateMileagesList = new List<Employee_Mileage__c>();
        for(Employee_Mileage__c currentMileages : Trigger.New)
        {
            if(currentMileages.TimeZone__c != Trigger.oldMap.get(currentMileages.id).TimeZone__c || currentMileages.StartTime__c != Trigger.oldMap.get(currentMileages.id).StartTime__c || currentMileages.EndTime__c != Trigger.oldMap.get(currentMileages.id).EndTime__c)
            {
                updateMileagesList.add(currentMileages);
            }
        }
        if(updateMileagesList.size()>0)
        {
            MappingGasPriceTriggerHelper.updateConvertedDates(updateMileagesList);
        }
    }
   
}