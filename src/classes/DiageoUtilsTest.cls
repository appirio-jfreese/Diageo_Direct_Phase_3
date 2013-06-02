@isTest
private class DiageoUtilsTest {


    static testMethod void test()
    {
    	System.Test.startTest();
    	String testString = DiageoUtils.getMonthFullnameFromMonthNumber(1);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(2);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(3);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(4);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(5);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(6);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(7);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(8);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(9);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(10);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(11);
    	testString = DiageoUtils.getMonthFullnameFromMonthNumber(12);
    	System.Test.stopTest();
    }

}