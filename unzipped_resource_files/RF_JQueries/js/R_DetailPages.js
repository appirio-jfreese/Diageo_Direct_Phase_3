// On Document Load
jQuery(document).ready(function() {
	sectionVisibility();
	initializationFunction();
});


// Action to perform JQ Tratnsformation
// *** NOTE : NO NEED OF THIS IF WE USE WHOLE (document).ready SCRIPT IN A SEPRATE METHOD, WILL USE THAT METHOD INSTEAD OF THIS
function jqTransformScript(){
	jQuery("h2").jqTransform();
	jQuery(".list-view").jqTransform();
	jQuery(".filter").jqTransform();
	jQuery(".doc-list .list-view .doc").jqTransform();
	jQuery(".select-all input[type='checkbox']").change(function() {
            var c = $j(this);
            $j(".doc-list input[type='checkbox']").each(function() {
                if($j(this).prop("checked") !== c.prop("checked")) {
                    $j(this).trigger("click");
                }
            });
    });
	jQuery(".doc-list input[type='checkbox']").change(function() {
		setTimeout(function() {
			if(jQuery(".doc-list input[type='checkbox']:checked").length > 0) {
				jQuery(".operation-line a").removeClass("disabled");
			}
			else {
				jQuery(".operation-line a").addClass("disabled");
			}
		}, 100);
	});
	jQuery(".setting-btn").click(function() {
		var doc = jQuery(this).parent();
		var btns = jQuery(this).parent().find(".doc-btns");
		positionDocBtns(btns);
		btns.toggle();
	});
	var positionDocBtns = function(btns) {
		var doc = btns.parent().parent();
		if(doc.hasClass("grid-view")) {
			btns.css({
				width: '100%',
				right: 0,
				bottom: jQuery(".info", doc).height() + 1
			});
		}
		else {
			btns.css({
				width: 200,
				right: 80,
				bottom: 20
			})
		}
	}
}

function initializationFunction() {
  jQuery(".sortAlp").change(function() {
	var orderBy = jQuery(this).val();
	if(orderBy != '' ) { 
		orderByAlphabetice(orderBy);
	}
  }); 
  
  jQuery(".period-select").change(function() {
	var showingDoc = jQuery(this).val();
	if(showingDoc != '' ) { 
		changeNumberOfItemPerPage(showingDoc);
	}
  }); 
	   
}