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
		
		// Fetch All Content Subscriptions Records
		List<Content_Subscription__c> subscrips = [SELECT Id, User__c, Content__c 
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
		}
		
		// Insert Notification Records
		if(notifications.size() > 0)
			insert notifications;
	}
	
}