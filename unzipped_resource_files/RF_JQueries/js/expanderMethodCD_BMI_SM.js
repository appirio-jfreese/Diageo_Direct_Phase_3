// expander method
jQuery('div.expander').live('click', function(){
	if(jQuery('div.filter-wrapper').length == 0){
		return;
	}
	filters = jQuery('div.filter-wrapper');

	if(!filters.hasClass('expanded')){
		if(jQuery('.specialContent').height() < filters.height()+150){
			jQuery('.specialContent').css('min-height', filters.height()+150);
		}
		filters.addClass('expanded');
		jQuery('.arrowUp').removeClass('hidden');
		jQuery('.arrowDown').addClass('hidden');
		filters.stop().animate({top: 0}, 1000);
		jQuery('.expander-overlay-disable').css({height: '100%', opacity: '0'});
		jQuery('.expander-overlay-disable').stop().animate({opacity: '0.7'}, 1000);
	} else {
		filters.removeClass('expanded');
		jQuery('.arrowUp').addClass('hidden');
		jQuery('.arrowDown').removeClass('hidden');
		actualFilterHeight = filters.height();
		newPosition = -(actualFilterHeight);
		filters.stop().animate({top: newPosition}, 1000, function(){
			jQuery('.specialContent').css('min-height', 400);
		});
		jQuery('.expander-overlay-disable').stop().animate({opacity: '0'}, 1000, function(){
			jQuery('.expander-overlay-disable').css({height: '0%'});
		});
	}
});