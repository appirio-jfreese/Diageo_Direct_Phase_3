/*******************************************************************************
Name        : Controller_SearchResult.cls

Modified By	: Basant Kumar Verma
Date				: 7/15/2013
Story/Task	: US612/DE635

Modified By	: Basant Kumar Verma
Date				: 7/16/2013
Story/Task	: US612/DE636
*******************************************************************************/
public with sharing class Controller_SearchResult extends Controller_Base {
		
    public Integer minNoOfChar {
        get {
            return Integer.valueOf(Service_API.getSetting('minSearchNoOfChars'));
        }
        protected set;
    }
    public Integer limitPerSection {
        get {
            return Integer.valueOf(Service_API.getSetting('searchResultLimit'));
        }
        protected set;
    }   
    public String searchValue {get; set;}
    public map<string, List<AggregateResult>> contentMap {get; protected set;}
    public MAP<string, List<AggregateResultHolder>> contentHolderMap {
    	get {
    		MAP<string, List<AggregateResultHolder>> contentHolder1 = new MAP<string, List<AggregateResultHolder>>();
    		if(contentMap!=null){
    			for(string key : contentMap.keySet()){
		    		List<AggregateResultHolder> tmpList = new List<AggregateResultHolder>();
		    		for(AggregateResult ar : contentMap.get(key)){
		    			AggregateResultHolder tmp = new AggregateResultHolder();
		    			tmp.result = ar;
		    			tmpList.add(tmp);
		    		}
		    		contentHolder1.put(key,tmpList);
    			}
    		}
    		return contentHolder1;
    	}
    	set;
    }
    // Start Changes for DE636 - Basant
    private String responsiveSingleSectionName = 'Responsive';
    public MAP<string, List<AggregateResultHolder>> R_contentHolderMap {
    	get {
    		MAP<string, List<AggregateResultHolder>> contentHolder1 = new MAP<string, List<AggregateResultHolder>>();
    		if(contentMap!=null){
    				List<AggregateResultHolder> finalList = new List<AggregateResultHolder>();
						for(string key : contentMap.keySet()){
							List<AggregateResultHolder> tmpList = new List<AggregateResultHolder>();
			    		for(AggregateResult ar : contentMap.get(key)){
			    			AggregateResultHolder tmp = new AggregateResultHolder();
			    			tmp.result = ar;
			    			tmpList.add(tmp);
			    		}
			    		finalList = applyCustomeSorting(finalList, tmpList);
	    			}
	    			contentHolder1.put(responsiveSingleSectionName,finalList);
    			}
    		return contentHolder1;
    	}
    	set;
    }
    
    public List<String> R_sectionOrder {
			get{
				List<String> R_sectionOrder = new List<String>();
				R_sectionOrder.add(responsiveSingleSectionName);
				return R_sectionOrder;
			} 
			protected set;
		}
		
		public map<string, integer> R_sectionItemNumber {
	 		get{
	 			R_sectionItemNumber = new map<string, integer>();
	 			Integer intTotal = 0;
	 			for(Integer intVal : sectionItemNumber.values()){
	 				intTotal += intVal;
	 			}
	 			R_sectionItemNumber.put(responsiveSingleSectionName, intTotal);
	 			return R_sectionItemNumber;
	 		}
	 		protected set;
 		}
 		
 		private void responsiveRefresh(){
 			initPager();
 			numberOfItems = Integer.valueOf(R_sectionItemNumber.get(responsiveSingleSectionName));
 			List<AggregateResult> sectionContentTemp = new List<AggregateResult>();
 			for(string key : contentMap.keySet()){
				for(AggregateResult ar : contentMap.get(key)){
					sectionContentTemp.add(ar);
				}
			}
			sectionContent = getRequestedPage(sectionContentTemp);
 		}
 		
 		private List<AggregateResultHolder> applyCustomeSorting(List<AggregateResultHolder> list1, List<AggregateResultHolder> list2){
 			// receive the left and right sublist as arguments.
	    // 'result' variable for the merged result of two sublists.
	    System.debug('START applyCustomeSorting ==================== R_OrdertBy :'+R_OrdertBy);
	    List<AggregateResultHolder> result = new List<AggregateResultHolder>();
	    // assign the element of the sublists to 'result' variable until there is no element to merge. 
	    while(list1.size() > 0 || list2.size() > 0){
	        if( list1.size() > 0 && list2.size() > 0){
	           // compare the first two element, which is the small one, of each two sublists.
	            if( ((R_OrdertBy == null || R_OrdertBy.trim().equalsIgnoreCase('ASC')) && String.valueOf(list1.get(0).result.get('description')).toUpperCase().compareTo(String.valueOf(list2.get(0).result.get('description')).toUpperCase()) <= 0 )
	            		|| ((R_OrdertBy != null && R_OrdertBy.trim().equalsIgnoreCase('DESC')) && String.valueOf(list1.get(0).result.get('description')).toUpperCase().compareTo(String.valueOf(list2.get(0).result.get('description')).toUpperCase()) >= 0 ) ){
	                // the small element is copied to 'result' variable.
	                // delete the copied one(a first element) in the sublist.
	                System.debug('START applyCustomeSorting ==================== DATA :'+String.valueOf(list1.get(0).result.get('description')));
	                result.add(list1.get(0));
	                list1.remove(0);
	            }
	            else{
	                // same operation as the above(in the right sublist).
	                System.debug('START applyCustomeSorting ==================== DATA :'+String.valueOf(list2.get(0).result.get('description')));
	                result.add(list2.get(0));
	                list2.remove(0);
	            }
	        }
	        else if( list1.size() > 0){
	            // copy all of remaining elements from the sublist to 'result' variable, when there is no more element to compare with.
	            System.debug('START applyCustomeSorting ==================== DATA :'+String.valueOf(list1.get(0).result.get('description')));
	            result.add(list1.get(0));
	            list1.remove(0);
	        }
	        else if( list2.size() > 0){
	            // same operation as the above(in the right sublist).
	            System.debug('START applyCustomeSorting ==================== DATA :'+String.valueOf(list2.get(0).result.get('description')));
	            result.add(list2.get(0));
	            list2.remove(0);
	        }
 			}	
	    // return the result of the merged sublists(or completed one, finally).
	    // the length of the left and right sublists will grow bigger and bigger, after the next call of this function.
	    System.debug('END applyCustomeSorting ==================== R_OrdertBy :'+R_OrdertBy);
	    return result;
 		}
		// End Changes for DE636 - Basant
		
    public List<AggregateResult> contentDownloadShare {
    	get{
    		List<AggregateResult> ret = new List<AggregateResult>();
    		if(isDetails){
				ret.addAll(sectionContent);
    		} else {
    			for(List<AggregateResult> ars : contentMap.values()){
    				ret.addAll(ars);
    			}
    		}
    		return ret;
    	} 
    }
    
    public List<AggregateResult> sectionContent {get; protected set;}
    public List<AggregateResultHolder> sectionContentHolder {
    	get {
    		List<AggregateResultHolder> contentHolder1 = new List<AggregateResultHolder>();
    		if(sectionContent!=null){
	    		for(AggregateResult ar : sectionContent){
	    			AggregateResultHolder tmp = new AggregateResultHolder();
	    			tmp.result = ar;
	    			contentHolder1.add(tmp);
	    		}
    		}
    		return contentHolder1;
    	}
    	set;
    }
    
	public List<String> sectionOrder {get; protected set;}
	public map<string, integer> sectionItemNumber {get; protected set;}
 	public Integer totalItemNumber {get; protected set;}
    public String currentSection {get; set;}
    public Boolean isDetails {get; set;}
    public Boolean firstZeroResult {get; set;}
    public String R_OrdertBy {get; set;}
    public Boolean secondZeroResult {get; set;}    
    protected String brandIdsString {get; protected set;}
 	protected transient map<string, string> sectionQuery {protected get; protected set;}
 	public String innovationSectionName {
 		get{
 			return (siteTheme == 'Spirits') ? (Constant.INNOVATION_AND_SUSTAINOVATION) : (Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE);
		}
		private set;
	}
     
    public Boolean R_MultInFollowWithselAll {get; set;}  
    
    public Controller_SearchResult() {
		pageUrl = Page.SearchResult.getUrl();
    	sectionQuery = new map<string, string>();
    	sectionItemNumber = new map<string, integer>();
    	sectionOrder = new List<String>();
    	sectionContent = new List<AggregateResult>();
    	contentMap = new map<string, List<AggregateResult>>();
    	currentSection = '';
    	searchValue = '';
    	isDetails = false;
    	totalItemNumber = 0;
		firstZeroResult = false;
		secondZeroResult = false;
		
		initQuery();
		initSections();				
		 
		try{
			if(ApexPages.currentPage().getParameters().get('query') != null && ApexPages.currentPage().getParameters().get('query') != ''){
				searchValue = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('query'), 'UTF-8');
				searchValue = searchValue.replaceAll('[^a-zA-Z0-9]',' '); // search for alphanumeric 
        		addBreadcrumbItem(Apexpages.currentPage().getUrl(), 'Search results for: ' + searchValue);				
			}
        } catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to load data from url. '));
			return;        
        }
        if(searchValue.length() < minNoOfChar){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Minimum length of search value is '+minNoOfChar+' chars. '));
			return;        
        }
     
        refreshPageContent();
    }

    // switch section
    public void switchSection() {
    	isDetails = true;
    	initPager();
    	refreshPageContent();
   }

    public void clearSection() {
    	isDetails = false;
    	sectionContent = new List<AggregateResult>();
    	refreshPageContent();
    	firstZeroResult = false;
    	secondZeroResult = false;
    }
    
    public PageReference userResearch(){
    	PageReference pr = ApexPages.currentPage();
    	String refine = '';
    	if(firstZeroResult || secondZeroResult){
    		refine = '&refine=true';
    	}
    	if(searchPhrase.length() != 0){
    		pr = new PageReference( Page.SearchResult.getUrl() + '?query='+EncodingUtil.urlEncode(searchPhrase,'UTF-8')+ refine );
    		pr.setRedirect(true);
    	}
    	return pr;
    }
    
	public void R_usersearchOrdertBy(){
    	refreshPageContent();
    }
    
        
    public override void refreshPageContent() {
    	try{
   	
    	initQuery();
 		if(isDetails){
		    String sectionQueryString = sectionQuery.get(currentSection);
		    if(sectionQueryString != null && sectionQueryString != ''){
				sectionContent = database.query(sectionQueryString+' limit 1000 ');
				numberOfItems = Integer.valueOf(sectionContent.size());
				sectionContent = getRequestedPage(sectionContent);
		    }
 		} else {   
			totalItemNumber = 0;
			
			Set<ID> brandIdsSet = new Set<Id>();
			List<ID> userBrands = new List<ID>(Service_API.getAccBrandIds());
			brandIdsSet = Service_API.getContentBrandIDs(userBrands);
			
			
			if(!brandIdsSet.isEmpty()){
				brandIdsString = IdSetToString(brandIdsSet);
				initQuery();
				List<AggregateResult> sectionResultList;
				String sectionQueryString = '';
		    	for(String sectionName : sectionOrder){
		    		sectionQueryString = sectionQuery.get(sectionName);
		    		sectionResultList = database.query(sectionQueryString+' limit '+limitPerSection);
			        if (isNewContent==false && sectionResultList!=null && sectionResultList.size()>0) {
				        for (AggregateResult currentItem : sectionResultList) {
				            String dateString = String.valueOf(currentItem.get('createdDate'));
				            DateTime itemTime = datetime.valueOf(dateString);
				            if(lastLoginDate < itemTime){
				                isNewContent = true;
				                break;
				            }   
				        }
			        }
					contentMap.put(sectionName, sectionResultList);
					totalItemNumber += sectionResultList.size();
		    		sectionItemNumber.put(sectionName, sectionResultList.size());
		    	}
			}
			Boolean isRefine = false;
			if(ApexPages.currentPage().getParameters().get('refine') != null && ApexPages.currentPage().getParameters().get('refine') != ''){
				isRefine = true;
			}
			if(totalItemNumber == 0 && !isRefine){
				firstZeroResult = true;
			}
			if(totalItemNumber == 0 && isRefine){
				secondZeroResult = true;
			}		
 		}
		
		currentBasketIds = Service_Basket.getBasketIds();
		currentFollowIds = Service_Notification.getFollowIds();
    	} catch(Exception ex){
    		Apexpages.addmessage(new apexpages.message(apexpages.severity.info, ex.getMessage()+' '+ex.getStackTraceString()));
    	}
    	
    	// Start Changes for DE636 - Basant
    	if(currentUserPage().equalsIgnoreCase('/apex/R_SearchResult')){
    		responsiveRefresh();
    	}
    	// End Changes for DE636 - Basant
    }
		
    private String IdSetToString(Set<ID> valueList){
    	String result = '';
    	String glue = '';
		for (String value : valueList) {         
			result += glue + '\''+value+'\' ';
			glue = ',';
		}    	
    	return result;
    }

    private String IdSetToString(Set<String> valueList){
    	String result = '';
    	String glue = '';
		for (String value : valueList) {         
			result += glue + '\''+value+'\' ';
			glue = ',';
		}    	
    	return result;
    }

    private void initSections(){
    	sectionOrder = new List<string>();
    	sectionOrder.add(CONSTANT.MONTHLY_EXECUTION_PLAN);
		sectionOrder.add(innovationSectionName);
    	sectionOrder.add(CONSTANT.SELLING_MATERILAS);
		sectionOrder.add(CONSTANT.CATEGOTY_DEVELOPMENT);
    	sectionOrder.add(CONSTANT.BRAND_MARKETING_INFORMATION);
		sectionOrder.add(CONSTANT.PRODUCT_IMAGES_AND_LOGOS);
    	sectionOrder.add(CONSTANT.COLLABORATION);
		if(isInternalUser){
			sectionOrder.add(CONSTANT.PLANNING);
		}
    	sectionOrder.add(CONSTANT.MULTICULTURAL);		
		
    	contentMap = new Map<string, List<AggregateResult>>();
		sectionItemNumber = new map<string, integer>();
    	for(String sectionName : sectionOrder){
    		contentMap.put(sectionName, new List<AggregateResult>());
    		sectionItemNumber.put(sectionName, 0);    		
    	}
    }

     
    
     private void initQuery(){
    	
    	sectionQuery = new map<string, string>();
    	
		Set<Id> currentDistributors = Service_API.getAIDs();
		Set<String> currentDivisions  = Service_API.getDivisions();
		String currentDistributorsString = IdSetToString(currentDistributors);
		String currentDivisionsString = IdSetToString(currentDivisions);
		
		String ids = ''; // SOSL extra ids
		String searchValDec = EncodingUtil.urlDecode(searchValue, 'ASCII');

		/*
		// CURRENTLY TURN OFF 
		if(searchValue.length()>1){
			//SOSL QUERY FOR IDS
			List<List<SObject>> similar = [FIND :searchValDec IN ALL FIELDS RETURNING ContentVersion(Id)];
			String glue = '';
			for (SObject value : similar.get(0)) {         
				ids += glue + '\''+value.id+'\' ';
				glue = ',';
			} 
		}
		*/
		/* Start: changes for R_SearchResult page Harish Khatri(Appirio Offshore) */ 
		searchValue = searchValDec;
		// BMI SEARCH			    	
		String queryBMI    	= ' SELECT Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, content_description__r.Tags__c tag, content_description__r.is_video__c is_video, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, content_description__r.Content_Version_Id_Low__c cvidlow, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' 
	 	 		   		  	+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and Category__c in (\''+CONSTANT.BRAND_MARKETING_INFORMATION+'\') '
   						   	+ ' AND (content_description__r.Content_Id__c in ('+brandIdsString+') OR ( content_description__r.Portfolio__c=true and content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') ) ) '
				   		   	+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
				           	+ ' GROUP BY Sub_Category__c, Sub_Sub_Category__c, content_description__r.Tags__c, Sub_Sub_Sub_Category__c, content_description__r.is_video__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.Content_Version_Id_Low__c, content_description__r.image_resolution__c  '+ 
				           	//+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c ASC' ;
				           	+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c ' + (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.BRAND_MARKETING_INFORMATION, queryBMI);
		
		// SM SEARCH
		String querySM     	= ' SELECT Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, content_description__r.Tags__c tag, content_description__r.is_video__c is_video, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, content_description__r.Content_Version_Id_Low__c cvidlow, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' 
 		           		   	+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and Category__c in (\''+CONSTANT.SELLING_MATERILAS+'\') '
			 	   		   	+ ' AND (content_description__r.Content_Id__c in ('+brandIdsString+') OR ( content_description__r.Portfolio__c=true and content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') ) ) '
       				 	   	+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
		        		   	+ ' GROUP BY Sub_Category__c, Sub_Sub_Category__c, content_description__r.Tags__c, Sub_Sub_Sub_Category__c, content_description__r.is_video__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.Content_Version_Id_Low__c, content_description__r.image_resolution__c  '+ 
		        	       	//+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c ASC';
		        	       	+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c ' + (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.SELLING_MATERILAS, querySM);

		// MEP SEARCH
		String queryMEP    	= ' SELECT content_description__r.is_video__c is_video, content_description__r.Tags__c tag, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.Content_Version_Id_Low__c cvidlow, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' + 
		               		+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and category__c=\''+Constant.MONTHLY_EXECUTION_PLAN+'\' AND content_description__r.Content_Id__c in ('+brandIdsString+') '
		               		+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\') )' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
		               		+ ' GROUP BY content_description__r.is_video__c, content_description__r.Tags__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.Content_Version_Id_Low__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.image_resolution__c  '+ 
		               		//+ ' ORDER BY content_description__r.Description__c ASC';
		               		+ ' ORDER BY content_description__r.Description__c ' + (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.MONTHLY_EXECUTION_PLAN, queryMEP);
		
		// IVAP SEARCH
		String queryIVAP   	= ' SELECT content_description__r.is_video__c is_video, content_description__r.Tags__c tag, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.Content_Version_Id_Low__c cvidlow, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' + 
		               		+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and category__c=\''+innovationSectionName+'\' AND content_description__r.Content_Id__c in ('+brandIdsString+') '
		               		+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
		               		+ ' GROUP BY content_description__r.is_video__c, content_description__r.Tags__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.Content_Version_Id_Low__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.image_resolution__c  '+ 
		               		//+ ' ORDER BY content_description__r.Description__c ASC';
		               		+ ' ORDER BY content_description__r.Description__c '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(innovationSectionName, queryIVAP);
		
		// PIL SEARCH
  		String queryPIL    	= ' SELECT content_description__r.is_video__c is_video, content_description__r.Tags__c tag, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.Content_Version_Id_Low__c cvidlow, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' + 
		               		+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and category__c=\''+Constant.PRODUCT_IMAGES_AND_LOGOS+'\' AND content_description__r.Content_Id__c in ('+brandIdsString+') '
		               		+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
		               		+ ' GROUP BY content_description__r.is_video__c, content_description__r.Tags__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.Content_Version_Id_Low__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.image_resolution__c  '+ 
		               		//+ ' ORDER BY content_description__r.Description__c ASC';
		               		+ ' ORDER BY content_description__r.Description__c  '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.PRODUCT_IMAGES_AND_LOGOS, queryPIL);

		// CD SEARCH
		String queryCD     	= ' SELECT Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, content_description__r.Tags__c tag, content_description__r.is_video__c is_video, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, content_description__r.Content_Version_Id_Low__c cvidlow, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' 
 		           		   	+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and Category__c in (\''+CONSTANT.CATEGOTY_DEVELOPMENT+'\') '
			 	   		   	+ ' AND (content_description__r.Content_Id__c in ('+brandIdsString+') OR ( content_description__r.Portfolio__c=true and content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') ) ) '
       				 	   	+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
		        		   	+ ' GROUP BY Sub_Category__c, Sub_Sub_Category__c, content_description__r.Tags__c, Sub_Sub_Sub_Category__c, content_description__r.is_video__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.Content_Version_Id_Low__c, content_description__r.image_resolution__c  '+ 
		        	       //	+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c ASC';	
		        	       	+ ' ORDER BY Sub_Sub_Sub_Category__c, content_description__r.Description__c '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;					
		sectionQuery.put(CONSTANT.CATEGOTY_DEVELOPMENT, queryCD);
		
		// COLLABORATION SEARCH
		String queryCOL    	= ' SELECT Content_Version_Id__c cvid,  Tags__c, Description__c description, filesize__c filesize, filetype__c filetype, Title__c  title, is_video__c is_video, video_id__c video_id, max(Uploaded_date__c) createdDate, image_resolution__c imageRes, OwnerId ' 
		  			  	    + ' FROM File__c '
		  			  	// Start : Changes for DE635 - Basant Verma
						    + ' WHERE Classification__c includes (\''+Service_API.getSectionTheme()+'\') and Page_Section__c = \''+CONSTANT.COLLABORATION+'\' and (( Distributors__c includes ('+currentDistributorsString+') ' + ((currentDivisionsString != null && !currentDivisionsString.trim().equals('')) ? ' or Division_Access__c in ('+currentDivisionsString+')' : '') + ' ) ';
						    // END : Changes for DE635 - Basant Verma
							if(isInternalUser){
								queryCOL += ' or ( Distributors__c = null or Division_Access__c = null ) ';
							}   
			   queryCOL    += ' ) ' 
		               		+ ' AND (((Title__c like \'%'+searchValue+'%\' OR Description__c like \'%'+searchValue+'%\' OR Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? 'OR (content_version_id__c in ('+ids+')))  '  : ')' )+			
							+ ' GROUP BY Content_Version_Id__c, Tags__c, video_id__c,  Description__c, image_resolution__c, filesize__c, filetype__c, Title__c, is_video__c, OwnerId' +
							//+ ' ORDER BY Description__c ASC';	
							+ ' ORDER BY Description__c  '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.COLLABORATION, queryCOL);
		system.debug('DNAMES x'+currentDivisionsString+'x');
		
		// PLANNING SEARCH
		String queryPLN    	= ' SELECT  Content_Version_Id__c cvid, Description__c description, Tags__c, filesize__c filesize, filetype__c filetype, Title__c  title, is_video__c is_video, video_id__c video_id, Preview_Available__c previewAvailable, Preview_Id__c previewId, max(Uploaded_date__c) createdDate, image_resolution__c imageRes ' + 
		               		+ ' FROM File__c ' +
		               		+ ' WHERE Classification__c includes (\''+Service_API.getSectionTheme()+'\') and ( Available_Until__c >= TODAY or Available_Until__c = null) and (Page_Section__c = \'' + CONSTANT.PLANNING + '\' ) ' +
							+ ' AND (((Title__c like \'%'+searchValue+'%\' OR Description__c like \'%'+searchValue+'%\' OR Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? 'OR (content_version_id__c in ('+ids+')))  '  : ')' )+
		           	   		+ ' GROUP BY Tags__c, video_id__c, Content_Version_Id__c, Description__c, filesize__c, filetype__c, Title__c, is_video__c, Preview_Available__c, Preview_Id__c, image_resolution__c ' +
		           	   		//+ ' ORDER BY Description__c ASC';
		           	   		+ ' ORDER BY Description__c '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.PLANNING, queryPLN);
		
		String queryMUL    	= ' SELECT Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, content_description__r.Tags__c, content_description__r.is_video__c is_video, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, content_description__r.Content_Version_Id_Low__c cvidlow, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c' 
	 	 		   		  	+ ' WHERE content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') and Category__c in (\''+CONSTANT.MULTICULTURAL+'\') '
   						   	+ ' AND (content_description__r.Content_Id__c in ('+brandIdsString+') OR ( content_description__r.Portfolio__c=true and content_description__r.Classification__c includes (\''+Service_API.getSectionTheme()+'\') ) ) '
				   		   	+ ' AND (((content_description__r.Title__c like \'%'+searchValue+'%\' OR content_description__r.Description__c like \'%'+searchValue+'%\' OR content_description__r.Tags__c like \'%'+searchValue+'%\'))' + ((ids!='') ? ' OR (content_description__r.content_version_id__c in ('+ids+') OR content_description__r.content_version_id_low__c in ('+ids+'))) ' : ')') +
				           	+ ' GROUP BY Sub_Category__c, content_description__r.Tags__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, content_description__r.is_video__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.Content_Version_Id_Low__c, content_description__r.image_resolution__c  '+ 
				           	//+ ' ORDER BY content_description__r.Description__c ASC';
				           	+ ' ORDER BY content_description__r.Description__c '+ (R_OrdertBy != null && R_OrdertBy.trim() != '' ? R_OrdertBy+' ' : 'ASC ') ;
		sectionQuery.put(CONSTANT.MULTICULTURAL, queryMUL);
		/* End: changes for R_SearchResult page Harish Khatri(Appirio Offshore) */ 		
    }

        
}