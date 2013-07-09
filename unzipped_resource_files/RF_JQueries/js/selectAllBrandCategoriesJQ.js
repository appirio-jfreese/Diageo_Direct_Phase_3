//selectAllBrandCategories
jQuery('.selectAllBrandCategories').live('click', function(){
	selectedBrandCategoriesString = '';
	if(jQuery(this).is(':checked')){

		jQuery('.category-brand-box').addClass('category-brand-box-selected');
		jQuery('.category-brand-box input[type=checkbox]').attr('checked', true);

		jQuery('input[id*=selectedBrandCategories]').val('{!allCategoriesString}');

	} else {
		jQuery('.category-brand-box').removeClass('category-brand-box-selected');
		jQuery('.category-brand-box input[type=checkbox]').attr('checked', false);

		jQuery('input[id*=selectedBrandCategories]').val('');
	}
});