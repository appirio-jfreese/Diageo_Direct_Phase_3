jQuery(document).keydown(function(e) {
	var element = e.target.nodeName.toLowerCase();
	if (element != 'input' && element != 'textarea') {
		if (e.keyCode === 39) {
			if(jQuery('.horizontal-slider-next').length == 1){
				jQuery('.horizontal-slider-next').trigger('click');
			}
			return false;
		} else if (e.keyCode === 37) {
			if(jQuery('.horizontal-slider-prev').length == 1){
				jQuery('.horizontal-slider-prev').trigger('click');
			}
			return false;
		}
	}
});