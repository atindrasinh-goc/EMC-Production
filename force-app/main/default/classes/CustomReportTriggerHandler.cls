public with sharing class CustomReportTriggerHandler 
{
    public CustomReportTriggerHandler() 
    {

    }
    public static void checkField(List<String> fieldsList, String currentField,String message,Custom_Report__c currentReport)
    {
        System.debug(currentField.toLowerCase().trim());
        
        System.debug(fieldsList.contains(currentField.toLowerCase().trim()));
        System.debug(fieldsList);
        if(!fieldsList.contains(currentField.toLowerCase().trim()))
        {
            currentReport.addError(message);
        }
    }
}