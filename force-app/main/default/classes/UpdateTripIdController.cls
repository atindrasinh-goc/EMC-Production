public class UpdateTripIdController {
    public string accId {get;set;}
    public Account acc {get;set;}
    public string errorMessage {get;set;}
    public Map<String,Contact> contactMap{get;set;}
    public UpdateTripIdController(ApexPages.StandardController stdController) {     
        accId = ApexPages.currentPage().getParameters().get('id');
        if (!Test.isRunningTest()){
            stdController.addFields(new List<String>{'Triplog_API__c', 'isUsingTriplog__c'}); 
        }       
        acc = (Account)stdController.getRecord();
       
		if(acc.Triplog_API__c == null && acc.isUsingTriplog__c == false){
            errorMessage = System.label.UpdateTripIdError;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,errorMessage));
        }
    }

    public pagereference backMethod()
    {
        Pagereference pg =  new Pagereference('/'+accId);        
        pg.setRedirect(true);
        return pg;
    }

    public void tripUserUpdatebatch()
    {
        contactMap = new Map<String,Contact>();
        List<Contact> conList = new List<Contact>();
        for(Contact currentContact : [Select id,Name,Triplog_UserID__c,External_Email__c,Deactivated_Date__c From Contact Where Account.id =: accId and (Role__c = 'Driver' or Role__c = 'Driver/Manager'or Role__c =: StaticValues.roleAdminDriver )])
        {
            contactMap.put(currentContact.External_Email__c.toLowerCase(),currentContact);
        }

        if(acc.Triplog_API__c != null && acc.isUsingTriplog__c == true && contactMap.size()>0){            
            TriplogUserIdUpdateBatch tripUserUpdate = new TriplogUserIdUpdateBatch(accId,acc.Triplog_API__c,contactMap);
            database.executebatch(tripUserUpdate,1);                      
        }       
    }
}