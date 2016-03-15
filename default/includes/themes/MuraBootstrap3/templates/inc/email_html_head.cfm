<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
   <html lang="en">
	<head>
	  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	  <meta name="viewport" content="initial-scale=1.0">    <!-- So that mobile webkit will display zoomed in -->
	  <meta name="format-detection" content="telephone=no"> <!-- disable auto telephone linking in iOS -->
	  <title>#$.content('eHeadline')#</title>
	  
	  <link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/email/style.css">
	  <link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/email/responsive.css" data-premailer="ignore">
	  
	  <!--- jQuery --->
	  <script src="#$.siteConfig('assetPath')#/jquery/jquery.js"></script>
	  
	</head>
</cfoutput>
<cfscript>
if($.event('showInline')==1){
	renderer=$.getContentRenderer();
	renderer.renderHTMLQueues=false;
	renderer.showAdminToolBar=false;
	renderer.showEditableObjects=false;
	renderer.showInlineEditor=false;
}
</cfscript>
