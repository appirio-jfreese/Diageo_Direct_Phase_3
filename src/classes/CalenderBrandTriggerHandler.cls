/*******************************************************************************
Name        : CalenderBrandTriggerHandler

Created By  : Basant Verma (Appirio JDC)   
Date        : 10/11/13
Story/Task  : US834/TA1500 : Only one Calendar Brand can marked as primary for an Calender
*******************************************************************************/
public with sharing class CalenderBrandTriggerHandler {
	public static void onBeforeInsert(List<CalendarBrand__c> newList){
    checkForPrimaryBrandBeforeInsert(newList);
	}
	
	public static void onAfterInsert(List<CalendarBrand__c> newList){
    checkForPrimaryBrand(newList, null);
	}

	public static void onAfterUpdate(List<CalendarBrand__c> newList,
                                 Map<Id,CalendarBrand__c> oldMap){
    checkForPrimaryBrand(newList, oldMap);
	}
	
	private static void checkForPrimaryBrandBeforeInsert(List<CalendarBrand__c> newList){
		Map<String, List<CalendarBrand__c>> calBrandMap = new Map<String, List<CalendarBrand__c>>();
		for(CalendarBrand__c cb : newList){
			if(!calBrandMap.containsKey(cb.Calendar__c))
				calBrandMap.put(cb.Calendar__c, new List<CalendarBrand__c>());
			calBrandMap.get(cb.Calendar__c).add(cb);
		}
		
		for(CalendarBrand__c cb : [Select Id, Name, Primary_Brand__c, Calendar__c
			From CalendarBrand__c Where Calendar__c IN :calBrandMap.keySet() AND Primary_Brand__c = true]){
			calBrandMap.remove(cb.Calendar__c);
		}
		
		for(String key : calBrandMap.keySet()){
			calBrandMap.get(key).get(0).Primary_Brand__c = true;
		}
	}

	private static void checkForPrimaryBrand(List<CalendarBrand__c> newList, 
			Map<Id,CalendarBrand__c> oldMap){
		Map<String, CalendarBrand__c> calBrandMap = new Map<String, CalendarBrand__c>();
		List<Calendar__c> calToBeUpdate = new List<Calendar__c>();
		for(CalendarBrand__c cb : newList){
			if(!calBrandMap.containsKey(cb.Calendar__c)){
				calBrandMap.put(cb.Calendar__c, null);
			}
		}
		
		for(CalendarBrand__c cb : [Select Id, Name, Primary_Brand__c, Calendar__c, Brand__c, Brand__r.Name 
			From CalendarBrand__c Where Calendar__c IN :calBrandMap.keySet()]){
			if(cb.Primary_Brand__c){
				if(calBrandMap.get(cb.Calendar__c) == null){
					calBrandMap.put(cb.Calendar__c, cb);
				}else{
					newList.get(0).Primary_Brand__c.addError(Label.PrimaryCalendarBrandError);
				}
			}
		}
		
		String brandName = '';
		for(Calendar__c cal : [Select Id, Name, Program_Name__c, RecordType.Name, 
			Sales_Channel__c, Start_Date__c
			From Calendar__c Where Id IN :calBrandMap.keySet()]){
			brandName = '';
			if(calBrandMap.get(cal.Id) != null){
				brandName = ' - ' + calBrandMap.get(cal.Id).Brand__r.Name;
			}else{
				newList.get(0).Primary_Brand__c.addError(Label.PrimaryCalendarBrandMustError);
			}
			cal.Program_Name__c = cal.RecordType.Name + ' - ' + cal.Sales_Channel__c 
					+ brandName + ' - ' + String.valueOf(cal.Start_Date__c);
			calToBeUpdate.add(cal);
		}
		if(calToBeUpdate.size() > 0){
			update calToBeUpdate;
		}
	}
}