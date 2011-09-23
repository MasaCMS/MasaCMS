<cfoutput>
<!DOCTYPE html> 
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="#HTMLEditFormat($.getMetaDesc())#" />
	<meta name="keywords" content="#HTMLEditFormat($.getMetaKeywords())#" />
	<cfif request.contentBean.getCredits() neq ""><meta name="author" content="#HTMLEditFormat($.content('credits'))#" /></cfif>
	<meta name="generator" content="Mura CMS #$.globalConfig('version')#" />
	
	<title>#HTMLEditFormat($.content('HTMLTitle'))# - #HTMLEditFormat($.siteConfig('site'))#</title>

	<link rel="icon" href="#$.siteConfig('assetPath')#/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#$.siteConfig('assetPath')#/images/favicon.ico" type="image/x-icon" />	
	
	<link rel="stylesheet" href="#$.siteConfig('assetPath')#/mobile/jquery.mobile.min.css" />
	<script src="#$.siteConfig('assetPath')#/js/jquery/jquery.js"></script>
	<script src="#$.siteConfig('assetPath')#/mobile/jquery.mobile.min.js"></script>
	
	<cfset rs=$.getBean('feedManager').getFeeds($.event('siteID'),'Local',true,true) />

</head>

<body id="#$.getTopID()#" class="mobile depth#arrayLen($.event('crumbdata'))#">
<div data-role="page">

	<div data-role="header" class="ui-header">
		<h1>#HTMLEditFormat($.content('title'))#</h1>
		<!---
<form action="" id="searchForm" class="ui-btn-right">
			<fieldset data-role="fieldcontain">
				<input type="search" name="Keywords" id="search" class="text" value="Search" onfocus="this.value=(this.value=='Search') ? '' : this.value;" onblur="this.value=(this.value=='') ? 'Search' : this.value;" />
				<input type="hidden" name="display" value="search" />
				<input type="hidden" name="newSearch" value="true" />
				<input type="hidden" name="noCache" value="1" />
				<!--- <input type="submit" class="submit" value="Go" /> --->
			</fieldset>
		</form>
--->
	</div><!-- /header -->

	<div data-role="content">
		<!--- #$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")# --->
		#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=0)#
		<cf_CacheOMatic key="dspPrimaryNav#request.contentBean.getcontentID()#">
			#$.dspPrimaryNav(
				viewDepth="0",
				id="navPrimary",
				displayHome="Always",
				class="ui-listview ui-listview-inset ui-corner-all ui-shadow",
				closePortals="true",
				showCurrentChildrenOnly="false"
				)#
		</cf_cacheomatic>
		#$.dspObjects(2)#		
	</div><!-- /content -->

	<div data-role="footer">
		<p>Footer</p>
	</div><!-- /footer -->
</div><!-- /page -->
			
</html>
</cfoutput>