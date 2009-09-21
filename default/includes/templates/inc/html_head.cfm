<cfcontent reset="yes"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!--- SUGGESTED LANGUAGE ATTRIBUTES - xml:lang="en" lang="en" --->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="#request.contentBean.getmetadesc()#" />
	<meta name="keywords" content="#request.contentBean.getmetakeywords()#" />
	<cfif request.contentBean.getCredits() neq ""><meta name="author" content="#request.contentbean.getCredits()#" /></cfif>
	<meta name="generator" content="Mura CMS #application.configBean.getVersion()#" />
	<!--- <meta name="robots" content="noindex, nofollow" /> ---><!--- use this to discourage search engines from indexing your site. (can be useful if developing on a live server for example) Delete if not needed. --->
	<title>#request.contentBean.getHTMLTitle()# - #renderer.getSite().getSite()#</title>

	<link rel="icon" href="#application.configBean.getContext()#/#request.siteid#/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#application.configBean.getContext()#/#request.siteid#/images/favicon.ico" type="image/x-icon" />

	<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/default.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/typography.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/site.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#application.configBean.getContext()#/#request.siteid#/css/print.css" type="text/css" media="print" />
	<cfinclude template="ie_conditional_includes.cfm" />
	
	<!-- JQuery, Mura global.js, and other necessary js gets included by Mura on page render to avoid loading unnecesary libraries -->
	
	<cfset rs=application.feedManager.getFeeds(request.siteID,'Local',true,true) />
	<cfloop query="rs">
	<link rel="alternate" type="application/rss+xml" title="#renderer.getSite().getSite()# - #rs.name#" href="#XMLFormat('http://#listFirst(cgi.http_host,":")##application.configBean.getContext()#/tasks/feed/?feedID=#rs.feedID#')#" />
	</cfloop>
</head>
</cfoutput>