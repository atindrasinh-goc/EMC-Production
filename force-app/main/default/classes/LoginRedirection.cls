public with sharing class LoginRedirection 
{
    
    public LoginRedirection() 
    {
        

    }
    public PageReference redirectOnPage()
    {
        User u = new User();

        u = [select id,Profile.Name,contactid,contact.showTeamRecord__c,contact.Accountid from user where id=:userinfo.getuserid()];
        
        
        if(u!=null)
        {   
            if(u.Profile.Name == 'Customer Community Login User - Manager')
            {
                PageReference pageRef = new PageReference('/app/managerdashboard?accid='+u.contact.Accountid+'&id='+u.contactid+'&showteam='+String.valueOf(u.contact.showTeamRecord__c));
                return pageRef;
            } 
            else if(u.Profile.Name == 'Customer Community Login User - Super Manager')
            {
                PageReference pageRef = new PageReference('/app/admindashboard?accid='+u.contact.Accountid+'&id='+u.contactid+'&showteam='+String.valueOf(u.contact.showTeamRecord__c));
                return pageRef;
            }
            else if(u.Profile.Name == 'Customer Community Login User - Driver')
            {
                PageReference pageRef = new PageReference('/app/driverDashboardClone?accid='+u.contact.Accountid+'&id='+u.contactid);
                return pageRef;
            }
            else if(u.Profile.Name == 'Customer Community Login User - Manager/Driver')
            {
                PageReference pageRef = new PageReference('/app/drivermanagerdashboard?accid='+u.contact.Accountid+'&id='+u.contactid+'&showteam='+String.valueOf(u.contact.showTeamRecord__c));
                return pageRef;
            }
            else if(u.Profile.Name == 'Customer Community Login User - Super Manager/Driver')
            {
                PageReference pageRef = new PageReference('/app/admindriverdashboard?accid='+u.contact.Accountid+'&id='+u.contactid+'&showteam='+String.valueOf(u.contact.showTeamRecord__c)+'&admindriver=true');
                return pageRef;
            }
            
        }
    //  PageReference pageRef = new PageReference();
        return null;
    }
}