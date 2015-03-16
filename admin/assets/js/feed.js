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
var feedManager = {
	loadSiteFilters: function(siteid, keywords, isNew, contentPoolID) {
		var url = 'index.cfm';
		var pars = 'muraAction=cFeed.loadSite&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&contentPoolID=' + contentPoolID +'&cacheid=' + Math.random();
		var d = $('#selectFilter');
		d.html('<div class="load-inline"></div>');
		$('#selectFilter .load-inline').spin(spinnerArgs2); 
		$.get(url + "?" + pars, function(data) {
			$("#selectFilter").html(data);
		});
	},

	addContentFilter: function(contentID, contentType, sourceID) {

		var tbody = document.getElementById('contentFilters').getElementsByTagName("TBODY")[0];
		var row = document.createElement("TR");
		row.id = "c" + contentID;
		
		var name = document.createElement("TD");
		name.className = "var-width";
		$(name).html($('#' + decodeURI(sourceID)).html());

		var type = document.createElement("TD");
		$(type).html(decodeURI(contentType));
		
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
		deleteUL.className = "clearfix";
		var deleteLI = document.createElement("LI");
		deleteLI.className = "delete";
		deleteLI.appendChild(deleteLink);
		deleteUL.appendChild(deleteLI);

		var content = document.createElement("INPUT");
		content.setAttribute("type", "hidden");
		content.setAttribute("name", "contentID");
		content.setAttribute("value", contentID);
		admin.appendChild(content);
		admin.appendChild(deleteUL);
		row.appendChild(name);
		row.appendChild(type);
		row.appendChild(admin);
		tbody.appendChild(row);
		if($('#noFilters').length) $('#noFilters').hide();

		stripe('stripe');

	},

	removeFilter: function(id) {
		$("#" + id).remove();
		stripe('stripe');
		return false;
	},


	loadSiteParents: function(siteid, parentid, keywords, isNew) {
		var url = 'index.cfm';
		var pars = 'muraAction=cFeed.siteParents&compactDisplay=true&siteid=' + siteid + '&parentid=' + parentid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('#move');
		d.html('<div class="load-inline"><inut type=hidden name=parentid value=' + parentid + ' ></div>');
		$('#move .load-inline').spin(spinnerArgs2);
		$.get(url + "?" + pars, function(data) {
			$("#move").html(data);
		});
	},

	confirmImport: function() {

		$("#alertDialogMessage").html('Import Selections?');
		$("#alertDialog").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'Yes': function() {
					$(this).dialog('close');
					submitForm(document.forms.contentForm, 'Import');
				},
				'No': function() {
					$(this).dialog('close');
				}
			}
		});

		return false;
	},

	setDisplayListSort: function() {
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
			}
		}).disableSelection();
	},

	updateInstanceObject: function() {
		var availableObjectParams = {};
		$("#tabDisplay").find(":input").each(

		function() {
			var item = $(this);
			if(item.attr("type") != "radio" || (item.attr("type") == "radio" && item.is(':checked'))) {
				availableObjectParams[item.attr("data-displayobjectparam")] = item.val();
			}
		})
		$("#instanceParams").val(JSON.stringify(availableObjectParams));
	}
}