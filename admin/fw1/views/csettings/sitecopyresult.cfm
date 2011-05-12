<cfsavecontent variable="rc.layout">
<cfoutput>
<h2>Site Copy Tool</h2>
<p>The contents of the site named '<strong>#application.settingsManager.getSite(rc.fromsiteid).getSite()#</strong>' have been copied into '<strong>#application.settingsManager.getSite(rc.tositeid).getSite()#</strong>'.
</cfoutput>
</cfsavecontent>