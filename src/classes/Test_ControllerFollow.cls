/*******************************************************************************
Name        : Test_ControllerFollow.cls

Updated By  : Basant Verma (Appirio Offshore)   
Date        : 6/10/13
Description	: Test Class which provide code coverage for 
									Controller_Follow.cls and Service_Follow  
*******************************************************************************/
@isTest
private class Test_ControllerFollow {

    static testmethod void testFollow(){
        // insert test user data
        Account a = Test_Helper.testInsertAccount('Test Account');
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u;     
    
        System.runAs (thisUser) {
            u = Test_Helper.testInsertDistributorPortalUser(c.ID);
        }
        
        // insert test brands
        Brand__c brandA = Test_Helper.testInsertBrand('Test Brand A');
        
        // hook one of the parent brands too the user's account
        AccountBrand__c accBrand = Test_Helper.testInsertAccountBrand(a.ID, brandA.ID);
        
        // insert test content that looks up to the previoulsy inserted brands
        Content_Description__c contentA = Test_Helper.testInsertContentDescriptionExtended('rose');
        Content_Description__c contentB = Test_Helper.testInsertContentDescriptionExtended('orchid');
        Content_Description__c contentC = Test_Helper.testInsertContentDescriptionExtended('tulip');
        Content_Description__c contentD = Test_Helper.testInsertContentDescriptionExtended('Test');
        
        contentA.Content_Version_Id_Low__c = contentA.Content_Version_Id__c;
        contentA.Content_Version_Id__c = null;
        update contentA;
        
        
        // insert the join records between content and brand        
        ContentBrand__c cbA = Test_Helper.testInsertContentBrand(contentA.id, brandA.id);
        ContentBrand__c cbB = Test_Helper.testInsertContentBrand(contentB.id, brandA.id);
        ContentBrand__c cbC = Test_Helper.testInsertContentBrand(contentC.id, brandA.id);
        
        Content_Subscription__c sub = new Content_Subscription__c();
        sub.User__c = u.Id;
				sub.Content__c = contentD.Content_ID__c;
				insert sub;
        
        Test.startTest();

        PageReference pageRef = Page.FollowedItems;
        Test.setCurrentPage(pageRef);
                
        System.runAs(u){
            Controller_Follow cFollow = new Controller_Follow();
           
            System.assertEquals(0, Service_Follow.getNumberOfItems());
            
            // add single
            cFollow.cVersionId = contentB.Content_Version_Id__c;
            
            cFollow.addToFollow();
            System.assertEquals(1, Service_Follow.getNumberOfItems());
            
            //remove single
            cFollow.removeFromFollow();
            System.assertEquals(0 , Service_Follow.getNumberOfItems());
            
            // add multiple
            cFollow.cVersionIds = contentA.Content_Version_Id_Low__c+','+contentB.Content_Version_Id__c;
            cFollow.addToFollowMultiple();
            System.assertEquals(2, Service_Follow.getNumberOfItems());
            
            cFollow.refreshPageContent();
            
            //remove multiple
            cFollow.removeFromFollowMultiple();
            System.assertEquals(0, Service_Follow.getNumberOfItems());


            Service_Follow.getNumberOfItems();

            cFollow.showFirstPage();
            cFollow.showPrevPage();

            delete cbA;
            delete cbB;
            delete cbC;
            cFollow.refreshPageContent();
            cFollow.removeTrashFromFollowed();
            
        }
        
        Test.stopTest();
    }

}