<cfoutput>
<!DOCTYPE html>
<html lang="en"<cfif $.hasFETools()> class="mura-edit-mode"</cfif>>
<head>
	<!--- META
	================================================== --->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>#HTMLEditFormat($.content('HTMLTitle'))# - #HTMLEditFormat($.siteConfig('site'))#</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#HTMLEditFormat($.content('MetaDesc'))#">
	<meta name="keywords" content="#HTMLEditFormat($.content('getMetaKeywords'))#">
	<cfif len($.content('credits'))><meta name="author" content="#HTMLEditFormat($.content('credits'))#" /></cfif>
	<meta name="generator" content="Mura CMS #$.globalConfig('version')#" />

	<!--- CSS
	================================================== --->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/font-awesome/css/font-awesome.css">
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.6.0.min.css">

	<!--- CfStatic CSS --->
	<cf_CacheOMatic key="globalheadercss">
		#$.static()
			.include('/css/theme/')
			.renderIncludes('css')#
	</cf_CacheOMatic>


	<!--- jQuery
	================================================== --->
	<script src="#$.siteConfig('assetPath')#/jquery/jquery.js"></script>

	<!--- IE SHIM - for IE6-8 support of HTML5 elements
	================================================== --->
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!--- FAV AND TOUCH ICONS
	================================================== --->
	<link rel="shortcut icon" href="#$.siteConfig('themeAssetPath')#/images/ico/favicon.ico">
	<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-144-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-114-precomposed.png">
	<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-72-precomposed.png">
	<link rel="apple-touch-icon-precomposed" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-57-precomposed.png">

	<!--- MURA FEEDS
	================================================== --->
	<cfset rs=$.getBean('feedManager').getFeeds($.event('siteID'),'Local',true,true) />
	<cfloop query="rs"><link rel="alternate" type="application/rss+xml" title="#HTMLEditFormat($.siteConfig('site'))# - #HTMLEditFormat(rs.name)#" href="#XMLFormat('http://#listFirst(cgi.http_host,":")##$.globalConfig('context')#/tasks/feed/?feedID=#rs.feedID#')#"></cfloop>
</head>
</cfoutput>