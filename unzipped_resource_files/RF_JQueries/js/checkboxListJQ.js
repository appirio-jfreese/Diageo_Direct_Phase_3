var allChildClasses = new Array();
		function subOptionChange(childClass, calledOnClick, currentCB){
			var bIndeterminate = false;
			var bChecked = false;
			var i=0;
			jQuery("."+childClass).each(function() {
			//alert('in subop :'+jQuery(this).prop('checked'));
    		if(jQuery(this).is(':checked')){
    			bIndeterminate = true
			  	if(!bChecked && i == 0)
			  		bChecked = true;
    		}else if(bChecked){
			  	bChecked = false;
			  }
			  i++;
			});

			if(bChecked && bIndeterminate && i == jQuery("."+childClass).length){
				bChecked = true;
				bIndeterminate = false;
			}
			
			if(childClass == '{!siteTheme}' && !bChecked && !bIndeterminate){
				alert('{!$Label.SubThemeOptionError}' + " '" + '{!siteTheme}' + "'..!!!");
				currentCB.checked = !currentCB.checked;
				calledOnClick = false;
			}
			else{
				var parentCheckBoxId;
				jQuery("."+childClass+"_P").each(function() {
					parentCheckBoxId = jQuery(this).attr('id');
					jQuery(this).prop('indeterminate',bIndeterminate);
					jQuery(this).prop('checked',bChecked);
					//alert('in subop _P:'+jQuery(this).prop('checked'));
				});
			}
			
			if(calledOnClick)
				{!onchange};
		}
		
		function parentOptionChange(childClass, calledOnClick){
			var bChecked;
			jQuery("."+childClass+"_P").each(function() {
					bChecked = jQuery(this).is(':checked');
			});
			
			jQuery("."+childClass).each(function() {
    			jQuery(this).prop('checked',bChecked);
    			//alert('in p :'+jQuery(this).prop('checked'));
			});
			
			if(calledOnClick)
				{!onchange};
		}
		
		
		function onLoadForChildOptions(){
			var i;
			for(i=0; i<allChildClasses.length; i++){
				subOptionChange(allChildClasses[i], false);
			}
		}