public with sharing class AccountActions {

	public static void updateRecordTypes(List<Account> newList, Map<Id, Account> oldMap){
		//used for update
		
		List<Account> accsToUpdate = new List<Account>();
		for(Account acc : newList){
			if(acc.NABCA_Sector_Code__c != oldMap.get(acc.Id).NABCA_Sector_Code__c){
				accsToUpdate.add(acc);
			}
		}
		
		if(accsToUpdate.size() > 0){
			updateRecordTypes(accsToUpdate);
		}
	}

	public static void updateRecordTypes(List<Account> newList){
		//used for insert
		
		//get proper record type IDs
		Id onPremId;
		Id offPremId;
		Id combPremId;
		
		List<RecordType> accRecTypeList = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND Name LIKE '% - Control'];
		for(RecordType rt : accRecTypeList){
			if(rt.Name == 'On-Premise - Control'){
				onPremId = rt.Id;
			} else if(rt.Name == 'Off-Premise - Control'){
				offPremId = rt.Id;
			//REMOVE COMBINED } else if(rt.Name == 'Combined Premise - Control'){
			//REMOVE COMBINED 	combPremId = rt.Id;
			}
		}
		
		//loop through incoming accounts and set their record types appropriately
		for(Account acc : newList){
			if(acc.NABCA_Sector_Code__c == 'o' || acc.NABCA_Sector_Code__c == 'O'){
				acc.RecordTypeId = onPremId;
			} else if(acc.NABCA_Sector_Code__c == 'f' || acc.NABCA_Sector_Code__c == 'F' || acc.NABCA_Sector_Code__c == 'c' || acc.NABCA_Sector_Code__c == 'C'){
				acc.RecordTypeId = offPremId;
			//REMOVE COMBINED } else if(acc.NABCA_Sector_Code__c != null){
			//REMOVE COMBINED 	acc.RecordTypeId = combPremId;
			}
		} 
	}
	
	public static void checkNabcaTerritory(List<Account> accs){
		List<Account> accsToModify = new List<Account>();
		Set<String> terrNames = new Set<String>();
		
		for(Account acc : accs){
			if(acc.Nabca_Account_Name__c != null && acc.Nabca_Account_Name__c.contains('(') && acc.NABCA_Licensee_State_Abbreviation__c  != null && acc.Territory__c == null){
				accsToModify.add(acc);
				terrNames.add(acc.NABCA_Licensee_State_Abbreviation__c  + '1 Holding');
			}
		}
		
		if(accsToModify.size() > 0){
			List<Territory__c> terrs =
				[SELECT Id,
						Name
				   FROM Territory__c
				  WHERE Name IN :terrNames
				];
				
			if(terrs.size() > 0){
				Map<String, Id> terrIdsByName = new Map<String, Id>();
				for(Territory__c terr : terrs){
					terrIdsByName.put(terr.Name, terr.Id);
				}
				
				for(Account acc : accsToModify){
					acc.Territory__c = terrIdsByName.get(acc.NABCA_Licensee_State_Abbreviation__c  + '1 Holding');
				}
			}
		}
	}

}