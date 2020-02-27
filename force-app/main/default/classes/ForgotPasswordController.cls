/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}
    public String userID {get; set;}
    public boolean displayPopup {get; set;}
    string value = 'true';
    string url;

    /**
    * Constructor
    */  
    public ForgotPasswordController() {
        displayPopup = false;
    }

    /**
    * Check UserName in community regarding forgot password
    */

    public void checkUserNameForCommunity(){
        if(username != null && username != ''){
            User userObj = [Select Id, Name, Profile.Name From User where Email =: username  OR Username =: username Limit 1];
            userID = userObj.Id;
            if(userObj != null){
                displayPopup = true;
            }
        } else{
            displayPopup = false;
        }
    }
    
    /**
    * reset password for community
    */
    
    public PageReference resetPasswordForCommunity() {
        //boolean success = Site.forgotPassword(username);

        System.ResetPasswordResult currectUserResult = System.resetPassword(userID, true);   
        url = '/app/adminlogin?param1=' + value;
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        return pr;
    }
    
     public PageReference resetPassword() {
        boolean success = Site.forgotPassword(username);
        //PageReference pr = Page.ForgotPasswordConfirm;
        url = '/Comm/RG_CommunitiesLogin?param1=' + value;
        //PageReference pr = Page.RG_Login;
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        
        if (success) {
            return pr;
        }
        return null;
    }
}