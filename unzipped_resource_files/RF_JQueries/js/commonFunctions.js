function calculateBoxHeight(){
 jQuery("div.content-item").each(function(i, elem){
		var bottomValue = jQuery("div.item-description", elem).height()-jQuery("div.content-item-menu div", elem).height() - 5;
		jQuery("div.item-description", elem).css('bottom', -bottomValue+"px");
	});
}

function forEachOverviewContent(){
	jQuery('.content-item-wrapper').not('.overview-content').each(function(){
		if(!jQuery(this).hasClass('scrollBind')){
			jQuery(this).addClass('scrollBind');
			jQuery(this).jScrollPane();
		}
	});
}

function overviewToScrollClass(){
	if(!jQuery('.overview-to-Scroll').hasClass('scrollBind')){
		jQuery('.overview-to-Scroll').addClass('scrollBind');
		jQuery('.overview-to-Scroll').jScrollPane();
	} 
}

function iPadContentItemList(){
	var isiPad = navigator.userAgent.match(/iPad/i) != null;

	if( isiPad == true){
		jQuery("div.content-item-list-description").live('touchstart', function(){
			jQuery("div.content-item-list-buttons").addClass("hidden");
			jQuery(this).parent().find("div.content-item-list-buttons").removeClass("hidden");
			return false;
		});
	}
}

function horizontalSliderContainer(){
	jQuery('.horizontal-slider-container').scrollLeft(0);           
	jQuery('.horizontal-slider').each(function(){
		jQuery(this).find('.horizontal-slider-prev').css({'opacity': '0', 'visibility': 'hidden'});
		dataContentWidth = jQuery(this).find('.horizontal-slider-content').size();
		if(!isNaN(dataContentWidth)){
			totalWarpperWidth = dataContentWidth * jQuery(this).find('.horizontal-slider-content').first().outerWidth();
			jQuery(this).find('.horizontal-slider-content-wrapper').css('width', totalWarpperWidth);
		}
	});
}

function horizontalSliderNavigation(){
	// horizontal slider navigation
	jQuery('.horizontal-slider-button').live('click', function(){
		sliderHolder = jQuery(this).parents('.horizontal-slider');
		if(sliderHolder.length != 0){
			slider = sliderHolder.find('.horizontal-slider-container');
			if(slider.length != 0){
				if(slider.find('.horizontal-slider-content').first().length != 0){
					if(sliderHolder.find('.horizontal-slider-navigation-button-active').length == 0){
						return;
					}
					scrollToPosition = slider.scrollLeft();
					buttonToActivate = null;
					if(jQuery(this).hasClass('horizontal-slider-prev')){
						if(sliderHolder.find('.horizontal-slider-navigation-button-active').prev('.horizontal-slider-navigation-button').length == 0){
							return;
						}

						if(sliderHolder.find('.horizontal-slider-navigation-button-active').prev('.horizontal-slider-navigation-button').prev('.horizontal-slider-navigation-button').length == 0){
							sliderHolder.find('.horizontal-slider-prev').stop().animate({'opacity': 0}, 500, function(){
								jQuery(this).css('visibility','hidden');
							});
						} else {
							sliderHolder.find('.horizontal-slider-next').css('visibility','');
							sliderHolder.find('.horizontal-slider-next').stop().animate({'opacity': 1}, 500);
						}

						buttonToActivate = sliderHolder.find('.horizontal-slider-navigation-button-active').prev('.horizontal-slider-navigation-button');
						scrollToPosition -= slider.find('.horizontal-slider-content').first().outerWidth();
					} else if(jQuery(this).hasClass('horizontal-slider-next')){
						if(sliderHolder.find('.horizontal-slider-navigation-button-active').next('.horizontal-slider-navigation-button').length == 0){
							return;
						}
						
						if(sliderHolder.find('.horizontal-slider-navigation-button-active').next('.horizontal-slider-navigation-button').next('.horizontal-slider-navigation-button').length == 0){
							sliderHolder.find('.horizontal-slider-next').stop().animate({'opacity': 0}, 500, function(){
								jQuery(this).css('visibility','hidden');
							});
						} else {
							sliderHolder.find('.horizontal-slider-prev').css('visibility','');                                
							sliderHolder.find('.horizontal-slider-prev').stop().animate({'opacity': 1}, 500);
						}

						buttonToActivate = sliderHolder.find('.horizontal-slider-navigation-button-active').next('.horizontal-slider-navigation-button');
						scrollToPosition += slider.find('.horizontal-slider-content').first().outerWidth();
					}
					if(buttonToActivate.hasClass('mediaPage')){
						renderAsBoxSlider();
					}	else {
						renderAsListSlider();
					}    
					if(!slider.hasClass('scrolling') && buttonToActivate != null){                          
						slider.addClass('scrolling');
						sliderHolder.find('.horizontal-slider-navigation-button').removeClass('horizontal-slider-navigation-button-active');
						buttonToActivate.addClass('horizontal-slider-navigation-button-active');
						slider.animate({scrollLeft: scrollToPosition }, 600,function(){
							jQuery(this).removeClass('scrolling');
						});
					}
				}
			}
		}
	});
	jQuery('.horizontal-slider-navigation-button').live('click', function(){
		sliderHolder = jQuery(this).parents('.horizontal-slider');
		if(jQuery(this).hasClass('mediaPage')){
			renderAsBoxSlider();
		} else {
			renderAsListSlider();
		}             
		if(sliderHolder.length != 0){
			slider = sliderHolder.find('.horizontal-slider-container');
			if(slider.length != 0){
				if(slider.find('.horizontal-slider-content').first().length != 0){
					scrollToPosition = jQuery(this).index()*jQuery(slider).find('.horizontal-slider-content').first().outerWidth();
					if(!slider.hasClass('scrolling')){
						slider.addClass('scrolling');
						sliderHolder.find('.horizontal-slider-navigation-button').removeClass('horizontal-slider-navigation-button-active');
						jQuery(this).addClass('horizontal-slider-navigation-button-active');
						
						if(sliderHolder.find('.horizontal-slider-navigation-button-active').next('.horizontal-slider-navigation-button').length == 0){
							sliderHolder.find('.horizontal-slider-next').stop().animate({'opacity': 0}, 500, function(){
								jQuery(this).css('visibility','hidden');                                    
							});
						} else {
							sliderHolder.find('.horizontal-slider-next').css('visibility','');
							sliderHolder.find('.horizontal-slider-next').stop().animate({'opacity': 1}, 500);
						}
						if(sliderHolder.find('.horizontal-slider-navigation-button-active').prev('.horizontal-slider-navigation-button').length == 0){
							sliderHolder.find('.horizontal-slider-prev').stop().animate({'opacity': 0}, 500, function(){
								jQuery(this).css('visibility','hidden');
							});
						} else {
							sliderHolder.find('.horizontal-slider-prev').css('visibility','');
							sliderHolder.find('.horizontal-slider-prev').stop().animate({'opacity': 1}, 500);
						}
						
						slider.animate({scrollLeft: scrollToPosition }, 600,function(){
							jQuery(this).removeClass('scrolling');
						});
					}
				}
			}
		}
	});
}


function countCheckBrands()
{
	var counter = jQuery(".additional-brand-content").find('.brand-box-selected').length;
	if(counter > 0)
	{
		jQuery("#ADB").addClass("brand-box-selected");
	}else{
		jQuery("#ADB").removeClass("brand-box-selected");
	}
}

function bindFilter4SMnCD(){
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
			if(ui.newContent.hasClass('brandFilterWrapper') && jQuery('.brandCategoryFilterWrapper').prev().not('.hidden').length > 0){
				if(orgSelectedBrandCategories != jQuery('input[id*=selectedBrandCategories]').val()){
					initParentBrands();
				}

			}
			if(ui.newContent.hasClass('brandCategoryFilterWrapper')){
				jQuery('input[id*=selectedBrandIds]').val('');
			}
			filters = jQuery('div.filter-wrapper');
			if(jQuery('.specialContent').height() < filters.height()+150){
				jQuery('.specialContent').css('min-height', filters.height()+150);
			}
		}
	}
	if (!jQuery("#filter-accordion").hasClass('ui-accordion')) {
		config.active = activeAccordionTab
	}
	jQuery("#filter-accordion").accordion(config);

	filters = jQuery('div.filter-wrapper');
	if(jQuery('.specialContent').height() < filters.height()+150){
		jQuery('.specialContent').css('min-height', filters.height()+150);
	}

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


function bindFilter4Planning(){
	countCheckBrands();
	jQuery("#filter-accordion").accordion({
		collapsible: true,
		autoHeight: false,
		'accordionchange': function(event, ui) {
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+100){
				jQuery('.specialContent').css('min-height', jQuery('div.filter-wrapper').height()+100);
			}          
		},
		change: function(event, ui){
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+150){
				jQuery('.specialContent').css('height', jQuery('div.filter-wrapper').height()+150);
			}          
		}         
	});
	jQuery("#additional-brands-accordion").accordion({
		collapsible: true,
		autoHeight: false,
		active: false,
		'accordionchange': function(event, ui) {
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+100){
				jQuery('.specialContent').css('min-height', jQuery('div.filter-wrapper').height()+100);
			}          
		},
		change: function(event, ui){
			if(jQuery('.specialContent').height() < jQuery('div.filter-wrapper').height()+150){
				jQuery('.specialContent').css('height', jQuery('div.filter-wrapper').height()+150);
			}          
		}         
	});      
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

function setSelectAllBrandsCheckboxValue(){
	if(jQuery('.brand-box').not('.hidden').not('.brand-box-selected').length == 0 && jQuery('.brand-box').not('.hidden').length !=0 ){
		jQuery('.selectAllBrands').attr('checked', true);
	} else {
		jQuery('.selectAllBrands').attr('checked', false);
	}
}

function setSelectAllChildBrandsCheckboxValue(){
	if(jQuery('.child-brand-box').length !=0 ){
		if(jQuery('.child-brand-box').length == jQuery('.child-brand-box-selected').length){
			jQuery('.selectAllChildBrands').attr('checked', true);
		} else {
			jQuery('.selectAllChildBrands').attr('checked', false);
		}
	} else {
		jQuery('.selectAllChildBrands').attr('checked', false);
	}
}

function hideFilter(){
	if(jQuery('div.filter-wrapper').length == 0){
		return;
	}

	filters = jQuery('div.filter-wrapper');

	if(filters.hasClass('expanded')){
		filters.removeClass('expanded');
		jQuery('.arrowUp').addClass('hidden');
		jQuery('.arrowDown').removeClass('hidden');
		actualFilterHeight = filters.height();
		newPosition = -(actualFilterHeight + 50);
		filters.stop().animate({top: newPosition}, 1000, function(){
			jQuery('.specialContent').css('min-height', 400);
		});
		jQuery('.expander-overlay-disable').stop().animate({opacity: '0'}, 1000, function(){
			jQuery('.expander-overlay-disable').css({height: '0%'});
		});
	}
}