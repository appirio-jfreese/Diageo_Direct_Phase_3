function populateFileUploadWithCurrentDestination(){
	firstDestination = jQuery('.one-destination-wrapper').first();

	if(firstDestination.length == 1){
		// hide other destinations
		jQuery('.one-destination-wrapper').not(firstDestination).addClass('hidden');
		jQuery('.destinationIndexHolder').val('0,');

		var folderIdsString = jQuery('#currentLocationUpload').find('input.currentFoldersIds').val()+',';
		var folderNameString = jQuery('#currentLocationUpload').find('input.currentFoldersNames').val()+',';
		var geographyUploadId = jQuery('#currentLocationUpload').find('input.currentOrgUnitId').val();
		var geographyUploadName = jQuery('#currentLocationUpload').find('input.currentOrgUnitName').val();
		var distributorUploadId = jQuery('#currentLocationUpload').find('input.currentDistributorId').val();
		var distributorUploadName = jQuery('#currentLocationUpload').find('input.currentDistributorName').val();

		// populate data
		var dataHolder = firstDestination.find('.uploadInformation');
		dataHolder.find('input.orgUnitId').val(geographyUploadId);
		dataHolder.find('input.orgUnitName').val(geographyUploadName);
		dataHolder.find('input.distributorId').val(distributorUploadId);
		dataHolder.find('input.distributorName').val(distributorUploadName);
		dataHolder.find('input.foldersIds').val(folderIdsString);
		dataHolder.find('input.foldersNames').val(folderNameString);
		// display information
		firstDestination.find('.one-destination-description').find('.ddname').html(distributorUploadName);
		firstDestination.find('.one-destination-description').find('.dfname').html(folderNameString);
		// end of populate data
	}
}

function bindJs(){
	jQuery('#addCommentInfo').removeClass('readyToShowInvisible');

	iPadContentItemList();

	if(!jQuery(".file-comment-holder").hasClass('js-scroll')){
		jQuery(".file-comment-holder").jScrollPane();
		jQuery(".file-comment-holder").addClass('js-scroll');
		jQuery('.file-comment-content').last().css('border-color', 'transparent');
	}

	if(!jQuery(".comment-holder").hasClass('js-scroll')){
		jQuery(".comment-holder").jScrollPane();
		jQuery(".comment-holder").addClass('js-scroll');
	}

	calculateBoxHeight();

	jQuery('.extrabreadcrumbs').each(function(){
		var wdth = jQuery(this).find('.button-bread').width();
		jQuery(this).find('.breadcrumbs-wrapper-ext').css('width', wdth+5);
	});

	if(jQuery('.showUploadDialog').length == 1){
		showDialog('uploadFileInfo');
		margeLocations();
	}

	jQuery('.availableUntil').datepicker({
		showOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: 'Close',
		showButtonPanel :true,
		selectOtherMonths: true,
		dateFormat: 'mm/dd/yy'
	});
}

jQuery(document).ready(function() {
	bindJs();
	function margeLocations(){
		try {
			var selectedFolders = '';
			jQuery('.destinations-holder').find('input.foldersIds').each(function(){
				if(!jQuery(this).parents('.one-destination-wrapper').hasClass('hidden')){
					selectedFolders += jQuery(this).val() +',';
				}
			});
			if(selectedFolders == null || selectedFolders == ''){
				return;
			}
			showDialog('ajaxLoader');
			Controller_BaseRemote.getFoldersMergedLocations(selectedFolders, function(data, event){
				if (event.status) {
					jQuery('.dfname').html(data);
					setTimeout("hideDialog('ajaxLoader');", 500);
					//sucess
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		} catch (err){
			alert(err.message);
		}
	}

	function updateDistributorsUpload(){
		try {
			var geographyUpload = jQuery('#geographyUpload').find('select').val();
			if(geographyUpload == null || geographyUpload == ''){
				alert('Please select organizational unit.');
				return;
			}
			showDialog('ajaxLoader');

			Controller_BaseRemote.getDistributorsForOrgUnit(geographyUpload, function(data, event){
				if (event.status) {
					// clear current selectbox
					selectBox = jQuery('#distributorUpload').find('select');
					customSelectBox = jQuery('#distributorUpload').find('.custom-select-box-values');

					// remove current values
					selectBox.find('option').remove();
					customSelectBox.replaceWith("<div class='custom-select-box-values'></div>");
					customSelectBox = jQuery('#distributorUpload').find('.custom-select-box-values');

					//populate data
					jQuery.each(data, function(index,value){
					selectBox.append('<option value="'+value.Id+'">'+value.Name+'</option>')
					customSelectBox.append('<div title="'+value.Name+'" name="'+value.Id+'" class="bold custom-select-box-item">'+value.Name+'</div>');
					});

					//setup first value as selected
					customValue = selectBox.find('option').first();
					jQuery('#distributorUpload').find('.custom-select-box-val').html('');
					if(customValue.length == 1){
						customValue.attr('selected', true);
						jQuery('#distributorUpload').find('.custom-select-box-val').html(customValue.text());
						jQuery('#distributorUpload').find('.custom-select-box-item').first().addClass('current');
					}
					jQuery('#distributorUpload').find('.custom-select-box-values').jScrollPane();
					//sucess
					setTimeout("hideDialog('ajaxLoader');", 500);
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		} catch (err){
			alert(err.message);
		}
	}
	jQuery('#geographyUpload').find('select').live('change',function(){
		updateDistributorsUpload();
	});

	jQuery('.uploadButton').live('click',function(){
		var isValid = true;
		// file(s) exists
		if(jQuery('.one-file-wrapper').not('.hidden').size() == 0){
			isValid = false;
			alert("Please select at least one file.");
		}
		// location(s) exists
		if(jQuery('.one-destination-wrapper').not('.hidden').size() == 0){
			isValid = false;
			alert("Please select at least one destination.");
		}
		// description(s) exists
		jQuery('.one-file-wrapper').not('.hidden').each(function(){
			var dValue = jQuery(this).find('input.fDescription').val();
			if(dValue == null || (dValue != null && dValue.trim() == '')){
				isValid = false;
				alert("Description field is required.");
				return false;
			}
			var fValue = jQuery(this).find('input.fileinput').val();
			if(fValue == null || (fValue != null && fValue.trim() == '')){
				isValid = false;
				alert("File field is required.");
				return false;
			}
		});
		// date is valid
		dateValue = jQuery('.availableUntil').val();
		if(dateValue != null && dateValue != '' && dateValue != "mm/dd/yyyy"){
			try{
				jQuery.datepicker.parseDate('mm/dd/yy', jQuery('.availableUntil').val());
			} catch(e){
				isValid = false;
				alert("Invalid date format.");
			}
		}

		// comment is not grater then 1000 chars
		if(jQuery('.uploadComment').val() != null){
			commentValue = jQuery('.uploadComment').val();
			if(commentValue.length >= 999){
				isValid = false;
				alert("Comment text is too long.");
			}
		}
		if(isValid){
			showDialog('ajaxLoader');
			jQuery('.uploadButtonReal').trigger('click');
		}
	});

	jQuery('.folder').live('click',function(){
		if(jQuery(this).hasClass('folder-selected')){
			jQuery(this).removeClass('folder-selected');
			jQuery(this).prev('input[type=checkbox]').attr('checked', false);
		} else {
			jQuery(this).addClass('folder-selected');
			jQuery(this).prev('input[type=checkbox]').attr('checked', true);
		}
	});
	jQuery('.addDistributor').live('click',function(){
		jQuery('.destination-navigation').addClass('hidden');
		jQuery('.select-destination-stage-two').addClass('hidden');
		jQuery('.select-destination-stage-one').removeClass('hidden');
		jQuery('#distributorUpload').find('.custom-select-box-values').jScrollPane();
		jQuery('#geographyUpload').find('.custom-select-box-values').jScrollPane();
		updateDistributorsUpload();
	});
	jQuery('.addFolder').live('click',function(){
		try {
			var geographyUpload = jQuery('#geographyUpload').find('select').val();
			var distributorUpload = jQuery('#distributorUpload').find('select').val();
			isInternalUserRequest = {!isInternalUser};
			if(geographyUpload == null || geographyUpload == '' || distributorUpload == null || distributorUpload == '' ){
				alert('Please select organizational unit and distributor.');
				return;
			}
			showDialog('ajaxLoader');
			Controller_BaseRemote.getFoldersOptions(geographyUpload, distributorUpload, isInternalUserRequest, function(data, event){
				if (event.status) {
					var currentFolderClass = '';
					var currentFolderSelectedId = jQuery('#currentLocationUpload').find('input.currentFoldersIds').val();
					treeString = '<div class="folder-upload-tree-wrapper"><ul id="folder-upload-tree" class="folder-section">';
					jQuery.each(data, function(index, tree){
						currentFolderClass = '';
						if(tree.value == currentFolderSelectedId) { currentFolderClass = 'folder-selected'; }
						treeString += '<li>';
						treeString += '<span class="folder main-folders '+currentFolderClass+'" id="'+tree.value+'">'+tree.label+'</span>';
						treeString += '<ul class="folder-section">';
						jQuery.each(tree.children, function(index, ctree){
							currentFolderClass = '';
							if(ctree.value == currentFolderSelectedId) { currentFolderClass = 'folder-selected'; }
							treeString += '<li>';
							treeString += '<span class="folder main-folders '+currentFolderClass+'" id="'+ctree.value+'">'+ctree.label+'</span>';
							treeString += '<ul class="folder-section">';
							jQuery.each(ctree.children, function(index, cctree){
								currentFolderClass = '';
								if(cctree.value == currentFolderSelectedId) { currentFolderClass = 'folder-selected'; }
								treeString += '<li>';
								treeString += '<span class="folder main-folders '+currentFolderClass+'" id="'+cctree.value+'">'+cctree.label+'</span>';
								treeString += '<ul class="folder-section">';
								jQuery.each(cctree.children, function(index, ccctree){
									currentFolderClass = '';
									if(ccctree.value == currentFolderSelectedId) { currentFolderClass = 'folder-selected'; }
									treeString += '<li>';
									treeString += '<span class="folder main-folders '+currentFolderClass+'" id="'+ccctree.value+'">'+ccctree.label+'</span>';
									treeString += '<ul class="folder-section">';
									jQuery.each(ccctree.children, function(index, cccctree){
										currentFolderClass = '';
										if(cccctree.value == currentFolderSelectedId) { currentFolderClass = 'folder-selected'; }
										treeString += '<li>';
										treeString += '<span class="folder main-folders '+currentFolderClass+'" id="'+cccctree.value+'">'+cccctree.value+'</span>';
										treeString += '</li>';
									});
									treeString += '</ul>';
									treeString += '</li>';
								});
								treeString += '</ul>';
								treeString += '</li>';
							});
							treeString += '</ul>';
							treeString += '</li>';
						});
						treeString += '</ul>';
						treeString += '</li>';
					});
					treeString += '</ul></div>';
					jQuery('.folder-upload-tree-wrapper').replaceWith(jQuery(treeString));
					jQuery('.destination-navigation').addClass('hidden');
					jQuery('.select-destination-stage-one').addClass('hidden');
					jQuery('.select-destination-stage-two').removeClass('hidden');
					jQuery("#folder-upload-tree").treeview({
						animated: "medium",
						collapsed: false
					});
					jQuery('.folder-upload-tree-wrapper').jScrollPane();
					//sucess
					setTimeout("hideDialog('ajaxLoader');", 500);
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		} catch (err){
			alert(err.message);
		}
	});
	
	jQuery('.addDestination').live('click',function(){
		geographyUploadOption = jQuery('#geographyUpload').find('select option:selected');
		distributorUploadOption = jQuery('#distributorUpload').find('select option:selected');
		folderIdsString = '';
		folderNameString = '';
		jQuery('.folder-upload-tree-wrapper').find('.folder-selected').each(function(){
			folderIdsString += jQuery(this).attr('id')+',';
			folderNameString += jQuery(this).html()+',';
		});
		if(geographyUploadOption.val() == null || geographyUploadOption.val() == '' || distributorUploadOption.val() == null || distributorUploadOption.val() == '' || folderIdsString == '' ){
			alert('Please select organizational unit, distributor and folder.');
			return;
		}
		jQuery('.destination-navigation').removeClass('hidden');
		jQuery('.select-destination-stage-one').addClass('hidden');
		jQuery('.select-destination-stage-two').addClass('hidden');
		toShow = jQuery('.one-destination-wrapper.hidden').first();
		if(toShow.length == 1){
			idx = toShow.index();
			toShow.removeClass('hidden')
			jQuery('.destinationIndexHolder').val(jQuery('.destinationIndexHolder').val()+idx+',');
			// populate data
			dataHolder = toShow.find('.uploadInformation');
			dataHolder.find('input.orgUnitId').val(geographyUploadOption.val());
			var txtDivision = geographyUploadOption.text();
			var txtDivisionToShow = txtDivision.substr(txtDivision.lastIndexOf('-')+1,txtDivision.length).trim();
			dataHolder.find('input.orgUnitName').val(txtDivisionToShow);
			dataHolder.find('input.distributorId').val(distributorUploadOption.val());
			dataHolder.find('input.distributorName').val(distributorUploadOption.text());
			dataHolder.find('input.foldersIds').val(folderIdsString);
			dataHolder.find('input.foldersNames').val(folderNameString);
			// display information
			toShow.find('.one-destination-description').find('.ddname').html(distributorUploadOption.text());
			toShow.find('.one-destination-description').find('.dfname').html(folderNameString);
			margeLocations();
			// end of populate data
		}
		nextToShow = jQuery('.one-destination-wrapper.hidden').first();
		if(nextToShow.length == 0){
			jQuery('.addDistributor').addClass('hidden');
		} else {
			jQuery('.addDistributor').removeClass('hidden');
		}
	});
	
	jQuery('.removeDestination').live('click',function(){
		toRemove = jQuery(this).parents('.one-destination-wrapper');
		if(toRemove.length == 1){
			idx = toRemove.index();
			toRemove.addClass('hidden')
			jQuery('.destinationIndexHolder').val(jQuery('.destinationIndexHolder').val().replace(idx+',',''));
		}
		nextToShow = jQuery('.one-destination-wrapper.hidden').first();
		if(nextToShow.length != 0){
			jQuery('.addDistributor').removeClass('hidden');
		} else {
			jQuery('.addDistributor').addClass('hidden');
		}
		margeLocations();
	});
	
	jQuery('.closeAddingDestination').live('click',function(){
		jQuery('.destination-navigation').removeClass('hidden');
		jQuery('.select-destination-stage-two').addClass('hidden');
		jQuery('.select-destination-stage-one').addClass('hidden');
	});
	
	jQuery('.addFile').live('click',function(){
		toShow = jQuery('.one-file-wrapper.hidden').first();
		if(toShow.length == 1){
			idx = toShow.index('.one-file-wrapper');
			toShow.removeClass('hidden')
			toShow.find('input.fDescription').val('');
			jQuery('.fileIndexHolder').val(jQuery('.fileIndexHolder').val()+idx+',');
		}
		nextToShow = jQuery('.one-file-wrapper.hidden').first();
		if(nextToShow.length == 0){
			jQuery(this).addClass('hidden');
		} else {
			jQuery(this).removeClass('hidden');
		}
	});
	
	jQuery('.removeFile').live('click',function(){
		toRemove = jQuery(this).parents('.one-file-wrapper');
		if(toRemove.length == 1){
			idx = toRemove.index('.one-file-wrapper');
			toRemove.addClass('hidden')
			jQuery('.fileIndexHolder').val(jQuery('.fileIndexHolder').val().replace(idx+',',''));
		}
		nextToShow = jQuery('.one-file-wrapper.hidden').first();
		if(nextToShow.length != 0){
			jQuery('.addFile').removeClass('hidden');
		} else {
			jQuery('.addFile').addClass('hidden');
		}
	});
	if({!IF(currentDistributorId == '','true','false')}){
		jQuery('.extrabreadcrumbs').find(".subnav:not('.subnav2')").last().css('display', 'block');
	}
});
