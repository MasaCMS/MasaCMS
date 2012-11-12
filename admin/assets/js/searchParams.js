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

/*function addSearchOption(containerid){
	
	var num =$(containerid).getElementsByTagName('LI').length + 1
	var str= '<p id="newFileP' + num + '"><input type="file" id="fileId' + num + '"  name="newFile' + num +'" ><input type="button" value="cancel" onclick="$(\'newFileP' + num + '\').innerHTML=\'\';"</p>';
	new Insertion.Bottom(containerid, str);
	
}*/


var searchParams={
	addSearchParam: function(){
		
		var num =$('#searchParams > .controls').length;
		var str= '<div class="controls">' + $('#searchParams > .controls').html() + '</div>';
		$('#searchParams').append(str);
		var newParam = $('#searchParams > .controls:last');
		var newParamSelects = $('#searchParams > .controls:last > select');
		var newParamInputs = $('#searchParams > .controls:last > input');
		
		newParamSelects[0].selectedIndex=0;
		newParamSelects[1].selectedIndex=0;
		newParamSelects[2].selectedIndex=0;
		newParamInputs[1].setAttribute('value','');
		
		this.setSearchParamNames(newParam,num + 1);
	},

	setSearchParamNames: function(param,num){

		var newParamSelects =$(param).find("select");
		var newParamInputs = $(param).find("input");
		
		newParamSelects[0].setAttribute('name','paramRelationship' + num);
		newParamSelects[1].setAttribute('name','paramField'  + num);
		newParamSelects[2].setAttribute('name','paramCondition'  + num);
		newParamInputs[0].setAttribute('value',num);
		newParamInputs[1].setAttribute('name','paramCriteria' + num);
		
	},

	setSearchButtons: function(){
		var params=$('#searchParams > .controls');
		var num =params.length;
		
		if(num == 1){
			var buttons = params.find("a");
				$(buttons[0]).hide();
				$(buttons[1]).show();
				params.find("select:first").hide();
		} else {
				
			params.each(function(index){
					if(index==0){
						var buttons =$(params[index]).find("a");
						$(params[index]).find('select:first').hide();
						$(buttons[0]).hide();
						$(buttons[1]).hide();
					} else {
						var buttons =$(params[index]).find("a");
						$(params[index]).find('select:first').show();
						
						if(index!= num-1){
							$(buttons[0]).show();
							$(buttons[1]).hide();
							
						}else{
							$(buttons[0]).show();
							$(buttons[1]).show();
						}
						
						 searchParams.setSearchParamNames(params[index],index + 1);
					}
				}
			);
			
		}
		
		return false;
	},

	removeSeachParam: function(option){

		new $(option).remove();
		
		return false;
	}
}