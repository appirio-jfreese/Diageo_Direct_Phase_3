//-----------------------------------------------------------------------------------------------------------------
//Name        : mod_script.js
//
//Created By  : Jonathan Freese (Appirio)
//Date        : 7/14/13
//Description : Modified copies of jQueries in script.js to perfomrm similar functions or provide temporary replacements
//
//-----------------------------------------------------------------------------------------------------------------

jQuery(".header .desc-wrapper").click(function() {
    var w = jQuery(this);
    var d = jQuery(".dropdown", w);
    var s = jQuery("span.name", w);
    w.toggleClass("click-wrapper");
    if(w.hasClass("click-wrapper")) {
        d.css("width", s.width()+10);
        s.animate({
            height: 30  //this is the only change, needed because other profile dropdown options are hidden
        }, 200);
        d.show();
    }
    else {
        d.hide();
        s.animate({
            height: 15
        }, 200);
    }
});

jQuery(".breadcrumb .site-nav-wrapper").click(function() {
    var w = jQuery(this);
    var d = jQuery(".dropdown", w);
    var s = jQuery("span.nav", w);
    w.toggleClass("click-wrapper");
    if(w.hasClass("click-wrapper")) {
        d.css("width", s.width()+10);
        s.animate({
            height: 150
        }, 200);
        d.show();
    }
    else {
        d.hide();
        s.animate({
            height: 15
        }, 200);
    }
});
