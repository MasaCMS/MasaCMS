<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.changesetManager="">
<cfset variables.instance.changesetID="">
<cfset variables.instance.siteID="">
<cfset variables.instance.name="">
<cfset variables.instance.created=now()>
<cfset variables.instance.description="">
<cfset variables.instance.publishDate="">
<cfset variables.instance.published=0>
<cfset variables.instance.remoteID = "" />
<cfset variables.instance.remoteSourceURL = "" />
<cfset variables.instance.remotePubDate = "">
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.isNew=1 />
<cfset variables.instance.errors=structNew()>

<cfif isDefined("session.mura") and session.mura.isLoggedIn>
	<cfset variables.instance.LastUpdateBy = left(session.mura.fname & " " & session.mura.lname,50) />
	<cfset variables.instance.LastUpdateByID = session.mura.userID />
<cfelse>
	<cfset variables.instance.LastUpdateBy = "" />
	<cfset variables.instance.LastUpdateByID = "" />
</cfif>

<cffunction name="init" output="false">
<cfargument name="changesetManager">
<cfset variables.changesetManager=arguments.changesetManager>
<cfreturn this>
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.data)>
		
			<cfset setChangesetID(arguments.data.changesetID) />
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setName(arguments.data.name) />
			<cfset setDescription(arguments.data.description) />
			<cfset setCreated(arguments.data.created) />
			<cfset setpublishDate(arguments.data.publishDate) />
			<cfset setpublished(arguments.data.published) />
			<cfset setlastUpdate(arguments.data.lastUpdate) />
			<cfset setLastUpdateByID(arguments.data.lastUpdateByID) />
			<cfset setRemoteID(arguments.data.remoteID) />
			<cfset setRemotePubDate(arguments.data.remotePubDate) />
			<cfset setRemoteSourceURL(arguments.data.remoteSourceURL) />
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop]) />
			</cfloop>
			
			<cfif isDate(getpublishDate())>
				
				<cfif isdefined("arguments.data.publishhour")
				and isdefined("arguments.data.publishMinute")
				and isdefined("arguments.data.publishDayPart")>
				
					<cfif arguments.data.publishdaypart eq "PM">
						<cfset publishhour = arguments.data.publishhour + 12>
						
						<cfif publishhour eq 24>
							<cfset publishhour = 12>
						</cfif>
					<cfelse>
						<cfset publishhour = arguments.data.publishhour>
						
						<cfif publishhour eq 12>
							<cfset publishhour = 0>
						</cfif>
					</cfif>
					
					<cfset setpublishDate(createDateTime(year(getpublishDate()), month(getpublishDate()), day(getpublishDate()), publishhour, arguments.data.publishMinute, "0"))>
			
				</cfif>
			</cfif>
			
		</cfif>
		
		<cfset validate() />
		<cfreturn this />
  </cffunction>

<cffunction name="getChangesetID" output="false">
	<cfif not len(variables.instance.changesetID)>
		<cfset variables.instance.changesetID=createUUID()>
	</cfif>
	<cfreturn variables.instance.changesetID>
</cffunction>

<cffunction name="setChangesetID" output="false">
<cfargument name="changesetID">
<cfset variables.instance.changesetID=arguments.changesetID>
<cfreturn this>
</cffunction>

<cffunction name="getSiteID" output="false">
<cfreturn variables.instance.siteID>
</cffunction>

<cffunction name="setSiteID" output="false">
<cfargument name="siteID">
<cfset variables.instance.siteID=arguments.siteID>
<cfreturn this>
</cffunction>

<cffunction name="getName" output="false">
<cfreturn variables.instance.name>
</cffunction>

<cffunction name="setName" output="false">
<cfargument name="name">
<cfset variables.instance.name=arguments.name>
<cfreturn this>
</cffunction>

<cffunction name="getDescription" output="false">
<cfreturn variables.instance.description>
</cffunction>

<cffunction name="setDescription" output="false">
<cfargument name="Description">
<cfset variables.instance.description=arguments.description>
<cfreturn this>
</cffunction>

<cffunction name="getCreated" output="false">
<cfreturn variables.instance.created>
</cffunction>

<cffunction name="setCreated" output="false" access="public">
<cfargument name="created" type="string" required="true">
<cfif lsisDate(arguments.created)>
	<cftry>
	<cfset variables.instance.created = lsparseDateTime(arguments.created) />
	<cfcatch>
		<cfset variables.instance.created = arguments.created />
	</cfcatch>
	</cftry>
	<cfelse>
	<cfset variables.instance.created = ""/>
</cfif>
<cfreturn this>
</cffunction>

<cffunction name="getPublishDate" output="false">
<cfreturn variables.instance.publishDate>
</cffunction>

<cffunction name="setPublishDate" output="false" access="public">
<cfargument name="publishDate" type="string" required="true">
<cfif lsisDate(arguments.publishDate)>
	<cftry>
	<cfset variables.instance.publishDate = lsparseDateTime(arguments.publishDate) />
	<cfcatch>
		<cfset variables.instance.publishDate = arguments.publishDate />
	</cfcatch>
	</cftry>
	<cfelse>
	<cfset variables.instance.publishDate = ""/>
</cfif>
<cfreturn this>
</cffunction>

<cffunction name="getPublished" output="false">
<cfreturn variables.instance.published>
</cffunction>

<cffunction name="setPublished" output="false">
<cfargument name="published">
<cfif isNumeric(arguments.published)>
<cfset variables.instance.published=arguments.published>
</cfif>
<cfreturn this>
</cffunction>

<cffunction name="getIsNew" returnType="numeric" output="false" access="public">
   <cfreturn variables.instance.IsNew />
</cffunction>

<cffunction name="setIsNew" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
	<cfreturn this>
</cffunction>

<cffunction name="getLastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getLastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setLastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdateByID" output="false" access="public">
<cfargument name="lastUpdateByID" type="string" required="true">
	<cfset variables.instance.lastUpdateByID = trim(arguments.lastUpdateByID) />
	<cfreturn this>
</cffunction>
	
<cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
	<cfreturn variables.instance.lastUpdateByID />
</cffunction>

<cffunction name="setRemoteID" output="false" access="public">
<cfargument name="RemoteID" type="string" required="true">
	<cfset variables.instance.RemoteID = trim(arguments.RemoteID) />
	<cfreturn this>
</cffunction>
	
<cffunction name="getRemoteID" returnType="string" output="false" access="public">
	<cfreturn variables.instance.RemoteID />
</cffunction>
	  
<cffunction name="setRemoteSourceURL" output="false" access="public">
<cfargument name="remoteSourceURL" type="string" required="true">
	<cfset variables.instance.remoteSourceURL = trim(arguments.remoteSourceURL) />
	<cfreturn this>
</cffunction>
	
<cffunction name="getRemoteSourceURL" returnType="string" output="false" access="public">
	<cfreturn variables.instance.remoteSourceURL />
</cffunction>
	 
<cffunction name="setRemotePubDate" output="false" access="public">
<cfargument name="RemotePubDate" type="string" required="true">
	<cfif lsisDate(arguments.RemotePubDate)>
	<cftry>
		<cfset variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate) />
		<cfcatch>
			<cfset variables.instance.RemotePubDate = arguments.RemotePubDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.RemotePubDate = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getRemotePubDate" returnType="string" output="false" access="public">
	<cfreturn variables.instance.RemotePubDate />
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfset var response="">
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=getSiteID()>
	</cfif>
	
	<cfset response=variables.changesetManager.read(argumentCollection=arguments)>

	<cfif isArray(response)>
		<cfset setAllValues(response[1].getAllValues())>
		<cfreturn response>
	<cfelse>
		<cfset setAllValues(response.getAllValues())>
		<cfreturn this>
	</cfif>
</cffunction>

<cffunction name="save" output="false" access="public">
	<cfset setAllValues(variables.changesetManager.save(this).getAllValues())>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.changesetManager.delete(getChangesetID()) />
</cffunction>

<cffunction name="getErrors" output="false">
<cfreturn variables.instance.errors>
</cffunction>

<cffunction name="setErrors" output="false" access="public">
<cfargument name="errors">
	<cfset variables.instance.errors = arguments.errors />
	<cfreturn this>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelse>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfreturn evaluate("get#property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
	<cfreturn variables.instance>
</cffunction>

<cffunction name="validate" output="false">

</cffunction>
</cfcomponent>