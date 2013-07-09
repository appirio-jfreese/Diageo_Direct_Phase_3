function bindFilterJs(){
	bindFilter4SMnCD();

	// classification display
	classification = jQuery('.classification-wrapper');
	if(!classification.hasClass('cls-js')){
		classification.addClass('cls-js')
		var breakIndex = null;
		if(classification.hasClass('PSM')){
			breakIndex = 5;
		} else if(classification.hasClass('IVSM')){
			breakIndex = 5;
		}
		if(breakIndex != null){
			tr = classification.find('tr');
			tr.after('<tr class="sec-class-row"></tr>');
			tr.after('<tr><td><br></td></tr>');
			tr.find('td').each(function(){
			elem = jQuery(this);
				if(elem.index() > breakIndex){
					jQuery('.sec-class-row').append(elem.clone());
					elem.remove();
				}
			});
		}
	}
}

var orgSelectedBrandCategories;
function initialize(){
	calculateBoxHeight();
	orgSelectedBrandCategories = jQuery('input[id*=selectedBrandCategories]').val();
}

jQuery(document).ready(function() {
	initialize();
	bindFilterJs();

	//select brand category
	jQuery('.category-brand-box').live('click',function(){
			if(jQuery(this).hasClass('category-brand-box-selected')){
			jQuery(this).removeClass('category-brand-box-selected');
			jQuery(this).find('input[type=checkbox]').attr('checked', false);
		} else {
			jQuery(this).addClass('category-brand-box-selected');
			jQuery(this).find('input[type=checkbox]').attr('checked', true);
		}

		selectedCategoryBrandString = '';
		jQuery('.brand-box-selected', jQuery(this).parent()).not('.TBA').each(function(index, elem){
			if(jQuery(elem).attr('name').length != 0){
				if(selectedCategoryBrandString == '' || selectedCategoryBrandString == null){
					selectedCategoryBrandString = ''+jQuery(elem).attr('name');
				} else {
					selectedCategoryBrandString += ','+jQuery(elem).attr('name');
				}
			}
		});
		jQuery('input[id*=selectedBrandCategories]').val(selectedCategoryBrandString);
	});


	jQuery('.previous-period').live('click',previousPeriod);
	jQuery('.next-period').live('click',nextPeriod);
	jQuery('.label-time-period').live('mouseenter',function(){
		jQuery(this).addClass('time-hover');
	});
	jQuery('.label-time-period').live('mouseleave',function(){
		jQuery(this).removeClass('time-hover');
	});
	iPadContentItemList();

});
