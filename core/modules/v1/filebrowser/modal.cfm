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
	MuraFileBrowser.config.resourcepath="#esapiEncode('javascript','User_Assets')#";
	MuraFileBrowser.config.selectMode=2;
	MuraFileBrowser.config.selectCallback=function(){console.log(arguments)};
	MuraFileBrowser.config.height=600;

	siteManager.setDisplayObjectModalWidth(800);

	MuraFileBrowser.render();

});
</script>
</cfoutput>
