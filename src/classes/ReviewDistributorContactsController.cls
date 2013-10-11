/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Vikash Goyal	(Appirio JDC) 
Story/Task	: US729/TA1401
Description	: Controller class for ReviewDistributorContacts
*******************************************************************************/
public with sharing class ReviewDistributorContactsController {
	
	public String selectedContactId {get;set;}
	public List<SelectOption> lstContacts {get;set;}
	public Map<String, Contact> mapContacts{get;set;}
	public String comments {get;set;}
	private Map<String, String> mapContactToProcessId;
	
	public ReviewDistributorContactsController(ApexPages.StandardController stdController){
	  lstContacts = new List<SelectOption>();
	  mapContacts = new Map<String, Contact>();
	  mapContactToProcessId = new Map<String, String>();
	  comments = '';
	  populateContacts();	
	}
	
	private void populateContacts(){
		Set<String> processIds = new Set<String>();
		for(ProcessInstanceStep processStep : [SELECT StepStatus, ProcessInstanceId, Id, ActorId FROM ProcessInstanceStep 
																WHERE ActorId = :UserInfo.getUserId() AND StepStatus = 'Started']){
			processIds.add(processStep.ProcessInstanceId);
		}
		
		for(ProcessInstance processInstanse : [SELECT Id, TargetObjectId FROM ProcessInstance 
																											WHERE Status = 'Pending' AND Id IN :processIds]){
			mapContactToProcessId.put(processInstanse.TargetObjectId, processInstanse.Id);
		}
		
		lstContacts.add(new SelectOption('','---None---'));
		for(Contact con : [SELECT Id, Name, Title, Email, Phone, Subscribe_Status__c, Distributor_Name__c,
		  					Distributor_City__c, Distributor_State__c, Distributor_Postal_Code__c, Subscribe_Interested_In__c,
		  					Subscribe_Premise__c FROM Contact WHERE Id IN :mapContactToProcessId.keySet()]){
			lstContacts.add(new SelectOption(con.Id, con.Name));
			mapContacts.put(con.Id, con);
		}
	}
	
	public PageReference approveRequest(){
		Approval.ProcessWorkitemRequest workItemReq = new Approval.ProcessWorkitemRequest();
		workItemReq.setComments(comments);
		workItemReq.setWorkitemId(mapContactToProcessId.get(selectedContactId));
		workItemReq.setAction('Approve');
		Approval.ProcessResult result =  Approval.process(workItemReq);
		return null;
	}
	
	public PageReference rejectRequest(){
		Approval.ProcessWorkitemRequest workItemReq = new Approval.ProcessWorkitemRequest();
		workItemReq.setComments(comments);
		workItemReq.setWorkitemId(mapContactToProcessId.get(selectedContactId));
		workItemReq.setAction('Reject');
		Approval.ProcessResult result =  Approval.process(workItemReq);
		return null;
	}

}