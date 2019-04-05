<cfparam name="url.target" default="">
<cfparam name="url.completepath" default="true">
<cfoutput>
	<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">
				<div id="MuraFileBrowserContainer"></div>
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.block-constrain -->
<script>

Mura(function(){
	//This set the front end modal window width
	// The default is 'standard'
	var target="#esapiEncode('javascript',url.target)#";
	MuraFileBrowser.config.resourcepath="#esapiEncode('javascript','User_Assets')#";
	MuraFileBrowser.config.selectMode=2;
	MuraFileBrowser.config.displaymode=1;
	MuraFileBrowser.config.selectCallback=function(item){
		siteManager.updateDisplayObjectParams({#esapiEncode('javascript',url.target)#:item.url});
	};

	MuraFileBrowser.config.height=600;

	siteManager.setDisplayObjectModalWidth(1200);

	MuraFileBrowser.render();

});
</script>
</cfoutput>
