jQuery('.grid-mode').live('click', function(){
	if(jQuery('.grid-mode').hasClass("active")){
		if(!jQuery('.grid-mode').hasClass("DoNotCallActionFunction")){
			renderAsBoxSlider();
		}else{
			jQuery('.grid-mode').removeClass("DoNotCallActionFunction");
			if(!jQuery(".ListViewContents").hasClass("hidden")){
				jQuery(".ListViewContents").addClass("hidden");
			}
			if(jQuery(".GridViewContents").hasClass("hidden")){
				jQuery(".GridViewContents").removeClass("hidden")
			}

			jQuery(".doc-list .grid-view .doc").each(function() {
				if(jQuery(this).find("input[type='hidden']").val() == "IMG"){
					jQuery(this).css("background", "");
				}else{
					jQuery(this).css("background", jQuery(this).find("input[type='hidden']").val());
				}
			});
		}
		closeAllGear();
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
		closeAllGear();
		
		if(!jQuery('.list-mode').hasClass("DoNotCallActionFunction")){
			// I think we don't need to rerender page in this case
			//renderAsListSlider();
		}else{
			jQuery('.list-mode').removeClass("DoNotCallActionFunction");
		}
	}
});


function closeAllGear(){
	jQuery(".doc-btns").each(function() {
		jQuery(this).css("display", "none");
	});
}