/*!
 * OneUI - v1.2.0 - Auto-compiled on 2015-09-01 - Copyright 2015
 * @author pixelcave
 */
 + function(a) {
    "use strict";

    function b() {
        var a = document.createElement("bootstrap"),
            b = {
                WebkitTransition: "webkitTransitionEnd",
                MozTransition: "transitionend",
                OTransition: "oTransitionEnd otransitionend",
                transition: "transitionend"
            };
        for (var c in b)
            if (void 0 !== a.style[c]) return {
                end: b[c]
            };
        return !1
    }
    a.fn.emulateTransitionEnd = function(b) {
        var c = !1,
            d = this;
        a(this).one("bsTransitionEnd", function() {
            c = !0
        });
        var e = function() {
            c || a(d).trigger(a.support.transition.end)
        };
        return setTimeout(e, b), this
    }, a(function() {
        a.support.transition = b(), a.support.transition && (a.event.special.bsTransitionEnd = {
            bindType: a.support.transition.end,
            delegateType: a.support.transition.end,
            handle: function(b) {
                return a(b.target).is(this) ? b.handleObj.handler.apply(this, arguments) : void 0
            }
        })
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var c = a(this),
                e = c.data("bs.alert");
            e || c.data("bs.alert", e = new d(this)), "string" == typeof b && e[b].call(c)
        })
    }
    var c = '[data-dismiss="alert"]',
        d = function(b) {
            a(b).on("click", c, this.close)
        };
    d.VERSION = "3.3.4", d.TRANSITION_DURATION = 150, d.prototype.close = function(b) {
        function c() {
            g.detach().trigger("closed.bs.alert").remove()
        }
        var e = a(this),
            f = e.attr("data-target");
        f || (f = e.attr("href"), f = f && f.replace(/.*(?=#[^\s]*$)/, ""));
        var g = a(f);
        b && b.preventDefault(), g.length || (g = e.closest(".alert")), g.trigger(b = a.Event("close.bs.alert")), b.isDefaultPrevented() || (g.removeClass("in"), a.support.transition && g.hasClass("fade") ? g.one("bsTransitionEnd", c).emulateTransitionEnd(d.TRANSITION_DURATION) : c())
    };
    var e = a.fn.alert;
    a.fn.alert = b, a.fn.alert.Constructor = d, a.fn.alert.noConflict = function() {
        return a.fn.alert = e, this
    }, a(document).on("click.bs.alert.data-api", c, d.prototype.close)
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.button"),
                f = "object" == typeof b && b;
            e || d.data("bs.button", e = new c(this, f)), "toggle" == b ? e.toggle() : b && e.setState(b)
        })
    }
    var c = function(b, d) {
        this.$element = a(b), this.options = a.extend({}, c.DEFAULTS, d), this.isLoading = !1
    };
    c.VERSION = "3.3.4", c.DEFAULTS = {
        loadingText: "loading..."
    }, c.prototype.setState = function(b) {
        var c = "disabled",
            d = this.$element,
            e = d.is("input") ? "val" : "html",
            f = d.data();
        b += "Text", null == f.resetText && d.data("resetText", d[e]()), setTimeout(a.proxy(function() {
            d[e](null == f[b] ? this.options[b] : f[b]), "loadingText" == b ? (this.isLoading = !0, d.addClass(c).attr(c, c)) : this.isLoading && (this.isLoading = !1, d.removeClass(c).removeAttr(c))
        }, this), 0)
    }, c.prototype.toggle = function() {
        var a = !0,
            b = this.$element.closest('[data-toggle="buttons"]');
        if (b.length) {
            var c = this.$element.find("input");
            "radio" == c.prop("type") && (c.prop("checked") && this.$element.hasClass("active") ? a = !1 : b.find(".active").removeClass("active")), a && c.prop("checked", !this.$element.hasClass("active")).trigger("change")
        } else this.$element.attr("aria-pressed", !this.$element.hasClass("active"));
        a && this.$element.toggleClass("active")
    };
    var d = a.fn.button;
    a.fn.button = b, a.fn.button.Constructor = c, a.fn.button.noConflict = function() {
        return a.fn.button = d, this
    }, a(document).on("click.bs.button.data-api", '[data-toggle^="button"]', function(c) {
        var d = a(c.target);
        d.hasClass("btn") || (d = d.closest(".btn")), b.call(d, "toggle"), c.preventDefault()
    }).on("focus.bs.button.data-api blur.bs.button.data-api", '[data-toggle^="button"]', function(b) {
        a(b.target).closest(".btn").toggleClass("focus", /^focus(in)?$/.test(b.type))
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.carousel"),
                f = a.extend({}, c.DEFAULTS, d.data(), "object" == typeof b && b),
                g = "string" == typeof b ? b : f.slide;
            e || d.data("bs.carousel", e = new c(this, f)), "number" == typeof b ? e.to(b) : g ? e[g]() : f.interval && e.pause().cycle()
        })
    }
    var c = function(b, c) {
        this.$element = a(b), this.$indicators = this.$element.find(".carousel-indicators"), this.options = c, this.paused = null, this.sliding = null, this.interval = null, this.$active = null, this.$items = null, this.options.keyboard && this.$element.on("keydown.bs.carousel", a.proxy(this.keydown, this)), "hover" == this.options.pause && !("ontouchstart" in document.documentElement) && this.$element.on("mouseenter.bs.carousel", a.proxy(this.pause, this)).on("mouseleave.bs.carousel", a.proxy(this.cycle, this))
    };
    c.VERSION = "3.3.4", c.TRANSITION_DURATION = 600, c.DEFAULTS = {
        interval: 5e3,
        pause: "hover",
        wrap: !0,
        keyboard: !0
    }, c.prototype.keydown = function(a) {
        if (!/input|textarea/i.test(a.target.tagName)) {
            switch (a.which) {
                case 37:
                    this.prev();
                    break;
                case 39:
                    this.next();
                    break;
                default:
                    return
            }
            a.preventDefault()
        }
    }, c.prototype.cycle = function(b) {
        return b || (this.paused = !1), this.interval && clearInterval(this.interval), this.options.interval && !this.paused && (this.interval = setInterval(a.proxy(this.next, this), this.options.interval)), this
    }, c.prototype.getItemIndex = function(a) {
        return this.$items = a.parent().children(".item"), this.$items.index(a || this.$active)
    }, c.prototype.getItemForDirection = function(a, b) {
        var c = this.getItemIndex(b),
            d = "prev" == a && 0 === c || "next" == a && c == this.$items.length - 1;
        if (d && !this.options.wrap) return b;
        var e = "prev" == a ? -1 : 1,
            f = (c + e) % this.$items.length;
        return this.$items.eq(f)
    }, c.prototype.to = function(a) {
        var b = this,
            c = this.getItemIndex(this.$active = this.$element.find(".item.active"));
        return a > this.$items.length - 1 || 0 > a ? void 0 : this.sliding ? this.$element.one("slid.bs.carousel", function() {
            b.to(a)
        }) : c == a ? this.pause().cycle() : this.slide(a > c ? "next" : "prev", this.$items.eq(a))
    }, c.prototype.pause = function(b) {
        return b || (this.paused = !0), this.$element.find(".next, .prev").length && a.support.transition && (this.$element.trigger(a.support.transition.end), this.cycle(!0)), this.interval = clearInterval(this.interval), this
    }, c.prototype.next = function() {
        return this.sliding ? void 0 : this.slide("next")
    }, c.prototype.prev = function() {
        return this.sliding ? void 0 : this.slide("prev")
    }, c.prototype.slide = function(b, d) {
        var e = this.$element.find(".item.active"),
            f = d || this.getItemForDirection(b, e),
            g = this.interval,
            h = "next" == b ? "left" : "right",
            i = this;
        if (f.hasClass("active")) return this.sliding = !1;
        var j = f[0],
            k = a.Event("slide.bs.carousel", {
                relatedTarget: j,
                direction: h
            });
        if (this.$element.trigger(k), !k.isDefaultPrevented()) {
            if (this.sliding = !0, g && this.pause(), this.$indicators.length) {
                this.$indicators.find(".active").removeClass("active");
                var l = a(this.$indicators.children()[this.getItemIndex(f)]);
                l && l.addClass("active")
            }
            var m = a.Event("slid.bs.carousel", {
                relatedTarget: j,
                direction: h
            });
            return a.support.transition && this.$element.hasClass("slide") ? (f.addClass(b), f[0].offsetWidth, e.addClass(h), f.addClass(h), e.one("bsTransitionEnd", function() {
                f.removeClass([b, h].join(" ")).addClass("active"), e.removeClass(["active", h].join(" ")), i.sliding = !1, setTimeout(function() {
                    i.$element.trigger(m)
                }, 0)
            }).emulateTransitionEnd(c.TRANSITION_DURATION)) : (e.removeClass("active"), f.addClass("active"), this.sliding = !1, this.$element.trigger(m)), g && this.cycle(), this
        }
    };
    var d = a.fn.carousel;
    a.fn.carousel = b, a.fn.carousel.Constructor = c, a.fn.carousel.noConflict = function() {
        return a.fn.carousel = d, this
    };
    var e = function(c) {
        var d, e = a(this),
            f = a(e.attr("data-target") || (d = e.attr("href")) && d.replace(/.*(?=#[^\s]+$)/, ""));
        if (f.hasClass("carousel")) {
            var g = a.extend({}, f.data(), e.data()),
                h = e.attr("data-slide-to");
            h && (g.interval = !1), b.call(f, g), h && f.data("bs.carousel").to(h), c.preventDefault()
        }
    };
    a(document).on("click.bs.carousel.data-api", "[data-slide]", e).on("click.bs.carousel.data-api", "[data-slide-to]", e), a(window).on("load", function() {
        a('[data-ride="carousel"]').each(function() {
            var c = a(this);
            b.call(c, c.data())
        })
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        var c, d = b.attr("data-target") || (c = b.attr("href")) && c.replace(/.*(?=#[^\s]+$)/, "");
        return a(d)
    }

    function c(b) {
        return this.each(function() {
            var c = a(this),
                e = c.data("bs.collapse"),
                f = a.extend({}, d.DEFAULTS, c.data(), "object" == typeof b && b);
            !e && f.toggle && /show|hide/.test(b) && (f.toggle = !1), e || c.data("bs.collapse", e = new d(this, f)), "string" == typeof b && e[b]()
        })
    }
    var d = function(b, c) {
        this.$element = a(b), this.options = a.extend({}, d.DEFAULTS, c), this.$trigger = a('[data-toggle="collapse"][href="#' + b.id + '"],[data-toggle="collapse"][data-target="#' + b.id + '"]'), this.transitioning = null, this.options.parent ? this.$parent = this.getParent() : this.addAriaAndCollapsedClass(this.$element, this.$trigger), this.options.toggle && this.toggle()
    };
    d.VERSION = "3.3.4", d.TRANSITION_DURATION = 350, d.DEFAULTS = {
        toggle: !0
    }, d.prototype.dimension = function() {
        var a = this.$element.hasClass("width");
        return a ? "width" : "height"
    }, d.prototype.show = function() {
        if (!this.transitioning && !this.$element.hasClass("in")) {
            var b, e = this.$parent && this.$parent.children(".panel").children(".in, .collapsing");
            if (!(e && e.length && (b = e.data("bs.collapse"), b && b.transitioning))) {
                var f = a.Event("show.bs.collapse");
                if (this.$element.trigger(f), !f.isDefaultPrevented()) {
                    e && e.length && (c.call(e, "hide"), b || e.data("bs.collapse", null));
                    var g = this.dimension();
                    this.$element.removeClass("collapse").addClass("collapsing")[g](0).attr("aria-expanded", !0), this.$trigger.removeClass("collapsed").attr("aria-expanded", !0), this.transitioning = 1;
                    var h = function() {
                        this.$element.removeClass("collapsing").addClass("collapse in")[g](""), this.transitioning = 0, this.$element.trigger("shown.bs.collapse")
                    };
                    if (!a.support.transition) return h.call(this);
                    var i = a.camelCase(["scroll", g].join("-"));
                    this.$element.one("bsTransitionEnd", a.proxy(h, this)).emulateTransitionEnd(d.TRANSITION_DURATION)[g](this.$element[0][i])
                }
            }
        }
    }, d.prototype.hide = function() {
        if (!this.transitioning && this.$element.hasClass("in")) {
            var b = a.Event("hide.bs.collapse");
            if (this.$element.trigger(b), !b.isDefaultPrevented()) {
                var c = this.dimension();
                this.$element[c](this.$element[c]())[0].offsetHeight, this.$element.addClass("collapsing").removeClass("collapse in").attr("aria-expanded", !1), this.$trigger.addClass("collapsed").attr("aria-expanded", !1), this.transitioning = 1;
                var e = function() {
                    this.transitioning = 0, this.$element.removeClass("collapsing").addClass("collapse").trigger("hidden.bs.collapse")
                };
                return a.support.transition ? void this.$element[c](0).one("bsTransitionEnd", a.proxy(e, this)).emulateTransitionEnd(d.TRANSITION_DURATION) : e.call(this)
            }
        }
    }, d.prototype.toggle = function() {
        this[this.$element.hasClass("in") ? "hide" : "show"]()
    }, d.prototype.getParent = function() {
        return a(this.options.parent).find('[data-toggle="collapse"][data-parent="' + this.options.parent + '"]').each(a.proxy(function(c, d) {
            var e = a(d);
            this.addAriaAndCollapsedClass(b(e), e)
        }, this)).end()
    }, d.prototype.addAriaAndCollapsedClass = function(a, b) {
        var c = a.hasClass("in");
        a.attr("aria-expanded", c), b.toggleClass("collapsed", !c).attr("aria-expanded", c)
    };
    var e = a.fn.collapse;
    a.fn.collapse = c, a.fn.collapse.Constructor = d, a.fn.collapse.noConflict = function() {
        return a.fn.collapse = e, this
    }, a(document).on("click.bs.collapse.data-api", '[data-toggle="collapse"]', function(d) {
        var e = a(this);
        e.attr("data-target") || d.preventDefault();
        var f = b(e),
            g = f.data("bs.collapse"),
            h = g ? "toggle" : e.data();
        c.call(f, h)
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        b && 3 === b.which || (a(e).remove(), a(f).each(function() {
            var d = a(this),
                e = c(d),
                f = {
                    relatedTarget: this
                };
            e.hasClass("open") && (e.trigger(b = a.Event("hide.bs.dropdown", f)), b.isDefaultPrevented() || (d.attr("aria-expanded", "false"), e.removeClass("open").trigger("hidden.bs.dropdown", f)))
        }))
    }

    function c(b) {
        var c = b.attr("data-target");
        c || (c = b.attr("href"), c = c && /#[A-Za-z]/.test(c) && c.replace(/.*(?=#[^\s]*$)/, ""));
        var d = c && a(c);
        return d && d.length ? d : b.parent()
    }

    function d(b) {
        return this.each(function() {
            var c = a(this),
                d = c.data("bs.dropdown");
            d || c.data("bs.dropdown", d = new g(this)), "string" == typeof b && d[b].call(c)
        })
    }
    var e = ".dropdown-backdrop",
        f = '[data-toggle="dropdown"]',
        g = function(b) {
            a(b).on("click.bs.dropdown", this.toggle);
        };
    g.VERSION = "3.3.4", g.prototype.toggle = function(d) {
        var e = a(this);
        if (!e.is(".disabled, :disabled")) {
            var f = c(e),
                g = f.hasClass("open");
            if (b(), !g) {
                "ontouchstart" in document.documentElement && !f.closest(".navbar-nav").length && a('<div class="dropdown-backdrop"/>').insertAfter(a(this)).on("click", b);
                var h = {
                    relatedTarget: this
                };
                if (f.trigger(d = a.Event("show.bs.dropdown", h)), d.isDefaultPrevented()) return;
                e.trigger("focus").attr("aria-expanded", "true"), f.toggleClass("open").trigger("shown.bs.dropdown", h)
            }
            return !1
        }
    }, g.prototype.keydown = function(b) {
        if (/(38|40|27|32)/.test(b.which) && !/input|textarea/i.test(b.target.tagName)) {
            var d = a(this);
            if (b.preventDefault(), b.stopPropagation(), !d.is(".disabled, :disabled")) {
                var e = c(d),
                    g = e.hasClass("open");
                if (!g && 27 != b.which || g && 27 == b.which) return 27 == b.which && e.find(f).trigger("focus"), d.trigger("click");
                var h = " li:not(.disabled):visible a",
                    i = e.find('[role="menu"]' + h + ', [role="listbox"]' + h);
                if (i.length) {
                    var j = i.index(b.target);
                    38 == b.which && j > 0 && j--, 40 == b.which && j < i.length - 1 && j++, ~j || (j = 0), i.eq(j).trigger("focus")
                }
            }
        }
    };
    var h = a.fn.dropdown;
    a.fn.dropdown = d, a.fn.dropdown.Constructor = g, a.fn.dropdown.noConflict = function() {
        return a.fn.dropdown = h, this
    }, a(document).on("click.bs.dropdown.data-api", b).on("click.bs.dropdown.data-api", ".dropdown form", function(a) {
        a.stopPropagation()
    }).on("click.bs.dropdown.data-api", f, g.prototype.toggle).on("keydown.bs.dropdown.data-api", f, g.prototype.keydown).on("keydown.bs.dropdown.data-api", '[role="menu"]', g.prototype.keydown).on("keydown.bs.dropdown.data-api", '[role="listbox"]', g.prototype.keydown)
}(jQuery), + function(a) {
    "use strict";

    function b(b, d) {
        return this.each(function() {
            var e = a(this),
                f = e.data("bs.modal"),
                g = a.extend({}, c.DEFAULTS, e.data(), "object" == typeof b && b);
            f || e.data("bs.modal", f = new c(this, g)), "string" == typeof b ? f[b](d) : g.show && f.show(d)
        })
    }
    var c = function(b, c) {
        this.options = c, this.$body = a(document.body), this.$element = a(b), this.$dialog = this.$element.find(".modal-dialog"), this.$backdrop = null, this.isShown = null, this.originalBodyPad = null, this.scrollbarWidth = 0, this.ignoreBackdropClick = !1, this.options.remote && this.$element.find(".modal-content").load(this.options.remote, a.proxy(function() {
            this.$element.trigger("loaded.bs.modal")
        }, this))
    };
    c.VERSION = "3.3.4", c.TRANSITION_DURATION = 300, c.BACKDROP_TRANSITION_DURATION = 150, c.DEFAULTS = {
        backdrop: !0,
        keyboard: !0,
        show: !0
    }, c.prototype.toggle = function(a) {
        return this.isShown ? this.hide() : this.show(a)
    }, c.prototype.show = function(b) {
        var d = this,
            e = a.Event("show.bs.modal", {
                relatedTarget: b
            });
        this.$element.trigger(e), this.isShown || e.isDefaultPrevented() || (this.isShown = !0, this.checkScrollbar(), this.setScrollbar(), this.$body.addClass("modal-open"), this.escape(), this.resize(), this.$element.on("click.dismiss.bs.modal", '[data-dismiss="modal"]', a.proxy(this.hide, this)), this.$dialog.on("mousedown.dismiss.bs.modal", function() {
            d.$element.one("mouseup.dismiss.bs.modal", function(b) {
                a(b.target).is(d.$element) && (d.ignoreBackdropClick = !0)
            })
        }), this.backdrop(function() {
            var e = a.support.transition && d.$element.hasClass("fade");
            d.$element.parent().length || d.$element.appendTo(d.$body), d.$element.show().scrollTop(0), d.adjustDialog(), e && d.$element[0].offsetWidth, d.$element.addClass("in").attr("aria-hidden", !1), d.enforceFocus();
            var f = a.Event("shown.bs.modal", {
                relatedTarget: b
            });
            e ? d.$dialog.one("bsTransitionEnd", function() {
                d.$element.trigger("focus").trigger(f)
            }).emulateTransitionEnd(c.TRANSITION_DURATION) : d.$element.trigger("focus").trigger(f)
        }))
    }, c.prototype.hide = function(b) {
        b && b.preventDefault(), b = a.Event("hide.bs.modal"), this.$element.trigger(b), this.isShown && !b.isDefaultPrevented() && (this.isShown = !1, this.escape(), this.resize(), a(document).off("focusin.bs.modal"), this.$element.removeClass("in").attr("aria-hidden", !0).off("click.dismiss.bs.modal").off("mouseup.dismiss.bs.modal"), this.$dialog.off("mousedown.dismiss.bs.modal"), a.support.transition && this.$element.hasClass("fade") ? this.$element.one("bsTransitionEnd", a.proxy(this.hideModal, this)).emulateTransitionEnd(c.TRANSITION_DURATION) : this.hideModal())
    }, c.prototype.enforceFocus = function() {
        a(document).off("focusin.bs.modal").on("focusin.bs.modal", a.proxy(function(a) {
            this.$element[0] === a.target || this.$element.has(a.target).length || this.$element.trigger("focus")
        }, this))
    }, c.prototype.escape = function() {
        this.isShown && this.options.keyboard ? this.$element.on("keydown.dismiss.bs.modal", a.proxy(function(a) {
            27 == a.which && this.hide()
        }, this)) : this.isShown || this.$element.off("keydown.dismiss.bs.modal")
    }, c.prototype.resize = function() {
        this.isShown ? a(window).on("resize.bs.modal", a.proxy(this.handleUpdate, this)) : a(window).off("resize.bs.modal")
    }, c.prototype.hideModal = function() {
        var a = this;
        this.$element.hide(), this.backdrop(function() {
            a.$body.removeClass("modal-open"), a.resetAdjustments(), a.resetScrollbar(), a.$element.trigger("hidden.bs.modal")
        })
    }, c.prototype.removeBackdrop = function() {
        this.$backdrop && this.$backdrop.remove(), this.$backdrop = null
    }, c.prototype.backdrop = function(b) {
        var d = this,
            e = this.$element.hasClass("fade") ? "fade" : "";
        if (this.isShown && this.options.backdrop) {
            var f = a.support.transition && e;
            if (this.$backdrop = a('<div class="modal-backdrop ' + e + '" />').appendTo(this.$body), this.$element.on("click.dismiss.bs.modal", a.proxy(function(a) {
                    return this.ignoreBackdropClick ? void(this.ignoreBackdropClick = !1) : void(a.target === a.currentTarget && ("static" == this.options.backdrop ? this.$element[0].focus() : this.hide()))
                }, this)), f && this.$backdrop[0].offsetWidth, this.$backdrop.addClass("in"), !b) return;
            f ? this.$backdrop.one("bsTransitionEnd", b).emulateTransitionEnd(c.BACKDROP_TRANSITION_DURATION) : b()
        } else if (!this.isShown && this.$backdrop) {
            this.$backdrop.removeClass("in");
            var g = function() {
                d.removeBackdrop(), b && b()
            };
            a.support.transition && this.$element.hasClass("fade") ? this.$backdrop.one("bsTransitionEnd", g).emulateTransitionEnd(c.BACKDROP_TRANSITION_DURATION) : g()
        } else b && b()
    }, c.prototype.handleUpdate = function() {
        this.adjustDialog()
    }, c.prototype.adjustDialog = function() {
        var a = this.$element[0].scrollHeight > document.documentElement.clientHeight;
        this.$element.css({
            paddingLeft: !this.bodyIsOverflowing && a ? this.scrollbarWidth : "",
            paddingRight: this.bodyIsOverflowing && !a ? this.scrollbarWidth : ""
        })
    }, c.prototype.resetAdjustments = function() {
        this.$element.css({
            paddingLeft: "",
            paddingRight: ""
        })
    }, c.prototype.checkScrollbar = function() {
        var a = window.innerWidth;
        if (!a) {
            var b = document.documentElement.getBoundingClientRect();
            a = b.right - Math.abs(b.left)
        }
        this.bodyIsOverflowing = ((document.body.clientWidth != null && document.body.clientWidth) || 1) < a, this.scrollbarWidth = this.measureScrollbar()
    }, c.prototype.setScrollbar = function() {
        var a = parseInt(this.$body.css("padding-right") || 0, 10);
        this.originalBodyPad = document.body.style.paddingRight || "", this.bodyIsOverflowing && this.$body.css("padding-right", a + this.scrollbarWidth)
    }, c.prototype.resetScrollbar = function() {
        this.$body.css("padding-right", this.originalBodyPad)
    }, c.prototype.measureScrollbar = function() {
        var a = document.createElement("div");
        a.className = "modal-scrollbar-measure", this.$body.append(a);
        var b = a.offsetWidth - a.clientWidth;
        return this.$body[0].removeChild(a), b
    };
    var d = a.fn.modal;
    a.fn.modal = b, a.fn.modal.Constructor = c, a.fn.modal.noConflict = function() {
        return a.fn.modal = d, this
    }, a(document).on("click.bs.modal.data-api", '[data-toggle="modal"]', function(c) {
        var d = a(this),
            e = d.attr("href"),
            f = a(d.attr("data-target") || e && e.replace(/.*(?=#[^\s]+$)/, "")),
            g = f.data("bs.modal") ? "toggle" : a.extend({
                remote: !/#/.test(e) && e
            }, f.data(), d.data());
        d.is("a") && c.preventDefault(), f.one("show.bs.modal", function(a) {
            a.isDefaultPrevented() || f.one("hidden.bs.modal", function() {
                d.is(":visible") && d.trigger("focus")
            })
        }), b.call(f, g, this)
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.tooltip"),
                f = "object" == typeof b && b;
            (e || !/destroy|hide/.test(b)) && (e || d.data("bs.tooltip", e = new c(this, f)), "string" == typeof b && e[b]())
        })
    }
    var c = function(a, b) {
        this.type = null, this.options = null, this.enabled = null, this.timeout = null, this.hoverState = null, this.$element = null, this.init("tooltip", a, b)
    };
    c.VERSION = "3.3.4", c.TRANSITION_DURATION = 150, c.DEFAULTS = {
        animation: !0,
        placement: "top",
        selector: !1,
        template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
        trigger: "hover focus",
        title: "",
        delay: 0,
        html: !1,
        container: !1,
        viewport: {
            selector: "body",
            padding: 0
        }
    }, c.prototype.init = function(b, c, d) {
        if (this.enabled = !0, this.type = b, this.$element = a(c), this.options = this.getOptions(d), this.$viewport = this.options.viewport && a(this.options.viewport.selector || this.options.viewport), this.$element[0] instanceof document.constructor && !this.options.selector) throw new Error("`selector` option must be specified when initializing " + this.type + " on the window.document object!");
        for (var e = this.options.trigger.split(" "), f = e.length; f--;) {
            var g = e[f];
            if ("click" == g) this.$element.on("click." + this.type, this.options.selector, a.proxy(this.toggle, this));
            else if ("manual" != g) {
                var h = "hover" == g ? "mouseenter" : "focusin",
                    i = "hover" == g ? "mouseleave" : "focusout";
                this.$element.on(h + "." + this.type, this.options.selector, a.proxy(this.enter, this)), this.$element.on(i + "." + this.type, this.options.selector, a.proxy(this.leave, this))
            }
        }
        this.options.selector ? this._options = a.extend({}, this.options, {
            trigger: "manual",
            selector: ""
        }) : this.fixTitle()
    }, c.prototype.getDefaults = function() {
        return c.DEFAULTS
    }, c.prototype.getOptions = function(b) {
        return b = a.extend({}, this.getDefaults(), this.$element.data(), b), b.delay && "number" == typeof b.delay && (b.delay = {
            show: b.delay,
            hide: b.delay
        }), b
    }, c.prototype.getDelegateOptions = function() {
        var b = {},
            c = this.getDefaults();
        return this._options && a.each(this._options, function(a, d) {
            c[a] != d && (b[a] = d)
        }), b
    }, c.prototype.enter = function(b) {
        var c = b instanceof this.constructor ? b : a(b.currentTarget).data("bs." + this.type);
        return c && c.$tip && c.$tip.is(":visible") ? void(c.hoverState = "in") : (c || (c = new this.constructor(b.currentTarget, this.getDelegateOptions()), a(b.currentTarget).data("bs." + this.type, c)), clearTimeout(c.timeout), c.hoverState = "in", c.options.delay && c.options.delay.show ? void(c.timeout = setTimeout(function() {
            "in" == c.hoverState && c.show()
        }, c.options.delay.show)) : c.show())
    }, c.prototype.leave = function(b) {
        var c = b instanceof this.constructor ? b : a(b.currentTarget).data("bs." + this.type);
        return c || (c = new this.constructor(b.currentTarget, this.getDelegateOptions()), a(b.currentTarget).data("bs." + this.type, c)), clearTimeout(c.timeout), c.hoverState = "out", c.options.delay && c.options.delay.hide ? void(c.timeout = setTimeout(function() {
            "out" == c.hoverState && c.hide()
        }, c.options.delay.hide)) : c.hide()
    }, c.prototype.show = function() {
        var b = a.Event("show.bs." + this.type);
        if (this.hasContent() && this.enabled) {
            this.$element.trigger(b);
            var d = a.contains(this.$element[0].ownerDocument.documentElement, this.$element[0]);
            if (b.isDefaultPrevented() || !d) return;
            var e = this,
                f = this.tip(),
                g = this.getUID(this.type);
            this.setContent(), f.attr("id", g), this.$element.attr("aria-describedby", g), this.options.animation && f.addClass("fade");
            var h = "function" == typeof this.options.placement ? this.options.placement.call(this, f[0], this.$element[0]) : this.options.placement,
                i = /\s?auto?\s?/i,
                j = i.test(h);
            j && (h = h.replace(i, "") || "top"), f.detach().css({
                top: 0,
                left: 0,
                display: "block"
            }).addClass(h).data("bs." + this.type, this), this.options.container ? f.appendTo(this.options.container) : f.insertAfter(this.$element);
            var k = this.getPosition(),
                l = f[0].offsetWidth,
                m = f[0].offsetHeight;
            if (j) {
                var n = h,
                    o = this.options.container ? a(this.options.container) : this.$element.parent(),
                    p = this.getPosition(o);
                h = "bottom" == h && k.bottom + m > p.bottom ? "top" : "top" == h && k.top - m < p.top ? "bottom" : "right" == h && k.right + l > p.width ? "left" : "left" == h && k.left - l < p.left ? "right" : h, f.removeClass(n).addClass(h)
            }
            var q = this.getCalculatedOffset(h, k, l, m);
            this.applyPlacement(q, h);
            var r = function() {
                var a = e.hoverState;
                e.$element.trigger("shown.bs." + e.type), e.hoverState = null, "out" == a && e.leave(e)
            };
            a.support.transition && this.$tip.hasClass("fade") ? f.one("bsTransitionEnd", r).emulateTransitionEnd(c.TRANSITION_DURATION) : r()
        }
    }, c.prototype.applyPlacement = function(b, c) {
        var d = this.tip(),
            e = d[0].offsetWidth,
            f = d[0].offsetHeight,
            g = parseInt(d.css("margin-top"), 10),
            h = parseInt(d.css("margin-left"), 10);
        isNaN(g) && (g = 0), isNaN(h) && (h = 0), b.top = b.top + g, b.left = b.left + h, a.offset.setOffset(d[0], a.extend({
            using: function(a) {
                d.css({
                    top: Math.round(a.top),
                    left: Math.round(a.left)
                })
            }
        }, b), 0), d.addClass("in");
        var i = d[0].offsetWidth,
            j = d[0].offsetHeight;
        "top" == c && j != f && (b.top = b.top + f - j);
        var k = this.getViewportAdjustedDelta(c, b, i, j);
        k.left ? b.left += k.left : b.top += k.top;
        var l = /top|bottom/.test(c),
            m = l ? 2 * k.left - e + i : 2 * k.top - f + j,
            n = l ? "offsetWidth" : "offsetHeight";
        d.offset(b), this.replaceArrow(m, d[0][n], l)
    }, c.prototype.replaceArrow = function(a, b, c) {
        this.arrow().css(c ? "left" : "top", 50 * (1 - a / b) + "%").css(c ? "top" : "left", "")
    }, c.prototype.setContent = function() {
        var a = this.tip(),
            b = this.getTitle();
        a.find(".tooltip-inner")[this.options.html ? "html" : "text"](b), a.removeClass("fade in top bottom left right")
    }, c.prototype.hide = function(b) {
        function d() {
            "in" != e.hoverState && f.detach(), e.$element.removeAttr("aria-describedby").trigger("hidden.bs." + e.type), b && b()
        }
        var e = this,
            f = a(this.$tip),
            g = a.Event("hide.bs." + this.type);
        return this.$element.trigger(g), g.isDefaultPrevented() ? void 0 : (f.removeClass("in"), a.support.transition && f.hasClass("fade") ? f.one("bsTransitionEnd", d).emulateTransitionEnd(c.TRANSITION_DURATION) : d(), this.hoverState = null, this)
    }, c.prototype.fixTitle = function() {
        var a = this.$element;
        (a.attr("title") || "string" != typeof a.attr("data-original-title")) && a.attr("data-original-title", a.attr("title") || "").attr("title", "")
    }, c.prototype.hasContent = function() {
        return this.getTitle()
    }, c.prototype.getPosition = function(b) {
        b = b || this.$element;
        var c = b[0],
            d = "BODY" == c.tagName,
            e = c.getBoundingClientRect();
        null == e.width && (e = a.extend({}, e, {
            width: e.right - e.left,
            height: e.bottom - e.top
        }));
        var f = d ? {
                top: 0,
                left: 0
            } : b.offset(),
            g = {
                scroll: d ? document.documentElement.scrollTop || document.body.scrollTop : b.scrollTop()
            },
            h = d ? {
                width: a(window).width(),
                height: a(window).height()
            } : null;
        return a.extend({}, e, g, h, f)
    }, c.prototype.getCalculatedOffset = function(a, b, c, d) {
        return "bottom" == a ? {
            top: b.top + b.height,
            left: b.left + b.width / 2 - c / 2
        } : "top" == a ? {
            top: b.top - d,
            left: b.left + b.width / 2 - c / 2
        } : "left" == a ? {
            top: b.top + b.height / 2 - d / 2,
            left: b.left - c
        } : {
            top: b.top + b.height / 2 - d / 2,
            left: b.left + b.width
        }
    }, c.prototype.getViewportAdjustedDelta = function(a, b, c, d) {
        var e = {
            top: 0,
            left: 0
        };
        if (!this.$viewport) return e;
        var f = this.options.viewport && this.options.viewport.padding || 0,
            g = this.getPosition(this.$viewport);
        if (/right|left/.test(a)) {
            var h = b.top - f - g.scroll,
                i = b.top + f - g.scroll + d;
            h < g.top ? e.top = g.top - h : i > g.top + g.height && (e.top = g.top + g.height - i)
        } else {
            var j = b.left - f,
                k = b.left + f + c;
            j < g.left ? e.left = g.left - j : k > g.width && (e.left = g.left + g.width - k)
        }
        return e
    }, c.prototype.getTitle = function() {
        var a, b = this.$element,
            c = this.options;
        return a = b.attr("data-original-title") || ("function" == typeof c.title ? c.title.call(b[0]) : c.title)
    }, c.prototype.getUID = function(a) {
        do a += ~~(1e6 * Math.random()); while (document.getElementById(a));
        return a
    }, c.prototype.tip = function() {
        return this.$tip = this.$tip || a(this.options.template)
    }, c.prototype.arrow = function() {
        return this.$arrow = this.$arrow || this.tip().find(".tooltip-arrow")
    }, c.prototype.enable = function() {
        this.enabled = !0
    }, c.prototype.disable = function() {
        this.enabled = !1
    }, c.prototype.toggleEnabled = function() {
        this.enabled = !this.enabled
    }, c.prototype.toggle = function(b) {
        var c = this;
        b && (c = a(b.currentTarget).data("bs." + this.type), c || (c = new this.constructor(b.currentTarget, this.getDelegateOptions()), a(b.currentTarget).data("bs." + this.type, c))), c.tip().hasClass("in") ? c.leave(c) : c.enter(c)
    }, c.prototype.destroy = function() {
        var a = this;
        clearTimeout(this.timeout), this.hide(function() {
            a.$element.off("." + a.type).removeData("bs." + a.type)
        })
    };
    var d = a.fn.tooltip;
    a.fn.tooltip = b, a.fn.tooltip.Constructor = c, a.fn.tooltip.noConflict = function() {
        return a.fn.tooltip = d, this
    }
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.popover"),
                f = "object" == typeof b && b;
            (e || !/destroy|hide/.test(b)) && (e || d.data("bs.popover", e = new c(this, f)), "string" == typeof b && e[b]())
        })
    }
    var c = function(a, b) {
        this.init("popover", a, b)
    };
    if (!a.fn.tooltip) throw new Error("Popover requires tooltip.js");
    c.VERSION = "3.3.4", c.DEFAULTS = a.extend({}, a.fn.tooltip.Constructor.DEFAULTS, {
        placement: "right",
        trigger: "click",
        content: "",
        template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
    }), c.prototype = a.extend({}, a.fn.tooltip.Constructor.prototype), c.prototype.constructor = c, c.prototype.getDefaults = function() {
        return c.DEFAULTS
    }, c.prototype.setContent = function() {
        var a = this.tip(),
            b = this.getTitle(),
            c = this.getContent();
        a.find(".popover-title")[this.options.html ? "html" : "text"](b), a.find(".popover-content").children().detach().end()[this.options.html ? "string" == typeof c ? "html" : "append" : "text"](c), a.removeClass("fade top bottom left right in"), a.find(".popover-title").html() || a.find(".popover-title").hide()
    }, c.prototype.hasContent = function() {
        return this.getTitle() || this.getContent()
    }, c.prototype.getContent = function() {
        var a = this.$element,
            b = this.options;
        return a.attr("data-content") || ("function" == typeof b.content ? b.content.call(a[0]) : b.content)
    }, c.prototype.arrow = function() {
        return this.$arrow = this.$arrow || this.tip().find(".arrow")
    };
    var d = a.fn.popover;
    a.fn.popover = b, a.fn.popover.Constructor = c, a.fn.popover.noConflict = function() {
        return a.fn.popover = d, this
    }
}(jQuery), + function(a) {
    "use strict";

    function b(c, d) {
        this.$body = a(document.body), this.$scrollElement = a(a(c).is(document.body) ? window : c), this.options = a.extend({}, b.DEFAULTS, d), this.selector = (this.options.target || "") + " .nav li > a", this.offsets = [], this.targets = [], this.activeTarget = null, this.scrollHeight = 0, this.$scrollElement.on("scroll.bs.scrollspy", a.proxy(this.process, this)), this.refresh(), this.process()
    }

    function c(c) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.scrollspy"),
                f = "object" == typeof c && c;
            e || d.data("bs.scrollspy", e = new b(this, f)), "string" == typeof c && e[c]()
        })
    }
    b.VERSION = "3.3.4", b.DEFAULTS = {
        offset: 10
    }, b.prototype.getScrollHeight = function() {
        return this.$scrollElement[0].scrollHeight || Math.max(this.$body[0].scrollHeight, document.documentElement.scrollHeight)
    }, b.prototype.refresh = function() {
        var b = this,
            c = "offset",
            d = 0;
        this.offsets = [], this.targets = [], this.scrollHeight = this.getScrollHeight(), a.isWindow(this.$scrollElement[0]) || (c = "position", d = this.$scrollElement.scrollTop()), this.$body.find(this.selector).map(function() {
            var b = a(this),
                e = b.data("target") || b.attr("href"),
                f = /^#./.test(e) && a(e);
            return f && f.length && f.is(":visible") && [
                [f[c]().top + d, e]
            ] || null
        }).sort(function(a, b) {
            return a[0] - b[0]
        }).each(function() {
            b.offsets.push(this[0]), b.targets.push(this[1])
        })
    }, b.prototype.process = function() {
        var a, b = this.$scrollElement.scrollTop() + this.options.offset,
            c = this.getScrollHeight(),
            d = this.options.offset + c - this.$scrollElement.height(),
            e = this.offsets,
            f = this.targets,
            g = this.activeTarget;
        if (this.scrollHeight != c && this.refresh(), b >= d) return g != (a = f[f.length - 1]) && this.activate(a);
        if (g && b < e[0]) return this.activeTarget = null, this.clear();
        for (a = e.length; a--;) g != f[a] && b >= e[a] && (void 0 === e[a + 1] || b < e[a + 1]) && this.activate(f[a])
    }, b.prototype.activate = function(b) {
        this.activeTarget = b, this.clear();
        var c = this.selector + '[data-target="' + b + '"],' + this.selector + '[href="' + b + '"]',
            d = a(c).parents("li").addClass("active");
        d.parent(".dropdown-menu").length && (d = d.closest("li.dropdown").addClass("active")), d.trigger("activate.bs.scrollspy")
    }, b.prototype.clear = function() {
        a(this.selector).parentsUntil(this.options.target, ".active").removeClass("active")
    };
    var d = a.fn.scrollspy;
    a.fn.scrollspy = c, a.fn.scrollspy.Constructor = b, a.fn.scrollspy.noConflict = function() {
        return a.fn.scrollspy = d, this
    }, a(window).on("load.bs.scrollspy.data-api", function() {
        a('[data-spy="scroll"]').each(function() {
            var b = a(this);
            c.call(b, b.data())
        })
    })
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.tab");
            e || d.data("bs.tab", e = new c(this)), "string" == typeof b && e[b]()
        })
    }
    var c = function(b) {
        this.element = a(b)
    };
    c.VERSION = "3.3.4", c.TRANSITION_DURATION = 150, c.prototype.show = function() {
        var b = this.element,
            c = b.closest("ul:not(.dropdown-menu)"),
            d = b.data("target");
        if (d || (d = b.attr("href"), d = d && d.replace(/.*(?=#[^\s]*$)/, "")), !b.parent("li").hasClass("active")) {
            var e = c.find(".active:last a"),
                f = a.Event("hide.bs.tab", {
                    relatedTarget: b[0]
                }),
                g = a.Event("show.bs.tab", {
                    relatedTarget: e[0]
                });
            if (e.trigger(f), b.trigger(g), !g.isDefaultPrevented() && !f.isDefaultPrevented()) {
                var h = a(d);
                this.activate(b.closest("li"), c), this.activate(h, h.parent(), function() {
                    e.trigger({
                        type: "hidden.bs.tab",
                        relatedTarget: b[0]
                    }), b.trigger({
                        type: "shown.bs.tab",
                        relatedTarget: e[0]
                    })
                })
            }
        }
    }, c.prototype.activate = function(b, d, e) {
        function f() {
            g.removeClass("active").find("> .dropdown-menu > .active").removeClass("active").end().find('[data-toggle="tab"]').attr("aria-expanded", !1), b.addClass("active").find('[data-toggle="tab"]').attr("aria-expanded", !0), h ? (b[0].offsetWidth, b.addClass("in")) : b.removeClass("fade"), b.parent(".dropdown-menu").length && b.closest("li.dropdown").addClass("active").end().find('[data-toggle="tab"]').attr("aria-expanded", !0), e && e()
        }
        var g = d.find("> .active"),
            h = e && a.support.transition && (g.length && g.hasClass("fade") || !!d.find("> .fade").length);
        g.length && h ? g.one("bsTransitionEnd", f).emulateTransitionEnd(c.TRANSITION_DURATION) : f(), g.removeClass("in")
    };
    var d = a.fn.tab;
    a.fn.tab = b, a.fn.tab.Constructor = c, a.fn.tab.noConflict = function() {
        return a.fn.tab = d, this
    };
    var e = function(c) {
        c.preventDefault(), b.call(a(this), "show")
    };
    a(document).on("click.bs.tab.data-api", '[data-toggle="tab"]', e).on("click.bs.tab.data-api", '[data-toggle="pill"]', e)
}(jQuery), + function(a) {
    "use strict";

    function b(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("bs.affix"),
                f = "object" == typeof b && b;
            e || d.data("bs.affix", e = new c(this, f)), "string" == typeof b && e[b]()
        })
    }
    var c = function(b, d) {
        this.options = a.extend({}, c.DEFAULTS, d), this.$target = a(this.options.target).on("scroll.bs.affix.data-api", a.proxy(this.checkPosition, this)).on("click.bs.affix.data-api", a.proxy(this.checkPositionWithEventLoop, this)), this.$element = a(b), this.affixed = null, this.unpin = null, this.pinnedOffset = null, this.checkPosition()
    };
    c.VERSION = "3.3.4", c.RESET = "affix affix-top affix-bottom", c.DEFAULTS = {
        offset: 0,
        target: window
    }, c.prototype.getState = function(a, b, c, d) {
        var e = this.$target.scrollTop(),
            f = this.$element.offset(),
            g = this.$target.height();
        if (null != c && "top" == this.affixed) return c > e ? "top" : !1;
        if ("bottom" == this.affixed) return null != c ? e + this.unpin <= f.top ? !1 : "bottom" : a - d >= e + g ? !1 : "bottom";
        var h = null == this.affixed,
            i = h ? e : f.top,
            j = h ? g : b;
        return null != c && c >= e ? "top" : null != d && i + j >= a - d ? "bottom" : !1
    }, c.prototype.getPinnedOffset = function() {
        if (this.pinnedOffset) return this.pinnedOffset;
        this.$element.removeClass(c.RESET).addClass("affix");
        var a = this.$target.scrollTop(),
            b = this.$element.offset();
        return this.pinnedOffset = b.top - a
    }, c.prototype.checkPositionWithEventLoop = function() {
        setTimeout(a.proxy(this.checkPosition, this), 1)
    }, c.prototype.checkPosition = function() {
        if (this.$element.is(":visible")) {
            var b = this.$element.height(),
                d = this.options.offset,
                e = d.top,
                f = d.bottom,
                g = a(document.body).height();
            "object" != typeof d && (f = e = d), "function" == typeof e && (e = d.top(this.$element)), "function" == typeof f && (f = d.bottom(this.$element));
            var h = this.getState(g, b, e, f);
            if (this.affixed != h) {
                null != this.unpin && this.$element.css("top", "");
                var i = "affix" + (h ? "-" + h : ""),
                    j = a.Event(i + ".bs.affix");
                if (this.$element.trigger(j), j.isDefaultPrevented()) return;
                this.affixed = h, this.unpin = "bottom" == h ? this.getPinnedOffset() : null, this.$element.removeClass(c.RESET).addClass(i).trigger(i.replace("affix", "affixed") + ".bs.affix")
            }
            "bottom" == h && this.$element.offset({
                top: g - b - f
            })
        }
    };
    var d = a.fn.affix;
    a.fn.affix = b, a.fn.affix.Constructor = c, a.fn.affix.noConflict = function() {
        return a.fn.affix = d, this
    }, a(window).on("load", function() {
        a('[data-spy="affix"]').each(function() {
            var c = a(this),
                d = c.data();
            d.offset = d.offset || {}, null != d.offsetBottom && (d.offset.bottom = d.offsetBottom), null != d.offsetTop && (d.offset.top = d.offsetTop), b.call(c, d)
        })
    })
}(jQuery),
function(a) {
    a.fn.extend({
        slimScroll: function(b) {
            var c = a.extend({
                width: "auto",
                height: "250px",
                size: "7px",
                color: "#000",
                position: "right",
                distance: "1px",
                start: "top",
                opacity: .4,
                alwaysVisible: !1,
                disableFadeOut: !1,
                railVisible: !1,
                railColor: "#333",
                railOpacity: .2,
                railDraggable: !0,
                railClass: "slimScrollRail",
                barClass: "slimScrollBar",
                wrapperClass: "slimScrollDiv",
                allowPageScroll: !1,
                wheelStep: 20,
                touchScrollStep: 200,
                borderRadius: "7px",
                railBorderRadius: "7px"
            }, b);
            return this.each(function() {
                function d(b) {
                    if (j) {
                        b = b || window.event;
                        var d = 0;
                        b.wheelDelta && (d = -b.wheelDelta / 120), b.detail && (d = b.detail / 3), a(b.target || b.srcTarget || b.srcElement).closest("." + c.wrapperClass).is(s.parent()) && e(d, !0), b.preventDefault && !r && b.preventDefault(), r || (b.returnValue = !1)
                    }
                }

                function e(a, b, d) {
                    r = !1;
                    var e = a,
                        f = s.outerHeight() - v.outerHeight();
                    b && (e = parseInt(v.css("top")) + a * parseInt(c.wheelStep) / 100 * v.outerHeight(), e = Math.min(Math.max(e, 0), f), e = a > 0 ? Math.ceil(e) : Math.floor(e), v.css({
                        top: e + "px"
                    })), p = parseInt(v.css("top")) / (s.outerHeight() - v.outerHeight()), e = p * (s[0].scrollHeight - s.outerHeight()), d && (e = a, a = e / s[0].scrollHeight * s.outerHeight(), a = Math.min(Math.max(a, 0), f), v.css({
                        top: a + "px"
                    })), s.scrollTop(e), s.trigger("slimscrolling", ~~e), h(), i()
                }

                function f() {
                    window.addEventListener ? (this.addEventListener("DOMMouseScroll", d, !1), this.addEventListener("mousewheel", d, !1)) : document.attachEvent("onmousewheel", d)
                }

                function g() {
                    o = Math.max(s.outerHeight() / s[0].scrollHeight * s.outerHeight(), 30), v.css({
                        height: o + "px"
                    });
                    var a = o == s.outerHeight() ? "none" : "block";
                    v.css({
                        display: a
                    })
                }

                function h() {
                    g(), clearTimeout(m), p == ~~p ? (r = c.allowPageScroll, q != p && s.trigger("slimscroll", 0 == ~~p ? "top" : "bottom")) : r = !1, q = p, o >= s.outerHeight() ? r = !0 : (v.stop(!0, !0).fadeIn("fast"), c.railVisible && w.stop(!0, !0).fadeIn("fast"))
                }

                function i() {
                    c.alwaysVisible || (m = setTimeout(function() {
                        c.disableFadeOut && j || k || l || (v.fadeOut("slow"), w.fadeOut("slow"))
                    }, 1e3))
                }
                var j, k, l, m, n, o, p, q, r = !1,
                    s = a(this);
                if (s.parent().hasClass(c.wrapperClass)) {
                    var u = s.scrollTop(),
                        v = s.parent().find("." + c.barClass),
                        w = s.parent().find("." + c.railClass);
                    if (g(), a.isPlainObject(b)) {
                        if ("height" in b && "auto" == b.height) {
                            s.parent().css("height", "auto"), s.css("height", "auto");
                            var x = s.parent().parent().height();
                            s.parent().css("height", x), s.css("height", x)
                        }
                        if ("scrollTo" in b) u = parseInt(c.scrollTo);
                        else if ("scrollBy" in b) u += parseInt(c.scrollBy);
                        else if ("destroy" in b) return v.remove(), w.remove(), void s.unwrap();
                        e(u, !1, !0)
                    }
                } else if (!(a.isPlainObject(b) && "destroy" in b)) {
                    c.height = "auto" == c.height ? s.parent().height() : c.height, u = a("<div></div>").addClass(c.wrapperClass).css({
                        position: "relative",
                        overflow: "hidden",
                        width: c.width,
                        height: c.height
                    }), s.css({
                        overflow: "hidden",
                        width: c.width,
                        height: c.height
                    });
                    var w = a("<div></div>").addClass(c.railClass).css({
                            width: c.size,
                            height: "100%",
                            position: "absolute",
                            top: 0,
                            display: c.alwaysVisible && c.railVisible ? "block" : "none",
                            "border-radius": c.railBorderRadius,
                            background: c.railColor,
                            opacity: c.railOpacity,
                            zIndex: 90
                        }),
                        v = a("<div></div>").addClass(c.barClass).css({
                            background: c.color,
                            width: c.size,
                            position: "absolute",
                            top: 0,
                            opacity: c.opacity,
                            display: c.alwaysVisible ? "block" : "none",
                            "border-radius": c.borderRadius,
                            BorderRadius: c.borderRadius,
                            MozBorderRadius: c.borderRadius,
                            WebkitBorderRadius: c.borderRadius,
                            zIndex: 99
                        }),
                        x = "right" == c.position ? {
                            right: c.distance
                        } : {
                            left: c.distance
                        };
                    w.css(x), v.css(x), s.wrap(u), s.parent().append(v), s.parent().append(w), c.railDraggable && v.bind("mousedown", function(b) {
                        var c = a(document);
                        return l = !0, t = parseFloat(v.css("top")), pageY = b.pageY, c.bind("mousemove.slimscroll", function(a) {
                            currTop = t + a.pageY - pageY, v.css("top", currTop), e(0, v.position().top, !1)
                        }), c.bind("mouseup.slimscroll", function(a) {
                            l = !1, i(), c.unbind(".slimscroll")
                        }), !1
                    }).bind("selectstart.slimscroll", function(a) {
                        return a.stopPropagation(), a.preventDefault(), !1
                    }), w.hover(function() {
                        h()
                    }, function() {
                        i()
                    }), v.hover(function() {
                        k = !0
                    }, function() {
                        k = !1
                    }), s.hover(function() {
                        j = !0, h(), i()
                    }, function() {
                        j = !1, i()
                    }), s.bind("touchstart", function(a, b) {
                        a.originalEvent.touches.length && (n = a.originalEvent.touches[0].pageY)
                    }), s.bind("touchmove", function(a) {
                        r || a.originalEvent.preventDefault(), a.originalEvent.touches.length && (e((n - a.originalEvent.touches[0].pageY) / c.touchScrollStep, !0), n = a.originalEvent.touches[0].pageY)
                    }), g(), "bottom" === c.start ? (v.css({
                        top: s.outerHeight() - v.outerHeight()
                    }), e(0, !0)) : "top" !== c.start && (e(a(c.start).position().top, null, !0), c.alwaysVisible || v.hide()), f()
                }
            }), this
        }
    }), a.fn.extend({
        slimscroll: a.fn.slimScroll
    })
}(jQuery),
function(a) {
    "function" == typeof define && define.amd ? define(["jquery"], a) : a(jQuery)
}(function(a) {
    function b(a) {
        var b = a.prop("clientWidth"),
            c = a.prop("offsetWidth"),
            d = parseInt(a.css("border-right-width"), 10),
            e = parseInt(a.css("border-left-width"), 10);
        return c > b + e + d
    }
    var c = "onmousewheel" in window ? "ActiveXObject" in window ? "wheel" : "mousewheel" : "DOMMouseScroll",
        d = ".scrollLock",
        e = a.fn.scrollLock;
    a.fn.scrollLock = function(e, f, g) {
        return "string" != typeof f && (f = null), void 0 !== e && !e || "off" === e ? this.each(function() {
            a(this).off(d)
        }) : this.each(function() {
            a(this).on(c + d, f, function(c) {
                var d, e;
                if (!c.ctrlKey && (d = a(this), g === !0 || b(d))) {
                    c.stopPropagation();
                    var f = d.scrollTop(),
                        h = d.prop("scrollHeight"),
                        i = d.prop("clientHeight"),
                        j = c.originalEvent.wheelDelta || -1 * c.originalEvent.detail || -1 * c.originalEvent.deltaY,
                        k = 0;
                    "wheel" === c.type && (e = d.height() / a(window).height(), k = c.originalEvent.deltaY * e), (j > 0 && 0 >= f + k || 0 > j && f + k >= h - i) && (c.preventDefault(), k && d.scrollTop(f + k))
                }
            })
        })
    }, a.fn.scrollLock.noConflict = function() {
        return a.fn.scrollLock = e, this
    }
}), ! function(a) {
    a.fn.appear = function(b, c) {
        var d = a.extend({
            data: void 0,
            one: !0,
            accX: 0,
            accY: 0
        }, c);
        return this.each(function() {
            var c = a(this);
            if (c.appeared = !1, !b) return void c.trigger("appear", d.data);
            var e = a(window),
                f = function() {
                    if (!c.is(":visible")) return void(c.appeared = !1);
                    var a = e.scrollLeft(),
                        b = e.scrollTop(),
                        f = c.offset(),
                        g = f.left,
                        h = f.top,
                        i = d.accX,
                        j = d.accY,
                        k = c.height(),
                        l = e.height(),
                        m = c.width(),
                        n = e.width();
                    h + k + j >= b && b + l + j >= h && g + m + i >= a && a + n + i >= g ? c.appeared || c.trigger("appear", d.data) : c.appeared = !1
                },
                g = function() {
                    if (c.appeared = !0, d.one) {
                        e.unbind("scroll", f);
                        var g = a.inArray(f, a.fn.appear.checks);
                        g >= 0 && a.fn.appear.checks.splice(g, 1)
                    }
                    b.apply(this, arguments)
                };
            d.one ? c.one("appear", d.data, g) : c.bind("appear", d.data, g), e.scroll(f), a.fn.appear.checks.push(f), f()
        })
    }, a.extend(a.fn.appear, {
        checks: [],
        timeout: null,
        checkAll: function() {
            var b = a.fn.appear.checks.length;
            if (b > 0)
                for (; b--;) a.fn.appear.checks[b]()
        },
        run: function() {
            a.fn.appear.timeout && clearTimeout(a.fn.appear.timeout), a.fn.appear.timeout = setTimeout(a.fn.appear.checkAll, 20)
        }
    }), a.each(["append", "prepend", "after", "before", "attr", "removeAttr", "addClass", "removeClass", "toggleClass", "remove", "css", "show", "hide"], function(b, c) {
        var d = a.fn[c];
        d && (a.fn[c] = function() {
            var b = d.apply(this, arguments);
            return a.fn.appear.run(), b
        })
    })
}(jQuery), ! function(a) {
    function b(a, b) {
        return a.toFixed(b.decimals)
    }
    var c = function(b, d) {
        this.$element = a(b), this.options = a.extend({}, c.DEFAULTS, this.dataOptions(), d), this.init()
    };
    c.DEFAULTS = {
        from: 0,
        to: 0,
        speed: 1e3,
        refreshInterval: 100,
        decimals: 0,
        formatter: b,
        onUpdate: null,
        onComplete: null
    }, c.prototype.init = function() {
        this.value = this.options.from, this.loops = Math.ceil(this.options.speed / this.options.refreshInterval), this.loopCount = 0, this.increment = (this.options.to - this.options.from) / this.loops
    }, c.prototype.dataOptions = function() {
        var a = {
                from: this.$element.data("from"),
                to: this.$element.data("to"),
                speed: this.$element.data("speed"),
                refreshInterval: this.$element.data("refresh-interval"),
                decimals: this.$element.data("decimals")
            },
            b = Object.keys(a);
        for (var c in b) {
            var d = b[c];
            "undefined" == typeof a[d] && delete a[d]
        }
        return a
    }, c.prototype.update = function() {
        this.value += this.increment, this.loopCount++, this.render(), "function" == typeof this.options.onUpdate && this.options.onUpdate.call(this.$element, this.value), this.loopCount >= this.loops && (clearInterval(this.interval), this.value = this.options.to, "function" == typeof this.options.onComplete && this.options.onComplete.call(this.$element, this.value))
    }, c.prototype.render = function() {
        var a = this.options.formatter.call(this.$element, this.value, this.options);
        this.$element.text(a);
    }, c.prototype.restart = function() {
        this.stop(), this.init(), this.start()
    }, c.prototype.start = function() {
        this.stop(), this.render(), this.interval = setInterval(this.update.bind(this), this.options.refreshInterval)
    }, c.prototype.stop = function() {
        this.interval && clearInterval(this.interval)
    }, c.prototype.toggle = function() {
        this.interval ? this.stop() : this.start()
    }, a.fn.countTo = function(b) {
        return this.each(function() {
            var d = a(this),
                e = d.data("countTo"),
                f = !e || "object" == typeof b,
                g = "object" == typeof b ? b : {},
                h = "string" == typeof b ? b : "start";
            f && (e && e.stop(), d.data("countTo", e = new c(this, g))), e[h].call(e)
        })
    }
}(jQuery), ! function(a) {
    "function" == typeof define && define.amd ? define(["jquery"], a) : a(jQuery)
}(function(a) {
    function b(b) {
        var c = {},
            d = /^jQuery\d+$/;
        return a.each(b.attributes, function(a, b) {
            b.specified && !d.test(b.name) && (c[b.name] = b.value)
        }), c
    }

    function c(b, c) {
        var d = this,
            f = a(d);
        if (d.value == f.attr("placeholder") && f.hasClass(m.customClass))
            if (f.data("placeholder-password")) {
                if (f = f.hide().nextAll('input[type="password"]:first').show().attr("id", f.removeAttr("id").data("placeholder-id")), b === !0) return f[0].value = c;
                f.focus()
            } else d.value = "", f.removeClass(m.customClass), d == e() && d.select()
    }

    function d() {
        var d, e = this,
            f = a(e),
            g = this.id;
        if ("" === e.value) {
            if ("password" === e.type) {
                if (!f.data("placeholder-textinput")) {
                    try {
                        d = f.clone().attr({
                            type: "text"
                        })
                    } catch (h) {
                        d = a("<input>").attr(a.extend(b(this), {
                            type: "text"
                        }))
                    }
                    d.removeAttr("name").data({
                        "placeholder-password": f,
                        "placeholder-id": g
                    }).bind("focus.placeholder", c), f.data({
                        "placeholder-textinput": d,
                        "placeholder-id": g
                    }).before(d)
                }
                f = f.removeAttr("id").hide().prevAll('input[type="text"]:first').attr("id", g).show()
            }
            f.addClass(m.customClass), f[0].value = f.attr("placeholder")
        } else f.removeClass(m.customClass)
    }

    function e() {
        try {
            return document.activeElement
        } catch (a) {}
    }
    var f, g, h = "[object OperaMini]" == Object.prototype.toString.call(window.operamini),
        i = "placeholder" in document.createElement("input") && !h,
        j = "placeholder" in document.createElement("textarea") && !h,
        k = a.valHooks,
        l = a.propHooks;
    if (i && j) g = a.fn.placeholder = function() {
        return this
    }, g.input = g.textarea = !0;
    else {
        var m = {};
        g = a.fn.placeholder = function(b) {
            var e = {
                customClass: "placeholder"
            };
            m = a.extend({}, e, b);
            var f = this;
            return f.filter((i ? "textarea" : ":input") + "[placeholder]").not("." + m.customClass).bind({
                "focus.placeholder": c,
                "blur.placeholder": d
            }).data("placeholder-enabled", !0).trigger("blur.placeholder"), f
        }, g.input = i, g.textarea = j, f = {
            get: function(b) {
                var c = a(b),
                    d = c.data("placeholder-password");
                return d ? d[0].value : c.data("placeholder-enabled") && c.hasClass(m.customClass) ? "" : b.value
            },
            set: function(b, f) {
                var g = a(b),
                    h = g.data("placeholder-password");
                return h ? h[0].value = f : g.data("placeholder-enabled") ? ("" === f ? (b.value = f, b != e() && d.call(b)) : g.hasClass(m.customClass) ? c.call(b, !0, f) || (b.value = f) : b.value = f, g) : b.value = f
            }
        }, i || (k.input = f, l.value = f), j || (k.textarea = f, l.value = f), a(function() {
            a(document).delegate("form", "submit.placeholder", function() {
                var b = a("." + m.customClass, this).each(c);
                setTimeout(function() {
                    b.each(d)
                }, 10)
            })
        }), a(window).bind("beforeunload.placeholder", function() {
            a("." + m.customClass).each(function() {
                this.value = ""
            })
        })
    }
}), ! function(a) {
    if ("function" == typeof define && define.amd) define(a);
    else if ("object" == typeof exports) module.exports = a();
    else {
        var b = window.Cookies,
            c = window.Cookies = a(window.jQuery);
        c.noConflict = function() {
            return window.Cookies = b, c
        }
    }
}(function() {
    function a() {
        for (var a = 0, b = {}; a < arguments.length; a++) {
            var c = arguments[a];
            for (var d in c) b[d] = c[d]
        }
        return b
    }

    function b(c) {
        function d(b, e, f) {
            var g;
            if (arguments.length > 1) {
                if (f = a({
                        path: "/"
                    }, d.defaults, f), "number" == typeof f.expires) {
                    var h = new Date;
                    h.setMilliseconds(h.getMilliseconds() + 864e5 * f.expires), f.expires = h
                }
                try {
                    g = JSON.stringify(e), /^[\{\[]/.test(g) && (e = g)
                } catch (i) {}
                return e = encodeURIComponent(String(e)), e = e.replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent), b = encodeURIComponent(String(b)), b = b.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent), b = b.replace(/[\(\)]/g, escape), document.cookie = [b, "=", e, f.expires && "; expires=" + f.expires.toUTCString(), f.path && "; path=" + f.path, f.domain && "; domain=" + f.domain, f.secure ? "; secure" : ""].join("")
            }
            b || (g = {});
            for (var j = document.cookie ? document.cookie.split("; ") : [], k = /(%[0-9A-Z]{2})+/g, l = 0; l < j.length; l++) {
                var m = j[l].split("="),
                    n = m[0].replace(k, decodeURIComponent),
                    o = m.slice(1).join("=");
                '"' === o.charAt(0) && (o = o.slice(1, -1));
                try {
                    if (o = c && c(o, n) || o.replace(k, decodeURIComponent), this.json) try {
                        o = JSON.parse(o)
                    } catch (i) {}
                    if (b === n) {
                        g = o;
                        break
                    }
                    b || (g[n] = o)
                } catch (i) {}
            }
            return g
        }
        return d.get = d.set = d, d.getJSON = function() {
            return d.apply({
                json: !0
            }, [].slice.call(arguments))
        }, d.defaults = {}, d.remove = function(b, c) {
            d(b, "", a(c, {
                expires: -1
            }))
        }, d.withConverter = b, d
    }
    return b()
});
var App = function() {
        var a, b, c, d, e, f, g, h, i, j, k = function() {
                a = jQuery("html"), b = jQuery("body"), c = jQuery("#page-container"), d = jQuery("#sidebar"), e = jQuery("#sidebar-scroll"), f = jQuery("#side-overlay"), g = jQuery("#side-overlay-scroll"), h = jQuery("#header-navbar"), i = jQuery("#main-container-nullified"), j = jQuery("#page-footer"), jQuery('[data-toggle="tooltip"], .js-tooltip').tooltip({
                    container: "body",
                    animation: !1
                }), jQuery('[data-toggle="popover"], .js-popover').popover({
                    container: "body",
                    animation: !0,
                    trigger: "hover"
                }), jQuery('[data-toggle="tabs"] a, .js-tabs a').click(function(a) {
                    a.preventDefault(), jQuery(this).tab("show")
                }), jQuery(".form-control").placeholder()
            },
            l = function() {
                var b;
                i.length && (m(), jQuery(window).on("resize orientationchange", function() {
                    clearTimeout(b), b = setTimeout(function() {
                        m()
                    }, 150)
                })), n("init"), c.hasClass("header-navbar-fixed") && c.hasClass("header-navbar-transparent") && jQuery(window).on("scroll", function() {
                    jQuery(this).scrollTop() > 20 ? c.addClass("header-navbar-scroll") : c.removeClass("header-navbar-scroll")
                }), jQuery('[data-toggle="layout"]').on("click", function() {
                    var b = jQuery(this);
                    o(b.data("action")), a.hasClass("no-focus") && b.blur()
                })
            },
            m = function() {
                var a = jQuery(window).height(),
                    b = h.outerHeight(),
                    d = j.outerHeight();
                c.hasClass("header-navbar-fixed") ? i.css("min-height", a - d) : i.css("min-height", a - (b + d))
            },
            n = function(a) {
                var b = window.innerWidth || document.documentElement.clientWidth || (document.body.clientWidth != null && document.body.clientWidth) || 1 ;
                if ("init" === a) {
                    n();
                    var h;
                    jQuery(window).on("resize orientationchange", function() {
                        clearTimeout(h), h = setTimeout(function() {
                            n()
                        }, 150)
                    })
                } else b > 991 && c.hasClass("side-scroll") ? (jQuery(d).scrollLock("off"), jQuery(f).scrollLock("off"), e.length && !e.parent(".slimScrollDiv").length ? e.slimScroll({
                    height: d.outerHeight(),
                    color: "#fff",
                    size: "5px",
                    opacity: .35,
                    wheelStep: 15,
                    distance: "2px",
                    railVisible: !1,
                    railOpacity: 1
                }) : e.add(e.parent()).css("height", d.outerHeight()), g.length && !g.parent(".slimScrollDiv").length ? g.slimScroll({
                    height: f.outerHeight(),
                    color: "#000",
                    size: "5px",
                    opacity: .35,
                    wheelStep: 15,
                    distance: "2px",
                    railVisible: !1,
                    railOpacity: 1
                }) : g.add(g.parent()).css("height", f.outerHeight())) : (jQuery(d).scrollLock(), jQuery(f).scrollLock(), e.length && e.parent(".slimScrollDiv").length && (e.slimScroll({
                    destroy: !0
                }), e.attr("style", "")), g.length && g.parent(".slimScrollDiv").length && (g.slimScroll({
                    destroy: !0
                }), g.attr("style", "")))
            },
            o = function(a) {
                var b = window.innerWidth || document.documentElement.clientWidth || (document.body.clientWidth != null && document.body.clientWidth) || 1;
                switch (a) {
                    case "sidebar_pos_toggle":
                        c.toggleClass("sidebar-l sidebar-r");
                        break;
                    case "sidebar_pos_left":
                        c.removeClass("sidebar-r").addClass("sidebar-l");
                        break;
                    case "sidebar_pos_right":
                        c.removeClass("sidebar-l").addClass("sidebar-r");
                        break;
                    case "sidebar_toggle":
                        b > 991 ? c.toggleClass("sidebar-o") : c.toggleClass("sidebar-o-xs");
                        break;
                    case "sidebar_open":
                        b > 991 ? c.addClass("sidebar-o") : c.addClass("sidebar-o-xs");
                        break;
                    case "sidebar_close":
                        b > 991 ? c.removeClass("sidebar-o") : c.removeClass("sidebar-o-xs");
                        break;
                    case "sidebar_mini_toggle":
                        b > 991 && c.toggleClass("sidebar-mini");
                        break;
                    case "sidebar_mini_on":
                        b > 991 && c.addClass("sidebar-mini");
                        break;
                    case "sidebar_mini_off":
                        b > 991 && c.removeClass("sidebar-mini");
                        break;
                    case "side_overlay_toggle":
                        c.toggleClass("side-overlay-o");
                        break;
                    case "side_overlay_open":
                        c.addClass("side-overlay-o");
                        break;
                    case "side_overlay_close":
                        c.removeClass("side-overlay-o");
                        break;
                    case "side_overlay_hoverable_toggle":
                        c.toggleClass("side-overlay-hover");
                        break;
                    case "side_overlay_hoverable_on":
                        c.addClass("side-overlay-hover");
                        break;
                    case "side_overlay_hoverable_off":
                        c.removeClass("side-overlay-hover");
                        break;
                    case "header_fixed_toggle":
                        c.toggleClass("header-navbar-fixed");
                        break;
                    case "header_fixed_on":
                        c.addClass("header-navbar-fixed");
                        break;
                    case "header_fixed_off":
                        c.removeClass("header-navbar-fixed");
                        break;
                    case "side_scroll_toggle":
                        c.toggleClass("side-scroll"), n();
                        break;
                    case "side_scroll_on":
                        c.addClass("side-scroll"), n();
                        break;
                    case "side_scroll_off":
                        c.removeClass("side-scroll"), n();
                        break;
                    default:
                        return !1
                }
            },
            p = function() {
                jQuery('[data-toggle="nav-submenu"]').on("click", function(b) {
                    var c = jQuery(this),
                        d = c.parent("li");
                    return d.hasClass("open") ? d.removeClass("open") : (c.closest("ul").find("> li").removeClass("open"), d.addClass("open")), a.hasClass("no-focus") && c.blur(), !1
                })
            },
            q = function() {
                r(!1, "init"), jQuery('[data-toggle="block-option"]').on("click", function() {
                    r(jQuery(this).parents(".block"), jQuery(this).data("action"))
                })
            },
            r = function(a, b) {
                var c = "si si-size-fullscreen",
                    d = "si si-size-actual",
                    e = "si si-arrow-up",
                    f = "si si-arrow-down";
                if ("init" === b) jQuery('[data-toggle="block-option"][data-action="fullscreen_toggle"]').each(function() {
                    var a = jQuery(this);
                    a.html('<i class="' + (jQuery(this).closest(".block").hasClass("block-opt-fullscreen") ? d : c) + '"></i>')
                }), jQuery('[data-toggle="block-option"][data-action="content_toggle"]').each(function() {
                    var a = jQuery(this);
                    a.html('<i class="' + (a.closest(".block").hasClass("block-opt-hidden") ? f : e) + '"></i>')
                });
                else {
                    var g = a instanceof jQuery ? a : jQuery(a);
                    if (g.length) {
                        var h = jQuery('[data-toggle="block-option"][data-action="fullscreen_toggle"]', g),
                            i = jQuery('[data-toggle="block-option"][data-action="content_toggle"]', g);
                        switch (b) {
                            case "fullscreen_toggle":
                                g.toggleClass("block-opt-fullscreen"), g.hasClass("block-opt-fullscreen") ? jQuery(g).scrollLock() : jQuery(g).scrollLock("off"), h.length && (g.hasClass("block-opt-fullscreen") ? jQuery("i", h).removeClass(c).addClass(d) : jQuery("i", h).removeClass(d).addClass(c));
                                break;
                            case "fullscreen_on":
                                g.addClass("block-opt-fullscreen"), jQuery(g).scrollLock(), h.length && jQuery("i", h).removeClass(c).addClass(d);
                                break;
                            case "fullscreen_off":
                                g.removeClass("block-opt-fullscreen"), jQuery(g).scrollLock("off"), h.length && jQuery("i", h).removeClass(d).addClass(c);
                                break;
                            case "content_toggle":
                                g.toggleClass("block-opt-hidden"), i.length && (g.hasClass("block-opt-hidden") ? jQuery("i", i).removeClass(e).addClass(f) : jQuery("i", i).removeClass(f).addClass(e));
                                break;
                            case "content_hide":
                                g.addClass("block-opt-hidden"), i.length && jQuery("i", i).removeClass(e).addClass(f);
                                break;
                            case "content_show":
                                g.removeClass("block-opt-hidden"), i.length && jQuery("i", i).removeClass(f).addClass(e);
                                break;
                            case "refresh_toggle":
                                g.toggleClass("block-opt-refresh"), jQuery('[data-toggle="block-option"][data-action="refresh_toggle"][data-action-mode="demo"]', g).length && setTimeout(function() {
                                    g.removeClass("block-opt-refresh")
                                }, 2e3);
                                break;
                            case "state_loading":
                                g.addClass("block-opt-refresh");
                                break;
                            case "state_normal":
                                g.removeClass("block-opt-refresh");
                                break;
                            case "close":
                                g.hide();
                                break;
                            case "open":
                                g.show();
                                break;
                            default:
                                return !1
                        }
                    }
                }
            },
            s = function() {
                jQuery(".form-material.floating > .form-control").each(function() {
                    var a = jQuery(this),
                        b = a.parent(".form-material");
                    a.val() && b.addClass("open"), a.on("change", function() {
                        a.val() ? b.addClass("open") : b.removeClass("open")
                    })
                })
            },
            t = function() {
                var a = jQuery("#css-theme"),
                    b = c.hasClass("enable-cookies") ? !0 : !1;
                if (b) {
                    var d = Cookies.get("colorTheme") ? Cookies.get("colorTheme") : !1;
                    d && ("default" === d ? a.length && a.remove() : a.length ? a.attr("href", d) : jQuery("#css-main").after('<link rel="stylesheet" id="css-theme" href="' + d + '">')), a = jQuery("#css-theme")
                }
                jQuery('[data-toggle="theme"][data-theme="' + (a.length ? a.attr("href") : "default") + '"]').parent("li").addClass("active"), jQuery('[data-toggle="theme"]').on("click", function() {
                    var c = jQuery(this),
                        d = c.data("theme");
                    jQuery('[data-toggle="theme"]').parent("li").removeClass("active"), jQuery('[data-toggle="theme"][data-theme="' + d + '"]').parent("li").addClass("active"), "default" === d ? a.length && a.remove() : a.length ? a.attr("href", d) : jQuery("#css-main").after('<link rel="stylesheet" id="css-theme" href="' + d + '">'), a = jQuery("#css-theme"), b && Cookies.set("colorTheme", d, {
                        expires: 7
                    })
                })
            },
            u = function() {
                jQuery('[data-toggle="scroll-to"]').on("click", function() {
                    var a = jQuery(this),
                        b = a.data("target"),
                        c = a.data("speed") ? a.data("speed") : 1e3;
                    jQuery("html, body").animate({
                        scrollTop: jQuery(b).offset().top
                    }, c)
                })
            },
            v = function() {
                jQuery('[data-toggle="class-toggle"]').on("click", function() {
                    var b = jQuery(this);
                    jQuery(b.data("target").toString()).toggleClass(b.data("class").toString()), a.hasClass("no-focus") && b.blur()
                })
            },
            w = function() {
                var a = new Date,
                    b = jQuery(".js-year-copy");
                2015 === a.getFullYear() ? b.html("2015") : b.html("2015-" + a.getFullYear().toString().substr(2, 2))
            },
            x = function() {
                var a = c.prop("class");
                c.prop("class", ""), window.print(), c.prop("class", a)
            },
            y = function() {
                var a = jQuery(".js-table-sections"),
                    b = jQuery(".js-table-sections-header > tr", a);
                b.click(function(b) {
                    var c = jQuery(this),
                        d = c.parent("tbody");
                    d.hasClass("open") || jQuery("tbody", a).removeClass("open"), d.toggleClass("open")
                })
            },
            z = function() {
                var a = jQuery(".js-table-checkable");
                jQuery("thead input:checkbox", a).click(function() {
                    var b = jQuery(this).prop("checked");
                    jQuery("tbody input:checkbox", a).each(function() {
                        var a = jQuery(this);
                        a.prop("checked", b), A(a, b)
                    })
                }), jQuery("tbody input:checkbox", a).click(function() {
                    var a = jQuery(this);
                    A(a, a.prop("checked"))
                }), jQuery("tbody > tr", a).click(function(a) {
                    if ("checkbox" !== a.target.type && "button" !== a.target.type && "a" !== a.target.tagName.toLowerCase() && !jQuery(a.target).parent("label").length) {
                        var b = jQuery("input:checkbox", this),
                            c = b.prop("checked");
                        b.prop("checked", !c), A(b, !c)
                    }
                })
            },
            A = function(a, b) {
                b ? a.closest("tr").addClass("active") : a.closest("tr").removeClass("active")
            },
            B = function() {
                jQuery('[data-toggle="appear"]').each(function() {
                    var b = window.innerWidth || document.documentElement.clientWidth || (document.body.clientWidth != null && document.body.clientWidth) || 1,
                        c = jQuery(this),
                        d = c.data("class") ? c.data("class") : "animated fadeIn",
                        e = c.data("offset") ? c.data("offset") : 0,
                        f = a.hasClass("ie9") || 992 > b ? 0 : c.data("timeout") ? c.data("timeout") : 0;
                    c.appear(function() {
                        setTimeout(function() {
                            c.removeClass("visibility-hidden").addClass(d)
                        }, f)
                    }, {
                        accY: e
                    })
                })
            },
            C = function() {
                jQuery('[data-toggle="countTo"]').each(function() {
                    var a = jQuery(this),
                        b = a.data("after"),
                        c = a.data("speed") ? a.data("speed") : 1500,
                        d = a.data("interval") ? a.data("interval") : 15;
                    a.appear(function() {
                        a.countTo({
                            speed: c,
                            refreshInterval: d,
                            onComplete: function() {
                                b && a.html(a.html() + b)
                            }
                        })
                    })
                })
            },
            D = function() {
                jQuery('[data-toggle="slimscroll"]').each(function() {
                    var a = jQuery(this),
                        b = a.data("height") ? a.data("height") : "200px",
                        c = a.data("size") ? a.data("size") : "5px",
                        d = a.data("position") ? a.data("position") : "right",
                        e = a.data("color") ? a.data("color") : "#000",
                        f = a.data("always-visible") ? !0 : !1,
                        g = a.data("rail-visible") ? !0 : !1,
                        h = a.data("rail-color") ? a.data("rail-color") : "#999",
                        i = a.data("rail-opacity") ? a.data("rail-opacity") : .3;
                    a.slimScroll({
                        height: b,
                        size: c,
                        position: d,
                        color: e,
                        alwaysVisible: f,
                        railVisible: g,
                        railColor: h,
                        railOpacity: i
                    })
                })
            },
            E = function() {
                jQuery(".js-gallery").each(function() {
                    jQuery(this).magnificPopup({
                        delegate: "a.img-link",
                        type: "image",
                        gallery: {
                            enabled: !0
                        }
                    })
                }), jQuery(".js-gallery-advanced").each(function() {
                    jQuery(this).magnificPopup({
                        delegate: "a.img-lightbox",
                        type: "image",
                        gallery: {
                            enabled: !0
                        }
                    })
                })
            },
            F = function() {
                CKEDITOR.disableAutoInline = !0, jQuery("#js-ckeditor-inline").length && CKEDITOR.inline("js-ckeditor-inline"), jQuery("#js-ckeditor").length && CKEDITOR.replace("js-ckeditor")
            },
            G = function() {
                jQuery(".js-summernote-air").summernote({
                    airMode: !0
                }), jQuery(".js-summernote").summernote({
                    height: 350,
                    minHeight: null,
                    maxHeight: null
                })
            },
            H = function() {
                jQuery(".js-slider").each(function() {
                    var a = jQuery(this),
                        b = a.data("slider-arrows") ? a.data("slider-arrows") : !1,
                        c = a.data("slider-dots") ? a.data("slider-dots") : !1,
                        d = a.data("slider-num") ? a.data("slider-num") : 1,
                        e = a.data("slider-autoplay") ? a.data("slider-autoplay") : !1,
                        f = a.data("slider-autoplay-speed") ? a.data("slider-autoplay-speed") : 3e3;
                    a.slick({
                        arrows: b,
                        dots: c,
                        slidesToShow: d,
                        autoplay: e,
                        autoplaySpeed: f
                    })
                })
            },
            I = function() {
                jQuery(".js-datepicker").add(".input-daterange").datepicker({
                    weekStart: 1,
                    autoclose: !0,
                    todayHighlight: !0
                })
            },
            J = function() {
                jQuery(".js-colorpicker").each(function() {
                    var a = jQuery(this),
                        b = a.data("colorpicker-mode") ? a.data("colorpicker-mode") : "hex",
                        c = a.data("colorpicker-inline") ? !0 : !1;
                    a.colorpicker({
                        format: b,
                        inline: c
                    })
                })
            },
            K = function() {
                jQuery(".js-masked-date").mask("99/99/9999"), jQuery(".js-masked-date-dash").mask("99-99-9999"), jQuery(".js-masked-phone").mask("(999) 999-9999"), jQuery(".js-masked-phone-ext").mask("(999) 999-9999? x99999"), jQuery(".js-masked-taxid").mask("99-9999999"), jQuery(".js-masked-ssn").mask("999-99-9999"), jQuery(".js-masked-pkey").mask("a*-999-a999")
            },
            L = function() {
                jQuery(".js-tags-input").tagsInput({
                    height: "36px",
                    width: "100%",
                    defaultText: "Add tag",
                    removeWithBackspace: !0,
                    delimiter: [","]
                })
            },
            M = function() {
                jQuery(".js-select2").select2()
            },
            N = function() {
                hljs.initHighlightingOnLoad()
            },
            O = function() {
                jQuery(".js-notify").on("click", function() {
                    var a = jQuery(this),
                        b = a.data("notify-message"),
                        c = a.data("notify-type") ? a.data("notify-type") : "info",
                        d = a.data("notify-from") ? a.data("notify-from") : "top",
                        e = a.data("notify-align") ? a.data("notify-align") : "right",
                        f = a.data("notify-icon") ? a.data("notify-icon") : "",
                        g = a.data("notify-url") ? a.data("notify-url") : "";
                    jQuery.notify({
                        icon: f,
                        message: b,
                        url: g
                    }, {
                        element: "body",
                        type: c,
                        allow_dismiss: !0,
                        newest_on_top: !0,
                        showProgressbar: !1,
                        placement: {
                            from: d,
                            align: e
                        },
                        offset: 20,
                        spacing: 10,
                        z_index: 1031,
                        delay: 5e3,
                        timer: 1e3,
                        animate: {
                            enter: "animated fadeIn",
                            exit: "animated fadeOutDown"
                        }
                    })
                })
            },
            P = function() {
                jQuery(".js-draggable-items > .draggable-column").sortable({
                    connectWith: ".draggable-column",
                    items: ".draggable-item",
                    dropOnEmpty: !0,
                    opacity: .75,
                    handle: ".draggable-handler",
                    placeholder: "draggable-placeholder",
                    tolerance: "pointer",
                    start: function(a, b) {
                        b.placeholder.css({
                            height: b.item.outerHeight(),
                            "margin-bottom": b.item.css("margin-bottom")
                        })
                    }
                })
            },
            Q = function() {
                jQuery(".js-pie-chart").easyPieChart({
                    barColor: jQuery(this).data("bar-color") ? jQuery(this).data("bar-color") : "#777777",
                    trackColor: jQuery(this).data("track-color") ? jQuery(this).data("track-color") : "#eeeeee",
                    lineWidth: jQuery(this).data("line-width") ? jQuery(this).data("line-width") : 3,
                    size: jQuery(this).data("size") ? jQuery(this).data("size") : "80",
                    animate: 750,
                    scaleColor: jQuery(this).data("scale-color") ? jQuery(this).data("scale-color") : !1
                })
            },
            R = function() {
                jQuery(".js-maxlength").each(function() {
                    var a = jQuery(this);
                    a.maxlength({
                        alwaysShow: a.data("always-show") ? !0 : !1,
                        threshold: a.data("threshold") ? a.data("threshold") : 10,
                        warningClass: a.data("warning-class") ? a.data("warning-class") : "label label-warning",
                        limitReachedClass: a.data("limit-reached-class") ? a.data("limit-reached-class") : "label label-danger",
                        placement: a.data("placement") ? a.data("placement") : "bottom",
                        preText: a.data("pre-text") ? a.data("pre-text") : "",
                        separator: a.data("separator") ? a.data("separator") : "/",
                        postText: a.data("post-text") ? a.data("post-text") : ""
                    })
                })
            },
            S = function() {
                jQuery(".js-datetimepicker").each(function() {
                    var a = jQuery(this);
                    a.datetimepicker({
                        format: a.data("format") ? a.data("format") : !1,
                        useCurrent: a.data("use-current") ? a.data("use-current") : !1,
                        locale: moment.locale("" + (a.data("locale") ? a.data("locale") : "")),
                        showTodayButton: a.data("show-today-button") ? a.data("show-today-button") : !1,
                        showClear: a.data("show-clear") ? a.data("show-clear") : !1,
                        showClose: a.data("show-close") ? a.data("show-close") : !1,
                        sideBySide: a.data("side-by-side") ? a.data("side-by-side") : !1,
                        inline: a.data("inline") ? a.data("inline") : !1,
                        icons: {
                            time: "si si-clock",
                            date: "si si-calendar",
                            up: "si si-arrow-up",
                            down: "si si-arrow-down",
                            previous: "si si-arrow-left",
                            next: "si si-arrow-right",
                            today: "si si-size-actual",
                            clear: "si si-trash",
                            close: "si si-close"
                        }
                    })
                })
            },
            T = function() {
                jQuery(".js-rangeslider").each(function() {
                    var a = jQuery(this);
                    a.ionRangeSlider()
                })
            };
        return {
            init: function(a) {
                switch (a) {
                    case "uiInit":
                        k();
                        break;
                    case "uiLayout":
                        l();
                        break;
                    case "uiNav":
                        p();
                        break;
                    case "uiBlocks":
                        q();
                        break;
                    case "uiForms":
                        s();
                        break;
                    case "uiHandleTheme":
                        t();
                        break;
                    case "uiToggleClass":
                        v();
                        break;
                    case "uiScrollTo":
                        u();
                        break;
                    case "uiYearCopy":
                        w();
                        break;
                    default:
                        k(), l(), p(), q(), s(), t(), v(), u(), w()
                }
            },
            layout: function(a) {
                o(a)
            },
            blocks: function(a, b) {
                r(a, b)
            },
            initHelper: function(a) {
                switch (a) {
                    case "print-page":
                        x();
                        break;
                    case "table-tools":
                        y(), z();
                        break;
                    case "appear":
                        B();
                        break;
                    case "appear-countTo":
                        C();
                        break;
                    case "slimscroll":
                        D();
                        break;
                    case "magnific-popup":
                        E();
                        break;
                    case "ckeditor":
                        F();
                        break;
                    case "summernote":
                        G();
                        break;
                    case "slick":
                        H();
                        break;
                    case "datepicker":
                        I();
                        break;
                    case "colorpicker":
                        J();
                        break;
                    case "tags-inputs":
                        L();
                        break;
                    case "masked-inputs":
                        K();
                        break;
                    case "select2":
                        M();
                        break;
                    case "highlightjs":
                        N();
                        break;
                    case "notify":
                        O();
                        break;
                    case "draggable-items":
                        P();
                        break;
                    case "easy-pie-chart":
                        Q();
                        break;
                    case "maxlength":
                        R();
                        break;
                    case "datetimepicker":
                        S();
                        break;
                    case "rangeslider":
                        T();
                        break;
                    default:
                        return !1
                }
            },
            initHelpers: function(a) {
                if (a instanceof Array)
                    for (var b in a) App.initHelper(a[b]);
                else App.initHelper(a)
            }
        }
    }(),
    OneUI = App;
jQuery(function() {
    "undefined" == typeof angular && App.init()
});
