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
        			+ ' Content_Version__c, '
    				+ ' Content_Subscription__c, Change_Description__c, Send_Date__c,'
        			+ ' Status__c, Error_Message__c'
        			+ ' from Content_Change_Notifications__r'
        			+ ' where Status__c = \'Pending\''
        			+ ' and Send_Date__c < : dt order by createddate desc limit 50)' 
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
        processNotifications(scope);
    }
    
    // Method sends print requests for posting on server and updates status field
    global void processNotifications(List<sObject> scope){
        System.debug('processUnsentNotifications :::::::::::::::::::'+scope);
        
        // Process unsent notifications
        processUnsentNotifications(scope);
       
        // Delete sent notifications
		deleteSentNotifications();      
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
    // Method processes pending/unsent notifications
    *********************************************************************/
    public static void processUnsentNotifications(List<sObject> scope){
    	
    	 // List of email messages 
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
		
		// List of content change notifications
		List<Content_Change_Notification__c> changeNotifications 
        				= new List<Content_Change_Notification__c>();
							
		// Get latest content versions
        Map<id, ContentVersion> contentVersionMap = getContentVersions(scope);
        
        // Get unsent email messages
        emailMessages = getEmailMessages(scope, changeNotifications, contentVersionMap);  
        
        if(emailMessages.size() > 0){
	        try{
	        	system.debug('========emailMessages================'+emailMessages);
	        	// Send email messages
	        	Messaging.sendEmail(emailMessages);	
	        	
	        	// If successfully sent, update status = 'Sent'
	        	for(Content_Change_Notification__c changeNotification : changeNotifications){
	        		changeNotification.status__c = 'Sent';
	        	}			
			}
			catch (Exception e) {
				system.debug('BatchContentChangeNotification :: Failed to send emails ' + e);
				
				// If exception occurs, update status = 'Error'
				for(Content_Change_Notification__c changeNotification : changeNotifications){
	        		changeNotification.status__c = 'Error';
	        		changeNotification.Error_Message__c = e.getMessage();
	        	}
			}
			system.debug('========changeNotifications================'+changeNotifications);
			
			// Update notifications
			update changeNotifications; 					
        } 
    }
    
    /*********************************************************************
    // Method returns content document map
    *********************************************************************/
    private static Map<Id, ContentVersion> getContentVersions(List<sObject> scope){
    	Set<Id> contentVersionIds = new Set<Id>(); 
    	User user;
    	for(sObject obj : scope){
        	user = (User)obj;
        	for(Content_Change_Notification__c changeNotification : user.Content_Change_Notifications__r){
	        	contentVersionIds.add(changeNotification.Content_Version__c);
        	}
        }
        Map<Id, ContentVersion> contentVersionMap 
        	= new Map<Id, ContentVersion>([Select id, title, ReasonForChange from ContentVersion 
        										where id in : contentVersionIds]);
    	system.debug('========contentVersionMap================'+contentVersionMap);
    	return contentVersionMap;
    }
    
    
    /*********************************************************************
    // Method returns unsent email messages list
    *********************************************************************/
    private static List<Messaging.SingleEmailMessage> getEmailMessages(List<sObject> scope, 
    					List<Content_Change_Notification__c> changeNotificaitons,
    					Map<Id, ContentVersion> contentVersionMap){
        List<Messaging.SingleEmailMessage> unsentEmailMessages = new List<Messaging.SingleEmailMessage>();
    	User user;
        String notificationStr;
        String notificationHtmlStr;   
        Messaging.SingleEmailMessage mail;        
        DateTime todayDT = (DateTime)Date.today();
		String dayOfWeek = todayDT.format('E');
		String changeDesc = '';
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
        	|| (user.Content_Notification_Frequency__c == 'Weekly' 
        		&& dayOfWeek == 'Sun')
        	|| user.Content_Notification_Frequency__c == 'Real Time')
        	&& user.Content_Change_Notifications__r.size() > 0) {     	      	
        		mail = new Messaging.SingleEmailMessage();				
				notificationStr = '';	
				notificationHtmlStr = '';
				changeDesc = '';		
	        	for(Content_Change_Notification__c changeNotification : user.Content_Change_Notifications__r){
	        		if(changeNotification.content_Version__c != null 
	        		&& contentVersionMap.get(changeNotification.content_Version__c) != null){
	        			if(contentVersionMap.get(changeNotification.content_Version__c).ReasonForChange != null){
	        				changeDesc = contentVersionMap.get(changeNotification.content_Version__c).ReasonForChange;
	        			}
		        		system.debug('====reasonForChange========'+contentVersionMap.get(changeNotification.content_Version__c).ReasonForChange);
		        		if(notificationStr == ''){
		        			notificationStr = '\n\n' + contentVersionMap.get(changeNotification.content_Version__c).title
		        							+ ' - ' + changeDesc;
		        			notificationHtmlStr += '\n\n<a href="https://cs10.salesforce.com/'+ changeNotification.Content__c + '">' 
		        				+ contentVersionMap.get(changeNotification.content_Version__c).title + '</a>'
		        				+ ' - ' + changeDesc;
		        		}else{
		        			notificationStr = '\n' + contentVersionMap.get(changeNotification.content_Version__c).title
		        							+ ' - ' + changeDesc;
		        			notificationHtmlStr += '\n' + '<a href="https://cs10.salesforce.com/'+ changeNotification.Content__c + '">' 
		        				+ contentVersionMap.get(changeNotification.content_Version__c).title + '</a>'
		        				+ ' - ' + changeDesc;
		        		}
		        		changeNotificaitons.add(changeNotification);
	        		}
	        	} 
	        	if(notificationStr != '' && notificationHtmlStr != ''){
		        	populateEmailParameters(mail, user, sender, notificationStr, notificationHtmlStr);	        	
		        	unsentEmailMessages.add(mail); 
	        	}     	
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
		String subject = 'Diageo Direct Content ' + user.Content_Notification_Frequency__c +  ' Status Update';
		String prePlainBody = 'The following contents has been updated.'
							+ 'Click on the link to open the content. \n';
							
    	mail.setToAddresses(new List<String>{receiver.email});				
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
    
    /*********************************************************************
    // Method deletes sent notifications which are created before 
    // the period of time specified in custom setting.
    *********************************************************************/
    private static void deleteSentNotifications(){
    	
    	// Get threashold month value
        Content_Notification__c notificationSetting = Content_Notification__c.getOrgDefaults();
        if(notificationSetting != null 
        && notificationSetting.Delete_Sent_Notification_Threshhold__c != null){
	    	Date dateToCompare 
	    	= system.today().addMonths(Integer.valueOf(notificationSetting.Delete_Sent_Notification_Threshhold__c));
	    	
	    	// Get all sent notifications before threshold date
			List<Content_Change_Notification__c> sentNotifications 
	        			= [Select id from Content_Change_Notification__c
	        				where status__c = 'Sent' 
	        				and createdDate < : dateToCompare];
	        				
	        // Delete sent notifications
	        if(sentNotifications.size() > 0){
	        	delete sentNotifications;
	        }
        }
    	
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