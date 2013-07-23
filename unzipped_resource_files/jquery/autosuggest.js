/*
 * jQuery UI Autocomplete 1.8.16
 *
 * CUSTOM CHANGES
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Autocomplete
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *	jquery.ui.position.js
 */
(function (a) {
    var b = 0;
    a.widget("ui.autocomplete", {
        options: {
            appendTo: "body",
            autoFocus: false,
            delay: 300,
            minLength: 1,
            position: {
                my: "left top",
                at: "left bottom",
                collision: "none"
            },
            source: null
        },
        pending: 0,
        _create: function () {
            var b = this,
                c = this.element[0].ownerDocument,
                e;
            this.element.addClass("ui-autocomplete-input").attr("autocomplete", "off").attr({
                role: "textbox",
                "aria-autocomplete": "list",
                "aria-haspopup": "true"
            }).bind("keydown.autocomplete", function (c) {
                if (!(b.options.disabled || b.element.propAttr("readOnly"))) {
                    e = false;
                    var f = a.ui.keyCode;
                    switch (c.keyCode) {
                    case f.ENTER:
                    case f.NUMPAD_ENTER:
                        if (b.menu.active) {
                            e = true;
                            c.preventDefault()
                        };
                    case f.TAB:
                        if (!b.menu.active) return;
                        b.menu.select(c);
                        break;
                    case f.ESCAPE:
                        b.element.val(b.term);
                        b.close(c);
                        break;
                    case 40:
                        b.menu.next(new a.Event("mouseenter"));
                        break;
                    case 38:
                        b.menu.previous(new a.Event("mouseenter"));
                        break;
                    default:
                        clearTimeout(b.searching);
                        b.searching = setTimeout(function () {
                            if (b.term != b.element.val()) {
                                b.selectedItem = null;
                                b.search(null, c)
                            }
                        }, b.options.delay);
                        break
                    }
                }
            }).bind("keypress.autocomplete", function (a) {
                if (e) {
                    e = false;
                    a.preventDefault()
                }
            }).bind("focus.autocomplete", function () {
                if (!b.options.disabled) {
                    b.selectedItem = null;
                    b.previous = b.element.val()
                }
            }).bind("blur.autocomplete", function (a) {
                if (!b.options.disabled) {
                    clearTimeout(b.searching);
                    b.closing = setTimeout(function () {
                        b.close(a);
                        b._change(a)
                    }, 150)
                }
            });
            this._initSource();
            this.response = function () {
                return b._response.apply(b, arguments)
            };
			this.positioned = false;
            this.menu = a("<ul></ul>").addClass("ui-autocomplete").appendTo(a(this.options.appendTo || "body", c)[0]).mousedown(function (c) {
                var e = b.menu.element[0];
                a(c.target).closest(".ui-menu-item").length || setTimeout(function () {
                    a(document).one("mousedown", function (c) {
                        c.target !== b.element[0] && c.target !== e && !a.ui.contains(e, c.target) && b.close()
                    })
                }, 1);
                setTimeout(function () {
                    clearTimeout(b.closing)
                }, 13)
            }).menu({
                focus: function (a, c) {
                    c = c.item.data("item.autocomplete");
                    false !== b._trigger("focus", a, {
                        item: c
                    }) && /^key/.test(a.originalEvent.type) && b.element.val(c.value)
                },
                selected: function (a, d) {
                    var e = d.item.data("item.autocomplete"),
                        f = b.previous;
                    if (b.element[0] !== c.activeElement) {
                        b.element.focus();
                        b.previous = f;
                        setTimeout(function () {
                            b.previous = f;
                            b.selectedItem = e
                        }, 1)
                    }
                    false !== b._trigger("select", a, {
                        item: e
                    }) && b.element.val(e.value);
                    b.term = b.element.val();
                    b.close(a);
                    b.selectedItem = e
                },
                blur: function () {
                    b.menu.element.is(":visible") && b.element.val() !== b.term && b.element.val(b.term)
                }
            }).zIndex(this.element.zIndex() + 1).css({
                top: 0,
                left: 0
            }).hide().data("menu");
            a.fn.bgiframe && this.menu.element.bgiframe()
        },
        destroy: function () {
            this.element.removeClass("ui-autocomplete-input").removeAttr("autocomplete").removeAttr("role").removeAttr("aria-autocomplete").removeAttr("aria-haspopup");
            this.menu.element.remove();
            a.Widget.prototype.destroy.call(this)
        },
        _setOption: function (b, c) {
            a.Widget.prototype._setOption.apply(this, arguments);
            b === "source" && this._initSource();
            if (b === "appendTo") this.menu.element.appendTo(a(c || "body", this.element[0].ownerDocument)[0]);
            b === "disabled" && c && this.xhr && this.xhr.abort()
        },
        _initSource: function () {
            var c = this,
                f, g;
            if (a.isArray(this.options.source)) {
                f = this.options.source;
                this.source = function (b, c) {
                    c(a.ui.autocomplete.filter(f, b.term))
                }
            } else if (typeof this.options.source === "string") {
                g = this.options.source;
                this.source = function (f, h) {
                    c.xhr && c.xhr.abort();
                    c.xhr = a.ajax({
                        url: g,
                        data: f,
                        dataType: "json",
                        autocompleteRequest: ++b,
                        success: function (a) {
                            this.autocompleteRequest === b && h(a)
                        },
                        error: function () {
                            this.autocompleteRequest === b && h([])
                        }
                    })
                }
            } else this.source = this.options.source
        },
        search: function (a, b) {
            a = a != null ? a : this.element.val();
            this.term = this.element.val();
            if (a.length < this.options.minLength) return this.close(b);
            clearTimeout(this.closing);
            if (this._trigger("search", b) !== false) return this._search(a)
        },
        _search: function (a) {
            this.pending++;
            this.element.addClass("ui-autocomplete-loading");
            this.source({
                term: a
            }, this.response)
        },
        _response: function (a) {
            if (!this.options.disabled && a && a.length) {
                a = this._normalize(a);
                this._suggest(a);
                this._trigger("open")
            } else this.close();
            this.pending--;
            this.pending || this.element.removeClass("ui-autocomplete-loading")
        },
        close: function (a) {
            clearTimeout(this.closing);
            if (this.menu.element.is(":visible")) {
                this.menu.element.hide();
                this.menu.deactivate();
                this._trigger("close", a)
            }
        },
        _change: function (a) {
            this.previous !== this.element.val() && this._trigger("change", a, {
                item: this.selectedItem
            })
        },
        _normalize: function (b) {
            if (b.length && b[0].label && b[0].value) return b;
            return a.map(b, function (b) {
                if (typeof b === "string") return {
                    label: b,
                    value: b
                };
                return a.extend({
                    label: b.label || b.value,
                    value: b.value || b.label
                }, b)
            })
        },
        _suggest: function (b) {
            var c = this.menu.element.empty().zIndex(this.element.zIndex() + 1);
            this._renderMenu(c, b);
            this.menu.deactivate();
            this.menu.refresh();
            c.show();
            this._resizeMenu();
			if(this.positioned == false){
				c.position(a.extend({
					of: this.element
				}, this.options.position));
				this.positioned = true;
			}
            this.options.autoFocus && this.menu.next(new a.Event("mouseover"))
        },
        _resizeMenu: function () {
            var a = this.menu.element;
            a.outerWidth(Math.max(a.width("").outerWidth(), this.element.outerWidth()))
        },
        _renderMenu: function (b, c) {
            var e = this;
            a.each(c, function (a, c) {
                e._renderItem(b, c)
            })
        },
        _renderItem: function (b, c) {
            return a("<li></li>").data("item.autocomplete", c).append(a("<a></a>").text(c.label)).appendTo(b)
        },
        _move: function (a, b) {
            if (this.menu.element.is(":visible")) if (this.menu.first() && /^previous/.test(a) || this.menu.last() && /^next/.test(a)) {
                this.element.val(this.term);
                this.menu.deactivate()
            } else this.menu[a](b);
            else this.search(null, b)
        },
        widget: function () {
            return this.menu.element
        }
    });
    a.extend(a.ui.autocomplete, {
        escapeRegex: function (a) {
            return a.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")
        },
        filter: function (b, c) {
            var e = new RegExp('^'+a.ui.autocomplete.escapeRegex(c), "i");
            return a.grep(b, function (a) {
                return e.test(a.label || a.value || a)
            })
        }
    })
})(jQuery);
(function (a) {
    a.widget("ui.menu", {
        _create: function () {
            var b = this;
            this.element.addClass("ui-menu ui-widget ui-widget-content ui-corner-all").attr({
                role: "listbox",
                "aria-activedescendant": "ui-active-menuitem"
            }).click(function (c) {
                if (a(c.target).closest(".ui-menu-item a").length) {
                    c.preventDefault();
                    b.select(c)
                }
            });
            this.refresh()
        },
        refresh: function () {
            var b = this;
            this.element.children("li:not(.ui-menu-item):has(a)").addClass("ui-menu-item").attr("role", "menuitem").children("a").addClass("ui-corner-all").attr("tabindex", -1).mouseenter(function (c) {
                b.activate(c, a(this).parent())
            }).mouseleave(function () {
                b.deactivate()
            })
        },
        activate: function (a, b) {
            this.deactivate();
            if (this.hasScroll()) {
                var c = b.offset().top - this.element.offset().top,
                    d = this.element.scrollTop(),
                    e = this.element.height();
                if (c < 0) this.element.scrollTop(d + c);
                else c >= e && this.element.scrollTop(d + c - e + b.height())
            }
            this.active = b.eq(0).children("a").addClass("ui-state-hover").attr("id", "ui-active-menuitem").end();
            this._trigger("focus", a, {
                item: b
            });
            jQuery(b).trigger("mouseenter")
        },
        deactivate: function () {
            if (this.active) {
                this.active.children("a").removeClass("ui-state-hover").removeAttr("id");
                this._trigger("blur");
                jQuery(this.active).trigger("mouseleave");
                this.active = null
            }
        },
        next: function (a) {
            this.move("next", ".ui-menu-item:first", a)
        },
        previous: function (a) {
            this.move("prev", ".ui-menu-item:last", a)
        },
        first: function () {
            return this.active && !this.active.prevAll(".ui-menu-item").length
        },
        last: function () {
            return this.active && !this.active.nextAll(".ui-menu-item").length
        },
        move: function (a, b, c) {
            if (this.active) {
                a = this.active[a + "All"](".ui-menu-item").eq(0);
                a.length ? this.activate(c, a) : this.activate(c, this.element.children(b))
            } else this.activate(c, this.element.children(b))
        },
        nextPage: function (b) {
            if (this.hasScroll()) if (!this.active || this.last()) this.activate(b, this.element.children(".ui-menu-item:first"));
            else {
                var c = this.active.offset().top,
                    e = this.element.height(),
                    f = this.element.children(".ui-menu-item").filter(function () {
                        var b = a(this).offset().top - c - e + a(this).height();
                        return b < 10 && b > -10
                    });
                f.length || (f = this.element.children(".ui-menu-item:last"));
                this.activate(b, f)
            } else this.activate(b, this.element.children(".ui-menu-item").filter(!this.active || this.last() ? ":first" : ":last"))
        },
        previousPage: function (b) {
            if (this.hasScroll()) if (!this.active || this.first()) this.activate(b, this.element.children(".ui-menu-item:last"));
            else {
                var c = this.active.offset().top,
                    e = this.element.height();
                result = this.element.children(".ui-menu-item").filter(function () {
                    var b = a(this).offset().top - c + e - a(this).height();
                    return b < 10 && b > -10
                });
                result.length || (result = this.element.children(".ui-menu-item:first"));
                this.activate(b, result)
            } else this.activate(b, this.element.children(".ui-menu-item").filter(!this.active || this.first() ? ":last" : ":first"))
        },
        hasScroll: function () {
            return this.element.height() < this.element[a.fn.prop ? "prop" : "attr"]("scrollHeight")
        },
        select: function (a) {
            this._trigger("selected", a, {
                item: this.active
            })
        }
    })
})(jQuery);
