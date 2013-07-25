/*******************************************************************************
Name        : Service_FilterSection.cls
Created By  : Geeta kumawat (Appirio Offshore)   
Date        : 7/12/13
Description : controller class for R_Filters.component 
*******************************************************************************/
public with sharing class Service_FilterSection {
	
// brands
	public List<Brand__c> parentBrandList {get; set;}
	public List<Brand__c> additionalBrandList{get; set;}
	public List<Brand__c> childBrandList {get; set;}
    public Integer brandBoxToRender {get;set;}
	public String parentId {get; set;}
	public String siteTheme {get; set;}
	public String currentSection {get; set;}
    public String selectedBrandIds {get; set;}
    public String selectedChildBrandIds {get; set;} 
    public String selectedBrandName {get; set;}
    
     // time period
	// calendar
    protected Service_Calendar calendar;
    protected Service_Calendar calendarMonthView;
	public List<Map<String, String>> quarterViewsList {public get; public set;}
	public List<Map<String, String>> monthViewsList {public get; public set;}
    public String selectedTimePeriods {get; set;}
	protected List<Integer> selectedTimePeriodsList {protected get; protected set;}
    public Integer quarterShift {public get; public set;}
    protected Integer currentQtr {protected get; protected set;}
    public Integer monthShift {public get; public set;}
    protected Integer currentMTH {protected get; protected set;}
    public Boolean monthOrQuarterRender {get; set;} // true = Quarter
   
    //classification
    public String[] selectedClassificationItemsRow1 {get;set;}
    public String[] selectedClassificationItemsRow2 {get;set;}
    
    //brand categories
    public List <SelectOption> brandCategories {get;set;}
    public String selectedBrandCategories {get;set;}
    public String allCategoriesString {get;set;}
    
    public Service_FilterSection(){
    	selectedBrandIds = '';
    	parentId = '';
    	selectedChildBrandIds = '';
    	selectedTimePeriods = '';
    	if(SiteTheme != 'Wine') {
        	brandBoxToRender = 21;
        } else {
        	brandBoxToRender = 23;
        }
    	initBrandCategories();
    	initParentBrands();
    	// get time periods
		monthOrQuarterRender = true;
        calendar = new Service_Calendar();
		calendar.initDateRange(3, null);	// quarter view
		calendarMonthView = new Service_Calendar();
		calendarMonthView.initDateRange(1, null);
		currentQtr = calendar.fiscalQuarter;
		currentMth = calendarMonthView.fiscalMonth;
		quarterShift = 0;
		monthShift = 0;
    	initTimePeriodsComp();
    }
	
	public void resetFilter(){
		selectedBrandIds = '';
    	parentId = '';
    	selectedTimePeriods = '';
    	selectedChildBrandIds = '';    	
    	childBrandList = new list<Brand__c>();
		selectedClassificationItemsRow1 = new String[]{};
		selectedClassificationItemsRow2 = new String[]{};
		selectedBrandCategories = '';
		
	}
	//Method to get Next Period for selected Month or Quarter
    public void nextPeriodComp() {
    	if(monthOrQuarterRender){//quarter
			calendar.incrementQuarter(1);
			quarterShift++;
			selectedTimePeriods = '';
			initTimePeriodsComp();
		} else {//month
			calendarMonthView.incrementMonth(3);
			monthShift = monthShift + 3;
			selectedTimePeriods = '';
			initTimePeriodsComp();
		}
  	}
    
    //Method to get Previous Period for selected Month or Quarter
    public void previousPeriodComp() {
		if(monthOrQuarterRender){
			calendar.incrementQuarter(-1);
			quarterShift--;
			selectedTimePeriods = '';
			initTimePeriodsComp();
		} else {
			calendarMonthView.incrementMonth(-3);
			monthShift = monthShift - 3;
			selectedTimePeriods = '';
			initTimePeriodsComp();
		}
	}
	//Method to initilize time Period for Month and Quarter
    private void initTimePeriodsComp() {
		quarterViewsList = Service_UserInput.getQuarterOptions(calendar.fiscalQuarter, calendar.fiscalYear, calendar.startDate);
   		monthViewsList = Service_UserInput.getMonthsOptions(calendarMonthView);
    }
    
    //Method to initialize Parent brands
    public void initParentBrands(){
		String[] categoryList = (selectedBrandCategories != null &&  selectedBrandCategories != '') ? selectedBrandCategories.split(',') : null;
		parentBrandList = Service_API.getBrandsForFilters(categoryList);
		
		Set<Id> setOfBrands = new Set<Id>();
		Integer i = 0;
		for(Brand__c brand : parentBrandList)
		{
			setOfBrands.add(brand.id);
			i++;
			if(i == brandBoxToRender)
			{
				break;
			}
		}
		
		if(i > 0){
			additionalBrandList = Service_API.getAdditionalBrandsForFilters(setOfBrands, categoryList);
		}
		
		 childBrandList = new list<Brand__c>();		
	}
	
	//Method to get Variant brand for selected Parent brand
	public void updateVariantBrands() {
    	if(parentId != null && parentId != ''){
    		selectedBrandIds = (selectedBrandIds!=null && selectedBrandIds.trim() != '') ? ','+parentId: parentId; 
			childBrandList = Service_API.getChildBrands(parentId);
    		selectedChildBrandIds = '';
			selectedBrandName = [select Name from Brand__c where id = :parentId].Name;    		
		} else {
			childBrandList = new list<Brand__c>();
    		selectedChildBrandIds = '';
			parentId = '';	
    	}
	}
	
	//Method to initialize brand Categories
    private void initBrandCategories(){
    	brandCategories = Service_UserInput.getBrandCategories(false);
    	
    	String glue ='';
    	allCategoriesString = '';
    	for(SelectOption bc : brandCategories){
    		allCategoriesString += glue + bc.getValue();
    		glue = ',';
    	}
    }
    
    
}