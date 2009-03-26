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

function loadExtendedAttributes(baseID,type,subType,siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cPublicUsers.loadExtendedAttributes&baseID=' + baseID +'&type=' + type  +'&subType=' + subType + '&siteID=' + siteID + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = $('extendSets');
		
		if(d != null){
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
			var myAjax = new Ajax.Request(url, {method: 'get', parameters: pars, onSuccess:setExtendedAttributes});
		}
		
		return false;
	}

function setExtendedAttributes(transport){
	$("extendSets").innerHTML=transport.responseText;
	checkExtendSetTargeting();
}

function checkExtendSetTargeting(){
	var extendSets=document.getElementsByClassName('extendset');
	var found=false;
	var started=false;
	var empty=true;
	
	if (extendSets.length){
		for(var s=0;s<extendSets.length;s++){
			var extendSet=extendSets[s];

			if(extendSet.getAttribute("categoryid") != undefined
			&& extendSet.getAttribute("categoryid") != ""){
				if(!started){
				var categories=document.form1.categoryID;
				started=true;
				}
				
				for(var c=0;c<categories.length;c++){
					var cat =categories[c];
					var catID=categories[c].value;
					var assignedID=extendSet.getAttribute("categoryid");
					if(!found && catID != null && assignedID.indexOf(catID) > -1){
						found=true;
						membership=cat.checked;			
					}
				}
				
				if(found){
					if(membership){
						setFormElementsDisplay(extendSet,'');
						extendSet.style.display='';	
						empty=false;
					} else {
						setFormElementsDisplay(extendSet,'none');
						extendSet.style.display='none';
						
					}
				} else {
					setFormElementsDisplay(extendSet,'none');
					extendSet.style.display='none';
					
				}
			} else {
				setFormElementsDisplay(extendSet,'');
				extendSet.style.display='';
				empty=false;
				
				
			}
			
			
			found=false;
		}
		
		if(empty){
			$('extendMessage').style.display="";
			$('extendDL').style.display="none";
		} else {
			$('extendMessage').style.display="none";
			$('extendDL').style.display="";
		}
	
	}

}

function resetExtendedAttributes(contentHistID,type,subtype,siteID)	{
	loadExtendedAttributes(contentHistID,type,subtype,siteID);
	//alert(dataArray[1]);
}

function setFormElementsDisplay(container,display){
	var inputs = container.getElementsByTagName('input');
	//alert(inputs.length);
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
			//alert(inputs[i].style.display);
		}
	}
	
	inputs = container.getElementsByTagName('textarea');
	
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
		}
	}
	
	inputs = container.getElementsByTagName('select');
	
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
		}
	}

}
