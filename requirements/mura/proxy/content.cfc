<cfcomponent output="false" extends="service">

<cffunction name="call">
	<cfargument name="Event">
	
	<cfif application.permUtility.getModulePerm('00000000000000000000000000000000000',event.getValue('siteID'))>	
		<cfset proceed( event ) >
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
	
</cffunction>

<cffunction name="getPerm">
	<cfargument name="Event">
	
	<cfset var result=structNew()>
	<cfset var content=event.getValue("content")>
	
	<cfif content.getIsNew()>
		<cfset result.crumbdata=application.contentManager.getCrumbList(content.getParentID(),event.getValue('siteID'))/>
	 	<cfset result.level=application.permUtility.getNodePerm(result.crumbdata) />
	 <cfelse>
		<cfset result.crumbdata=application.contentManager.getCrumbList(content.getContentID(),event.getValue('siteID'))/>
		<cfset result.level=application.permUtility.getNodePerm(result.crumbdata) />
	</cfif>
	
	<cfset result.allowAction=listFindNoCase("Author,Editor",result.level)>
	<cfset event.setValue("perm",result)>
	
	<cfreturn result>
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="event">
	
	<cfset var content="">
	
	<cfif not isBoolean(event.getValue("use404"))>
		<cfset event.setValue("use404",false)>
	</cfif>
	
	<cfif len(event.getValue("contenthistid"))>
		<cfset content=application.contentManager.getcontentVersion(event.getValue("contenthistid"),event.getValue("siteid"),event.getValue("use404"))>
	<cfelseif event.valueExists("filename")>
		<cfset content=application.contentManager.getActiveContentByFilename(event.getValue("filename"),event.getValue("siteid"),event.getValue("use404"))>
	<cfelseif len(event.getValue("remoteID"))>
		<cfset content=application.contentManager.getActiveByRemoteID(event.getValue("remoteid"),event.getValue("siteid"))>
	<cfelse>
		<cfset content=application.contentManager.getActiveContent(event.getValue("contentid"),event.getValue("siteid"),event.getValue("use404"))>
	</cfif>
	
	<cfset event.setValue('content',content)>
	
	<cfreturn content>
	
</cffunction>

<cffunction name="read" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq "deny">
		<cfset content=content.getAllValues()>
	
		<cfset event.setValue("__response__", format(content.getAllValues(),event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
	
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		
		<cfif perm.level eq "Author">
			<cfset event.setValue("approved",0)>
		</cfif>
		
		<cfset content.set(event.getAllValues())>
		<cfset content.save()>
		<cfset event.setValue("__response__", format(content.getAllValues(),event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("false",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.delete()>
		<cfset event.setValue("__response__", format("true",event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("false",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

<cffunction name="deleteVersion" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.deleteVersion()>
		<cfset event.setValue("__response__", format("true",event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("false",event.getValue("responseFormat")))>
	</cfif>

</cffunction>

<cffunction name="deleteVersionHistory" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.deleteVersionHistory()>
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

<cffunction name="getKids" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfif not isBoolean(event.getValue("liveOnly"))>
			<cfset event.setValue("__response__", format(content.getKidsQuery(),event.getValue("responseFormat")))>
		<cfelse>
			<cfset event.setValue("__response__", format(content.getKidsIterator(liveOnly=event.getValue("liveOnly")).getQuery(),event.getValue("responseFormat")))>
		</cfif>
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

<cffunction name="getCategories" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfset event.setValue("__response__", format(getBean(event).getCategoriesQuery(),event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

<cffunction name="getRelatedContent" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfset event.setValue("__response__", format(content.getRelateContentQuery(),event.getValue("responseFormat")))>
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
</cffunction>

</cfcomponent>