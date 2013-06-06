/*****************************************************************************
 * Name           : BatchContentChangeNotification
 * Created On     : June 6, 2013
 * Created By     : Parul Gupta(Appirio Offshore)
 * Task Number    : TA1000
 * Implementation : Batch job to send unsent Content Change Notifications.
******************************************************************************/
global class BatchContentChangeNotification implements Database.Batchable<sObject>, Schedulable{
    
    // Holds the query string.
    public String queryStr;
    
    // Holds the boolean value to acknowledge user that batch job is completed
    public boolean sendAckEmail = false;
    
    // Initializes the query with QueryLocator.
    global Database.QueryLocator start(Database.BatchableContext BC){       
        System.debug('BatchContentChangeNotification :: Batch Process start()');
        Date dt = Date.today();
        queryStr = 'Select id, email, Content_Notification_Frequency__c,'
        			+ ' (Select id, User__c,'
        			+ ' Content__c,'
        			+ ' Content_Version__c,'
    				+ ' Content_Subscription__c, Change_Description__c, Send_Date__c,'
        			+ ' Status__c, Error_Message__c'
        			+ ' from Content_Change_Notifications__r'
        			+ ' where Status__c = \'Pending\''
        			+ ' and Send_Date__c < : dt )' 
        			+ ' from user'
        			+ ' where Content_Notification_Frequency__c = \'Daily\''
        			+ ' or Content_Notification_Frequency__c = \'Weekly\'';
              			
        system.debug('Query Str :: ' + queryStr);       
        return Database.getQueryLocator(queryStr);
    }
    
    // Processes the list of objects.
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('BatchContentChangeNotification :: Batch Process execute()'); 
        System.debug('Batch size ::::::::::::::::::: ' + scope.size());
        processUnsentNotifications(scope);
    }
    
    // Method sends print requests for posting on server and updates status field
    global void processUnsentNotifications(List<sObject> scope){
        System.debug('processUnsentNotifications :::::::::::::::::::'+scope);
        
        // List of email messages 
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
		
		// List of content change notifications
		List<Content_Change_Notification__c> changeNotificaitons 
        				= new List<Content_Change_Notification__c>();
							
		// Get content documents
        Map<Id, ContentDocument> contentDocumentMap = getContentDocuments(scope);
        
        // Get unsent email messages
        emailMessages = getEmailMessages(scope, contentDocumentMap, changeNotificaitons);  
        
        if(emailMessages.size() > 0){
	        try{
	        	system.debug('========emailMessages================'+emailMessages);
	        	// Send email messages
	        	Messaging.sendEmail(emailMessages);	
	        	
	        	// If successfully sent, update status = 'Sent'
	        	for(Content_Change_Notification__c changeNotification : changeNotificaitons){
	        		changeNotification.status__c = 'Sent';
	        	}			
			}
			catch (Exception e) {
				system.debug('BatchContentChangeNotification :: Failed to send emails ' + e);
				
				// If exception occurs, update status = 'Error'
				for(Content_Change_Notification__c changeNotification : changeNotificaitons){
	        		changeNotification.status__c = 'Error';
	        		changeNotification.Error_Message__c = e.getMessage();
	        	}
			}
			system.debug('========changeNotifications================'+changeNotificaitons);
			update changeNotificaitons; 
        }       
    }
                 
    // Completes the batch process.
    global void finish(Database.BatchableContext BC) {
       
        // Add logging information
        System.debug('Process Completed');
         // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                          from AsyncApexJob 
                          where Id = :BC.getJobId()];
        
        if(sendAckEmail) {
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('BatchContentChangeNotification status :: ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
        System.debug('Batch :: BatchContentChangeNotification status :: ' + a.Status);
        System.debug('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
    }
    
    /*********************************************************************
    // Method returns content document map
    *********************************************************************/
    private static Map<Id, ContentDocument> getContentDocuments(List<sObject> scope){
    	Set<Id> contentDocumentIds = new Set<Id>(); 
    	User user;
    	for(sObject obj : scope){
        	user = (User)obj;
        	for(Content_Change_Notification__c changeNotification : user.Content_Change_Notifications__r){
	        	contentDocumentIds.add(changeNotification.Content__c);
        	}
        }
        Map<Id, ContentDocument> contentDocumentMap 
        	= new Map<Id, ContentDocument>([Select id, title from ContentDocument 
        										where id in : contentDocumentIds]);
    	system.debug('========contentDocumentMap================'+contentDocumentMap);
    	return contentDocumentMap;
    }
    
    /*********************************************************************
    // Method returns unsent email messages list
    *********************************************************************/
    private static List<Messaging.SingleEmailMessage> getEmailMessages(List<sObject> scope, 
    					Map<Id, ContentDocument> contentDocumentMap,
    					List<Content_Change_Notification__c> changeNotificaitons){
        List<Messaging.SingleEmailMessage> unsentEmailMessages = new List<Messaging.SingleEmailMessage>();
    	User user;
        String notificationStr;
        String notificationHtmlStr;   
        Messaging.SingleEmailMessage mail;        
        DateTime todayDT = (DateTime)Date.today();
		String dayOfWeek = todayDT.format('E');
        system.debug('===dayOfWeek========='+dayOfWeek);
        
        // Get sender email	
		User sender;
		for(User currentUser : [select id, Email, Name from User where Id = :Service_API.getUID()]){
			sender = currentUser;
		}
        
        // Iterage through each user and create email message for each user contianing
        // list of change notifications
        for(sObject obj : scope){
        	user = (User)obj; 
        	if((user.Content_Notification_Frequency__c == 'Daily'
        	|| dayOfWeek == 'Sun')
        	&& user.Content_Change_Notifications__r.size() > 0) {     	      	
        		mail = new Messaging.SingleEmailMessage();				
				notificationStr = '';	
				notificationHtmlStr = '';		
	        	for(Content_Change_Notification__c changeNotification : user.Content_Change_Notifications__r){
	        		
	        		if(notificationStr == ''){
	        			notificationStr = '\n\n' + contentDocumentMap.get(changeNotification.Content__c).title;
	        			notificationHtmlStr += '\n\n<a href="https://cs10.salesforce.com/'+ changeNotification.Content__c + '">' 
	        				+ contentDocumentMap.get(changeNotification.Content__c).title + '</a>';
	        		}else{
	        			notificationStr = '\n' + contentDocumentMap.get(changeNotification.Content__c).title;
	        			notificationHtmlStr += '\n' + '<a href="https://cs10.salesforce.com/'+ changeNotification.Content__c + '">' 
	        				+ contentDocumentMap.get(changeNotification.Content__c).title + '</a>';
	        		}
	        		changeNotificaitons.add(changeNotification);
	        	} 
	        	populateEmailParameters(mail, user, sender, notificationStr, notificationHtmlStr);	        	
	        	unsentEmailMessages.add(mail);      	
        	}                   	
        }
        return unsentEmailMessages;
    }
    
    /*********************************************************************
    // Method populates email parameters
    *********************************************************************/
    private static void populateEmailParameters(Messaging.SingleEmailMessage mail,
    											User receiver, User sender,
    											String notificationStr,
    											String notificationHtmlStr){
    	// Email Subject and pre plain body
		String subject = 'Diageo Direct Content Update Status';
		String prePlainBody = 'The following contents has been updated.'
							+ 'Click on the link to open the content. \n';
							
    	mail.setToAddresses(new List<String>{'parulgupta2709@gmail.com'});				
		mail.setReplyTo(sender.email);
		mail.setSubject(subject);
		mail.setTargetObjectId(receiver.id);
		mail.setSenderDisplayName(sender.Name);
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setSaveAsActivity(false);
		mail.setPlainTextBody(prePlainBody + notificationStr);
	    notificationHtmlStr = notificationHtmlStr.replaceAll('\n','<br/>');
	    mail.setHtmlBody(prePlainBody + notificationHtmlStr);
    }
    
    // Execute method for schedulable context.
    global void execute(SchedulableContext SC) {
      
        System.debug('In SchedulableContext :::::::: ');
        
        ID batchprocessid = Database.executeBatch(this);        
        
        System.debug('batchprocessid ::::: ' + batchprocessid);
        
        ID scheduledJobId = SC.getTriggerID();
        
        System.debug('scheduledJobId ::::: ' + scheduledJobId);
   }
}