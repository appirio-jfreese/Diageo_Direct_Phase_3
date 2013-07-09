jQuery(document).ready(function() {
    var isiPad = navigator.userAgent.match(/iPad/i) != null;        
    
    if( isiPad == true){                                                    
	jQuery(".tooltip").bind('touchstart', function(){ 
	    var offset = jQuery(this).offset()
	
	    var tooltContentBefore = '<div id="tooltip" style="display: none; left: '+ (offset.left + 80) +'px; right: auto; top: '+ (offset.top + 50) +'px;">'
				+'<h3 style="display: none;"></h3>'
				+'<div class="body">';
				
	    var tooltContentAfter = '</div><div class="url" style="display: none;"></div></div>';                                                               
	    
	    if(jQuery(this).attr('id').length!=0 ){
		    tooltipId = jQuery(this).attr('id');
		    if(!jQuery('#tooltip-'+tooltipId).hasClass('disableTooltip')){
			tooltContent = jQuery('#tooltip-'+tooltipId).html();
			jQuery('#tooltipIpad').html(tooltContentBefore + tooltContent + tooltContentAfter);
			jQuery('#tooltipIpad').find('#tooltip').show();
		    } else {
			return false;
		    }
	    } else {
		return false;
	    }                               
	}); 
	
	jQuery(".tooltip").bind('touchend', function(){
	    jQuery('#tooltipIpad').find('#tooltip').hide();
	});
						    
    }else{                   
	jQuery('.tooltip').tooltip({ 
	    bodyHandler: function() { 
		if(jQuery(this).attr('id').length!=0 ){
		    tooltipId = jQuery(this).attr('id');
		    if(!jQuery('#tooltip-'+tooltipId).hasClass('disableTooltip')){
			return jQuery('#tooltip-'+tooltipId).html();
		    } else {
			return false;
		    }
		} else {
		    return false;
		}
	    }, 
	    showURL: false,
	    track: true,
	    fade: 250 
	});
    }
    
    
});

function bindJs(){
if(!jQuery('.general-updates-list').hasClass('jsbinded')){
    jQuery('.general-updates-list').jScrollPane();
    jQuery('.general-updates-list').addClass('jsbinded');
}
}
jQuery(document).ready(function() {
	//calculating max height of the second general updates list 
	var lists = jQuery('.general-updates-list');
	var firstList = jQuery('.general-updates-list.first-list');
	if(firstList.length > 0){
		if(lists.length > 1){
		var height = firstList.height();
		var calculateHeight = 392 - height;
		jQuery(lists[1]).css('max-height', calculateHeight+'px');
		}
	}

	bindJs();
        
});