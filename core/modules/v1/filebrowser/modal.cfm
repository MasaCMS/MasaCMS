<cfparam name="url.target" default="">
<cfparam name="url.completepath" default="true">
<cfoutput>
<div id="MasaBrowserContainer"></div>
<script>

Mura(function(){
	//This set the front end modal window width
	// The default is 'standard'
	var target="#esapiEncode('javascript',url.target)#";
	MuraFileBrowser.config.resourcepath="#esapiEncode('javascript','User_Assets')#";
	MuraFileBrowser.config.selectMode=2;
	MuraFileBrowser.config.displaymode=1;
	MuraFileBrowser.config.selectCallback=function(item){
		siteManager.updateDisplayObjectParams({#esapiEncode('javascript',url.target)#:item.url},false);
	};

	MuraFileBrowser.config.height=600;

	siteManager.setDisplayObjectModalWidth(1000);

	MuraFileBrowser.render();

});
</script>
</cfoutput>
