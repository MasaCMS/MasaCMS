<cfoutput>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#">Back to Site Settings</a></li>
</ul>
<h2>Bundle Created</h2>
<p>The bundle that you have requested has been created and is now available on your server at #rc.bundleFilePath#.</p>
	<p class="notice"><strong>Important:</strong> Leaving large bundle files on server can lead to excessive disk space usage.</p>
<cfif findNoCase(application.configBean.getWebRoot(),rc.bundleFilePath)>
	<cfset downloadURL=application.configBean.getContext() & right(rc.bundleFilePath,len(rc.bundleFilePath)-len(application.configBean.getWebRoot()))>
	<p><a href="#downloadURL#"class="submit"><span>Download Bundle</span></a></p>
</cfif>
</cfoutput>