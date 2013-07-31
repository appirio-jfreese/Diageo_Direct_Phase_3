/******************************************************************
 * Name                 : Controller_BPDetails
 * Created By           : Parul Gupta(Appirio Offshore)
 * Created Date         : 3 June, 2013
 * Description          : Controller class for BPDetails.page
 ******************************************************************/
public with sharing class Controller_BPDetails extends Controller_Base {
	
	public String backToBlogPostsUrl {get; private set;}	
	public Id bpDetailId {public get; protected set;}
	public Id previousPostId {public get; protected set;}
	public Id nextPostId {public get; protected set;}
	public Blog__c blogItem {public get; protected set;}
	public Comment__c newComment {public get; protected set;}
	
	/**
    * Constructor
    */	
	public Controller_BPDetails() {
		backToBlogPostsUrl = Page.BlogPosts.getUrl();
		pageUrl = Page.BPDetails.getUrl();
		addBreadcrumbItem(Page.BlogPosts.getUrl(), 'Blog Posts');
		if(ApexPages.currentPage().getParameters().get('BlogPostId') != null){
            try {
                bpDetailId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
                blogItem = getBP(bpDetailId);
                newComment = new Comment__c();
                // Service_API.getBP(bpDetailId);
            } 
            catch( Exception err ){
            	bpDetailId = null;
            	getBP(bpDetailId);
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to load details.'));
                return;
            }   	
		}
	}
	
	public PageReference postComment(){
		newComment.Blog__c = bpDetailId;
		insert newComment;
		return null;
	}
	public PageReference previousPost(){
		for(Blog__c  blog : [SELECT Id, CreatedDate, Name
						    FROM Blog__c 
							where CreatedDate < : blogItem.CreatedDate
							and id != : blogItem.id
							order by CreatedDate
							desc limit 1]){
			previousPostId = blog.id;					
		}
		PageReference pageRef = new PageReference('/bpDetails?id=' + previousPostId);
		return pageRef;
	}
	public PageReference nextPost(){
		for(Blog__c  blog : [SELECT Id, CreatedDate, Name
						    FROM Blog__c 
							where CreatedDate > : blogItem.CreatedDate
							and id != : blogItem.id
							order by CreatedDate
							asc limit 1]){
			nextPostId = blog.id;					
		}
		PageReference pageRef = new PageReference('/bpDetails?id=' + nextPostId);
		return pageRef;
	}
	
	/**
    * @author Parul Gupta(Appirio Offshore)
    * @date 06/03/2013
    * @param Id Requested Blog Post Id
    * @description Get a Blog Post for requested ID
    * @return Blog__c
    */
    private Blog__c getBP(Id bpId){
        return [
            SELECT Id, Name, AllowComments__c, Detail__c, EndDate__c, 
			StartDate__c, Sub_Title__c, Summary__c, Theme__c, CreatedById, CreatedBy.Name, CreatedDate, 
			(Select Id, Comment__c, CreatedById, CreatedBy.Name, CreatedDate From Comment__r),
			(Select Id, Tag__r.Name From Blog2Tag__r)
			FROM Blog__c
            WHERE  ID = : bpId
        ];
    }
}