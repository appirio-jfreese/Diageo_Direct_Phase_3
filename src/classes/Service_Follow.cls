/*******************************************************************************
Name        : Service_Follow.cls

Updated By  : Basant Verma (Appirio Offshore)   
Date        : 6/7/13
Story/Task  : US503/TA1009
*******************************************************************************/
public with sharing class Service_Follow {
	private static Set<Id> followIds;
	
	public static void addFollow(list<ID> contentvIds){
		if(contentvIds != null && contentvIds.size() > 0){
			// If content is already following.
			getFollowIds();
			List<Id> cvIds = new List<Id>();
			for(Id cvId : contentvIds){
				if(!followIds.contains(cvId))
					cvIds.add(cvId);
			}
			
			if(cvIds.size() > 0){
				List<Content_Subscription__c> subsList = new List<Content_Subscription__c>(); 
				
				// Fetch All Documents for which we need to Create Contenet_Subscription__c
				Map<String, ContentVersion> docVersions = new Map<String, ContentVersion>();
				for(ContentVersion cv : [Select Id, ContentDocumentId, ReasonForChange 
											From ContentVersion Where Id IN : cvIds]){
					docVersions.put(cv.ContentDocumentId, cv);
				}
				
				// Create Contenet_Subscription__c
				for(String key : docVersions.keySet()){
					Content_Subscription__c sub = new Content_Subscription__c();
					sub.User__c = Service_API.getUID();
					sub.Content__c = key;
					subsList.add(sub);
				}
				
				if(subsList.size() > 0){
					insert subsList;
					
					List<Content_Change_Notification__c> ccnList = new List<Content_Change_Notification__c>();
					for(Content_Subscription__c sub : subsList){
							Content_Change_Notification__c notific = new Content_Change_Notification__c();
							notific.User__c = sub.User__c;
							notific.Content__c = sub.Content__c;
							notific.Content_Version__c = docVersions.get(sub.Content__c).Id;
							notific.Content_Subscription__c = (ID)sub.Id;
							notific.Send_Date__c = Date.today();
							ccnList.add(notific);
							followIds.add(docVersions.get(sub.Content__c).Id);
					}
					if(ccnList.size() > 0){
						insert ccnList;
					}
				}
			}
		}
	}

    
	public static Set<Id> getFollowIds(){
		if(followIds == null){
			followIds = new Set<Id>();
			for(Content_Change_Notification__c ccn : [Select Id, User__c, Content__c, 
				Content_Version__c, Content_Subscription__c 
					From Content_Change_Notification__c Where User__c = :Service_API.getUID()]){
				if(ccn.Content_Version__c != null && !ccn.Content_Version__c.trim().equals(''))
					followIds.add((Id)ccn.Content_Version__c);
			}
		} 
		return followIds;
	}
	
	public static List<Id> getFollowIdList(){
		List<Id> cvIdList = new List<Id>();
		for(Id cvId : getFollowIds()){
			cvIdList.add(cvId);
		}
		return cvIdList;
	}
       
    
	public static void removeFollow(list<ID> contentvIds){
		if(contentvIds != null && contentvIds.size() > 0){
			// If content is already following.
			getFollowIds();
			List<Id> cvIds = new List<Id>();
			for(Id cvId : contentvIds){
				if(followIds.contains(cvId))
					cvIds.add(cvId);
			}
			
			if(cvIds.size() > 0){
				List<Content_Subscription__c> subList;
				List<Content_Change_Notification__c> ccnList = new List<Content_Change_Notification__c>();
				Set<Id> subIds = new Set<Id>();
				for(Content_Change_Notification__c ccn : [Select Id, User__c, Content__c, 
					Content_Version__c, Content_Subscription__c 
						From Content_Change_Notification__c 
						Where User__c = :Service_API.getUID() AND Content_Version__c IN :cvIds ]){
					if(ccn.Content_Subscription__c != null)
						subIds.add((Id)ccn.Content_Subscription__c);
					ccnList.add(ccn);
				}
				
				subList = new List<Content_Subscription__c>([Select Id From Content_Subscription__c 
					Where User__c = :Service_API.getUID() AND Id IN :subIds]);
				
				if(ccnList.size() > 0)
					delete ccnList;
				if(subList.size() > 0)
					delete subList;
				followIds.removeAll(cvIds);
			}
		}
	}
	
	
	public static Integer getNumberOfItems(){
		Set<Id> contentIds = Service_Follow.getFollowIds();
		return contentIds.size();
	} 
    
}