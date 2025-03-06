<cfsilent>

	<cfscript>
		if(server.coldfusion.productname != 'ColdFusion Server'){
			backportdir='';
			include "../../../../mura/backport/backport.cfm";
		} else {
			backportdir='../../../../mura/backport/';
			include "#backportdir#backport.cfm";
		}
	</cfscript>
	<cfparam name="session.siteid" default="default">
	<cfparam name="url.resourcepath" default="User_Assets">
	<cfparam name="url.directory" default="">
	<cfparam name="url.displaymode" default="2">
	<cfset m=application.Mura.getBean('m').init(session.siteid)>
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<title>Mura File Browser</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex, nofollow" />
	<cfoutput>
  <script src="#m.siteConfig().getAdminPath(complete=1)#/assets/js/mura.min.js"></script>
  <script src="#m.siteConfig().getAdminPath(complete=1)#/assets/js/filebrowser/filebrowser.js"></script>
	<link href="#m.siteConfig().getAdminPath(complete=1)#/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
	<link href="#m.siteConfig().getAdminPath(complete=1)#/assets/js/filebrowser/assets/css/filebrowser.css" link rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="#m.siteConfig().getAdminPath(complete=1)#/assets/css/fonts.min.css">
  <script>
	Mura.init({
		context:'#esapiEncode("javascript",m.globalConfig('context'))#',
		themepath:'#esapiEncode("javascript",m.siteConfig().getThemeAssetPath(complete=1))#',
		siteid:'#esapiEncode("javascript",m.siteConfig().getSiteID())#',
		assetpath:'#esapiEncode("javascript",m.siteConfig().getAssetPath(complete=1))#',
		sitespath:'#esapiEncode("javascript",m.siteConfig().getSitesPath(complete=1))#',
		corepath:'#esapiEncode("javascript",m.siteConfig().getCorePath(complete=1))#',
		fileassetpath:'#esapiEncode("javascript",m.siteConfig().getFileAssetPath(complete=1))#',
		adminpath:'#esapiEncode("javascript",m.siteConfig().getAdminPath(complete=1))#',
		themepath:'#esapiEncode("javascript",m.siteConfig().getThemeAssetPath(complete=1))#',
		pluginspath:'#esapiEncode("javascript",m.siteConfig().getPluginsPath(complete=1))#',
		rootpath:'#esapiEncode("javascript",m.siteConfig().getRootPath(complete=1))#',
		indexfileinapi: #m.globalConfig('indexfileinapi')#
	});
  </script>
	</cfoutput>
</head>
<body class="mura-admin MuraFileBrowserWindow">
	<div class="mura">
  	<div id="MasaBrowserContainer"></div>
	</div>
</body>
<cfoutput>
<script>
	Mura(function(m) {
		MuraFileBrowser.config.height=600;
		MuraFileBrowser.config.selectMode=1;
		MuraFileBrowser.config.resourcepath='#esapiEncode("javascript",url.resourcepath)#';
		MuraFileBrowser.config.directory='#esapiEncode("javascript",url.directory)#';
		MuraFileBrowser.config.displaymode='#esapiEncode("javascript",url.displaymode)#';
		MuraFileBrowser.render();
	});
</script>
</cfoutput>
</head>

</html>
