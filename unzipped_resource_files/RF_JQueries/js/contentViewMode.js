jQuery('.grid-mode').live('click', function(){
	if(jQuery('.grid-mode').hasClass("active")){
		if(!jQuery(".ListViewContents").hasClass("hidden")){
			jQuery(".ListViewContents").addClass("hidden");
		}
		if(jQuery(".GridViewContents").hasClass("hidden")){
			jQuery(".GridViewContents").removeClass("hidden")
		}
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
	}
});