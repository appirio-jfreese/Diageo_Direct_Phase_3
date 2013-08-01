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
	public List<Integer> yearList {get; set;}
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
    	/*List<Map<String, String>> currYrQuarterViewsList = quarterViewsList;
    	quarterViewsList = new List<Map<String, String>>();
    	List<Map<String, String>> currYrMonthViewsList = monthViewsList;
    	for(Integer i =-1;i<2;i++){
    		for(Map<String, String> qtr : currYrQuarterViewsList){
    			Integer year = Integer.valueOf(qtr.get('year'));
				Integer fiscalYear = Integer.valueOf(qtr.get('fiscalYear'));
				year += i;
				quarterViewsList.add(new Map<String, String>{'value' => qtr.get('value'), 'className' => qtr.get('className'),'year' => String.valueOf(year), 'fiscalYear' => String.valueOf(fiscalYear) });
			}
    		for(Map<String, String> mnth : currYrMonthViewsList){
				Integer year = Integer.valueOf(mnth.get('year'));
				Integer fiscalYear = Integer.valueOf(mnth.get('fiscalYear'));
				monthViewsList.add(new Map<String, String>{'value' => mnth.get('value'), 'className' => mnth.get('className'),'year' => string.valueOf(year), 'fiscalYear' => String.valueOf(fiscalYear), 'monthName' => mnth.get('monthName') });
				
			}
    	}*/
    	List<Map<String, String>> currYrQuarterViewsList = quarterViewsList;
    	List<Map<String, String>> nextYrQuarterViewsList = new List<Map<String, String>>();
    	quarterViewsList = new List<Map<String, String>>();
    	List<Map<String, String>> currYrMonthViewsList = monthViewsList;
    	List<Map<String, String>> nextYrMonthViewsList = new List<Map<String, String>>();
    	monthViewsList = new List<Map<String, String>>();
    	for(Map<String, String> qtr : currYrQuarterViewsList){
			Integer year = Integer.valueOf(qtr.get('year'));
			year--;
			Map<String, String> qtr1 = new Map<String, String>{'value' => qtr.get('value'), 'className' => qtr.get('className'),'year' => String.valueOf(year), 'fiscalYear' => qtr.get('fiscalYear') };
			//qtr1.put('year',''+currYr);
			quarterViewsList.add(qtr1);
			
		}
		for(Map<String, String> qtr : currYrQuarterViewsList){
			Integer year = Integer.valueOf(qtr.get('year'));
			year ++;
			Map<String, String> qtr1 = new Map<String, String>{'value' => qtr.get('value'), 'className' => qtr.get('className'),'year' => String.valueOf(year), 'fiscalYear' => qtr.get('fiscalYear') };
			//qtr.put('year',''+currYr);
			nextYrQuarterViewsList.add(qtr);
			
		}
		for(Map<String, String> mnth : currYrMonthViewsList){
			Integer year = Integer.valueOf(mnth.get('year'));
			year--;
			
			//mnth.put('year',''+(currYr));
			monthViewsList.add(new Map<String, String>{'value' => mnth.get('value'), 'className' => mnth.get('className'),'year' => string.valueOf(year), 'fiscalYear' => mnth.get('fiscalYear'), 'monthName' => mnth.get('monthName') });
		}
		for(Map<String, String> mnth : currYrMonthViewsList){
			Integer year = Integer.valueOf(mnth.get('year'));
			year++;
			//mnth.put('year',''+(currYr));
			nextYrMonthViewsList.add(new Map<String, String>{'value' => mnth.get('value'), 'className' => mnth.get('className'),'year' => string.valueOf(year), 'fiscalYear' => mnth.get('fiscalYear'), 'monthName' => mnth.get('monthName') });
		}
		monthViewsList.addAll(currYrMonthViewsList);
		monthViewsList.addAll(nextYrMonthViewsList);
		
		quarterViewsList.addAll(currYrQuarterViewsList);
		quarterViewsList.addAll(nextYrQuarterViewsList);
		
    	/*yearList = new List<Integer>();
    	yearList.add( calendar.startDate.year()-1);
    	yearList.add( calendar.startDate.year());
    	yearList.add( calendar.startDate.year()+1);
    	//past year
    	calendar.incrementYear(-1);
		quarterShift -= 4;
		calendarMonthView.incrementYear(-1);
		monthShift -= 12;
		system.debug('1...calendar.startDate:::'+calendar.startDate+' !! calendar.fiscalYear::'+calendar.fiscalYear);
		quarterViewsList = Service_UserInput.getQuarterOptions(calendar.fiscalQuarter, calendar.fiscalYear, calendar.startDate);
   		monthViewsList = Service_UserInput.getMonthsOptions(calendarMonthView);
   		//current year
   		calendar.incrementYear(1);
		quarterShift += 4;
		calendarMonthView.incrementYear(1);
		monthShift += 12;
		system.debug('1...quarterViewsList :::'+quarterViewsList);
		system.debug('2...calendar.startDate:::'+calendar.startDate+' !! calendar.fiscalYear::'+calendar.fiscalYear);
		quarterViewsList.addAll(Service_UserInput.getQuarterOptions(calendar.fiscalQuarter, calendar.fiscalYear, calendar.startDate));
   		monthViewsList.addAll(Service_UserInput.getMonthsOptions(calendarMonthView));
   		//future year
		calendar.incrementYear(1);
		quarterShift += 4;
		calendarMonthView.incrementYear(1);
		monthShift += 12;
		system.debug('2...quarterViewsList :::'+quarterViewsList);
		system.debug('3...calendar.startDate:::'+calendar.startDate+' !! calendar.fiscalYear::'+calendar.fiscalYear);
		quarterViewsList.addAll(Service_UserInput.getQuarterOptions(calendar.fiscalQuarter, calendar.fiscalYear, calendar.startDate));
   		monthViewsList.addAll(Service_UserInput.getMonthsOptions(calendarMonthView));
   		system.debug('3...quarterViewsList :::'+quarterViewsList);
		system.debug('...quarterViewsList size:::'+quarterViewsList.size());
		*/
			
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