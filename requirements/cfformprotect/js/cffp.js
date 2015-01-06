if(!window.CFFormProtect){
	var CFFormProtect=true;

	// Bas van der Graaf (bvdgraaf@e-dynamics.nl): 
	// Declare getInputElementsByClassName to collect all input fields with a certain classname
	var getInputElementsByClassName = function (c) {
		var r = new Array();
		var j = 0;
		var o = document.getElementsByTagName('input');
		for(i=0;i<o.length;i++)
		{
			if(o[i].className == c) {
				r[j]=o[i];j++;
			}
		}
		return r;
	} 

	/* This code will grab two mouse coordinate sets from the user's mouse.
	 * The first set is shortly after the user starts moving thier mouse across the web page.
	 * The second set is grabbed a specified time later.  The distance between the two sets
	 * is calculated and stored in a form field
	 */

	//tell the browser to start executing the timedMousePos function every x milliseconds
	var myInterval = window.setInterval(timedMousePos,250)

	// Variables for mouse positions
	var xPos = -1;
	var yPos = -1;
	var firstX = -1;
	var firstY = -1;
	// variable to track how many times I polled the mouse position
	var intervals = 0;

	// retrieve mouse x,y coordinates
	function getMousePos(p) {
		if (!p) var p = window.event;
		if (p.pageX || p.pageY) {
			xPos = p.pageX;
			yPos = p.pageY;
		}	else if (p.clientX || p.clientY) {
			xPos = p.clientX + document.body.scrollLeft	+ document.documentElement.scrollLeft;
			yPos = p.clientY + document.body.scrollTop + document.documentElement.scrollTop;
		}
	}

	// capture mouse movement
	function timedMousePos() {
		//when the user moves the mouse, start working
		document.onmousemove = getMousePos;
		if (xPos >= 0 && yPos >= 0) {
			//0,0 is a valid mouse position, so I want to accept that.  for this reason
			//my vars are initialized to -1
			var newX = xPos;
			var newY = yPos;
			intervals++;
		}
		if (intervals == 1) {
			//store the first coordinates when we've got a pair (not when 'intervals' is 0)
		  firstX = xPos;
	  	firstY = yPos;
		} else if (intervals == 2) {
			//I've got two coordinate sets
			//tell the browser to stop executing the timedMousePos function
	  	clearInterval(myInterval);
			//send the 4 mouse coordinates to the calcDistance function
	  	calcDistance(firstX,firstY,newX,newY);
	  }
	}

	function calcDistance(aX,aY,bX,bY) {
		//use the Euclidean 2 dimensional distance formula to calculate the distance 
		//in pizels between the coordinate sets 
		var mouseTraveled = Math.round(Math.sqrt(Math.pow(aX-bX,2)+Math.pow(aY-bY,2)));
		//ajax stuff to set a session variable
		try	{
			// Dave Shuck - 26 Mar 2007 - added try/catch for giant pages that take a while to 
			// load, in case the user moves their mouse before the page is completely rendered.
			// Bas van der Graaf (bvdgraaf@e-dynamics.nl) 
			// Get all usedKeyboard inputs and set value
			var elMouseMovement = getInputElementsByClassName('cffp_mm');
			for (var i=0;i<elMouseMovement.length;i++)
			{
				elMouseMovement[i].value = mouseTraveled
			} 
		}
		catch(excpt) { /* no action to take */ }
	}

	var keysPressed = 0;
	//capture when a user uses types on their keyboard
	document.onkeypress = logKeys;

	function logKeys() {
		//user hit a key, increment the counter
		keysPressed++;
		// Bas van der Graaf (bvdgraaf@e-dynamics.nl) 
		// Get all usedKeyboard inputs and set value
		var elKeyPressed = getInputElementsByClassName('cffp_kp');
		for (var i=0;i<elKeyPressed.length;i++)
		{
			elKeyPressed[i].value = keysPressed
		} 
	}

	function dummy() {}
}