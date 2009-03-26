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

/*function addSearchOption(containerid){
	
	var num =$(containerid).getElementsByTagName('LI').length + 1
	var str= '<p id="newFileP' + num + '"><input type="file" id="fileId' + num + '"  name="newFile' + num +'" ><input type="button" value="cancel" onclick="$(\'newFileP' + num + '\').innerHTML=\'\';"</p>';
	new Insertion.Bottom(containerid, str);
	
}*/


function addSearchParam(){
	
	var num =$('searchParams').getElementsByTagName('LI').length;
	var str= '<li>' + $('searchParams').getElementsByTagName('LI')[0].innerHTML + '</li>';
	new Insertion.Bottom('searchParams', str);
	
	var newParam =$('searchParams').getElementsByTagName('LI')[num];
	
	var newParamSelects = newParam.getElementsByTagName('SELECT');
	var newParamInputs = newParam.getElementsByTagName('INPUT');
	
	newParamSelects[0].selectedIndex=0;
	newParamSelects[1].selectedIndex=0;
	newParamSelects[2].selectedIndex=0;
	newParamInputs[1].setAttribute('value','');
	
	setSearchParamNames(newParam,num + 1);
}

function setSearchParamNames(param,num){
	
	var newParamSelects = param.getElementsByTagName('SELECT');
	var newParamInputs = param.getElementsByTagName('INPUT');
	
	newParamSelects[0].setAttribute('name','paramRelationship' + num);
	newParamSelects[1].setAttribute('name','paramField'  + num);
	newParamSelects[2].setAttribute('name','paramCondition'  + num);
	newParamInputs[0].setAttribute('value',num);
	newParamInputs[1].setAttribute('name','paramCriteria' + num);
	
}

function setSearchButtons(){
	var params=$('searchParams').getElementsByTagName('LI');
	var num =params.length;
	
	if(num == 1){
		var buttons = params[0].getElementsByTagName('A');
			buttons[0].style.display='none';
			buttons[1].style.display='';
			params[0].getElementsByTagName('SELECT')[0].style.display='none';
	} else {
		var buttons = params[0].getElementsByTagName('A');
		buttons[0].style.display='none';
		buttons[1].style.display='none';
		params[0].getElementsByTagName('SELECT')[0].style.display='none';
			
		for(var p=1;p<num;p++){
			var buttons = params[p].getElementsByTagName('A');
			params[p].getElementsByTagName('SELECT')[0].style.display='';
			if(p!= num-1){
				buttons[0].style.display='';
				buttons[1].style.display='none';
				
			}else{
				buttons[0].style.display='';
				buttons[1].style.display='';
			}
			
			 setSearchParamNames(params[p],p + 1);
		}
	}
	
	return false;
}

function removeSeachParam(option){

	new Element.remove($(option));
	
	return false;
}