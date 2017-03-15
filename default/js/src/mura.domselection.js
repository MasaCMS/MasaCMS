/* This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
	Mura CMS under the license of your choice, provided that you follow these specific guidelines:

	Your custom code

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.

	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
	requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */
;
(function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define([root, 'Mura'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        factory(root, require('Mura'));
    } else {
        // Browser globals (root is window)
        factory(root, root.Mura);
    }
}(this, function(root, Mura) {
    /**
     * Creates a new Mura.DOMSelection
     * @class {class} Mura.DOMSelection
     */
    Mura.DOMSelection = Mura.Core.extend(
        /** @lends Mura.DOMSelection.prototype */
        {

            /**
             * init - initiliazes instance
             *
             * @param  {object} properties Object containing values to set into object
             * @return {void}
             */
            init: function(selection, origSelector) {
                this.selection = selection;
                this.origSelector = origSelector;

                if (this.selection.length && this.selection[0]) {
                    this.parentNode = this.selection[0].parentNode;
                    this.childNodes = this.selection[0].childNodes;
                    this.node = selection[0];
                    this.length = this.selection.length;
                } else {
                    this.parentNode = null;
                    this.childNodes = null;
                    this.node = null;
                    this.length = 0;
                }
            },


            /**
             * get - Deprecated: Returns element at index of selection, use item()
             *
             * @param  {number} index Index of selection
             * @return {*}
             */
            get: function(index) {
                return this.selection[index];
            },


            /**
             * select - Returns new Mura.DomSelection
             *
             * @param  {string} selector Selector
             * @return {object}
             */
            select: function(selector) {
                return mura(selector);
            },


            /**
             * each - Runs function against each item in selection
             *
             * @param  {function} fn Method
             * @return {Mura.DOMSelection} Self
             */
            each: function(fn) {
                this.selection.forEach(function(el, idx, array) {
                    fn.call(el, el, idx, array);
                });
                return this;
            },


            /**
             * filter - Creates a new Mura.DomSelection instance contains selection values that pass filter function by returning true
             *
             * @param  {function} fn Filter function
             * @return {object}    New Mura.DOMSelection
             */
            filter: function(fn) {
                return mura(this.selection.filter(function(el,
                    idx, array) {
                    return fn.call(el, el, idx,
                        array);
                }));
            },

            /**
             * map - Creates a new Mura.DomSelection instance contains selection values that are returned by Map function
             *
             * @param  {function} fn Map function
             * @return {object}    New Mura.DOMSelection
             */
            map: function(fn) {
                return mura(this.selection.map(function(el, idx,
                    array) {
                    return fn.call(el, el, idx,
                        array);
                }));
            },

            /**
             * reduce - Returns value from  reduce function
             *
             * @param  {function} fn Reduce function
             * @param  {any} initialValue Starting accumulator value
             * @return {accumulator}
             */
            reduce: function(fn, initialValue) {
                initialValue = initialValue || 0;
                return this.selection.reduce(
                    function(accumulator, item, idx, array) {
                        return fn.call(item, accumulator,
                            item, idx, array);
                    },
                    initialValue
                );
            },


            /**
             * isNumeric - Returns if value is numeric
             *
             * @param  {*} val Value
             * @return {type}     description
             */
            isNumeric: function(val) {
                if (typeof val != 'undefined') {
                    return isNumeric(val);
                }
                return isNumeric(this.selection[0]);
            },


            /**
             * processMarkup - Process Markup of selected dom elements
             *
             * @return {Promise}
             */
            processMarkup: function() {
                var self = this;
                return new Promise(function(resolve, reject) {
                    self.each(function(el) {
                        Mura.processMarkup(el);
                    });
                });
            },

            /**
             * on - Add event handling method
             *
             * @param  {string} eventName Event name
             * @param  {string} selector  Selector (optional: for use with delegated events)
             * @param  {function} fn        description
             * @return {Mura.DOMSelection} Self
             */
            on: function(eventName, selector, fn) {
                if (typeof selector == 'function') {
                    fn = selector;
                    selector = '';
                }

                if (eventName == 'ready') {
                    if (document.readyState != 'loading') {
                        var self = this;

                        setTimeout(
                            function() {
                                self.each(function() {
                                    if (selector) {
                                        mura(this).find(
                                            selector
                                        ).each(
                                            function() {
                                                fn
                                                    .call(
                                                        this
                                                    );
                                            });
                                    } else {
                                        fn.call(
                                            this
                                        );
                                    }
                                });
                            },
                            1
                        );

                        return this;

                    } else {
                        eventName = 'DOMContentLoaded';
                    }
                }

                this.each(function() {
                    if (typeof this.addEventListener ==
                        'function') {
                        var self = this;

                        this.addEventListener(
                            eventName,
                            function(event) {
                                if (selector) {
                                    if (mura(event.target)
                                        .is(
                                            selector
                                        )) {
                                        return fn.call(
                                            event
                                            .target,
                                            event
                                        );
                                    }
                                } else {
                                    return fn.call(
                                        self,
                                        event);
                                }

                            },
                            true
                        );
                    }
                });

                return this;
            },

            /**
             * hover - Adds hovering events to selected dom elements
             *
             * @param  {function} handlerIn  In method
             * @param  {function} handlerOut Out method
             * @return {object}            Self
             */
            hover: function(handlerIn, handlerOut) {
                this.on('mouseover', handlerIn);
                this.on('mouseout', handlerOut);
                this.on('touchstart', handlerIn);
                this.on('touchend', handlerOut);
                return this;
            },


            /**
             * click - Adds onClick event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            click: function(fn) {
                this.on('click', fn);
                return this;
            },

            /**
             * change - Adds onChange event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            change: function(fn) {
                this.on('change', fn);
                return this;
            },

            /**
             * submit - Adds onSubmit event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            submit: function(fn) {
                if (fn) {
                    this.on('submit', fn);
                } else {
                    this.each(function(el) {
                        if (typeof el.submit ==
                            'function') {
                            Mura.submitForm(el);
                        }
                    });
                }

                return this;
            },

            /**
             * ready - Adds onReady event handler to selection
             *
             * @param  {function} fn Handler function
             * @return {Mura.DOMSelection} Self
             */
            ready: function(fn) {
                this.on('ready', fn);
                return this;
            },

            /**
             * off - Removes event handler from selection
             *
             * @param  {string} eventName Event name
             * @param  {function} fn      Function to remove  (optional)
             * @return {Mura.DOMSelection} Self
             */
            off: function(eventName, fn) {
                this.each(function(el, idx, array) {
                    if (typeof eventName != 'undefined') {
                        if (typeof fn != 'undefined') {
                            el.removeEventListener(
                                eventName, fn);
                        } else {
                            el[eventName] = null;
                        }
                    } else {
                        if (typeof el.parentElement !=
                            'undefined' && el.parentElement &&
                            typeof el.parentElement.replaceChild !=
                            'undefined') {
                            var elClone = el.cloneNode(
                                true);
                            el.parentElement.replaceChild(
                                elClone, el);
                            array[idx] = elClone;
                        } else {
                            console.log(
                                "Mura: Can not remove all handlers from element without a parent node"
                            )
                        }
                    }

                });
                return this;
            },

            /**
             * unbind - Removes event handler from selection
             *
             * @param  {string} eventName Event name
             * @param  {function} fn      Function to remove  (optional)
             * @return {Mura.DOMSelection} Self
             */
            unbind: function(eventName, fn) {
                this.off(eventName, fn);
                return this;
            },

            /**
             * bind - Add event handling method
             *
             * @param  {string} eventName Event name
             * @param  {string} selector  Selector (optional: for use with delegated events)
             * @param  {function} fn        description
             * @return {Mura.DOMSelection}           Self
             */
            bind: function(eventName, fn) {
                this.on(eventName, fn);
                return this;
            },

            /**
             * trigger - Triggers event on selection
             *
             * @param  {string} eventName   Event name
             * @param  {object} eventDetail Event properties
             * @return {Mura.DOMSelection}             Self
             */
            trigger: function(eventName, eventDetail) {
                eventDetails = eventDetail || {};

                this.each(function(el) {
                    Mura.trigger(el, eventName,
                        eventDetail);
                });
                return this;
            },

            /**
             * parent - Return new Mura.DOMSelection of the first elements parent
             *
             * @return {Mura.DOMSelection}
             */
            parent: function() {
                if (!this.selection.length) {
                    return this;
                }
                return mura(this.selection[0].parentNode);
            },

            /**
             * children - Returns new Mura.DOMSelection or the first elements children
             *
             * @param  {string} selector Filter (optional)
             * @return {Mura.DOMSelection}
             */
            children: function(selector) {
                if (!this.selection.length) {
                    return this;
                }

                if (this.selection[0].hasChildNodes()) {
                    var children = mura(this.selection[0].childNodes);

                    if (typeof selector == 'string') {
                        var filterFn = function() {
                            return (this.nodeType === 1 ||
                                    this.nodeType === 11 ||
                                    this.nodeType === 9) &&
                                this.matchesSelector(
                                    selector);
                        };
                    } else {
                        var filterFn = function() {
                            return this.nodeType === 1 ||
                                this.nodeType === 11 ||
                                this.nodeType === 9;
                        };
                    }

                    return children.filter(filterFn);
                } else {
                    return mura([]);
                }

            },


            /**
             * find - Returns new Mura.DOMSelection matching items under the first selection
             *
             * @param  {string} selector Selector
             * @return {Mura.DOMSelection}
             */
            find: function(selector) {
                if (this.selection.length && this.selection[0]) {
                    var removeId = false;

                    if (this.selection[0].nodeType == '1' ||
                        this.selection[0].nodeType == '11') {
                        var result = this.selection[0].querySelectorAll(
                            selector);
                    } else if (this.selection[0].nodeType ==
                        '9') {
                        var result = document.querySelectorAll(
                            selector);
                    } else {
                        var result = [];
                    }
                    return mura(result);
                } else {
                    return mura([]);
                }
            },

            /**
             * first - Returns first item in selection
             *
             * @return {*}
             */
            first: function() {
                if (this.selection.length) {
                    return mura(this.selection[0]);
                } else {
                    return mura([]);
                }
            },

            /**
             * last - Returns last item in selection
             *
             * @return {*}
             */
            last: function() {
                if (this.selection.length) {
                    return mura(this.selection[this.selection.length -
                        1]);
                } else {
                    return mura([]);
                }
            },

            /**
             * selector - Returns css selector for first item in selection
             *
             * @return {string}
             */
            selector: function() {
                var pathes = [];
                var path, node = mura(this.selection[0]);

                while (node.length) {
                    var realNode = node.get(0),
                        name = realNode.localName;
                    if (!name) {
                        break;
                    }

                    if (!node.data('hastempid') && node.attr(
                            'id') && node.attr('id') !=
                        'mura-variation-el') {
                        name = '#' + node.attr('id');
                        path = name + (path ? ' > ' + path : '');
                        break;
                    } else {

                        name = name.toLowerCase();
                        var parent = node.parent();
                        var sameTagSiblings = parent.children(
                            name);

                        if (sameTagSiblings.length > 1) {
                            var allSiblings = parent.children();
                            var index = allSiblings.index(
                                realNode) + 1;

                            if (index > 0) {
                                name += ':nth-child(' + index +
                                    ')';
                            }
                        }

                        path = name + (path ? ' > ' + path : '');
                        node = parent;
                    }

                }

                pathes.push(path);

                return pathes.join(',');
            },

            /**
             * siblings - Returns new Mura.DOMSelection of first item's siblings
             *
             * @param  {string} selector Selector to filter siblings (optional)
             * @return {Mura.DOMSelection}
             */
            siblings: function(selector) {
                if (!this.selection.length) {
                    return this;
                }
                var el = this.selection[0];

                if (el.hasChildNodes()) {
                    var silbings = mura(this.selection[0].childNodes);

                    if (typeof selector == 'string') {
                        var filterFn = function() {
                            return (this.nodeType === 1 ||
                                    this.nodeType === 11 ||
                                    this.nodeType === 9) &&
                                this.matchesSelector(
                                    selector);
                        };
                    } else {
                        var filterFn = function() {
                            return this.nodeType === 1 ||
                                this.nodeType === 11 ||
                                this.nodeType === 9;
                        };
                    }

                    return silbings.filter(filterFn);
                } else {
                    return mura([]);
                }
            },

            /**
             * item - Returns item at selected index
             *
             * @param  {number} idx Index to return
             * @return {*}
             */
            item: function(idx) {
                return this.selection[idx];
            },

            /**
             * index - Returns the index of element
             *
             * @param  {*} el Element to return index of
             * @return {*}
             */
            index: function(el) {
                return this.selection.indexOf(el);
            },

            /**
             * closest - Returns new Mura.DOMSelection of closest parent matching selector
             *
             * @param  {string} selector Selector
             * @return {Mura.DOMSelection}
             */
            closest: function(selector) {
                if (!this.selection.length) {
                    return null;
                }

                var el = this.selection[0];

                for (var parent = el; parent !== null && parent
                    .matchesSelector && !parent.matchesSelector(
                        selector); parent = el.parentElement) {
                    el = parent;
                };

                if (parent) {
                    return mura(parent)
                } else {
                    return mura([]);
                }

            },

            /**
             * append - Appends element to items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            append: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'beforeend', el);
                    } else {
                        this.appendChild(el);
                    }
                });
                return this;
            },

            /**
             * appendDisplayObject - Appends display object to selected items
             *
             * @param  {object} data Display objectparams (including object='objectkey')
             * @return {Promise}
             */
            appendDisplayObject: function(data) {
                var self = this;

                return new Promise(function(resolve, reject) {
                    self.each(function() {
                        var el = document.createElement(
                            'div');
                        el.setAttribute('class',
                            'mura-object');

                        for (var a in data) {
                            el.setAttribute(
                                'data-' + a,
                                data[a]);
                        }

                        if (typeof data.async ==
                            'undefined') {
                            el.setAttribute(
                                'data-async',
                                true);
                        }

                        if (typeof data.render ==
                            'undefined') {
                            el.setAttribute(
                                'data-render',
                                'server');
                        }

                        el.setAttribute(
                            'data-instanceid',
                            Mura.createUUID()
                        );

                        mura(this).append(el);

                        Mura.processDisplayObject(
                            el).then(
                            resolve, reject
                        );

                    });
                });
            },

            /**
             * prependDisplayObject - Prepends display object to selected items
             *
             * @param  {object} data Display objectparams (including object='objectkey')
             * @return {Promise}
             */
            prependDisplayObject: function(data) {
                var self = this;

                return new Promise(function(resolve, reject) {
                    self.each(function() {
                        var el = document.createElement(
                            'div');
                        el.setAttribute('class',
                            'mura-object');

                        for (var a in data) {
                            el.setAttribute(
                                'data-' + a,
                                data[a]);
                        }

                        if (typeof data.async ==
                            'undefined') {
                            el.setAttribute(
                                'data-async',
                                true);
                        }

                        if (typeof data.render ==
                            'undefined') {
                            el.setAttribute(
                                'data-render',
                                'server');
                        }

                        el.setAttribute(
                            'data-instanceid',
                            Mura.createUUID()
                        );

                        mura(this).prepend(el);

                        Mura.processDisplayObject(
                            el).then(
                            resolve, reject
                        );

                    });
                });
            },

            /**
             * processDisplayObject - Handles processing of display object params to selection
             *
             * @param  {object} data Display object params
             * @return {Promise}
             */
            processDisplayObject: function(data) {
                var self = this;
                return new Promise(function(resolve, reject) {
                    self.each(function() {
                        Mura.processDisplayObject(
                            this).then(
                            resolve, reject
                        );
                    });
                });
            },

            /**
             * prepend - Prepends element to items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            prepend: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'afterbegin', el);
                    } else {
                        this.insertBefore(el, this.firstChild);
                    }
                });
                return this;
            },

            /**
             * before - Inserts element before items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            before: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'beforebegin', el);
                    } else {
                        this.parent.insertBefore(el,
                            this);
                    }
                });
                return this;
            },

            /**
             * after - Inserts element after items in selection
             *
             * @param  {*} el Element to append
             * @return {Mura.DOMSelection} Self
             */
            after: function(el) {
                this.each(function() {
                    if (typeof el == 'string') {
                        this.insertAdjacentHTML(
                            'afterend', el);
                    } else {
                        this.parent.insertBefore(el,
                            this.parent.firstChild);
                    }
                });
                return this;
            },


            /**
             * hide - Hides elements in selection
             *
             * @return {object}  Self
             */
            hide: function() {
                this.each(function(el) {
                    el.style.display = 'none';
                });
                return this;
            },

            /**
             * show - Shows elements in selection
             *
             * @return {object}  Self
             */
            show: function() {
                this.each(function(el) {
                    el.style.display = '';
                });
                return this;
            },

            /**
             * repaint - repaints elements in selection
             *
             * @return {object}  Self
             */
            redraw: function() {
                this.each(function(el) {
                    var elm = Mura(el);

                    setTimeout(
                        function() {
                            elm.show();
                        },
                        1
                    );

                });
                return this;
            },

            /**
             * remove - Removes elements in selection
             *
             * @return {object}  Self
             */
            remove: function() {
                this.each(function(el) {
                    el.parentNode.removeChild(el);
                });
                return this;
            },

            /**
             * addClass - Adds class to elements in selection
             *
             * @param  {string} className Name of class
             * @return {Mura.DOMSelection} Self
             */
            addClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.add(className);
                    } else {
                        el.className += ' ' + className;
                    }
                });
                return this;
            },

            /**
             * hasClass - Returns if the first element in selection has class
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            hasClass: function(className) {
                return this.is("." + className);
            },

            /**
             * removeClass - Removes class from elements in selection
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            removeClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.remove(className);
                    } else if (el.className) {
                        el.className = el.className.replace(
                            new RegExp('(^|\\b)' +
                                className.split(' ')
                                .join('|') +
                                '(\\b|$)', 'gi'),
                            ' ');
                    }
                });
                return this;
            },

            /**
             * toggleClass - Toggles class on elements in selection
             *
             * @param  {string} className Class name
             * @return {Mura.DOMSelection} Self
             */
            toggleClass: function(className) {
                this.each(function(el) {
                    if (el.classList) {
                        el.classList.toggle(className);
                    } else {
                        var classes = el.className.split(
                            ' ');
                        var existingIndex = classes.indexOf(
                            className);

                        if (existingIndex >= 0)
                            classes.splice(
                                existingIndex, 1);
                        else
                            classes.push(className);

                        el.className = classes.join(' ');
                    }
                });
                return this;
            },

            /**
             * empty - Removes content from elements in selection
             *
             * @return {object}  Self
             */
            empty: function() {
                this.each(function(el) {
                    el.innerHTML = '';
                });
                return this;
            },

            /**
             * evalScripts - Evaluates script tags in selection elements
             *
             * @return {object}  Self
             */
            evalScripts: function() {
                if (!this.selection.length) {
                    return this;
                }

                this.each(function(el) {
                    Mura.evalScripts(el);
                });

                return this;

            },

            /**
             * html - Returns or sets HTML of elements in selection
             *
             * @param  {string} htmlString description
             * @return {object}            Self
             */
            html: function(htmlString) {
                if (typeof htmlString != 'undefined') {
                    this.each(function(el) {
                        el.innerHTML = htmlString;
                        Mura.evalScripts(el);
                    });
                    return this;
                } else {
                    if (!this.selection.length) {
                        return '';
                    }
                    return this.selection[0].innerHTML;
                }
            },

            /**
             * css - Sets css value for elements in selection
             *
             * @param  {string} ruleName Css rule name
             * @param  {string} value    Rule value
             * @return {object}          Self
             */
            css: function(ruleName, value) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof ruleName == 'undefined' && typeof value ==
                    'undefined') {
                    try {
                        return getComputedStyle(this.selection[
                            0]);
                    } catch (e) {
                        return {};
                    }
                } else if (typeof ruleName == 'object') {
                    this.each(function(el) {
                        try {
                            for (var p in ruleName) {
                                el.style[p] = ruleName[
                                    p];
                            }
                        } catch (e) {}
                    });
                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        try {
                            el.style[ruleName] = value;
                        } catch (e) {}
                    });
                    return this;
                } else {
                    try {
                        return getComputedStyle(this.selection[
                            0])[ruleName];
                    } catch (e) {}
                }
            },

            /**
             * text - Gets or sets the text content of each element in the selection
             *
             * @param  {string} textString Text string
             * @return {object}            Self
             */
            text: function(textString) {
                if (typeof textString == 'undefined') {
                    this.each(function(el) {
                        el.textContent = textString;
                    });
                    return this;
                } else {
                    return this.selection[0].textContent;
                }
            },

            /**
             * is - Returns if the first element in the select matches the selector
             *
             * @param  {string} selector description
             * @return {boolean}
             */
            is: function(selector) {
                if (!this.selection.length) {
                    return false;
                }
                return this.selection[0].matchesSelector &&
                    this.selection[0].matchesSelector(selector);
            },

            /**
             * hasAttr - Returns is the first element in the selection has an attribute
             *
             * @param  {string} attributeName description
             * @return {boolean}
             */
            hasAttr: function(attributeName) {
                if (!this.selection.length) {
                    return false;
                }

                return typeof this.selection[0].hasAttribute ==
                    'function' && this.selection[0].hasAttribute(
                        attributeName);
            },

            /**
             * hasData - Returns if the first element in the selection has data attribute
             *
             * @param  {sting} attributeName Data atttribute name
             * @return {boolean}
             */
            hasData: function(attributeName) {
                if (!this.selection.length) {
                    return false;
                }

                return this.hasAttr('data-' + attributeName);
            },


            /**
             * offsetParent - Returns first element in selection's offsetParent
             *
             * @return {object}  offsetParent
             */
            offsetParent: function() {
                if (!this.selection.length) {
                    return this;
                }
                var el = this.selection[0];
                return el.offsetParent || el;
            },

            /**
             * outerHeight - Returns first element in selection's outerHeight
             *
             * @param  {boolean} withMargin Whether to include margin
             * @return {number}
             */
            outerHeight: function(withMargin) {
                if (!this.selection.length) {
                    return this;
                }
                if (typeof withMargin == 'undefined') {
                    function outerHeight(el) {
                        var height = el.offsetHeight;
                        var style = getComputedStyle(el);

                        height += parseInt(style.marginTop) +
                            parseInt(style.marginBottom);
                        return height;
                    }

                    return outerHeight(this.selection[0]);
                } else {
                    return this.selection[0].offsetHeight;
                }
            },

            /**
             * height - Returns height of first element in selection or set height for elements in selection
             *
             * @param  {number} height  Height (option)
             * @return {object}        Self
             */
            height: function(height) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof width != 'undefined') {
                    if (!isNaN(height)) {
                        height += 'px';
                    }
                    this.css('height', height);
                    return this;
                }

                var el = this.selection[0];
                //var type=el.constructor.name.toLowerCase();

                if (el === root) {
                    return innerHeight
                } else if (el === document) {
                    var body = document.body;
                    var html = document.documentElement;
                    return Math.max(body.scrollHeight, body.offsetHeight,
                        html.clientHeight, html.scrollHeight,
                        html.offsetHeight)
                }

                var styles = getComputedStyle(el);
                var margin = parseFloat(styles['marginTop']) +
                    parseFloat(styles['marginBottom']);

                return Math.ceil(el.offsetHeight + margin);
            },

            /**
             * width - Returns height of first element in selection or set width for elements in selection
             *
             * @param  {number} width Width (optional)
             * @return {object}       Self
             */
            width: function(width) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof width != 'undefined') {
                    if (!isNaN(width)) {
                        width += 'px';
                    }
                    this.css('width', width);
                    return this;
                }

                var el = this.selection[0];
                //var type=el.constructor.name.toLowerCase();

                if (el === root) {
                    return innerWidth
                } else if (el === document) {
                    var body = document.body;
                    var html = document.documentElement;
                    return Math.max(body.scrollWidth, body.offsetWidth,
                        html.clientWidth, html.scrolWidth,
                        html.offsetWidth)
                }

                return getComputedStyle(el).width;
            },

            /**
             * scrollTop - Returns the scrollTop of the current document
             *
             * @return {object}
             */
            scrollTop: function() {
                return document.body.scrollTop;
            },

            /**
             * offset - Returns offset of first element in selection
             *
             * @return {object}
             */
            offset: function() {
                if (!this.selection.length) {
                    return this;
                }
                var box = this.selection[0].getBoundingClientRect();
                return {
                    top: box.top + (pageYOffset || document.scrollTop) -
                        (document.clientTop || 0),
                    left: box.left + (pageXOffset || document.scrollLeft) -
                        (document.clientLeft || 0)
                };
            },

            /**
             * removeAttr - Removes attribute from elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @return {object}               Self
             */
            removeAttr: function(attributeName) {
                if (!this.selection.length) {
                    return this;
                }

                this.each(function(el) {
                    if (el && typeof el.removeAttribute ==
                        'function') {
                        el.removeAttribute(
                            attributeName);
                    }

                });
                return this;

            },

            /**
             * changeElementType - Changes element type of elements in selection
             *
             * @param  {string} type Element type to change to
             * @return {Mura.DOMSelection} Self
             */
            changeElementType: function(type) {
                if (!this.selection.length) {
                    return this;
                }

                this.each(function(el) {
                    Mura.changeElementType(el, type)

                });
                return this;

            },

            /**
             * val - Set the value of elements in selection
             *
             * @param  {*} value Value
             * @return {Mura.DOMSelection} Self
             */
            val: function(value) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof value != 'undefined') {
                    this.each(function(el) {
                        if (el.tagName == 'radio') {
                            if (el.value == value) {
                                el.checked = true;
                            } else {
                                el.checked = false;
                            }
                        } else {
                            el.value = value;
                        }

                    });
                    return this;

                } else {
                    if (Object.prototype.hasOwnProperty.call(
                            this.selection[0], 'value') ||
                        typeof this.selection[0].value !=
                        'undefined') {
                        return this.selection[0].value;
                    } else {
                        return '';
                    }
                }
            },

            /**
             * attr - Returns attribute value of first element in selection or set attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            attr: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }

                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getAttributes(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        if (el.setAttribute) {
                            for (var p in attributeName) {
                                el.setAttribute(p,
                                    attributeName[p]
                                );
                            }
                        }
                    });
                    return this;
                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        if (el.setAttribute) {
                            el.setAttribute(
                                attributeName,
                                value);
                        }
                    });
                    return this;

                } else {
                    if (this.selection[0] && this.selection[0].getAttribute) {
                        return this.selection[0].getAttribute(
                            attributeName);
                    } else {
                        return undefined;
                    }

                }
            },

            /**
             * data - Returns data attribute value of first element in selection or set data attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            data: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }
                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getData(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        for (var p in attributeName) {
                            el.setAttribute("data-" + p,
                                attributeName[p]);
                        }
                    });
                    return this;

                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        el.setAttribute("data-" +
                            attributeName, value);
                    });
                    return this;
                } else if (this.selection[0] && this.selection[
                        0].getAttribute) {
                    return Mura.parseString(this.selection[0].getAttribute(
                        "data-" + attributeName));
                } else {
                    return undefined;
                }
            },

            /**
             * prop - Returns attribute value of first element in selection or set attribute value for elements in selection
             *
             * @param  {string} attributeName Attribute name
             * @param  {*} value         Value (optional)
             * @return {Mura.DOMSelection} Self
             */
            prop: function(attributeName, value) {
                if (!this.selection.length) {
                    return this;
                }
                if (typeof value == 'undefined' && typeof attributeName ==
                    'undefined') {
                    return Mura.getProps(this.selection[0]);
                } else if (typeof attributeName == 'object') {
                    this.each(function(el) {
                        for (var p in attributeName) {
                            el.setAttribute(p,
                                attributeName[p]);
                        }
                    });
                    return this;

                } else if (typeof value != 'undefined') {
                    this.each(function(el) {
                        el.setAttribute(attributeName,
                            value);
                    });
                    return this;
                } else {
                    return Mura.parseString(this.selection[0].getAttribute(
                        attributeName));
                }
            },

            /**
             * fadeOut - Fades out elements in selection
             *
             * @return {Mura.DOMSelection} Self
             */
            fadeOut: function() {
                this.each(function(el) {
                    el.style.opacity = 1;

                    (function fade() {
                        if ((el.style.opacity -= .1) <
                            0) {
                            el.style.display =
                                "none";
                        } else {
                            requestAnimationFrame(
                                fade);
                        }
                    })();
                });

                return this;
            },

            /**
             * fadeIn - Fade in elements in selection
             *
             * @param  {string} display Display value
             * @return {Mura.DOMSelection} Self
             */
            fadeIn: function(display) {
                this.each(function(el) {
                    el.style.opacity = 0;
                    el.style.display = display ||
                        "block";

                    (function fade() {
                        var val = parseFloat(el.style
                            .opacity);
                        if (!((val += .1) > 1)) {
                            el.style.opacity = val;
                            requestAnimationFrame(
                                fade);
                        }
                    })();
                });

                return this;
            },

            /**
             * toggle - Toggles display object elements in selection
             *
             * @return {Mura.DOMSelection} Self
             */
            toggle: function() {
                this.each(function(el) {
                    if (typeof el.style.display ==
                        'undefined' || el.style.display ==
                        '') {
                        el.style.display = 'none';
                    } else {
                        el.style.display = '';
                    }
                });
                return this;
            },
            /**
             * slideToggle - Place holder
             *
             * @return {Mura.DOMSelection} Self
             */
            slideToggle: function() {
                this.each(function(el) {
                    if (typeof el.style.display ==
                        'undefined' || el.style.display ==
                        '') {
                        el.style.display = 'none';
                    } else {
                        el.style.display = '';
                    }
                });
                return this;
            },

            /**
             * focus - sets focus of the first select element
             *
             * @return {self}
             */
            focus: function() {
                if (!this.selection.length) {
                    return this;
                }

                this.selection[0].focus();

                return this;
            }
        });

}));
