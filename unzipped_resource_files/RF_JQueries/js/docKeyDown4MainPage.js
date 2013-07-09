jQuery(document).keydown(function(e) {
	var element = e.target.nodeName.toLowerCase();
	if (element != 'input' && element != 'textarea' && element != 'select') {

		if(jQuery('#ajaxLoader').length != 0 && !jQuery('#ajaxLoader').hasClass('hidden') ){
			return false;
		}
	
		if (e.keyCode === 39) { // right
			if(jQuery('.month-next').length != 0){
				jQuery('.month-next').first().trigger('click');
			}
			return false;
		} else if (e.keyCode === 37) { // left
			if(jQuery('.month-previous').length != 0){
				jQuery('.month-previous').first().trigger('click');
			}
			return false;
		} else if (e.keyCode === 38) { //up
			if(jQuery('.title-menu').find('.custom-select-box-values').find('.current').prev().length == 1){
				jQuery('.title-menu').find('.custom-select-box-values').find('.current').prev().trigger('click');
			}
			return false;
		} else if (e.keyCode === 40) { // down
			if(jQuery('.title-menu').find('.custom-select-box-values').find('.current').next().length == 1){
				jQuery('.title-menu').find('.custom-select-box-values').find('.current').next().trigger('click');
			}
			return false;
		}
	}
});