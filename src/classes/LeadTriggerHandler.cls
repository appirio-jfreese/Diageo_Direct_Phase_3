/***************************************************************************
// (c) 2013 Appirio, Inc.
//
// Description    : Class that contains all of the functionality called by the 
//                  LeadTrigger. All contexts should be in this class.
//                  
// Sep 12th, 2013 :  Randy Wandell  
//***************************************************************************/
public with sharing class LeadTriggerHandler {
    private boolean m_isExecuting = false;  
    private integer BatchSize = 0;
    
    public LeadTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;    
    }
    
    //-------------------------------------------------------------------------  
    // On before insert trigger method
    //-------------------------------------------------------------------------
    public void OnBeforeInsert(List<lead> leads) {

    } 

    //-------------------------------------------------------------------------
    // On after insert trigger method
    //-------------------------------------------------------------------------
    public void OnAfterInsert(List<Lead> leads) {   
         
    }

    //-------------------------------------------------------------------------
    // On before update trigger method
   //-------------------------------------------------------------------------
    public void OnBeforeUpdate(Map<Id, Lead>oldMap, Map<Id, Lead>newMap) {

    }

    //-------------------------------------------------------------------------
    // On after update trigger method
    //-------------------------------------------------------------------------
    public void OnAfterUpdate (Map<Id, Lead>oldMap, Map<Id, Lead>newMap) {    
      
    }

    //-------------------------------------------------------------------------
    // On before delete trigger method
    //-------------------------------------------------------------------------
    public void OnBeforeDelete (Map<Id, Lead>oldMap) {    
      
    }
    
    //-------------------------------------------------------------------------
    // On after delete trigger method
    //-------------------------------------------------------------------------
    public void OnAfterDelete (Map<Id, Lead>oldMap) {    
      
    }
    
    
}