jQuery(document).ready(function() {
    jQuery('.month-previous').click(previousMonth);
    jQuery('.month-next').click(nextMonth);
	jQuery('.jumpToDate').datepicker({
		showOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: 'Close',
		showButtonPanel :true,
		selectOtherMonths: true,
		dateFormat: 'yy-mm-dd',
	beforeShow: function( input ) {  
	    setTimeout(function() {  
		var buttonPane = jQuery(input).datepicker("widget").find( ".ui-datepicker-buttonpane" );   
		var btn = jQuery('<button class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" type="button">Select</button>');  
		btn.unbind("click").bind("click", function () {  
		    var selectedDate = jQuery.datepicker._formatDate(jQuery.datepicker._getInst(input)); 
		    jQuery.datepicker.selectedDay;  
		    setStartDateValue(selectedDate);
		    jQuery.datepicker._hideDatepicker();
		});  
		btn.appendTo( buttonPane );
		buttonPane.find('button').addClass('update-filter').css('margin-bottom', 5);
	    }, 1 );  
	},
	onChangeMonthYear: function(year, month, inst ) {  
	    var input = inst.input[0];
	    setTimeout(function() {  
		var buttonPane = jQuery(input).datepicker("widget").find( ".ui-datepicker-buttonpane" );   
		var btn = jQuery('<button class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" type="button">Select</button>');  
		btn.unbind("click").bind("click", function () {  
		    var selectedDate = jQuery.datepicker._formatDate(jQuery.datepicker._getInst(input)); 
		    setStartDateValue(selectedDate);
		    jQuery.datepicker._hideDatepicker();
		});  
		btn.appendTo( buttonPane );
		buttonPane.find('button').addClass('update-filter').css('margin-bottom', 5);
	    }, 1 );  
	}
	});                                
});