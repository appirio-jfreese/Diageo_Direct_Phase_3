var clickedHovers=new Array();
jQuery(".cion").live('touchstart',function() {
	if(typeof jQuery(this).attr('title') != 'undefined' && jQuery(this).attr('title').length != 0){
		var unique = jQuery(this).parent().attr('id')+ jQuery(this).attr('title');
		var uniquetab = jQuery(this).parent().attr('id');
		if(jQuery.inArray(unique, clickedHovers) == 0 && jQuery.inArray(uniquetab, clickedHovers) == 1){
			jQuery(this).trigger('click');
		}else{
			clickedHovers=new Array();
			clickedHovers.push(unique);
			clickedHovers.push(uniquetab);
			jQuery(".content-item-wrapper").find('.content-item-tooltip').html('&nbsp;');
			jQuery(this).parents('.cionwrapper').first().find('.content-item-tooltip').html(jQuery(this).attr('title'));
			return false;
		}
	} else {
		jQuery(this).parents('.cionwrapper').first().find('.content-item-tooltip').html('&nbsp;');
	}
});