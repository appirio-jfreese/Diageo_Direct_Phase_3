var defaultBoxPosition = [];

jQuery.fn.reverse = function() {
	return this.pushStack(this.get().reverse(), arguments);
};

function initPosition(){
	indexHorizontal = 0;
	indexVertical = 0;
	jQuery('.section-box').each(function(index){
		leftPostition = indexHorizontal*315;
		topPosition = indexVertical*180;
		indexHorizontal++;
		if(index % 3 == 2){
			indexVertical++;
			indexHorizontal = 0;
		}

		elemId = jQuery(this).attr('id');
		defaultBoxPosition[elemId] = {top: topPosition, left: leftPostition};
		jQuery(this).css({'top': topPosition, 'left': leftPostition, opacity: 0});
		jQuery(this).removeClass('hidden');
		jQuery(this).stop().animate({opacity: 1}, 1000);
	});
	jQuery('.section-back').css('opacity', 0);
	jQuery('.sub-section-box').each(function(){
		index = jQuery(this).index();
		if(index > 10){
			index = 10;
		}
		whiteMaskOpacity = index*0.03;
		jQuery(this).find('.white-mask').css('opacity', whiteMaskOpacity);
		bgPosition = '-'+(10+Math.floor(Math.random()*180))+'px 0px';
		jQuery(this).css({backgroundPosition: bgPosition});
	});

	jQuery('.section-back').removeClass('hidden');
	jQuery('.sub-section-box').css('opacity', 0);
	jQuery('.section-box').find('.white-mask').css('opacity', 0);
}


jQuery(document).ready(function() {
	initPosition();

	jQuery('.sub-section-box').mouseenter(function(){
		whiteMaskOpacity = 0.6;
		jQuery(this).find('.white-mask').css('opacity', whiteMaskOpacity);
	});

	jQuery('.sub-section-box').mouseleave(function(){
		index = jQuery(this).index();
		if(index > 10){
			index = 10;
		}
		whiteMaskOpacity = index*0.03;
		jQuery(this).find('.white-mask').css('opacity', whiteMaskOpacity);
	});

	jQuery('.section-box').mouseenter(function(){
		if(!jQuery(this).hasClass('selected')){
			whiteMaskOpacity = 0.4;
			jQuery(this).find('.white-mask').css('opacity', whiteMaskOpacity);
		}
	});

	jQuery('.section-box').mouseleave(function(){
		if(!jQuery(this).hasClass('selected')){
			jQuery(this).find('.white-mask').css('opacity', 0);
		}
	});

	jQuery('.section-box').click(function(){
		if(jQuery('.selected').length == 0){
			jQuery(this).addClass('selected');
			boxElem = jQuery(this);
			boxElemId = boxElem.attr('id');
			whiteMaskOpacity = 0.4;
			jQuery(this).find('.white-mask').css('opacity', whiteMaskOpacity);
			jQuery('.section-box').not(this).stop().animate({opacity: 0}, 600, function(){
				jQuery(this).addClass('hidden');
				boxElem.stop().animate({top: 0, left: 0}, 600, function(){
					boxElem.children('.section-back').stop().animate({opacity: 1}, 400);
					jQuery('#sub-menu-'+boxElemId).children().each(function(index){
						jQuery(this).removeClass('hidden');
						jQuery(this).stop().delay(index*150).animate({opacity: 1}, 400, function(){

						});
					});
				});
			});
		}
	});

	jQuery('.section-back').click(function(){
		boxElem = jQuery(this).parent();
		boxElemId = boxElem.attr('id');
		boxElemDefaultPosition = defaultBoxPosition[boxElemId];
		button = jQuery(this);
		if(boxElem.hasClass('selected')){
			subMenuElems = jQuery('#sub-menu-'+boxElemId).children();
			numberOfsubMenuElems = subMenuElems.size();
			subMenuElems.reverse().each(function(index){
				jQuery(this).stop().delay(index*150).animate({opacity: 0}, 400, function(){
					jQuery(this).addClass('hidden');
					if(index == numberOfsubMenuElems - 1){
						button.stop().animate({opacity: 0}, 400);
						boxElem.find('.white-mask').css('opacity', 0);
						boxElem.stop().animate({top: boxElemDefaultPosition.top, left: boxElemDefaultPosition.left}, 600, function(){
							jQuery('.section-box').removeClass('hidden');
							jQuery('.section-box').not(this).stop().animate({opacity: 1}, 600, function(){
							boxElem.removeClass('selected');
							});
						});
					}
				});
			});
		}
	});
});
