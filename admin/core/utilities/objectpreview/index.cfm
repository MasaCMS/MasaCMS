<html>
<head>
	<cfsilent>
		<cfparam name="url.siteid" default="#session.siteid#">
		<cfparam name="url.objectid" default="">
		<cfparam name="url.object" default="">
		<cfparam name="url.params" default="{}">
		<cfset url.params=deserializeJSON(urlDecode(url.params))>
		<cfset url.params.async=true>

		<cfset $=application.serviceFactory.getBean('$').init(url.siteid)>
		<cfset $.event('contentBean',$.getBean('content').loadBy(contenthistid=url.contenthistid))>

		<cfif not $.content().exists()>
			<cfset $.event('contentBean',$.getBean('content').loadBy(contentid=url.parentid))>
		</cfif>

		<cfset secure=$.getBean('utility').isHTTPS()>
		<cfscript>
			if(server.coldfusion.productname != 'ColdFusion Server'){
				backportdir='';
				include "/mura/backport/backport.cfm";
			} else {
				backportdir='#repeatString('../',3)#requirements/mura/backport/';
				include "/mura/backport/backport.cfm";
			}
		</cfscript>
	</cfsilent>
	
	<!--- contentsCss --->
	<cfoutput>
	<cfif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css.cfm') )>
		<link rel="stylesheet" href="#$.siteConfig().getThemeAssetPath(secure=secure,complete=1,domain=cgi.server_name)#/css/editor/editor.css.cfm">
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor/editor.css') )>
		<link rel="stylesheet" href="#$.siteConfig().getThemeAssetPath(secure=secure,complete=1,domain=cgi.server_name)#/css/editor/editor.css">
	<cfelseif fileExists(expandPath($.siteConfig("themeIncludePath") & '/css/editor.css.cfm') )>
		<link rel="stylesheet" href="#$.siteConfig().getThemeAssetPath(secure=secure,complete=1,domain=cgi.server_name)#/css/editor.css.cfm">
	<cfelse>		
		<link rel="stylesheet" href="#$.siteConfig().getThemeAssetPath(secure=secure,complete=1,domain=cgi.server_name)#/css/editor.css">
	</cfif>
	<script src="#$.siteConfig().getAssetPath(secure=secure,complete=1,domain=cgi.server_name)#/js/dist/mura.js"></script>
	<script>
		mura.init({
				loginURL:"#esapiEncode('javascript',$.siteConfig('LoginURL'))#",
				siteid:"#esapiEncode('javascript',$.event('siteID'))#",
				contentid:"#esapiEncode('javascript',$.content('contentid'))#",
				contenthistid:"#esapiEncode('javascript',$.content('contenthistid'))#",
				siteID:"#esapiEncode('javascript',$.event('siteID'))#",
				context:"#esapiEncode('javascript',$.globalConfig('context'))#",
				nocache:"#esapiEncode('javascript',$.event('nocache'))#",
				assetpath:"#esapiEncode('javascript',$.siteConfig().getResourcePath(complete=1) & $.siteConfig().getAssetPath())#",
				requirementspath:"#esapiEncode('javascript',$.siteConfig().getRequirementsPath(complete=1))#",
				adminpath:"#esapiEncode('javascript',$.globalConfig('adminpath'))#",
				themepath:"#esapiEncode('javascript',$.siteConfig().getResourcePath(complete=1) & $.siteConfig().getThemeAssetPath())#",
				rb:"#esapiEncode('javascript',lcase(listFirst($.siteConfig('JavaLocale'),"_")))#",
				reCAPTCHALanguage:"#esapiEncode('javascript',$.siteConfig('reCAPTCHALanguage'))#",
				preloaderMarkup:"#esapiEncode('javascript',$.getContentRenderer().preloaderMarkup)#",
				mobileformat:"#esapiEncode('javascript',esapiEncode('javascript',$.event('muraMobileRequest')))#",
				adminpreview:"#esapiEncode('javascript',lcase(structKeyExists(url,'muraadminpreview')))#",
				windowdocumentdomain:"#esapiEncode('javascript',$.globalConfig('WindowDocumentDomain'))#",
				perm:"none",
				layoutmanager:false
			});
	</script>
	</cfoutput>
</head>
<body>
<cfoutput>
#$.getBean('contentRendererUtility').renderObjectInManager(object=url.object,
				objectid=url.objectid,
				content='',
				objectParams=url.params,
				showEditable=false,
				isConfigurator=false,
				objectname='')#
</cfoutput>
</body>
</html>
