<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="#HTMLEditFormat($.getMetaDesc())#" />
	<meta name="keywords" content="#HTMLEditFormat($.getMetaKeywords())#" />
	<cfif request.contentBean.getCredits() neq ""><meta name="author" content="#HTMLEditFormat($.content('credits'))#" /></cfif>
	<meta name="generator" content="Mura CMS #$.globalConfig('version')#" />
	<!--- <meta name="robots" content="noindex, nofollow" /> ---><!--- use this to discourage search engines from indexing your site. (can be useful if developing on a live server for example) Delete if not needed. --->
	<title>#HTMLEditFormat($.content('HTMLTitle'))# - #HTMLEditFormat($.siteConfig('site'))#</title>

	<link rel="icon" href="#$.siteConfig('assetPath')#/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#$.siteConfig('assetPath')#/images/favicon.ico" type="image/x-icon" />
	
	<!--- Shared Styles --->	
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/reset.min.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.min.css" type="text/css" media="all" />

	<!--- Theme-Specific Styles --->
	<cfif listFirst(server.coldfusion.productversion) eq 8>
	<!--- ** Simple Method of CSS Inclusion ** --->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/core/typography.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/core/merced.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/print/print.css" type="text/css" media="print" />
	<cfinclude template="ie_conditional_includes.cfm" />
	<cfelse>
	<!--- ** Optimized Method of CSS Inclusion ** --->
	<cf_CacheOMatic key="globalheadercss">
	#$.static()
		.include("/css/core/")
		.include("/css/print/")
		.include("/css/ie/lte7/")
		.renderIncludes("css")#
	</cf_CacheOMatic>
	</cfif>	
	<cfset rs=$.getBean('feedManager').getFeeds($.event('siteID'),'Local',true,true) />
	<cfloop query="rs">
	<link rel="alternate" type="application/rss+xml" title="#HTMLEditFormat($.siteConfig('site'))# - #HTMLEditFormat(rs.name)#" href="#XMLFormat('http://#listFirst(cgi.http_host,":")##$.globalConfig('context')#/tasks/feed/?feedID=#rs.feedID#')#" />
	</cfloop>

</head>
</cfoutput>