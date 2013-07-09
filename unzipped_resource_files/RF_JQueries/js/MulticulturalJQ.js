function bindFilterJs(){
	bindFilter4Planning();
	// **** DETAIL VIEW ****
	if(!jQuery('.horizontal-slider').hasClass('jsBind')){
		jQuery('.horizontal-slider').addClass('jsBind');
		forEachOverviewContent();
		overviewToScrollClass();
		horizontalSliderContainer();
	}
	iPadContentItemList();       
}

jQuery(document).ready(function() {
	calculateBoxHeight();
	bindFilterJs();
});
