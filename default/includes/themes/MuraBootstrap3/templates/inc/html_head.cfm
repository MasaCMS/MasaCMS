<cfoutput>
<!DOCTYPE html>
<html lang="en"<cfif $.hasFETools()> class="mura-edit-mode"</cfif>>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#esapiEncode('html_attr', $.content('metaDesc'))#">
	<meta name="keywords" content="#esapiEncode('html_attr', $.content('metaKeywords'))#">
	<cfif len($.content('credits'))><meta name="author" content="#esapiEncode('html_attr', $.content('credits'))#"></cfif>
	<meta name="generator" content="Mura CMS #$.globalConfig('version')#">

	<title>#esapiEncode('html', $.content('HTMLTitle'))# - #esapiEncode('html', $.siteConfig('site'))#</title>
	<!--- Mura CMS Base Styles--->
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.7.0.min.css?v=#$.siteConfig('version')#">
	<!--- Optional: Mura CMS Skin Styles. Duplicate to your theme to customize, changing 'assetPath' to 'themeAssetPath' below. Don't forget to move, remove or replace sprite.png. --->
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.7.0.skin.css?v=#$.siteConfig('version')#">

	<!--- Bootstrap core CSS --->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/bootstrap/css/bootstrap.min.css">

	<!--- Font Awesome --->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/font-awesome/css/font-awesome.css">

	<!---
				THEME CSS
				This has been compiled using a pre-processor such as CodeKit or Prepros
	--->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/theme/theme.min.css">

	<!--[if IE]>
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/ie/ie.min.css">
	<![endif]-->

	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="#$.siteConfig('themeAssetPath')#/js/html5shiv/html5shiv.js"></script>
	<script src="#$.siteConfig('themeAssetPath')#/js/respond/respond.min.js"></script>
	<![endif]-->

	<!--- jQuery --->
	<script src="#$.siteConfig('assetPath')#/js/external/jquery.min.js"></script>

	<!--- FAV AND TOUCH ICONS --->
	<link rel="shortcut icon" href="#$.siteConfig('assetPath')#/images/favicon.ico">
	<!--- <link rel="apple-touch-icon-precomposed" sizes="144x144" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-144-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-114-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-72-precomposed.png">
	<link rel="apple-touch-icon-precomposed" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-57-precomposed.png"> --->

	<!--- MURA FEEDS --->
	<cfset rs=$.getBean('feedManager').getFeeds($.event('siteID'),'Local',true,true) />
	<cfset apiEndpoint=$.siteConfig().getApi('feed','v1').getEndpoint() />
	<cfloop query="rs"><link rel="alternate" type="application/rss+xml" title="#esapiEncode('html_attr', $.siteConfig('site'))# - #esapiEncode('html_attr', rs.name)#" href="#XMLFormat('#apiEndpoint#/?feedID=#rs.feedID#')#"></cfloop>
</head>
</cfoutput>
