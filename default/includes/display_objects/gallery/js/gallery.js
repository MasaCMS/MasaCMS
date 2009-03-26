var galleryHeight=0;

function setGallery(theImg){
	var reportedHeight = theImg.parentNode.parentNode.getHeight();
	if(reportedHeight > galleryHeight ){
		galleryHeight=reportedHeight;
		var gArray=document.getElementById("svGallery").getElementsByTagName("LI");
		for(var i=0;i<gArray.length;i++){
				gArray[i].style.height=galleryHeight + 'px';
		}
	}
	
}



