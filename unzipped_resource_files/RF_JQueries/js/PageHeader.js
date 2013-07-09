jQuery.noConflict();

function checkHeaderThemeSelector() {
	if(jQuery('.horizontal-slider').length != 0){
		if(! jQuery('.content').hasClass('pilsite')){
			jQuery('#headerSiteThemeDropdown').addClass('hidden');
		}
	} else {
		jQuery('#headerSiteThemeDropdown').removeClass('hidden');
	}
}

function addToDownloadCache(ids){
	if(typeof ids != 'undefined' && ids != null && ids.length != 0){
		try {
			Controller_BaseRemote.cacheDownload(ids, function(data, event){
				if (event.status) {
					//sucess
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		} catch (err){
		}
		if(jQuery('#possibleItemsToRemove').length == 1){
			jQuery('#possibleItemsToRemove').val(ids);
			showDialog('confirmDelete');
		}
	}
}

var customSelectBoxHideTimeout = null;

// to share autocomplete
function split( val ) {
	return val.split( /,\s*/ );
}
// to share autocomplete
function extractLast( term ) {
	return split( term ).pop();
}

function userTryToShare(stringIds){
	if(jQuery('#possibleItemsToRemove').length == 1){
		jQuery('#possibleItemsToRemove').val(stringIds);
	}
}

function bindUserAutoComplete(){
	if(jQuery('.recipientEmailInput').length != 1){
		return false;
	}
	jQuery('.recipientEmailInput').autosize();
	jQuery('.recipientEmailInput').autocomplete({
		source: function( request, response ) {
			Controller_BaseRemote.getPossibleShareUsers(extractLast(request.term), request.term, function(data, event){
				if (event.status) {
					//sucess
					response( jQuery.map( data, function( item ) {
						if(!!item.FirstName){
							fName = item.FirstName;
						} else {
							fName = '';
						}
						if(!!item.LastName){
							lName = item.LastName;
						} else {
							lName = '';
						}
						return {
							label: fName+' '+lName+' '+item.Email+'',
							value: item.Email
						}
					}));
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		},
		search: function() {
			// custom minLength
			var term = extractLast( this.value );
			if ( term.length < 3 ) {
				return false;
			}
		},
		focus: function() {
			// prevent value inserted on focus
			return false;
		},
		select: function( event, ui ) {
			var terms = split( this.value );
			// remove the current input
			terms.pop();
			// add the selected item
			terms.push( ui.item.value );
			// add placeholder to get the comma-and-space at the end
			terms.push( "" );
			this.value = terms.join( ", " );
			jQuery('.recipientEmailInput').trigger('resize');
			return false;
		}
	});
}


jQuery(document).ready(function() {
	var isiPad = navigator.userAgent.match(/iPad/i) != null;

	jQuery('.selectFile').live('click',function(){
		fInputReal = jQuery(this).parent().parent().find('input.fileinput');
		if(fInputReal.length == 1){
			fInputReal.trigger('click');
			return false;
		}
	});

	jQuery("div.theme-page-box").live('click', function() {
		thm = jQuery(this).attr('name');
		jQuery('input.themeWrapperSelector').val(thm);

		jQuery("div.theme-page-box-title", this).stop(true).animate({'top': 35}, 500);
		jQuery("div.theme-page-box-title-bg", this).stop(true).animate({'opacity':'0.75'}, 500);

		jQuery("div.theme-page-box").not(this).each(function() {
			jQuery("div.theme-page-box-title", this).animate({'top': 75}, 500);
			jQuery("div.theme-page-box-title-bg", this).animate({'opacity':'0.95'}, 500);
		});
	});

	if(jQuery('#selectTheme').length == 1){
		if(jQuery('#selectTheme').hasClass('selectThemeRequired')){
			showDialog('selectTheme');
		}
	}

	jQuery("button.back-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery("button.back-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".download-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".download-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".download-pdf-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".download-pdf-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".downloadAllButton").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".downloadAllButton").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".action-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".action-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery("a.additionalBrand").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery("a.additionalBrand").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".green").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".green").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".sub-section-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".sub-section-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".section-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".section-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery(".horizontal-slider-navigation-button").live('mouseenter', function() {
		jQuery(this).addClass('over');
	});

	jQuery(".horizontal-slider-navigation-button").live('mouseleave', function(){
		jQuery(this).removeClass('over');
	});

	jQuery.ui.accordion.prototype.options.header = '> li > :first-child,> :not(li):even:not(.hidden)';
	jQuery.fn.jScrollPane.defaults.enableKeyboardNavigation = false;
	jQuery.fn.jScrollPane.defaults.showArrows = true;
	if(!jQuery('.custom-select-box-values').hasClass('js-scroll')){
		jQuery('.custom-select-box-values').jScrollPane();
		jQuery('.custom-select-box-values').addClass('js-scroll');
	}

	jQuery('img.scaleImg').imgscale({parent : '.preview-wrapper',scale: 'fit',fade : 1000});

	jQuery('.forceSubmit').keydown(function(e) {
		if(!jQuery.browser.msie){
			return;
		}
		if(e.keyCode == 13){
			if(jQuery(this).parents('form').length != 0 ){
				form = jQuery(this).parents('form');
				if(form.find('input[type=submit]').length == 1){
					form.find('input[type=submit]').trigger('click');
				} else if(form.find('button').length == 1) {
					form.find('button').trigger('click');
				}
			}
		}
	});

	jQuery(".custom-select-box-header").live('click',function() {
		selectBox = jQuery(this).parent();
		if(!jQuery('.custom-select-box-values').hasClass('js-scroll')){
			jQuery('.custom-select-box-values').jScrollPane();
			jQuery('.custom-select-box-values').addClass('js-scroll');
		}
		if(selectBox.hasClass('expanded')){
			selectBox.removeClass('expanded');
			jQuery('.custom-select-button',selectBox).animate({'rotate': 0}, 400);
			selectBox.animate({height: jQuery('.custom-select-box-header', selectBox).outerHeight()}, 400);
		} else {
			selectBox.addClass('expanded');
			selectBoxMaxHeight = jQuery('.custom-select-box-values', selectBox).outerHeight();
			selectBoxActualHeight = jQuery('.custom-select-box-item', selectBox).first().outerHeight()*jQuery('.custom-select-box-item', selectBox).size();
			if(selectBoxActualHeight >= selectBoxMaxHeight){
				selectBoxHeight = selectBoxMaxHeight;
			} else {
				selectBoxHeight = selectBoxActualHeight;
			}
			var offset = 45;
			if(jQuery(this).hasClass('custom-select-box-header-slim')){
				offset = 35;
			}
			selectBox.animate({height: selectBoxHeight+offset}, 600);
			jQuery('.custom-select-button',selectBox).animate({'rotate': 180}, 600);
		}
	});

	jQuery(".custom-select-box").live('mouseenter', function() {
		jQuery(this).addClass('hover');
	});

	jQuery(".custom-select-box").live('mouseleave', function() {
		jQuery(this).removeClass('hover');
		var that = this;
		if(customSelectBoxHideTimeout != null) {
			clearTimeout(customSelectBoxHideTimeout);
		}
		customSelectBoxHideTimeout = setTimeout(function(){
			if(jQuery(that).hasClass('expanded') && !jQuery(that).hasClass('hover')){
				jQuery(that).delay(200).animate({height: jQuery('.custom-select-box-header', that).outerHeight()}, 400, function(){
					jQuery(that).removeClass('expanded');
				});
				jQuery('.custom-select-button',that).delay(200).animate({'rotate': 0}, 400);
			}
		}, 1000);
	});

	jQuery(".custom-select-box-item").live('mouseenter', function() {
		jQuery(this).addClass('custom-select-box-item-active');
		if(jQuery(this).hasClass('useSectionTheme')){
			jQuery(this).addClass('sectionBackground');
			jQuery(this).addClass('sectionBorder');
		}
	});
	jQuery(".custom-select-box-item").live('mouseleave',function() {
		jQuery(this).removeClass('custom-select-box-item-active');
		if(jQuery(this).hasClass('useSectionTheme')){
			jQuery(this).removeClass('sectionBackground');
			jQuery(this).removeClass('sectionBorder');
		}
	});

	jQuery(".custom-select-box-item").live('click', function(){
		customSelectBox = jQuery(this).parents('.custom-select-box');
		if(customSelectBox.length == 0){
			return;
		}

		clearTimeout(customSelectBoxHideTimeout);
		customSelectBox.animate({height: jQuery('.custom-select-box-header', customSelectBox).outerHeight()}, 400, function(){
			jQuery(customSelectBox).removeClass('expanded');
		});
		jQuery('.custom-select-button',customSelectBox).animate({'rotate': 0}, 400);

		valDescription = jQuery.trim( jQuery(this).html() );
		if(!customSelectBox.find('.custom-select-box-val').hasClass('multi')){
			if(valDescription.length > 18 && customSelectBox.hasClass('trim')){
				customSelectBox.find('.custom-select-box-val').html(valDescription.substring(0, 18)+'...');
			} else {
				customSelectBox.find('.custom-select-box-val').html(valDescription);
			}
		}

		selectBox = jQuery("select.orgSelect-"+customSelectBox.attr('id')+"");
		if(selectBox.length == 0){
			return;
		}

		selectBox.val(jQuery(this).attr('name'));
		//customSelectBox.trigger('mouseleave');
		customSelectBox.find(".custom-select-box-item").removeClass('current');
		jQuery(this).addClass('current');

		selectBox.focus();  // important
		selectBox.blur();   // important
		selectBox.change(); // important
	});

	jQuery(".close").live('click', function(){
		if(jQuery(this).parents('.dialog').length != 0){
			dialog = jQuery(this).parents('.dialog');
			dialogId = jQuery(this).parents('.dialog').attr('id');
			if(dialog.find('.dialogUploadContentDiv').length == 0){
				dialog.find('input[type="text"]').val('');
				dialog.find('input[type="checkbox"]').attr('checked', false);
				jQuery('span.totalDownloadSizeValue', dialog).html('0.00');
				jQuery('span.totalDownloadTimeValue', dialog).html('0 second');
			}
			if(jQuery(this).parents('.dialog').attr('name') !== undefined){
				dialogName = jQuery(this).parents('.dialog').attr('name');
			} else {
				dialogName = '';
			}
			if(dialogId.length != 0){
				if(dialogName.length !=0){
					hideDialog(""+dialogId+"[name='"+dialogName+"']");
				} else {
					hideDialog(dialogId);
				}
			}
		}
	});

	jQuery(".content-item-description").live('touchstart', function() {
		var iparent = jQuery(this).parents(".content-item");
		if(iparent.find('.item-buttons').length != 0){
			var bottomValue = jQuery("div.item-description", iparent).height()-jQuery("div.content-item-menu", iparent).height() - 5;
			jQuery("div.item-description", iparent).stop().animate({bottom: -bottomValue}, 400);
		}
	});

	jQuery(".content-item-description").live('mouseenter', function() {
		var iparent = jQuery(this).parents(".content-item");
		if(iparent.find('.item-buttons').length != 0){
			var bottomValue = jQuery("div.item-description", iparent).height()-jQuery("div.content-item-menu", iparent).height() - 5;
			jQuery("div.item-description", iparent).stop().animate({bottom: -bottomValue}, 400);
		}
	});
	jQuery(".content-item-description").live('mouseleave', function() {
		var iparent = jQuery(this).parents(".content-item");
		var bottomValue = jQuery("div.item-description", iparent).height()-jQuery("div.content-item-menu div", iparent).height() - 5;
		jQuery("div.item-description", iparent).stop().animate({bottom: -bottomValue}, 400);
	});

	jQuery(".content-item-list").live('mouseenter', function() {
		if( isiPad != true){
			jQuery("div.content-item-list-buttons", this).css('opacity', 0);
			jQuery("div.content-item-list-buttons", this).removeClass('hidden');
			jQuery("div.content-item-list-buttons", this).stop().animate({opacity: 1}, 400);
		}
	});

	jQuery(".content-item-list").live('mouseleave', function() {
		if( isiPad != true){
			jQuery("div.content-item-list-buttons", this).removeClass('hidden');
			jQuery("div.content-item-list-buttons", this).stop().animate({opacity: 0});
		}
	});

	jQuery(".showResolution").live('click',function() {
		jQuery(this).parents("div.item-description").stop().animate({bottom: -3}, 400);
	});
	jQuery(".user-menu-dropdown").live('mouseenter',function() {
		jQuery(this).addClass('user-menu-dropdown-active');
		jQuery(this).stop().animate({height: jQuery('.user-menu-values', this).outerHeight()+jQuery('.user-menu-name', this).outerHeight()}, 400, function(){

		});
		jQuery('.user-menu-dropdown-ind',this).stop().animate({'rotate': 180}, 400);
	});
	jQuery(".user-menu-dropdown").live('mouseleave',function() {
		jQuery(this).stop().animate({height: jQuery('.user-menu-name', this).outerHeight()}, 400, function(){
			jQuery(this).removeClass('user-menu-dropdown-active');
		});
		jQuery('.user-menu-dropdown-ind',this).stop().animate({'rotate': 0}, 400);
	});

	var dropdownmenu = null;
	jQuery("body").live('touchstart',function(event) {
		if (jQuery(event.target).hasClass("user-menu-dropdown") || jQuery(event.target).parents().hasClass("user-menu-dropdown")){

		}else{
			if(dropdownmenu != null){
				dropdownmenu.stop().animate({height: jQuery('.user-menu-name', this).outerHeight()}, 400, function(){
					dropdownmenu.removeClass('user-menu-dropdown-active');
				});
				jQuery('.user-menu-dropdown-ind',dropdownmenu).stop().animate({'rotate': 0}, 400);
			}
		}

	});

	jQuery(".user-menu-dropdown").live('touchstart', function () {
		jQuery(this).addClass('user-menu-dropdown-active');
		jQuery(this).stop().animate({height: jQuery('.user-menu-values', this).outerHeight()+jQuery('.user-menu-name', this).outerHeight()}, 400, function(){
		});
		jQuery('.user-menu-dropdown-ind',this).stop().animate({'rotate': 180}, 400);
		dropdownmenu = jQuery(this);
	});

	jQuery(".user-menu-value").live('mouseenter',function() {
		jQuery(this).addClass('user-menu-value-acitve');
	});
	jQuery(".user-menu-value").live('mouseleave',function() {
		jQuery(this).removeClass('user-menu-value-acitve');
	});
	jQuery('.downloadAllButton').live('click', function(){
		if(jQuery(this).attr('id') !== undefined){
			if(jQuery(this).attr('id').length != 0){
				showDialog("downloadAllInfo-"+jQuery(this).attr('id'), true);
			} else {
				showDialog("downloadAllInfo", true);
			}
			return;
		}
		if(jQuery('div#downloadAllInfo').length != 0){
			showDialog('downloadAllInfo', true);
		}
	});
	jQuery('.downloadAllButtonDynamic').live('click', function(){
		if(jQuery('div#downloadAllInfo').length != 0){
			showDialog('downloadAllInfo');
		}
	});
	jQuery('.uploadFileButton').live('click', function(){
		if(jQuery('div#uploadFileInfo').length != 0){
			showDialog('uploadFileInfo', true);
		}
	});

	jQuery('input[type=checkbox].doc').live('click',function(){
		stringIds = '';
		docTotalSizeInB = 0;
		numberOfSelectedFiles = 0;
		numberOfFiles = jQuery(this).parents('.dialog').find('input[type=checkbox].doc').size();
		jQuery(this).parents('.dialog').find('input[type=checkbox].doc').each(function(){
			if(jQuery(this).is(':checked')){
				if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
					docId = jQuery(this).attr('id');
					stringIds = stringIds +'/'+docId;
					docSize = jQuery(this).attr('name');
					docSizeInt = 0;
					if (docSize.toLowerCase().indexOf("kb") >= 0){
						docSizeInt = parseInt(docSize.toLowerCase().replace('kb', ''));
						if(!isNaN(docSizeInt)){
							docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024);
						}
					} else if (docSize.toLowerCase().indexOf("mb") >= 0){
						docSizeInt = parseInt(docSize.toLowerCase().replace('mb', ''));
						if(!isNaN(docSizeInt)){
							docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024 * 1024);
						}
					}
					numberOfSelectedFiles++;
				} else {
					jQuery(this).attr('checked', false);
				}
			}
		});

		docTotalSizeInMB = (docTotalSizeInB/1024/1024);
		jQuery('span.totalDownloadSizeValue', jQuery(this).parents('.dialog')).html(docTotalSizeInMB.toFixed(2));
		timeInSec = docTotalSizeInB / 175000;
		if(timeInSec < 60){
			timeNum = timeInSec.toFixed(0);
			if(timeNum > 1){
				timeDesc = 'seconds';
			} else {
				timeDesc = 'second';
			}
		} else {
			timeInMin = timeInSec / 60;
			timeNum = timeInMin.toFixed(0);

			if(timeNum < 60){
				if(timeNum > 1){
					timeDesc = 'minutes';
				} else {
					timeDesc = 'minute';
				}
			} else {
				timeInH = timeInMin / 60;
				timeNum = timeInH.toFixed(0);
				if(timeNum > 1){
					timeDesc = 'hours';
				} else {
					timeDesc = 'hour';
				}
			}
		}
		if(!isNaN(timeNum)){
			jQuery('span.totalDownloadTimeValue', jQuery(this).parents('.dialog')).html(timeNum+' '+timeDesc);
		}

		if(numberOfSelectedFiles == numberOfFiles && numberOfFiles != 0){
			jQuery(this).parents('.dialog').find('.selectAllShareDownloaFilesChckbx').attr('checked', true);
		} else {
			jQuery(this).parents('.dialog').find('.selectAllShareDownloaFilesChckbx').attr('checked', false);
		}
	});

	jQuery('.startShareAll').live('click', function(){
		dataContainer = jQuery(this).parents('.dialog');
		if(dataContainer.find('input[type=checkbox]').length != 0){
			var stringIds = '';
			if(dataContainer.find('input[type=checkbox].doc').length != 0){
				var glue = '';
				docTotalSizeInB = 0;
				dataContainer.find('input[type=checkbox].doc').each(function(){
					if(jQuery(this).is(':checked')){
						if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
							docId = jQuery(this).attr('id');
							stringIds += glue+docId;
							glue = ',';
						}
					}
				});
				if(stringIds != '' && stringIds != null){
					userMultipleShare(stringIds);
					if(jQuery('#possibleItemsToRemove').length == 1){
						jQuery('#possibleItemsToRemove').val(stringIds);
					}
					dialog = jQuery(this).parents('.dialog');
					dialog.addClass('hidden');
					dialog.find('input[type="text"]').val('');
					dialog.find('input[type="checkbox"]').attr('checked', false);
					jQuery('span.totalDownloadSizeValue', dialog).html('0.00');
					jQuery('span.totalDownloadTimeValue', dialog).html('0 second');
					dialog.attr('style','');
					showDialog('shareInfo');
				}
			}
			dataContainer.find('input[type=checkbox]').each(function(){this.checked = false;})
		}

	});

	jQuery('.multiBasketActionButton').live('click', function(){
		dataContainer = jQuery(this).parents('.dialog');
		if(dataContainer.find('input[type=checkbox]').length != 0){
			var stringIds = '';
			if(dataContainer.find('input[type=checkbox].doc').length != 0){
				var glue = '';
				docTotalSizeInB = 0;
				dataContainer.find('input[type=checkbox].doc').each(function(){
					if(jQuery(this).is(':checked')){
						if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
							docId = jQuery(this).attr('id');
							stringIds += glue+docId;
							glue = ',';
						}
					}
				});
				if(stringIds != '' && stringIds != null){
					if(jQuery(this).hasClass('addToBasket')){
						addToBasketMultiple(stringIds);
					} else if(jQuery(this).hasClass('removeFromBasket')){
						removeFromBasketMultiple(stringIds);
					} else {
						alert('Unable to manage basket');
					}
					dialog = jQuery(this).parents('.dialog');
					dialog.addClass('hidden');
					dialog.find('input[type="text"]').val('');
					dialog.find('input[type="checkbox"]').attr('checked', false);
					jQuery('span.totalDownloadSizeValue', dialog).html('0.00');
					jQuery('span.totalDownloadTimeValue', dialog).html('0 second');
					dialog.attr('style','');
				}
			}
			dataContainer.find('input[type=checkbox]').each(function(){this.checked = false;})
		}
	});

	jQuery('.multiFollowActionButton').live('click', function(){
		dataContainer = jQuery(this).parents('.dialog');
		if(dataContainer.find('input[type=checkbox]').length != 0){
			var stringIds = '';
			if(dataContainer.find('input[type=checkbox].doc').length != 0){
				var glue = '';
				docTotalSizeInB = 0;
				dataContainer.find('input[type=checkbox].doc').each(function(){
					if(jQuery(this).is(':checked')){
						if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
							docId = jQuery(this).attr('id');
							stringIds += glue+docId;
							glue = ',';
						}
					}
				});
				if(stringIds != '' && stringIds != null){
					if(jQuery(this).hasClass('addToFollow')){
						addToFollowMultiple(stringIds);
					} else if(jQuery(this).hasClass('removeFromFollow')){
						removeFromFollowMultiple(stringIds);
					} else {
						alert('Unable to manage Follow');
					}
					dialog = jQuery(this).parents('.dialog');
					dialog.addClass('hidden');
					dialog.find('input[type="text"]').val('');
					dialog.find('input[type="checkbox"]').attr('checked', false);
					jQuery('span.totalDownloadSizeValue', dialog).html('0.00');
					jQuery('span.totalDownloadTimeValue', dialog).html('0 second');
					dialog.attr('style','');
				}
			}
			dataContainer.find('input[type=checkbox]').each(function(){this.checked = false;})
		}
	});

	jQuery('.startDownloadAll').live('click', function(){
		dataContainer = jQuery(this).parents('.dialog');
		var cacheIds = '';
		videoIds = Array();
		if(dataContainer.find('input[type=checkbox]').length != 0){
			var stringIds = '';
			if(dataContainer.find('input[type=checkbox].doc').length != 0){
				docTotalSizeInB = 0;
				dataContainer.find('input[type=checkbox].doc').each(function(){
					if(jQuery(this).is(':checked')){
						if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
							docId = jQuery(this).attr('id');
							cacheIds = cacheIds + docId+',';
							if(!jQuery(this).hasClass('videofile')){
								stringIds = stringIds +'/'+docId;
							} else {
								videoIds.push(jQuery(this).parent().attr('id'));
							}
							docSize = jQuery(this).attr('name');
							docSizeInt = 0;
							if (docSize.toLowerCase().indexOf("kb") >= 0){
								docSizeInt = parseInt(docSize.toLowerCase().replace('kb', ''));
								if(!isNaN(docSizeInt)){
									docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024);
								}
							} else if (docSize.toLowerCase().indexOf("mb") >= 0){
								docSizeInt = parseInt(docSize.toLowerCase().replace('mb', ''));
								if(!isNaN(docSizeInt)){
									docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024 * 1024);
								}
							}
						}
					}
					docTotalSizeInMB = (docTotalSizeInB/1024/1024);
				});
				if(docTotalSizeInMB > 100){
					var answer = confirm("Please confirm, that you you would like to download more then 100MB.");
					if (!answer) {
						return;
					}
				}

				if(stringIds != '' && stringIds != null){
					var iframe = document.createElement('iframe');
					iframe.style.width      = '1px';
					iframe.style.height     = '1px';
					iframe.style.visibility = 'hidden';
					iframe.src              = '/sfc/servlet.shepherd/version/download' + stringIds;
					jQuery(document.body).append(iframe);
					if (jQuery(this).parents('.dialog').length != 0) {
						dialogId = jQuery(this).parents('.dialog').attr('id');
						if (dialogId.length != 0) {
							hideDialog(dialogId);
							if(jQuery(this).hasClass('showClearBasketPopup')){
								showDialog('confirmDelete');
							}
							dialog = jQuery(this).parents('.dialog');
							dialog.find('input[type="text"]').val('');
							dialog.find('input[type="checkbox"]').attr('checked', false);
							jQuery('span.totalDownloadSizeValue', dialog).html('0.00');
							jQuery('span.totalDownloadTimeValue', dialog).html('0 second');
						}
					}
				}
				jQuery.each(videoIds, function(index, videoId){
					if(videoId.length != 0){
						var videodesc = jQuery('div[id="'+videoId+'"] label').html();
						var videourl = '/apex/VideoDownload?videoid='+videoId+'&videodesc='+videodesc;
						window.open(videourl);
					}
				});
				if(cacheIds!= null && cacheIds != ''){
					addToDownloadCache(cacheIds);
				}
			}
		}
	});
	
	jQuery('.selectAllShareDownloaFilesChckbx').live('click', function(){
		docTotalSizeInMB = 0;
		timeNum = 0;
		timeDesc = 'second';
		stringIds = '';
		if(jQuery(this).is(':checked')){
			jQuery(this).parents('.dialog').find('input[type=checkbox].doc').attr('checked', true);
			docTotalSizeInB = 0;
			numberOfFiles = jQuery(this).parents('.dialog').find('input[type=checkbox].doc').size();
			numberOfSelectedFiles = numberOfFiles;
			jQuery(this).parents('.dialog').find('input[type=checkbox].doc').each(function(){
				if(jQuery(this).attr('id') !== undefined && jQuery(this).attr('id').length != 0 && jQuery(this).attr('name') !== undefined && jQuery(this).attr('name').length != 0){
					docId = jQuery(this).attr('id');
					stringIds = stringIds +'/'+docId;
					docSize = jQuery(this).attr('name');
					docSizeInt = 0;
					if (docSize.toLowerCase().indexOf("kb") >= 0){
						docSizeInt = parseInt(docSize.toLowerCase().replace('kb', ''));
						if(!isNaN(docSizeInt)){
							docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024);
						}
					} else if (docSize.toLowerCase().indexOf("mb") >= 0){
						docSizeInt = parseInt(docSize.toLowerCase().replace('mb', ''));
						if(!isNaN(docSizeInt)){
							docTotalSizeInB = docTotalSizeInB + (docSizeInt * 1024 * 1024);
						}
					}
					numberOfSelectedFiles++;
				} else {
					jQuery(this).attr('checked', false);
				}
			});

			docTotalSizeInMB = (docTotalSizeInB/1024/1024);

			timeInSec = docTotalSizeInB / 175000;
			if(timeInSec < 60){
				timeNum = timeInSec.toFixed(0);
				if(timeNum > 1){
					timeDesc = 'seconds';
				} else {
					timeDesc = 'second';
				}
			} else {
				timeInMin = timeInSec / 60;
				timeNum = timeInMin.toFixed(0);

				if(timeNum < 60){
					if(timeNum > 1){
						timeDesc = 'minutes';
					} else {
						timeDesc = 'minute';
					}
				} else {
					timeInH = timeInMin / 60;
					timeNum = timeInH.toFixed(0);
					if(timeNum > 1){
						timeDesc = 'hours';
					} else {
						timeDesc = 'hour';
					}
				}
			}
		} else {
			jQuery(this).parents('.dialog').find('input[type=checkbox].doc').attr('checked', false);
		}

		if(!isNaN(timeNum)){
			jQuery('span.totalDownloadSizeValue', jQuery(this).parents('.dialog')).html(docTotalSizeInMB.toFixed(2));
		} else {
			jQuery('span.totalDownloadSizeValue', jQuery(this).parents('.dialog')).html('0.00');
		}

		if(!isNaN(timeNum)){
			jQuery('span.totalDownloadTimeValue', jQuery(this).parents('.dialog')).html(timeNum+' '+timeDesc);
		} else {
			jQuery('span.totalDownloadTimeValue', jQuery(this).parents('.dialog')).html('0 second');
		}

	});
	
	jQuery('.videoDownloadButton').live('click', function(){
		var videoId = jQuery(this).attr('id');
		if(videoId.length != 0){
			Controller_BaseRemote.downloadVideoFromBC(videoId, function(videourl, event){
				if (event.status) {
					window.location = videourl;
				} else if (event.type === 'exception') {
					alert(event.message);
				} else {
					alert(event.message);
				}
			}, {escape:true});
		} else {
			alert('Video ID not found.');
		}
	});

	jQuery('.cion').live('mouseenter', function(){
		if(typeof jQuery(this).attr('title') != 'undefined' && jQuery(this).attr('title').length != 0){
			jQuery(this).parents('.cionwrapper').first().find('.content-item-tooltip').html(jQuery(this).attr('title'));
		} else {
			jQuery(this).parents('.cionwrapper').first().find('.content-item-tooltip').html('&nbsp;');
		}
	});

	jQuery('.cion').live('mouseleave', function(){
		jQuery(this).parents('.cionwrapper').first().find('.content-item-tooltip').html('&nbsp;');
	});

	jQuery('.box-cion-download, .list-cion-download, .box-cion-openlink, .list-cion-openlink').live('click', function(){
		if(typeof jQuery(this).attr('href') != 'undefined' && jQuery(this).attr('href').length != 0){
			window.open(jQuery(this).attr('href'));
		}
	});

});
