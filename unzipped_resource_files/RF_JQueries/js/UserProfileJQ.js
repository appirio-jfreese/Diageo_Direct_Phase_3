jQuery(document).ready(function() {

    var isiPad = navigator.userAgent.match(/iPad/i) != null;        
    if( isiPad == true){  
        jQuery('table.profile-table tr').live('touchstart',function(event){
            if ( !(jQuery(event.target).hasClass("save-button") || jQuery(event.target).hasClass("edit-button") || jQuery(event.target).hasClass("cancel-button"))){
                if(jQuery('.edit-in-progress').length == 0){
                    jQuery('table.profile-table tr').removeClass('active-row');
                    jQuery('.edit-option').addClass('hidden');                  
                    jQuery(this).find('.save-option').addClass('hidden');
                    jQuery(this).find('.edit-option').removeClass('hidden');
                    jQuery(this).addClass('active-row');
                }
            }
        });
        
        jQuery('.edit-button').live('touchstart',function(){
            if(jQuery(this).parents('.editable').length != 0){
                var editable = jQuery(this).parents('.editable').first();
                editable.addClass('edit-in-progress');
                editable.find('.save-option').removeClass('hidden');
                editable.find('.edit-option').addClass('hidden');
                editable.parent().find('.t-value').addClass('hidden');
                editable.parent().find('.e-value').removeClass('hidden');
                jQuery('.custom-select-box-values').jScrollPane();
            }               
        });

        jQuery('.cancel-button').live('touchstart',function(){
            var editable = jQuery(this).parents('.editable').first();
            editable.removeClass('edit-in-progress');           
            editable.find('.save-option').addClass('hidden');
            editable.find('.edit-option').removeClass('hidden');
            editable.parent().find('.e-value').addClass('hidden');
            editable.parent().find('.t-value').removeClass('hidden');
            cancelEdit();           
        });

        jQuery('.save-button').live('touchstart',function(){
            if(jQuery(this).parents('.editable').length != 0){
                var editable = jQuery(this).parents('.editable').first();
                editable.removeClass('edit-in-progress');
                editable.find('.save-option').addClass('hidden');
                editable.find('.edit-option').removeClass('hidden');
                editable.parent().find('.e-value').addClass('hidden');
                editable.parent().find('.t-value').removeClass('hidden');
                updateUserRecord();
            }
        }); 
    }else{
        jQuery('table.profile-table tr').live('mouseenter',function(){
            if(jQuery('.edit-in-progress').length == 0){
                jQuery(this).find('.save-option').addClass('hidden');
                jQuery(this).find('.edit-option').removeClass('hidden');
                jQuery(this).addClass('active-row');
            }
        });
        jQuery('table.profile-table tr').live('mouseleave',function(){
            if(!jQuery(this).find('.editable').hasClass('edit-in-progress')){
                jQuery(this).find('.edit-option').addClass('hidden');
                jQuery(this).find('.save-option').addClass('hidden');
                jQuery(this).removeClass('active-row');
            }
        });             
    
        jQuery('.edit-button').live('click',function(){
            if(jQuery(this).parents('.editable').length != 0){
                var editable = jQuery(this).parents('.editable').first();
                editable.addClass('edit-in-progress');
                editable.find('.save-option').removeClass('hidden');
                editable.find('.edit-option').addClass('hidden');
                editable.parent().find('.t-value').addClass('hidden');
                editable.parent().find('.e-value').removeClass('hidden');
                jQuery('.custom-select-box-values').jScrollPane();
            }
        });

        jQuery('.cancel-button').live('click',function(){
            if(jQuery(this).parents('.editable').length != 0){
                var editable = jQuery(this).parents('.editable').first();
                editable.removeClass('edit-in-progress');
                editable.find('.save-option').addClass('hidden');
                editable.find('.edit-option').removeClass('hidden');
                editable.parent().find('.e-value').addClass('hidden');
                editable.parent().find('.t-value').removeClass('hidden');
                cancelEdit();
            }
        });

        jQuery('.save-button').live('click',function(){
            if(jQuery(this).parents('.editable').length != 0){
                var editable = jQuery(this).parents('.editable').first();
                editable.removeClass('edit-in-progress');
                editable.find('.save-option').addClass('hidden');
                editable.find('.edit-option').removeClass('hidden');
                editable.parent().find('.e-value').addClass('hidden');
                editable.parent().find('.t-value').removeClass('hidden');
                updateUserRecord();
            }
        });
    }   
});
