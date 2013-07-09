// Action called when Checkbox is clicked
jQuery(".doc-list input[type='checkbox']").change(function() {
	setTimeout(function() {
		var contentItemCheckBox = jQuery(".doc-list input[type='checkbox']").length - jQuery(".select-all input[type='checkbox']").length;
		var contentItemSelectedCheckBox =  jQuery(".doc-list input[type='checkbox']:checked").length - jQuery(".select-all input[type='checkbox']:checked").length;
		if(contentItemSelectedCheckBox > 0) {
					jQuery(".operation-line a").removeClass("disabled");
					if(contentItemCheckBox == contentItemSelectedCheckBox && !jQuery(".select-all input[type='checkbox']").prop("checked")){
						jQuery(".select-all input[type='checkbox']").trigger("click");
		}/*else if(contentItemCheckBox != contentItemSelectedCheckBox && jQuery(".select-all input[type='checkbox']").prop("checked")){
			jQuery(".select-all input[type='checkbox']").trigger("click");
		}*/
		}
		else {
			jQuery(".operation-line a").addClass("disabled");
			if(jQuery(".select-all input[type='checkbox']").prop("checked")){
				jQuery(".select-all input[type='checkbox']").trigger("click");
			}
		}
	}, 100);
});

// Action called when clciked on any operation line (Download/Share/Add/Follow)
function operationLine(lineClass){
	if(!jQuery("."+lineClass).hasClass("disabled")){
		var glue = "";
		var selectedContentIds = "";
		var clickedButton = jQuery("."+lineClass).first().text().trim();
		if(clickedButton == "Follow" || clickedButton == "Unfollow"
			|| clickedButton == "Add" || clickedButton == "Remove"
			|| clickedButton == "Email"){
			
			var opType = "", anchorClassName = "";
			if(clickedButton == "Follow" || clickedButton == "Unfollow"){
				opType = "Follow";
				anchorClassName = "follow";
			}else if(clickedButton == "Add" || clickedButton == "Remove"){
				opType = "Basket";
				anchorClassName = "add-to-basket";
			}else if(clickedButton == "Email"){
				opType = "Share";
				anchorClassName = "share";
			}
			
			jQuery(".doc-list input[type='checkbox']:checked").each(function() {
				var tmpHref = jQuery(this).parents(".doc").find("."+anchorClassName).attr('href');
				selectedContentIds += glue + tmpHref.substring(tmpHref.indexOf(opType+"('")+(opType+"('").length, 
																												tmpHref.indexOf(opType+"('")+(opType+"('").length+18);
				glue = ",";
			});
			
			if(clickedButton == "Follow"){
				addToFollowMultiple(selectedContentIds);
			}else if(clickedButton == "Unfollow"){
				removeFromFollowMultiple(selectedContentIds);
			}else if(clickedButton == "Add"){
				addToBasketMultiple(selectedContentIds);
			}else if(clickedButton == "Remove"){
				removeFromBasketMultiple(selectedContentIds);
			}else if(clickedButton == "Email"){
				userMultipleShare(selectedContentIds);
	  userTryToShare(selectedContentIds);
	  showDialog('shareInfo');
	}
	
		}else if(clickedButton == "Download"){
		var anchorClassName="download", opType = "DownloadCache", cacheIds = '', stringIds = '';
	  var videoIds = Array();
	  var docTotalSizeInB = 0;
	  jQuery(".doc-list input[type='checkbox']:checked").each(function() {
		var tmpHref = jQuery(this).parents(".doc").find("."+anchorClassName).attr('onclick');
		if( tmpHref !== undefined && tmpHref.length != 0){
					docId = tmpHref.substring(tmpHref.indexOf(opType+"('")+(opType+"('").length, 
																												tmpHref.indexOf(opType+"('")+(opType+"('").length+18);
					cacheIds = cacheIds + docId + glue;
				}else{
					docId = "";
				}
				
				if(!jQuery(this).hasClass('videofile')){
		if(docId.length != 0){
			stringIds = stringIds +'/'+docId;
		}
	  } else {
		videoIds.push(tmpHref.substring(tmpHref.indexOf("videoId=")+8, tmpHref.length));
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
				
				glue = ",";
				
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
	  /*if (jQuery(this).parents('.dialog').length != 0) {
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
	  }*/
	}
			
			jQuery.each(videoIds, function(index, videoId){
		if(videoId.length != 0){
		  //var videodesc = jQuery('div[id="'+videoId+'"] label').html();
		  var videodesc = "";
		  var videourl = '/apex/VideoDownload?videoid='+videoId+'&videodesc='+videodesc;                      
		  window.open(videourl);
		}                   
	  });
	  if(cacheIds!= null && cacheIds != ''){
		addToDownloadCache(cacheIds);
	  }
	  sectionVisibility();
		}
	}
}