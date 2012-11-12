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

var userManager = {
	loadExtendedAttributes: function(baseID, type, subType, _siteID, _context, _themeAssetPath) {
		var url = 'index.cfm';
		var pars = 'muraAction=cPublicUsers.loadExtendedAttributes&baseID=' + baseID + '&type=' + type + '&subType=' + subType + '&siteID=' + _siteID + '&cacheid=' + Math.random();

		siteID = _siteID;
		context = _context;
		themeAssetPath = _themeAssetPath

		//location.href=url + "?" + pars;
		var d = $('#extendSetsDefault');

		if(d.length) {
			d.html('<div class="load-inline"></div>');
			$.get(url + "?" + pars, function(data) {
				if(data.indexOf('mura-primary-login-token') != -1) {
					location.href = './';
				}
				userManager.setExtendedAttributes(data);
			});
		}

		return false;
	},

	setExtendedAttributes: function(data) {
		var r = eval("(" + data + ")");
		$("#extendSetsDefault").html(r.extended);
		$("#extendSetsBasic").html(r.basic);

		if(r.extended == '') {
			$('#tabExtendedattributesLI').addClass('hide');
		} else {
			$('#tabExtendedattributesLI').removeClass('hide');
		}
		//checkExtendSetTargeting();
		setHTMLEditors(context, themeAssetPath);
		setDatePickers(".tabcontent .datepicker", dtLocale);
		setColorPickers(".tabcontent .colorpicker");
		setToolTips(".tabcontent");

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
						var categories = document.form1.categoryID;
						started = true;
					}

					for(var c = 0; c < categories.length; c++) {
						var cat = categories[c];
						var catID = categories[c].value;
						var assignedID = extendSet.getAttribute("categoryid");
						if(!found && catID != null && assignedID.indexOf(catID) > -1) {
							found = true;
							membership = cat.checked;
						}
					}

					if(found) {
						if(membership) {
							userManager.setFormElementsDisplay(extendSet, '');
							extendSet.style.display = '';
							empty = false;
						} else {
							userManager.setFormElementsDisplay(extendSet, 'none');
							extendSet.style.display = 'none';

						}
					} else {
						userManager.setFormElementsDisplay(extendSet, 'none');
						extendSet.style.display = 'none';

					}
				} else {
					userManager.setFormElementsDisplay(extendSet, '');
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

	resetExtendedAttributes: function(contentHistID, type, subtype, siteID, context, themeAssetPath) {
		this.loadExtendedAttributes(contentHistID, type, subtype, siteID, context, themeAssetPath);
		//alert(dataArray[1]);
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

	}
}