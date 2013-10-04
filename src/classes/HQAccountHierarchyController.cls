/*******************************************************************************
Name        : HQAccountHierarchyController

Created By  : Basant Verma (Appirio JDC)   
Date        : 24/09/13
Story/Task  : US841/TA1508 : To show Outlet HeadQuater, Banner and Store Hierarchy
*******************************************************************************/
public with sharing class HQAccountHierarchyController {
    // Error Messages
    private final String INVALID_RT_ERROR = 'INVALID RECORD TYPE: This is applicable only on '+Label.Outlet_Headquarters_Record_Type+' Accounts';
    private final String INVALID_PARAM = 'INVALID PARAMETER: Account Id did not passed';
    private final String MISMATCHED_STATES = 'MISMATCHED STATES: There are few missmatched state names, please contact Administrator';
    
    // Public propeties which we will use on Page
    public Id campaignId { get; set; }
    public String accId { get; set; }
    
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
    public HQAccountHierarchyController(ApexPages.StandardController stdController) {
//    public HQAccountHierarchyController() {
        // Check for National Account Group
        campaignId = stdController.getId();
        Campaign campaign = [SELECT ID, National_Account__c FROM Campaign WHERE Id =: campaignId];
        if(campaign.National_Account__c != null) {
            accId = campaign.National_Account__c;
//            String accId = null;
            // Check for Account Id Parameter
//            if(Apexpages.currentPage().getParameters().containsKey('id')){
//                accId = Apexpages.currentPage().getParameters().get('id');
//            }else{
//                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_PARAM));
//                hqAcc = new Account();
//            }
            if(accId != null){
                // Fetch Account Details
                hqAcc = [Select Id, Name, RecordTypeId, RecordType.Name From Account Where Id = :accId];
                // Check for Account Record Type
                
                if(hqAcc.RecordType.Name.equalsIgnoreCase(Label.Outlet_Headquarters_Record_Type)){
                    states = new Map<String, String>();
                    mrktGrpsClass = new Map<String, String>();
                    bannerAccList = new List<Account>();
                    createHierarchy(hqAcc.Id);
                    
                    // Build Distinct States Map, with their Parent Banner info
                                for(Account storeAcc : [Select Id, Name, RecordTypeId, RecordType.Name, 
                                    ParentId, TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name  
                                    From Account Where ParentId IN :bannerAccList 
                                        AND RecordType.Name = : Label.Outlet_Store_Record_Type]){
                                    if(!states.containsKey(storeAcc.TDLinx_Outlet_State__c ))
                                        states.put(storeAcc.TDLinx_Outlet_State__c ,storeAcc.ParentId);
                                    else if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.ParentId))
                                        states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.ParentId);
                                    // Also add Marketing Group Id
                                    if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.Marketing_Group__c))
                                            states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.Marketing_Group__c);
                                    
                                    if(storeAcc.Marketing_Group__c != null){
                                        if(!mrktGrpsClass.containsKey(storeAcc.Marketing_Group__c))
                                            mrktGrpsClass.put(storeAcc.Marketing_Group__c, storeAcc.ParentId);
                                        else if(!mrktGrpsClass.get(storeAcc.Marketing_Group__c).contains(storeAcc.ParentId))
                                            mrktGrpsClass.put(storeAcc.Marketing_Group__c, mrktGrpsClass.get(storeAcc.Marketing_Group__c)+' '+storeAcc.ParentId);
                                    }
                                    List<SelectOption> stateOptionList = allStatesList;
                                    List<String> statesNameSet = statesSet;
                                    if(statesNameSet.size() != stateOptionList.size()){
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, MISMATCHED_STATES));
                                    } 
                                }
                                mrktGrps = new Map<String, Marketing_Group__c>([Select Id, Name From Marketing_Group__c Where Id IN :marketingGroupsSet]);
                                
                }else{
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, INVALID_RT_ERROR));
                }
                
            }
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
    
    
    // Test Method
    @isTest
    public static void testHQAccounts() {
        final String HQ_RT_NAME = Label.Outlet_Headquarters_Record_Type;
        final String BANNER_RT_NAME = Label.Outlet_Banner_Record_Type;
        final String STORE_RT_NAME = Label.Outlet_Store_Record_Type;
        Map<String, String> recTyps = new Map<String, String>();
        for(RecordType rt : [Select Id, Name From RecordType Where SobjectType = :'Account']){
            recTyps.put(rt.Name, rt.Id);
        }
        Account hqAccount = new Account();
        hqAccount.Name = 'Test HQ Account';
        hqAccount.RecordTypeId = recTyps.get(HQ_RT_NAME);
        insert hqAccount;
        System.assertNotEquals(hqAccount.Id, null);
        
        List<Account> bannerAccounts = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account bac = new Account();
            bac.Name = 'Test Banner Account '+i;
            bac.ParentId = hqAccount.Id;
            bac.RecordTypeId = recTyps.get(BANNER_RT_NAME);
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
            sac.TDLinx_Outlet_State__c  = stateList.get(Math.mod(i, 3));
            sac.RecordTypeId = recTyps.get(STORE_RT_NAME);
            storeAccounts.add(sac);
        }
        insert storeAccounts;
        System.assertNotEquals(storeAccounts.get(0).Id, null);
        System.assertNotEquals(storeAccounts.get(2).Id, null);
        
        Pagereference pg = Page.HQAccountHierarchyPage;
        Test.setCurrentPage(pg);
        
        Campaign campaign = new Campaign(Name='Test Campaign');
        ApexPages.StandardController controller = new ApexPages.StandardController(campaign);
        HQAccountHierarchyController con = new HQAccountHierarchyController(controller);
        System.assert(Apexpages.getMessages().size() > 0);
        
        Apexpages.currentPage().getParameters().put('id',bannerAccounts.get(0).Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(bannerAccounts.get(0));
        con = new HQAccountHierarchyController(controller);
        System.assert(Apexpages.getMessages().size() > 0);
        
        Apexpages.currentPage().getParameters().put('id',hqAccount.Id);
        con = new HQAccountHierarchyController(controller);
        
        System.assertEquals(con.hqAcc.Id, hqAccount.Id);
        System.assertEquals(con.statesSet.size(), stateList.size());
    }
}