/*******************************************************************************
Name        : ContentVersionTriggerHandler.cls

Updated By  : Basant Verma (Appirio Offshore)   
Date        : 6/5/13
Story/Task  : US79/TA1001
Description	: Handler Class for ContentVersionTrigger.trigger
*******************************************************************************/
public with sharing class ContentVersionTriggerHandler {
	// This method called from ContentVersionTrigger on After Insert
	public static void onAfterInsert(Map<ID, ContentVersion> newRecordsMap){
		// Create Content Notification Records
		createContentNotifications(newRecordsMap);
	}
	
	private static void createContentNotifications(Map<ID, ContentVersion> newRecordsMap){
		// Fetch All Parent Content Documnet's Id
		Map<String, String> versionContentMap = new Map<String, String>();
		for(String cvId : newRecordsMap.keySet()){
			versionContentMap.put(newRecordsMap.get(cvId).ContentDocumentId, cvId);
		}
		system.debug('=============== versionContentMap : '+versionContentMap);	
		
		// Set of user ids
		Set<String> userIds = new Set<String>();
		
		// Fetch All Content Subscriptions Records
		List<Content_Subscription__c> subscrips = [SELECT Id, User__c, 
												   User__r.Content_Notification_Frequency__c,
												   Content__c 
				FROM Content_Subscription__c WHERE Content__c IN :versionContentMap.keySet()];
		system.debug('=============== subscrips : '+subscrips);		
		// Created New Notification Records 
		List<Content_Change_Notification__c> notifications = new List<Content_Change_Notification__c>();
		for(Content_Subscription__c sub : subscrips){
			Content_Change_Notification__c notific = new Content_Change_Notification__c();
			notific.User__c = sub.User__c;
			notific.Content__c = sub.Content__c;
			notific.Content_Version__c = versionContentMap.get(sub.Content__c);
			notific.Content_Subscription__c = (ID)sub.Id;
			notific.Send_Date__c = Date.today();
			system.debug('=============== notific : '+notific);
			notifications.add(notific);
			if(sub.User__r.Content_Notification_Frequency__c == 'Real Time'){
				userIds.add(sub.User__c);
			}
		}
		
		// Insert Notification Records
		if(notifications.size() > 0){
			insert notifications;
			Set<String> notificationIds = new Set<String>();
			for(Content_Change_Notification__c notification : notifications){
				notificationIds.add(notification.id);
			}
			
			// Call future method to send real time notifications
			if(userIds.size() > 0){
				sendRealTimeNotifications(userIds, notificationIds);
			}
		}
	}
	
	/**************************************************************
     // @future interface to send real time notifications
    **************************************************************/
    @future
    public static void sendRealTimeNotifications(Set<String> userIds, Set<String> notificationIds){
        system.debug('=======Future Method to send real time users====='+userIds);
        system.debug('=======Future Method to send real time notifications====='+notificationIds);
        Date dt = Date.today();
        String queryStr = 'Select id, email, Content_Notification_Frequency__c,'
        			+ ' (Select id, User__c,'
        			+ ' Content__c,'
        			+ ' Content_Version__c, '
    				+ ' Content_Subscription__c, Change_Description__c, Send_Date__c,'
        			+ ' Status__c, Error_Message__c'
        			+ ' from Content_Change_Notifications__r'
        			+ ' where Status__c = \'Pending\''
        			+ ' and Send_Date__c <= : dt and id in : notificationIds)' 
        			+ ' from user'
        			+ ' where id in : userIds';
        List<sObject> scope = Database.query(queryStr);
        BatchContentChangeNotification.processUnsentNotifications(scope);
    }
	
}