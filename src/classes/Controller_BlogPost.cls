/*****************************************************************************************************************
Name        : Controller_BlogPost.cls

Updated By  : Basant Verma (Appirio Offshore)   
Date        : 5/31/13
Story/Task  : US503/TA907
*****************************************************************************************************************/
public without sharing class Controller_BlogPost extends Controller_Base{
	public List<Blog__c> blogPosts {get;set;}
	public String blogUrl {set; get;}
	public String blogTag {set; get;}
	public List<String> blogTags {set; get;}
	public String blogSTag {set; get;}
	public Integer blogCount {set; get;}
	public String blogFormat ='';
	
	public Controller_BlogPost(){
		System.debug('============== blogFormat : '+blogFormat);
		//blogTag = 'TestTag';
		blogTags = new List<String>();
		String tagType='';
		if(blogTag != null && !blogTag.trim().equals('')){
			blogTags.add(blogTag);
			tagType = blogTag.contains(':') ? blogTag.substring(0, blogTag.indexOf(':')) : '';
		}
		blogPosts = Service_API.getBlogRecordss(blogUrl, blogTags, tagType);
	}
	
	public void setBlogFormat(String s ){
		blogFormat =s;
	}
	
	public String getBlogFormat(){
		return blogFormat;
	}
}