/*****************************************************************************************************************
Name        : Sertvice_ContentItem.cls

Updated By  : Jonathan Freese (Appirio)   
Date        : 5/29/13
Story/Task  : US507/TA918
******************************************************************************************************************/

global public with sharing class Service_ContentItem {
    
    public Boolean isIpadComponent{get;set;}
    
    public Service_ContentItem(){    	
    	String myuserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
    	if(myuserAgent != null && myuserAgent.contains('iPad')){
    		isIpadComponent = true;	
    	}else{
    		isIpadComponent = false;
    	}
    }
    
    public Boolean editable{
    	get{
    		try{
    			return aggregated.result.get('OwnerID') == UserInfo.getUserId();
    		} catch(Exception ex){
    			return false;
    		}
    	}
    }
    public Datetime createdDate1 {
    	get{
    		try{
    			return (Datetime)aggregated.result.get('createdDate');
    		} catch(Exception ex){
    			return system.now();
    		}
    	}
    	set;
    }
    public Datetime lastLoginDateItem1 {
    	get;
    	set;
    }
    public String cvid1 {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('cvid');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			} 
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public String cvidlow1 {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('cvidlow');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			} 
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public String imageRes1 {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('imageRes');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			}
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public String fileType1 {
    	get{
    		try{
    			return (String)aggregated.result.get('filetype');
    		} catch(Exception ex){
    			return '';
    		}
    	}
    	set;
    }
    public String fileSize1 {
    	get{
    		try{
    			return (String)aggregated.result.get('filesize');
    		} catch(Exception ex){
    			return '';
    		}
    	}
    	set;
    }
    public Boolean displayUploadDate1 {
    	get;
    	set;
    }
    public Boolean showDownloadShare1 {
    	get;
    	set;
    }
    public Boolean showListButtons1 {
    	get;
    	set;
    }
    public Boolean isVideo1 {
    	get{
    		try{
    			return (Boolean)aggregated.result.get('is_video');
    		} catch(Exception ex){
    			return false;
    		}
    	}
    	set;
    }
    public String videoId1 {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('video_id');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			}
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public Boolean previewAvailable1 {
    	get{
    		try{
    			return (Boolean)aggregated.result.get('previewAvailable');
    		} catch(Exception ex){
    			return false;
    		}
    	}
    	set;
    }
    public String previewId1 {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('previewId');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			}
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public String width1 {
    	get;
    	set;
    }
    public String height1 {
    	get;
    	set;
    }
    public String margin1 {
    	get{
    		try{
    			return (String)aggregated.result.get('margin');
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
    public Boolean renderAsList1 {
    	get;
    	set;
    }
    public String description2 {
    	get{
	        try{
    			return (String)aggregated.result.get('description');
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }

    /* Start: changes for TA918 Jonathan Freese */
    public String title1 {
    	get{
	        try{
    			return (String)aggregated.result.get('title');
    		} catch(Exception ex){
    			return '';
    		}
    	}
    	set;
    }
    /*   End: changes for TA918 Jonathan Freese */
    
    public AggregateResultHolder aggregated {get;
    	set{
    		aggregated = value;
    		}
    }
    
    public Set<id> basketIds {get; set;}
    
    public Set<id> followIds {get; set;}
    
	public Boolean inBasket {
    	get{
	        try{
	        	if(basketIds != null){
	        		if(basketIds.contains(cvid1) || basketIds.contains(cvidlow1)){
	        			return true;
	        		} else {
	        			return false;
	        		}
	        	} else {
	        		return false;
	        	}
    		} catch(Exception ex){
    			return false;
    		}
    	}
    	set;
    }
    
	public Boolean inFollow {
    	get{
	        try{
	        	if(followIds != null){
	        		if(followIds.contains(cvid1) || followIds.contains(cvidlow1)){
	        			return true;
	        		} else {
	        			return false;
	        		}
	        	} else {
	        		return false;
	        	}
    		} catch(Exception ex){
    			return false;
    		}
    	}
    	set;
    }
    
    public void setaggregated(object a){
    	aggregated = (AggregateResultHolder)a;
    }
    
    
    public Date getcreatedDate2() {
    	createdDate1 = (createdDate1 == null) ? system.now() : createdDate1;
    	Date convertedDate = Date.newInstance(createdDate1.year(),createdDate1.month(),createdDate1.day());
    	return convertedDate;       
    }   
    
    public void setlastLoginDateItem(object b)
    {
    	 lastLoginDateItem1 = (Datetime)b;   
    	
    }
        
	public Boolean getisNew(){
		if(lastLoginDateItem1 < createdDate1)
		{
			return true;
		}else{
			return false;
		}		
	}
	
	public Boolean canEdit(){
		return aggregated.result.get('OwnerId') == UserInfo.getUserId();
	}
	
	public String cid {
    	get{
    		try{
    			String tmp = (String)aggregated.result.get('id');
    			if(tmp != null && tmp != ''){
    				return tmp;
    			} else {
    				return null;
    			} 
    		} catch(Exception ex){
    			return null;
    		}
    	}
    	set;
    }
}