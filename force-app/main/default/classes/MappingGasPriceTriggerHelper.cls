public without sharing class MappingGasPriceTriggerHelper{

    public static void updateConvertedDates(List<Employee_Mileage__c> mileagesList){
        List<String> datetimeofstart;
       system.debug('mileagesList'+mileagesList);
        Map<String,String> timeZoneMap = new Map<String,String>();
        set<Id> reimIds = new Set<Id>();
        for(Employee_Mileage__c currentMileage : mileagesList)
        {
            reimIds.add(currentMileage.EmployeeReimbursement__c);
            
            /*if(currentMileage.EmployeeReimbursement__c != null && !timeZoneMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                timeZoneMap.put(currentMileage.EmployeeReimbursement__c,currentMileage.EmployeeReimbursement__r.Contact_Id__r.Time_Zone__c);
            }*/
        }
        for(Employee_Reimbursement__c currentReimbursement : [Select id,Contact_Id__r.Time_Zone__c from Employee_Reimbursement__c where id IN: reimIds])
        {
           if(!timeZoneMap.containsKey(currentReimbursement.id))
            {
                timeZoneMap.put(currentReimbursement.id,currentReimbursement.Contact_Id__r.Time_Zone__c);
            } 
        }
        for(Employee_Mileage__c currentMileage : mileagesList)
        {
            
            if(timeZoneMap.containsKey(currentMileage.EmployeeReimbursement__c))
            {
                currentMileage.TimeZone__c = timeZoneMap.get(currentMileage.EmployeeReimbursement__c);
                if(currentMileage.StartTime__c!=null) 
                {
                    String strConvertedDate = currentMileage.StartTime__c.format('MM/dd/yyyy HH:mm:ss',timeZoneMap.get(currentMileage.EmployeeReimbursement__c));
               
                datetimeofstart = new List<String>();
                datetimeofstart.addAll(strConvertedDate.split(' '));
                Datetime GMTDate =Datetime.newInstanceGMT(Integer.valueOf(datetimeofstart[0].split('/')[2]),Integer.valueOf(datetimeofstart[0].split('/')[0]),Integer.valueOf(datetimeofstart[0].split('/')[1]),Integer.valueOf(datetimeofstart[1].split(':')[0]),Integer.valueOf(datetimeofstart[1].split(':')[1]),Integer.valueOf(datetimeofstart[1].split(':')[2]));
                
                currentMileage.ConvertedStartTime__c = GMTDate;
                }
                system.debug('TimeZone__c '+currentMileage.TimeZone__c);
                if(currentMileage.EndTime__c!=null)
                {
                     String strEndCOnvertedDate = currentMileage.EndTime__c.format('MM/dd/yyyy HH:mm:ss',timeZoneMap.get(currentMileage.EmployeeReimbursement__c));
                datetimeofstart = new List<String>();
                datetimeofstart.addAll(strEndCOnvertedDate.split(' '));
                Datetime GMTEndDate =Datetime.newInstanceGMT(Integer.valueOf(datetimeofstart[0].split('/')[2]),Integer.valueOf(datetimeofstart[0].split('/')[0]),Integer.valueOf(datetimeofstart[0].split('/')[1]),Integer.valueOf(datetimeofstart[1].split(':')[0]),Integer.valueOf(datetimeofstart[1].split(':')[1]),Integer.valueOf(datetimeofstart[1].split(':')[2]));
                currentMileage.ConvertedEndTime__c = GMTEndDate;
                }
               

               
               
            }
        }
    }
}