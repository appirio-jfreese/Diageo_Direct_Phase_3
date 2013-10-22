@isTest
private class Test_Controller_BeerPlanning {
	static User u;
	static Folder__c folderParent;
	static Folder__c folderChild;
	static File__c fileContent;
	static Calendar__c cal;
	static testMethod void testAsDiageoPortalUser() {
        createTestData();
		PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
    	
 		Test.StartTest();

        String section = folderParent.ID;
		String subSection = folderChild.ID;
		
		ApexPages.currentPage().getParameters().put('section', section);
		ApexPages.currentPage().getParameters().put('subsection', subSection);
		ApexPages.currentPage().getParameters().put('displayas', 'box');
		Apexpages.currentPage().getParameters().put('date', String.valueOf(date.today()));
        ApexPages.currentPage().getParameters().put('toggledTheme','Beer');
	    System.runAs(u){
			Controller_BeerPlanning controller = new Controller_BeerPlanning();
			System.assertEquals(controller.currentSection, section);
			//System.assertEquals(controller.currentSubSection, subSection);
			System.assertEquals(controller.requestedFolder, folderChild.ID);
			System.assertEquals(true,controller.contentHolderMap!=null);
			System.assertEquals(true,controller.headers!=null);
			controller.detailId =  cal.Id; 
	    	controller.showDetails();
	    	System.assertEquals(true, controller.detailsHolderMap != null);
	    	
	    	controller.setStartDateValue();
	    	controller.switchToMonthView();
	    	controller.nextMonth();
	    	controller.nextPeriod();
	    	controller.previousPeriod();
	    	controller.selectedTimePeriods='1,2,3';
	    	controller.changeFilter();
	    	controller.switchToQuarterView();
	    	controller.previousMonth();
	    	controller.getTimePeriods();
	    	controller.getSalesDrivers();
	    	controller.renderAsListSlider();
	    	controller.renderAsBoxSlider();
	    	controller.nextPeriod();
	    	controller.previousPeriod();
	    	controller.selectedTimePeriods='1,2';
	    	System.assertEquals(controller.parentBrandList.size()>0 , true);
			controller.selectedBrandIds = controller.parentBrandList[0].Id;
			controller.selectedRTS = true;
			controller.selectedPortfolio = true;
			controller.changeFilter();
	    	
	    	
		}				
 		Test.StopTest();   	
    }
    
	static testmethod void testRenderType(){
		createTestData();
		folderChild.Layout_Type__c =CONSTANT.PLANNING_CALENDAR;
		update folderChild;
		PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
        
 		Test.StartTest();
 		ApexPages.currentPage().getParameters().put('section', folderParent.ID);
 		ApexPages.currentPage().getParameters().put('time', '3');
 		ApexPages.currentPage().getParameters().put('driver', 'Planning');
        
	    System.runAs(u){
			Controller_BeerPlanning controller = new Controller_BeerPlanning();
			controller.renderAsList();
			System.assertEquals(controller.displayAsList , true);
			
			controller.renderAsBox();
			System.assertEquals(controller.displayAsList , false);
			controller.updateVariantBrands();
			System.assertEquals(controller.parentBrandList.size()>0 , true);
			controller.parentId = controller.parentBrandList[0].Id;
			controller.updateVariantBrands();
			controller.resetFilter();
	    	controller.clearDetailsCalendar();
	    	controller.clearVariantBrandsSelected();
	    	controller.clearVariantBrands();
	    	controller.selectSalesDriver();
	    }
 		Test.StopTest();
	}

	static testmethod void testSwitchSections(){
        createTestData();
        PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
        
 		Test.StartTest();
 		
        //ApexPages.currentPage().getParameters().put('section', folderParent.ID);
		ApexPages.currentPage().getParameters().put('toggledTheme','Beer');
	    ApexPages.currentPage().getParameters().put('toggled','true');
	    ApexPages.currentPage().getParameters().put('toggledThemeDef','Beer');
	    
		
	    System.runAs(u){
			Controller_BeerPlanning controller = new Controller_BeerPlanning();
			System.assertEquals(true, controller.sectionFolders.dirs.size()>1);
			controller.currentSection = controller.sectionFolders.dirs[1].folderId;
			System.assertEquals(controller.requestedFolderName, controller.sectionFolders.dirs[1].folderName);
			
			controller.switchSection();
			System.assertEquals(controller.requestedFolderName, controller.subSectionFolders.dirs[0].folderName);
			System.assertEquals(true, controller.subSectionFolders.dirs.size()>1);
			controller.currentSubSection = controller.subSectionFolders.dirs[1].folderId;
			controller.switchSubSection();
			
	    }
 		Test.StopTest();
	}
	
	
	static void createTestData(){
		Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'divisionName');
        insert division;
        
    	Account a = Test_Helper.testGetDiageoAccount();
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        u = Test_Helper.testInsertDiageoPortalUser(c.ID);
         		
		folderParent = Test_Helper.testInsertFolder(false, false, null, true, true, CONSTANT.PLANNING, null, null);
		folderParent.Classification__c = 'Beer';
		update folderParent;
		folderChild = Test_Helper.testInsertFolder(false, false, null, true, true, CONSTANT.PLANNING, folderParent.ID, null);
		folderChild.Classification__c = 'Beer';
		//folderChild.Layout_Type__c =CONSTANT.PLANNING_CALENDAR;
		update folderChild;
		fileContent = Test_Helper.testInsertFile(folderChild.ID, Constant.PLANNING, division.name, division.Id, null);
		cal = Test_Helper.testInsertPCalendar('test1','test1 desc', date.today(), date.today().addDays(10));
        cal.Folder__c =folderChild.id;
        cal.Classification__c = 'Beer';
		update cal;
		
        File__c file = Test_Helper.testInsertFile(folderChild.Id, Constant.PLANNING, cal, division); 
		//file.Classification__c = 'Beer';
		//update file;
		
	}
}