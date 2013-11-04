/*******************************************************************************
Name        : HQAccountHierarchyController2

Created By  : Vikash Goyal (Appirio JDC)   
Date        : 31/10/13
Story/Task  : US807/TA1571
*******************************************************************************/
public with sharing class HQAccountHierarchyController2 {
    // Error Messages
    private final String INVALID_RT_ERROR = 'INVALID RECORD TYPE: This is applicable only on '+Label.Outlet_Headquarters_Record_Type+' Accounts';
    private final String INVALID_PARAM = 'INVALID PARAMETER: Account Id did not passed';
    private final String MISMATCHED_STATES = 'MISMATCHED STATES: There are few missmatched state names, please contact Administrator';
    private boolean isFirst = true;
    
    // Public propeties which we will use on Page
    public Id campaignId { get; set; }
    public String accId { get; set; }
    public String allSelectedStateCheckBox { get; set; }
    public Map<String, Integer> existingCampStates {get; set;}
    public Set<String> existingCampStatesNames {
    	get{
    		if(existingCampStates != null)
    			return existingCampStates.keySet();
    		else 
    			return new Set<String>();
    	}
    }
    
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
    public Map<String, String> stageAbbrevations {set; get;}
    public List<SelectOption> allStatesList {
        get{
            if(allStatesList == null){
                allStatesList = new List<SelectOption>();
                stageAbbrevations = new Map<String, String>();
                for(States__c st : [Select Id, Name, Abbreviation__c From States__c Order by Name]){
                    allStatesList.add(new SelectOption(st.Abbreviation__c, st.Name));
                    stageAbbrevations.put(st.Abbreviation__c, st.Name);
                    if(!states.containsKey(st.Abbreviation__c)){
                        states.put(st.Abbreviation__c,'');
                    }
                }
            }
            return allStatesList;
        }
        protected set;
    }
    
    
    // Constructor
    public HQAccountHierarchyController2(ApexPages.StandardController stdController) {
      // Check for National Account Group
      campaignId = stdController.getId();
      hqAcc = new Account();
      //init();
      isFirst = false;
    }
    
    private void init(){
    	selectAccount();
    }
    
    public void selectAccount(){
    	String queryString = 'SELECT Id, Name, RecordTypeId, RecordType.Name From Account ';
    	String conditionClause;
    	if(hqAcc.National_Account_Group__c != null){
    		conditionClause = 'WHERE National_Account_Group__c = :hqAcc.National_Account_Group__c ';
    	}
    	if(hqAcc.Marketing_Group__c != null){
    		conditionClause += (conditionClause == null) ? 'WHERE Marketing_Group__c = :hqAcc.Marketing_Group__c ' : 'AND Marketing_Group__c = :hqAcc.Marketing_Group__c';
    	}
    	if(hqAcc.Key_Account_Group__c != null){
    		conditionClause += (conditionClause == null) ? 'WHERE Key_Account_Group__c = :hqAcc.Key_Account_Group__c ' : 'AND Key_Account_Group__c = :hqAcc.Key_Account_Group__c';
    	}
    	if(conditionClause != null){
    		queryString += conditionClause;
    	}
    	hqAcc = Database.query(queryString);
    	if(hqAcc != null){    	
    		if(hqAcc.RecordType.Name.equalsIgnoreCase(Label.Outlet_Headquarters_Record_Type)){
          states = new Map<String, String>();
          mrktGrpsClass = new Map<String, String>();
          bannerAccList = new List<Account>();
          createHierarchy(hqAcc.Id);
          existingCampStates = new Map<String, Integer>();
					for(Campaign_State__c cs : [Select Id, Name, Campaign__c From Campaign_State__c Where Campaign__c = :campaignId]){
					  if(!existingCampStates.containsKey(cs.Name))
						  existingCampStates.put(cs.Name, 0);
					}
          // Build Distinct States Map, with their Parent Banner info
          for(Account storeAcc : [Select Id, Name, RecordTypeId, RecordType.Name, 
                               ParentId, TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name  
                               From Account Where ParentId IN :bannerAccList 
                              AND RecordType.Name = : Label.Outlet_Store_Record_Type]){
            if(!states.containsKey(storeAcc.TDLinx_Outlet_State__c ))
              states.put(storeAcc.TDLinx_Outlet_State__c ,storeAcc.ParentId);
            else if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.ParentId))
              states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.ParentId);
                        
            if(storeAcc.Marketing_Group__c != null){
              // Also add Marketing Group Id
              if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.Marketing_Group__c))
                states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.Marketing_Group__c);
              if(!mrktGrpsClass.containsKey(storeAcc.Marketing_Group__c))
                mrktGrpsClass.put(storeAcc.Marketing_Group__c, storeAcc.ParentId);
              else if(!mrktGrpsClass.get(storeAcc.Marketing_Group__c).contains(storeAcc.ParentId))
                mrktGrpsClass.put(storeAcc.Marketing_Group__c, mrktGrpsClass.get(storeAcc.Marketing_Group__c)+' '+storeAcc.ParentId);
            }
            
            List<SelectOption> stateOptionList = allStatesList;
            List<String> statesNameSet = statesSet;
            if(statesNameSet.size() != stateOptionList.size() && isFirst){
              Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, MISMATCHED_STATES));
            }
                        
            if(existingCampStates.containsKey(storeAcc.TDLinx_Outlet_State__c)){
             	existingCampStates.put(storeAcc.TDLinx_Outlet_State__c, existingCampStates.get(storeAcc.TDLinx_Outlet_State__c)+1);
            }
          }
          mrktGrps = new Map<String, Marketing_Group__c>([Select Id, Name From Marketing_Group__c Where Id IN :marketingGroupsSet]);
                                
        }else{
           Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_RT_ERROR));
        }
      }else{
			  Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_PARAM));
				hqAcc = new Account();
		  }
    }
    
    /***************************************************************************
                NEW MODIFICATION STARTS HERE
    ***************************************************************************/
    public Map<String, List<Account>> bannerAccMap {get; protected set;}
    // Private method to build Hierarchy
    private void createHierarchy(String parentAccId){
        if(bannerAccMap == null)
            bannerAccMap = new Map<String, List<Account>>();
        Set<String> allParents = new Set<String>();
        allParents.add(parentAccId);
        Integer icount = 0;
        while(true){
            // Fetch All Banner Accounts
            List<Account> bannerAccounts = [Select Id, Name, RecordTypeId, RecordType.Name, ParentId
                From Account 
                Where ParentId IN :allParents AND RecordType.Name = :Label.Outlet_Banner_Record_Type order by Name];
            
            // Terminate condition for this infinite loop
            if(bannerAccounts.size() == 0){
                break;
            }
            else{
                allParents.clear();
                for(Account acc : bannerAccounts){
                    if(!bannerAccMap.containsKey(acc.ParentId))
                        bannerAccMap.put(acc.ParentId, new List<Account>());
                    bannerAccMap.get(acc.ParentId).add(acc);
                    allParents.add(acc.Id);
                    bannerAccList.add(acc);
                }
            }
        }
    }
    
    /*public Pagereference saveAction(){
    	try{
    		Campaign newCamp = new Campaign();
	    	newCamp.Name = calendar.Name;
	    	newCamp.National_Account__c = calendar.National_Account__c;
	    	newCamp.Program__c = calendar.Id;
	    	insert newCamp;
	    	createCamaignStates(newCamp.Id);
    	}catch(Exception e){
    		 Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
    	}
    	return null;
    }*/
    
    public Pagereference createCamaignStates(String campaignId){
    	List<Campaign_State__c> newCamStates = new List<Campaign_State__c>();
    	
    	for(String st : allSelectedStateCheckBox.split(',')){
    		if(!existingCampStates.containsKey(st)){
    			newCamStates.add( new Campaign_State__c(Name = st, Campaign__c = campaignId));
    		}
    	}
    	
    	if(newCamStates != null && newCamStates.size() > 0){
    		insert newCamStates;
    	}
    	
    	init();
    	return null;
    }   
}