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
	verion 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

var siteManager = {

	formSubmitted: false,
	fileLockConfirmed: false,
	hasFileLock: false,
	dirtyRelatedContent: false,
	copyContentID: "",
	copySiteID: "",
	reloadURL: "",
	tablist: "",

	ckContent: function(draftremovalnotice) {

		if(typeof(saveFormBuilder) != "undefined") saveFormBuilder();

		if(document.contentForm.display.value == '2') {
			var tempStart = document.contentForm.displayStart.value;
			var tempStop = document.contentForm.displayStop.value;
			//alert(tempStart);
			if(isDate(tempStart, 'DISPLAY START DATE') == false) {

				alertDialog("Please enter a valid date in the 'Display Start Date' field");
				return false;
			} else if(tempStop != '' && isDate(tempStop, 'DISPLAY STOP DATE') == false) {

				alertDialog("Please enter a valid date in the 'Display Stop Date' field");
				return false;
			}
		} else {
			document.contentForm.displayStart.value = "";
			document.contentForm.displayStop.value = "";
		}

		if(document.contentForm.title.value == '') {
			if(document.contentForm.type.value == 'Component') {

				alertDialog("The form field 'Menu Title' is required");
				return false;

			} else if(document.contentForm.type.value == 'Form') {

				alertDialog("The form field 'Title' is required");
				return false;
			} else {

				alertDialog("The form field 'Long Title' is required");
				return false;
			}

		}

		if(document.contentForm.type.value == 'Link' && document.contentForm.body.value == '') {

			alertDialog("The form field 'URL' is required");
			return false;
		}


		if(document.contentForm.approved.value == 1 && draftremovalnotice != "" && !confirm(draftremovalnotice)) {
			return false;
		}

		if(typeof(this.hasFileLock) != 'undefined' && !this.fileLockConfirmed && this.hasFileLock && $("#file").val() != '') {
			confirmDialog(this.unlockfileconfirm, function() {
				//alert('true')
				$("#unlockwithnew").val("true");
				if(this.ckContent(false)) {
					formSubmitted = true;
					document.contentForm.submit();
				}
			}, function() {
				//alert('false')
				$("#unlockwithnew").val("false");
				if(this.ckContent(false)) {
					this.formSubmitted = true;
					document.contentForm.submit();
				}
			});

			this.fileLockConfirmed = true;
			return false;
		}

		if(document.contentForm.muraPreviouslyApproved == 0 && document.contentForm.approved.value == 1 && typeof(currentChangesetID) != 'undefined' && currentChangesetID != '') {

			confirmDialog(publishitemfromchangeset, function() {
				formSubmitted = true;
				document.contentForm.submit();
			});

			return false;

		} else {
			formSubmitted = true;
			return true;
		}

	},


	//  DHTML Menu for Site Summary
	DHTML: (document.getElementById || document.all || document.layers),
	lastid: "",
	getObj: function(name) {
		if(document.getElementById) {
			this.obj = document.getElementById(name);
			this.style = document.getElementById(name).style;
		} else if(document.all) {
			this.obj = document.all[name];
			this.style = document.all[name].style;
		} else if(document.layers) {
			this.obj = document.layers[name];
			this.style = document.layers[name];
		}
	},

	openNewContentMenu: function(contentid, siteid, topid, parentid, type) {

		$("#newContentMenuContainer").remove();
		$("body").append('<div id="newContentMenuContainer" title="Loading..." style="display:none"><div id="newContentMenu"><div class="load-inline"></div></div></div>');

		$("#newContentMenuContainer").dialog({
			resizable: false,
			modal: true,
			width: 552,
			position: getDialogPosition(),
			/*
buttons: {
					Cancel: function() {
							$( this ).dialog( "close" );
					}
				},
*/
			open: function() {
				$("#ui-dialog-title-newContentMenuContainer").html(newContentMenuTitle);
				$("#newContentMenuContainer").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
				var url = 'index.cfm';
				var pars = 'muraAction=cArch.loadnewcontentmenu&siteid=' + siteid + '&contentid=' + contentid + '&parentid=' + parentid + '&topid=' + parentid + '&ptype=' + type + '&cacheid=' + Math.random();
				$.get(url + "?" + pars, function(data) {
					$('#newContentMenuContainer').html(data);
					$("#newContentMenuContainer").dialog("option", "position", "center");
					setToolTips('.add-content-ui');

				});

			},
			close: function() {
				$(this).dialog("destroy");
				$("#newContentMenuContainer").remove();
			}
		});

		return false;
	},

	showMenu: function(id, newcontent, obj, contentid, topid, parentid, siteid, type) {
		var navperm = newcontent.toLowerCase();

		if(window.innerHeight) {
			var posTop = window.pageYOffset
		} else if(document.documentElement && document.documentElement.scrollTop) {
			var posTop = document.documentElement.scrollTop
		} else if(document.body) {
			var posTop = document.body.scrollTop
		}

		if(window.innerWidth) {
			var posLeft = window.pageXOffset
		} else if(document.documentElement && document.documentElement.scrollLeft) {
			var posLeft = document.documentElement.scrollLeft
		} else if(document.body) {
			var posLeft = document.body.scrollLeft
		}

		var xPos = this.findPosX(obj);
		var yPos = this.findPosY(obj);

		xPos = xPos + 20;

		document.getElementById('newZoom').style.display = 'none';
		document.getElementById('newZoomLink').style.display = 'none';
		document.getElementById('newCopy').style.display = 'none';
		document.getElementById('newCopyLink').style.display = 'none';
		//document.getElementById('newCopyAll').style.display='none';
		document.getElementById('newCopyAllLink').style.display = 'none';
		document.getElementById('newPaste').style.display = 'none';
		document.getElementById('newPasteLink').style.display = 'none';
		document.getElementById('newContentLink').style.display = 'none';
		document.getElementById('newContent').style.display = 'none';

		document.getElementById('newZoomLink').onclick = function() {
			siteManager.loadSiteManagerInTab(function() {
				return siteManager.loadSiteManager(siteid, contentid, '00000000000000000000000000000000000', '', '', type, 1);
			});
			return false;
		}
		document.getElementById('newZoom').style.display = '';
		document.getElementById('newZoomLink').style.display = '';

		if(navperm != 'none') {

			document.getElementById('newCopyLink').href = 'javascript:siteManager.copyThis(\'' + siteid + '\', \'' + contentid + '\',\'false\')';
			document.getElementById('newCopyAllLink').href = 'javascript:siteManager.copyThis(\'' + siteid + '\', \'' + contentid + '\',\'true\')';
			document.getElementById('newCopy').style.display = '';
			document.getElementById('newCopyLink').style.display = '';
			document.getElementById('newCopyAllLink').style.display = '';

		}

		if(navperm == 'author' || navperm == 'editor') {

			document.getElementById('newContentLink').onclick = function() {
				siteManager.openNewContentMenu(contentid, siteid, topid, parentid, type);
				return false;
			};

			//.href='index.cfm?muraAction=cArch.edit&contentid=&parentid=' + contentid + '&type=Page&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;

			if(this.copySiteID != "" && this.copyContentID != "") {
				document.getElementById('newPasteLink').href = 'javascript:siteManager.pasteThis(\'' + contentid + '\')';
				document.getElementById('newPaste').style.display = '';
				document.getElementById('newPasteLink').style.display = '';
			}

			//if (type!='File' && type!='Link'){
			document.getElementById('newContentLink').style.display = '';
			document.getElementById('newContent').style.display = '';
			document.getElementById('newCopy').style.border = '';
			/*} else {
				document.getElementById('newCopy').style.border='0';
				document.getElementById('newPaste').style.display='none';
				document.getElementById('newZoom').style.display='none';
			}*/
		}

		document.getElementById(id).style.top = yPos + "px";
		document.getElementById(id).style.left = xPos + "px";

		$("#" + id).removeClass("hide");

		if(this.astid != "" && this.lastid != id) {
			this.hideMenu(this.lastid);
		}

		this.navTimer = setTimeout('siteManager.hideMenu(siteManager.lastid);', 20000);
		this.lastid = id;
	},

	findPosX: function(obj) {
		var curleft = 0;
		if(obj.offsetParent) {
			while(obj.offsetParent) {
				curleft += obj.offsetLeft
				obj = obj.offsetParent;
			}
		} else if(obj.x) curleft += obj.x;
		return curleft;
	},

	findPosY: function(obj) {
		var curtop = 0;
		if(obj.offsetParent) {
			while(obj.offsetParent) {
				curtop += obj.offsetTop
				obj = obj.offsetParent;
			}
		} else if(obj.y) curtop += obj.y;
		return curtop;
	},

	keepMenu: function(id) {
		this.navTimer = setTimeout('hideMenu(lastid);', 20000);
		$('#' + id).removeClass('hide');
		//document.getElementById(id).style.display="block";
	},

	hideMenu: function(id) {
		if(this.navTimer != null) clearTimeout(this.navTimer);
		$('#' + id).addClass('hide');
		//document.getElementById(id).style.display="none";
	},

	deleteDisplayObject: function(regionid) {
		var selectedObjects = document.getElementById("selectedObjects" + regionid);
		var deleteIndex = selectedObjects.selectedIndex;
		var len = (selectedObjects.options.length > 1) ? selectedObjects.options.length - 1 : 0;
		if(deleteIndex < 0) return;

		selectedObjects.options[deleteIndex] = null;
		this.updateDisplayObjectList(regionid);

		if(selectedObjects.options.length) {
			selectedObjects.options[selectedObjects.options.length - 1].selected = true;
		}

	},

	updateDisplayObjectList: function(regionid) {
		var selectedObjects = document.getElementById("selectedObjects" + regionid);
		var objectList = document.getElementById("objectList" + regionid)
		objectList.value = "";

		for(var i = 0; i < selectedObjects.options.length; i++) {
			if(objectList.value != "") {
				objectList.value += "^" + selectedObjects.options[i].value;
			} else {
				objectList.value = selectedObjects.options[i].value;
			}
		}

	},

	moveDisplayObjectUp: function(regionid) {
		var selectedObjects = document.getElementById("selectedObjects" + regionid);
		var moverIndex = selectedObjects.selectedIndex;
		if(moverIndex < 1) return;

		var moveroption = document.createElement("option");
		var movedoption = document.createElement("option");

		moveroption.text = selectedObjects.options[moverIndex].text;
		moveroption.value = selectedObjects.value;
		moveroption.selected = "selected"

		movedoption.text = selectedObjects.options[moverIndex - 1].text;
		movedoption.value = selectedObjects.options[moverIndex - 1].value;

		selectedObjects[moverIndex - 1] = moveroption;
		selectedObjects[moverIndex] = movedoption;

		this.updateDisplayObjectList(regionid);
	},

	moveDisplayObjectDown: function(regionid) {
		var selectedObjects = document.getElementById("selectedObjects" + regionid);
		var moverIndex = selectedObjects.selectedIndex;
		if(moverIndex == selectedObjects.length - 1) return;

		var moveroption = document.createElement("option");
		var movedoption = document.createElement("option");

		moveroption.text = selectedObjects.options[moverIndex].text;
		moveroption.value = selectedObjects.options[moverIndex].value;
		moveroption.selected = "selected"

		movedoption.text = selectedObjects.options[moverIndex + 1].text;
		movedoption.value = selectedObjects.options[moverIndex + 1].value;


		selectedObjects.options[moverIndex + 1] = moveroption;
		selectedObjects.options[moverIndex] = movedoption;

		this.updateDisplayObjectList(regionid);

	},

	setTargetParams: function(frm) {
		var hp = (!isNaN(frm.height.value) && frm.height.value > 0) ? ",height=" + frm.height.value : "";
		var wp = (!isNaN(frm.width.value) && frm.width.value > 0) ? ",width=" + frm.width.value : "";
		var tp = (!isNaN(frm.top.value) && frm.top.value > 0) ? ",top=" + frm.top.value : "";
		var lp = (!isNaN(frm.left.value) && frm.left.value > 0) ? ",left=" + frm.left.value : "";
		var tb = (frm.toolbar.value != "") ? ",toolbar=" + frm.toolbar.value : "";
		var loc = (frm.location.value != "") ? ",location=" + frm.location.value : "";
		var dir = (frm.directories.value != "") ? ",directories=" + frm.directories.value : "";
		var st = (frm.status.value != "") ? ",status=" + frm.status.value : "";
		var mb = (frm.menubar.value != "") ? ",menubar=" + frm.menubar.value : "";
		var rs = (frm.resizable.value != "") ? ",resizable=" + frm.resizable.value : "";
		var hist = (frm.copyhistory.value != "") ? ",copyhistory=" + frm.copyhistory.value : "";
		var sb = (frm.scrollbars.value != "") ? ",scrollbars=" + frm.scrollbars.value : "";

		document.forms["contentForm"].targetParams.value = tb + loc + dir + st + mb + rs + hist + sb + wp + hp + tp + lp;
	},

	loadSiteParents: function(siteid, contentid, parentid, keywords, isNew) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.siteParents&compactDisplay=true&siteid=' + siteid + '&contentid=' + contentid + '&parentid=' + parentid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('#move');
		d.html('<div class="load-inline"><input type=hidden name=parentid value=' + parentid + ' ></div>');
		$.get(url + "?" + pars, function(data) {
			$('#move').html(data);
		});
	},

	loadAssocImages: function(siteid, fileid, contentid, keywords, isNew) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.assocImages&compactDisplay=true&siteid=' + siteid + '&fileid=' + fileid + '&contentid=' + contentid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('#selectAssocImage');
		$.get(url + "?" + pars, function(data) {
			$('#selectAssocImage').html(data);
			$('#selectAssocImageResults').slideDown();
		});
	},

	loadObjectClass: function(siteid, classid, subclassid, contentid, parentid, contenthistid) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadclass&compactDisplay=true&siteid=' + siteid + '&classid=' + classid + '&subclassid=' + subclassid + '&contentid=' + contentid + '&parentid=' + parentid + '&cacheid=' + Math.random();
		var d = $('#classList');

		d.html('<div class="load-inline"></div>');
		$.get(url + "?" + pars, function(data) {
			$('#classList').html(data);
			siteManager.availableObjectTemplate = "";
			siteManager.availalbeObjectParams = {};
			siteManager.availableObject = {};
			siteManager.availableObjectValidate = function() {
				return true
			};
		});
		return false;
	},

	getDisplayObjectClass: function(regionid) {
		var str = $('#selectedObjects' + regionid).val().toString();
		var a = str.split("~");
		return a[0];
	},

	getDisplayObjectID: function(regionid) {
		var str = $('#selectedObjects' + regionid).val().toString();
		var a = str.split("~");
		return a[2];
	},

	loadNotify: function(siteid, contentid, parentid) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadNotify&compactDisplay=true&siteid=' + siteid + '&contentid=' + contentid + '&parentid=' + parentid + '&cacheid=' + Math.random();
		var d = $('#selectNotify');
		if(d.html() == '') {
			d.show();
			d.html('<div class="load-inline"></div>');
			$.get(url + "?" + pars, function(data) {
				$('#selectNotify').html(data);
			});
		} else {
			d.toggle();
		}

		return false;
	},

	loadExpiresNotify: function(siteid, contenthistid, parentid) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadExpireNotify&compactDisplay=true&siteid=' + siteid + '&contenthistid=' + contenthistid + '&parentid=' + parentid + '&cacheid=' + Math.random();
		var d = $('#selectExpiresNotify');
		if(d.html() == '') {
			d.show();
			d.html('<div class="load-inline"></div>');
			$.get(url + "?" + pars, function(data) {
				$('#selectExpiresNotify').html(data);
			});
		} else {
			d.toggle();
		}

		return false;
	},


	loadRelatedContent: function(siteid, keywords, isNew) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadRelatedContent&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		/*if(keywords != ''){
		location.href="?" + pars;
		}*/
		var d = $('#selectRelatedContent');
		d.html('<div class="load-inline"></div>');
		$.get(url + "?" + pars, function(data) {
			$('#selectRelatedContent').html(data);
		});
	},


	addRelatedContent: function(contentID, contentType, title) {
		var tbody = document.getElementById('relatedContent').getElementsByTagName("TBODY")[0];
		var row = document.createElement("TR");
		row.id = "c" + contentID;
		var name = document.createElement("TD");
		name.appendChild(document.createTextNode(title));
		name.className = "var-width";
		var type = document.createElement("TD");
		type.appendChild(document.createTextNode(contentType));
		var admin = document.createElement("TD");
		admin.className = "actions";
		var deleteLink = document.createElement("A");
		deleteLink.setAttribute("href", "#");
		deleteLink.setAttribute("title", "Delete");
		deleteLink.onclick = function() {
			$("#c" + contentID).remove();
			stripe('stripe');
			return false;
		}

		var deleteIcon = document.createElement("I");	
		deleteIcon.setAttribute("class", "icon-remove-sign");

		deleteLink.appendChild(deleteIcon);

		var deleteUL = document.createElement("UL");
		deleteUL.className = "one";

		var deleteLI = document.createElement("LI");
		deleteLI.className = "delete";
		deleteLI.appendChild(deleteLink);
		deleteUL.appendChild(deleteLI);

		var content = document.createElement("INPUT");
		content.setAttribute("type", "hidden");
		content.setAttribute("name", "relatedContentID");
		content.setAttribute("value", contentID);
		admin.appendChild(content);
		admin.appendChild(deleteUL);
		row.appendChild(name);
		row.appendChild(type);
		row.appendChild(admin);
		tbody.appendChild(row);
		if($('#noFilters').length) $('#noFilters').hide();

		stripe('stripe');
		this.dirtyRelatedContent = true;

	},

	removeRelatedContent: function(contentID, confirmText) {
		if(confirm(confirmText)) {
			$("#" + contentID).remove();
			stripe('stripe');
			this.dirtyRelatedContent = true;
		}
		return false;
	},

	form_is_modified: function(oForm) {
		for(var i = 0; i < oForm.elements.length; i++) {
			var element = oForm.elements[i];
			var type = element.type;
			if(type == "checkbox" || type == "radio") {
				if(element.checked != element.defaultChecked) {
					//alert(type + ":" + element.name)
					return true;
				}
			} else if(type == "hidden" || type == "password" || type == "text" || type == "textarea") {
				if(element.value != element.defaultValue) {
					if(element.name != 'sdContent') {
						//alert(type + ":" + element.name)
						return true;
					}
				}
			}
			/*
	        else if (type == "select-one" || type == "select-multiple")
	        {
	            for (var j = 0; j < element.options.length; j++)
	            {
	                if (element.options[j].selected !=
	                    element.options[j].defaultSelected)
	                {
	                    return true;
	                } 
	            }
	        }
	        */
		}

		if(typeof(FCKeditorAPI) != 'undefined') {
			if(FCKeditorAPI.GetInstance('body') && FCKeditorAPI.GetInstance('body').IsDirty()) return true;
			if(FCKeditorAPI.GetInstance('summary') && FCKeditorAPI.GetInstance('summary').IsDirty()) return true;
			if(this.dirtyRelatedContent) return true;
		} else if(typeof(CKEDITOR) != 'undefined' && typeof(CKEDITOR.instances["body"]) != 'undefined') {
			var instance = CKEDITOR.instances["body"];
			if(instance.checkDirty()) {
				return true;
			}

		}

		return false;
	},

	copyThis: function(siteID, contentID, _copyAll) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.saveCopyInfo&siteid=' + siteID + '&contentid=' + contentID + '&copyAll=' + _copyAll + '&cacheid=' + Math.random();

		$.get(url + "?" + pars);

		this.copyContentID = contentID;
		this.copySiteID = siteID;
		this.copyAll = _copyAll;

		this.hideMenu('newContentMenu');
	},

	pasteThis: function(parentID) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.copy&compactDisplay=true&siteid=' + this.copySiteID + '&copyAll=' + this.copyAll + '&contentid=' + this.copyContentID + '&parentid=' + parentID + '&cacheid=' + Math.random();
		var d = $('#newPasteLink');
		d.css('background', 'url(assets/images/ajax-loader.gif) no-repeat 1px 5px;');
		this.reloadURL = $('#newZoomLink').attr("href");

		$.get(url + "?" + pars, function(data) {
			siteManager.loadSiteManagerInTab(

			function() {
				siteManager.loadSiteManager(siteManager.copySiteID, parentID, '00000000000000000000000000000000000', '', '', '', 1);
			});
		});
	},

	reloadPage: function() {
		if(reloadURL == '') {
			window.location.reload();
		} else {
			location.href = this.reloadURL;
		}
	},

	loadExtendedAttributes: function(contentHistID, type, subType, _siteID, _context, _themeAssetPath) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadExtendedAttributes&contentHistID=' + contentHistID + '&type=' + type + '&subType=' + subType + '&siteID=' + _siteID + '&tablist=' + siteManager.tablist + '&cacheid=' + Math.random();

		siteID = _siteID;
		context = _context;
		themeAssetPath = _themeAssetPath;
		//location.href=url + "?" + pars;
		$('.extendset-container').each(

		function() {
			if($(this).html() != '') {
				$(this).html('<div class="load-inline"></div>');
			}
		});

		$.get(url + "?" + pars, function(data) {
			siteManager.setExtendedAttributes(data);
		});

		return false;
	},

	setExtendedAttributes: function(data) {
		//alert(data);
		var r = eval("(" + data + ")");

		$.each(r, function(name, value) {
			//alert(name + ": " + value);
			$('#extendset-container-' + name).html(value);

		});

		if(r['default'] == '') {
			$('#tabExtendedAttributesLI').addClass('hide');
		} else {
			$('#tabExtendedAttributesLI').removeClass('hide');
		}

		if(!r.hassummary) {
			if(typeof hideSummaryEditor != 'undefined') {
				hideSummaryEditor();
			}
		} else {
			if(typeof showSummaryEditor != 'undefined') {
				showSummaryEditor();
			}
		}

		if(!r.hasbody) {
			if(typeof hideBodyEditor != 'undefined') {
				hideBodyEditor();
			}
		} else {
			if(typeof showBodyEditor != 'undefined') {
				showBodyEditor();
			}
		}

		this.checkExtendSetTargeting();
		setHTMLEditors(context, themeAssetPath);
		setDatePickers(".tab-content .datepicker", dtLocale);
		setColorPickers(".tab-content .colorpicker");
		setColorPickers(".tab-content .colorpicker");
		setToolTips(".tab-content");
	},

	checkExtendSetTargeting: function() {
		var extendSets = $('.extendset');
		var found = false;
		var started = false;
		var empty = true;

		if(extendSets.length) {
			for(var s = 0; s < extendSets.length; s++) {
				var extendSet = extendSets[s];

				if(extendSet.getAttribute("categoryid") != undefined && extendSet.getAttribute("categoryid") != "") {
					if(!started) {
						var categories = $('categoryContainer').getElementsByTagName('select');
						started = true;
					}

					for(var c = 0; c < categories.length; c++) {
						var cat = categories[c];
						var catID = categories[c].getAttribute("categoryid");
						var assignedID = extendSet.getAttribute("categoryid");
						if(!found && catID != null && assignedID.indexOf(catID) > -1) {
							found = true;
							membership = cat.value;
						}
					}

					if(found) {
						if(membership != "") {
							this.setFormElementsDisplay(extendSet, '');
							extendSet.style.display = '';
							empty = false;
						} else {
							this.setFormElementsDisplay(extendSet, 'none');
							extendSet.style.display = 'none';

						}
					} else {
						this.setFormElementsDisplay(extendSet, 'none');
						extendSet.style.display = 'none';

					}
				} else {
					this.setFormElementsDisplay(extendSet, '');
					extendSet.style.display = '';
					empty = false;


				}


				found = false;
			}

			if(empty) {
				$('#extendMessage').show();
				$('#extendDL').hide();
			} else {
				$('#extendMessage').hide();
				$('#extendDL').show();
			}

		}

	},

	resetExtendedAttributes: function(contentHistID, str, _siteID, _context, _themeAssetPath) {
		var dataArray = str.split("^");
		this.loadExtendedAttributes(contentHistID, dataArray[0], dataArray[1], _siteID, _context, _themeAssetPath);
		//alert(dataArray[1]);
		document.contentForm.type.value = dataArray[0];
		document.contentForm.subtype.value = dataArray[1];
	},

	setFormElementsDisplay: function(container, display) {
		var inputs = container.getElementsByTagName('input');
		//alert(inputs.length);
		if(inputs.length) {
			for(var i = 0; i < inputs.length; i++) {
				inputs[i].style.display = display;
				//alert(inputs[i].style.display);
			}
		}

		inputs = container.getElementsByTagName('textarea');

		if(inputs.length) {
			for(var i = 0; i < inputs.length; i++) {
				inputs[i].style.display = display;
			}
		}

		inputs = container.getElementsByTagName('select');

		if(inputs.length) {
			for(var i = 0; i < inputs.length; i++) {
				inputs[i].style.display = display;
			}
		}

	},

	loadCategoryFeatureStartStop: function(id, display, siteID) {
		var cat = $("#" + id);
		if(cat.html().length > 10) {
			cat.toggle();
		} else if(display == true) {
			var url = 'index.cfm';
			var idParam = id;
			var pars = 'muraAction=cArch.loadCategoryFeatureStartStop&id=' + idParam.replace(/editDates/, "") + '&siteID=' + siteID + '&cacheid=' + Math.random();
			cat.show();
			$.get(url + "?" + pars, function(data) {
				$("#" + id).html(data);
				setDatePickers("#" + id + " .datepicker", dtLocale);
				setToolTips("#" + id);
			});

		}
	},

	activeQuickEdit: false,

	loadSiteManager: function(siteid, topid, moduleid, sortby, sortdirection, ptype, startrow) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadSiteManager&siteid=' + siteid + '&topid=' + topid + '&moduleid=' + moduleid + '&sortby=' + sortby + '&sortdirection=' + sortdirection + '&ptype=' + ptype + '&startrow=' + startrow + '&cacheid=' + Math.random();
		$('#newContentMenu').addClass('hide');
		//$('#viewTabs a[href="#tabArchitectural"]').tab('show');
		//location.href=url + "?" + pars;
		var d = $('#gridContainer');
		if(!this.activeQuickEdit) {
			d.html('<div class="load-inline"></div>').show();
		}
		// return false;
		$.get(url + "?" + pars, function(data) {
			try {
				var r = eval("(" + data + ")");
				if(!siteManager.activeQuickEdit) {
					d.hide()
				}
				d.html(r.html);
				$('#newContentMenu').addClass('hide');
				stripe('stripe');
				siteManager.initQuickEdits();
				initDraftPrompt();
				setToolTips("#gridContainer");
				if(r.perm.toLowerCase() == "editor" && r.sortby.toLowerCase() == 'orderno') {	
					$("#sortableKids").sortable({
						stop: function(event, ui) {
							stripe('stripe');
							siteManager.setAsSorted();
							$(ui.item).removeClass('ui-draggable-dragging');
						},
						start: function(event, ui) {
							$(ui.item).addClass('ui-draggable-dragging');
						}
					});
					$("#sortableKids").disableSelection();
				}

			} catch(err) {
				if(data.indexOf('mura-primary-login-token') != -1) {
					location.href = './';
				}
				d.html(data);
			}

			if(!siteManager.activeQuickEdit) {
				d.hide().animate({
					'opacity': 'show'
				}, 1000);
			}
			siteManager.activeQuickEdit = false;
		});


		return false;
	},

	sectionLoading: false,

	loadSiteFlatByFilter: function() {
		flatViewArgs.type = $("#contentTypeFilter").val();
		var categoryid = [];
		var tag = [];

		$(".categories :checked").each(

		function() {
			categoryid.push($(this).val());
		});

		flatViewArgs.categoryid = categoryid.toString();

		$("#svTagCloud .active").each(

		function() {
			tag.push($(this).html());
		});

		flatViewArgs.tag = tag.toString();
		flatViewArgs.keywords = $("#contentKeywords").val();
		flatViewArgs.page = 1;
		flatViewArgs.filtered = true;
		this.loadSiteFlat(flatViewArgs);

	},

	loadSiteManagerInTab: function(loader) {
		archViewLoaded = true;
		window.scrollTo(0, 0);
		loader();
		$('#viewTabs a[href="#tabArchitectural"]').tab('show');
		//document.getElementById("newContentMenu").style.visibility="hidden"; 
		return false;
	},

	loadSiteFlat: function(args) {
		var url = 'index.cfm';
		var pars = 'muraAction=cArch.loadSiteFlat&cacheid=' + Math.random();

		//location.href=url + "?" + pars;
		var d = $('#flatViewContainer');

		d.html('<div class="load-inline"></div>');
		$('#newContentMenu').addClass('hide');

		$.post(url + "?" + pars, args, function(data) {

			if(data.indexOf('mura-primary-login-token') != -1) {
				location.href = './';
			}
			d.html(data);
			stripe('stripe');
			setCheckboxTrees();

			$("#svTagCloud a").click(

			function(event) {
				event.preventDefault();
				$(this).toggleClass('active');
			});

			$(".navSort a").click(

			function(event) {
				event.preventDefault();

				$(".sortNav .active").toggleClass('active');
				$(this).toggleClass('active');

				var sortby = $(this).attr("data-sortby");

				if(sortby == flatViewArgs.sortby) {
					if(flatViewArgs.sortdirection == "asc") {
						flatViewArgs.sortdirection = "desc";
					} else {
						flatViewArgs.sortdirection = "asc";
					}
				} else {
					flatViewArgs.sortby = sortby;

					switch(flatViewArgs.sortby) {
					case "menutitle":
						flatViewArgs.sortdirection = "asc";
						break;
					case "created":
					case "lastupdate":
					case "releasedate":
						flatViewArgs.sortdirection = "desc";
					}
				}

				flatViewArgs.page = 1;

				siteManager.loadSiteFlat(flatViewArgs)

			});

			$("#navReports a").click(

			function(event) {
				event.preventDefault();

				$(".navReports .active").toggleClass('active');
				$(this).toggleClass('active');

				var report = $(this).attr("data-report");

				if(
				(flatViewArgs.report == "mylockedfiles" || flatViewArgs.report == "lockedfiles") && !(report == "mylockedfiles" || report == "lockedfiles")) {
					flatViewArgs.type = "";
				}

				flatViewArgs.report = report;

				if(flatViewArgs.report == "mylockedfiles" || flatViewArgs.report == "lockedfiles") {
					flatViewArgs.type = "File";
				}

				flatViewArgs.page = 1;

				siteManager.loadSiteFlat(flatViewArgs)

			});

			$("#tabFlat .moreResults a").click(

			function(event) {
				event.preventDefault();

				$("#tabFlat .moreResults a").toggleClass('active');
				$(this).toggleClass('active');

				flatViewArgs.page = $(this).attr("data-page");

				siteManager.loadSiteFlat(flatViewArgs)

			});
			initDraftPrompt();

			d.hide().animate({
				'opacity': 'show'
			}, 1000);
		});

		return false;
	},

	loadSiteSection: function(node, startrow) {

		if(!this.sectionLoading) {
			this.sectionLoading = true;
			var url = 'index.cfm';
			var pars = 'muraAction=cArch.loadSiteSection&siteid=' + node.attr("data-siteid") + '&contentID=' + node.attr("data-contentid") + '&moduleid=' + node.attr("data-moduleid") + '&sortby=' + node.attr("data-sortby") + '&sortdirection=' + node.attr("data-sortdirection") + '&ptype=' + node.attr("data-type") + '&startrow=' + startrow + '&cacheid=' + Math.random();

			//location.href=url + "?" + pars;
			var icon = node.find("span:first");

			if(icon.hasClass('hasChildren closed')) {

				icon.removeClass('hasChildren closed');
				icon.addClass('hasChildren open');

				//d.find(".loadProgress").show();
				$.get(url + "?" + pars, function(data) {
					try {
						var r = eval("(" + data + ")");

						//d.find(".loadProgress").remove();
						node.find('.section:first').remove();
						node.append(r.html);

						$('#newContentMenu').addClass('hide');
						stripe('stripe');
						initDraftPrompt();
						siteManager.initQuickEdits();

						//The fadeIn in ie8 causes a rendering issue
						if(!(document.all && document.querySelector && !document.addEventListener)) {
							node.find('.section:first').hide().fadeIn("slow");
						}
					} catch(err) {
						if(data.indexOf('mura-primary-login-token') != -1) {
							location.href = './';
						}
						node.append(data);
					}

					siteManager.sectionLoading = false;
				});
			} else {

				icon.removeClass('hasChildren open');
				icon.addClass('hasChildren closed');

				$.get(url + "?" + pars);

				node.find('.section:first').fadeOut("fast", function() {
					node.find('.section:first').remove();
					stripe('stripe');
					$('#newContentMenu').addClass('hide');
					siteManager.sectionLoading = false;
				});

			}
		}
		return false;
	},

	refreshSiteSection: function(node, startrow) {
		if(!this.sectionLoading) {
			this.sectionLoading = true;
			var url = 'index.cfm';
			var pars = 'muraAction=cArch.refreshSiteSection&siteid=' + node.attr("data-siteid") + '&contentID=' + node.attr("data-contentid") + '&moduleid=' + node.attr("data-moduleid") + '&sortby=' + node.attr("data-sortby") + '&sortdirection=' + node.attr("data-sortdirection") + '&ptype=' + node.attr("data-type") + '&startrow=' + startrow + '&cacheid=' + Math.random();

			$.get(url + "?" + pars, function(data) {
				try {
					var r = eval("(" + data + ")");

					//d.find(".loadProgress").remove();
					node.find('.section:first').remove();
					node.append(r.html);

					$('#newContentMenu').addClass('hide');
					stripe('stripe');
					initDraftPrompt();
					siteManager.initQuickEdits();
				} catch(err) {
					if(data.indexOf('mura-primary-login-token') != -1) {
						location.href = './';
					}
					node.append(data);
				}

				siteManager.activeQuickEdit = false;
				siteManager.sectionLoading = false;
			});

		}
		return false;
	},

	setAsSorted: function() {
		$('#sorted').val('true');
		$('#sitemgr-reorder').fadeIn();
	},

	initQuickEdits: function() {
		$(".mura-quickEditItem").toggle(

		function(event) {
			event.preventDefault();
			if(!this.activeQuickEdit) {

				var attribute = $(this).attr("data-attribute");
				var node = $(this).parents("li:first");
				var url = 'index.cfm';
				var pars = 'muraAction=cArch.loadQuickEdit&siteid=' + siteid + '&contentID=' + node.attr("data-contentid") + '&attribute=' + attribute + '&cacheid=' + Math.random();

				//location.href='?' + pars;
				//images/icons/template_24x24.png
				$("#mura-quickEditor").remove();
				$("#selected").attr("id", "");
				$('#selectedIcon').attr("id", "").attr("src", "assets/images/icons/template_24x24.png");
				$(this).parent().prepend(quickEditTmpl);

				var qe = $("#mura-quickEditor")
				var dd = qe.parents("dd:first");

				dd.attr("id", "selected");

				$.get(url + "?" + pars, function(data) {
					if(data.indexOf('mura-primary-login-token') != -1) {
						location.href = './';
					}
					$("#mura-quickEditor").html(data);
					setDatePickers(".mura-quickEdit-datepicker", dtLocale, dtCh);
					setToolTips(".mura-quickEdit-datepicker");
					if($("#hasDraftsMessage").length) {
						dd.addClass("hasDraft");
					}

					if(attribute == 'template') {
						var img = dd.find("img:first");
						if(img.length) {
							img.attr("id", "selectedIcon").attr("src", "assets/images/icons/template_24x24-on.png")
						}
					}

				});
			}
		}, function(event) {
			event.preventDefault();
			siteManager.closeQuickEdit();
		});
	},

	saveQuickEdit: function() {
		this.activeQuickEdit = true;
		var attribute = $("#mura-quickEditor").parent().find(".mura-quickEditItem:first").attr("data-attribute");
		var node = $("#mura-quickEditor").parents("li:first");
		var url = 'index.cfm';

		var basePars = {
			'muraAction': 'cArch.saveQuickEdit',
			'siteID': siteID,
			'contentID': node.attr("data-contentid"),
			'attribute': attribute
		}

		if(attribute == 'isnav') {
			var attributeParams = {
				'isnav': $("#mura-quickEdit-isnav").val()
			}
		} else if(attribute == 'inheritObjects') {
			var attributeParams = {
				'inheritObjects': $("#mura-quickEdit-inheritobjects").val()
			}
		} else if(attribute == 'template') {
			var attributeParams = {
				'template': $("#mura-quickEdit-template").val(),
				'childTemplate': $("#mura-quickEdit-childtemplate").val()
			}
		} else if(attribute == 'display') {
			var attributeParams = {
				'display': $("#mura-quickEdit-display").val(),
				'displayStop': $("#mura-quickEdit-displayStop").val(),
				'stopHour': $("#mura-quickEdit-stopHour").val(),
				'stopMinute': $("#mura-quickEdit-stopMinute").val(),
				'stopDayPart': $("#mura-quickEdit-stopDayPart").val(),
				'displayStart': $("#mura-quickEdit-displayStart").val(),
				'startHour': $("#mura-quickEdit-startHour").val(),
				'startMinute': $("#mura-quickEdit-startMinute").val(),
				'startDayPart': $("#mura-quickEdit-startDayPart").val()
			}

		}

		var pars = $.extend({}, basePars, attributeParams);

		$("#mura-quickEditor").html('<img class="loader" src="assets/images/ajax-loader-big.gif" />');

		$.post('index.cfm', pars, function(data) {
			if(data.indexOf('mura-primary-login-token') != -1) {
				location.href = './';
			}
			var parentNode = node.parents("li:first");
			
			if(parentNode.parents('li:first').length) {
				siteManager.refreshSiteSection(parentNode, 1)
			} else {
				var topNode = $("#top-node").parents("li:first");
				siteManager.loadSiteManager(topNode.attr("data-siteid"), topNode.attr("data-contentid"), topNode.attr("data-moduleid"), topNode.attr("data-sortby"), topNode.attr("data-sortdirection"), topNode.attr("data-type"), 1);
			}
		});

	},

	closeQuickEdit: function() {
		$('#selected').attr("id", "");
		$('#selectedIcon').attr("id", "").attr("src", "assets/images/icons/template_24x24.png");
		$('.mura-quickEdit').remove();
	},

	initCategoryAssignments: function() {
		$(".mura-quickEditItem").toggle(

		function(event) {
			event.preventDefault();

			var node = $(this).parents("li:first");
			var cattrim = node.attr("data-cattrim");

			var categoryAssignment = {
				muraAction: 'cArch.loadCategoryAssignment',
				cattrim: node.attr("data-cattrim"),
				siteID: node.attr("data-siteid"),
				categoryID: node.attr("data-categoryid"),
				categoryAssignment: $('#categoryAssign' + cattrim).val(),
				featureStart: '',
				startHour: '',
				startMinute: '',
				startDayPart: '',
				featureStop: '',
				stopHour: '',
				stopMinute: '',
				stopDayPart: ''
			};

			if(categoryAssignment.categoryAssignment == '2') {
				$.extend(
				categoryAssignment, {
					featureStart: $('#featureStart' + cattrim).val(),
					startHour: $('#startHour' + cattrim).val(),
					startMinute: $('#startMinute' + cattrim).val(),
					startDayPart: $('#startDayPart' + cattrim).val(),
					featureStop: $('#featureStop' + cattrim).val(),
					stopHour: $('#stopHour' + cattrim).val(),
					stopMinute: $('#stopMinute' + cattrim).val(),
					stopDayPart: $('#stopDayPart' + cattrim).val()
				});
				//alert(JSON.stringify(categoryAssignment))
			}

			$("#mura-quickEditor").remove();
			$("#selected").attr("id", "");
			$('#selectedIcon').attr("id", "").attr("src", "assets/images/icons/template_24x24.png");
			$(this).parent().prepend(quickEditTmpl);

			var qe = $("#mura-quickEditor")
			var dd = qe.parents("dd:first");

			dd.attr("id", "selected");

			$.post("./index.cfm", categoryAssignment, function(data) {
				if(data.indexOf('mura-primary-login-token') != -1) {
					location.href = './';
				}
				$("#mura-quickEditor").html(data);
				setDatePickers(".mura-quickEdit-datepicker", dtLocale, dtCh);
				setToolTips(".mura-quickEdit-datepicker");
			});
		}, function(event) {
			event.preventDefault();
			siteManager.closeQuickEdit();
		});
	},

	saveCategoryAssignment: function() {
		var cattrim = $('#mura-quickEdit-cattrim').val();

		var categoryAssignment = {
			muraAction: 'cArch.loadCategoryFeatureStartStop',
			cattrim: cattrim,
			categoryAssignment: $('#mura-quickEdit-display').val(),
			featureStart: $('#mura-quickEdit-featureStart').val(),
			startHour: $('#mura-quickEdit-startHour').val(),
			startMinute: $('#mura-quickEdit-startMinute').val(),
			startDayPart: $('#mura-quickEdit-startDayPart').val(),
			featureStop: $('#mura-quickEdit-featureStop').val(),
			stopHour: $('#mura-quickEdit-stopHour').val(),
			stopMinute: $('#mura-quickEdit-stopMinute').val(),
			stopDayPart: $('#mura-quickEdit-stopDayPart').val(),
			siteid: siteid
		};

		//alert(JSON.stringify(categoryAssignment));
		$("#mura-quickEditor").html('<img class="loader" src="assets/images/ajax-loader-big.gif" />');

		$.post("./index.cfm", categoryAssignment, function(data) {
			if(data.indexOf('mura-primary-login-token') != -1) {
				location.href = './';
			}
			$('#categoryLabelContainer' + cattrim).html(data);
			siteManager.closeCategoryAssignment();
			setToolTips(".mura-quickEdit-datepicker");
			siteManager.initCategoryAssignments();
		});

	},

	closeCategoryAssignment: function() {
		$('#selected').attr("id", "");
		$('.mura-quickEdit').remove();
	},

	availableObjectTemplate: "",
	availalbeObjectParams: {},
	availableObject: {},
	availableObjectValidate: function() {
		return true
	},

	getDisplayObjectConfig: function(regionid) {
		var selectedObjects = $('#selectedObjects' + regionid);
		var str = selectedObjects.val().toString();
		var a = str.split("~");
		var data = {};

		data.object = a[0];
		data.name = a[1];
		data.objectid = a[2];

		if(a.length > 3) {
			data.params = a[3];
		}

		data.regionid = regionid;
		data.context = context;
		data.siteid = siteid;
		data.contentid = contentid;
		data.contenthistid = contenthistid;
		data.parentid = parentid;

		return data;
	},


	addDisplayObject: function(objectToAdd, regionid, configure) {
		var tmpObject = "";
		var tmpValue = "";
		var tmpText = "";
		var isUpdate = false;

		//If it's not a js object then it must be an id of a form input or select
		if(typeof(objectToAdd) == "string") {

			// return error if the id does not exist.
			if(document.getElementById(objectToAdd) == null) {

				alertDialog("Please select a display object.");

				return false;
			}

			if(document.getElementById(objectToAdd).tagName.toLowerCase() == "select") {

				if(document.getElementById(objectToAdd).selectedIndex == -1) {
					alertDialog("Please select a display object.");

					return false;
				}
				//alert("Please select a display object."); return false;}
				var addIndex = document.getElementById(objectToAdd).selectedIndex;

				if(addIndex < 0) return false;

				var addoption = document.getElementById(objectToAdd).options[addIndex];

				tmpText = addoption.text;
				tmpValue = addoption.value;

			} else if(document.getElementById(objectToAdd).tagName.toLowerCase() == "input") {

				var addoption = document.getElementById(objectToAdd);
				tmpValue = addoption.value;

			} else {
				//If it's not a select box then the value must be json object.
				addoption = document.getElementById(objectToAdd);
			}

			try {
				tmpObject = eval('(' + addoption.value + ')');
			} catch(err) {
				tmpObject = addoption.value
			}

		} else {
			//If it's not a select box then the value must be json object.
			tmpObject = objectToAdd;
		}

		//if the tmpValue evaluated into a js object pull out it's values
		var checkSelection = false;

		if(typeof(tmpObject) == "object") {
			//object^name^objectID^params
			tmpObject.regionid = regionid;
			tmpObject.context = context;
			tmpObject.siteid = siteid;
			tmpObject.contentid = contentid;
			tmpObject.contenthistid = contenthistid;
			tmpObject.parentid = parentid;

			if(tmpObject.object == 'feed') {
				if(configure) {
					//alert(JSON.stringify(tmpObject));
					tmpObject.regionid = regionid;
					if(this.initFeedConfigurator(tmpObject)) {
						return false;
					}
				}
				checkSelection = true;
			}

			if(tmpObject.object == 'feed_slideshow') {
				if(configure) {
					tmpObject.regionid = regionid;
					this.initSlideShowConfigurator(tmpObject)
					return false;
				}
				checkSelection = true;
			}

			if(tmpObject.object == 'category_summary') {
				if(configure) {
					tmpObject.regionid = regionid;
					this.initCategorySummaryConfigurator(tmpObject)
					return false;
				}
				checkSelection = true;
			}

			if((tmpObject.object == 'related_content' || tmpObject.object == 'related_section_content')) {
				if(configure) {
					tmpObject.regionid = regionid;
					this.initRelatedContentConfigurator(tmpObject);
					return false;
				}
				checkSelection = true;
			}

			if(tmpObject.object == 'plugin') {
				var configurator = this.getPluginConfigurator(tmpObject.objectid);

				if(configurator != '') {
					if(configure) {
						window[configurator](tmpObject);
						return false;
					}
					checkSelection = true;
				}
			}

			tmpValue = tmpObject.object;
			tmpValue = tmpValue + "~" + tmpObject.name;
			tmpValue = tmpValue + "~" + tmpObject.objectid;

			if(typeof(tmpObject.params) == "string") {
				tmpValue = tmpValue + "~" + tmpObject.params;
			} else if(typeof(tmpObject.params) == "object") {
				tmpValue = tmpValue + "~" + JSON.stringify(tmpObject.params);
			}

			if(checkSelection && document.getElementById('selectedObjects' + regionid).selectedIndex != -1) {
				var currentSelection = this.getDisplayObjectConfig(regionid);

				if(currentSelection) {
					if(currentSelection.objectid == tmpObject.objectid) {
						isUpdate = true
					}
				}

			}

			tmpText = tmpObject.name;

		}

		if(tmpValue == "") {

			alertDialog("Please select a display object.");

			return false;
		}

		//get reference to the select where it will go.
		var selectedObjects = document.getElementById("selectedObjects" + regionid);

		//double check that it's not already there
		if(selectedObjects.options.length) {
			for(var i = 0; i < selectedObjects.options.length; i++) {
				if(selectedObjects.options[i].value == tmpValue) {
					selectedObjects.selectedIndex = i;
					return false;
				}
			}
		}


		// add it.

		if(isUpdate) {
			myoption = selectedObjects.options[document.getElementById("selectedObjects" + regionid).selectedIndex];
			myoption.text = tmpText;
			myoption.value = tmpValue;
		} else {
			var myoption = document.createElement("option");
			selectedObjects.appendChild(myoption);
			myoption.text = tmpText;
			myoption.value = tmpValue;
			myoption.selected = "selected"
		}

		this.updateDisplayObjectList(regionid);

		return true

	},

	initCategorySummaryConfigurator: function(data) {

		if(typeof(data.object) != 'undefined') {
			if(data.object != 'category_summary') {
				return false;
			}
		}

		this.initConfigurator(data, {
			url: 'index.cfm',
			pars: 'muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=category_summary&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionid + '&objectid=' + data.objectid + '&cacheid=' + Math.random(),
			title: categorySummaryConfiguratorTitle
		});

		return true;
	},

	initFeedConfigurator: function(data) {

		/*
		if(typeof(data.object) !='undefined'){	
			if(data.object !='feed'){
				return false;
			}
		}
		*/

		this.initConfigurator(data, {
			url: 'index.cfm',
			pars: 'muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=feed&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionid + '&feedid=' + data.objectid + '&cacheid=' + Math.random(),
			title: "Loading...",
			init: function(data, config) {
				//alert(JSON.stringify(data));
				if(data.type.toLowerCase() == 'remote') {
					$("#ui-dialog-title-configuratorContainer").html(remoteFeedConfiguratorTitle);
					$("#configuratorHeader").html(remoteFeedConfiguratorTitle);
				} else {
					$("#ui-dialog-title-configuratorContainer").html(localIndexConfiguratorTitle);
					$("#configuratorHeader").html(localIndexConfiguratorTitle);
				}

				if($("#availableListSort").length) {
					$("#availableListSort, #displayListSort").sortable({
						connectWith: ".displayListSortOptions",
						update: function(event) {
							event.stopPropagation();
							$("#displayList").val("");
							$("#displayListSort > li").each(function() {
								var current = $("#displayList").val();

								if(current != '') {
									$("#displayList").val(current + "," + $.trim($(this).html()));
								} else {
									$("#displayList").val($.trim($(this).html()));
								}

							});

							siteManager.updateAvailableObject();
						}
					}).disableSelection();
				}
			}
		});
		//location.href=url + "?" + pars;
		return true;
	},

	initSlideShowConfigurator: function(data) {

		/*
		if(typeof(data.object) !='undefined'){	
			if(data.object !='feed_slideshow'){
				return false;
			}
		}
		*/

		this.initConfigurator(data, {
			url: 'index.cfm',
			pars: 'muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=feed_slideshow&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionid + '&feedid=' + data.objectid + '&cacheid=' + Math.random(),
			title: slideShowConfiguratorTitle,
			init: function(data, config) {
				$("#availableListSort, #displayListSort").sortable({
					connectWith: ".displayListSortOptions",
					update: function(event) {
						event.stopPropagation();
						$("#displayList").val("");
						$("#displayListSort > li").each(function() {
							var current = $("#displayList").val();

							if(current != '') {
								$("#displayList").val(current + "," + $(this).html());
							} else {
								$("#displayList").val($(this).html());
							}

						});
						siteManager.vupdateAvailableObject();
					}
				}).disableSelection();
			}
		});

		return true;
	},

	initRelatedContentConfigurator: function(data) {

		this.initConfigurator(
		data, {
			url: 'index.cfm',
			pars: 'muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=' + data.object + '&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionid + '&objectid=' + data.objectid + '&cacheid=' + Math.random(),
			title: relatedContentConfiguratorTitle,
			init: function(data, config) {
				$("#availableListSort, #displayListSort").sortable({
					connectWith: ".displayListSortOptions",
					update: function(event) {
						event.stopPropagation();
						$("#displayList").val("");
						$("#displayListSort > li").each(function() {
							var current = $("#displayList").val();

							if(current != '') {
								$("#displayList").val(current + "," + $(this).html());
							} else {
								$("#displayList").val($(this).html());
							}

						});
						siteManager.updateAvailableObject();
					}
				}).disableSelection();
			}
		});
		return true;
	},

	initGenericConfigurator: function(data) {
		this.resetAvailableObject();
		this.resetConfiguratorContainer();
		//location.href=url + "?" + pars;
		$("#configuratorContainer").dialog({
			resizable: true,
			modal: true,
			// width: 400,
			position: getDialogPosition(),
			buttons: {
				Cancel: function() {
					$(this).dialog("close");
				}
			},
			open: function() {
				$("#ui-dialog-title-configuratorContainer").html(genericConfiguratorTitle);
				$("#configurator").html('<div class="ui-dialog-content ui-widget-content">' + genericConfiguratorMessage + '</div>');
			},
			close: function() {
				$(this).dialog("destroy");
			}
		});

		return true;
	},


	updateAvailableObject: function() {
		var availableObjectParams = {};

		$("#availableObjectParams").find(".objectParam").each(

		function() {
			var item = $(this);
			if((item.attr("type") != "radio" && item.attr("type") != "checkbox") || ((item.attr("type") == "radio" || item.attr("type") == "checkbox") && item.is(':checked'))) {
				if(typeof(availableObjectParams[item.attr("name")]) == 'undefined') {
					availableObjectParams[item.attr("name")] = item.val();
				} else {
					if(!$.isArray(availableObjectParams[item.attr("name")])) {
						var tempArray = [];
						tempArray[0] = availableObjectParams[item.attr("name")];
						availableObjectParams[item.attr("name")] = tempArray;
					}

					availableObjectParams[item.attr("name")].push(item.val());

				}
			}
		})
		this.availableObject = $.extend({}, this.availableObjectTemplate);
		this.availableObject.params = availableObjectParams;
	},

	initDisplayObjectConfigurators: function() {
		$(".displayRegions").dblclick(

		function() {
			var regionid = $(this).attr("data-regionid");
			var data = siteManager.getDisplayObjectConfig(regionid);

			if(data.object == 'feed') {
				siteManager.initFeedConfigurator(data);
			} else if(data.object == 'feed_slideshow') {
				siteManager.initSlideShowConfigurator(data);
			} else if(data.object == 'category_summary') {
				siteManager.initCategorySummaryConfigurator(data);
			} else if(data.object == 'related_content' || data.object == 'related_section_content') {
				siteManager.initRelatedContentConfigurator(data);
			} else if(data.object == 'plugin') {
				var configurator = siteManager.getPluginConfigurator(data.objectid);
				if(configurator != '') {
					window[configurator](data);
				}
			} else {
				siteManager.initGenericConfigurator(data);
			}
		});
	},

	resetAvailableObject: function() {
		this.availableObjectTemplate = "";
		//availalbeObjectParams={};
		this.availableObject = {};
		this.availableObjectValidate = function() {
			return true
		};
	},

	resetConfiguratorContainer: function() {
		//$(instance).dialog("destroy");
		$("#configuratorContainer").remove();
		$("body").append('<div id="configuratorContainer" title="Loading..." style="display:none"><div id="configurator"><div class="load-inline"></div></div></div>');
	},

	initConfiguratorParams: function() {
		this.updateAvailableObject();
		$("#availableObjectParams").find(".objectParam").bind("change", function() {
			siteManager.updateAvailableObject();
		});
	},

	setContentDisplayListSort: function() {
		$("#contentAvailableListSort, #contentDisplayListSort").sortable({
			connectWith: ".contentDisplayListSortOptions",
			update: function(event) {
				event.stopPropagation();
				$("#contentDisplayList").val("");
				$("#contentDisplayListSort > li").each(function() {
					var current = $("#contentDisplayList").val();

					if(current != '') {
						$("#contentDisplayList").val(current + "," + $.trim($(this).html()));
					} else {
						$("#contentDisplayList").val($.trim($(this).html()));
					}

				});
			}
		}).disableSelection();
	},

	//CONFIG: URL,PARS,TITLE,INIT
	configuratorMode: 'backEnd',

	initConfigurator: function(data, config) {
		this.resetAvailableObject();

		if(typeof(config.validate) != 'undefined') {
			this.availableObjectValidate = config.validate;
		}

		data.configuratorMode = this.configuratorMode;

		if(typeof(data.object) == 'undefined') {
			return false;
		}

		if(this.configuratorMode == 'backEnd') {
			this.resetConfiguratorContainer();

			$("#configuratorContainer").dialog({
				resizable: true,
				modal: true,
				width: 600,
				position: getDialogPosition(),
				buttons: {
					Save: function() {
						siteManager.updateAvailableObject();

						if(siteManager.availableObjectValidate(data.params)) {
							siteManager.addDisplayObject(siteManager.availableObject, data.regionid, false);

							if(typeof(config.destroy) != 'undefined') {
								config.destroy(data, config);
							}

							$(this).dialog("destroy");
						}

					},
					Cancel: function() {
						if(typeof(config.destroy) != 'undefined') {
							config.destroy(data, config);
						}

						$(this).dialog("destroy");

					}
				},
				close: function() {
					if(typeof(config.destroy) != 'undefined') {
						config.destroy(data, config);
					}

					$(this).dialog("destroy");
				}

			});
		}

		$.post(config.url + "?" + config.pars, data, function(_resp) {
			try {
				resp = eval('(' + _resp + ')');
			} catch(err) {
				if(_resp.indexOf('mura-primary-login-token') != -1) {
					location.href = './';
				}
				resp = _resp;
			}

			if(typeof(resp) == 'object') {
				$("#configurator").html(resp.html);
			} else if(typeof(resp) == 'xml') {
				$("#configurator").html(resp.toString());
			} else {
				$("#configurator").html(resp);
			}


			$("#ui-dialog-title-configuratorContainer").html(config.title);
			$("#configuratorHeader").html(config.title);

			if(siteManager.availableObjectTemplate == "") {
				var availableObjectContainer = $("#availableObjectParams");
				siteManager.availableObjectTemplate = {
					object: availableObjectContainer.attr("data-object"),
					objectid: availableObjectContainer.attr("data-objectid"),
					name: availableObjectContainer.attr("data-name")
				};
				siteManager.availableObject = $.extend({}, siteManager.availableObjectTemplate);
			}

			if(typeof(config.init) != 'undefined') {

				if(typeof(resp) == 'object') {
					data = $.extend(data, resp);
				}
				config.init(data, config);
			}

			if(siteManager.configuratorMode == 'backEnd') {
				$("#configuratorContainer").dialog("option", "position", getDialogPosition());
			} else if(siteManager.configuratorMode == 'frontEnd') {
				$("#actionButtons").show();
				$("#configuratorNotices").show();
			}
			//initConfiguratorParams();
		});

		return true;
	},

	getPluginConfigurator: function(objectid) {
		for(var i = 0; i < pluginConfigurators.length; i++) {
			if(pluginConfigurators[i].objectid == objectid) {
				return pluginConfigurators[i].init;
			}
		}

		return "";
	}
};


quickEditTmpl = '<div class="mura-quickEdit" id="mura-quickEditor">';
quickEditTmpl += '<img class="loader" src="assets/images/ajax-loader-big.gif" />';
quickEditTmpl += '</div>';

$(document).ready(

function() {
	siteManager.initDisplayObjectConfigurators();
});

function initConfigurator(data, config) {
	return siteManager.initConfigurator(data, config);
}