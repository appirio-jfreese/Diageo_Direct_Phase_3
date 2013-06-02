public with sharing class Controller_Init {

	public User u {public get; private set;}
	public String startUrlPage {public get; private set;}
	
    public Controller_Init() {
    	try {
	    	u = [SELECT Id FROM User WHERE id = :Service_API.getUID()];
	    	startUrlPage = Page.HomePage.getUrl();
		} catch (Exception e){
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to login.' ));
		}    	    	
    }
    
    public PageReference initEnvironment(){
		try {
	    	// set last login date
	        u.loginDate__c = dateTime.now();
	        update u; 
	                       
			// prepare site theme after login
	       	Service_API.prepareSiteThemeAfterLogin(u.id);
			
	    	PageReference pr = new Pagereference(startUrlPage);
	    	return pr;
		} catch (Exception e){
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to login.' ));
			return null;
		}    	    	

    }
    
}