/*******************************************************************************
Name		: HQAccountHierarchyController

Created By  : Basant Verma (Appirio JDC)   
Date        : 24/09/13
Story/Task  : To show Outlet HeadQuater, Banner and Store Hierarchy
*******************************************************************************/
public with sharing class HQAccountHierarchyController {
	// Record Type Names
	private final String HQ_RT_NAME = 'Outlet - Headquarters';
	private final String BANNER_RT_NAME = 'Outlet - Level A';
	private final String STORE_RT_NAME = 'Outlet Store';
	
	// Error Messages
	private final String INVALID_RT_ERROR = 'INVALID RECORD TYPE: This is applicable only on '+HQ_RT_NAME+' Accounts';
	private final String INVALID_PARAM = 'INVALID PARAMETER: Account Id did not passed';
	
	// Public propeties which we will use on Page
	public Account hqAcc {get; protected set;}
	public List<Account> bannerAccList {get; protected set;}
	public Map<String, String> states {get; protected set;}
	public List<String> statesSet {
		get{
			if(states != null){
				List<String> lst = new List<String>();
				lst.addAll(states.keySet());
				lst.sort();
				return lst;
			}	
			else{
				return new List<String>();
			}
		}
		protected set;
	}
	
	public Map<String, Marketing_Group__c> mrktGrps {get; protected set;}
	public Map<String, String> mrktGrpsClass {get; protected set;}
	public List<String> marketingGroupsSet {
		get{
			if(mrktGrpsClass != null){
				List<String> lst = new List<String>();
				lst.addAll(mrktGrpsClass.keySet());
				lst.sort();
				return lst;
			}
			else{
				return new List<String>();
			}
		}
		protected set;
	}
	
	public String selectedState {set; get;}
	public List<SelectOption> allStatesList {
		get{
			if(allStatesList == null){
				allStatesList = new List<SelectOption>();
				for(States__c st : [Select Id, Name, Abbreviation__c From States__c Order by Name]){
					allStatesList.add(new SelectOption(st.Name, st.Name));
				}
			}
			return allStatesList;
		}
		protected set;
	}
	
	// Constructor
	public HQAccountHierarchyController() {
		String accId = null;
		// Check for Account Id Parameter
		if(Apexpages.currentPage().getParameters().containsKey('accId')){
			accId = Apexpages.currentPage().getParameters().get('accId');
		}else{
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_PARAM));
			hqAcc = new Account();
		}
		
		if(accId != null){
			// Fetch Account Details
			hqAcc = [Select Id, Name, RecordTypeId, RecordType.Name From Account Where Id = :accId];
			// Check for Account Record Type
			if(hqAcc.RecordType.Name.equalsIgnoreCase(HQ_RT_NAME)){
				
				// Fetch All Banner Accounts
				bannerAccList = [Select Id, Name, RecordTypeId, RecordType.Name, ParentId
					From Account 
					Where ParentId =:hqAcc.Id AND RecordType.Name = :BANNER_RT_NAME order by Name];
				
				// Build Distinct States Map, with their Parent Banner info
				states = new Map<String, String>();
				mrktGrpsClass = new Map<String, String>();
				for(Account storeAcc : [Select Id, Name, RecordTypeId, RecordType.Name, 
					ParentId, Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name  
					From Account Where ParentId IN :bannerAccList 
						AND RecordType.Name = :STORE_RT_NAME]){
					if(!states.containsKey(storeAcc.Outlet_State__c))
						states.put(storeAcc.Outlet_State__c,storeAcc.ParentId);
					else
						states.put(storeAcc.Outlet_State__c,states.get(storeAcc.Outlet_State__c)+' '+storeAcc.ParentId);
					
					if(storeAcc.Marketing_Group__c != null){
						if(!mrktGrpsClass.containsKey(storeAcc.Marketing_Group__c))
							mrktGrpsClass.put(storeAcc.Marketing_Group__c, storeAcc.ParentId);
						else
							mrktGrpsClass.put(storeAcc.Marketing_Group__c, mrktGrpsClass.get(storeAcc.Marketing_Group__c)+' '+storeAcc.ParentId);
					}
				}
				mrktGrps = new Map<String, Marketing_Group__c>([Select Id, Name From Marketing_Group__c Where Id IN :marketingGroupsSet]);
			}else{
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_RT_ERROR));
			}
			
		}
	}
	
	
	// Test Method
	@isTest
	public static void testHQAccounts() {
		final String HQ_RT_NAME = 'Outlet - Headquarters';
		final String BANNER_RT_NAME = 'Outlet - Banner';
		final String STORE_RT_NAME = 'Outlet Store';
		Map<String, String> recTyp = new Map<String, String>();
		for(RecordType rt : [Select Id, Name From RecordType Where SobjectType = :'Account']){
			recTyp.put(rt.Name, rt.Id);
		}
		Account hqAccount = new Account();
		hqAccount.Name = 'Test HQ Account';
		hqAccount.RecordTypeId = recTyp.get(HQ_RT_NAME);
		insert hqAccount;
		System.assertNotEquals(hqAccount.Id, null);
		
		List<Account> bannerAccounts = new List<Account>();
		for(Integer i=0; i<5; i++){
			Account bac = new Account();
			bac.Name = 'Test Banner Account '+i;
			bac.ParentId = hqAccount.Id;
			bac.RecordTypeId = recTyp.get(BANNER_RT_NAME);
			bannerAccounts.add(bac);
		}
		insert bannerAccounts;
		System.assertNotEquals(bannerAccounts.get(0).Id, null);
		System.assertNotEquals(bannerAccounts.get(2).Id, null);
		
		List<String> stateList = new List<String>();
		for(Integer i=0; i<3; i++){
			stateList.add('Test State '+i);
		}
		
		List<Account> storeAccounts = new List<Account>();
		for(Integer i=0; i<10; i++){
			Account sac = new Account();
			sac.Name = 'Test Store Account '+i;
			sac.ParentId = bannerAccounts.get(Math.mod(i, 5)).Id;
			sac.Outlet_State__c = stateList.get(Math.mod(i, 3));
			sac.RecordTypeId = recTyp.get(STORE_RT_NAME);
			storeAccounts.add(sac);
		}
		insert storeAccounts;
		System.assertNotEquals(storeAccounts.get(0).Id, null);
		System.assertNotEquals(storeAccounts.get(2).Id, null);
		
		Pagereference pg = Page.HQAccountHierarchyPage;
		Test.setCurrentPage(pg);
		HQAccountHierarchyController con = new HQAccountHierarchyController();
		System.assert(Apexpages.getMessages().size() > 0);
		
		Apexpages.currentPage().getParameters().put('accId',bannerAccounts.get(0).Id);
		con = new HQAccountHierarchyController();
		System.assert(Apexpages.getMessages().size() > 0);
		
		Apexpages.currentPage().getParameters().put('accId',hqAccount.Id);
		con = new HQAccountHierarchyController();
		
		System.assertEquals(con.hqAcc.Id, hqAccount.Id);
		System.assertEquals(con.statesSet.size(), stateList.size());
	}
}