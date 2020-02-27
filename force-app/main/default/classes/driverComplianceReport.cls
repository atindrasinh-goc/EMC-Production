public with sharing class driverComplianceReport 
{
    public Date currentdate {get;set;}

    public Double TotalActualReimbursements {get;set;}
    public Double MaximumAllowable{get;set;}
    public Double AnnualTaxLiability{get;set;}
    public Decimal totalmileages  {get;set;}

    public List<wrapperTaxReport> obj_wrapperTaxReport {get;set;}
    public List<String> listofmonths {get;set;}

    public List<IRS_Mileage_Rate__c> irsrate {get;set;}
    public Map<String,Double> obj_irsrate {get;set;}
    public Map<String,Contact> obj_contact_map{get;set;}
     
    public driverComplianceReport() 
    {
        
        
        List<String> obj_date = Label.dateofIRS.split('-');
        currentdate = date.newinstance(Integer.valueOf(obj_date[2]),Integer.valueOf(obj_date[1]), Integer.valueOf(obj_date[0]));

        listofmonths = new List<String>();
        List<String> listcomplincemonth =  new List<String>();
        obj_wrapperTaxReport = new List<wrapperTaxReport>();

        irsrate = new List<IRS_Mileage_Rate__c>();
        obj_irsrate = new Map<String,Double>();
        obj_contact_map = new Map<String,Contact>();

        if(currentdate.month()!=12)
        {
            listofmonths.add(String.valueOf((currentdate.year())-1));             
        }
        listofmonths.add(String.valueOf(currentdate.year()));

        Integer month = currentdate.month();
        if(month==12)
        {
          listcomplincemonth.add(String.valueOf(month)+'-'+currentdate.year());              
        }
        else
        {
            listcomplincemonth.add(String.valueOf(12)+'-'+(currentdate.year()-1));
            for(Integer i=1;i<=month;i++)
            {
                if(i<10)
                {
                    listcomplincemonth.add('0'+String.valueOf(i)+'-'+currentdate.year()); 
                } 
                else if((i==10)||(i==11))
                {
                    listcomplincemonth.add(String.valueOf(i)+'-'+(currentdate.year()));
                }          
            }
        }
        irsrate = [select id,year__c,IRS_Rate__c from IRS_Mileage_Rate__c where year__c =: listofmonths];
        for(IRS_Mileage_Rate__c rate:irsrate)
        {
            obj_irsrate.put(rate.year__c,Double.valueOf(rate.IRS_Rate__c));
        }
        getComplianceContacts(listcomplincemonth);

    }
    public void getComplianceContacts(List<String> listcomplincemonth)
    {
        System.debug('listcomplincemonth'+listcomplincemonth);
        List<Contact> obj_contact = new List<Contact>();
        obj_contact = [SELECT id, compliancestatus__c, Name, Employee_ID__c, External_Email__c FROM Contact WHERE (compliancestatus__c ='Yes') and Account.Name='Delta' and (Role__c =: StaticValues.roleAdminDriver OR Role__c='Driver' OR Role__c='Driver/Manager')];
        List<ID> obj_list_id = new List<ID>();
        for(Contact c:obj_contact)
        {
            obj_list_id.add(c.id);
            if(!obj_contact_map.containsKey(c.id))
            {
                obj_contact_map.put(c.id,c);    
            }
        }
        List<Employee_Reimbursement__c> listEmployeeReimbursement= new List<Employee_Reimbursement__c>();
        listEmployeeReimbursement=[SELECT id, Total_Mileage__c, Total_Monthly_Reimbursement__c, Contact_Id__c, Contact_Id__r.Name,
                                            Contact_Id__r.Employee_ID__c, Contact_Id__r.External_Email__c, Month__c,Approved_Date__c  
                                        FROM Employee_Reimbursement__c 
                                        WHERE Contact_Id__c =: obj_list_id AND Month__c =: listcomplincemonth AND Approved_Date__c != null];
        Map<String,List<Employee_Reimbursement__c>> obj_map_Employee_Reimbursement = new Map<String,List<Employee_Reimbursement__c>>();
        for(Employee_Reimbursement__c e:listEmployeeReimbursement)
        {
            if(obj_map_Employee_Reimbursement.containsKey(e.Contact_Id__c))
            {
                obj_map_Employee_Reimbursement.get(e.Contact_Id__c).add(e);
            }
            else
            {
                obj_map_Employee_Reimbursement.put(e.Contact_Id__c, new List<Employee_Reimbursement__c> {e});
            }
        }
        System.Debug(obj_map_Employee_Reimbursement);
        if(obj_map_Employee_Reimbursement.size()>0)
        {
            obj_wrapperTaxReport = complianceStatus(obj_map_Employee_Reimbursement);
        }

    }
    public List<wrapperTaxReport> complianceStatus(Map<String,List<Employee_Reimbursement__c>> obj_map_Employee_Reimbursement)
    {
        List<wrapperTaxReport> obj_ListwrapperTaxReport = new List<wrapperTaxReport>();
        for(String s:obj_map_Employee_Reimbursement.keySet())
        {
            List<String> months = new List<String>();
            if(obj_map_Employee_Reimbursement.get(s).size()>0)
            {
                totalmileages =0;
                TotalActualReimbursements=0;
                MaximumAllowable=0;
                AnnualTaxLiability=0;

                for(Employee_Reimbursement__c obj:obj_map_Employee_Reimbursement.get(s))
                {
                    if((obj.Month__c!=null)&&(obj.Month__c.contains('-')))
                    {
                        months = obj.Month__c.split('-');

                        /*wrapperTaxReport objw = new wrapperTaxReport();
                        objw.drivername = obj.Contact_Id__r.Name;
                        objw.employeeid =obj.Contact_Id__r.Employee_ID__c;
                        objw.emailid = obj.Contact_Id__r.External_Email__c;*/
                        if(months.size()>0)
                        {
                            if(obj.Total_Mileage__c!=null)
                            {
                              totalmileages = totalmileages +  obj.Total_Mileage__c.setScale(2);
                            }
                            
                            if(obj.Total_Monthly_Reimbursement__c!=null)
                            {
                                TotalActualReimbursements = TotalActualReimbursements + obj.Total_Monthly_Reimbursement__c.setScale(2);
                            }
                            
                            if((obj.Total_Mileage__c!=null)&&(obj_irsrate.containsKey(String.valueOf(months[1]))))
                            {
                                MaximumAllowable = MaximumAllowable + (((obj.Total_Mileage__c.setScale(2))*(obj_irsrate.get(String.valueOf(months[1])))));
                            }                      
                            if((obj.Total_Monthly_Reimbursement__c !=null)&&(obj.Total_Mileage__c!=null)&&(obj_irsrate.containsKey(String.valueOf(months[1]))))
                            {
                                AnnualTaxLiability=AnnualTaxLiability + ((obj.Total_Monthly_Reimbursement__c.setScale(2))-((obj.Total_Mileage__c.setScale(2))*obj_irsrate.get(String.valueOf(months[1]))));
                            } 
                            System.Debug(AnnualTaxLiability);   
                        }
                        
                       /* objw.month =Integer.valueOf(months[0]);
                        objw.year =String.valueOf(months[1]);*/
                    }
                }
                
                if(obj_contact_map.containsKey(s))
                {
                    wrapperTaxReport objw = new wrapperTaxReport();
                    objw.drivername = obj_contact_map.get(s).Name;
                    objw.employeeid =obj_contact_map.get(s).Employee_ID__c;
                    objw.emailid = obj_contact_map.get(s).External_Email__c;
                    objw.imputedincome = Decimal.valueOf(AnnualTaxLiability).setScale(2);
                    obj_ListwrapperTaxReport.add(objw);
                }
            }           

        }
        return obj_ListwrapperTaxReport;
    }
    public class wrapperTaxReport
    {
        public String drivername {get;set;}
        public String employeeid {get;set;}
        public String emailid {get;set;}
        public Double approvedmileages {get;set;}
        public Double totalreim {get;set;}
        public Double iRSallowable {get;set;}
        public Double imputedincome {get;set;}
        public Integer month {get;set;}
        public String year {get;set;}
        public wrapperTaxReport()
        {
    
        }
    }
}