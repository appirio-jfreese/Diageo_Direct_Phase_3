jQuery.fn.hasScrollBar = function() {
    return this.get(0).scrollHeight > this.height();
}
    
function bindFilterJs(){
    jQuery('.recipientsinfowrapper').each(function(){
        if(jQuery(this).hasScrollBar()){
            jQuery(this).find('.showAllRec').removeClass('hidden');
        }
    });
}


jQuery(document).ready(function() {
    jQuery('.showAllRec').live('click', function(){
        rwrapper = jQuery(this).parents('.recipientsinfowrapper');
        if(rwrapper.length != 1){
            return false;
        }
        jQuery(this).find('.info-history-more-img').addClass('hidden');
        if(jQuery(this).hasClass('expandeddetails')){
            elem = jQuery(this);
            elem.find('.textholder').html('More');
            jQuery(this).find('.more').removeClass('hidden');
            rwrapper.stop().animate({'height': '18px'}, 500, function(){
                elem.removeClass('expandeddetails');
            });
            
        } else {
            if(!isNaN(rwrapper.get(0).scrollHeight)){
                elem = jQuery(this);
                elem.find('.textholder').html('Less');
                jQuery(this).find('.less').removeClass('hidden');
                rwrapper.stop().animate({'height': rwrapper.get(0).scrollHeight+'px'}, 500, function(){
                    elem.addClass('expandeddetails');
                });
            }
        }
    });
    
    calculateBoxHeight();
    bindFilterJs();
    
});
