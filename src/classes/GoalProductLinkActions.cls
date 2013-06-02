public without sharing class GoalProductLinkActions {

	public static void deduplicateLinks(Map<Id, Goal_Product_Link__c> linksById){
		Set<String> linkKeys = new Set<String>();
		List<Goal_Product_Link__c> insertLinks = [SELECT Id, Duplication_Key__c FROM Goal_Product_Link__c WHERE Id IN :linksById.keyset()];
		for(Goal_Product_Link__c link : insertLinks){
			linkKeys.add(link.Duplication_Key__c);
		}
		
		List<Goal_Product_Link__c> allLinks = [SELECT Id, Duplication_Key__c FROM Goal_Product_Link__c WHERE Duplication_Key__c IN :linkKeys ORDER BY CreatedDate];
		Map<String, Goal_Product_Link__c> linksByKey = new Map<String, Goal_Product_Link__c>();
		List<Goal_Product_Link__c> dupeLinks = new List<Goal_Product_Link__c>();
		
		for(Goal_Product_Link__c link : allLinks){
			if(linksByKey.get(link.Duplication_Key__c) == null){
				linksByKey.put(link.Duplication_Key__c, link);
			} else {
				dupeLinks.add(link);
			}
		}
		
		delete dupeLinks;
	}

}