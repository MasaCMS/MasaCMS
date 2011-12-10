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
		
	var textPadding = 3; // Padding at the left of tab text - bigger value gives you wider tabs
	var strictDocType = true; 
	var tabView_maxNumberOfTabs = 6;	// Maximum number of tabs
	
	/* Don't change anything below here */
	var page_tabObj;
	var activeTabIndex = -1;
	var MSIE = navigator.userAgent.indexOf('MSIE')>=0?true:false;
	var navigatorVersion = navigator.appVersion.replace(/.*?MSIE (\d\.\d).*/g,'$1')/1;
	var ajaxObjects = new Array();
	var tabView_countTabs = 0;
	var tabViewHeight;
	
	function setPadding(obj,padding){
		var span = obj.getElementsByTagName('SPAN')[0];
		span.style.paddingLeft = padding + 'px';	
		span.style.paddingRight = padding + 'px';	
	}
	function showTab(tabIndex)
	{
		if(!document.getElementById('tabView' + tabIndex))return;
		if(activeTabIndex>=0){
			if(activeTabIndex==tabIndex)return;
			var obj = document.getElementById('tabTab'+activeTabIndex);
			obj.className='tabInactive';
			var img = obj.getElementsByTagName('IMG')[0];
			img.src = 'images/tabs/tab_right_inactive.gif';
			document.getElementById('tabView' + activeTabIndex).style.display='none';
		}
		
		var thisObj = document.getElementById('tabTab'+tabIndex);		
		thisObj.className='tabActive';
		var img = thisObj.getElementsByTagName('IMG')[0];
		img.src = 'images/tabs/tab_right_active.gif';
		
		document.getElementById('tabView' + tabIndex).style.display='block';
		activeTabIndex = tabIndex;
		

		var parentObj = thisObj.parentNode;
		var aTab = parentObj.getElementsByTagName('LI')[0];
		countObjects = 0;
		var startPos = 2;
		var previousObjectActive = false
		
		while(aTab){
			if(aTab.tagName=='LI'){
				if(previousObjectActive){
					previousObjectActive = false;
					startPos-=2;
				}
				if(aTab==thisObj){
					startPos-=2;
					previousObjectActive=true;
					setPadding(aTab,textPadding+1);
				}else{
					setPadding(aTab,textPadding);
				}
				
				aTab.style.left = startPos + 'px';
				countObjects++;
				startPos+=2;
			}			
			aTab = aTab.nextSibling;
		}
		
		return;
	}
	
	function tabClick()
	{
		showTab(this.id.replace(/[^\d]/g,''));
		
	}
	
	function rolloverTab()
	{
		if(this.className.indexOf('tabInactive')>=0){
			this.className='inactiveTabOver';
			var img = this.getElementsByTagName('IMG')[0];
			img.src = 'images/tabs/tab_right_over.gif';
		}
		
	}
	function rolloutTab()
	{
		if(this.className ==  'inactiveTabOver'){
			this.className='tabInactive';
			var img = this.getElementsByTagName('IMG')[0];
			img.src = 'images/tabs/tab_right_inactive.gif';
		}
		
	}
	
	function initTabs(tabTitles,activeTab,width,height,additionalTab)
	{
		if(!additionalTab || additionalTab=='undefined'){			
			page_tabObj = document.getElementById('page_tabView');
			
			if(width > 0){
				width = width + '';
				if(width.indexOf('%')<0)width= width + 'px';
				page_tabObj.style.width = width;
			}
			
			if(height > 0){
				height = height + '';
				if(height.length>0){
					if(height.indexOf('%')<0)height= height + 'px';
					page_tabObj.style.height = height;
				}
				
				tabViewHeight = height;
			}
			
			var tabUL = document.createElement('UL');		
			var firstDiv = page_tabObj.getElementsByTagName('DIV')[0];	
			
			page_tabObj.insertBefore(tabUL,firstDiv);	
			tabUL.className = 'page_tabPane';
			
			tabView_countTabs = 0;
		}else{
			var tabUL = page_tabObj.getElementsByTagName('UL')[0];
			var firstDiv = page_tabObj.getElementsByTagName('DIV')[0];
			height = tabViewHeight;
			activeTab = tabView_countTabs;			
		}
		
		
		
		for(var no=0;no<tabTitles.length;no++){
			var aTab = document.createElement('LI');
			aTab.id = 'tabTab' + (no + tabView_countTabs);
			aTab.onmouseover = rolloverTab;
			aTab.onmouseout = rolloutTab;
			aTab.onclick = tabClick;
			aTab.className='tabInactive';
			tabUL.appendChild(aTab);
			var span = document.createElement('SPAN');
			span.innerHTML = tabTitles[no];
			aTab.appendChild(span);
			
			var img = document.createElement('IMG');
			img.valign = 'bottom';
			img.src = 'images/tabs/tab_right_inactive.gif';
			// IE5.X FIX
			if((navigatorVersion && navigatorVersion<6) || (MSIE && !strictDocType)){
				img.style.styleFloat = 'none';
				img.style.position = 'relative';	
				img.style.top = '4px'
				span.style.paddingTop = '4px';
				aTab.style.cursor = 'hand';
			}	// End IE5.x FIX
			aTab.appendChild(img);
		}
	
			
		var tabs = page_tabObj.getElementsByTagName('DIV');
		var liCounter = 0;
		for(var no=0;no<tabs.length;no++){
			if(tabs[no].className=='page_aTab'){
				if(height.length>0)tabs[no].style.height = height;
				tabs[no].style.display='none';
				tabs[no].id = 'tabView' + liCounter;
				liCounter++;
			}			
		}	
		tabView_countTabs = tabView_countTabs + tabTitles.length;	
		showTab(activeTab);
		
		return activeTab;
	}	
	
	function showAjaxTabContent(ajaxIndex,tabId)
	{
		document.getElementById('tabView'+tabId).innerHTML = ajaxObjects[ajaxIndex].response;		
	}
	
	function resetTabIds()
	{
		var divs = page_tabObj.getElementsByTagName('DIV');
		var tabTitleCounter = 0;
		var tabContentCounter = 0;
		
		for(var no=0;no<divs.length;no++){
			if(divs[no].className=='page_aTab'){
				divs[no].id = 'tabView' + tabTitleCounter;
				tabTitleCounter++;
			}
			if(divs[no].id.indexOf('tabTab')>=0){
				divs[no].id = 'tabTab' + tabContentCounter;	
				tabContentCounter++;
			}	
			
				
		}
		
		tabView_countTabs = tabContentCounter;
	}
	
	
	function createNewTab(tabTitle,tabContent,tabContentUrl)
	{
		if(tabView_countTabs>=tabView_maxNumberOfTabs)return;	// Maximum number of tabs reached - return
		var li = document.createElement('LI');
		li.className = 'page_aTab';
		page_tabObj.appendChild(li);		
		var tabId = initTabs(Array(tabTitle),0,'','',true);
		if(tabContent)div.innerHTML = tabContent;
		if(tabContentUrl){
		
			var ajaxIndex = ajaxObjects.length;
			ajaxObjects[ajaxIndex] = new sack();
			ajaxObjects[ajaxIndex].requestFile = tabContentUrl;	// Specifying which file to get
			ajaxObjects[ajaxIndex].onCompletion = function(){ showAjaxTabContent(ajaxIndex,tabId); };	// Specify function that will be executed after file has been found
			ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function	
		
		}
				
	}
	
	function getTabIndexByTitle(tabTitle)
	{
		var divs = page_tabObj.getElementsByTagName('DIV');
		for(var no=0;no<divs.length;no++){
			if(divs[no].id.indexOf('tabTab')>=0){
				var span = divs[no].getElementsByTagName('SPAN')[0];
				if(span.innerHTML == tabTitle)return divs[no].id.replace(/[^0-9]/g,'')/1;		
			}
		}
		
		return -1;
		
	}
	
	
	function deleteTab(tabLabel,tabIndex)
	{
		
		if(tabLabel){
			var index = getTabIndexByTitle(tabLabel);
			if(index>=0){
				deleteTab(false,index);
			}
			
		}else if(tabIndex>=0){
			if(document.getElementById('tabTab' + tabIndex)){
				var obj = document.getElementById('tabTab' + tabIndex);
				obj.parentNode.removeChild(obj);
				var obj2 = document.getElementById('tabView' + tabIndex);
				obj2.parentNode.removeChild(obj2);
				resetTabIds();
				activeTabIndex=-1;
				showTab(0);
			}			
		}
		

			
		
		
	}
	
	