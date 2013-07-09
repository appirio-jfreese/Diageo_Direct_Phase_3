		// Load Calender JS (Picked from script.js)
    function loadCalenderJs(){
        jQuery(".calendar-head a.with-dropdown").click(function() {
            var a = jQuery(this);
            var d = a.closest(".calendar-head");
            var p = jQuery(".popover", d);
            p.css({
                    left: a.position().left - 60
            }).show();
        });
        
        jQuery(".calendar-head .popover .close-btn, .calendar-head .popover .select-btn").click(function() {
            jQuery(".calendar-head .popover").hide();
        });       
    }
    
    // Sets selected calender value and calls action function : setStartDateValue()
    function setSelectedCalender(currEle){      
        var currBtn = jQuery(currEle);
        var calendarHeadEle = currBtn.closest(".calendar-head");
        var popoverDiv = jQuery(".popover", calendarHeadEle);
        if(popoverDiv.find("select").length == 2){          
            var selectedMon = popoverDiv.find("select")[0].selectedOptions[0].value;
            var selectedYr = popoverDiv.find("select")[1].selectedOptions[0].value;
            var paramVal = selectedYr + '-' + selectedMon + '-01';
            setStartDateValue(paramVal);
        }
    }