@isTest
private class ActionProductLinkActionsTest {
	
	static testMethod void testUpdateOnlineFields() {
		List<Product__c> prods = new List<Product__c>();
		for(Integer i = 1; i <= 4; i++){
			Product__c testProd = new Product__c();
			testProd.Brand_Composite_Key__c = 'testme' + i;
			testProd.Product_Classification__c = 'testme' + i;
			testProd.Product_Group__c = 'testme' + i;
			testProd.Generic_Brand__c = 'testme' + i;
			testProd.Sub_Brand__c = 'testme' + i;
			testProd.Individual_Brand__c = 'testme' + i;
			testProd.Size__c = 'testme' + i;
			prods.add(testProd);
		}
		insert prods;
		
		Action__c parent = new Action__c();
        insert parent;
        
        List<Action_Product_Link__c> links = new List<Action_Product_Link__c>();
        
        Action_Product_Link__c link1 = new Action_Product_Link__c();
        link1.Action__c = parent.Id;
        link1.Individual_Brand_Offline__c = 'testme1';
        link1.Size_Offline__c = 'testme1';
        links.add(link1);

        Action_Product_Link__c link2 = new Action_Product_Link__c();
        link2.Action__c = parent.Id;
        link2.Individual_Brand_Offline__c = 'testme2';
        links.add(link2);
        
        Action_Product_Link__c link3 = new Action_Product_Link__c();
        link3.Action__c = parent.Id;
        link3.Product_Classification__c = 'testme3';
        link3.Product_Group__c = 'testme3';
        link3.Generic_Brand__c = 'testme3';
        link3.Sub_Brand__c = 'testme3';
        link3.Individual_Brand__c = 'testme3';
        link3.Size__c = 'testme3';
        links.add(link3);
        
        Action_Product_Link__c link4 = new Action_Product_Link__c();
        link4.Action__c = parent.Id;
        link4.Product_Classification__c = 'testme4';
        link4.Product_Group__c = 'testme4';
        link4.Generic_Brand__c = 'testme4';
        link4.Sub_Brand__c = 'testme4';
        link4.Individual_Brand__c = 'testme4';
        links.add(link4);
        
        Test.startTest();
        
        insert links;
        
        Test.stopTest();
        
        assertVals(link1, 'testme1', true);
        assertVals(link2, 'testme2', false);
        assertVals(link3, 'testme3', true);
        assertVals(link4, 'testme4', false);
	}
	
	private static void assertVals(Action_Product_Link__c link, String val, Boolean sizeShouldMatch){
        link  = [SELECT Id, Product_Classification__c, Product_Group__c,
        				Generic_Brand__c, Sub_Brand__c, Individual_Brand__c,
        				Size__c, Individual_Brand_Offline__c, Size_Offline__c
        		   FROM Action_Product_Link__c
        		  WHERE Id = :link.Id
        		];
        System.assertEquals(val, link.Product_Classification__c);
        System.assertEquals(val, link.Product_Group__c);
        System.assertEquals(val, link.Generic_Brand__c);
        System.assertEquals(val, link.Sub_Brand__c);
        System.assertEquals(val, link.Individual_Brand__c);
        System.assertEquals(val, link.Individual_Brand_Offline__c);
        if(sizeShouldMatch){
	        System.assertEquals(val, link.Size__c);
	        System.assertEquals(val, link.Size_Offline__c);
        }
	}
/*
    static testMethod void testDeduplicateLinks() {
        Action__c parent = new Action__c();
        insert parent;
        
        List<Action_Product_Link__c> links = new List<Action_Product_Link__c>();
        
        Action_Product_Link__c link1 = new Action_Product_Link__c();
        link1.Action__c = parent.Id;
        link1.Generic_Brand__c = 'gen brand unique';
        links.add(link1);
        
        Action_Product_Link__c link2 = new Action_Product_Link__c();
        link2.Action__c = parent.Id;
        link2.Generic_Brand__c = 'gen brand dupe';
        links.add(link2);
        
        Action_Product_Link__c link3 = new Action_Product_Link__c();
        link3.Action__c = parent.Id;
        link3.Generic_Brand__c = 'gen brand dupe';
        links.add(link3);
        
        Test.startTest();
        
        insert links;
        
        Test.stopTest();
        
        links = [SELECT Id FROM Action_Product_Link__c WHERE Id IN :links];
        System.assertEquals(2, links.size());
    }
    
    
    static testMethod void testDeduplicateLinks2() {
        Action__c parent = new Action__c();
        insert parent;
        
        Action_Product_Link__c link1 = new Action_Product_Link__c();
        link1.Action__c = parent.Id;
        link1.Generic_Brand__c = 'gen brand unique';
        insert link1;
        
        Action_Product_Link__c link2 = new Action_Product_Link__c();
        link2.Action__c = parent.Id;
        link2.Generic_Brand__c = 'gen brand dupe';
        insert link2;
        
        Action_Product_Link__c link3 = new Action_Product_Link__c();
        link3.Action__c = parent.Id;
        link3.Generic_Brand__c = 'gen brand dupe';
        
        Test.startTest();
        
        insert link3;
        
        Test.stopTest();
        
       	List<Action_Product_Link__c> links = [SELECT Id FROM Action_Product_Link__c WHERE Id = :link3.Id];
        System.assertEquals(0, links.size());
    }*/
}