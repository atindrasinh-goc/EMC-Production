trigger CheckVehicleAccountTrigger on Account(before insert,before update) {
    list<String> vehicleNamesset = new list<String>();
    Map<String,String> urlMap = new Map<String,String>();
    for(Account accObj : Trigger.new){
        if(accObj.Vehicle_Types__c != null){
            vehicleNamesset.addAll(accObj.Vehicle_Types__c.replace(' ','').toUpperCase().split(';'));
        }
    }
    for(Vehicle_URL_Mapping__c u : [SELECT Id, Year__c, Vehicle__c, URL__c,Vehicle_Mapping__c FROM Vehicle_URL_Mapping__c where Vehicle_Mapping__c IN: vehicleNamesset]){
        if((u.URL__c != null || u.URL__c != '') &&(!urlMap.containsKey(u.Vehicle_Mapping__c))){
            urlMap.put(u.Vehicle_Mapping__c,u.URL__c);
        }
    } 
    for(Account acc : Trigger.new){
        if(String.isNotBlank(acc.Vehicle_Types__c))
        {
            list<String> accList = new List<String>();
            if(acc.Vehicle_Types__c.contains(';')){
                accList.addAll(acc.Vehicle_Types__c.replace(' ','').toUpperCase().split(';'));
            }
            else{
                accList.add(acc.Vehicle_Types__c.replace(' ','').toUpperCase());
            }
            //accList.addAll(acc.Vehicle_Types__c.replace(' ','').toUpperCase().split(';'));
            if(accList.size() > 0 ){
                for(String accObj : accList){
                    if(!urlMap.containsKey(accObj))
                    {
                        acc.addError('Please Enter Valid Standard Vehicle Make Model and Year');
                    }
                }
            }
        }
    }
}