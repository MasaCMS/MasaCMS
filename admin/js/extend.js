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

	However, as a special exception, the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1. 

	In addition, as a special exception,  the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS  with independent software modules that communicate with Mura CMS solely 
	through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API, 
	provided that these modules (a) may only modify the  /plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/admin/ 
	/tasks/ 
	/config/ 
	/requirements/mura/ 

	You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include  
	the source code of that other code when and as the GNU GPL requires distribution of source code. 

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception 
	for your modified version; it is your choice whether to do so, or to make such modified version available under 
	the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception 
	to your own modified versions of Mura CMS. */

function showSaveSort(id){
	jQuery('#showSort').hide();
	jQuery('#saveSort').show();
	
	jQuery(".handle").each(
		function(index) {
			jQuery(this).show();
		}
	);
	
	setSortable(id);
	
}
	
function showSort(id){
	jQuery('#showSort').show();
	jQuery('#saveSort').hide();
	
	jQuery(".handle").each(
		function(index) {
			jQuery(this).hide();
		}
	);
	
	jQuery("#" + id).sortable('destroy');
	jQuery("#" + id).enableSelection();
	
}
	
function saveAttributeSort(id){
	var attArray=new Array();
	
	jQuery("#" + id + ' > li').each(
		function(index) {
			attArray.push( jQuery(this).attr("attributeID") );
		}
	);
	
	var url = "index.cfm";
	var pars = 'fuseaction=cExtend.saveAttributeSort&attributeID=' + attArray.toString() + '&cacheID=' + Math.random();	
	
	//location.href=url + "?" + pars;
	jQuery.get(url + "?" + pars); 
	showSort(id)
}

function saveExtendSetSort(id){
	var setArray=new Array();
	
	jQuery("#" + id + ' > li').each(
		function(index) {
			setArray.push( jQuery(this).attr("extendSetID") );
		}
	);

	var url = "index.cfm";
	var pars = 'fuseaction=cExtend.saveExtendSetSort&extendSetID=' + setArray.toString() + '&cacheID=' + Math.random();	
	
	//location.href=url + "?" + pars;
	jQuery.get(url + "?" + pars); 	
	showSort(id);
}

function setSortable(id){	
	jQuery("#" + id).sortable();
	jQuery("#" + id).disableSelection();
}

function setBaseInfo(str){
	var dataArray=str.split("^");
	
	document.subTypeFrm.type.value=dataArray[0];
	document.subTypeFrm.baseTable.value=dataArray[1];
	document.subTypeFrm.baseKeyField.value=dataArray[2];
	document.subTypeFrm.dataTable.value=dataArray[3];
	
}
