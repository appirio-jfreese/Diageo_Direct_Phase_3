/*******************************************************************************
Name		: HQAccountHierarchyController

Created By  : Basant Verma (Appirio JDC)   
Date        : 24/09/13
Story/Task  : To show Outlet HeadQuater, Banner and Store Hierarchy
*******************************************************************************/
public with sharing class HQAccountHierarchyController {
	public Account hqAcc {set; get;}
	public List<Account> bannerAccList {set; get;}
	//public Map<String, List<Account>> bannerStoreHierarchy {set; get;}
	public Map<String, String> states {set; get;}
	public Set<String> statesSet {
		get{
			if(states != null)
				return states.keySet();
			else
				return new Set<String>();
		}
	}
	private final String HQ_RT_NAME = 'Outlet - Headquarters';
	private final String BANNER_RT_NAME = 'Outlet - Banner';
	private final String STORE_RT_NAME = 'Outlet Store';
	private final String INVALID_RT_ERROR = 'INVALID RECORD TYPE: This is applicable only on '+HQ_RT_NAME;
	private final String INVALID_PARAM = 'INVALID PARAMETER: Account Id did not passed';
	
	public HQAccountHierarchyController() {
		String accId = null;
		if(Apexpages.currentPage().getParameters().containsKey('accId')){
			accId = Apexpages.currentPage().getParameters().get('accId');
		}else{
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_PARAM));
			hqAcc = new Account();
		}
		
		if(accId != null){
			hqAcc = [Select Id, Name, RecordTypeId, RecordType.Name From Account Where Id = :accId];
			if(hqAcc.RecordType.Name.equalsIgnoreCase(HQ_RT_NAME)){
				
				bannerAccList = [Select Id, Name, RecordTypeId, RecordType.Name, ParentId
					From Account 
					Where ParentId =:hqAcc.Id AND RecordType.Name = :BANNER_RT_NAME];
				
				//bannerStoreHierarchy = new Map<String, List<Account>>();
				states = new Map<String, String>();
				for(Account storeAcc : [Select Id, Name, RecordTypeId, RecordType.Name, 
					ParentId, Outlet_State__c From Account Where ParentId IN :bannerAccList 
						AND RecordType.Name = :STORE_RT_NAME]){
					/*if(!bannerStoreHierarchy.containsKey(storeAcc.ParentId))
						bannerStoreHierarchy.put(storeAcc.ParentId, new List<Account>());
					bannerStoreHierarchy.get(storeAcc.ParentId).add(storeAcc);*/
					
					if(states.containsKey(storeAcc.Outlet_State__c))
						states.put(storeAcc.Outlet_State__c,storeAcc.Id);
					else
						states.put(storeAcc.Outlet_State__c,states.get(storeAcc.Outlet_State__c)+','+storeAcc.Id);
				}
			}else{
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_RT_ERROR));
			}
		}
	}
}