<cfset objectParams.objectid=rc.objectid>
<cfset objectParams.objectname=application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')>



<cfset content=rc.$.getBean("content").loadBy(contentID=rc.objectid)>
<cfset displayRSS=isDefined("objectParams.displayRSS") and yesNoFormat(objectParams.displayRSS)>	