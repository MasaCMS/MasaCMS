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
	provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/trunk/www/admin/ 
	/trunk/www/tasks/ 
	/trunk/www/config/ 
	/trunk/www/requirements/mura/ 

	You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include  
	the source code of that other code when and as the GNU GPL requires distribution of source code. 

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception 
	for your modified version; it is your choice whether to do so, or to make such modified version available under 
	the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception 
	to your own modified versions of Mura CMS. */

	function openScheduler()
	{
		var s = jQuery('#scheduler');
		var c = jQuery('#controls');
		c.css('display','none');
		s.css('display','inline');
		
		return false;

	}
	function closeScheduler()
	{
		var s = jQuery('#scheduler');	
		var c = jQuery('#controls');
		s.css('display','none');
		c.css('display','inline');
		document.forms.form1.deliveryDate.value = '';

		document.forms.form1.timehour.selectedIndex = 7;
		document.forms.form1.timeminute.selectedIndex = 0;
		document.forms.form1.timepart.selectedIndex = 1;
		
		return false;
		
	}
	
	function showMessageEditor()
	{
		var selObj = document.getElementById('messageFormat');
		var selIndex = selObj.selectedIndex;
		var h = jQuery('#htmlMessage');
		var t = jQuery('#textMessage');
		
		if (selObj.options[selIndex].value == "HTML")
		{
			h.css('display','inline');
			t.css('display','none');
		}
		if (selObj.options[selIndex].value == "Text")
		{
			h.css('display','none');
			t.css('display','inline');
		}
		if (selObj.options[selIndex].value == "HTML & Text")
		{
			h.css('display','inline');
			t.css('display','inline');
		}
	
	}
	function validateEmailForm(formAction, errorMessage)
	{
		document.forms.form1.action.value=formAction;
		if (confirm(errorMessage))
		{
			
			if(!checkContentLength())
				{return false;}
			
			submitForm(document.forms.form1);
		}
		
		return false;
	}
	
	function validateScheduler(formAction, errorMessage, formField)
	{
		var f = jQuery("#" + formField);
		document.forms.form1.action.value=formAction;
		if (f.val() == ''){
			alert(errorMessage);
			f.focus();
		} else {
			submitForm(document.forms.form1);
		}
		
		return false;
		
	}
	
	
function checkContentLength(){
	/*
	var bodyHTML =FCKeditorAPI.GetInstance('bodyHTML').GetXHTML();
	var bodyHTMLLength = bodyHTML.length;
	var pageSize=32000;
			
			if(bodyHTMLLength > pageSize ){
		
			alert("The 'HTML' content length must be less than 32000 characters.");
			return false;
			}
			
			var bodyText =document.forms.form1.bodyText.value.length;
			var bodyTextLength = bodyText.length;
			
			if(bodyTextLength > pageSize ){
		
			alert("The 'Text' content length must be less than 32000 characters.");
			return false;
			}
			
		*/
			return true;
}
		

