public with sharing class adminLoginController {
    public static String username {get;set;}
    public static String password {get;set;}
    public static Boolean popup {get;set;}
    static Integer invalidUsernameCount;
    public static Boolean isUsernameInvalid {get;set;}
    public static Boolean isLimitExeeded {get;set;}
    public static Boolean isPasswordInvalid {get;set;}

    public adminLoginController() {
        popup = false;
        invalidUsernameCount = 0;
        String param = ApexPages.currentPage().getParameters().get('param1');
        if ('true'.Equals(param)) {
            popup= true;
        }
    }

    public static PageReference login() {
        isUsernameInvalid = false;
        isLimitExeeded = false;
        isPasswordInvalid = false;
        PageReference pgRef = Site.login(username, password, null);
        Boolean isValidUsername =false;
        vaidationforwrapper valWrappObj = validateUsername(username);
        isValidUsername = valWrappObj.isValid;
        String userid = valWrappObj.id;
        if(!isValidUsername && invalidUsernameCount < 3) {
            invalidUsernameCount++;
            isUsernameInvalid = true;
            isPasswordInvalid = false;
            pgRef = null;
        }
        if(!isValidUsername && invalidUsernameCount >= 3) {
            isLimitExeeded = true;
            isUsernameInvalid = false;
            isPasswordInvalid = false;
        }
        if(isValidUsername && pgRef == null) {
            isPasswordInvalid = true;
            isLimitExeeded = false;
            isUsernameInvalid = false;
        }
        return pgRef;
    }

    public PageReference redirectToMyVF() {	
        PageReference myVFPage = new PageReference('/app/ForgotPasswordNewUI');
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    
    public static vaidationforwrapper validateUsername(String username) {
        
        vaidationforwrapper valWrappObj = new vaidationforwrapper();
        List<User> users = new List<User>([SELECT Id, Email,ContactID FROM User WHERE Email =: username limit 1]);
        if(!users.isEmpty()) {
            valWrappObj.Id = users[0].Id;
            valWrappObj.isValid = true;
        } else {
            valWrappObj.isValid = false;
        }
        return valWrappObj;
    }

    public class vaidationforwrapper{
        public String id        {get; set;}
        public Boolean isValid  {get; set;}  
    }
}