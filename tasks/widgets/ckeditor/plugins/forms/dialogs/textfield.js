/*
 Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("textfield", function (c) {
    function e(a) {
        var a = a.element,
            b = this.getValue();
        b ? a.setAttribute(this.id, b) : a.removeAttribute(this.id)
    }
    function f(a) {
        this.setValue(a.hasAttribute(this.id) && a.getAttribute(this.id) || "")
    }
    var g = {
        text: 1,
        password: 1,
      	'data-required': 1,
        'data-validate': 1,
        'data-message': 1,
        'data-regex': 1,
        'data-matchfield': 1,
        'data-label': 1
    };
    return {
        title: c.lang.forms.textfield.title,
        minWidth: 350,
        minHeight: 150,
        onShow: function () {
            delete this.textField;
            var a = this.getParentEditor().getSelection().getSelectedElement();
            if (a && "input" == a.getName() && (g[a.getAttribute("type")] || !a.getAttribute("type"))) this.textField = a, this.setupContent(a)
        },
        onOk: function () {
            var a = this.getParentEditor(),
                b = this.textField,
                c = !b;
            c && (b = a.document.createElement("input"), b.setAttribute("type", "text"));
            b = {
                element: b
            };
            c && a.insertElement(b.element);
            this.commitContent(b);
            c || a.getSelection().selectElement(b.element)
        },
        onLoad: function () {
            this.foreach(function (a) {
                if (a.getValue && (a.setup || (a.setup = f), !a.commit)) a.commit = e
            })
        },
        contents: [{
            id: "info",
            label: c.lang.forms.textfield.title,
            title: c.lang.forms.textfield.title,
            elements: [{
                type: "hbox",
                widths: ["50%",
                    "50%"],
                children: [{
                    id: "_cke_saved_name",
                    type: "text",
                    label: c.lang.forms.textfield.name,
                    "default": "",
                    accessKey: "N",
                    setup: function (a) {
                        this.setValue(a.data("cke-saved-name") || a.getAttribute("name") || "")
                    },
                    commit: function (a) {
                        a = a.element;
                        this.getValue() ? a.data("cke-saved-name", this.getValue()) : (a.data("cke-saved-name", !1), a.removeAttribute("name"))
                    }
                }, {
                    id: "value",
                    type: "text",
                    label: c.lang.forms.textfield.value,
                    "default": "",
                    accessKey: "V",
                    commit: function (a) {
                        if (CKEDITOR.env.ie && !this.getValue()) {
                            var b = a.element,
                                d = new CKEDITOR.dom.element("input", c.document);
                            b.copyAttributes(d, {
                                value: 1
                            });
                            d.replace(b);
                            a.element = d
                        } else e.call(this, a)
                    }
                }]
            }, {
                type: "hbox",
                widths: ["50%", "50%"],
                children: [{
                    id: "size",
                    type: "text",
                    label: c.lang.forms.textfield.charWidth,
                    "default": "",
                    accessKey: "C",
                    style: "width:50px",
                    validate: CKEDITOR.dialog.validate.integer(c.lang.common.validateNumberFailed)
                }, {
                    id: "maxLength",
                    type: "text",
                    label: c.lang.forms.textfield.maxChars,
                    "default": "",
                    accessKey: "M",
                    style: "width:50px",
                    validate: CKEDITOR.dialog.validate.integer(c.lang.common.validateNumberFailed)
                }],
                onLoad: function () {
                    CKEDITOR.env.ie7Compat && this.getElement().setStyle("zoom", "100%")
                }
            }, {
                id: "type",
                type: "select",
                label: c.lang.forms.textfield.type,
                "default": "text",
                accessKey: "M",
                items: [
                    [c.lang.forms.textfield.typeText, "text"],
                    [c.lang.forms.textfield.typePass, "password"]
                ],
                setup: function (a) {
                    this.setValue(a.getAttribute("type"))
                },
                commit: function (a) {
                    var b = a.element;
                    if (CKEDITOR.env.ie) {
                        var d = b.getAttribute("type"),
                            e = this.getValue();
                        d != e && (d = CKEDITOR.dom.element.createFromHtml('<input type="' + e + '"></input>',
                        c.document), b.copyAttributes(d, {
                            type: 1
                        }), d.replace(b), a.element = d)
                    } else b.setAttribute("type", this.getValue())
                }
            }]
        },
		            {
		                id: 'data-required',
		                type: 'select',
		                label: 'Required',
		                'default': 'false',
		                items: [
		                    ['False', 'false'],
		                    ['True', 'true']
		                ]
		            },
		            {
		                id: 'data-validate',
		                type: 'select',
		                label: 'Validation',
		                'default': '',
		                items: [
		                    ['None', ''],
		                    ['Email', 'email'],
		                    ['Date', 'date'],
		                    ['Numeric', 'numeric'],
		                    ['Regex', 'regex'],
		                    ['Match', 'match']
		                ]
		            },
		            {
		                id: 'data-message',
		                type: 'text',
		                label: 'Validation Failure Message',
		                'default': ''
		            },
		            {
		                id: 'data-regex',
		                type: 'text',
		                label: 'Regex Expression (Use when validate is set to Regex)',
		                'default': ''
		            },
		            {
		                id: 'data-matchfield',
		                type: 'text',
		                label: 'Match Field (Use when validate is set to Match)',
		                'default': ''
		            }]
    }
});