function bindFilterJs(){
	bindFilter4Planning();
	// **** DETAIL VIEW ****
	if(!jQuery('.horizontal-slider').hasClass('jsBind')){
		jQuery('.horizontal-slider').addClass('jsBind');
		jQuery('.content-item-wrapper').jScrollPane();
		horizontalSliderContainer();
	}
	iPadContentItemList();
}

jQuery(document).ready(function() {
	calculateBoxHeight();
	bindFilterJs();  
});
