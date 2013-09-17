@isTest 
private class TestBatchToDeleteRecipeAttribute {
	static void createData(){
		Recipe__c recipe = new Recipe__c();
		recipe.Recipe_Title__c = 'rt';
		insert recipe;
		Attribute__c attr = new Attribute__c();
		attr.Attribute_Type__c = 'Description/Overview';
		attr.Dynamic__c = true;
		insert attr;
		Recipe_Attribute__c rt = new Recipe_Attribute__c();
		rt.Attribute__c = attr.Id;
		rt.Recipe__c = recipe.Id;
		insert rt;
		Recipe_Attribute__c rt2 = new Recipe_Attribute__c();
		rt2.Attribute__c = attr.Id;
		rt2.Recipe__c = recipe.Id;
		insert rt2;
		
	}
    static testMethod void testMethod_TestBatchToDeleteRecipeAttribute() {
    	createData();
    	String query = 'select Id,Recipe_Title__c from Recipe__c limit 100';
    	Id btachId = Database.executeBatch(new BatchToDeleteRecipeAttribute(query));
    	
    }
}