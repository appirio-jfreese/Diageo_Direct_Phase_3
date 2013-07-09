jQuery(document).ready(function() {
			
    jQuery("button.update-filter").live('mouseenter', function() {
		jQuery(this).addClass('over');
    }); 

    jQuery("button.update-filter").live('mouseleave', function(){
		jQuery(this).removeClass('over');
    }); 

    jQuery("div.home-page-box").hover(
		function() {
			var menuItems = jQuery("div.home-page-box-menu-items", this);
			if( menuItems.length ==0){
				jQuery("div.home-page-box-title", this).stop(true).animate({'top': 25}, 500);
				jQuery("div.home-page-box-title-bg", this).stop(true).animate({'opacity':'0.75'}, 500);
			} else {
				jQuery("div.home-page-box-title", this).stop(true).animate({'top': 0, 'height': 50}, 500);
				jQuery("div.home-page-box-title-bg", this).stop(true).animate({'opacity':'0.75'}, 500);
				jQuery("div.home-page-box-title-text", this).stop(true).animate({'paddingTop':7,'paddingBottom':5 }, 500);
				//  menuItems.show();
				menuItems.stop(true).animate({'top':50,'height':115, opacity: 1 }, 500);
			}
			
		},
		function() {
			var menuItems = jQuery("div.home-page-box-menu-items", this);
			if( menuItems.length ==0){
				jQuery("div.home-page-box-title", this).animate({'top': 42}, 500);
				jQuery("div.home-page-box-title-bg", this).animate({'opacity':'0.95'}, 500);
			} else {
				jQuery("div.home-page-box-title", this).stop(true).animate({'top': 42, 'height': 90}, 500);
				jQuery("div.home-page-box-title-bg", this).stop(true).animate({'opacity':'0.95'}, 500);
				jQuery("div.home-page-box-title-text", this).stop(true).animate({'paddingTop':30,'paddingBottom':30}, 500);
				menuItems.stop(true).animate({'top':42,'height':50, opacity: 0 }, 500);
				//  menuItems.hide();
			}
		}
    )
    jQuery('.home-page-news-wrapper').jScrollPane();
});