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
private class Test_Service_FolderComments {


    static testMethod void addCommentMsgTest() {
        Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'Control', Type__c ='Spirits');
        insert division;
        Account a = Test_Helper.testInsertAccount('Test Account');
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        User u;
        System.runAs (thisUser) {
            u = Test_Helper.testInsertDistributorPortalUser(c.ID);
        }
        
        Folder__c folder = Test_Helper.testInsertFolder(true, true, division.Id, false, false, 'Collaboration', null, null);
        File__c file = Test_Helper.testInsertFile();
        
        Service_FolderComments fcService = new Service_FolderComments();
        fcService.commentBody = 'Test body';
        fcService.distributorId = a.ID;
        fcService.folderId = folder.Id;
        fcService.fileId = file.Id;
                        
        Test.StartTest();
            System.runAs(u){
                fcService.addCommentMsg();
                list<Folder_Comment__c> folderCommentListAfterAdd = Service_API.getFolderComments(a.id, folder.Id);

                System.assertEquals(1, folderCommentListAfterAdd.size());
                System.assertEquals(fcService.isAdded, true);
                
                for(Folder_Comment__c comment : folderCommentListAfterAdd){
                    if(comment.Comment_Body__c == 'Test body'){
                        System.assertEquals(comment.Distributor_Name__c, Service_API.getAID());
                        System.assertEquals(comment.Distributor_Access__c, a.ID);
                        System.assertEquals(comment.File__c, file.ID);
                        System.assertEquals(comment.Folder__c, folder.ID);
                    }
                }
            }
        Test.StopTest();
    }
    
    static testMethod void closeCommentMsgTest() {
        Service_FolderComments fcService = new Service_FolderComments();
        
        Test.StartTest();
            fcService.closeCommentMsg();        

            System.assertEquals(fcService.isAdded, false);      
            System.assertEquals(fcService.commentBody, null);
            System.assertEquals(fcService.distributorId, null);
            System.assertEquals(fcService.folderId, null);
            System.assertEquals(fcService.fileId, null);
        
        Test.StopTest();            
    }    
}