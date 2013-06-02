/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallRecpClasifDtl_Test
Updated By  : Appirio Offshore(Rishi Khirbat)   
Date        : 15th Jan, 2013
Purpose     : Test Class for 
				- APPIRIO_WebServiceCallRecipeClasifDtl
********************************************************************************************************************/
@isTest
private class APPIRIO_WebServiceCallRecpClasifDtl_Test {
	
	//variable declaration
	static Attribute__c attr;
	static Attribute__c attr1;
	static Attribute__c attr2;
	static Attribute__c attr3;
	static Attribute__c attr4;
	static Attribute__c attr5;
	static Attribute__c attr6;
	static Attribute__c attr7;
	static Attribute__c attr8;
	static Attribute__c attr9;
	static Attribute__c attr10;
	
	static {
		//Creating a bunch of Attribute Records
		attr = TestUtil.createAttribute('Color','TestBlue',null);
		attr1= TestUtil.createAttribute('Language','TestEnglish',null);
		attr2 = TestUtil.createAttribute('Flavor','TestStrawberry',null);
		attr3 = TestUtil.createAttribute('Drink Type','TestCocktails',null);
		attr4 = TestUtil.createAttribute('Glassware','TestGlassware',null);
        attr5 = TestUtil.createAttribute('Effort Level','TestEffortLevel',null);
        attr6 = TestUtil.createAttribute('Serving Style','TestServingStyle',null);
        attr7 = TestUtil.createAttribute('Wine Type','TestWineType',null);
        attr8 = TestUtil.createAttribute('Wine Taste','TestWineTaste',null);
        attr9 = TestUtil.createAttribute('Barware Needed','TestBarwareNeeded',null);
        attr10 = TestUtil.createAttribute('Test Drink Classification','TestDrinkClassification',null);
        attr10.Dynamic__c = true;
        update attr10;
	}
	
	//Test Web Service Call for Recipe Classifications
    static testMethod void WebServiceCallRecipeClasifictinsTest() {
    	String xmlString;
    	attr = [Select API_External_ID__c, Locale__c From Attribute__c Where Id=:attr.id];
    	
    	Test.startTest();
	    	// set up the request object
	        System.RestContext.request = new RestRequest();
	        RestContext.request.requestURI = '/CallRecipeClassificationDetails/';
	        
	        // Invoke the method directly
	        xmlString = APPIRIO_WebServiceCallRecipeClasifDtl.WebServiceCallRecipeClassificationDetails();
			System.assert(xmlString.contains('<?xml version="1.0"?>'));
	        System.assert(xmlString.contains('<recipeClassifications>'));
	        System.assert(xmlString.contains('<key>Color</key>'));
	        System.assert(xmlString.contains('<value id="'+attr.API_External_ID__c+'" Locale="'+attr.Locale__c+'">TestBlue</value>'));
	        System.assert(!xmlString.contains('<recipeClassification>Test Drink Classification'));
	        System.assert(xmlString.contains('<key>Occasion</key>'));
	        System.assert(xmlString.contains('<key>Brand</key>'));
	        System.assert(xmlString.contains('<key>Product</key>'));
	        System.assert(xmlString.contains('</recipeClassifications>'));
	        
	        // Invoke the method directly
	        RestContext.request.addParameter('Key', 'Color');
	        xmlString = APPIRIO_WebServiceCallRecipeClasifDtl.WebServiceCallRecipeClassificationDetails();
			System.assert(xmlString.contains('<?xml version="1.0"?>'));
	        System.assert(xmlString.contains('<recipeClassifications>'));
	        System.assert(xmlString.contains('<key>Color</key>'));
	        System.assert(xmlString.contains('<value id="'+attr.API_External_ID__c+'" Locale="'+attr.Locale__c+'">TestBlue</value>'));
	        System.assert(!xmlString.contains('<recipeClassification>Test Drink Classification'));
	        System.assert(!xmlString.contains('<key>Occasion</key>'));
	        System.assert(!xmlString.contains('<key>Brand</key>'));
	        System.assert(!xmlString.contains('<key>Product</key>'));
	        System.assert(xmlString.contains('</recipeClassifications>'));
	        
	        // Invoke the method directly
	        RestContext.request.addParameter('Key', 'Brand');
	        xmlString = APPIRIO_WebServiceCallRecipeClasifDtl.WebServiceCallRecipeClassificationDetails();
			System.assert(xmlString.contains('<?xml version="1.0"?>'));
	        System.assert(xmlString.contains('<recipeClassifications>'));
	        System.assert(!xmlString.contains('<key>Color</key>'));
	        System.assert(!xmlString.contains('<value id="'+attr.API_External_ID__c+'" Locale="'+attr.Locale__c+'">TestBlue</value>'));
	        System.assert(!xmlString.contains('<recipeClassification>Test Drink Classification'));
	        System.assert(!xmlString.contains('<key>Occasion</key>'));
	        System.assert(xmlString.contains('<key>Brand</key>'));
	        System.assert(!xmlString.contains('<key>Product</key>'));
	        System.assert(xmlString.contains('</recipeClassifications>'));
	        
	        // Invoke the method directly
	        RestContext.request.addParameter('Key', 'Product');
	        xmlString = APPIRIO_WebServiceCallRecipeClasifDtl.WebServiceCallRecipeClassificationDetails();
			System.assert(xmlString.contains('<?xml version="1.0"?>'));
	        System.assert(xmlString.contains('<recipeClassifications>'));
	        System.assert(!xmlString.contains('<key>Color</key>'));
	        System.assert(!xmlString.contains('<value id="'+attr.API_External_ID__c+'" Locale="'+attr.Locale__c+'">TestBlue</value>'));
	        System.assert(!xmlString.contains('<recipeClassification>Test Drink Classification'));
	        System.assert(!xmlString.contains('<key>Occasion</key>'));
	        System.assert(!xmlString.contains('<key>Brand</key>'));
	        System.assert(xmlString.contains('<key>Product</key>'));
	        System.assert(xmlString.contains('</recipeClassifications>'));
	        
	        // Invoke the method directly
	        RestContext.request.addParameter('Key', 'Occasion');
	        xmlString = APPIRIO_WebServiceCallRecipeClasifDtl.WebServiceCallRecipeClassificationDetails();
			System.assert(xmlString.contains('<?xml version="1.0"?>'));
	        System.assert(xmlString.contains('<recipeClassifications>'));
	        System.assert(!xmlString.contains('<key>Color</key>'));
	        System.assert(!xmlString.contains('<value id="'+attr.API_External_ID__c+'" Locale="'+attr.Locale__c+'">TestBlue</value>'));
	        System.assert(!xmlString.contains('<recipeClassification>Test Drink Classification'));
	        System.assert(xmlString.contains('<key>Occasion</key>'));
	        System.assert(!xmlString.contains('<key>Brand</key>'));
	        System.assert(!xmlString.contains('<key>Product</key>'));
	        System.assert(xmlString.contains('</recipeClassifications>'));
        Test.stopTest();
    }
}