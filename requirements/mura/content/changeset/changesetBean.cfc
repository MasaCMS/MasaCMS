<cfcomponent extends="mura.bean.bean" entityName="changeset" table="tchangesets" output="false">

<cfproperty name="changesetID" fieldtype="id" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="created" type="date" default="" />
<cfproperty name="description" type="string" default="" />
<cfproperty name="publishDate" type="date" default="" />
<cfproperty name="published" type="numeric" default="0" required="true" />
<cfproperty name="remoteID" type="string" default="" />
<cfproperty name="remoteSourceURL" type="string" default="" />
<cfproperty name="remotePubDate" type="date" default="" />
<cfproperty name="lastUpdate" type="date" default="" />
<cfproperty name="lastUpdateBy" type="string" default="" />
<cfproperty name="closeDate" type="date" default="" />
<cfproperty name="categoryID" type="string" default="" />
<cfproperty name="tags" type="string" default="" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cfset variables.primaryKey = 'changesetID'>
<cfset variables.entityName = 'changeset'>

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
	<cfset variables.instance.closeDate=""/>
	<cfset variables.instance.isNew=1 />
	<cfset variables.instance.categoryID=""/>
	<cfset variables.instance.tags=""/>
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
		<cfargument name="property" required="true">
	    <cfargument name="propertyValue">
	    
	    <cfif not isDefined('arguments.data')>
		    <cfif isSimpleValue(arguments.property)>
		      <cfreturn setValue(argumentCollection=arguments)>
		    </cfif>

		    <cfset arguments.data=arguments.property>
	    </cfif>
	    
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

<cffunction name="setCloseDate" access="public" output="false">
	<cfargument name="closeDate" type="String" />
	<cfset variables.instance.closeDate = parseDateArg(arguments.closeDate) />
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

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "changesetID">
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.instance.categoryID = trim(arguments.categoryID) />
	<cfelse>
		<cfloop list="#arguments.categoryID#" index="i">
		<cfif not listFindNoCase(variables.instance.categoryID,trim(i))>
	    	<cfset variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="hasPendingApprovals" output="false">
		<cfreturn variables.changesetManager.hasPendingApprovals(getValue('changesetID'))>
</cffunction>

<cffunction name="getAssignmentsIterator" output="false">
		<cfreturn variables.changesetManager.getAssignmentsIterator(getValue('changesetID'))>
</cffunction>

<cffunction name="getAssignmentsQuery" output="false">
		<cfreturn variables.changesetManager.getAssignmentsQuery(getValue('changesetID'))>
</cffunction>

<cffunction name="rollback" output="false">
	<cfif variables.instance.published>
		<cfset var it=getBean('changesetRollBack')
			.getFeed()
			.setNextN(0)
			.setSiteID(getValue('siteID'))
			.addParam(column='changesetID',criteria=getValue('changesetID'))
			.getIterator()>

		<cfif it.hasNext()>
			<cfloop condition="it.hasNext()">
				<cfset it.next().rollback()>
			</cfloop>
		</cfif>	
	</cfif>

	<cfset variables.instance.published=0>
	<cfset variables.instance.publishDate="">
	<cfset save()>
	<!---<cfdump var="#variables.instance.published#" abort="true">--->

	<cfreturn this>
</cffunction>

<cffunction name="getFeed" access="public" returntype="any" output="false">
	<cfreturn getBean("beanFeed").setSiteID(getValue('siteid')).setEntityName('changeset').setTable('tchangesets').setOrderBy('name asc')>
</cffunction>


</cfcomponent>