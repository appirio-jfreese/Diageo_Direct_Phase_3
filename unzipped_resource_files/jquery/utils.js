// show dialog
function showDialog(divId, showBeforeLoader){
	if(jQuery('#'+divId).length == 0){
		return false;
	}
	var messageBox = jQuery('#'+divId);
    if(!messageBox.hasClass('hidden')){
		return true;
	}
	
	if(jQuery('.pilDialog').length != 0 && !messageBox.hasClass('pilDialog')){
		jQuery('.pilDialog').css('z-index', 1999);
	}
	
	if(showBeforeLoader === undefined){
		if(divId != 'ajaxLoader' && !messageBox.hasClass('readyToShow')){
			var loaderBox = jQuery('#ajaxLoader');	
			if(loaderBox.length != 0){ // @todo: check loader status
				messageBox.addClass('readyToShow');
				return true;
			}
		}
	}
	
	var overlayDisable;
	if(divId != 'ajaxLoader'){
		overlayDisable = jQuery('#overlayDisable');
	} else {
		overlayDisable = jQuery('#loaderOverlayDisable');
	}
	
	if(overlayDisable.length != 0){
        overlayDisable.css('opacity', 0.7);
        overlayDisable.css('height', jQuery(document).height());        
        overlayDisable.css('width', jQuery(document).width()); 
	}

    var actualWindowWidth = jQuery(window).width();
    var actualWindowHeight = jQuery(window).height();
    var verticalScrollPosition = jQuery(document).scrollTop();
    var horizontalScrollPosition = jQuery(document).scrollLeft();
            
    var left = horizontalScrollPosition + (actualWindowWidth/2) - ((messageBox.width()) / 2);
    var top = verticalScrollPosition + (actualWindowHeight/2) - ((messageBox.height()) / 2);

	if(top<0) top = 0;
	if(left<0) left = 0;
			
    messageBox.css('top', top);
    messageBox.css('left', left);            

	messageBox.fadeIn(350,function(){
		jQuery(this).removeClass('hidden');
		jQuery(this).removeClass('readyToShow');		
	}); 
      
	return true;
}

// hide dialog 
function hideDialog(divId){
	if(jQuery('#'+divId).length == 0){
		return false;
	}        
	var messageBox = jQuery('#'+divId);
           
	if(messageBox.hasClass('hidden')){
		return true;
	}
	
	if(jQuery('.pilDialog').length != 0 && !messageBox.hasClass('pilDialog')){
		jQuery('.pilDialog').css('z-index', 2001);
	}
	
	messageBox.fadeOut(250,function(){
		jQuery(this).addClass('hidden');

		if(divId == 'ajaxLoader'){
			jQuery('#loaderOverlayDisable').css('opacity', 0);
			jQuery('#loaderOverlayDisable').css('height',0);			
		}
		
		if(jQuery('.readyToShow').length == 0){
			if(jQuery('.dialog:not(.hidden)').length == 0){
				if(jQuery('#overlayDisable').length != 0){
					jQuery('#overlayDisable').css('opacity', 0);
					jQuery('#overlayDisable').css('height',0);
				}
			}
		} else {
			jQuery('.readyToShow').each(function(){
				dialogId = jQuery(this).attr('id');
				if(dialogId.length != 0){
					showDialog(dialogId);
				}   
			});
		}
	});
	return true;
}

/* 
 * JQuery CSS Rotate property using CSS3 Transformations
 * Copyright (c) 2011 Jakub Jankiewicz  <http://jcubic.pl>
 * licensed under the LGPL Version 3 license.
 * http://www.gnu.org/licenses/lgpl.html
 */
(function($) {
    function getTransformProperty(element) {
        var properties = ['transform', 'WebkitTransform',
                          'MozTransform', 'msTransform',
                          'OTransform'];
        var p;
        while (p = properties.shift()) {
            if (element.style[p] !== undefined) {
                return p;
            }
        }
        return false;
    }
    $.cssHooks['rotate'] = {
        get: function(elem, computed, extra){
            var property = getTransformProperty(elem);
            if (property) {
                return elem.style[property].replace(/.*rotate\((.*)deg\).*/, '$1');
            } else {
                return '';
            }
        },
        set: function(elem, value){
            var property = getTransformProperty(elem);
            if (property) {
                value = parseInt(value);
                $(elem).data('rotatation', value);
                if (value == 0) {
                    elem.style[property] = '';
                } else {
                    elem.style[property] = 'rotate(' + value%360 + 'deg)';
                }
            } else {
                return '';
            }
        }
    };
    $.fx.step['rotate'] = function(fx){
        $.cssHooks['rotate'].set(fx.elem, fx.now);
    };
})(jQuery);

