/*
 *
 * jqTransform
 * by mathieu vilaplana mvilaplana@dfc-e.com
 * Designer ghyslain armand garmand@dfc-e.com
 *
 *
 * Version 1.0 25.09.08
 * Version 1.1 06.08.09
 * Add event click on Checkbox and Radio
 * Auto calculate the size of a select element
 * Can now, disabled the elements
 * Correct bug in ff if click on select (overflow=hidden)
 * No need any more preloading !!
 * 
 ******************************************** */
 
(function($){
	var defaultOptions = {preloadImg:true, wrapperClass: ""};
	var jqTransformImgPreloaded = false;
	var opt;

	var jqTransformPreloadHoverFocusImg = function(strImgUrl) {
		//guillemets to remove for ie
		strImgUrl = strImgUrl.replace(/^url\((.*)\)/,'$1').replace(/^\"(.*)\"$/,'$1');
		var imgHover = new Image();
		imgHover.src = strImgUrl.replace(/\.([a-zA-Z]*)$/,'-hover.$1');
		var imgFocus = new Image();
		imgFocus.src = strImgUrl.replace(/\.([a-zA-Z]*)$/,'-focus.$1');			
	};

	
	/***************************
	  Labels
	***************************/
	var jqTransformGetLabel = function(objfield){
		var selfForm = $(objfield.get(0).form);
		var oLabel = objfield.next();
		if(!oLabel.is('label')) {
			oLabel = objfield.prev();
			if(oLabel.is('label')){
				var inputname = objfield.attr('id');
				if(inputname){
					oLabel = selfForm.find('label[for="'+inputname+'"]');
				} 
			}
		}
		if(oLabel.is('label')){return oLabel.css('cursor','pointer');}
		return false;
	};
	
	/* Hide all open selects */
	var jqTransformHideSelect = function(oTarget){
		var ulVisible = $('.jqTransformSelectWrapper ul:visible');
		ulVisible.each(function(){
			var $wrapper = $(this).parents('.jqTransformSelectWrapper:first');
			$wrapper.parent().removeClass('focused');
			var oSelect = $(this).parents(".jqTransformSelectWrapper:first").find("select").get(0);
			//do not hide if click on the label object associated to the select
			if( !(oTarget && oSelect.oLabel && oSelect.oLabel.get(0) == oTarget.get(0)) ){$(this).hide();}
		});
	};
	/* Check for an external click */
	var jqTransformCheckExternalClick = function(event) {
		if ($(event.target).parents('.jqTransformSelectWrapper').length === 0) { jqTransformHideSelect($(event.target)); }
	};

	/* Apply document listener */
	var jqTransformAddDocumentListener = function (){
		$(document).mousedown(jqTransformCheckExternalClick);
	};	
			
	/* Add a new handler for the reset action */
	var jqTransformReset = function(f){
		var sel;
		$('.jqTransformSelectWrapper select', f).each(function(){sel = (this.selectedIndex<0) ? 0 : this.selectedIndex; $('ul', $(this).parent()).each(function(){$('a:eq('+ sel +')', this).click();});});
		$('a.jqTransformCheckbox, a.jqTransformRadio', f).removeClass('jqTransformChecked');
		$('input:checkbox, input:radio', f).each(function(){if(this.checked){$('a', $(this).parent()).addClass('jqTransformChecked');}});
	};
	/***************************
	  Text Fields 
	 ***************************/
	$.fn.jqTransInputText = function(){
		return this.each(function(){
			var $input = $(this);
			
			if($(this).hasClass("simplePlain")) return ;
	
			if($input.hasClass('jqtranformdone') || !$input.is('input')) {return;}
			$input.addClass('jqtranformdone');
	
			var oLabel = jqTransformGetLabel($(this));
			oLabel && oLabel.bind('click',function(){$input.focus();});
	
			var inputSize=$input.width();
			/*
			if($input.attr('size')){
				inputSize = $input.attr('size')*5;
				$input.css('width',inputSize-20);
			}
			*/
			$input.addClass("jqTransformInput").wrap('<div class="jqTransformInputWrapper"><div class="jqTransformInputInner"><div></div></div></div>');
			var $wrapper = $input.parent().parent().parent();
			if(opt.wrapperClass != "") {
				$wrapper.addClass(opt.wrapperClass);
			}
			var paddingLeft = $input.css("padding-left");
			paddingLeft = paddingLeft.substr(0, paddingLeft.length-2);
			var paddingRight = $input.css("padding-right");
			paddingRight = paddingRight.substr(0, paddingRight.length-2);
			var wrapperPadding = $wrapper.css("padding-right");
			wrapperPadding = wrapperPadding.substr(0, wrapperPadding.length-2);
			$wrapper.css("width", inputSize*1+paddingLeft*1+paddingRight*1-wrapperPadding*1);

			//$input.css("width", inputSize);
			$input
				.focus(function(){$wrapper.addClass("jqTransformInputWrapper_focus");$wrapper.trigger('change');})
				.blur(function(){$wrapper.removeClass("jqTransformInputWrapper_focus");$wrapper.trigger('change');})
				.hover(function(){$wrapper.addClass("jqTransformInputWrapper_hover");$wrapper.trigger('change');},function(){$wrapper.removeClass("jqTransformInputWrapper_hover");$wrapper.trigger('change');})
			;

			this.wrapper = $wrapper;
			
		});
	};

	/***************************
	  Check Boxes 
	 ***************************/	
	$.fn.jqTransCheckBox = function(){
		return this.each(function(){
			if($(this).hasClass('jqTransformHidden') || $(this).hasClass('noTransform')) {return;}

			var $input = $(this);
			var inputSelf = this;

			//set the click on the label
			var oLabel=jqTransformGetLabel($input);
			oLabel && oLabel.click(function(){aLink.trigger('click');});
			
			var aLink = $('<a href="#" class="jqTransformCheckbox"></a>');
			//wrap and add the link
			$input.addClass('jqTransformHidden').wrap('<span class="jqTransformCheckboxWrapper"></span>').parent().prepend(aLink);
			//on change, change the class of the link
			$input.change(function(){
				this.checked && aLink.addClass('jqTransformChecked') || aLink.removeClass('jqTransformChecked');
				return true;
			});
			// Click Handler, trigger the click and change event on the input
			aLink.click(function(){
				//do nothing if the original input is disabled
				if($input.attr('disabled')){return false;}
				
				//Change to support Active/Inactive status switch 
				if ( aLink.hasClass('jqTransformChecked') ){
					aLink.removeClass('jqTransformChecked');		
					$input.attr('checked', false);
					if ($input.hasClass('statusCheckBox')){
						aLink.parent().next().html("Inactive");	
						aLink.parent().next().addClass('grayOut');
					}
				}else{
					aLink.addClass('jqTransformChecked');		
					$input.attr('checked', true);
					if ($input.hasClass('statusCheckBox')){
						aLink.parent().next().html("Active");	
						aLink.parent().next().removeClass('grayOut');
					}
				}
				//trigger the envents on the input object
				//Begin changes for the External Prototype
				$input.trigger("change");
				return false;
			});

			// set the default state
			if ( this.checked ) { 
				aLink.addClass('jqTransformChecked');		
			}else{
				if ($input.hasClass('statusCheckBox')){
					aLink.parent().next().html("Inactive");	
					aLink.parent().next().addClass('grayOut');
				}
			}
			//End changes for the External Prototype
		});
	};
	/***************************
	  TextArea 
	 ***************************/	
	$.fn.jqTransTextarea = function(){
		return this.each(function(){
			var textarea = $(this);
	
			if(textarea.hasClass('jqtransformdone')) {return;}
			textarea.addClass('jqtransformdone');
	
			oLabel = jqTransformGetLabel(textarea);
			oLabel && oLabel.click(function(){textarea.focus();});
			
			var strTable = '<table cellspacing="0" cellpadding="0" border="0" class="jqTransformTextarea">';
			strTable +='<tr><td id="jqTransformTextarea-tl"></td><td id="jqTransformTextarea-tm"></td><td id="jqTransformTextarea-tr"></td></tr>';
			strTable +='<tr><td id="jqTransformTextarea-ml">&nbsp;</td><td id="jqTransformTextarea-mm"><div></div></td><td id="jqTransformTextarea-mr">&nbsp;</td></tr>';	
			strTable +='<tr><td id="jqTransformTextarea-bl"></td><td id="jqTransformTextarea-bm"></td><td id="jqTransformTextarea-br"></td></tr>';
			strTable +='</table>';					
			var oTable = $(strTable)
					.insertAfter(textarea)
					.hover(function(){
						!oTable.hasClass('jqTransformTextarea-focus') && oTable.addClass('jqTransformTextarea-hover');
					},function(){
						oTable.removeClass('jqTransformTextarea-hover');					
					})
				;
				
			textarea
				.focus(function(){oTable.removeClass('jqTransformTextarea-hover').addClass('jqTransformTextarea-focus');})
				.blur(function(){oTable.removeClass('jqTransformTextarea-focus');})
				.appendTo($('#jqTransformTextarea-mm div',oTable))
			;
			this.oTable = oTable;
			if($.browser.safari){
				$('#jqTransformTextarea-mm',oTable)
					.addClass('jqTransformSafariTextarea')
					.find('div')
						.css('height',textarea.height())
						.css('width',textarea.width())
				;
			}
		});
	};
	/***************************
	  Radio Buttons 
	 ***************************/	
	$.fn.jqTransRadio = function(){
		return this.each(function(){
			if($(this).hasClass('jqTransformHidden')) {return;}
			if($(this).hasClass('jqTransformSkip')) {return;}

			var $input = $(this);
			var inputSelf = this;
				
			oLabel = jqTransformGetLabel($input);
			oLabel && oLabel.click(function(){aLink.trigger('click');});
	
			var aLink = $('<a href="#" class="jqTransformRadio" rel="'+ this.name +'"></a>');
			$input.addClass('jqTransformHidden').wrap('<span class="jqTransformRadioWrapper"></span>').parent().prepend(aLink);
			
			$input.change(function(){
				inputSelf.checked && aLink.addClass('jqTransformChecked') || aLink.removeClass('jqTransformChecked');
				return true;
			});
			// Click Handler
			aLink.click(function(){
				if($input.attr('disabled')){return false;}
				$input.trigger('click').trigger('change');
	
				// uncheck all others of same name input radio elements
				$('input[name="'+$input.attr('name')+'"]',inputSelf.form).not($input).each(function(){
					$(this).attr('type')=='radio' && $(this).trigger('change');
				});
	
				return false;					
			});
			// set the default state
			inputSelf.checked && aLink.addClass('jqTransformChecked');
		});
	};
	/***************************
	  Select 
	 ***************************/	
	var tindex = 100;
	$.fn.jqTransSelect = function(){
		return this.each(function(index){
			var $select = $(this);

			if($select.hasClass('jqTransformHidden')) {return;}
			if($select.attr('multiple')) {return;}

			var oLabel  =  jqTransformGetLabel($select);
			/* First thing we do is Wrap it */
			var $wrapper = $select
				.addClass('jqTransformHidden')
				.wrap('<div class="jqTransformSelectWrapper"></div>')
				.parent()
			;
			$wrapper.css("z-index", tindex);
			tindex--;
			/* Now add the html for the select */
			$wrapper.prepend('<div><span></span><a href="#" class="jqTransformSelectOpen"></a></div><ul></ul>');
			var $ul = $('ul', $wrapper).css('width',$select.width()).hide();
			/* Now we add the options */
			$('option', this).each(function(i){
				var oLi = $('<li><a href="#" index="'+ i +'">'+ $(this).html() +'</a></li>');
				$ul.append(oLi);
			});


			/* Add click handler to the a */
			$ul.find('a').click(function(){
					$('a.selected', $wrapper).removeClass('selected');
					$(this).addClass('selected');	
					/* Fire the onchange event */
					if ($select[0].selectedIndex != $(this).attr('index') && $select[0].onchange) { $select[0].selectedIndex = $(this).attr('index'); $select[0].onchange(); }
					$select[0].selectedIndex = $(this).attr('index');
								
					$('span:eq(0)', $wrapper).html($(this).html());
                    $select.trigger('change'); 
					$ul.hide();
					$wrapper.parent().removeClass('focused');
					var objSelect = $(this).parent().parent().parent().parent().find("select").get(0);
					
					if (objSelect.id == "campain_select"){
						
						if (($(this).attr('index')) != 0){
							$("#sub_campain_select").css({visibility: "visible"});
							$("#sub_campain_label").css({visibility: "visible"});
						}else{
							$("#sub_campain_select").css({visibility: "hidden"});
							$("#sub_campain_label").css({visibility: "hidden"});							
						}
					}
					return false;
			});
			/* Set the default */
			$('a:eq('+ this.selectedIndex +')', $ul).click();
			$('span:first', $wrapper).click(function(){$("a.jqTransformSelectOpen",$wrapper).trigger('click');});
			oLabel && oLabel.click(function(){$("a.jqTransformSelectOpen",$wrapper).trigger('click');});
			this.oLabel = oLabel;
			
			/* Apply the click handler to the Open */
			var oLinkOpen = $('a.jqTransformSelectOpen', $wrapper)
				.click(function(){
					//Check if box is already open to still allow toggle, but close all other selects
					if( $ul.css('display') == 'none' ) {
						jqTransformHideSelect();
					} 
					if($select.attr('disabled')){
						$wrapper.parent().removeClass('focused');
						return false;
					}
					
					$wrapper.parent().addClass('focused');
					$ul.slideToggle('fast', function(){					
						var offSet = ($('a.selected', $ul).offset().top - $ul.offset().top);
						$ul.animate({scrollTop: offSet});
						
						if ($('li:visible', $ul).length <= 0) {
							$wrapper.parent().removeClass('focused');
						}
					});
					return false;
				})
			;

			// Set the new width
			var iSelectWidth = $select.outerWidth();
			var oSpan = $('span:first',$wrapper);
			var newWidth = Math.max(iSelectWidth, $wrapper.width());
			$wrapper.css('width',newWidth);
			$ul.css('width',newWidth-2);
			oSpan.css({width:newWidth-30});
			
		
			// Calculate the height if necessary, less elements that the default height
			//show the ul to calculate the block, if ul is not displayed li height value is 0
			$ul.css({display:'block',visibility:'hidden'});
			var iSelectHeight = ($('li',$ul).length)*($('li:first',$ul).height());//+1 else bug ff
			if(iSelectHeight < $ul.height()) {
				$ul.css({height:iSelectHeight,'overflow':'hidden'});//hidden else bug with ff
			}
			else {
				$ul.css("overflow-y", "auto");	
			}
			$ul.css({display:'none',visibility:'visible'});
			
		});
	};
	$.fn.jqTransSelectRemove = function(select) {
		
		select.parentsUntil(".jqTransformSelectWrapper").before(select);
		select.parentsUntil(".jqTransformSelectWrapper").remove();
		select.removeClass("jqTransformHidden");
		select.parentsUntil("jqtransformdone").parent().removeClass("jqtransformdone");
		
	}
	$.fn.jqTransform = function(options){
		opt = $.extend({},defaultOptions,options);
		
		/* each form */
		 return this.each(function(){
			var selfForm = $(this);
			if(selfForm.hasClass('jqtransformdone')) {return;}
			selfForm.addClass('jqtransformdone');
			
			$('input:checkbox', this).jqTransCheckBox();
			$('input:radio', this).jqTransRadio();			
			//$('input:text, input:password', this).jqTransInputText();
			//$('textarea', this).jqTransTextarea();
			
			if( $('select', this).jqTransSelect().length > 0 ){jqTransformAddDocumentListener();}
			selfForm.bind('reset',function(){var action = function(){jqTransformReset(this);}; window.setTimeout(action, 10);});

		}); /* End Form each */
				
	};/* End the Plugin */

})(jQuery);
				   
