<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="changesetid" type="string" default="" required="true" />
<cfproperty name="siteid" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="created" type="date" default="" />
<cfproperty name="description" type="string" default="" />
<cfproperty name="publishdate" type="date" default="" />
<cfproperty name="published" type="numeric" default="0" required="true" />
<cfproperty name="remoteid" type="string" default="" />
<cfproperty name="remotesourceurl" type="string" default="" />
<cfproperty name="remotePubdate" type="date" default="" />
<cfproperty name="lastupdate" type="date" default="" />
<cfproperty name="lastupdateby" type="string" default="" />
<cfproperty name="closedate" type="date" default="" />
<cfproperty name="categoryid" type="string" default="" />
<cfproperty name="tags" type="string" default="" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cfset variables.primaryKey = 'changesetid'>
<cfset variables.entityName = 'changeset'>

<cffunction name="init" output="false">
	
	<cfset super.init(argumentCollection=arguments)>

	<cfset variables.instance.changesetid="">
	<cfset variables.instance.siteid="">
	<cfset variables.instance.name="">
	<cfset variables.instance.created=now()>
	<cfset variables.instance.description="">
	<cfset variables.instance.publishdate="">
	<cfset variables.instance.published=0>
	<cfset variables.instance.remoteid = "" />
	<cfset variables.instance.remotesourceurl = "" />
	<cfset variables.instance.remotePubdate = "">
	<cfset variables.instance.lastupdate="#now()#"/>
	<cfset variables.instance.lastupdateby=""/>
	<cfset variables.instance.closedate=""/>
	<cfset variables.instance.isNew=1 />
	<cfset variables.instance.categoryid=""/>
	<cfset variables.instance.tags=""/>
	<cfset variables.instance.errors=structNew()>
	
	<cfif isDefined("session.mura") and session.mura.isLoggedIn>
		<cfset variables.instance.lastupdateby = left(session.mura.fname & " " & session.mura.lname,50) />
		<cfset variables.instance.lastupdatebyid = session.mura.userid />
	<cfelse>
		<cfset variables.instance.lastupdateby = "" />
		<cfset variables.instance.lastupdatebyid = "" />
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
			
		</cfif>
		
		<cfreturn this />
  </cffunction>

<cffunction name="getChangesetid" output="false">
	<cfif not len(variables.instance.changesetid)>
		<cfset variables.instance.changesetid=createUUid()>
	</cfif>
	<cfreturn variables.instance.changesetid>
</cffunction>

<cffunction name="setCreated" output="false" access="public">
	<cfargument name="created" type="string" required="true">
	<cfset variables.instance.created = parsedateArg(arguments.created) />
	<cfreturn this>
</cffunction>

<cffunction name="setPublishdate" output="false" access="public">
	<cfargument name="publishdate" type="string" required="true">
	<cfset variables.instance.publishdate = parsedateArg(arguments.publishdate) />
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

<cffunction name="setlastupdate" access="public" output="false">
	<cfargument name="lastupdate" type="String" />
	<cfset variables.instance.lastupdate = parsedateArg(arguments.lastupdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setClosedate" access="public" output="false">
	<cfargument name="closedate" type="String" />
	<cfset variables.instance.closedate = parsedateArg(arguments.closedate) />
	<cfreturn this>
</cffunction>

<cffunction name="setlastupdateby" access="public" output="false">
	<cfargument name="lastupdateby" type="String" />
	<cfset variables.instance.lastupdateby = left(trim(arguments.lastupdateby),50) />
	<cfreturn this>
</cffunction>

<cffunction name="setRemotePubdate" output="false" access="public">
	<cfargument name="RemotePubdate" type="string" required="true">
	<cfset variables.instance.RemotePubdate = parsedateArg(arguments.RemotePubdate) />
	<cfreturn this>
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteid")>
		<cfset arguments.siteid=variables.instance.siteid>
	</cfif>
	
	<cfset arguments.changesetBean=this>
	
	<cfreturn variables.changesetManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="save" output="false" access="public">
	<cfset setAllValues(variables.changesetManager.save(this).getAllValues())>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.changesetManager.delete(getChangesetid()) />
</cffunction>

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "changesetid">
</cffunction>

<cffunction name="setCategoryid" access="public" output="false">
	<cfargument name="categoryid" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.instance.categoryid = trim(arguments.categoryid) />
	<cfelse>
		<cfloop list="#arguments.categoryid#" index="i">
		<cfif not listFindNoCase(variables.instance.categoryid,trim(i))>
	    	<cfset variables.instance.categoryid = listAppend(variables.instance.categoryid,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="hasPendingApprovals" output="false">
		<cfreturn variables.changesetManager.hasPendingApprovals(getValue('changesetid'))>
</cffunction>

<cffunction name="getAssignmentsIterator" output="false">
		<cfreturn variables.changesetManager.getAssignmentsIterator(getValue('changesetid'))>
</cffunction>

<cffunction name="getAssignmentsQuery" output="false">
		<cfreturn variables.changesetManager.getAssignmentsQuery(getValue('changesetid'))>
</cffunction>

<cffunction name="rollback" output="false">
	<cfif variables.instance.published>
		<cfset var it=getBean('changesetRollBack')
			.getFeed()
			.setNextN(0)
			.setSiteid(getValue('siteid'))
			.addParam(column='changesetid',criteria=getValue('changesetid'))
			.getIterator()>

		<cfif it.hasNext()>
			<cfloop condition="it.hasNext()">
				<cfset it.next().rollback()>
			</cfloop>
		</cfif>	
	</cfif>

	<cfset variables.instance.published=0>
	<cfset variables.instance.publishdate="">
	<cfset save()>
	<!---<cfdump var="#variables.instance.published#" abort="true">--->

	<cfreturn this>
</cffunction>

<cffunction name="getFeed" access="public" returntype="any" output="false">
<cfargument name="siteid">
	<cfreturn getBean("beanFeed").setEntityName('changeset').setTable('tchangesets')>
</cffunction>

</cfcomponent>