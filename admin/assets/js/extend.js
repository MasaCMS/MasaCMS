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

var extendManager = {

	showSaveSort: function(id) {
		$('#showSort').hide();
		$('#saveSort').show();

		$(".handle").each(

		function(index) {
			$(this).show();
		});

		this.setSortable(id);

	},

	showSort: function(id) {
		$('#showSort').show();
		$('#saveSort').hide();

		$(".handle").each(

		function(index) {
			$(this).hide();
		});

		$("#" + id).sortable('destroy');
		$("#" + id).enableSelection();

	},
	
	showRelatedSaveSort: function(id) {
		$('#showRelatedSort').hide();
		$('#saveRelatedSort').show();

		$(".handleRelated").each(

		function(index) {
			$(this).show();
		});

		this.setSortable(id);

	},

	showRelatedSort: function(id) {
		$('#showRelatedSort').show();
		$('#saveRelatedSort').hide();

		$(".handleRelated").each(

		function(index) {
			$(this).hide();
		});

		$("#" + id).sortable('destroy');
		$("#" + id).enableSelection();

	},

	saveAttributeSort: function(id) {
		var attArray = new Array();

		$("#" + id + ' > li').each(

		function(index) {
			attArray.push($(this).attr("attributeID"));
		});

		var url = "index.cfm";
		var pars = 'muraAction=cExtend.saveAttributeSort&attributeID=' + attArray.toString() + '&cacheID=' + Math.random();

		//location.href=url + "?" + pars;
		$.get(url + "?" + pars);
		this.showSort(id)
	},

	saveExtendSetSort: function(id) {
		var setArray = new Array();

		$("#" + id + ' > li').each(

		function(index) {
			setArray.push($(this).attr("extendSetID"));
		});

		var url = "index.cfm";
		var pars = 'muraAction=cExtend.saveExtendSetSort&extendSetID=' + setArray.toString() + '&cacheID=' + Math.random();

		//location.href=url + "?" + pars;
		$.get(url + "?" + pars);
		this.showSort(id);
	},
	
	saveRelatedSetSort: function(id) {
		var setArray = new Array();

		$("#" + id + ' > li').each(

		function(index) {
			setArray.push($(this).attr("relatedContentSetID"));
		});

		var url = "index.cfm";
		var pars = 'muraAction=cExtend.saveRelatedSetSort&relatedContentSetID=' + setArray.toString() + '&cacheID=' + Math.random();

		//location.href=url + "?" + pars;
		$.get(url + "?" + pars);
		this.showRelatedSort(id);
	},

	setSortable: function(id) {
		$("#" + id).sortable();
		$("#" + id).disableSelection();
	},

	setBaseInfo: function(str) {
		var dataArray = str.split("^");

		document.subTypeFrm.type.value = dataArray[0];

		if(dataArray.length > 1) {
			document.subTypeFrm.baseTable.value = dataArray[1];
			document.subTypeFrm.baseKeyField.value = dataArray[2];
			document.subTypeFrm.dataTable.value = dataArray[3];
		}
		if(dataArray[0] == "") {
			$(".hasRow1Container").hide();
			$(".subTypeContainer").hide();
			$(".SubTypeIconSelect").hide();
			$(".hasSummaryContainer").hide();
			$(".hasBodyContainer").hide();
			$(".hasConfiguratorContainer").hide();
			$(".availableSubTypesContainer").hide();
			$(".hasAssocFileContainer").hide();
		} else if(dataArray[0] == "Site") {
			$(".hasRow1Container").hide();
			$(".subTypeContainer").hide();
			$(".SubTypeIconSelect").hide();
			$(".hasSummaryContainer").hide();
			$(".hasBodyContainer").hide();
			$(".hasConfiguratorContainer").hide();
			$(".hasAssocFileContainer").hide();
			$("#subType").val("Default");
		} else if(dataArray[0] == "1" || dataArray[0] == "2" || dataArray[0] == "Address" || dataArray[0] == "Custom" || dataArray[0] == "Base") {
			$(".hasRow1Container").hide();
			$(".subTypeContainer").show();
			$(".SubTypeIconSelect").hide();
			$(".hasSummaryContainer").hide();
			$(".hasBodyContainer").hide();
			$(".hasConfiguratorContainer").hide();
			$(".availableSubTypesContainer").hide();
			$(".hasAssocFileContainer").hide();
		} else if(dataArray[0] == "File" || dataArray[0] == "Link") {
			$(".hasRow1Container").show();
			$(".subTypeContainer").show();
			$(".SubTypeIconSelect").show();
			$(".hasSummaryContainer").show();
			$(".hasBodyContainer").hide();
			$(".hasConfiguratorContainer").hide();
			$(".availableSubTypesContainer").show();
			if(dataArray[0] == "File"){
				$(".hasAssocFileContainer").hide();
			} else {
				$(".hasAssocFileContainer").show();
			}
		} else if(dataArray[0] == "Component" || dataArray[0] == "Form") {
			$(".hasRow1Container").show();
			$(".subTypeContainer").show();
			$(".SubTypeIconSelect").hide();
			$(".hasSummaryContainer").hide();
			$(".hasBodyContainer").show();
			$(".hasConfiguratorContainer").hide();
			$(".availableSubTypesContainer").hide();
			$(".hasAssocFileContainer").hide();
		} else if(dataArray[0] == "Folder" || dataArray[0] == "Gallery" || dataArray[0] == "Calendar") {
			$(".hasRow1Container").show();
			$(".subTypeContainer").show();
			$(".SubTypeIconSelect").show();
			$(".hasSummaryContainer").show();
			$(".hasBodyContainer").show();
			$(".hasConfiguratorContainer").show();
			$(".availableSubTypesContainer").show();
			$(".hasAssocFileContainer").show();
		} else {
			$(".hasRow1Container").show();
			$(".subTypeContainer").show();
			$(".SubTypeIconSelect").show();
			$(".hasSummaryContainer").show();
			$(".hasBodyContainer").show();
			$(".hasConfiguratorContainer").hide();
			$(".availableSubTypesContainer").show();
			$(".hasAssocFileContainer").show();
		}

		

	}
}