// Action called when section-option clicked 
jQuery('.section-options').live('click', function(){
	jQuery(".section-options").each(function() {
		if(jQuery(this).hasClass('active')){
			jQuery(this).removeClass('active');
		}
	});
	jQuery(this).addClass('active');
	if(jQuery('.grid-mode').hasClass("active")){
		renderAsBoxSlider();
	}else{
		sectionVisibility();
	}
});


function uncheckAllDoc(){
	jQuery(".doc-list input[type='checkbox']:checked").each(function(){
		if(jQuery(this).prop('checked')){
			jQuery(this).trigger("click");
		}
	});
	jQuery(".select-all input[type='checkbox']").each(function(){
		if(jQuery(this).prop('checked')){
			jQuery(this).trigger("click");
		}
	});
}

// Hide or show the section based on selected section-option
function sectionVisibility(){
	uncheckAllDoc();
	
	closeAllGear();
	
	jQuery(".section-options").each(function() {
		var currentSectionClass = jQuery(this).text()+"-Section";
		if(jQuery(this).hasClass('active')){
			jQuery("."+pageNamePrefix+"-Section-Blok").each(function() {
		if(jQuery(this).hasClass(currentSectionClass)){
		  if(jQuery(this).hasClass('hidden')){
			jQuery(this).removeClass('hidden');
		  }
		  if(!jQuery(this).hasClass('noContent')){
			jQuery(".operation-line").each(function() {
			  if(jQuery(this).hasClass('hidden')){
				jQuery(this).removeClass('hidden');
			  }
			  if(!jQuery(".operation-line a").hasClass("disabled")){
				jQuery(".operation-line a").addClass("disabled");
			  }
			});
			jQuery(".filter").each(function() {
			  if(jQuery(this).hasClass('hidden')){
				jQuery(this).removeClass('hidden');
			  }
			});
		  }
		if(jQuery(this).hasClass('noContent')){
			jQuery(".operation-line").each(function() {
			  if(!jQuery(this).hasClass('hidden')){
				jQuery(this).addClass('hidden');
			  }
			});
			jQuery(".filter").each(function() {
			  if(!jQuery(this).hasClass('hidden')){
				jQuery(this).addClass('hidden');
			  }
			});
		  }   
		}
			});
		}else{
			jQuery("."+pageNamePrefix+"-Section-Blok").each(function() {
		if(jQuery(this).hasClass(currentSectionClass)){
					if(!jQuery(this).hasClass('hidden')){
				jQuery(this).addClass('hidden');
			}
				}
			});
		}
	});
	
	if(jQuery('.grid-mode').hasClass("active")){
		if(!jQuery('.grid-mode').hasClass("DoNotCallActionFunction")){
			jQuery('.grid-mode').addClass("DoNotCallActionFunction");
		}
		jQuery('.grid-mode').trigger("click");
	}else if(jQuery('.list-mode').hasClass("active")){
		if(!jQuery('.list-mode').hasClass("DoNotCallActionFunction")){
			jQuery('.list-mode').addClass("DoNotCallActionFunction");
		}
		jQuery('.list-mode').trigger("click");
	}
}