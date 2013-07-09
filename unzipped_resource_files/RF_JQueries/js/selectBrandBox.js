// **** STANDARD VIEW & FILTERS ****

// select brand (select from brand box)
jQuery('.brand-box').live('click',function(){
	if (jQuery(this).attr('id') == 'Portfolio') {
		if(jQuery(this).hasClass('brand-box-selected')){
			jQuery(this).removeClass('brand-box-selected');
		} else {
			jQuery(this).addClass('brand-box-selected');
		}
		jQuery('.PortfolioCheckbox', this).attr('checked', jQuery(this).hasClass('brand-box-selected'));
		return false;
	} else if (jQuery(this).attr('id') == 'ADB') {
		jQuery("#showaccordion").trigger('click');
		return false;
	} else if (jQuery(this).attr('id') == 'RTS') {
		if(jQuery(this).hasClass('brand-box-selected')){
			jQuery(this).removeClass('brand-box-selected');
		} else {
			jQuery(this).addClass('brand-box-selected');
		}
		jQuery('.RTSCheckbox', this).attr('checked', jQuery(this).hasClass('brand-box-selected'));
		return false;
	} else {
		if(jQuery(this).hasClass('brand-box-selected')){
			jQuery(this).removeClass('brand-box-selected');
			if(jQuery(this).find('input[type=checkbox]').length != 0){
				jQuery(this).find('input[type=checkbox]').attr('checked', false);
			}
		} else {
			jQuery(this).addClass('brand-box-selected');
			if(jQuery(this).find('input[type=checkbox]').length != 0){
				jQuery(this).find('input[type=checkbox]').attr('checked', true);
			}
		}
		selectedBrandIdsString = '';
		jQuery('.brand-box-selected').each(function(index, elem){
			brandId = jQuery(elem).attr('id');
			if(brandId.length != 0 && brandId != 'RTS' && brandId != 'ADB' && brandId != 'Portfolio'){
				if(selectedBrandIdsString == '' || selectedBrandIdsString == null){
					selectedBrandIdsString = ''+jQuery(elem).attr('id');
				} else {
					selectedBrandIdsString += ','+jQuery(elem).attr('id');
				}
			}
		});

		jQuery('.brandFilterWrapper').find('input[type=hidden]').each(function(index, elem){
			if(jQuery(elem).attr('id') !== undefined){
				if(jQuery(elem).attr('id').search('selectedBrandIds') != -1){
					jQuery(elem).val(selectedBrandIdsString);
					return;
				}
			}
		});
	}
	setSelectAllBrandsCheckboxValue();
	if(jQuery('.brand-box-selected').not('#Portfolio').not('#RTS').not('#ADB').size() == 1){
		if(jQuery('.brand-box-selected').not('#Portfolio').not('#RTS').not('#ADB').first().attr('id').length != 0){
			updateVariantBrands(''+jQuery('.brand-box-selected').not('#Portfolio').not('#RTS').not('#ADB').first().attr('id')+'');
		}
	} else {
		if(jQuery('.child-brand-box').not('#Portfolio').not('#RTS').not('#ADB').size() != 0){
			clearVariantBrands();
		}
	}
	countCheckBrands();
});


// select brand (select from brand box)
jQuery('.child-brand-box').live('click',function(){
	if(jQuery(this).hasClass('child-brand-box-selected')){
		jQuery(this).removeClass('child-brand-box-selected');
		jQuery(this).find('input[type=checkbox]').attr('checked', false);
	} else {
		jQuery(this).addClass('child-brand-box-selected');
		jQuery(this).find('input[type=checkbox]').attr('checked', true);
	}
	selectedChildBrandIdsString = '';
	jQuery('.child-brand-box-selected').each(function(index, elem){
		if(jQuery(elem).attr('id').length != 0){
			if(selectedChildBrandIdsString == '' || selectedChildBrandIdsString == null){
				selectedChildBrandIdsString = ''+jQuery(elem).attr('id');
			} else {
				selectedChildBrandIdsString += ','+jQuery(elem).attr('id');
			}
		}
	});
	jQuery('.variantFilterWrapper').find('input[type=hidden]').each(function(index, elem){
		if(jQuery(elem).attr('id') !== undefined){
			if(jQuery(elem).attr('id').search('selectedChildBrandIds') != -1){
				jQuery(elem).val(selectedChildBrandIdsString);
				return;
			}
		}
	});
	setSelectAllChildBrandsCheckboxValue();
});

// select time period
jQuery('.label-time-period').live('click',function(){
	if(jQuery(this).hasClass('time-box-selected')){
		jQuery(this).removeClass('time-box-selected');
		jQuery(this).removeClass('time-hover');
	} else {
		jQuery(this).addClass('time-box-selected');
	}
	selectedQuartersString = '';
	jQuery('.time-box-selected').each(function(index, elem){
		if(jQuery(elem).attr('name').length != 0){
			if(selectedQuartersString == '' || selectedQuartersString == null){
				selectedQuartersString = ''+jQuery(elem).attr('name');
			} else {
				selectedQuartersString += ','+jQuery(elem).attr('name');
			}
		}
	});
	jQuery('.timeFilterWrapper').find('input[type=hidden]').each(function(index, elem){
		if(jQuery(elem).attr('id') !== undefined){
			if(jQuery(elem).attr('id').search('selectedQuarters') != -1){
				jQuery(elem).val(selectedQuartersString);
				return;
			}
		}
	});
});
// select all brand functionality
jQuery('.selectAllBrands').live('click', function(){
	selectedBrandIdsString = '';
	clearVariantBrands();
	if(jQuery(this).is(':checked')){
		jQuery('.brand-box').not('.hidden').each(function(index, elem){
			if (jQuery(elem).attr('id').length != 0) {
				if (jQuery(elem).attr('id')!='Portfolio' && jQuery(elem).attr('id')!='RTS' && jQuery(elem).attr('id')!='ADB') {
					if(selectedBrandIdsString == '' || selectedBrandIdsString == null){
						selectedBrandIdsString = ''+jQuery(elem).attr('id');
					} else {
						selectedBrandIdsString += ','+jQuery(elem).attr('id');
					}
				}
				jQuery(elem).addClass('brand-box-selected');
			}
			if(jQuery(elem).find('input[type=checkbox]').length != 0){
				jQuery(elem).find('input[type=checkbox]').attr('checked', true);
			}                   
		});
	} else {
		jQuery('.brand-box').each(function(index, elem){
			if(jQuery(elem).attr('id').length != 0){
				jQuery(elem).removeClass('brand-box-selected');
			}
			if(jQuery(elem).find('input[type=checkbox]').length != 0){
				jQuery(elem).find('input[type=checkbox]').attr('checked', false);
			}                   
		});
	}
	jQuery('.brandFilterWrapper').find('input[type=hidden]').each(function(index, elem){
		if(jQuery(elem).attr('id') !== undefined){
			if(jQuery(elem).attr('id').search('selectedBrandIds') != -1){
				jQuery(elem).val(selectedBrandIdsString);
				return;
			}
		}
	});     
});

// select all child brand functionality
jQuery('.selectAllChildBrands').live('click', function(){
	selectedChildBrandIdsString = '';
	if(jQuery(this).is(':checked')){
		jQuery('.child-brand-box').not('.hidden').each(function(index, elem){
			if(jQuery(elem).attr('id').length != 0){
				if(selectedChildBrandIdsString == '' || selectedChildBrandIdsString == null){
					selectedChildBrandIdsString = ''+jQuery(elem).attr('id');
				} else {
					selectedChildBrandIdsString += ','+jQuery(elem).attr('id');
				}
				jQuery(elem).addClass('child-brand-box-selected');
				jQuery(elem).find('input[type=checkbox]').attr('checked', true);
			}
		});
	} else {
		clearVariantBrandsSelected();
		jQuery('.child-brand-box').each(function(index, elem){
			if(jQuery(elem).attr('id').length != 0){
				jQuery(elem).removeClass('child-brand-box-selected');
				jQuery(elem).find('input[type=checkbox]').attr('checked', false);
			}
		});
	}
	jQuery('.variantFilterWrapper').find('input[type=hidden]').each(function(index, elem){
		if(jQuery(elem).attr('id') !== undefined){
			if(jQuery(elem).attr('id').search('selectedChildBrandIds') != -1){
				jQuery(elem).val(selectedChildBrandIdsString);
				return;
			}
		}
	});     
});