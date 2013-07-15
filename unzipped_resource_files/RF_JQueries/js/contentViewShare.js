// Call model and set element margein top,left
function showModalPopup(){
	jQuery("#shareModal").modal();
	jQuery("#shareModal").css({
		marginTop: - (jQuery("#shareModal").outerHeight(true) / 2),
		marginLeft: - (jQuery("#shareModal").outerWidth(true) / 2)
		
	});
}
	