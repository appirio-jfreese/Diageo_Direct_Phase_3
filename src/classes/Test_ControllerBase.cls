/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ControllerBase {

    static testMethod void isInternalUserTest() {
        Account a = Test_Helper.testInsertAccount('Test Account');
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u; 
        System.runAs (thisUser) {
            u = Test_Helper.testInsertDistributorPortalUser(c.ID);
        }
                
        Test.StartTest();
        System.runAs(u){
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            System.assertEquals(bController.isInternalUser, false);
        }
        Test.StopTest();
    }    

    static testMethod void userShareOverviewTest() {
        Content_Description__c cDescription = Test_Helper.testInsertContentDescription();

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);
        
        Controller_Base bController = new Controller_Base();

        bController.cVersionId = cDescription.Content_Version_Id__c;
        bController.userShareOverview();
        System.assertEquals(bController.cDescr, cDescription.Description__c);
        System.assertEquals(bController.cVideoId, cDescription.Video_Id__c);
        System.assertEquals(bController.cIsVideo, cDescription.Is_Video__c);
        System.assertEquals(bController.cIsPreview, cDescription.Preview_Available__c);
        System.assertEquals(bController.cPreviewId, cDescription.Preview_Id__c);
        System.assertEquals(bController.cShareLink, cDescription.share_link__c);
        
        Test.StopTest();
    }
    
    static testMethod void showLastPageTest() {

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        bController.showLastPage();
        System.assertEquals(bController.numberOfCurrentPage, bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage <= bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage >= 1);        
        Test.StopTest();
    }
    
    static testMethod void showFirstPageTest() {

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        bController.showFirstPage();
        System.assertEquals(bController.numberOfCurrentPage, bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage <= bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage >= 1);        
        Test.StopTest();
    }
    
    static testMethod void showPrevPageTest() {

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        bController.showPrevPage();
        System.assertEquals(bController.numberOfCurrentPage, bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage <= bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage >= 1);        
        Test.StopTest();
    }
    
    static testMethod void showNextPageTest() {

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        Integer actualPage = bController.numberOfCurrentPage;
        bController.numberOfPages = 2;
        bController.showNextPage();
        System.assertEquals(bController.numberOfCurrentPage, actualPage+1);
        System.assert(bController.numberOfCurrentPage <= bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage >= 1);
                
        Test.StopTest();
    }
    
    static testMethod void showPageRequestedTest() {

        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        Integer actualPage = bController.numberOfCurrentPage;
        bController.showPageRequested();
        System.assert(bController.numberOfCurrentPage <= bController.numberOfPages);
        System.assert(bController.numberOfCurrentPage >= 1);        
        
        Test.StopTest();
    }

    static testMethod void getRequestedPageTest() {
        
        Test.StartTest();

        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        bController.showFromIndex = 0;
        bController.showToIndex = 0;
        list<sobject> request = new list<sobject>();
        list<sobject> result = bController.getRequestedPage(request);
        System.assert(bController.showFromIndex <= bController.showToIndex);
        System.assert(bController.showFromIndex - bController.showToIndex <= result.size());
        
        Test.StopTest();    
    }
    
    static testMethod void pageNumbersTest() {
        
        Test.StartTest();
        
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);

        Controller_Base bController = new Controller_Base();
        bController.numberOfItems = 24;
        System.assertEquals(bController.numberOfPages, bController.pageNumbers.size());
        
        Test.StopTest();    
    }
    
    static testMethod void lastLoginTest() {
        
        
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }   
        
        System.RunAs(user){
            user.loginDate__c = datetime.valueOf('2008-12-01 12:00:00');
            update user;
            Test.StartTest();
            
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            System.assertEquals(datetime.valueOf('2008-12-01 12:00:00'), bController.lastLoginDate );
            List<String> tmp = bController.distributorNames;
            
            Test.StopTest();    
        }
    }
    
    static testMethod void noOfItemsTest() {
        
        
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }        
        
        System.RunAs(user){
            user.loginDate__c = datetime.valueOf('2008-12-01 12:00:00');
            update user;
            Test.StartTest();
            
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            List<SelectOption> tmp = bController.getNumberOfItemsPerPageList();
            bController.numberOfItemsOnPage = 20;
            bController.changeNumberOfItemPerPage();
            
            Test.StopTest();    
        }
    }
    
    static testMethod void themesTest() {
        
        
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }       
        
        System.RunAs(user){
            user.loginDate__c = datetime.valueOf('2008-12-01 12:00:00');
            update user;
            Test.StartTest();
            
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            List<SelectOption> themes = bController.getSiteThemes();
            bController.siteTheme = 'Spirits';
            bController.changeSiteTheme();
            
            Test.StopTest();    
        }
    }
    
    static testMethod void searchTest() {
        
        
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }       
        
        System.RunAs(user){
            user.loginDate__c = datetime.valueOf('2008-12-01 12:00:00');
            update user;
            Test.StartTest();
            
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            String tmp = bController.getRandomId();
            bController.searchPhrase = 'abnc';
            bController.userSearch();
            
            Test.StopTest();    
        }
    }
    
    static testmethod void testFollowups(){
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }
        Content_Description__c cd = Test_Helper.testInsertContentDescription();
        
        System.RunAs(user){
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Controller_Base bController = new Controller_Base();
            bController.cVersionId = cd.id;
            bController.addToFollowMultiple();
            bController.addToFollow();
            bController.removeFromFollowMultiple();
            bController.removeFromFollow();
        }
    }

    static testmethod void testGetThemeString(){
        Account account = Test_Helper.testInsertAccount('test_account1');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user; 
        System.runAs (thisUser) {
            user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }     
 
 		Brand__c brand = Test_Helper.testInsertBrand('brand1');
 		Test_Helper.testInsertAccountBrand(account.id, brand.id);
 		       
        System.RunAs(user){
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
	        ApexPages.currentPage().getParameters().put('themetype1','Spirits');
            Controller_Base bController = new Controller_Base();
            system.assertEquals('Spirits', bController.themeOptionsString);
        }
    } 
    
    // Start : Code Covergae For Controller Base : Toggle Functionality
    static testmethod void testToggelAndMisc(){
    	User testUser = Test_Helper.generateTestUser('TUser', true, 'System Administrator');
    	Test.startTest();
    	System.runAs (testUser) {
 				PageReference pageRef = Page.HomePage;
 				Test.setCurrentPage(pageRef);
 				Controller_Base bController = new Controller_Base();
 				System.assert(bController.isNeedToggle);
 				bController.toggleToWine();
 				System.assertEquals(bController.clickedTheme, 'Wine');
 				
 				bController.toggleToSpirits();
 				System.assertEquals(bController.clickedTheme, 'Spirits');
 				
 				bController.planningTheme = 'Spirits';
 				pageRef = bController.openPlanningPage();
 				
 				bController.planningTheme = '';
 				pageRef = bController.openPlanningPage();
 				
 				bController.planningTheme = 'Wine';
 				pageRef = bController.openPlanningPage();
 				
 				bController.planningTheme = 'Spirits';
 				pageRef = bController.openPlanningPage();
 				Test.setCurrentPage(pageRef);
 				ApexPages.currentPage().getParameters().put('themetype1','Spirits');
 				System.assert(!bController.isNeedToggle);
 				//List<CheckboxOption> lst = bController.themeOptions;
 				
 				bController.siteTheme = 'Wine';
 				bController.changeCurrentSiteTheme();
 				System.assertEquals(bController.siteTheme, 'Wine');
 				bController.toggleToSpirits();
 				bController.toggleToWine();
 				
 				bController.siteTheme = '';
 				bController.changeCurrentSiteTheme();
 				System.assertNotEquals(ApexPages.getMessages(), null);
 				bController.siteTheme = 'Spirits';
 				bController.changeCurrentSiteTheme();
 				System.assertEquals(bController.siteTheme, 'Spirits');
 				bController.toggleToWine();
 				bController.toggleToSpirits();
 				
 				bController.changeListOrder();
 				
 				bController.siteTheme = '';
 				bController.changeSiteTheme();
 				System.assertNotEquals(ApexPages.getMessages(), null);
 				
 				bController.siteTheme = 'Spirits';
 				bController.openSpiritsPlanningPage();
 				
 				bController.siteTheme = 'Wine';
 				bController.openWinePlanningPage();
 				
 				String str = bController.avatarUrl;
 				
    	}
    	Test.stopTest();
    }
    // End : Code Covergae For Controller Base : Toggle Functionality
}