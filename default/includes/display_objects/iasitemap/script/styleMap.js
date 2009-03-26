/*
	Title: StyleMap v2 Javascript
	Author: Scott Jehl, http://www.scottjehl.com
	Date: May 2007
	notes: this script will add classes and an inline width to the sitemap for centering. *for scaling in firefox, the inline width is slightly wider than the actual width of the map.
	USAGE: Free to use, please do not remove this top credits area.
--------------------------------------------------------------------------------------------------------*/

/*
	addClasses function, StyleMap v2
	notes: This script will loop through an embedded Unordered List and add classnames "first" and "last" to the first and last LI in each UL. 
	It also adds the class name 'hasJS' to the body tag to enable the map-view css to work
-----------------------------------------------------*/
			
function addClasses(){
	//add body class to enable map-view css
	var body = document.getElementsByTagName('body')[0];
	body.className+=body.className?' hasJS':'hasJS';
	//set the home li classname to first
	var sitemap = document.getElementById('sitemap');
	var firstLI = sitemap.getElementsByTagName('li')[0];
	var firstDiv = firstLI.getElementsByTagName('div')[0];;
	firstDiv.className+=firstDiv.className?' root':'root';
	//get all the uls
	var uls = document.getElementsByTagName('ul');
		//for each ul loop through and add first, last
	var lis = document.getElementsByTagName('li');
	for(h=0; h<lis.length; h++){
		var thisLI = lis[h];
		var thisLILIs = thisLI.getElementsByTagName('li');
		//if this LI has child LI's then give its firstChild Div the classname 'section'
		if(thisLILIs.length >0){
			var thisLIdiv = thisLI.getElementsByTagName('div')[0];
			thisLIdiv.className+=thisLIdiv.className?' section':'section';
		}
	}
	for(i=0; i<uls.length; i++){
		var thisUL = uls[i];
		//get all the li's in this ul
		var lis = thisUL.getElementsByTagName('li');
		//make an array of the direct children of this ul
		var thisULfirstChilds = new Array;
		var k = 0;
			//for each li in the ul
			for(j=0; j<lis.length; j++){
				var thisLI = lis[j];
					if(thisLI.parentNode == thisUL){
						thisULfirstChilds[k] = thisLI;
						k++;
					}
			}
		//give the first and last nodes of this UL some classnames
		var m = thisULfirstChilds.length - 1;
		if(thisULfirstChilds[0] != thisULfirstChilds[m]){
			if (!/\bfirst\b/.exec(thisULfirstChilds[0].className)) {
				var thisFirstDiv = thisULfirstChilds[0].getElementsByTagName('div')[0];
				thisFirstDiv.className+=thisFirstDiv.className?' first':'first';
			}
			if (!/\blast\b/.exec(thisULfirstChilds[m].className)) {
				var thisLastDiv = thisULfirstChilds[m].getElementsByTagName('div')[0];
				thisLastDiv.className+=thisLastDiv.className?' last':'last';
			}
		}
		//if this ul has only one child LI, give it the className 'solo'
		else{
			thisUL.className+=thisLIdiv.className?' solo':'solo';
		}
	}
}

/*
	Title: hugSiteMap function, Stylemap V2
	Author: Scott Jehl, www.scottjehl.com
	Purpose: This script gets the width of the sitemap and sets its parent container to the same width. Units are in ems for scaling.
-----------------------------------------------------*/
function hugSiteMap(){
	var contain = document.getElementById('contain');
	contain.style.width = '40000px';	
	var sitemap = document.getElementById('sitemap');
	var lis = sitemap.getElementsByTagName('li');
	var lastLi = lis.length - 1;
	var siteMapWidth = lis[lastLi].offsetLeft + lis[lastLi].offsetWidth + '';
	rdEmVal = siteMapWidth.substring(0, siteMapWidth.length - 1);
	emInt = parseInt(rdEmVal) + 3;
	contain.style.width = 'auto';	
	sitemap.style.width = emInt + 'em';
}


/*
	DomReady function
	notes: Allows for firing events off when the dom is ready (window.onload waits for images to load).
	credit: http://www.thefutureoftheweb.com/blog/2006/6/adddomloadevent
-----------------------------------------------------*/
function addDOMLoadEvent(func) { if (!window.__load_events) { var init = function () { 
if (arguments.callee.done) return; arguments.callee.done = true; if (window.__load_timer) { clearInterval(window.__load_timer); window.__load_timer = null;}
for (var i=0;i < window.__load_events.length;i++) { window.__load_events[i]();}
window.__load_events = null;}; if (document.addEventListener) { document.addEventListener("DOMContentLoaded", init, false);}
if (/WebKit/i.test(navigator.userAgent)) { window.__load_timer = setInterval(function() { if (/loaded|complete/.test(document.readyState)) { init();}
}, 10);}
window.onload = init; window.__load_events = [];}
window.__load_events.push(func);}


/*
DOM LOAD EVENTS
-----------------------------------------------------*/
addDOMLoadEvent(addClasses);
addDOMLoadEvent(hugSiteMap);