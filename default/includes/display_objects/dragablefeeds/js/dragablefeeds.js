	/************************************************************************************************************
	(C) www.dhtmlgoodies.com, January 2006
	
	This is a script from www.dhtmlgoodies.com. You will find this and a lot of other scripts at our website.	
	
	Version:	1.0	: January 16th - 2006
				1.1 : January 31th - 2006 - Added cookie support - remember rss sources
	
	Terms of use:
	You are free to use this script as long as the copyright message is kept intact. However, you may not
	redistribute, sell or repost it without our permission.
	
	Thank you!
	
	www.dhtmlgoodies.com
	Alf Magne Kalleland
	
	Modified by blueriver for Mura CMS
	
	************************************************************************************************************/		
	
	/* USER VARIABLES */
	var imageHome = context + '/' + siteid + '/includes/display_objects/dragablefeeds/images/';
	var numberOfColumns = 2;	// Number of columns for dragable boxes
	var columnParentBoxId = 'svRSSFeeds';	// Id of box that is parent of all your dragable boxes
	// These may not be used, depending on implementation.
	var src_rightImage = imageHome + 'arrow_right.gif';
	var src_downImage = imageHome + 'arrow_down.gif';
	var src_refreshSource = imageHome + 'refresh.gif';
	var src_smallRightArrow = imageHome + 'small_arrow.gif';
	var src_closeSource = imageHome + 'delete.gif';
	var src_editSource = imageHome + 'info.gif';
	
	var transparencyWhenDragging = false;
	var txt_editLink = 'Edit';
	var txt_editLink_stop = 'End edit';
	var autoScrollSpeed = 4;	// Autoscroll speed	- Higher = faster	
	var dragObjectBorderWidth = 1;	// Border size of your RSS boxes - used to determine width of dotted rectangle
	
	var useCookiesToRememberRSSSources = true;
	
	var userID = '';
	var loginPage = '';
	var redirecting = false;
	
	/* END USER VARIABLES */
	
	
	
	var columnParentBox;
	var dragableBoxesObj;
	
	var ajaxObjects = new Array();
	
	var boxIndex = 0;	
	var autoScrollActive = false;
	var dragableBoxesArray = new Array();
	
	var dragDropCounter = -1;
	var dragObject = false;
	var dragObjectNextSibling = false;
	var dragObjectParent = false;
	var destinationObj = false;
	
	var mouse_x;
	var mouse_y;
	
	var el_x;
	var el_y;	
	
	var rectangleDiv;
	var okToMove = true;

	var documentHeight = false;
	var documentScrollHeight = false;
	var dragableAreaWidth = false;
		
	var opera = navigator.userAgent.toLowerCase().indexOf('opera')>=0?true:false;
	var cookieCounter=0;
	var cookieRSSSources = new Array();	
	
	var feeditems='Items';
	var feedsource='Source';
	var feedsave='Save';
		
	/*
	These cookie functions are downloaded from 
	http://www.mach5.com/support/analyzer/manual/html/General/CookiesJavaScript.htm
	*/	
	function Get_Cookie(name) { z
	   var start = document.cookie.indexOf(name+"="); 
	   var len = start+name.length+1; 
	   if ((!start) && (name != document.cookie.substring(0,name.length))) return null; 
	   if (start == -1) return null; 
	   var end = document.cookie.indexOf(";",len); 
	   if (end == -1) end = document.cookie.length; 
	   return unescape(document.cookie.substring(len,end)); 
	} 
	// This function has been slightly modified
	function Set_Cookie(name,value,expires,path,domain,secure) { 
		/*expires = expires * 60*60*24*1000;
		var today = new Date();
		var expires_date = new Date( today.getTime() + (expires) );
	    var cookieString = name + "=" +escape(value) + 
	       ( (expires) ? ";expires=" + expires_date.toGMTString() : "") + 
	       ( (path) ? ";path=" + path : "") + 
	       ( (domain) ? ";domain=" + domain : "") + 
	       ( (secure) ? ";secure" : ""); 
	    document.cookie = cookieString; */
	} 

	function autoScroll(direction,yPos)
	{
		if(document.documentElement.scrollHeight>documentScrollHeight && direction>0)return;
		if(opera)return;
		window.scrollBy(0,direction);
		
		if(direction<0){
			if(document.documentElement.scrollTop>0){
				dragObject.style.top = (el_y - mouse_y + yPos + document.documentElement.scrollTop) + 'px';		
			}else{
				autoScrollActive = false;
			}
		}else{
			if(yPos>(documentHeight-50)){	
				dragObject.style.top = (el_y - mouse_y + yPos + document.documentElement.scrollTop) + 'px';			
			}else{
				autoScrollActive = false;
			}
		}
		if(autoScrollActive)setTimeout('autoScroll('+direction+',' + yPos + ')',5);
	}
		
	function initDragDropBox(e)
	{
		
		dragDropCounter = 1;
		if(document.all)e = event;
		
		if (e.target) source = e.target;
			else if (e.srcElement) source = e.srcElement;
			if (source.nodeType == 3) // defeat Safari bug
				source = source.parentNode;
		
		if(source.tagName.toLowerCase()=='img' || source.tagName.toLowerCase()=='a' || source.tagName.toLowerCase()=='input' || source.tagName.toLowerCase()=='td' || source.tagName.toLowerCase()=='tr' || source.tagName.toLowerCase()=='table')return;
		
	
		mouse_x = e.clientX;
		mouse_y = e.clientY;	
		var numericId = this.id.replace(/[^0-9]/g,'');
		el_x = getLeftPos(this.parentNode)/1;
		el_y = getTopPos(this.parentNode)/1 - document.documentElement.scrollTop;
			
		dragObject = this.parentNode;
		
		documentScrollHeight = document.documentElement.scrollHeight + 100 + dragObject.offsetHeight;
		
		
		if(dragObject.nextSibling){
			dragObjectNextSibling = dragObject.nextSibling;
			if(dragObjectNextSibling.tagName!='DIV')dragObjectNextSibling = dragObjectNextSibling.nextSibling;
		}
		dragObjectParent = dragableBoxesArray[numericId]['parentObj'];
			
		dragDropCounter = 0;
		initDragDropBoxTimer();	
		
		return false;
	}
	
	
	function initDragDropBoxTimer()
	{
		if(dragDropCounter>=0 && dragDropCounter<10){
			dragDropCounter++;
			setTimeout('initDragDropBoxTimer()',10);
			return;
		}
		if(dragDropCounter==10){
			//mouseoutBoxHeader(false,dragObject);
		}
		
	}

	function moveDragableElement(e){
		if(document.all)e = event;
		if(dragDropCounter<10)return;
		
		if(document.body!=dragObject.parentNode){
			dragObject.style.width = (dragObject.offsetWidth - (dragObjectBorderWidth*2)) + 'px';
			dragObject.style.position = 'absolute';	
			dragObject.style.textAlign = 'left';
			if(transparencyWhenDragging){	
				dragObject.style.filter = 'alpha(opacity=70)';
				dragObject.style.opacity = '0.7';
			}	
			dragObject.parentNode.insertBefore(rectangleDiv,dragObject);
			rectangleDiv.style.display='block';
			document.body.appendChild(dragObject);

			rectangleDiv.style.width = dragObject.style.width;
			rectangleDiv.style.height = (dragObject.offsetHeight - (dragObjectBorderWidth*2)) + 'px'; 
			
		}
		
		if(e.clientY<50 || e.clientY>(documentHeight-50)){
			if(e.clientY<50 && !autoScrollActive){
				autoScrollActive = true;
				autoScroll((autoScrollSpeed*-1),e.clientY);
			}
			
			if(e.clientY>(documentHeight-50) && document.documentElement.scrollHeight<=documentScrollHeight && !autoScrollActive){
				autoScrollActive = true;
				autoScroll(autoScrollSpeed,e.clientY);
			}
		}else{
			autoScrollActive = false;
		}		

		
		var leftPos = e.clientX;
		var topPos = e.clientY + document.documentElement.scrollTop;
		
		dragObject.style.left = (e.clientX - mouse_x + el_x) + 'px';
		dragObject.style.top = (el_y - mouse_y + e.clientY + document.documentElement.scrollTop) + 'px';
								

		
		if(!okToMove)return;
		okToMove = false;

		destinationObj = false;	
		rectangleDiv.style.display = 'none'; 
		
		var objFound = false;
		var tmpParentArray = new Array();
		
		if(!objFound){
			for(var no=1;no<dragableBoxesArray.length;no++){
				if(dragableBoxesArray[no]['obj']==dragObject)continue;
				tmpParentArray[dragableBoxesArray[no]['obj'].parentNode.id] = true;
				if(!objFound){
					var tmpX = getLeftPos(dragableBoxesArray[no]['obj']);
					var tmpY = getTopPos(dragableBoxesArray[no]['obj']);

					if(leftPos>tmpX && leftPos<(tmpX + dragableBoxesArray[no]['obj'].offsetWidth) && topPos>(tmpY-20) && topPos<(tmpY + (dragableBoxesArray[no]['obj'].offsetHeight/2))){
						destinationObj = dragableBoxesArray[no]['obj'];
						destinationObj.parentNode.insertBefore(rectangleDiv,dragableBoxesArray[no]['obj']);
						rectangleDiv.style.display = 'block';
						objFound = true;
						break;
						
					}
					
					if(leftPos>tmpX && leftPos<(tmpX + dragableBoxesArray[no]['obj'].offsetWidth) && topPos>=(tmpY + (dragableBoxesArray[no]['obj'].offsetHeight/2)) && topPos<(tmpY + dragableBoxesArray[no]['obj'].offsetHeight)){
						objFound = true;
						if(dragableBoxesArray[no]['obj'].nextSibling){
							
							destinationObj = dragableBoxesArray[no]['obj'].nextSibling;
							if(!destinationObj.tagName)destinationObj = destinationObj.nextSibling;
							if(destinationObj!=rectangleDiv)destinationObj.parentNode.insertBefore(rectangleDiv,destinationObj);
						}else{
							destinationObj = dragableBoxesArray[no]['obj'].parentNode;
							dragableBoxesArray[no]['obj'].parentNode.appendChild(rectangleDiv);
						}
						rectangleDiv.style.display = 'block';
						break;					
					}
					
					
					if(!dragableBoxesArray[no]['obj'].nextSibling && leftPos>tmpX && leftPos<(tmpX + dragableBoxesArray[no]['obj'].offsetWidth)
					&& topPos>topPos>(tmpY + (dragableBoxesArray[no]['obj'].offsetHeight))){
						destinationObj = dragableBoxesArray[no]['obj'].parentNode;
						dragableBoxesArray[no]['obj'].parentNode.appendChild(rectangleDiv);	
						rectangleDiv.style.display = 'block';	
						objFound = true;				
						
					}
				}
				
			}
		
		}
		
		if(!objFound){
			
			for(var no=1;no<=numberOfColumns;no++){
				if(!objFound){
					var obj = document.getElementById('dragableBoxesColumn' + no);			
					
						var left = getLeftPos(obj)/1;						
					
						var width = obj.offsetWidth;
						if(leftPos>left && leftPos<(left+width)){
							destinationObj = obj;
							obj.appendChild(rectangleDiv);
							rectangleDiv.style.display='block';
							objFound=true;		
							
						}				
					
				}
			}		
			
		}
	

		setTimeout('okToMove=true',5);
		
	}
	
	function stop_dragDropElement()
	{

		if(dragDropCounter<10){
			dragDropCounter = -1
			return;
		}
		dragDropCounter = -1;
		if(transparencyWhenDragging){
			dragObject.style.filter = null;
			dragObject.style.opacity = null;
		}		
		dragObject.style.position = 'static';
		dragObject.style.width = null;
		var numericId = dragObject.id.replace(/[^0-9]/g,'');
		if(destinationObj && destinationObj.id!=dragObject.id){
			
			if(destinationObj.id.indexOf('dragableBoxesColumn')>=0){
				destinationObj.appendChild(dragObject);
				dragableBoxesArray[numericId]['parentObj'] = destinationObj;
			}else{
				destinationObj.parentNode.insertBefore(dragObject,destinationObj);
				dragableBoxesArray[numericId]['parentObj'] = destinationObj.parentNode;
			}


							
		}else{
			if(dragObjectNextSibling){
				dragObjectParent.insertBefore(dragObject,dragObjectNextSibling);	
			}else{
				dragObjectParent.appendChild(dragObject);
			}				
			
			
		}
	

		
		autoScrollActive = false;
		rectangleDiv.style.display = 'none'; 
		dragObject = false;
		dragObjectNextSibling = false;
		destinationObj = false;
		
		if(useCookiesToRememberRSSSources)setTimeout('saveCookies()',100);

		documentHeight = document.documentElement.clientHeight;	
	}

	function saveCookies()
	{
		deleteRssFavorites(userID, siteID);
		
		cookieCounter = 0;
		var tmpUrlArray = new Array();
		for(var no=1;no<=numberOfColumns;no++)
		{
			var parentObj = document.getElementById('dragableBoxesColumn' + no);
			
			var items = parentObj.getElementsByTagName('DIV');
			if(items.length==0)continue;
			
			var item = items[0];
			
			var tmpItemArray = new Array();
			while(item){
				var boxIndex = item.id.replace(/[^0-9]/g,'');
				if(item.id!='rectangleDiv' && item.style.display != 'none'){
					tmpItemArray[tmpItemArray.length] = boxIndex;
				}	
				item = item.nextSibling;			
			}
			
			var columnIndex = no;
			
			for(var no2=tmpItemArray.length-1;no2>=0;no2--){
				var boxIndex = tmpItemArray[no2];
				var url = dragableBoxesArray[boxIndex]['rssUrl'];
				var heightOfBox = dragableBoxesArray[boxIndex]['heightOfBox'];
				var maxRssItems = dragableBoxesArray[boxIndex]['maxRssItems'];
				var minutesBeforeReload = dragableBoxesArray[boxIndex]['minutesBeforeReload'];
				
				
				
			//	if(!tmpUrlArray[url]){
				//	tmpUrlArray[url] = true;
					Set_Cookie('dragable_rss_boxes' + cookieCounter,url + '#;#' + columnIndex + '#;#' + maxRssItems + '#;#' + heightOfBox + '#;#' + minutesBeforeReload ,60000);
					cookieRSSSources[url] = cookieCounter;
					cookieCounter++;
					saveRssFavorite(userID, siteID, "RSS Favorite", url, "RSS", columnIndex, cookieCounter, maxRssItems);
					
					//alert(url);
					
				//}			
				
			}
		}
	}
	

	
	function redirectToLogin() {
		if (!redirecting){
			redirecting = true;
			alert('Sorry, you must be logged in to edit news feeds');
			window.location = loginURL;	
		}	
		
	}
	
	function getTopPos(inputObj)
	{		
	  var returnValue = inputObj.offsetTop;
	  while((inputObj = inputObj.offsetParent) != null){
	  	if(inputObj.tagName!='HTML')returnValue += inputObj.offsetTop;
	  }
	  return returnValue;
	}
	
	function getLeftPos(inputObj)
	{
	  var returnValue = inputObj.offsetLeft;
	  while((inputObj = inputObj.offsetParent) != null){
	  	if(inputObj.tagName!='HTML')returnValue += inputObj.offsetLeft;
	  }
	  return returnValue;
	}
		
	
	function createColumns()
	{
		if(!columnParentBoxId){
			alert('No parent box defined for your columns');
			return;
		}
		columnParentBox = document.getElementById(columnParentBoxId);
		var columnWidth = Math.floor(100/numberOfColumns);
		var sumWidth = 0;
		for(var no=0;no<numberOfColumns;no++){
			var div = document.createElement('DIV');
			if(no==(numberOfColumns-1))columnWidth = 99 - sumWidth;
			sumWidth = sumWidth + columnWidth;
			div.style.cssText = 'float:left;';
//			div.style.cssText = 'float:left;width:'+columnWidth+'%;';
//			div.style.height='100%';
			div.style.styleFloat='left';
//			div.style.width = columnWidth + '%';
//			div.style.padding = '0px';
//			div.style.margin = '0px';

			div.id = 'dragableBoxesColumn' + (no+1);
			columnParentBox.appendChild(div);
			
//			var clearObj = document.createElement('HR');	
//			clearObj.style.clear = 'both';
//			clearObj.style.visibility = 'hidden';
//			div.appendChild(clearObj);
		}
		
		
		
		var clearingDiv = document.createElement('DIV');
		columnParentBox.appendChild(clearingDiv);
		clearingDiv.style.clear='both';
		
	}
	
	function mouseoverBoxHeader()
	{
		/*if(dragDropCounter==10)return;
		var id = this.id.replace(/[^0-9]/g,'');
		document.getElementById('dragableBoxExpand' + id).style.visibility = 'visible';		
		document.getElementById('dragableBoxRefreshSource' + id).style.visibility = 'visible';		
		document.getElementById('dragableBoxCloseSource' + id).style.visibility = 'visible';
		document.getElementById('dragableBoxEditLink' + id).style.visibility = 'visible';*/
		
	}
	function mouseoutBoxHeader(e,obj)
	{
		/*if(!obj)obj=this;
		
		var id = obj.id.replace(/[^0-9]/g,'');
		document.getElementById('dragableBoxExpand' + id).style.visibility = 'hidden';		
		document.getElementById('dragableBoxRefreshSource' + id).style.visibility = 'hidden';		
		document.getElementById('dragableBoxCloseSource' + id).style.visibility = 'hidden';		
		document.getElementById('dragableBoxEditLink' + id).style.visibility = 'hidden';	*/	
		
	}
	
	function refreshRSS()
	{
		reloadRSSData(this.id.replace(/[^0-9]/g,''));
		setTimeout('dragDropCounter=-5',5);
	}
	
	function showHideBoxContent()
	{
		var numericId = this.id.replace(/[^0-9]/g,'');
		var obj = document.getElementById('dragableBoxContent' + numericId);
		
		//alert(obj.style.display);
		
		obj.style.display = obj.style.display.indexOf('block')>=0?'none':'block';
		//this.src = this.src.indexOf(src_rightImage)>=0?src_downImage:src_rightImage
		setTimeout('dragDropCounter=-5',5);
	}
	
	/*function mouseover_CloseButton()
	{
		this.className = 'closeButton_over';	
		setTimeout('dragDropCounter=-5',5);
	}
	
	function highlightCloseButton()
	{
		this.className = 'closeButton_over';	
	}
	
	function mouseout_CloseButton()
	{
		this.className = 'closeButton';	
	}*/
	
	function closeDragableBox()
	{
		var numericId = this.id.replace(/[^0-9]/g,'');
		document.getElementById('dragableBox' + numericId).style.display='none';
		//new Element.remove($('dragableBox' + numericId));	
		Set_Cookie('dragable_rss_boxes' + cookieRSSSources[dragableBoxesArray[numericId]['rssUrl']],'none' ,60000);
		// remove element from array
		//dragableBoxesArray.splice(numericId,1);
		saveCookies();
		
		setTimeout('dragDropCounter=-5',5);
		
	}
	
	function editRSSContent()
	{
		var numericId = this.id.replace(/[^0-9]/g,'');
		var obj = document.getElementById('dragableBoxEdit' + numericId);
		if(obj.style.display=='none'){
			obj.style.display='block';
			//this.innerHTML = txt_editLink_stop;
			document.getElementById('dragableBoxHeader' + numericId).style.height = '135px';
		}else{
			obj.style.display='none';
			//this.innerHTML = txt_editLink;
			document.getElementById('dragableBoxHeader' + numericId).style.height = '20px';
		}
		setTimeout('dragDropCounter=-5',5);
	}
	
	
	function showStatusBarMessage(numericId,message)
	{
		document.getElementById('dragableBoxStatusBar' + numericId).innerHTML = message;
		
	}
	
	function addBoxHeader(parentObj)
	{
		/*var div = document.createElement('DIV');
		div.className = 'dragableBoxHeader';
		div.style.cursor = 'move';
		div.id = 'dragableBoxHeader' + boxIndex;
		div.onmousedown = initDragDropBox;
		//div.onmouseover = mouseoverBoxHeader;
		//div.onmouseout = mouseoutBoxHeader;

		var image = document.createElement('IMG');
		image.id = 'dragableBoxExpand' + boxIndex;
		image.src = src_rightImage;
		image.style.cursor = 'pointer';
		image.onmousedown = showHideBoxContent;	
		div.appendChild(image);
		
		var textSpan = document.createElement('SPAN');
		textSpan.id = 'dragableBoxHeader_txt' + boxIndex;
		div.appendChild(textSpan);
				
		var image = document.createElement('IMG');
		image.src = src_closeSource;
		image.id = 'dragableBoxCloseSource' + boxIndex;
		image.style.cssText = 'float:right';
		image.style.styleFloat = 'right';
		image.onclick = closeDragableBox;
		image.style.cursor = 'pointer';
		div.appendChild(image);
		
		
		var image = document.createElement('IMG');
		image.src = src_refreshSource;
		image.id = 'dragableBoxRefreshSource' + boxIndex;
		image.style.cssText = 'float:right';
		image.style.styleFloat = 'right';
		image.onclick = refreshRSS;
		image.style.cursor = 'pointer';
		div.appendChild(image);
		
		
		parentObj.appendChild(div);*/
		
		
		
		
		var div = document.createElement('DIV');
		div.className = 'dragableBoxHeader';
		div.style.cursor = 'move';
		div.id = 'dragableBoxHeader' + boxIndex;
		//div.onmouseover = mouseoverBoxHeader;
		//div.onmouseout = mouseoutBoxHeader;
		div.onmousedown = initDragDropBox;
		
		var collapseLink = document.createElement('A');
//		collapseLink.style.cssText = 'float:left';
//		collapseLink.style.styleFloat = 'left';
		collapseLink.id = 'dragableBoxExpand' + boxIndex;
		collapseLink.innerHTML = 'Collapse&nbsp;';
		collapseLink.className = 'RSSbuttonCollapse';
		collapseLink.onmousedown = showHideBoxContent;	
		collapseLink.style.cursor = 'pointer';
		collapseLink.style.display = 'none';
		div.appendChild(collapseLink);

		var textSpan = document.createElement('SPAN');
		textSpan.id = 'dragableBoxHeader_txt' + boxIndex;
		textSpan.className = 'RSSHeader';
		div.appendChild(textSpan);
		
		var closeLink = document.createElement('A');
//		closeLink.style.cssText = 'float:right';
//		closeLink.style.styleFloat = 'right';
		closeLink.id = 'dragableBoxCloseLink' + boxIndex;
		closeLink.innerHTML = 'Close';
		closeLink.style.cursor = 'pointer';
		//closeLink.style.visibility = 'hidden';
		closeLink.className = 'RSSbuttonClose';
		closeLink.onmousedown = closeDragableBox;
		div.appendChild(closeLink);
		
		/*var image = document.createElement('IMG');
		image.src = src_closeSource;
		image.id = 'dragableBoxCloseSource' + boxIndex;
		image.style.cssText = 'float:right';
		image.style.styleFloat = 'right';
		image.onclick = closeDragableBox;
		image.style.cursor = 'pointer';
		div.appendChild(image);*/
		
	/*	var refreshLink = document.createElement('A');
		refreshLink.style.cssText = 'float:right';
		refreshLink.style.styleFloat = 'right';
		refreshLink.id = 'dragableBoxRefreshSource' + boxIndex;
		refreshLink.innerHTML = 'Refresh';
		refreshLink.style.cursor = 'pointer';
		refreshLink.style.display = 'none';
		collapseLink.className = 'RSSbuttonRefresh';
		refreshLink.onclick = refreshRSS;
		div.appendChild(refreshLink);*/
		
		parentObj.appendChild(div);	
	}
	
	function saveFeed(boxIndex)
	{
		var heightOfBox = dragableBoxesArray[boxIndex]['heightOfBox'];// = document.getElementById('heightOfBox[' + boxIndex + ']').value;
		var intervalObj = dragableBoxesArray[boxIndex]['intervalObj'];
		if(intervalObj)clearInterval(intervalObj);
		
		if(heightOfBox && heightOfBox>40){
			var contentObj = document.getElementById('dragableBoxContent' + boxIndex);
			contentObj.style.height = heightOfBox + 'px';
			contentObj.setAttribute('heightOfBox',heightOfBox);
			contentObj.heightOfBox = heightOfBox;	
			if(document.all)contentObj.style.overflowY = 'auto';else contentObj.style.overflow='-moz-scrollbars-vertical;';
			if(opera)contentObj.style.overflow='auto';			
			
		}
		
		dragableBoxesArray[boxIndex]['rssUrl'] = document.getElementById('rssUrl[' + boxIndex + ']').value;
		dragableBoxesArray[boxIndex]['heightOfBox'] = heightOfBox;
		dragableBoxesArray[boxIndex]['maxRssItems'] = document.getElementById('maxRssItems[' + boxIndex + ']').value;
		//dragableBoxesArray[boxIndex]['heightOfBox'] = document.getElementById('heightOfBox[' + boxIndex + ']').value;
		//dragableBoxesArray[boxIndex]['minutesBeforeReload'] = document.getElementById('minutesBeforeReload[' + boxIndex + ']').value;
		
		if(dragableBoxesArray[boxIndex]['minutesBeforeReload'] && dragableBoxesArray[boxIndex]['minutesBeforeReload']>5){
			var tmpInterval = setInterval("reloadRSSData(" + boxIndex + ")",(dragableBoxesArray[boxIndex]['minutesBeforeReload']*1000*60));	
			dragableBoxesArray[boxIndex]['intervalObj'] = tmpInterval;
		}
		
		reloadRSSData(boxIndex);
		
		if(useCookiesToRememberRSSSources)setTimeout('saveCookies()',100);
		
	}
	
	function addRSSEditcontent(parentObj)
	{

		/*var image = document.createElement('IMG');
		image.src = src_editSource;
		image.id = 'dragableBoxEditLink' + boxIndex;
		image.style.cssText = 'float:right';
		image.style.styleFloat = 'right';
		image.className = 'dragableBoxEditLink';
		image.onclick = cancelEvent;
		image.style.cursor = 'pointer';
		image.onmousedown = editRSSContent
		parentObj.appendChild(image);*/
		
		var editLink = document.createElement('A');
		editLink.href = '#';
		editLink.onclick = cancelEvent;
//		editLink.style.cssText = 'float:right';
//		editLink.style.styleFloat = 'right';
		editLink.id = 'dragableBoxEditLink' + boxIndex;
		editLink.innerHTML = txt_editLink;
		editLink.className = 'RSSbuttonEdit';
		editLink.style.cursor = 'pointer';
		//editLink.style.visibility = 'hidden';
		editLink.onmousedown = editRSSContent;
		parentObj.appendChild(editLink);	

				
		var editBox = document.createElement('DIV');
		editBox.style.clear='both';
		editBox.id = 'dragableBoxEdit' + boxIndex;
		editBox.style.display='none';
		
		var content = '<form class="RSSeditForm"><table><tr><td>' + feedsource + ':<\/td><td><input type="text" id="rssUrl[' + boxIndex + ']" value="' + dragableBoxesArray[boxIndex]['rssUrl'] + '"  class="text"><\/td><\/tr>'
		+'<tr><td>' + feeditems + ':<\/td><td><input type="text" class="text" id="maxRssItems[' + boxIndex + ']" onblur="this.value = this.value.replace(/[^0-9]/g,\'\');if(!this.value)this.value=' + dragableBoxesArray[boxIndex]['maxRssItems'] + '" value="' + dragableBoxesArray[boxIndex]['maxRssItems'] + '" size="2" maxlength="2"><\/td><\/tr>'
		//+'<tr><td>Fixed height:<\/td><td><input type="text" id="heightOfBox[' + boxIndex + ']" onblur="this.value = this.value.replace(/[^0-9]/g,\'\');if(!this.value)this.value=' + dragableBoxesArray[boxIndex]['heightOfBox'] + '" value="' + dragableBoxesArray[boxIndex]['heightOfBox'] + '" size="2" maxlength="3"><\/td><\/tr>'
		//+'<tr><td>Reload every:<\/td><td width="30"><input type="text" id="minutesBeforeReload[' + boxIndex + ']" onblur="this.value = this.value.replace(/[^0-9]/g,\'\');if(!this.value || this.value/1<5)this.value=' + dragableBoxesArray[boxIndex]['minutesBeforeReload'] + '" value="' + dragableBoxesArray[boxIndex]['minutesBeforeReload'] + '" size="2" maxlength="3">&nbsp;minute<\/td><\/tr>'
		+'<tr><td colspan="2"><input type="button" onclick="saveFeed(' + boxIndex + ')" value="' + feedsave + '"><\/td><\/tr><\/table><\/form>';
		editBox.innerHTML = content;
		
		parentObj.appendChild(editBox);		
		
	}
	
	
	function addBoxContentContainer(parentObj,heightOfBox)
	{
		var div = document.createElement('DIV');
		div.className = 'dragableBoxContent';
		div.style.display = 'block';
		if(opera)div.style.clear='none';
		div.id = 'dragableBoxContent' + boxIndex;
		parentObj.appendChild(div);			
		if(heightOfBox && heightOfBox/1>40){
			div.style.height = heightOfBox + 'px';
			div.setAttribute('heightOfBox',heightOfBox);
			div.heightOfBox = heightOfBox;	
			if(document.all)div.style.overflowY = 'auto';else div.style.overflow='-moz-scrollbars-vertical;';
			if(opera)div.style.overflow='auto';
		}		
	}
	
	function addBoxStatusBar(parentObj)
	{
		var div = document.createElement('DIV');
		div.className = 'dragableBoxStatusBar';
		div.id = 'dragableBoxStatusBar' + boxIndex;
		parentObj.appendChild(div);	
		
		
	}
	
	function createABox(columnIndex,heightOfBox)
	{
		boxIndex++;
		
		var div = document.createElement('DIV');
		div.className = 'dragableBox';
		div.id = 'dragableBox' + boxIndex;
		addBoxHeader(div);
		addBoxContentContainer(div,heightOfBox);
		addBoxStatusBar(div);
		
		var obj = document.getElementById('dragableBoxesColumn' + columnIndex);		
		var subs = obj.getElementsByTagName('DIV');
		if(subs.length>0){
			obj.insertBefore(div,subs[0]);
		}else{
			obj.appendChild(div);
		}
		
		dragableBoxesArray[boxIndex] = new Array();
		dragableBoxesArray[boxIndex]['obj'] = div;
		dragableBoxesArray[boxIndex]['parentObj'] = div.parentNode;
		
		

		
		
		return boxIndex;
		
	}
	
	function showRSSData(transport,boxIndex)
	{
		if(jslib=="jquery"){
			var rssContent = transport;		
		} else {
			var rssContent = transport.responseText;	
		}
		
		var tokens = rssContent.split(/\n\n/g);
		
		var headerTokens = tokens[0].split(/\n/g);
		if(headerTokens[0]=='0'){
			headerTokens[1] = '';
			headerTokens[0] = 'Invalid source';
		}
		
		document.getElementById('dragableBoxHeader_txt' + boxIndex).innerHTML = '<span>' + headerTokens[0] + '<\/span><span class="rssNumberOfItems">(' + headerTokens[1] + ')<\/span>';	// title
		
		var string = '<ul class=\"dragableFeeds\">';
		for(var no=1;no<tokens.length;no++){	// Looping through RSS items
			var itemTokens = tokens[no].split(/##/g);			
			string = string + '<li class=\"boxItemHeader\"><a class=\"boxItemHeader\" href="' + itemTokens[3] + '" onclick="var w = window.open(this.href);return false">' + itemTokens[0] + '<\/a><\/li>';		
		}
		/*for(var no=1;no<tokens.length;no++){	// Looping through RSS items
			alert(tokens[1]);
			var itemTokens = tokens[no].split(/##/g);
			for(var no2=0;no2<itemTokens.length;no2++) {
				alert(itemTokens[2]);
			}
		}*/
		var string = string + '<\/ul>';
		document.getElementById('dragableBoxContent' + boxIndex).innerHTML = string;
		showStatusBarMessage(boxIndex,'');
		//ajaxObjects[ajaxIndex] = false;
	}

		
	function createARSSBox(url,columnIndex,heightOfBox,maxRssItems,minutesBeforeReload)
	{

		if(!heightOfBox)heightOfBox = '0';
		if(!minutesBeforeReload)minutesBeforeReload = '20';

			
		var tmpIndex = createABox(columnIndex,heightOfBox);

		if(useCookiesToRememberRSSSources)
		{
			if(!cookieRSSSources[url]){
				cookieRSSSources[url] = cookieCounter;		
				Set_Cookie('dragable_rss_boxes' + cookieCounter,url + '#;#' + columnIndex + '#;#' + maxRssItems + '#;#' + heightOfBox + '#;#' + minutesBeforeReload ,60000);
				cookieCounter++;
			}
		}		
		
		dragableBoxesArray[tmpIndex]['rssUrl'] = url;
		dragableBoxesArray[tmpIndex]['maxRssItems'] = maxRssItems?maxRssItems:100;
		dragableBoxesArray[tmpIndex]['minutesBeforeReload'] = minutesBeforeReload;
		dragableBoxesArray[tmpIndex]['heightOfBox'] = heightOfBox;
		
		var tmpInterval = false;
		if(minutesBeforeReload && minutesBeforeReload>0){
			var tmpInterval = setInterval("reloadRSSData(" + tmpIndex + ")",(minutesBeforeReload*1000*60));
		}

		dragableBoxesArray[tmpIndex]['intervalObj'] = tmpInterval;
			
		addRSSEditcontent(document.getElementById('dragableBoxHeader' + tmpIndex))
			
		if(!document.getElementById('dragableBoxContent' + tmpIndex).innerHTML)document.getElementById('dragableBoxContent' + tmpIndex).innerHTML = '&nbsp; Loading data...';
		
		if(!maxRssItems)maxRssItems = 100;
		
		reloadRSSData(tmpIndex);
	}
	
	function createHelpObjects()
	{
		/* Creating rectangle div */
		rectangleDiv = document.createElement('DIV');
		rectangleDiv.id='rectangleDiv';
		rectangleDiv.style.display='none';
		document.body.appendChild(rectangleDiv);
		
		 
	}
	
	function cancelSelectionEvent(e)
	{
		if(document.all)e = event;
		
		if (e.target) source = e.target;
			else if (e.srcElement) source = e.srcElement;
			if (source.nodeType == 3) // defeat Safari bug
				source = source.parentNode;
		if(source.tagName.toLowerCase()=='input')return true;
						
		if(dragDropCounter>=0)return false; else return true;	
		
	}
	
	function cancelEvent()
	{
		return false;
	}
	
	function initEvents()
	{
		document.body.onmousemove = moveDragableElement;
		document.body.onmouseup = stop_dragDropElement;
		document.body.onselectstart = cancelSelectionEvent;

		document.body.ondragstart = cancelEvent;	
		
		documentHeight = document.documentElement.clientHeight;	
		
	}
	
	function initDragableBoxesScript()
	{
		createColumns();	// Always the first line of this function
		createHelpObjects();	// Always the second line of this function
		initEvents();	// Always the third line of this function
		//if(useCookiesToRememberRSSSources)createRSSBoxesFromCookie();
		//createDefaultBoxes();
		createBoxes();
	}
	
	
	
	function createFeed(formObj)
	{
		var box = formObj.rssURL;
		var selectURL = box.options[box.selectedIndex].value;
		var items = '5';
		var height = '';
		var reloadInterval = '60';
		var textURL = formObj.rssURLtext.value;
		var url = '';
		
		if(userID == ''){
			redirectToLogin();
		} else {
			if(textURL != ''){
				url = textURL;
			}else if (selectURL != ''){
				url = selectURL;
			}
			
			if(isNaN(height) || height/1<40)height = false;	
			if(isNaN(reloadInterval) || reloadInterval/1<5)reloadInterval = false;
			createARSSBox(url,1,height,items,reloadInterval);	
			saveCookies();
		}
	}
	
	function createRSSBoxesFromCookie()
	{
		var tmpArray = new Array();
		var cookieValue = Get_Cookie('dragable_rss_boxes0');
		while(cookieValue && cookieValue!=''){
			var items = cookieValue.split('#;#');
			if(items.length>1 && !tmpArray[items[0]]){
				tmpArray[items[0]] = true;
				createARSSBox(items[0],items[1],items[3],items[2],items[4]);
				cookieRSSSources[items[0]]==cookieCounter;
			}else{
				cookieCounter++;
			}
			var cookieValue = Get_Cookie('dragable_rss_boxes' + cookieCounter);
		}
				
		
	}
	
	/* You customize this function */
	function createDefaultBoxes()
	{		

		
		/*if(cookieCounter==0){
			createARSSBox('http://rss.cnn.com/rss/cnn_topstories.rss',1,false,5,1);			
			createARSSBox('http://feeds.feedburner.com/reuters/topNews/',1,false,5);			
			createARSSBox('http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml',1,false,5,10);			
			createARSSBox('http://rss.pcworld.com/rss/latestnews.rss',1,false,5);			
			createARSSBox('http://www.w3.org/2000/08/w3c-synd/home.rss',1,false,5,30);	
		}*/
		
	}
	
	
