/*************************************************************************************
 * Created by Matt Lamb (Appirio) as a prototype / POC for 
 *************************************************************************************/
trigger APPIRIO_ContentVersionTrigger on ContentVersion (after insert) {

    Map<Id, ContentVersion> cvIdToCVMap = new Map<Id, ContentVersion>();
    Map<Id, String> cdIdToChangeReasonMap = new Map<Id, String>();
    Set<Id> contentDocumentIds = new Set<Id>();
    List<Content_Change_Notification__c> changeNotifications = new List<Content_Change_Notification__c>();
    
    //For all the Versions that were just inserted, grab a unique list of their parent Documents
    for(ContentVersion cv : Trigger.new) {      
        contentDocumentIds.add(cv.ContentDocumentId);
        cvIdToCVMap.put(cv.Id, cv);
        cdIdToChangeReasonMap.put(cv.ContentDocumentId, cv.ReasonForChange);
    }
    
    //For all the related Documents, go find all their Subscriptions
    List<Content_Subscription__c> contentSubs; 
    contentSubs = new List<Content_Subscription__c>([SELECT Id, User__c, Content__c
                                                     FROM Content_Subscription__c
                                                     WHERE Content__c IN : contentDocumentIds]);
                                                     
    Content_Change_Notification__c ccn;
    for(Content_Subscription__c contentSub : contentSubs) {
        ccn = new Content_Change_Notification__c();
        ccn.User__c = contentSub.User__c;
        ccn.Content__c = contentSub.Content__c;
        ccn.Change_Description__c = cdIdToChangeReasonMap.get(contentSub.Content__c);
        changeNotifications.add(ccn);
    }
    
    if(changeNotifications.size() > 0) {
        insert changeNotifications;
    }
}