/**
@author Natavar Ghodasara
@date 26th Feb 2019
@group Wrapper
@group-content WrapperDetails.html
@description EmployeeReimbursements is used to Build Wrapper of Reimbursements.
*/
public with sharing class EmployeeReimbursements 
{
    /*******************************************************************************************************
    * @description employeeReimbursementId is Employee Reimbursement id.
    */
    public String employeeReimbursementId {get;set;}
    /*******************************************************************************************************
    * @description isSelected.
    */
    public boolean isSelected {get;set;}
    /*******************************************************************************************************
    * @description Approved date.
    */
    public String approveddate {get;set;}
    /*******************************************************************************************************
    * @description status.
    */
    public String status {get;set;}
    /*******************************************************************************************************
    * @description variableRate is Employee_Reimbursement__c's Total_Variable_Rate__c.
    */
    public String variableRate {get;set;}
    /*******************************************************************************************************
    * @description month is Employee_Reimbursement__c's Month__c.
    */
    public String month {get;set;}
    /*******************************************************************************************************
    * @description intmonth is Employee_Reimbursement__c's Month__c.
    */
    public Integer intmonth {get;set;}
    /*******************************************************************************************************
    * @description year is Employee_Reimbursement__c's year.
    */
    /*public String year {get;set;}*/
    /*******************************************************************************************************
    * @description fuel is Employee_Reimbursement__c's Fuel_Price__c.
    */
    public String fuel {get;set;}
    /*******************************************************************************************************
    * @description mileage is Employee_Reimbursement__c's Total_Mileage__c.
    */
    public String mileage {get;set;}
    /*******************************************************************************************************
    * @description varibleAndFixedReimbursements is Employee_Reimbursement__c's Fixed_Amount__c + Employee_Reimbursement__c's Variable_Rate__c.
    */
    public String varibleAndFixedReimbursements {get;set;}
    /*******************************************************************************************************
    * @description totalReimbursements is Employee_Reimbursement__c's Total_Monthly_Reimbursement__c.
    */
    public String totalReimbursements {get;set;}
    /**
    @author Natavar Ghodasara
    @date 26th Feb 2019
    @description Default Constructor.
    */
    public EmployeeReimbursements() 
    {
        
    }
}