trigger AccountTrigger on Account (before insert, before update) {
	
	if(trigger.isInsert){
		AccountActions.updateRecordTypes(trigger.new);
		AccountActions.checkNabcaTerritory(trigger.new);
	} else if(trigger.isUpdate){
		AccountActions.updateRecordTypes(trigger.new, trigger.oldMap);
		AccountActions.checkNabcaTerritory(trigger.new);
	}

}