public with sharing class Service_FolderComments {

	public String commentBody { get; set; }
	public String distributorId { get; set; }
	public String folderId { get; set; }
	public String fileId { get; set; }	
	public Boolean isAdded {
		public get{
			if(isAdded) {
				isAdded=false;
	            commentBody = null;
	            distributorId = null;
	            folderId = null;
	            fileId = null;			
				return true;
			}
			return isAdded;
		}
		public set;
	}

	public Service_FolderComments() {
		isAdded = false;
		commentBody = null;
		distributorId = null;
		folderId = null;
		fileId = null;
	}

    public void addCommentMsg(){
		try{
			if(commentBody == null || commentBody == '' || commentBody.length() > 999){
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to add comment.' ));
				isAdded = false;
				return;
			}
			Folder_Comment__c fcomment = new Folder_Comment__c();
			fcomment.Comment_Body__c = commentBody;
			fcomment.Distributor_Name__c = Service_API.getAID();
			fcomment.Distributor_Access__c = distributorId;
			fcomment.folder__c = folderId;
			fcomment.file__c = fileId;
			fcomment.Classification__c = Service_Api.getSectionTheme();
			insert fcomment;
			isAdded = true; 
		}
		catch (Exception e) {
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to add comment.' ));
			isAdded = false;
			return;
		}
    }   

    public void closeCommentMsg(){
		isAdded = false;
		commentBody = null;
		distributorId = null;
		folderId = null;
		fileId = null;
    }
}