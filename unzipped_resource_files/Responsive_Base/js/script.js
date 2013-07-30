var $j = jQuery.noConflict();

$j(document).ready(function() {

    $j(".hide").hide();

    $j(".header .search input.text").keyup(function(e) {
        if(e.keyCode === 13) {
            $j(".header .search a.btn").trigger("click");
        }
    });
    $j(".footer .footer-link-menu").click(function() {
       $j(".footer .links").slideToggle();
    });

    //Modify the dropdown height from 150 to 45, because other profile dropdown options are hidden
    $j(".header .desc-wrapper").click(function() {
        var w = $j(this);
        var d = $j(".dropdown", w);
        var s = $j("span.name", w);
        w.toggleClass("click-wrapper");
        if(w.hasClass("click-wrapper")) {
            d.css("width", s.width()+10);
            s.animate({
                height: 45
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

    $j("h3 a.toggleable").click(function() {
        var div = $j(this).parent().next();
        div.slideToggle();
    });

    $j('.news').flexslider({
        animation: "slide",
        animationLoop: false
    });

    $j(".search input.text").focus(function() {
        $j(this).addClass("has-text");
    });
    $j(".search input.text").blur(function() {
        var val = $j(this).val();
        if(val === "") $j(this).addClass("has-text");
    });

    $j("a.go-top").click(function() {
        $j(window).scrollTop(0);
    });

    if($j(".modal").length > 0) {
        $j(window).resize(function() {
            $j.modal.resize();
        });
    }
    $j("a").live("click", function() {
        var href = $j(this).attr("href");
        if(href === 'index.html') {
            window.location.href = 'index.html?t=1';
            return false;
        }
        return true;
    });


    $j("h2").jqTransform();
    $j(".list-view").jqTransform();
    $j(".filter").jqTransform();


    if($j(".login-page").length > 0) {
        $j(".login-form").jqTransform();

        $j(".login-modal").css({
            width: $j(".content").width()
        })

        $j(".login-btn").click(function() {
            var a = $j(this);
            var t = a.data("count");
            if(typeof t === "undefined") {
                a.data("count", 1);
                $j(".error").show();
                return false;
            }
        });

        $j(window).resize(function() {
            $j(".login-modal").css({
                width: $j(".content").width()
            })
        });

    }


    if($j(".home-page").length > 0) {


        $j(".boxes a").hover(
            function() {
                var a = $j(this);
                if(a.parent().hasClass("empty")) return false;
                a.stop().animate({top: "15%"}, 400, function() {

                });
            },
            function() {
                var a = $j(this);
                if(a.parent().hasClass("empty")) return false;
                a.stop().animate({top: "25.29411764705882%"}, 400, function() {

                });
            }
        );

        $j(".boxes a").click(function() {
            var a = $j(this);
            var related = a.data("related");
            if(related) {
                $j(".boxes .column").hide();
                $j("."+related).show();
            }
        });

        $j(".modal").css({
            "max-width": $j(".content").width()
        });
        $j(window).resize(function() {
            $j(".modal").css({
                "max-width": $j(".content").width()
            });
        });


        $j("#theme-selector-modal").jqTransform().modal();

        var href = window.location.href;
        if(href.indexOf('?t=1') !== -1) {
            $j("#theme-selector-modal .go-btn").trigger("click");
        }
    }

    if($j(".pil-landing-page").length > 0) {
        $j('.brand-box .inner').flexslider({
            animation: "slide",
            animationLoop: false,
            minItems: 1,
            maxItems: 10,
            itemWidth: 95,
            slideshow: false,
            after: function() {
                updateSlideBtn();
            }
        });
        var updateBrandBoxStyle = function() {
            var t = 0;
            $j(".brand-box").each(function() {
                t++;
                var b = $j(this);
                var slide = $j(".inner", b);
                var liLength = $j(".slides li", slide).length;
                var data = slide.data("flexslider");
                slide.css({
                        'padding-left': 0,
                        'padding-right': 0
                    });
                var x = 0;
                var size = Math.floor(slide.width()/95+0.00001);
                var sw = slide.width();
                if(data.pagingCount > 1) {
                    x = sw/2 - size*95/2;
                    slide.css({
                        'padding-left': x,
                        'padding-right': x
                    });
                }
                else {
                    x = sw/2 - liLength*95/2;
                    slide.css({
                        'padding-left': x,
                        'padding-right': x
                    });
                }
                $j(".flex-viewport", b).css("width", sw-x*2);
                if(data.pagingCount > 1) {
                    $j(".prev, .next", b).show();
                }
                else {
                    $j(".prev, .next", b).hide();
                }
                if(data.currentSlide > 0) {
                    $j(".prev", b).removeClass("disabled");
                }
                else {
                    $j(".prev", b).addClass("disabled");
                }
                if(data.currentSlide < data.pagingCount-1) {
                    $j(".next", b).removeClass("disabled");
                }
                else {
                    $j(".next", b).addClass("disabled");
                }
            });
        }
        var updateSlideBtn = function() {
            $j(".brand-box").each(function() {
                var b = $j(this);
                var slide = $j(".inner", b);
                var data = slide.data("flexslider");
                if(data.pagingCount > 1) {
                    $j(".prev, .next", b).show();
                }
                else {
                    $j(".prev, .next", b).hide();
                }
                if(data.currentSlide > 0) {
                    $j(".prev", b).removeClass("disabled");
                }
                else {
                    $j(".prev", b).addClass("disabled");
                }
                if(data.currentSlide < data.pagingCount-1) {
                    $j(".next", b).removeClass("disabled");
                }
                else {
                    $j(".next", b).addClass("disabled");
                }
            });
        }
        updateBrandBoxStyle();
        $j(window).resize(function() {
            updateBrandBoxStyle();
        });
        $j(".brand-box .prev").click(function() {
            var a = $j(this);
            var slide = a.parent().parent().find(".inner");
            var data = slide.data("flexslider");
            if(data.currentSlide === data.pagingCount-1) {
                slide.parent().find(".next").removeClass("disabled");
            }
            if(data.currentSlide === 1) {
                a.addClass("disabled");
            }
            slide.flexslider("prev");
        });
        $j(".brand-box .next").click(function() {
            var a = $j(this);
            var slide = a.parent().parent().find(".inner");
            var data = slide.data("flexslider");
            if(data.currentSlide === 0) {
                slide.parent().find(".prev").removeClass("disabled");
            }
            if(data.currentSlide === data.pagingCount-2) {
                a.addClass("disabled");
            }
            slide.flexslider("next");
        });

        $j(".brand-box li a").click(function() {
            var a = $j(this);
            var brand = a.closest('.brand-box');
            var popover = $j(".pil-popover");
            var left = a.offset().left - brand.offset().left - 40;
            if(left < -10) left = -10;
            popover.appendTo(brand).css({
                left: left,
                top: a.offset().top - brand.offset().top + 128
            });
            if(a.hasClass("clicked")) popover.toggle();
            else {
                popover.show();
                $j(".brand-box li a").removeClass("clicked");
                a.addClass("clicked");
            }
        });

        $j(".brand-box li a").hover(
            function() {
                $j("body").data("hover-brand", 1);
                resetBottle();
                var a = $j(this);
                var brand = a.closest('.brand-box');
                var popover = $j(".pil-popover");
                a.find("img").stop().animate({
                    width: 65,
                    left: 15
                }, 350);
                $j("body").data("hover-brand-ele", a);
            },
            function() {
                $j("body").data("hover-brand", 0);
                setTimeout(function() {
                    if(!$j(".pil-popover").data("hover") && !$j("body").data("hover-brand")) {
                        resetBottle()
                    }
                }, 100);
            }
        );
        $j(".pil-popover").hover(
            function() {
                $j(this).data("hover", 1);
            },
            function() {
                $j(this).data("hover", 0);
                resetBottle();
            }
        );
        var resetBottle = function() {
            var popover = $j(".pil-popover");
            var a = $j("body").data("hover-brand-ele");
            if(a) {
                a.find("img").stop().animate({
                    width: 55,
                    left: 20
                }, 350);
            }
        }
    }

    if($j(".pil-page, .col-page").length > 0) {
        $j(".filter").jqTransform();
        $j(".capacity").jqTransform();

        $j(".brand-variants li.with-sub a:eq(0)").click(function() {
            var li = $j(this).parent();
            li.toggleClass("opened");
            $j("ul.lv2", li).slideToggle();
        });
        $j(".brand-variants li").click(function() {
            var li = $j(this);
            if(li.hasClass("with-sub")) return false;
            $j(".brand-variants li a").removeClass("active");
            $j("a", li).eq(0).addClass("active");
        });
        $j(".doc-list input[type='checkbox']").change(function() {
            setTimeout(function() {
                if($j(".doc-list input[type='checkbox']:checked").length > 0) {
                    $j(".operation-line a").removeClass("disabled");
                }
                else {
                    $j(".operation-line a").addClass("disabled");
                }
            }, 100);
        });
        $j(".brand-list .doc").each(function(i) {
            if(i%2 === 1) $j(this).addClass("last");
        });
        $j(".select-all input[type='checkbox']").change(function() {
            var c = $j(this);
            $j(".doc-list input[type='checkbox']").each(function() {
                if($j(this).prop("checked") !== c.prop("checked") &&
                  !$j(this).parents("."+pageNamePrefix+"-Section-Blok").hasClass("hidden")
                  ){
                    $j(this).trigger("click");
                }
            });
        });
        $j(".filter .list-mode").click(function() {
            $j(this).addClass("active").next().removeClass("active");
            $j(".doc-list .list-view").removeClass("grid-view");

            $j(".doc-list .list-view").each(function() {
                $j(".doc", $j(this)).removeClass("last").last().addClass("last")
            });
            $j(".doc-list .doc");
            $j(".doc-btns:visible").each(function() {
                positionDocBtns($j(this));
            });
        });
        $j(".filter .grid-mode").click(function() {
            $j(this).addClass("active").prev().removeClass("active");
            $j(".doc-list .list-view").addClass("grid-view");
            $j(".doc-list .list-view").each(function() {
                $j(".doc", $j(this)).each(function(i) {
                    if(i%2 == 1) $j(this).addClass("last");
                    else $j(this).removeClass("last");
                })
            });
            $j(".doc-btns:visible").each(function() {
                positionDocBtns($j(this));
            });
        });
    }

    if($j(".col-page").length > 0) {
        $j("#conversation-modal .remove-btn").click(function() {
            var a = $j(this);
            var post = a.closest(".post");
            post.slideUp();
        });
    }

    if($j(".setting-btn").length > 0) {
        $j(".setting-btn").click(function() {
            var doc = $j(this).parent();
            var btns = $j(this).parent().find(".doc-btns");
            positionDocBtns(btns);
            btns.toggle();
        });
        var positionDocBtns = function(btns) {
            var doc = btns.parents(".doc");
            if(doc.parents(".list-view").hasClass("grid-view")) {
                btns.css({
                    width: '100%',
                    right: 0,
                    bottom: $j(".info", doc).height() + 1
                });
            }
            else {
                btns.css({
                    width: 200,
                    right: 80,
                    bottom: 20
                })
            }
        };
    }

    if($j(".mep-landing-page").length > 0) {
        $j(".doc-list .list-view .doc").jqTransform();
        $j(".filter").jqTransform();

        $j(".include-select div").click(function() {
            var div = $j(this);
            var w = div.parent();
            $j("ul", w).slideToggle();
        });
        $j(".include-select ul a input").click(function() {
            $j(this).parent().trigger("click");
            //return false;
        });
        $j(".include-select ul a").click(function() {
            var a = $j(this);
            var check = $j("input", a);
            var ul = a.closest("ul");
            ul.slideUp();
            if(check.prop("disabled")) return false;
            var to = false;
            if(check.prop("checked")) to = true;
            check.prop("checked", to);
            /*if(a.attr("index") == 0) {
                $j("input", ul).eq(1).prop("checked", to);
                $j("input", ul).eq(2).prop("checked", to);
            }
            */
        });

        $j(".calendar-head a.with-dropdown").click(function() {
            var a = $j(this);
            var d = a.closest(".calendar-head");
            var p = $j(".popover", d);
            p.css({
                left: a.position().left - 60
            }).show();
        });
        $j(".calendar-head .popover .close-btn, .calendar-head .popover .select-btn").click(function() {
            $j(".calendar-head .popover").hide();
        });

        $j("#period-select").change(function() {
            var s = $j(this);
            var val = +$j("option:selected", s).val();
            if(val === 1) {
                location.href = 'monthly-execution-plan-landing.html';
            }
            else {
                location.href = 'monthly-execution-plan-quarterly.html';
            }
        });
        $j("#header-period-select").change(function() {
            var s = $j(this);
            var val = +$j("option:selected", s).val();
            if(val === 1) {
                location.href = 'monthly-execution-plan-click-header.html';
            }
            else {
                location.href = 'monthly-execution-plan-click-header-quarterly.html';
            }
        })

        $j(".desc-block").click(function() {
            var link = $j(this).data("link");
            window.location.href = link;
        });
    }

    if($j(".mep-item-page, .isv-item-page, .results-page, .sm-page, .bmi-page, .pla-page, .cd-page").length > 0) {
        $j("a.email, a.share").click(function() {
            var a = $j(this);
            if(a.hasClass("disabled")) return false;
            //$j("#shareModal").modal();
        });
        $j(".select-all input[type='checkbox']").change(function() {
            var c = $j(this);
            $j(".doc-list input[type='checkbox']").each(function() {
                if($j(this).prop("checked") !== c.prop("checked") &&
                  !$j(this).parents("."+pageNamePrefix+"-Section-Blok").hasClass("hidden")
                  ){
                    $j(this).trigger("click");
                }
            });
        });
        $j(".doc-list input[type='checkbox']").change(function() {
            setTimeout(function() {
                if($j(".doc-list input[type='checkbox']:checked").length > 0) {
                    $j(".operation-line a").removeClass("disabled");
                }
                else {
                    $j(".operation-line a").addClass("disabled");
                }
            }, 100);
        });
        $j(".add-to-basket").click(function() {
            $j(this).toggleClass("remove-basket");
        });
        $j(".follow").click(function() {
            $j(this).toggleClass("unfollow");
        });

        $j(".filter .list-mode").click(function() {
            $j(this).addClass("active").next().removeClass("active");
            $j(".doc-list .list-view").removeClass("grid-view");

            $j(".doc-list .list-view").each(function() {
                $j(".doc", $j(this)).removeClass("last").last().addClass("last")
            });
            $j(".doc-list .doc");
            $j(".doc-btns:visible").each(function() {
                positionDocBtns($j(this));
            });
        });
        $j(".filter .grid-mode").click(function() {
            $j(this).addClass("active").prev().removeClass("active");
            $j(".doc-list .list-view").addClass("grid-view");
            $j(".doc-list .list-view").each(function() {
                $j(".doc", $j(this)).each(function(i) {
                    if(i%3 == 2) $j(this).addClass("last");
                    else $j(this).removeClass("last");
                })
            });
            $j(".doc-btns:visible").each(function() {
                positionDocBtns($j(this));
            });
        });

    }


    if($j(".isv-landing-page, .mul-page").length > 0) {

        $j("h2").jqTransform();
        $j(".doc-list .list-view .doc").jqTransform();
        $j(".filter").jqTransform();


        $j(".include-select div").click(function() {
            var div = $j(this);
            var w = div.parent();
            $j("ul", w).slideToggle();
        });
        $j(".include-select ul a input").click(function() {
            $j(this).parent().trigger("click");
        });
        $j(".include-select ul a").click(function() {
            var a = $j(this);
            var check = $j("input", a);
            var ul = a.closest("ul");
            ul.slideUp();
            if(check.prop("disabled")) return false;
            var to = false;
            if(check.prop("checked")) to = true;
            check.prop("checked", to);

            if(a.attr("index") == 0) {
                if(to) {
                    $j(".plans").removeClass("no-spirits");
                }
                else {
                    $j(".plans").addClass("no-spirits");
                }
            }
            updateH3Height();
        });
        $j(".calendar-head a.with-dropdown").click(function() {
            var a = $j(this);
            var d = a.closest(".calendar-head");
            var p = $j(".popover", d);
            p.css({
                left: a.position().left - 60
            }).show();
        });
        $j(".calendar-head .popover .close-btn, .calendar-head .popover .select-btn").click(function() {
            $j(".calendar-head .popover").hide();
        });

        $j("#period-select").change(function() {
            var s = $j(this);
            var val = +$j("option:selected", s).val();
            if($j(".isv-landing-page").length > 0)  {
                if(val === 1) {
                    location.href = 'innovation-landing.html';
                }
                else {
                    location.href = 'innovation-quarterly.html';
                }
            }
            else if($j(".mul-page").length > 0)  {
                if(val === 1) {
                    location.href = 'multicultural.html';
                }
                else {
                    location.href = 'multicultural-quarterly.html';
                }
            }
        });
        $j("#header-period-select").change(function() {
            var s = $j(this);
            var val = +$j("option:selected", s).val();
            if($j(".isv-landing-page").length > 0)  {
                if(val === 1) {
                    location.href = 'innovation-click-header.html';
                }
                else {
                    location.href = 'innovation-click-header-quarterly.html';
                }
            }
        });
        $j(".desc-block").click(function() {
            var link = $j(this).data("link");
            window.location.href = link;
        });

        var updateH3Height = function() {
            $j(".plan h3").each(function() {
                var h = $j(this);
                if(h.height() > 60) {
                    h.addClass("two-lines");
                }
                else if(h.height() < 40) {
                    h.removeClass("two-lines");
                }
            });
            $j(".plan a.p").each(function() {
                var h = $j(this);
                if(h.height() < 30) {
                    h.removeClass("two-lines");
                }
                else if(h.height() > 40) {
                    h.addClass("two-lines");
                }
            })
        }
        updateH3Height();
        $j(window).resize(function() {
            updateH3Height();
        });
    }

    if($j(".contact-case-page").length > 0) {
        $j(".write-comment a.button").click(function() {
            var w = $j(".write-comment");
            var h = w.prev();
            w.hide();
            h.hide();
            $j(".comments").show();
        });
    }

    if($j(".contact-new-case-page").length > 0) {
        $j(".form-line").jqTransform();

        $j("input.file").change(function() {
            var file = $j(this);
            var val = file.val();
            file.closest(".form-line").find("input.text").val(val);
        });
    }
    if($j(".user-profile-page").length > 0) {
        $j(".form-line").jqTransform();
    }

    /*if($j(".sm-page, .bmi-page, .pla-page, .cd-page").length > 0) {
        $j(".result-filter").click(function() {
            var a = $j(this);
            a.toggleClass("open");
            a.next().slideToggle(100);
            $j(".result-filter-layer").hide();
        });

        $j(".result-filter-layer a.clear-btn").click(function() {
            window.location.href = window.location.href;
        });
        $j(".result-filter-layer a.apply-btn").click(function() {
            $j(".result-filter").trigger("click");
        });

        $j(".result-filter-layer .other").jqTransform();
        $j(".result-filter-layer .inner").jqTransform();
        $j(".result-filter-layer .select-filter-all").jqTransform();

        $j(".content > .button-line a").click(function() {
            var a = $j(this);
            var related = a.data("related");
            if(typeof related !== "undefined") {
                $j(".result-filter-layer").hide();

                if(related === 'bv-filter') {
                    var len = $j(".brand-filter .brands a.selected").length + $j(".brand-filter .other .other-brand input:checked").length;
                    if(len > 0) related = 'bv-ok-filter';
                }
                if(related === 'time-filter') {
                    $j(".time-filter .quarterly").flexslider({
                        animation: "slide",
                        animationLoop: false,
                        minItems: 1,
                        maxItems: 4,
                        itemWidth: 215,
                        itemMargin: 5,
                        slideshow: false,
                        after: function() {
                        }
                    });
                }

                $j("."+related).show();

                resetFormLeft();
            }
            a.parent().find("a").removeClass("active");
            a.addClass("active");
        });
        $j(".result-filter-layer a.close-btn").click(function() {
            $j(this).parent().hide();
            $j(".filter-buttons a").removeClass("active");
        });
        $j(".brand-filter .brands a").click(function() {
            var a = $j(this);
            if(a.hasClass("other-btn")) {
                $j(".brand-filter .other").toggle();
                return false;
            }
            a.toggleClass("selected");
        });
        $j(".brand-filter .other .other-brand input").change(function() {
            var input = $j(this);
            if($j(".brand-filter .other .other-brand input:checked").length > 0) {
                $j(".brand-filter .other-btn").addClass("selected");
            }
            else {
                $j(".brand-filter .other-btn").removeClass("selected");
            }
        });
        $j(".sm-filter .select-filter-all input").change(function() {
            var input = $j(this);
            var checked = input.is(":checked");
            $j(".sm-filter .form-left input").each(function() {
                var i = $j(this);
                if(i.is(":checked") !== checked) {
                    i.parent().find("a").trigger("click");
                }
            });
        });
        $j(window).resize(function() {
            resetFormLeft();
        });
        var resetFormLeft = function() {
            $j(".result-filter-layer .form-left label").each(function() {
                var label = $j(this);
                if(label.height() > 70) {
                    label.addClass("two-lines");
                }
                else if(label.height() < 20) {
                    label.removeClass("two-lines");
                }
            });
        }

        $j(".time-filter .button-line a").click(function() {
            var a = $j(this);
            var buttons = a.parent();
            $j("a", buttons).removeClass("active");
            a.addClass("active");
            var related = a.data("related");
            $j(".time-filter .date-selector").hide();
            $j(".time-filter ."+related).show();
            $j(".time-filter ."+related).flexslider({
                animation: "slide",
                animationLoop: false,
                minItems: 1,
                maxItems: 4,
                itemWidth: 215,
                itemMargin: 5,
                slideshow: false,
                after: function() {
                }
            });

        })
        $j(".time-filter .date-selector .slides a").click(function() {
            var a = $j(this);
            a.toggleClass("selected");
        });

    }

    if($j(".pos-page").length > 0) {
        $j(".agreeBtn").click(function() {
            $j(this).parent().parent().hide();
            $j(".boxes").show();
        });
    }
    if($j(".faq-page").length > 0) {
        $j(".toggle-btn").click(function() {
            $j(this).toggleClass("expanded");
            $j(this).parent().find("p").slideToggle("fast");
        });
        $j(".expand-btn").click(function() {
            $j(".case > p").slideDown("fast");
            $j(".toggle-btn").addClass("expanded");
        });
        $j(".collapse-btn").click(function() {
            $j(".case > p").slideUp("fast");
            $j(".toggle-btn").removeClass("expanded");
        });
    }*/

});
