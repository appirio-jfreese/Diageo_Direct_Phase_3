trigger GoalProductLinkTrigger on Goal_Product_Link__c (before insert, before update, after insert, after update, after delete) {
	
	if (trigger.isBefore) {
		if (trigger.isInsert) {
		}
		
		if (trigger.isUpdate) {
		}
	}
	
	if (trigger.isAfter) {
		if (trigger.isInsert) {
			GoalProductLinkActions.deduplicateLinks(trigger.newMap);
		}
		
		if (trigger.isUpdate) {
		}
		
		if (trigger.isDelete){
		}
	}
	
}