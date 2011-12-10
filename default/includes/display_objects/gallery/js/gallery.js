function setGallery(){
	
try
	{
		var gArray=document.getElementById("svGallery").getElementsByTagName("LI");
		
		var h=0;
		var temph=0;
		for(var i=0;i<gArray.length;i++){
			if(jslib =='jquery'){
				temph=getHeightJQuery(gArray[i]);
			} else {
				temph=getHeightPrototype(gArray[i]);
			}
			if (temph > h)
			{h=temph;}
		}
		
		for(var i=0;i<gArray.length;i++){
			if(jslib =='jquery'){
				temph=setHeightJQuery(gArray[i],h);
			} else {
				temph=setHeightPrototype(gArray[i],h);
			}	
		}
	} 

catch(err) {}
}

function getHeightJQuery(theLI){
	return $(theLI).height();
}

function getHeightPrototype(theLI){
	return theLI.getHeight();
}

function setHeightJQuery(theLI,theHeight){
	 $(theLI).height(theHeight);
}

function setHeightPrototype(theLI,theHeight){
	 theLI.style.height=theHeight + "px";
}


addLoadEvent(setGallery);


