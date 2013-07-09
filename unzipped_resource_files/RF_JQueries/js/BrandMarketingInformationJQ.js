function bindFilterJs(){
	countCheckBrands();
	var activeAccordionTab = jQuery("#filter-accordion").attr('active');
	if (activeAccordionTab == undefined) {
		activeAccordionTab = 0;
	} else if (activeAccordionTab == 'false') {
		activeAccordionTab = false;
	} else {
		activeAccordionTab = parseInt(activeAccordionTab, 10);
	}
	var config  = {
		collapsible: true,
		autoHeight: false,
		change: function(event, ui){
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+150){
				jQuery('.specialContent').css('min-height', jQuery('div.filter-wrapper').height()+150);
			}
		}
	}
	if (!jQuery("#filter-accordion").hasClass('ui-accordion')) {
		config.active = activeAccordionTab
	}
	jQuery("#filter-accordion").accordion(config);



	jQuery("#additional-brands-accordion").accordion({
		collapsible: true,
		autoHeight: false,
		active: false,
		change: function(event, ui){
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+150){
				jQuery('.specialContent').css('min-height', jQuery('div.filter-wrapper').height()+150);
			}
		}
	});

	filters = jQuery('div.filter-wrapper');
	if(jQuery('.specialContent').height() < filters.height()+150){
		jQuery('.specialContent').css('min-height', filters.height()+150);
	}

	if(jQuery('div.filter-wrapper').length != 0){
		filters = jQuery('div.filter-wrapper');

		if(filters.hasClass('showAllFilter')){
			if(jQuery('.specialContent').height() < filters.height()+150){
				jQuery('.specialContent').css('min-height', filters.height()+150);
			}
			filters.addClass('expanded');
			filters.removeClass('showAllFilter');
			filters.stop().animate({top: 0}, 1000);
			jQuery('.arrowUp').removeClass('hidden');
			jQuery('.arrowDown').addClass('hidden');
			jQuery('.expander-overlay-disable').css({height: '100%', opacity: '0'});
			jQuery('.expander-overlay-disable').stop().animate({opacity: '0.7'}, 1000);
		} else {
			if(!filters.hasClass('expanded')){
				actualFilterHeight = filters.height();
				newPosition = -(actualFilterHeight);
				jQuery('.arrowUp').addClass('hidden');
				jQuery('.arrowDown').removeClass('hidden');
				filters.stop().animate({top: newPosition}, 1000, function(){
					jQuery('.specialContent').css('min-height', 400);
				});
			}
		}
	}
}

jQuery(document).ready(function() {

	calculateBoxHeight();
	bindFilterJs();

	iPadContentItemList();

});