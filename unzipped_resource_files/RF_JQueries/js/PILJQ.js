var dummyBottleImg = '{!URLFOR($Resource.PIL, 'images/defaultbottle.png')}';
var dummyBottleWineImg = '{!URLFOR($Resource.PIL, 'images/defaultwine.png')}';

var sliderWidth = 940;
var currentScreen = 1;
var currentInnovation = 0;
var maxInnovationBrandsSlide = 0;
var defaultBottleDim = {width: 66, height: 96};
var middleBottleDim = {width: 68, height: 100};
var hoverBottleDim = {width: 78, height: 115};
var defaultWineBoxWidth = 120;

var defaultWineDim = {width: 66, height: 94};
var middleWineDim = {width: 68, height: 104};
var hoverWineDim = {width: 82, height: 118};

var currentSearchValue = '';

var currentHeritage = 0;
var maxHeritageBrandsSlide = 0;

var currentLuxury = 0;
var maxLuxuryBrandsSlide = 0;

var currentLifestyle = 0;
var maxLifestyleBrandsSlide = 0;

jQuery('.brandNameSearch').keydown(function(e) {
	if (e.keyCode === 13) {
		return false;
	}
});

jQuery(document).keydown(function(e) {
	if(!jQuery('.pilDialog').hasClass('hidden')){
		return;
	}
	var element = e.target.nodeName.toLowerCase();
	if (element != 'input' && element != 'textarea') {
		currentScreenWrapper = jQuery('.horizontal-slider-content:eq('+currentScreen+')');
		if (e.keyCode === 39) { // slide right
			arrowButton = currentScreenWrapper.find('.right-arrow');
			if(arrowButton.length == 1){
				arrowButton.trigger('click');
			}
			return false;
		} else if (e.keyCode === 37) { // slide left
			arrowButton = currentScreenWrapper.find('.left-arrow');
			if(arrowButton.length == 1){
				arrowButton.trigger('click');
			}
			return false;
		} else if ((e.keyCode >= 48 && e.keyCode <= 90) || (e.keyCode >= 96 && e.keyCode <= 105)) {
			searchInput = jQuery('.brandNameSearch');
			if(!searchInput.hasClass('usertypeing')){
				searchInput.val('');
			}
			searchInput.addClass('usertypeing');
			if(currentScreen != 0){
				currentValue = searchInput.val();
				searchInput.val(currentValue+String.fromCharCode(e.keyCode).toLowerCase());
				slider = jQuery('.horizontal-slider').find('.horizontal-slider-container');
				if(slider.length == 1){
					scrollToPosition = 0;
					jQuery('.left-arrow, .right-arrow').addClass('hidden');
					slider.stop().animate({scrollLeft: scrollToPosition }, 1000, function(){
						currentScreen = 0;
						jQuery('.left-arrow, .right-arrow').removeClass('hidden');
						jQuery('.horizontal-slider-navigation-button-active').removeClass('horizontal-slider-navigation-button-active');
						jQuery('.search-button').addClass('horizontal-slider-navigation-button-active');
						searchInput.removeClass('usertypeing');
						searchInput.focus();
						jQuery('.brandNameSearch').autocomplete('search', jQuery('.brandNameSearch').val());
					});
				}
			} else {
				searchInput.focus();
				searchInput.removeClass('usertypeing');
				jQuery('.brandNameSearch').autocomplete('search', jQuery('.brandNameSearch').val());
			}
		}
	}
});

function reorganizeSearchView(){
	resultHolder = jQuery('.searchResult');
	shCenter = resultHolder.find('.alignBox').last();
	if(shCenter.length != 0){
		bottles = shCenter.nextAll('.brand-box').size();
		if(resultHolder.hasClass('wine')){
			if(bottles < 6){
				centerOffset = ((6 - bottles) * defaultWineBoxWidth)/2 + 40;
				shCenter.css('width', centerOffset);
				shCenter.html('&nbsp');
			} else {
				shCenter.css('width', 40);
				shCenter.html('&nbsp;');
			}
		}else{
			if(bottles < 10){
				centerOffset = ((10 - bottles) * 78)/2 + 10;
				shCenter.css('width', centerOffset);
				shCenter.html('&nbsp');
			} else {
				shCenter.css('width', 10);
				shCenter.html('&nbsp;');
			}
		}
	}
}

function bindAutoSuggest(){
	jQuery('.brandNameSearch').autocomplete({
		source: function( request, response ) {
			try {
				if(jQuery('.searchResult').hasClass('rerendering')){
					return false;
				}
				tempSearchValue = request.term;
				if(currentSearchValue == tempSearchValue){
					return;
				}
				currentSearchValue = tempSearchValue;
				jQuery('.searchResult').addClass('rerendering');
				showDialog('ajaxLoader');
				jQuery('.searchResult').delay(400).stop().animate({opacity: 0.0}, 500, function(){
					Controller_BaseRemote.searchPILBrand(request.term, function(data, event){
						if (event.status) {
							orgBrandNames = {};
							validBrandNames = {};
							brands = [];
							//sucess
							bottlehtml = unescape(''+data.bottlehtml.replace(/\+/g, " "));
							response( jQuery.map( data.brands, function( item ) {
								if(!!item.Name){
									bName = item.Name;
								} else {
									bName = 'No name';
								}
								return {
									label: bName,
									value: bName
								}
							}));

							jQuery(bottlehtml).find('img.dummyBottle').attr('src',dummyBottleImg);
							jQuery(bottlehtml).find('img.dummyBottleWine').attr('src',dummyBottleWineImg);

							jQuery('.searchResult').html(bottlehtml);
							jQuery('.searchResult').find('img.dummyBottle').attr('src',dummyBottleImg);
							jQuery('.searchResult').find('img.dummyBottleWine').attr('src',dummyBottleWineImg);

							jQuery('.brand-box').each(function(){
								if(jQuery(this).hasClass('wine')){
									jQuery(this).find('img').css({'left' : (defaultWineBoxWidth - defaultWineDim.width)/2 });
								}
							});

							jQuery.each(data.brands, function(index, item){
								orgBrandNames[data.brandValidNames[item.Id]] = item.Name;
								validBrandNames[item.Name] = data.brandValidNames[item.Id];

								var brand = {
									orgBrandName: item.Name,
									validBrandName: data.brandValidNames[item.Id]
								}
								brands.push(brand);
							});

							reorganizeSearchView();

						} else if (event.type === 'exception') {
							alert(event.message);
							jQuery('.searchResult').html('');
						} else {
							alert(event.message);
							jQuery('.searchResult').html('');
						}
						jQuery('.searchResult').animate({opacity: 1.0}, 500);
						hideDialog('ajaxLoader');
						jQuery('.searchResult').removeClass('rerendering');
					}, {escape:true});
				});
			} catch(e){
				alert('Error during search!');
				hideDialog('ajaxLoader');
				orgBrandNames = {};
				validBrandNames = {};
				brands = [];
				jQuery('.searchResult').html('');
				jQuery('.searchResult').animate({opacity: 1.0}, 500);
				jQuery('.searchResult').removeClass('rerendering');
			}
		},
		search: function() {

			// custom minLength
			var term = this.value;
			if ( term.length < 1 ) {
				return false;
			}
		},
		close: function(event, ui) {
			var searchForName = jQuery('.brandNameSearch').val();
			if(orgBrandNames[searchForName]){
				jQuery('.brandNameSearch').val(orgBrandNames[searchForName]);
			}
			if(searchForName != '{!defaultSearchBrand}'){
				jQuery('.searchScreen').find('.brand-box').each(function(index,elem){
					if(jQuery(elem).attr('name').toLowerCase() == searchForName.toLowerCase()){
						jQuery(elem).trigger('click');
					}
				});
			}
			jQuery('.brandNameSearch').autocomplete('search', jQuery('.brandNameSearch').val());
		}
	});
}
function calculateBoxHeight(){
	jQuery("div.content-item").each(function(i, elem){
		var bottomValue = jQuery("div.item-description", elem).height()-jQuery("div.content-item-menu div", elem).height() - 5;
		jQuery("div.item-description", elem).css('bottom', -bottomValue+"px");
		jQuery("div.item-description", elem).trigger('mouseleave');
	});
}


function bindFilterJs(){
	calculateBoxHeight();
	if(!jQuery('.result-content-wrapper').hasClass('scroller-bnd')){
		jQuery('.result-content-wrapper').addClass('scroller-bnd');
		jQuery('.result-content-wrapper').jScrollPane();
	}
	if(!jQuery('.variant-wrapper').hasClass('scroller-bnd')){
		jQuery('.variant-wrapper').addClass('scroller-bnd');
		jQuery('.variant-wrapper').jScrollPane();
	}
	if(!jQuery('.extraSubmenu').not('.hidden').find('.flavor-wrapper').hasClass('scroller-bnd')){
		jQuery('.extraSubmenu').not('.hidden').find('.flavor-wrapper').addClass('scroller-bnd');
		jQuery('.extraSubmenu').not('.hidden').find('.flavor-wrapper').jScrollPane();
	}
	jQuery('.extraSubmenu').find('.variant-brand-box').each(function(){
		var subSectionId = jQuery(this).attr('name');
		if(jQuery(this).hasClass('variant-brand-box-selected')){
			jQuery('div.withExtraSubmenu[name="'+subSectionId+'"]').addClass('sub-variant-brand-box-selected');
		}
	});
}

function centerDialog(){
	jQuery('#brandPageContent').css('top', -1000);

	var actualWindowWidth = jQuery(window).width();
	var actualWindowHeight = jQuery(window).height();
	var verticalScrollPosition = jQuery(document).scrollTop();
	var horizontalScrollPosition = jQuery(document).scrollLeft();

	var left = horizontalScrollPosition + (actualWindowWidth/2) - (480);
	var top = verticalScrollPosition + (actualWindowHeight/2) - (308);

	if(top<0) top = 0;
	if(left<0) left = 0;

	jQuery('#brandPageContent').css('top', top);
	jQuery('#brandPageContent').css('left', left);

}

function intro(){
	slider = jQuery('.horizontal-slider');
	slider.css('opacity', 0);
	jQuery('.horizontal-slider-container').scrollLeft(currentScreen*sliderWidth);
	jQuery('.box-content-container').scrollLeft(0);

	jQuery('.box-content-slide').each(function(){
		if(jQuery(this).hasClass('wine')){
			var widthTmp = jQuery(this).find('.brand-box').size() * (defaultWineBoxWidth) + 40;
			if(widthTmp < 760) {
				widthTmp = 760;
			}
		}else{
			var widthTmp = jQuery(this).find('.brand-box').size() * 82;
			if(widthTmp < 760) {
				widthTmp = 760;
			}
		}
		jQuery(this).css('width', widthTmp);

	});

	/*Case 00004352
	Modified By - Rahul Chitkara [Appirio Jaipur]
	Date  - 11th March 2013
	jQuery('.mslide.left').addClass('noVisible'); */
	jQuery('.mslide.left').addClass('noVisible');
	jQuery('.mslide.right').removeClass('noVisible');

	jQuery('.alignBox.onMainPage').each(function(){
		if(jQuery(this).parents().hasClass('wine')){
		if(jQuery(this).hasClass('onMainPage')){
			bottles = jQuery(this).nextAll('.brand-box').size();
			if(bottles < 6){
				centerOffset = ((6 - bottles) * (defaultWineBoxWidth))/2 + 30;
				jQuery(this).css('width', centerOffset);
				jQuery(this).html('&nbsp');
			} else {
				jQuery(this).css('width', 30);
				jQuery(this).html('&nbsp');
			}
		}
		}else{
			if(jQuery(this).hasClass('onMainPage')){
				bottles = jQuery(this).nextAll('.brand-box').size();
				if(bottles < 10){
					centerOffset = ((10 - bottles) * 78)/2;
					jQuery(this).css('width', centerOffset);
					jQuery(this).html('&nbsp');
				} else {
					jQuery(this).css('width', 0);
					jQuery(this).html('&nbsp');
				}
			}
		}
	});

	jQuery('.brand-box').each(function(){
		if(jQuery(this).hasClass('wine')){
			jQuery(this).find('img').css({'left' : (defaultWineBoxWidth - defaultWineDim.width)/2 });
		}
	});

	jQuery('.additionalScreen').each(function(){
		shCenter = jQuery(this).find('.alignBox').last();
		if(shCenter.length != 0){
			bottles = shCenter.parent().nextAll('.brand-box').size();
			if(jQuery(this).find('.wine').length != 0){
				if(bottles < 6){
					centerOffset = ((6 - bottles) * (defaultWineBoxWidth))/2 + 40;
					shCenter.css('width', centerOffset);
					shCenter.html('&nbsp');
				} else {
					shCenter.css('width', 40);
					shCenter.html('&nbsp;');
				}
			}else{

				if(bottles < 10){
					centerOffset = ((10 - bottles) * 78)/2 + 10;
					shCenter.css('width', centerOffset);
					shCenter.html('&nbsp');
				} else {
					shCenter.css('width', 10);
					shCenter.html('&nbsp;');
				}
			}

		}
	});
	shCenter = jQuery('.searchResult').find('.alignBox').last();
	if(shCenter.length != 0){
		bottles = shCenter.parent().nextAll('.brand-box').not('.hidden').size();
		if(jQuery('.searchResult').hasClass('wine')){
			if(bottles < 6){
				centerOffset = ((6 - bottles) * defaultWineBoxWidth)/2 + 40;
				shCenter.css('width', centerOffset);
				shCenter.html('&nbsp');
			} else {
				shCenter.css('width', 40);
				shCenter.html('&nbsp;');
			}
		}else{
			if(bottles < 10){
				centerOffset = ((10 - bottles) * 78)/2 + 10;
				shCenter.css('width', centerOffset);
				shCenter.html('&nbsp');
			} else {
				shCenter.css('width', 10);
				shCenter.html('&nbsp;');
			}
		}
	}
	slider.animate({opacity: 1}, 600);

}

jQuery(document).ready(function() {
	// Changes done by Jai Gupta [Appirio Jaipur] for case #00003413 on 10th Dec 2012
	if(jQuery('.box-content-slide.innovation').hasClass('wine')){
		maxInnovationBrandsSlide = jQuery('.box-content-slide.innovation').find('.brand-box').size()-6;
		if(maxInnovationBrandsSlide < 0){
			maxInnovationBrandsSlide = 0;
		}
	}else{
		maxInnovationBrandsSlide = jQuery('.box-content-slide.innovation').find('.brand-box').size()-10;
		if(maxInnovationBrandsSlide < 0){
			maxInnovationBrandsSlide = 0;
		}
	}

	maxHeritageBrandsSlide = jQuery('.box-content-slide.heritage').find('.brand-box').size()-6;
	if(maxHeritageBrandsSlide < 0){
		maxHeritageBrandsSlide = 0;
	}

	maxLifestyleBrandsSlide = jQuery('.box-content-slide.lifestyle').find('.brand-box').size()-6;
	if(maxLifestyleBrandsSlide < 0){
		maxLifestyleBrandsSlide = 0;
	}

	maxLuxuryBrandsSlide = jQuery('.box-content-slide.luxury').find('.brand-box').size()-6;
	if(maxLuxuryBrandsSlide < 0){
		maxLuxuryBrandsSlide = 0;
	}

	for(var i=0; i < brands.length; i++){
		if(jQuery('.searchScreen').find('div.brand-box[name="'+brands[i].validBrandName+'"]').length != 0){
			brands[i].elem = jQuery('div.brand-box[name="'+brands[i].validBrandName+'"]')[0];
		}
	}

	bindAutoSuggest();

	jQuery('.brandNameSearch').live('focusout', function(){
		if(jQuery(this).val() == ''){
			jQuery(this).val('{!defaultSearchBrand}');
		}
	});

	jQuery('.brandNameSearch').live('focusin', function(){
		if(jQuery(this).val() == '{!defaultSearchBrand}'){
			jQuery(this).val('');
		}
	});
	jQuery('li.ui-menu-item').live('mouseenter', function() {
		brandName = jQuery(this).children().first().html();

		if(jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').length != 0){
			jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').trigger('mouseenter');
		}
	});
	jQuery('li.ui-menu-item').live('mouseleave', function() {
		brandName = jQuery(this).children().first().html();
		if(jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').length != 0){
			jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').trigger('mouseleave');
		}
	});
	jQuery('li.ui-menu-item').live('click', function() {
		brandName = jQuery(this).children().first().html();
		if(jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').length != 0){
			jQuery('.searchScreen').find('div.brand-box[name="'+validBrandNames[brandName]+'"]').trigger('click');
		}
	});

	jQuery('.horizontal-slider-navigation-button').live('click', function(){
		if(jQuery(this).hasClass('horizontal-slider-navigation-button-active')){
			return
		}
		if(jQuery('.left-arrow, .right-arrow').hasClass('scrolling')){
			return;
		}
		that = jQuery('.left-arrow').first();
		that.addClass('scrolling');
		slider = jQuery('.horizontal-slider-container');
		if(slider.length == 1){
			scrollToPosition = null;
			currentScreen = jQuery(this).index();
			jQuery('.horizontal-slider-navigation-button-active').removeClass('horizontal-slider-navigation-button-active');
			jQuery(this).addClass('horizontal-slider-navigation-button-active');
			scrollToPosition = currentScreen*sliderWidth;
			if(scrollToPosition != null){
				jQuery('.left-arrow, .right-arrow').addClass('hidden');
				slider.stop().animate({scrollLeft: scrollToPosition }, 1000, function(){
				jQuery('.left-arrow, .right-arrow').removeClass('hidden');
				that.removeClass('scrolling');
				});
			}
		}
	});

	jQuery('.mslide').live('click', function(){

		if(jQuery(this).hasClass('scrolling')){
			return;
		}
		jQuery(this).addClass('scrolling');

		if(jQuery(this).hasClass('heritage')){

			if(jQuery(this).hasClass('left')){
				currentHeritage = currentHeritage - 6;
			}else if(jQuery(this).hasClass('right')){
				currentHeritage = currentHeritage + 6;
			}

			if(currentHeritage <= 0){
				currentHeritage = 0;
				jQuery('.mslide.left.heritage').addClass('noVisible');
				jQuery('.mslide.right.heritage').removeClass('noVisible');
			}

			if(maxHeritageBrandsSlide <= currentHeritage){
				currentHeritage = maxHeritageBrandsSlide;
				jQuery('.mslide.left.heritage').removeClass('noVisible');
				jQuery('.mslide.right.heritage').addClass('noVisible');
			}

			heritageSlider = jQuery('.box-content-container.heritage');
			if(heritageSlider.length == 1){
				heritageSlider.addClass("scrl");
				heritageSlider.animate({scrollLeft: currentHeritage*defaultWineBoxWidth }, 1000, function(){
					jQuery('.mslide.left.heritage, .mslide.right.heritage').removeClass('scrolling');
					heritageSlider.removeClass("scrl");
				});
			}
		}else if(jQuery(this).hasClass('innovation')){

			if(jQuery(this).hasClass('wine')){

				if(jQuery(this).hasClass('left')){
					currentInnovation = currentInnovation - 6;
				}else if(jQuery(this).hasClass('right')){
					currentInnovation = currentInnovation + 6;
				}

				if(currentInnovation <= 0){
					currentInnovation = 0;
					jQuery('.mslide.right.innovation').removeClass('noVisible');
				}

				if(currentInnovation > 1){
					currentInnovation = currentInnovation;
					jQuery('.mslide.left.innovation').removeClass('noVisible');
				}


				if(currentInnovation < 1){
					currentInnovation = currentInnovation;
					jQuery('.mslide.left.innovation').addClass('noVisible');
				}

				if(currentInnovation >= maxInnovationBrandsSlide){
					currentInnovation = currentInnovation;
					jQuery('.mslide.right.innovation').addClass('noVisible');
				}

				if(currentInnovation < maxInnovationBrandsSlide){
					currentInnovation = currentInnovation;
					jQuery('.mslide.right.innovation').removeClass('noVisible');
				}


				if(maxInnovationBrandsSlide < currentInnovation){
					currentInnovation = maxInnovationBrandsSlide;
					jQuery('.mslide.left.innovation').removeClass('noVisible');
				}




				innovationSlider = jQuery('.box-content-container.innovation');
				if(innovationSlider.length == 1){
					innovationSlider.addClass("scrl");
					innovationSlider.animate({scrollLeft: currentInnovation*defaultWineBoxWidth }, 1000, function(){
						jQuery('.mslide.left.innovation, .mslide.right.innovation').removeClass('scrolling');
						innovationSlider.removeClass("scrl");
					});
				}
			}else{
				if(jQuery(this).hasClass('left')){
					currentInnovation = currentInnovation - 10;
				}else if(jQuery(this).hasClass('right')){
					currentInnovation = currentInnovation + 10;
				}

				if(currentInnovation <= 0){
					currentInnovation = 0;
					jQuery('.mslide.right.innovation').removeClass('noVisible');
				}
				if(currentInnovation > 1){
					currentInnovation = currentInnovation;
					jQuery('.mslide.left.innovation').removeClass('noVisible');
				}


				if(currentInnovation < 1){
					currentInnovation = currentInnovation;
					jQuery('.mslide.left.innovation').addClass('noVisible');
				}

				if(currentInnovation >= maxInnovationBrandsSlide){
					currentInnovation = currentInnovation;
					jQuery('.mslide.right.innovation').addClass('noVisible');
				}

				if(currentInnovation < maxInnovationBrandsSlide){
					currentInnovation = currentInnovation;
					jQuery('.mslide.right.innovation').removeClass('noVisible');
				}



				if(maxInnovationBrandsSlide <= currentInnovation){
					currentInnovation = maxInnovationBrandsSlide;
					jQuery('.mslide.left.innovation').removeClass('noVisible');
				}

				innovationSlider = jQuery('.box-content-container.innovation');
				if(innovationSlider.length == 1){
					innovationSlider.addClass("scrl");
					innovationSlider.animate({scrollLeft: currentInnovation*78 }, 1000, function(){
						jQuery('.mslide.left.innovation, .mslide.right.innovation').removeClass('scrolling');
						innovationSlider.removeClass("scrl");
					});
				}
			}
		}else if(jQuery(this).hasClass('luxury')){
			if(jQuery(this).hasClass('left')){
				currentLuxury = currentLuxury - 6;
			}else if(jQuery(this).hasClass('right')){
				currentLuxury = currentLuxury + 6;
			}

			if(currentLuxury <= 0){
				currentLuxury = 0;
				jQuery('.mslide.left.luxury').addClass('noVisible');
				jQuery('.mslide.right.luxury').removeClass('noVisible');
			}

			if(maxLuxuryBrandsSlide <= currentLuxury){
				currentLuxury = maxLuxuryBrandsSlide;
				jQuery('.mslide.left.luxury').removeClass('noVisible');
				jQuery('.mslide.right.luxury').addClass('noVisible');
			}

			luxurySlider = jQuery('.box-content-container.luxury');
			if(luxurySlider.length == 1){
				luxurySlider.addClass("scrl");
				luxurySlider.animate({scrollLeft: currentLuxury*defaultWineBoxWidth  }, 1000, function(){
					jQuery('.mslide.left.luxury, .mslide.right.luxury').removeClass('scrolling');
					luxurySlider.removeClass("scrl");
				});
			}
		}else if(jQuery(this).hasClass('lifestyle')){
			if(jQuery(this).hasClass('left')){
				currentLifestyle = currentLifestyle - 6;
			}else if(jQuery(this).hasClass('right')){
				currentLifestyle = currentLifestyle + 6;
			}

			if(currentLifestyle <= 0){
				currentLifestyle = 0;
				jQuery('.mslide.left.lifestyle').addClass('noVisible');
				jQuery('.mslide.right.lifestyle').removeClass('noVisible');
			}

			if(maxLifestyleBrandsSlide <= currentLifestyle){
				currentLifestyle = maxLifestyleBrandsSlide;
				jQuery('.mslide.left.lifestyle').removeClass('noVisible');
				jQuery('.mslide.right.lifestyle').addClass('noVisible');
			}

			lifestyleSlider = jQuery('.box-content-container.lifestyle');
			if(lifestyleSlider.length == 1){
				lifestyleSlider.addClass("scrl");
				lifestyleSlider.animate({scrollLeft: currentLifestyle*defaultWineBoxWidth }, 1000, function(){
					jQuery('.mslide.left.lifestyle, .mslide.right.lifestyle').removeClass('scrolling');
					lifestyleSlider.removeClass("scrl");
				});
			}
		}

	});
	jQuery('.left-arrow, .right-arrow').live('click', function(){
		if(jQuery('.left-arrow, .right-arrow').hasClass('scrolling')){
			return;
		}
		that = jQuery(this);
		that.addClass('scrolling');
		slider = that.parents('.horizontal-slider').find('.horizontal-slider-container');
		if(slider.length == 1){
			scrollToPosition = null;
			if(that.hasClass('left-arrow')){
				currentScreen--;
				currentIndicator = jQuery('.horizontal-slider-navigation-button-active');
				currentIndicator.prev().addClass('horizontal-slider-navigation-button-active');
				currentIndicator.removeClass('horizontal-slider-navigation-button-active');
			} else if(that.hasClass('right-arrow')){
				currentScreen++;
				currentIndicator = jQuery('.horizontal-slider-navigation-button-active');
				currentIndicator.next().addClass('horizontal-slider-navigation-button-active');
				currentIndicator.removeClass('horizontal-slider-navigation-button-active');
			}
			scrollToPosition = currentScreen*sliderWidth;
			if(scrollToPosition != null){
				jQuery('.left-arrow, .right-arrow').addClass('hidden');
				slider.stop().animate({scrollLeft: scrollToPosition }, 1000, function(){
					jQuery('.left-arrow, .right-arrow').removeClass('hidden');
					that.removeClass('scrolling');
				});
			}
		}
	});

	jQuery(".brand-box").live('mouseenter', function() {
		img = jQuery(this).find('.brand-box-bottle');
		jQuery(this).addClass('bottle-hover');
		if(img.length == 1){
			if(jQuery(this).hasClass('wine')){
				img.stop().animate({'width': hoverWineDim.width, 'height': hoverWineDim.height, 'left' : (defaultWineBoxWidth - hoverWineDim.width)/2}, 300);
			}else{
				img.stop().animate({'width': hoverBottleDim.width, 'height': hoverBottleDim.height, 'left': ((defaultBottleDim.width - hoverBottleDim.width)/2)}, 300);
			}
		}
		if(jQuery(this).prevAll('.brand-box:not(.hidden)').length != 0){
			bottle = jQuery(this).prevAll('.brand-box:not(.hidden)').first();
			imgPrev = bottle.find('.brand-box-bottle');
			if(imgPrev.length == 1 && bottle.next().not(this).length == 0){
				if(jQuery(this).hasClass('wine')){
					imgPrev.stop().animate({'width': middleWineDim.width, 'height': middleWineDim.height, 'left' : (defaultWineBoxWidth - middleWineDim.width)/2}, 300);
				}else{
					imgPrev.stop().animate({'width': middleBottleDim.width, 'height': middleBottleDim.height, 'left': ((defaultBottleDim.width - middleBottleDim.width)/2)}, 300);
				}
			}
		}
		if(jQuery(this).nextAll('.brand-box:not(.hidden)').length != 0){
			bottle = jQuery(this).nextAll('.brand-box:not(.hidden)').first();
			imgNext = bottle.find('.brand-box-bottle');
			if(imgNext.length == 1 && bottle.prev().not(this).length == 0){
				if(jQuery(this).hasClass('wine')){
					imgNext.stop().animate({'width': middleWineDim.width, 'height': middleWineDim.height, 'left' : (defaultWineBoxWidth - middleWineDim.width)/2}, 300);
				}else{
					imgNext.stop().animate({'width': middleBottleDim.width, 'height': middleBottleDim.height, 'left': ((defaultBottleDim.width - middleBottleDim.width)/2)}, 300);
				}
			}
		}
		jQuery(this).stop().animate({'color': '#7E0C3A'}, 300);
	});

	jQuery(".brand-box").live('mouseleave', function() {
		img = jQuery(this).find('.brand-box-bottle');
		jQuery(this).removeClass('bottle-hover');
		if(img.length == 1){
			if(jQuery(this).hasClass('wine')){
				img.stop().animate({'width': defaultWineDim.width, 'height': defaultWineDim.height, 'left': (defaultWineBoxWidth - defaultWineDim.width)/2 }, 300);
			}else{
				img.stop().animate({'width': defaultBottleDim.width, 'height': defaultBottleDim.height, 'left': 0}, 300);
			}
		}
		if(jQuery(this).prevAll('.brand-box:not(.hidden)').length != 0){
			bottle = jQuery(this).prevAll('.brand-box:not(.hidden)').first();
			imgPrev = bottle.find('.brand-box-bottle');
			if(imgPrev.length == 1 && !imgPrev.hasClass('bottle-hover')){
				if(jQuery(this).hasClass('wine')){
					imgPrev.stop().animate({'width': defaultWineDim.width, 'height': defaultWineDim.height, 'left': (defaultWineBoxWidth - defaultWineDim.width)/2}, 300);
				}else{
					imgPrev.stop().animate({'width': defaultBottleDim.width, 'height': defaultBottleDim.height, 'left': 0}, 300);
				}
			}
		}
		if(jQuery(this).nextAll('.brand-box:not(.hidden)').length != 0){
			bottle = jQuery(this).nextAll('.brand-box:not(.hidden)').first();
			imgNext = bottle.find('.brand-box-bottle');

			if(imgNext.length == 1 && !imgNext.hasClass('bottle-hover') ){
				if(jQuery(this).hasClass('wine')){
					imgNext.stop().animate({'width': defaultWineDim.width, 'height': defaultWineDim.height, 'left': (defaultWineBoxWidth - defaultWineDim.width)/2}, 300);
				}else{
					imgNext.stop().animate({'width': defaultBottleDim.width, 'height': defaultBottleDim.height, 'left': 0}, 300);
				}
			}
		}
		jQuery(this).stop().animate({'color': '#000000'}, 300);
	});

	jQuery('.variant-brand-box').live('mouseenter',function(){
		if(jQuery(this).hasClass('withExtraSubmenu')){
			var subSectionId = jQuery(this).attr('name');
			var subSectionName = jQuery(this).find('.sub-group-name').html();
			jQuery('.extraSubmenu').addClass('hidden');
			jQuery('#sub-group-'+subSectionId).removeClass('hidden');
			if(!jQuery('#sub-group-'+subSectionId).find('.flavor-wrapper').hasClass('scroller-bnd')){
				jQuery('#sub-group-'+subSectionId).find('.flavor-wrapper').addClass('scroller-bnd');
				jQuery('#sub-group-'+subSectionId).find('.flavor-wrapper').jScrollPane();
			}
			jQuery('.leftBrandMenu').find('input[type=hidden]').each(function(index, elem){
				if(jQuery(elem).attr('id') !== undefined){
					if(jQuery(elem).attr('id').search('currentSubBrandGroup') != -1){
						jQuery(elem).val(subSectionId);
						return;
					}
				}
			});
			jQuery('.flavors-header').html(subSectionName);
			jQuery('.withExtraSubmenu').removeClass('bold');
			jQuery(this).addClass('bold');
		} else {
			if(!jQuery(this).hasClass('extraVariant')){
				jQuery('.extraSubmenu').addClass('hidden');
				jQuery('.flavors-header').html('');
			}
		}
	});

	jQuery('.variant-brand-box').live('click',function(){
		if(!jQuery(this).hasClass('withExtraSubmenu')){
			if(jQuery(this).hasClass('variant-brand-box-selected')){
				jQuery(this).removeClass('variant-brand-box-selected');
			} else {
				jQuery(this).addClass('variant-brand-box-selected');
			}
			if(jQuery(this).parents('.extraSubmenu').length != 0){
				var subSectionId = jQuery(this).attr('name');
				if(jQuery(this).parent().find('.variant-brand-box-selected').length != 0){
					jQuery('div.withExtraSubmenu[name="'+subSectionId+'"]').addClass('sub-variant-brand-box-selected');
				} else {
					jQuery('div.withExtraSubmenu[name="'+subSectionId+'"]').removeClass('sub-variant-brand-box-selected');
				}
			}
		}

		selectedBrandIdsString = '';
		jQuery('.variant-brand-box-selected').each(function(index, elem){
			if(jQuery(elem).attr('id').length != 0){
				if(selectedBrandIdsString == '' || selectedBrandIdsString == null){
					selectedBrandIdsString = ''+jQuery(elem).attr('id');
				} else {
					selectedBrandIdsString += ','+jQuery(elem).attr('id');
				}
			}
		});
		jQuery('.leftBrandMenu').find('input[type=hidden]').each(function(index, elem){
			if(jQuery(elem).attr('id') !== undefined){
				if(jQuery(elem).attr('id').search('selectedBrandIds') != -1){
					jQuery(elem).val(selectedBrandIdsString);
					return;
				}
			}
		});
		if(!jQuery(this).hasClass('withExtraSubmenu')){
			refreshPageContent();
		}
	});

	jQuery(".variant-brand-box").live('mouseenter', function(){
		jQuery(this).addClass('over');
	});
	jQuery(".variant-brand-box").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});
	intro();

});
