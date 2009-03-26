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

	function openScheduler()
	{
		var s = $('scheduler');
		var c = $('controls');
		c.style.display='none';
		s.style.display='inline';
		
		return false;

	}
	function closeScheduler()
	{
		var s = $('scheduler');	
		var c = $('controls');
		s.style.display='none';
		c.style.display='inline';
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
		var h = $('htmlMessage');
		var t = $('textMessage');
		
		if (selObj.options[selIndex].value == "HTML")
		{
			h.style.display='inline';
			t.style.display='none';
		}
		if (selObj.options[selIndex].value == "Text")
		{
			h.style.display='none';
			t.style.display='inline';
		}
		if (selObj.options[selIndex].value == "HTML & Text")
		{
			h.style.display='inline';
			t.style.display='inline';
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
		var f = $(formField);
		document.forms.form1.action.value=formAction;
		if (f.value == ''){
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
		

