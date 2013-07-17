jQuery('.grid-mode').live('click', function(){
	if(jQuery('.grid-mode').hasClass("active")){
		if(!jQuery(".ListViewContents").hasClass("hidden")){
			jQuery(".ListViewContents").addClass("hidden");
		}
		if(jQuery(".GridViewContents").hasClass("hidden")){
			jQuery(".GridViewContents").removeClass("hidden")
		}

		jQuery(".doc-list .grid-view .doc").each(function() {
			jQuery(this).css("background", jQuery(this).find("input[type='hidden']").val());
		});
	}
});

jQuery('.list-mode').live('click', function(){
	if(jQuery('.list-mode').hasClass("active")){
		if(jQuery(".ListViewContents").hasClass("hidden")){
			jQuery(".ListViewContents").removeClass("hidden");
		}
		if(!jQuery(".GridViewContents").hasClass("hidden")){
			jQuery(".GridViewContents").addClass("hidden")
		}

		jQuery(".doc-list .list-view .doc").each(function() {
			jQuery(this).css("background", "");
		});
	}
});