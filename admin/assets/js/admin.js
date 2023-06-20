/* 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
	requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

    function loadObject(e, t, i) {
        var a, n = t;
        processReqChange = function() {
            4 == a.readyState && 200 == a.status && (document.getElementById(n).innerHTML = a.responseText);
        }, document.getElementById(n).innerHTML = i, window.XMLHttpRequest ? ((a = new XMLHttpRequest()).onreadystatechange = processReqChange,
        a.open("GET", e, !0), a.send(null)) : window.ActiveXObject && (a = new ActiveXObject("Microsoft.XMLHTTP")) && (a.onreadystatechange = processReqChange,
        a.open("GET", e, !0), a.send());
    }
    
    var dtCh = "/", minYear = 1800, maxYear = 2200, dtFormat = [ 0, 1, 2 ], dtExample = "12/31/2016";
    
    function isInteger(e) {
        var t;
        for (t = 0; t < e.length; t++) {
            var i = e.charAt(t);
            if (i < "0" || "9" < i) return !1;
        }
        return !0;
    }
    
    function stripCharsInBag(e, t) {
        var i, a = "";
        for (i = 0; i < e.length; i++) {
            var n = e.charAt(i);
            -1 == t.indexOf(n) && (a += n);
        }
        return a;
    }
    
    function daysInFebruary(e) {
        return e % 4 != 0 || e % 100 == 0 && e % 400 != 0 ? 28 : 29;
    }
    
    function DaysArray(e) {
        for (var t = 1; t <= e; t++) this[t] = 31, 4 != t && 6 != t && 9 != t && 11 != t || (this[t] = 30),
        2 == t && (this[t] = 29);
        return this;
    }
    
    function parseDateTimeSelector(e) {
        if (isDate($(".datepicker.mura-datepicker" + e).val())) {
            var t = $(".datepicker.mura-datepicker" + e).val(), i = (DaysArray(12), t.split(dtCh)), a = i[dtFormat[0]], n = i[dtFormat[1]], o = i[dtFormat[2]], r = $("#mura-" + e + "Minute").length ? $("#mura-" + e + "Minute").val() : 0, l = $("#mura-" + e + "Hour").length ? $("#mura-" + e + "Hour").val() : 0;
            $("#mura-" + e + "DayPart").length && ("pm" == $("#mura-" + e + "DayPart").val().toLowerCase() ? 24 == (l = parseInt(l) + 12) && (l = 12) : 12 == parseInt(l) && (l = 0)),
            1 == l.length && (l = "0" + l), 1 == r.length && (r = "0" + r);
            var s = "{ts '" + o + "-" + a + "-" + n + " " + l + ":" + r + ":00'}";
            $("#mura-" + e).val(s);
        } else $("#mura-" + e).val("");
    }
    
    function isDate(e) {
        var t = DaysArray(12), i = e.split(dtCh);
        if (3 != i.length) return !1;
        var a = i[dtFormat[0]], n = i[dtFormat[1]], o = i[dtFormat[2]];
        strYr = o, "0" == n.charAt(0) && 1 < n.length && (n = n.substring(1)), "0" == a.charAt(0) && 1 < a.length && (a = a.substring(1));
        for (var r = 1; r <= 3; r++) "0" == strYr.charAt(0) && 1 < strYr.length && (strYr = strYr.substring(1));
        return month = parseInt(a), day = parseInt(n), year = parseInt(strYr), !(month < 1 || 12 < month) && (!(day < 1 || 31 < day || 2 == month && day > daysInFebruary(year) || day > t[month]) && (!(4 != o.length || 0 == year || year < minYear || year > maxYear) && 0 != isInteger(stripCharsInBag(e, dtCh))));
    }
    
    function isEmail(e) {
        return /^[a-zA-Z_0-9-'\+~]+(\.[a-zA-Z_0-9-'\+~]+)*@([a-zA-Z_0-9-]+\.)+[a-zA-Z]{2,7}$/.test(e);
    }
    
    function isColor(e) {
        var t, i = 0, a = e.replace(/ +/g, "").match(/(rgba?)|(\d+(\.\d+)?%?)|(\.\d+)/g);
        if (a && 3 < a.length) {
            for (;i < 3; ) {
                if ((t = -1 != (t = a[++i]).indexOf("%") ? Math.round(2.55 * parseFloat(t)) : parseInt(t)) < 0 || 255 < t) return NaN;
                a[i] = t;
            }
            if (0 === e.indexOf("rgba")) {
                if (null == a[4] || a[4] < 0 || 1 < a[4]) return NaN;
            } else if (a[4]) return NaN;
            return a[0] + "(" + a.slice(1).join(",") + ")";
        }
        return NaN;
    }
    
    function isURL(e) {
        return urlPattern = /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/,
        e.match(urlPattern);
    }
    
    function stripe(e) {
        $("table." + e + " tr").each(function(e) {
            e % 2 ? $(this).addClass("alt") : $(this).removeClass("alt");
        }), $("div.mura-grid." + e + " dl").each(function(e) {
            e % 2 ? $(this).addClass("alt") : $(this).removeClass("alt");
        });
    }
    
    function toggleDisplay(e, t, i) {
        "none" == document.getElementById(e).style.display ? (document.getElementById(e).style.display = "",
        document.getElementById(e + "Link") && (document.getElementById(e + "Link").innerHTML = "[" + i + "]")) : (document.getElementById(e).style.display = "none",
        document.getElementById(e + "Link") && (document.getElementById(e + "Link").innerHTML = "[" + t + "]"));
    }
    
    function openDisplay(e, t) {
        if ("none" == document.getElementById(e).style.display) {
            if ($("#" + e).slideDown(), "editAdditionalTitles" == e && $("#alertTitleSuccess").hide(),
            document.getElementById(e + "Link")) document.getElementById(e + "Link").innerHTML = "[" + t + "]";
            document.getElementById(e).style.display = "";
        }
    }
    
    function toggleDisplay2(e, t) {
        document.getElementById(e).style.display = 1 == t ? "" : "none";
    }
    
    function validate(e) {
        return validateForm(e);
    }
    
    function getValidationFieldName(e) {
        return null != e.getAttribute("data-label") ? e.getAttribute("data-label") : null != e.getAttribute("label") ? e.getAttribute("label") : e.getAttribute("name");
    }
    
    function getValidationIsRequired(e) {
        return null != e.getAttribute("data-required") ? "true" == e.getAttribute("data-required").toLowerCase() : null != e.getAttribute("required") && "true" == e.getAttribute("required").toLowerCase();
    }
    
    function getValidationMessage(e, t) {
        return null != e.getAttribute("data-message") ? e.getAttribute("data-message") + "<br/>" : null != e.getAttribute("message") ? e.getAttribute("message") + "<br/>" : getValidationFieldName(e).toUpperCase() + t + "<br/>";
    }
    
    function getValidationType(e) {
        return null != e.getAttribute("data-validate") ? e.getAttribute("data-validate").toUpperCase() : null != e.getAttribute("validate") ? e.getAttribute("validate").toUpperCase() : "";
    }
    
    function hasValidationMatchField(e) {
        return null != e.getAttribute("data-matchfield") && "" != e.getAttribute("data-matchfield") || null != e.getAttribute("matchfield") && "" != e.getAttribute("matchfield");
    }
    
    function getValidationMatchField(e) {
        return null != e.getAttribute("data-matchfield") ? e.getAttribute("data-matchfield") : null != e.getAttribute("matchfield") ? e.getAttribute("matchfield") : "";
    }
    
    function hasValidationRegex(e) {
        return null != e.value && (null != e.getAttribute("data-regex") && "" != e.getAttribute("data-regex") || (null != e.getAttribute("regex") && "" != e.getAttribute("regex") || void 0));
    }
    
    function getValidationRegex(e) {
        return null != e.getAttribute("data-regex") ? e.getAttribute("data-regex") : null != e.getAttribute("regex") ? e.getAttribute("regex") : "";
    }
    
    function validateForm(e) {
        var t, i, a = "", n = !1, o = "", r = e.getElementsByTagName("input");
        for (f = 0; f < r.length; f++) if (theField = r[f], o = getValidationType(theField),
        "" == theField.style.display) if (getValidationIsRequired(theField) && "" == theField.value) n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " is required."); else if ("" != o) if ("EMAIL" != o || "" == theField.value || isEmail(theField.value)) if ("NUMERIC" == o && "" != theField.value && isNaN(theField.value)) isNaN(theField.value.replace(/\$|\,|\%/g, "")) ? (n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " must be numeric.")) : theField.value = theField.value.replace(/\$|\,|\%/g, ""); else if ("COLOR" == o && "" != theField.value) isColor(theField.value) || (n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " is not a valid color.")); else if ("URL" == o && "" != theField.value) isURL(theField.value) || (n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " is not a valid URL.")); else if ("REGEX" == o && "" != theField.value && hasValidationRegex(theField)) {
            var l = new RegExp(getValidationRegex(theField));
            theField.value.match(l) || (n || (n = !0, t = f, i = "input"), a += getValidationMessage(theField, " is not valid."));
        } else "MATCH" == o && hasValidationMatchField(theField) && theField.value != e[getValidationMatchField(theField)].value ? (n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " must match" + getValidationMatchField(theField) + ".")) : "DATE" != o && "DATETIME" != o || "" == theField.value || isDate(theField.value) || (n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " must be a valid date [MM/DD/YYYY].")); else n || (n = !0,
        t = f, i = "input"), a += getValidationMessage(theField, " must be a valid email address.");
        var s = e.getElementsByTagName("textarea");
        for (f = 0; f < s.length; f++) if (theField = s[f], o = getValidationType(theField),
        "" == theField.style.display && getValidationIsRequired(theField) && "" == theField.value) n || (n = !0,
        t = f, i = "textarea"), a += getValidationMessage(theField, " is required."); else if ("" != o && "REGEX" == o && "" != theField.value && hasValidationRegex(theField)) {
            l = new RegExp(getValidationRegex(theField));
            theField.value.match(l) || (n || (n = !0, t = f, i = "input"), a += getValidationMessage(theField, " is not valid."));
        }
        var d = e.getElementsByTagName("select");
        for (f = 0; f < d.length; f++) theField = d[f], o = getValidationType(theField),
        "" == theField.style.display && getValidationIsRequired(theField) && "" == theField.options[theField.selectedIndex].value && (n || (n = !0,
        t = f, i = "select"), a += getValidationMessage(theField, " is required."));
        return "" == a || ("input" == i ? r[t].focus() : "textarea" == i ? s[t].focus() : "select" == i && d[t].focus(),
        $("#alertDialogMessage").html(a), $("#alertDialog").attr("title", "Alert"), $("#alertDialog").dialog({
            resizable: !1,
            modal: !0,
            position: getDialogPosition(),
            buttons: {
                Ok: {
                    click: function() {
                        $(this).dialog("close"), "input" == i ? r[t].focus() : "textarea" == i ? s[t].focus() : "select" == i && d[t].focus();
                    },
                    text: "OK",
                    class: "mura-primary"
                }
            }
        }), !1);
    }
    
    function submitForm(e, t, i) {
        var a = i, n = e;
        if (validateForm(e)) {
            if (void 0 !== t && "delete" != t) {
                var o = e.getElementsByTagName("input");
                for (f = 0; f < o.length; f++) "action" == o[f].getAttribute("name") && o[f].setAttribute("value", t);
            } else if ("delete" == t) return $("#alertDialogMessage").html(a), $("#alertDialog").dialog({
                modal: !0,
                position: getDialogPosition(),
                resizable: !1,
                dialogClass: "dialog-warning",
                width: 400,
                buttons: {
                    Yes: {
                        click: function() {
                            $(this).dialog("close");
                            var e = n.getElementsByTagName("input");
                            for (f = 0; f < e.length; f++) "action" == e[f].getAttribute("name") && e[f].setAttribute("value", t);
                            n.submit();
                        },
                        text: "Yes",
                        class: "mura-primary"
                    },
                    No: function() {
                        $(this).dialog("close");
                    }
                }
            }), !1;
            if ("undefined" != typeof htmlEditorType && "fckeditor" != htmlEditorType) for (var r in CKEDITOR.instances) void 0 !== CKEDITOR.instances[r] && null != CKEDITOR.instances[r] && $("#" + r).length && CKEDITOR.instances[r].updateElement();
            actionModal(function() {
                e.submit(), formSubmitted = !0;
            });
        }
        return !1;
    }
    
    function testEmail( e ){
        e.preventDefault();
        var pars = 'muraAction=cArch.emailTest&compactDisplay=true';
    
        $("#emailTestDialog").remove();
        $("body").append('<div id="emailTestDialog" title="Loading..." style="display:none"></div>');
        
        // get current email form element values
        let mailSettings = {};
    
            mailSettings.mailSmtpPort = $('input[name="MailServerSMTPPort"]').val();
            mailSettings.mailHost = $('input[name="MailServerIP"]').val();
            mailSettings.mailUsername = $('input[name="MailServerUserName"]').val();
            mailSettings.mailPassword = $('input[name="MailServerPassword"]').val();
            mailSettings.mailUseTLS = $('input[name="mailServerTLS"]:checked').val();
            mailSettings.mailUseSSL = $('input[name="mailServerSSL"]:checked').val();

        var modalUrl = "index.cfm?muraAction=cArch.emailTest&compactDisplay=true";
    
    
        $("#emailTestDialog").dialog({
            resizable: false,
            modal: true,
            title: 'Testing Email Connection',
            width: 400,
            position: getDialogPosition(),
            open: function() {
                $("#emailTestDialog").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
                
                $("#emailTestDialog .load-inline").spin(spinnerArgs2);
    
                $.post( Mura.apiEndpoint + '?method=generateCSRFTokens', {context: 'testEmail'}, function( data ) {
                    var csrf_token = data.data.csrf_token;
                    var csrf_token_expires = data.data.csrf_token_expires;

                    mailSettings.csrf_token = csrf_token;
                    mailSettings.csrf_token_expires = csrf_token_expires;

                    $.post( modalUrl, mailSettings, function( data ) {
                        $("#emailTestDialog .load-inline").spin(false);
                        $('#emailTestDialog').html(data);
                    }).fail(function(response) {
                        $("#emailTestDialog .load-inline").spin(false);
                        $('#emailTestDialog').html(response.responseText);
                    });
                }).fail(function(response) {
                    $("#emailTestDialog .load-inline").spin(false);
                    $('#emailTestDialog').html("Authentication failed, please try again.");
                });

            },
            close: function() {
                $(this).dialog("destroy");
                $("#emailTestDialog").remove();
            }
        });
    
    }
    
    function actionModal(e) {
        return $("body").append('<div id="action-modal" class="modal-backdrop fade in"></div>'),
        $("#action-modal").spin(spinnerArgs), e && ("string" == typeof e ? location.href = e : e()),
        !1;
    }
    
    function preview(e, t) {
        return newWindow = "" == t ? window.open(e, "previewWin") : window.open(e, "previewWin", t),
        !newWindow || newWindow.closed || void 0 === newWindow.closed ? alertDialog("pop-up window has been blocked for this site,Disable blocking pop-up windows to see the Site Preview") : newWindow.focus(),
        !1;
    }
    
    function createCookie(e, t, i) {
        if (i) {
            var a = new Date();
            a.setTime(a.getTime() + 24 * i * 60 * 60 * 1e3);
            var n = "; expires=" + a.toGMTString();
        } else n = "";
        "undefined" != typeof location && "https:" == location.protocol ? secure = "; secure" : secure = "",
        document.cookie = e + "=" + t + n + "; path=/" + secure;
    }
    
    function readCookie(e) {
        for (var t = e + "=", i = document.cookie.split(";"), a = 0; a < i.length; a++) {
            for (var n = i[a]; " " == n.charAt(0); ) n = n.substring(1, n.length);
            if (0 == n.indexOf(t)) return unescape(n.substring(t.length, n.length));
        }
        return "";
    }
    
    function eraseCookie(e) {
        createCookie(e, "", -1);
    }
    
    newWindow = null;
    
    var HTMLEditorLoadCount = 0;
    
    function setHTMLEditors() {
        var e = document.getElementsByTagName("textarea");
        new Array();
        for (i = 0; i < e.length; i++) if ("htmlEditor" == e[i].className && !e[i].getAttribute("mura-inprocess")) {
            e[i].setAttribute("mura-inprocess", "true");
            var t = CKEDITOR.instances[e[i].id];
            void 0 !== t && null != t && CKEDITOR.remove(t), "" == $(document.getElementById(e[i].id)).val() && $(document.getElementById(e[i].id)).val("<p></p>");
            var a = e[i].getAttribute("data-toolbar") || "Default";
            $(document.getElementById(e[i].id)).ckeditor({
                toolbar: a,
                customConfig: "config.js.cfm"
            }, htmlEditorOnComplete);
        }
    }
    
    function htmlEditorOnComplete(e) {
        $(e).ckeditorGet().resetDirty();
        var t = CKEDITOR.instances;
        HTMLEditorLoadCount++;
        var i = 0;
        for (k in t) i++;
        try {
            document.getElementById("actionButtons").style.display = i <= HTMLEditorLoadCount ? "block" : "none";
        } catch (e) {}
    }
    
    function setDatePickers(e, t, i) {
        if (null == $.datepicker.regional[t]) var a = t.substring(0, 2); else a = t;
        null != $.datepicker.regional[a] ? $(e).each(function(e) {
            $(this).datepicker($.datepicker.regional[a]).datepicker("option", "changeYear", !0).datepicker("option", "changeMonth", !0);
        }) : $(e).each(function(e) {
            $(this).datepicker($.datepicker.regional[""]).datepicker("option", "changeYear", !0).datepicker("option", "changeMonth", !0);
        }), $(e).each(function(e) {
            "mura-datepicker-displayStart" == $(this).attr("id") && "" == $(this).val() && $(this).datepicker("setDate", new Date());
        });
    }
    
    function setColorPickers(e) {
        $(e).each(function(e) {
            $(this).colorpicker({
                align: 'left'
            });
        });
    }
    
    function setToolTips(e) {
        "function" == typeof $(e).tooltip && $(e).tooltip({
            selector: "a[rel=tooltip]"
        }), $(e + " a[rel=tooltip]").click(function(e) {
            return e.preventDefault(), !1;
        }), $(e + ' [data-toggle="popover"]').popover("destroy").popover({
            trigger: "hover",
            html: !0
        });
    }
    
    function setTabs(t, e) {
        if ($(".tab-preloader").spin(spinnerArgs2), $(t + " a").click(function(e) {
            e.preventDefault(), $(this).tab("show");
        }), "" != window.location.hash) $(t + ' a[href="' + window.location.hash + '"]').tab("show"),
        window.setTimeout(function() {
            $("a span.display-tab").html('<i class="mi-chevron-down"></i>');
        }, 1); else if (void 0 !== e) try {
            $(t + " li::nth-child(" + (e + 1) + ") a").tab("show");
        } catch (e) {
            $(t + " li:first a").tab && $(t + " li:first a").tab("show");
        } else $(t + " li:first a").tab("show");
        $(".tab-preloader").hide().spin(!1);
    }
    
    function setAccordions(e, t) {
        $(e).each(function(e) {
            null != t ? $(this).accordion({
                active: t
            }) : $(this).accordion();
        });
    }
    
    function setCheckboxTrees() {
        $(".checkboxTree").each(function() {
            $(this).collapsibleCheckboxTree({
                checkParents: !1,
                checkChildren: !1,
                uncheckChildren: !0,
                initialState: "default"
            });
        });
    }
    
    function openFileMetaData(t, i, a, n) {
        try {
            "undefined" == typeof fileMetaDataAssign && (fileMetaDataAssign = {}), $("#newFileMetaContainer").remove(),
            $("body").append('<div id="newFileMetaContainer" title="Loading..." style="display:none"><div id="newFileMeta"><div class="load-inline"></div></div></div>');
            var e = $.ui.dialog.prototype._focusTabbable;
            $.ui.dialog.prototype._focusTabbable = function() {}, $("#newFileMetaContainer").dialog({
                resizable: !1,
                modal: !0,
                width: 600,
                title: "Edit Image Properties",
                position: getDialogPosition(),
                buttons: {
                    Cancel: function() {
                        $(this).dialog("close");
                    },
                    Save: {
                        click: function() {
                            var e = {
                                exifpartial: {}
                            };
                            $(".filemeta").each(function() {
                                e[$(this).attr("data-property")] = $(this).val();
                            }), $(".exif").each(function() {
                                e.exifpartial[$(this).attr("data-property")] = $(this).val();
                            }), e.setasdefault = $("#filemeta-setasdefault").is(":checked"), fileMetaDataAssign[n] = e,
                            $("#filemetadataassign").val(JSON.stringify(fileMetaDataAssign)), $(this).dialog("close");
                        },
                        text: "Save",
                        class: "mura-primary"
                    }
                },
                open: function() {
                    $(".ui-widget-overlay").css("z-index", 500), $(".ui-dialog").css("z-index", 501),
                    $("#newFileMetaContainer").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
                    var e = "muraAction=cArch.loadfilemetadata&fileid=" + i + "&property=" + n + "&contenthistid=" + t + "&siteid=" + a + "&cacheid=" + Math.random();
                    $("#newFileMetaContainer .load-inline").spin(spinnerArgs2), Mura.get("index.cfm?" + e).then(function(e) {
                        if (-1 != e.indexOf("mura-primary-login-token") && (location.href = "./"), $("#newFileMetaContainer .load-inline").spin(!1),
                        $("#newFileMetaContainer").html(e), n in fileMetaDataAssign) {
                            var t = fileMetaDataAssign[n];
                            for (var i in t) $('.filemeta[data-property="' + i + '"]').val(t[i]);
                            $("#filemeta-setasdefault").prop("checked", t.setasdefault);
                        }
                        $("#newFileMetaContainer .htmlEditor").ckeditor({
                            toolbar: "Basic",
                            height: 100,
                            customConfig: "config.js.cfm"
                        }, htmlEditorOnComplete), setTabs("#newFileMetaContainer.tabs", 0), setDatePickers(".datepicker", dtLocale),
                        $("#newFileMetaContainer").dialog("option", "position", getDialogPosition()), $(".filemeta:first").focus();
                    }, function(e) {
                        $("#newFileMetaContainer").html(e.responseText), $("#newFileMetaContainer").dialog("option", "position", getDialogPosition());
                    });
                },
                close: function() {
                    $(this).dialog("destroy"), $("#newFileMetaContainer").remove(), $.ui.dialog.prototype._focusTabbable = e;
                }
            });
        } catch (e) {
            console.log(e);
        }
        return !1;
    }
    
    function setFileSelectors() {
        $(".mura-file-selector").fileselector();
    }
    
    function alertDialog(e, t, i, a, n) {
        a = a || 450;
        if ("object" == typeof e) {
            var o = e;
            e = o.message || "Message not defined", t = o.okAction || function() {}, i = o.title || "Alert",
            a = o.width || 0;
        }
        i = i || "Alert";
        var r = {
            dialogClass: n = n || "dialog-warning",
            resizable: !1,
            modal: !0,
            position: getDialogPosition(),
            buttons: {
                Ok: {
                    click: function() {
                        $(this).dialog("close"), t && ("function" == typeof t ? t() : "string" == typeof t && "" != t && actionModal(t));
                    },
                    text: "OK",
                    class: "mura-primary"
                }
            }
        };
        return a && (r.width = a), $("#alertDialog").attr("title", i), $("#alertDialogMessage").html(e),
        $("#alertDialog").dialog(r), !1;
    }
    
    function confirmDialog(e, t, i, a, n, o, r, l) {
        n = n || 450;
        if ("object" == typeof e) {
            var s = e;
            e = s.message || "Message not defined", s.yesAction && (t = s.yesAction), s.noAction && (i = s.noAction),
            a = s.title || "Alert", n = s.width || 0;
        }
        a = a || "Alert", o = o || "OK", r = r || "Cancel";
        var d = {
            dialogClass: l = l || "dialog-confirm",
            resizable: !1,
            modal: !0,
            position: getDialogPosition(),
            buttons: {
                No: {
                    click: function() {
                        void 0 !== i && "" != i ? "function" == typeof i ? i() : actionModal(i) : $(this).dialog("destroy");
                    },
                    text: r,
                    class: "mura-cancel"
                },
                Yes: {
                    click: function() {
                        $(this).dialog("close"), "function" == typeof t ? t() : "" != t && actionModal(t);
                    },
                    text: o,
                    class: "mura-primary"
                }
            },
            close: function(e, t) {
                $(this).dialog("destroy");
            }
        };
        return n && (d.width = n), $("#alertDialog").attr("title", a), $("#alertDialogMessage").html(e),
        $("#alertDialog").dialog(d), !1;
    }
    
    !function(r) {
        var a = function(e, t) {
            var i = this.$element = r(e), a = this.options = r.extend({}, r.fn.fileselector.defaults, t);
            r(this.$element).attr("data-name") && (this.options.file = this.$element.attr("data-name"));
            var n = function(e) {
                var t = "muraAction=cArch.assocfiles&compactDisplay=true&siteid=" + i.attr("data-siteid") + "&fileid=" + i.attr("data-fileid") + "&type=" + i.attr("data-filetype") + "&contentid=" + i.attr("data-contentid") + "&property=" + i.attr("data-property") + "&keywords=" + e + "&cacheid=" + Math.random();
                i.find(".mura-file-existing").html('<div class="load-inline"></div>'), i.find(".load-inline").spin(spinnerArgs2),
                r.ajax("index.cfm?" + t).done(function(e) {
                    i.find(".load-inline").spin(!1), i.find(".mura-file-existing").html(e);
                    var t = i.find(".mura-file-existing").find(".filesearch").val();
                    i.find(".mura-file-existing").find(".filesearch").focus().val("").val(t), i.find(".mura-file-existing").find(".filesearch").keypress(function(e) {
                        if (13 == e.which) {
                            i.find(".mura-file-existing").find(".filesearch");
                            var t = i.find(".mura-file-existing").find(".filesearch + .btn");
                            return r(t).trigger("click"), !1;
                        }
                    }), i.find(".mura-file-existing").find(".btn").click(function() {
                        n(i.find(".mura-file-existing").find(".filesearch").val());
                    }), setTabs("#selectAssocImageResults-" + i.attr("data-property"), 0);
                }).fail(function(e) {
                    i.find(".load-inline").spin(!1), i.find(".mura-file-existing").html(e.responseText);
                });
            }, o = function(e) {
                i.find(".mura-file-option").find("input").val(""), i.find(".mura-file-option").find(".btn").hide(),
                i.find(".mura-file-option").hide(), i.find(".mura-file-" + e.toLowerCase()).show(),
                i.find(".mura-file-option").find("input").attr("name", ""), i.find(".mura-file-" + e.toLowerCase()).find("input").attr("name", a.file);
            };
            r(this.$element).find("button.mura-file-type-selector").click(function() {
                o(r(this).val()), "existing" == r(this).val().toLowerCase() ? n("") : (i.find(".mura-file-existing").html('<div class="load-inline"></div>'),
                i.find(".load-inline").spin(spinnerArgs2)), r(this).hasClass("btn") && (r(this).addClass("focus").addClass("onstate").addClass("active"),
                r(this).siblings(".btn").removeClass("focus").removeClass("active").removeClass("onstate"));
            }), i.find(".mura-file-option").find("input").change(function() {
                /^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))+(.jpg|.jpeg|.png|.gif|.svg)$/.test(r(this).val().toLowerCase()) || /(http(s?):)|([/|.|\w|\s])*\.(?:jpg|jpeg|gif|png|svg)/.test(r(this).val().toLowerCase()) ? r(this).parent().find(".file-meta-open").show() : r(this).parent().find(".file-meta-open").hide();
            }), o("Upload");
        };
        r.fn.fileselector = function(i) {
            return this.each(function() {
                var e = r(this), t = e.data("fileselector");
                t || e.data("fileselector", t = new a(this, i));
            });
        }, r.fn.fileselector.defaults = {
            file: "newfile"
        }, r.fn.fileselector.Constructor = a;
    }(window.jQuery);
    
    var start = new Date();
    
    start = Date.parse(start) / 1e3;
    
    var sessionTimeout = 10800;
    
    function CountDown() {
        var e = new Date();
        e = Date.parse(e) / 1e3;
        var t = parseInt(sessionTimeout - (e - start), 10), i = Math.floor(t / 3600), a = Math.floor((t - 3600 * i) / 60), n = t - (3600 * i + 60 * a);
        a = a <= 9 ? "0" + a : a, n = n <= 9 ? "0" + n : n, null != document.getElementById("clock").innerHTML && (document.getElementById("clock").innerHTML = i + ":" + a + ":" + n),
        0 < t ? timerID = setTimeout("CountDown()", 100) : null != document.getElementById("clock").innerHTML && (document.getElementById("clock").innerHTML = "0:0:0");
    }
    
    function fileManagerPopUp() {
        return false;
    }
    
    function fileManagerCreate() {}
    
    function loadjscssfile(e, t) {
        if ("js" == t) (i = document.createElement("script")).setAttribute("type", "text/javascript"),
        i.setAttribute("src", e); else if ("css" == t) {
            var i;
            (i = document.createElement("link")).setAttribute("rel", "stylesheet"), i.setAttribute("type", "text/css"),
            i.setAttribute("href", e);
        }
        void 0 !== i && document.getElementsByTagName("head")[0].appendChild(i);
    }
    
    function getDialogPosition() {
        return {
            my: "center",
            at: "center",
            of: window,
            collision: "fit"
        };
    }
    
    function openPreviewDialog(e) {
        var t = e;
        t = -1 == t.indexOf("?") ? e + "?muraadminpreview" : e + "&muraadminpreview";
        var i = [ "top", 20 ], a = $('<div id="mura-preview-container"></div>').html('<iframe id="preview-dialog" style="border: 0; background:#fff;" src="' + t + '&mobileFormat=false" width="1075" height="600" allowfullscreen></iframe>').dialog({
            width: 1105,
            height: 600,
            modal: !0,
            title: "Preview",
            position: i,
            resize: function(e, t) {
                $("#preview-dialog").attr("width", t.size.width - 25);
            },
            close: function() {
                $(a).dialog("destroy"), $("#mura-preview-container").remove(), $("#mura-preview-device-selector").remove();
            },
            open: function() {
                var e = '<div id="mura-preview-device-selector"><p>Preview Mode</p>';
                e += '<a class="mura-device-standard active" data-height="600" data-width="1075" data-mobileformat="false"><i class="mi-desktop"></i></a>',
                e += '<a class="mura-device-tablet" data-height="600" data-width="768" data-mobileformat="false"><i class="mi-tablet"></i></a>',
                e += '<a class="mura-device-tablet-landscape" data-height="480" data-width="1024" data-mobileformat="false"><i class="mi-tablet mi-rotate-270"></i></a>',
                e += '<a class="mura-device-phone" data-height="480" data-width="320" data-mobileformat="true"><i class="mi-mobile-phone"></i></a>',
                e += '<a class="mura-device-phone-landscape" data-height="250" data-width="520" data-mobileformat="true"><i class="mi-mobile-phone mi-rotate-270"></i></a>',
                e += "</div>";
                $(".ui-dialog").prepend(e), $("#mura-preview-device-selector a").bind("click", function() {
                    var e = $(this).data();
                    return $(a).dialog("option", "width", e.width + 30), $(a).dialog("option", "height", e.height + 124),
                    $("#preview-dialog").attr("width", e.width).attr("height", e.height).attr("src", t + "&mobileFormat=" + e.mobileformat),
                    $(a).dialog("option", "position", i), $("#mura-preview-device-selector a").removeClass("active"),
                    $(this).addClass("active"), !1;
                });
            }
        });
        return !1;
    }
    
    function preloadimages(e) {
        for (var t = [], i = (e = "object" != typeof e ? [ e ] : e, 0); i < e.length; i++) t[i] = new Image(),
        t[i].src = e[i];
    }
    
    var spinnerArgs = {
        lines: 17,
        length: 7,
        width: 4,
        radius: 13,
        corners: 1,
        rotate: 0,
        color: "#696969",
        speed: .9,
        trail: 60,
        shadow: !1,
        hwaccel: !1,
        className: "spinner",
        zIndex: 2e9,
        top: "auto",
        left: "auto"
    }, spinnerArgs2 = {
        lines: 17,
        length: 7,
        width: 4,
        radius: 13,
        corners: 1,
        rotate: 0,
        color: "#696969",
        speed: .9,
        trail: 60,
        shadow: !1,
        hwaccel: !1,
        className: "spinner-alt",
        zIndex: 2e9,
        top: "auto",
        left: "auto",
        position: "relative"
    }, spinnerArgs3 = {
        lines: 17,
        length: 7,
        width: 4,
        radius: 13,
        corners: 1,
        rotate: 0,
        color: "#696969",
        speed: .9,
        trail: 60,
        shadow: !1,
        hwaccel: !1,
        className: "spinner-alt",
        zIndex: 2e9,
        top: "auto",
        left: "auto",
        position: "relative"
    };
    
    function removePunctuation(e) {
        $(e).val($(e).val().replace(/[^\w\s-]|/g, "").replace(/\s+/g, ""));
    }
    
    function setLowerCaseKeys(e) {
        for (var t = Object.keys(e), i = t.length; i--; ) {
            var a = t[i];
            a !== a.toLowerCase() && (e[a.toLowerCase()] = e[a], delete e[a]), "object" == typeof e[a.toLowerCase()] && setLowerCaseKeys(e[a.toLowerCase()]);
        }
        return e;
    }
    
    function setFinders(e) {
        if (window.self !== window.top) {
            Mura.getQueryStringParams(location.search);
            Mura(e).click(function() {
                var e = Mura(this);
                siteManager.openDisplayObjectModal("filebrowser/modal.cfm", {
                    target: e.data("target"),
                    completepath: e.data("completepath")
                });
            });
        } else $(e).unbind("click").on("click", function() {
            var a = Mura(this);
            $("#alertDialogMessage").html('<div id="MasaBrowserContainer"></div>'), $("#alertDialog").attr("title", "Select File"),
            $("#alertDialog").dialog({
                resizable: !1,
                width: 1e3,
                open: function(e, t) {
                    var i = this;
                    MuraFileBrowser.config.height = 600, MuraFileBrowser.config.selectMode = 2, MuraFileBrowser.config.resourcepath = "User_Assets",
                    MuraFileBrowser.config.selectCallback = function(e) {
                        var tgt = $('input[name="' + a.data("target") + '"]');
                        var serverpath=a.attr('data-serverpath');
                        if(serverpath && serverpath.toLowerCase() == 'true') {
                            if(e.url.indexOf(e.rootpath) >= 0){
                                var root=e.url.indexOf(webroot);
                                if(root >= 0) {
                                    tgt.val(e.url.substring(root,e.url.length));
                                } else {
                                    tgt.val(webroot + e.url.substring(e.rootpath.length,e.url.length));
                                }
                            } else {
                                tgt.val(webroot + e.url);
                            }
                        } else {
                            var url=e.url;
                            if(url.indexOf('?') >= 0) {
                                url=url + '&cd=' + Math.random();
                            } else {
                                url=url + '?cd=' + Math.random();
                            }
                            tgt.val(url);
                        }
                        tgt.trigger("change");
                        $(i).dialog("close");
                    }, MuraFileBrowser.render();
                },
                modal: !0,
                position: {
                    my: "center",
                    at: "top",
                    of: window,
                    collision: "fit"
                },
                buttons: {}
            });
        });
    }
    
    function wireupExterndalUIWidgets() {
        setFinders(".mura-finder"),"undefined" != typeof dtLocale && setDatePickers(".datepicker", dtLocale),
        "undefined" != typeof activetab && setTabs(".mura-tabs", activetab), setHTMLEditors(),
        "undefined" != typeof activepanel && setAccordions(".accordion", activepanel), setCheckboxTrees(),
        setColorPickers(".mura-colorpicker"), setToolTips(".container"), setFileSelectors();
    }
    
    function showTableControls(e) {
        var t = $(e).next(".actions-menu");
        $("td.actions div.actions-menu").not(".hide").addClass("hide"), $(t).removeClass("hide");
    }
    
    void 0 !== $.ui && ($.widget("custom.muraSiteSelector", $.ui.autocomplete, {
        _suggest: function(e) {
            var t = this.element.closest("ul");
            t.children("li").remove(), this._renderMenu(t, e), this.isNewMenu = !0, this.menu.refresh(),
            t.show(), this._resizeMenu(), this.options.autoFocus && this.menu.next();
        },
        _renderItem: function(e, t) {
            return $("<li>").append($("<a>").attr("href", "?muraAction=cDashboard.main&siteID=" + t.id).append($("<i>").addClass("mi-globe")).append(t.label)).appendTo(e);
        },
        options: {
            create: function(e) {
                $(e.target).keyup(function(e, t) {
                    var i = $(this);
                    i.val().length < $(this).data("customMuraSiteSelector").option("minLength") && i.closest("ul").children("li").remove();
                });
            }
        }
    }), $(function() {
        $('input[name="site-search"]').muraSiteSelector({
            source: function(e, t) {
                $.ajax({
                    url: "./index.cfm?muraAction=cnav.searchsitedata",
                    dataType: "json",
                    method: "POST",
                    data: {
                        searchString: e.term
                    },
                    success: function(e) {
                        return t(e);
                    }
                });
            },
            minLength: 2
        });
    })), $(function() {
        wireupExterndalUIWidgets();
    });
    