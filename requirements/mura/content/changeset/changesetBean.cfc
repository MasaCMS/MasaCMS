<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="changesetID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="created" type="date" default="" required="true" />
<cfproperty name="description" type="string" default="" required="true" />
<cfproperty name="publishDate" type="date" default="" required="true" />
<cfproperty name="published" type="numeric" default="0" required="true" />
<cfproperty name="remoteID" type="string" default="" required="true" />
<cfproperty name="remoteSourceURL" type="string" default="" required="true" />
<cfproperty name="remotePubDate" type="date" default="" required="true" />
<cfproperty name="lastUpdate" type="date" default="" required="true" />
<cfproperty name="lastUpdateBy" type="string" default="" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cffunction name="init" output="false">
	
	<cfset super.init(argumentCollection=arguments)>

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
	
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setChangesetManager" output="false">
	<cfargument name="changesetManager">
	<cfset variables.changesetManager=arguments.changesetManager>
	<cfreturn this>
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop="" />
		<cfset var publishhour="">
		
		<cfif isquery(arguments.data)>
			<cfloop list="#arguments.data.columnlist#" index="prop">
				<cfset setValue(prop,arguments.data[prop][1]) />
			</cfloop>
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop]) />
			</cfloop>
			
			<cfif isDate(variables.instance.publishDate)>
				
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
					
					<cfset setpublishDate(createDateTime(year(variables.instance.publishDate), month(variables.instance.publishDate), day(variables.instance.publishDate), publishhour, arguments.data.publishMinute, "0"))>
			
				</cfif>
			</cfif>
			
		</cfif>
		
		<cfreturn this />
  </cffunction>

<cffunction name="getChangesetID" output="false">
	<cfif not len(variables.instance.changesetID)>
		<cfset variables.instance.changesetID=createUUID()>
	</cfif>
	<cfreturn variables.instance.changesetID>
</cffunction>

<cffunction name="setCreated" output="false" access="public">
	<cfargument name="created" type="string" required="true">
	<cfset variables.instance.created = parseDateArg(arguments.created) />
	<cfreturn this>
</cffunction>

<cffunction name="setPublishDate" output="false" access="public">
	<cfargument name="publishDate" type="string" required="true">
	<cfset variables.instance.publishDate = parseDateArg(arguments.publishDate) />
	<cfreturn this>
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

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfset variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="setRemotePubDate" output="false" access="public">
	<cfargument name="RemotePubDate" type="string" required="true">
	<cfset variables.instance.RemotePubDate = parseDateArg(arguments.RemotePubDate) />
	<cfreturn this>
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	
	<cfset arguments.changesetBean=this>
	
	<cfreturn variables.changesetManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="save" output="false" access="public">
	<cfset setAllValues(variables.changesetManager.save(this).getAllValues())>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.changesetManager.delete(getChangesetID()) />
</cffunction>

</cfcomponent>