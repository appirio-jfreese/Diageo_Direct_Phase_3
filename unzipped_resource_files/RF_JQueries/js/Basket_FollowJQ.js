function bindFilterJs(){

}

jQuery(document).ready(function() {
    if(jQuery('#basketWarning').length == 1){
        if(jQuery('#basketWarning').hasClass('showRequired')){
            showDialog('basketWarning');
        }
    }

    jQuery('button.confirm-no').live('click',function(){
        hideDialog('confirmDelete');
    });
    
    jQuery('button.confirm-clearall-no').live('click', function(){
       hideDialog('confirmDeleteAllBasketItems');
    });
    
    jQuery('#tryClearBasket').live('click', function(){
     showDialog('confirmDeleteAllBasketItems',true);    
    });
    
    jQuery('button.confirm-yes').live('click',function(){
        if(jQuery('#possibleItemsToRemove').val() != '' && jQuery('#possibleItemsToRemove').val() != null){
            removeFromBasketMultiple(jQuery('#possibleItemsToRemove').val());
        }
        hideDialog('confirmDelete');
    });

    // Start : Changes for US79/DE581 : Basant Verma
    /*jQuery('.emptyBasketPopupRequired').live('click',function(){
        if(jQuery('#possibleItemsToRemove').length == 1){
            showDialog('confirmDelete');
        }
    });*/
    // End : Changes for US79/DE581 : Basant Verma

    calculateBoxHeight();
    bindFilterJs();
});
