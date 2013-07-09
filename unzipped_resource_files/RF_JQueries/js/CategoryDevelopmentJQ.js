function bindFilterJs(){
	bindFilter4SMnCD();
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
		jQuery('.category-brand-box-selected', jQuery(this).parent()).not('.TBA').each(function(index, elem){
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

	iPadContentItemList();
});
