jQuery('.previous-period').live('click',previousPeriod);
jQuery('.next-period').live('click',nextPeriod);
jQuery('.label-time-period').live('mouseenter',function(){
	jQuery(this).addClass('time-hover');
});
jQuery('.label-time-period').live('mouseleave',function(){
	jQuery(this).removeClass('time-hover');
});