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
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */function ie6CookieCheck() 
{	
	/*------------------------------
	Check if a cookie has been set 
	------------------------------*/
	if (document.cookie.length > 0)
	{		
		if(document.cookie.indexOf("ie6Notice") == -1)
		{
			/*------------------------------
			Check user has hidden notice. If not show it. 
			------------------------------*/
			ie6Notice();
		}
	}
}
function ie6Notice() 
{		
	/*------------------------------
	Set variables
	------------------------------*/		
	var head, body, noticeDiv, noticeParagraph, noticeText, ie6css, hideText, hideLink, hideParagraph;

	/*------------------------------
	Check getElementsByTagName support
	------------------------------*/
	if(!document.getElementsByTagName) { return; }

	/*------------------------------
	Get head element
	------------------------------*/
	head = document.getElementsByTagName("head")[0];
	if (!head) { return;}
	
	/*------------------------------
	Create and insert CSS link into head
	------------------------------*/
	ie6Css = document.createElement('link');
	ie6Css.setAttribute("rel", "stylesheet");
	ie6Css.setAttribute("href", "../admin/css/ie/ie6_notice.css");
	ie6Css.setAttribute("type", "text/css");	
	ie6Css.setAttribute("media", "screen");	

	head.appendChild(ie6Css); 
	
	/*------------------------------
	Get body element
	------------------------------*/
	body = document.getElementsByTagName("body")[0];
	if (!body) { return;}
	
	/*------------------------------
	Create and insert notice div
	------------------------------*/
	noticeDiv = document.createElement('div');
	noticeDiv.id = "ie6-notice";
	body.appendChild(noticeDiv); 

	/*------------------------------
	Create and insert notice paragraph
	------------------------------*/
	noticeParagraph = document.createElement('p');
	noticeParagraph.id = "ie6-text";
	noticeDiv.appendChild(noticeParagraph);
	
	/*------------------------------
	Create and insert notice text
	------------------------------*/
	noticeText = 'You appear to be using Internet Explorer 7 or lower. Future versions of Mura CMS will not support any version of Internet Explorer below IE 8. It is recommended you upgrade to a modern browser such as the latest version of <a href="http://www.microsoft.com/windows/internet-explorer/">Internet Explorer</a>, <a href="https://www.google.com/intl/en/chrome/browser/">Chrome</a>, <a href="http://www.mozilla.com/firefox/">Firefox</a>, <a href="http://www.apple.com/safari/">Safari</a>, or <a href="http://www.opera.com/">Opera</a>.';
	noticeParagraph.innerHTML=noticeText;

	/*------------------------------
	Create and insert hide paragraph
	------------------------------*/	
	hideParagraph = document.createElement('p');
	hideParagraph.id = "ie6-hide-notice";
	noticeDiv.appendChild(hideParagraph);

	/*------------------------------
	Create and insert hide link
	------------------------------*/	
	hideLink = document.createElement('a');
	hideLink.setAttribute("href", "#");	
	hideParagraph.appendChild(hideLink);
			
	/*------------------------------
	Create and insert hide text
	------------------------------*/
	hideText = document.createTextNode('Hide this message');
	hideLink.appendChild(hideText);
	
	hideParagraph.onclick = function()
	{
		var today = new Date(); 
		var expiry = new Date(today.getTime() + 30 * 86400 * 1000);
		document.cookie = name + "=" + "ieNotice" + "; expires=" + expiry.toGMTString() + "; path=/"; 
		noticeDiv.style.display="none";
		ie6Css.removeAttribute("href");
		ie6css = null;
		noticeDiv = null;
		return false;
	}
		
}
ie6CookieCheck();