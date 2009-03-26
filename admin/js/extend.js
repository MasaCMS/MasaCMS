/* This file is part of Mura CMS. */

/*    Mura CMS is free software: you can redistribute it and/or modify */
/*    it under the terms of the GNU General Public License as published by */
/*    the Free Software Foundation, Version 2 of the License. */

/*    Mura CMS is distributed in the hope that it will be useful, */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*    GNU General Public License for more details. */

/*    You should have received a copy of the GNU General Public License */
/*    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. */

function showSaveSort(id){
	$('showSort').style.display='none';
	$('saveSort').style.display='';
	
	var items=document.getElementsByClassName("handle");
	
	if(items.length){
		for(var i=0;i<items.length;i++){
			items[i].style.display="";
		}
	}
	
	setSortable(id);
	
}
	
function showSort(id){
	$('showSort').style.display='';
	$('saveSort').style.display='none';
	
	var items=document.getElementsByClassName("handle");
	
	if(items.length){
		for(var i=0;i<items.length;i++){
			items[i].style.display="none";
		}
	}
	
}
	
function saveAttributeSort(id){
	var atts=$(id).getElementsByTagName('li');
	var attList="";
	for(var a=0;a<atts.length;a++){
		if(a>0){attList=attList + ",";}
		attList=attList + atts[a].getAttribute("attributeID");	
	}

	var url = "index.cfm";
	var pars = 'fuseaction=cExtend.saveAttributeSort&attributeID=' + attList + '&cacheID=' + Math.random();	
	
	//location.href=url + "?" + pars;
	var myAjax = new Ajax.Request(
			url, 
			{
				method: 'get', 
				parameters: pars
			}); 
	showSort(id)
}

function saveExtendSetSort(id){
	var sets=$(id).getElementsByTagName('li');
	var setList="";
	for(var s=0;s<sets.length;s++){
		if(s>0){setList=setList + ",";}
		setList=setList + sets[s].getAttribute("extendSetID");	
	}

	var url = "index.cfm";
	var pars = 'fuseaction=cExtend.saveExtendSetSort&extendSetID=' + setList + '&cacheID=' + Math.random();	
	
	//location.href=url + "?" + pars;
	var myAjax = new Ajax.Request(
			url, 
			{
				method: 'get', 
				parameters: pars
			}); 
			
	showSort(id);
}

function setSortable(id){	

	Sortable.create(id,
     {dropOnEmpty:false,handle:'handle',containment:$(id),tree:false,constraint:false,onChange:function(){showSaveSort()}});

	
}

function setBaseInfo(str){
	var dataArray=str.split("^");
	
	document.subTypeFrm.type.value=dataArray[0];
	document.subTypeFrm.baseTable.value=dataArray[1];
	document.subTypeFrm.baseKeyField.value=dataArray[2];
	document.subTypeFrm.dataTable.value=dataArray[3];
	
}
