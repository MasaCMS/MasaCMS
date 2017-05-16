function setGallery(){

try
	{
		var gArray=document.getElementById("svGallery").getElementsByTagName("LI");

		var h=0;
		var temph=0;
		for(var i=0;i<gArray.length;i++){
			temph=getHeightJQuery(gArray[i]);
			if (temph > h)
			{h=temph;}
		}

		for(var i=0;i<gArray.length;i++){
			temph=setHeightJQuery(gArray[i],h);
		}
	}

catch(err) {}
}

function getHeightJQuery(theLI){
	return $(theLI).height();
}

function setHeightJQuery(theLI,theHeight){
	 $(theLI).height(theHeight);
}

$(document).ready(function(){
	setGallery();
});
