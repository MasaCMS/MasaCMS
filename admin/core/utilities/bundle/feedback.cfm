<cfif not listFind(session.mura.memberships,'S2')>
Access Restricted.
<cfabort>
</cfif>
<cfsetting requestTimeout = "3000">
<cfparam name="URL.siteID" default="">
<cfflush interval="5">
<html>
<head>
	<title>Bundle Feedback</title>
	<style>
		.up {
			font-weight: bold;
			font-size: 12px;
			font-family: "Lucida Grande",Arial,Helvetica,sans-serif;
			margin-bottom: 10px;
		}
	</style>
</head>
<body>

<div id="feedbackLoop" class="up">Starting the bundle push</div>
<div id="feedbackIndicator"><img src="/admin/images/progress_bar.gif"></div>

<script language="javascript">
	document.getElementById('feedbackLoop').innerHTML="Creating bundle";
</script>

<cfset hasError = false>
<cfset counter = 1>
<cfset siteID = URL.siteID>
<cfset rsPlugins = application.serviceFactory.getBean("pluginManager").getSitePlugins(siteID)>
<cfset bundleFileName = application.serviceFactory.getBean("Bundle").Bundle(
		siteID=siteID,
		moduleID=ValueList(rsPlugins.moduleID),
		BundleName='deployBundle', 
		includeVersionHistory=false,
		includeTrash=false,
		includeMetaData=true,
		includeMailingListMembers=false,
		includeUsers=false,
		includeFormData=false,
		saveFile=true) />

<cfloop list="#application.configBean.getServerList()#" index="i" delimiters="^">
	<cfoutput>
		<script language="javascript">
			document.getElementById('feedbackLoop').innerHTML="Deploying bundle - #counter# of #listLen(application.configBean.getServerList(),'^')#";
		</script>
	</cfoutput>
	<cfset serverArgs = deserializeJSON(i)>
	<cfset result = application.settingsManager.pushBundle(siteID, bundleFileName, serverArgs)>
	<cfoutput>
		<cfif trim(result) contains "Deployment Successful">
			<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				update tsettings set lastDeployment = #createODBCDateTime(now())#
				where siteID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#siteID#">
			</cfquery>
		<cfelse>
			<cfset hasError = true>
			<script language="javascript">
				document.getElementById('feedbackLoop').innerHTML="Deployment #counter# of #listLen(application.configBean.getServerList(),'^')# failed - aborting";
			</script>
			<cfif isWddx(result)>
				<cfwddx action="wddx2cfml" input="#result#" output="errorMessage"> 
				<cfsavecontent variable="emailBody">
					<cfdump var="#errorMessage#">
				</cfsavecontent>
			<cfelse>
				<cfset emailBody = result>
			</cfif>
			<cfset mailer = application.configBean.getBean('mailer') />
			<cfset mailer.sendHTML(emailBody,
				application.configBean.getBundleDeployErrorEmail(),
				'Mura CMS',
				'Bundle Error',
				URL.siteID,
				application.configBean.getBundleDeployErrorEmail()) />
			<cfbreak>
		</cfif>
	</cfoutput>
	<cfset counter = counter + 1>
</cfloop>
<script language="javascript">
	<cfif not hasError>
		document.getElementById('feedbackLoop').innerHTML="Deployment complete";
	</cfif>
	document.getElementById('feedbackIndicator').style.display="none";
</script>
<cfset fileDelete(bundleFileName)>

</body>
</html>
