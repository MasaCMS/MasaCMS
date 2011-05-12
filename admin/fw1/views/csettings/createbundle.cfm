<cfoutput>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#">Back to Site Settings</a></li>
</ul>
<h2>Bundle Created</h2>
<p>The bundle that you have requested has been created and is now available on your server at #rc.bundleFilePath#.</p>
</cfoutput>