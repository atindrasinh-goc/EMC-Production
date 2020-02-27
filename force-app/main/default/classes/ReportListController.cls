/**
@author Natavar Ghodasara
@date 26th Feb 2019
@description DriverDashboardController is used to show/edit Employee details.
*/
public with sharing class ReportListController 
{
	//public static string role { get; set; }
	public ReportListController() 
	{
		
	}
	public static String getAccountid() {
		if (ApexPages.currentPage().getParameters().containsKey('accid')) {
			return ApexPages.currentPage().getParameters().get('accid');
		} else {
			return '';
		}
	}
	public static String getContactid() {
		if (ApexPages.currentPage().getParameters().containsKey('id')) {
			return ApexPages.currentPage().getParameters().get('id');
		} else {
			return '';
		}
	}
	public static PageReference getRedirected() {

		if (getContactid() != '' && getAccountid() != '') {
			return null;
		} else {
// redirect to error page
			return null;
		}

	}

	public static string getRole() {

		List<Contact> conRole = [SELECT Id, Role__c FROM Contact WHERE id =: getContactid()]; 
		string role = conRole[0].Role__c;
		return role;
	}
	public static string getAllReports()
	{	

		Map<String,List<Report_Accessibility__c>> obj_map_report_Accessibility = new Map<String,List<Report_Accessibility__c>>();
		for(Report_Accessibility__c obj_currentreportaccesibilty:[SELECT Custom_Report__r.ownerid,Custom_Report__r.Name,Custom_Report__c,Custom_Report__r.Report_Category__c FROM Report_Accessibility__c WHERE user__r.contactid=:getContactid() Order By Custom_Report__r.Report_Category__c])
		{
			if(obj_map_report_Accessibility.containsKey(obj_currentreportaccesibilty.Custom_Report__r.Report_Category__c))
			{
				
				obj_map_report_Accessibility.get(obj_currentreportaccesibilty.Custom_Report__r.Report_Category__c).add(obj_currentreportaccesibilty);	
			}
			else
			{
				List<Report_Accessibility__c> obj_Report_Accessibility_list = new List<Report_Accessibility__c>();
				obj_Report_Accessibility_list.add(obj_currentreportaccesibilty);
				obj_map_report_Accessibility.put(obj_currentreportaccesibilty.Custom_Report__r.Report_Category__c,obj_Report_Accessibility_list);	
			}
			
		}
		List<CategoryWiseReportList> obj_CategoryWiseReportList = new List<CategoryWiseReportList>();
		for(String s:obj_map_report_Accessibility.keySet())
		{
			CategoryWiseReportList obj = new CategoryWiseReportList();
			obj.categoryName = s;
			List<CategoryWiseReportList.Reports> reportsList = new List<CategoryWiseReportList.Reports>();
			for(Report_Accessibility__c r:obj_map_report_Accessibility.get(s))
			{
				CategoryWiseReportList.Reports obj_report = new CategoryWiseReportList.Reports();
				obj_report.reportId = r.Custom_Report__c;
				obj_report.reportName = r.Custom_Report__r.Name;				
				reportsList.add(obj_report);
			}
			obj.currentReports = reportsList;
			obj_CategoryWiseReportList.add(obj);
		}

		return JSON.serialize(obj_CategoryWiseReportList);		
	}
}