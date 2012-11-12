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
var dataManager={
	addObject: function(availableList,publicList,privateList){
	   if(document.getElementById(availableList)==null
		|| document.getElementById(availableList).selectedIndex ==-1){
		   alert("Please select a field."); return false;}
	   var selectedObjects =document.getElementById(publicList);
	   var addIndex = document.getElementById(availableList).selectedIndex;
	   
	   if(addIndex < 0)return;
	   
	   var addoption =document.getElementById(availableList).options[addIndex]; 
	 
		if(selectedObjects.options.length){
			
			for (var i=0;i < selectedObjects.options.length;i++){ 
			
				if(selectedObjects.options[i].value == addoption.value) {
				selectedObjects.selectedIndex=i;
				return;
				}
			}
		}
		
		var myoption = document.createElement("option");
		document.getElementById(publicList).appendChild(myoption);
		myoption.text     = addoption.text;
		myoption.value    = addoption.value;
		myoption.selected = "selected";
		
		this.updateList(publicList,privateList);
		
	},

	deleteObject: function(publicList,privateList){
	   var selectedObjects =document.getElementById(publicList);
	   var deleteIndex =selectedObjects.selectedIndex;
	   var len = (selectedObjects.options.length > 1)?selectedObjects.options.length-1:0;
	   if(deleteIndex < 0) return;
		
		selectedObjects.options[deleteIndex]=null; 
		this.updateList(publicList,privateList);
		if(selectedObjects.options.length){
			selectedObjects.options[selectedObjects.options.length-1].selected=true;
		}
		 
	},

	updateList: function(publicList,privateList){
		var selectedObjects =document.getElementById(publicList);
		var objectList=document.getElementById(privateList);
		
		objectList.value=""; 
		
		for (var i=0;i<selectedObjects.options.length;i++){ 
			if(objectList.value!=""){
				objectList.value += "^" + selectedObjects.options[i].value; 
			}
			else
			{
				objectList.value = selectedObjects.options[i].value; 
			}
		}

	},

	moveUp: function(publicList,privateList){
		var selectedObjects=document.getElementById(publicList);
		var moverIndex=selectedObjects.selectedIndex;
		if(moverIndex<1)return;

		var moveroption = document.createElement("option");
		var movedoption = document.createElement("option");

		moveroption.text = selectedObjects.options[moverIndex].text; 
		moveroption.value = selectedObjects.value;
		moveroption.selected = "selected"

		movedoption.text = selectedObjects.options[moverIndex-1].text;
		movedoption.value = selectedObjects.options[moverIndex-1].value;

		selectedObjects[moverIndex-1]=moveroption;
		selectedObjects[moverIndex]=movedoption;

		this.updateList(publicList,privateList);
	},

	moveDown: function(publicList,privateList){
		var selectedObjects=document.getElementById(publicList);
		var moverIndex=selectedObjects.selectedIndex;
		if(moverIndex ==selectedObjects.length-1)return;

		var moveroption = document.createElement("option");
		var movedoption = document.createElement("option");

		moveroption.text =selectedObjects.options[moverIndex].text; 
		moveroption.value = selectedObjects.options[moverIndex].value;
		moveroption.selected = "selected"

		movedoption.text =  selectedObjects.options[moverIndex+1].text;
		movedoption.value = selectedObjects.options[moverIndex+1].value;


		selectedObjects.options[moverIndex+1]=moveroption;
		selectedObjects.options[moverIndex]=movedoption;

		this.updateList(publicList,privateList);

	}
}