//-----------------------------------------------------------------------------------------------------------------
//Name        : mod_script.js
//
//Created By  : Jonathan Freese (Appirio)
//Date        : 7/14/13
//Description : Modified copies of jQueries in script.js to perfomrm similar functions or provide temporary replacements
//
//-----------------------------------------------------------------------------------------------------------------

var $j = jQuery.noConflict();

$j(document).ready(function() {

   //Modify the dropdown height from 150 to 45, because other profile dropdown options are hidden
   //Tried to use this to overwrite the same function in script.js, but they appear vto
   //cancel each other out.  Clicking on the profile dropdown does nothing.
   //No console errors, but commenting this out fvor now.
//    $j(".header .desc-wrapper").click(function() {
//        var w = $j(this);
//        var d = $j(".dropdown", w);
//        var s = $j("span.name", w);
//        w.toggleClass("click-wrapper");
//        if(w.hasClass("click-wrapper")) {
//            d.css("width", s.width()+10);
//            s.animate({
//                height: 45
//            }, 200);
//            d.show();
//        }
//        else {
//            d.hide();
//            s.animate({
//                height: 15
//            }, 200);
//        }
//    });


    //New jQuery for the breadcrumb
    $j(".breadcrumb .site-nav-wrapper").click(function() {
        var w = $j(this);
        var d = $j(".dropdown", w);
        var s = $j("span.nav", w);
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
});
