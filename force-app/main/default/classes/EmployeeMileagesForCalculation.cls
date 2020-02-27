public with sharing class EmployeeMileagesForCalculation {

    public String reimbursementid {get;set;}
    public String mileageid {get;set;}
    public String contactid {get;set;}
    public String name {get;set;}
    public String month {get;set;}
    public String threshold {get;set;}
    public String totalMileages {get;set;}
    public List<EmployeeMileages> mileagesList {get;set;}
    public String approvedMileages {get;set;}
//  public String status {get;set;}
//  public String approvedDate {get;set;}   
    public Boolean isSelected {get;set;}
    public List<String> reimbursementIdList {get;set;}
    public String managerName{get;set;}
    public Boolean isSelectedEmailReminder {get;set;}
    public EmployeeMileagesForCalculation() {
        
    }
}