public without sharing class ControllerControlMarketCases {
    public List<WrapperCase> WrapperCaseList;
    set<String> profileIds;
    public ControllerControlMarketCases(){
        List<Control_Market_Profile__c> cmp = Control_Market_Profile__c.getall().values();
        profileIds= new Set<String>();
        for(Control_Market_Profile__c controlMarketProfile : cmp ){
            profileIds.add(controlMarketProfile.ProfileId__c);
        }
    }
    
    public List<WrapperCase> getWrapperCaseList(){
    WrapperCaseList = new list<WrapperCase>();
    String caseComment;
    String caseComment2;
        list<Case> cases =  [SELECT  Id,Owner.Username,Subject,Case_Age__c,Appirio_Request_Type__c,Description, CaseNumber, status, priority, type, LastModifiedDate,(Select Id,CommentBody, LastModifiedDate From CaseComments order by LastModifiedDate DESC)
                    FROM Case where CreatedBy.ProfileId in : profileIds
                    ];
                  
        if(cases.size() > 0){
            for(Case c : cases){
                 WrapperCase wrappedCase = new WrapperCase();
                 wrappedCase.userName = c.Owner.Username;
                 wrappedCase.CaseNumber = c.CaseNumber;
                 wrappedCase.openDate = getOpenDate(c.Case_Age__c);
                 wrappedCase.subject = c.Subject;
                 wrappedCase.age = c.Case_Age__c;
                 wrappedCase.Appirio_Request_Type = c.Appirio_Request_Type__c;
                 wrappedCase.Description = c.Description;
                 if(c.CaseComments.size() > 0 ){
                 caseComment = c.CaseComments[0].CommentBody;
                 caseComment=caseComment.replaceAll(',','');
                 System.debug('----Case Comment after removal of comma'+caseComment);
                 
                 wrappedCase.caseComement = caseComment;
                 System.debug('-----------'+wrappedCase.caseComement);
                 }
                 else
                 wrappedCase.caseComement = '';
                 WrapperCaseList.add(wrappedCase);
            }
            
        }
        
        return   WrapperCaseList;          
    }
  private String getOpenDate(Decimal age){
    datetime todayDate = datetime.now();
    datetime openDate = todayDate.addDays(integer.valueof(-age));
    return openDate.format('MM/dd/yyyy');
  
  }
 public class WrapperCase{
   public String userName{get;set;}
   public String openDate{get;set;}
   public String subject{get;set;}
   public Double age{get;set;}
   public String Appirio_Request_Type{get;set;}
   public String Description{get;set;}
   public String CaseNumber{get;set;}
   public string caseComement{get;set;}
    
    
 }  
  
}