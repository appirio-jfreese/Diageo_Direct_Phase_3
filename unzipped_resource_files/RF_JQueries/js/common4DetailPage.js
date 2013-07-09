function bindJs(){
    iPadContentItemList();
	forEachOverviewContent();
	overviewToScrollClass();	    
}

jQuery(document).ready(function() {
	calculateBoxHeight();
	// init horizontal-slider
	bindJs();
	
	horizontalSliderContainer();
	// end of init

	horizontalSliderNavigation();
});