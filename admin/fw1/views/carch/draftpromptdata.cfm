<cfcontent type="application/json">
<cfoutput>#createObject("component","mura.json").encode(application.contentManager.getDraftPromptData(rc.contentid,rc.siteid))#</cfoutput>
<cfabort>