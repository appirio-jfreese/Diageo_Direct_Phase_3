@isTest
private class Test_Controller_SearchResult {
    
    static testmethod void testController(){
        PageReference pageRef = Page.SearchResult;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        Account a = Test_Helper.testInsertAccount('Test Account');
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u; 
        System.runAs (thisUser) {
            u = Test_Helper.testInsertDistributorPortalUser(c.ID);
        }
                
        Brand__c testBrand = new Brand__c();
        testBrand.Name = 'Test Brand1';
        insert testBrand;

        Test_Helper.testInsertAccountBrand(a.ID, testBrand.ID);     
        
        ApexPages.currentPage().getParameters().put('query', 'testquery');

        System.runAs(u){
            Controller_SearchResult controller = new Controller_SearchResult();
            System.assertEquals(controller.isDetails, false);
            controller.currentSection = Constant.BRAND_MARKETING_INFORMATION;

            controller.switchSection();
            System.assertEquals(controller.isDetails, true);
                        
            controller.clearSection();
            System.assertEquals(controller.isDetails, false);
            System.assertEquals(controller.firstZeroResult, false);
            System.assertEquals(controller.secondZeroResult, false);
            System.assertEquals(controller.sectionContent.size(), 0);
        }   

        Test.StopTest();
    }
}