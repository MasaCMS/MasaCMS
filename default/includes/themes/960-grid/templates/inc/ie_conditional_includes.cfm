<cfoutput>
	<!--[if lte IE 7]>
		<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/ie.css" type="text/css" media="all" />
		<script src="#$.siteConfig('themeAssetPath')#/js/DD_roundies.js"></script>
		<script>
		  DD_roundies.addRule('.submit, .buttons input, dd.textField .submit', '10px');
		  /* string argument can be any CSS selector */
		</script>
	<![endif]-->
	<!--[if lte IE 6]>
		<script src="#$.siteConfig('assetPath')#/js/DD_belatedPNG.js"></script>
		<script>
		  /* EXAMPLE */
		  DD_belatedPNG.fix('dd.rating, dd.comments');
		  /* string argument can be any CSS selector */
		</script>
	<![endif]-->
</cfoutput>