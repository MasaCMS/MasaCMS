<cfcomponent displayname="DatasetBean" output="false" extends="mura.cfobject">
	<cfproperty name="DatasetID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="ParentID" type="uuid" default="" maxlength="35" />
	<cfproperty name="Name" type="string" default="" maxlength="150" />
	<cfproperty name="SortColumn" type="string" default="orderby" required="true" maxlength="12" />
	<cfproperty name="SortDirection" type="string" default="asc" required="true" maxlength="4" />
	<cfproperty name="SortType" type="string" default="" maxlength="10" />
	<cfproperty name="IsGlobal" type="boolean" default="0" required="true" />
	<cfproperty name="IsSorted" type="boolean" default="0" required="true" />
	<cfproperty name="IsLocked" type="boolean" default="0" required="true" />
	<cfproperty name="IsActive" type="boolean" default="1" required="true" />
	<cfproperty name="SourceType" type="string" default="" maxlength="50" />
	<cfproperty name="Source" type="string" default="" maxlength="250" />
	<cfproperty name="SiteID" type="string" default="" required="true" maxlength="25" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	
	<cfproperty name="Model" type="Struct" default="" required="true" />
	<cfproperty name="DataRecords" type="Struct" default="" required="true" />
	<cfproperty name="DataRecordOrder" type="Array" default="" required="true" />
	<cfproperty name="IsSortChanged" type="boolean" default="0" required="true" />
	<cfproperty name="DeletedRecords" type="Struct" default="" required="false" />

	<cfset variables.instance 			= StructNew() />
	<cfset variables.DataRecordChecked	= false />

	<!--- INIT --->
	<cffunction name="init" access="public" returntype="DatasetBean" output="false">
		
		<cfargument name="DatasetID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="ParentID" type="string" required="false" default="" />
		<cfargument name="Name" type="string" required="false" default="" />
		<cfargument name="SortColumn" type="string" required="false" default="orderby" />
		<cfargument name="SortDirection" type="string" required="false" default="asc" />
		<cfargument name="SortType" type="string" required="false" default="" />
		<cfargument name="IsGlobal" type="boolean" required="false" default="0" />
		<cfargument name="IsSorted" type="boolean" required="false" default="0" />
		<cfargument name="IsLocked" type="boolean" required="false" default="0" />
		<cfargument name="IsActive" type="boolean" required="false" default="1" />
		<cfargument name="SourceType" type="string" required="false" default="" />
		<cfargument name="Source" type="string" required="false" default="" />
		<cfargument name="SiteID" type="string" required="false" default="" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />
		
		<cfargument name="Model" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="DataRecords" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="DataRecordOrder" type="Array" required="false" default="#ArrayNew(1)#" />
		<cfargument name="IsSortChanged" type="boolean" required="false" default="0" />
		<cfargument name="DeletedRecords" type="Struct" required="false" default="#StructNew()#" />

		<cfset super.init( argumentcollection=arguments ) />

		
		<cfset setDatasetID( arguments.DatasetID ) />
		<cfset setParentID( arguments.ParentID ) />
		<cfset setName( arguments.Name ) />
		<cfset setSortColumn( arguments.SortColumn ) />
		<cfset setSortDirection( arguments.SortDirection ) />
		<cfset setSortType( arguments.SortType ) />
		<cfset setIsGlobal( arguments.IsGlobal ) />
		<cfset setIsSorted( arguments.IsLocked ) />
		<cfset setIsLocked( arguments.IsLocked ) />
		<cfset setIsActive( arguments.IsActive ) />
		<cfset setSourceType( arguments.SourceType ) />
		<cfset setSource( arguments.Source ) />
		<cfset setSiteID( arguments.SiteID ) />
		<cfset setRemoteID( arguments.RemoteID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		
		<cfset setModel( arguments.Model ) />
		<cfset setDataRecords( arguments.DataRecords ) />
		<cfset setDataRecordOrder( arguments.DataRecordOrder ) />
		<cfset setIsSortChanged( arguments.IsSortChanged ) />
		<cfset setDeletedRecords( arguments.DeletedRecords ) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="setAllValues" access="public" returntype="DatasetBean" output="false">
		<cfargument name="AllValues" type="struct" required="yes"/>
		<cfset variables.instance = arguments.AllValues />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllValues" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setDatasetID" access="public" returntype="void" output="false">
		<cfargument name="DatasetID" type="uuid" required="true" />
		<cfset variables.instance['datasetid'] = arguments.DatasetID />
	</cffunction>
	<cffunction name="getDatasetID" access="public" returntype="uuid" output="false">
		<cfreturn variables.instance.DatasetID />
	</cffunction>

	<cffunction name="setParentID" access="public" returntype="void" output="false">
		<cfargument name="ParentID" type="string" required="true" />
		<cfset variables.instance['parentid'] = arguments.ParentID />
	</cffunction>
	<cffunction name="getParentID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ParentID />
	</cffunction>

	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="Name" type="string" required="true" />
		<cfset variables.instance['name'] = arguments.Name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Name />
	</cffunction>
	
	<cffunction name="setSortColumn" access="public" returntype="void" output="false">
		<cfargument name="SortColumn" type="string" required="true" />
		<cfset variables.instance['sortcolumn'] = arguments.SortColumn />
	</cffunction>
	<cffunction name="getSortColumn" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SortColumn />
	</cffunction>
	
	<cffunction name="setSortDirection" access="public" returntype="void" output="false">
		<cfargument name="SortDirection" type="string" required="true" />
		<cfset variables.instance['sortdirection'] = arguments.SortDirection />
	</cffunction>
	<cffunction name="getSortDirection" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SortDirection />
	</cffunction>
	
	<cffunction name="setSortType" access="public" returntype="void" output="false">
		<cfargument name="SortType" type="string" required="true" />
		<cfset variables.instance['sorttype'] = arguments.SortType />
	</cffunction>
	<cffunction name="getSortType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SortType />
	</cffunction>
	
	<cffunction name="setIsGlobal" access="public" returntype="void" output="false">
		<cfargument name="IsGlobal" type="boolean" required="true" />
		<cfset variables.instance['isglobal'] = arguments.IsGlobal />
	</cffunction>
	<cffunction name="getIsGlobal" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsGlobal />
	</cffunction>
	
	<cffunction name="setIsSorted" access="public" returntype="void" output="false">
		<cfargument name="IsSorted" type="boolean" required="true" />
		<cfset variables.instance['isSorted'] = arguments.IsSorted />
	</cffunction>
	<cffunction name="getIsSorted" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsSorted />
	</cffunction>
	
	<cffunction name="setIsLocked" access="public" returntype="void" output="false">
		<cfargument name="IsLocked" type="boolean" required="true" />
		<cfset variables.instance['islocked'] = arguments.IsLocked />
	</cffunction>
	<cffunction name="getIsLocked" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsLocked />
	</cffunction>
	
	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="IsActive" type="boolean" required="true" />
		<cfset variables.instance['isactive'] = arguments.IsActive />
	</cffunction>
	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsActive />
	</cffunction>
	
	<cffunction name="setSourceType" access="public" returntype="void" output="false">
		<cfargument name="SourceType" type="string" required="true" />
		<cfset variables.instance['sourcetype'] = arguments.SourceType />
	</cffunction>
	<cffunction name="getSourceType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SourceType />
	</cffunction>
	
	<cffunction name="setSource" access="public" returntype="void" output="false">
		<cfargument name="Source" type="string" required="true" />
		<cfset variables.instance['source'] = arguments.Source />
	</cffunction>
	<cffunction name="getSource" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Source />
	</cffunction>
	
	<cffunction name="setSiteID" access="public" returntype="void" output="false">
		<cfargument name="SiteID" type="string" required="true" />
		<cfset variables.instance['siteid'] = arguments.SiteID />
	</cffunction>
	<cffunction name="getSiteID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SiteID />
	</cffunction>
	
	<cffunction name="setRemoteID" access="public" returntype="void" output="false">
		<cfargument name="RemoteID" type="string" required="true" />
		<cfset variables.instance['remoteid'] = arguments.RemoteID />
	</cffunction>
	<cffunction name="getRemoteID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.RemoteID />
	</cffunction>
	
	<cffunction name="setDateCreate" access="public" returntype="void" output="false">
		<cfargument name="DateCreate" type="string" required="true" />
		<cfset variables.instance['datecreate'] = arguments.DateCreate />
	</cffunction>
	<cffunction name="getDateCreate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DateCreate />
	</cffunction>
	
	<cffunction name="setDateLastUpdate" access="public" returntype="void" output="false">
		<cfargument name="DateLastUpdate" type="string" required="true" />
		<cfset variables.instance['datelastupdate'] = arguments.DateLastUpdate />
	</cffunction>
	<cffunction name="getDateLastUpdate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DateLastUpdate />
	</cffunction>

	<cffunction name="setModel" access="public" returntype="void" output="false">
		<cfargument name="Model" type="Struct" required="true" />
		<cfset variables.instance['model'] = arguments.Model />
	</cffunction>
	<cffunction name="getModel" access="public" returntype="Struct" output="false">
		<cfreturn variables.instance.Model />
	</cffunction>

	<cffunction name="setDataRecords" access="public" returntype="void" output="false">
		<cfargument name="DataRecords" type="struct" required="true" />
		<cfset variables.instance['datarecords'] = arguments.DataRecords />
	</cffunction>
	<cffunction name="getDataRecords" access="public" returntype="struct" output="false">
		<cfreturn variables.instance.DataRecords />
	</cffunction>
	<cffunction name="getDataRecord" access="public" returntype="any" output="false">
		<cfargument name="DataRecordID" type="struct" required="true" />

		<cfif StructKeyExists( variables.instance.DataRecords,arguments.DataRecordID )>
			<cfreturn variables.instance.DataRecords[arguments.DataRecordID] />
		</cfif>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="setDataRecordOrder" access="public" returntype="void" output="false">
		<cfargument name="DataRecordOrder" type="Array" required="true" />
		<cfset variables.instance['datarecordorder'] = arguments.DataRecordOrder />
	</cffunction>
	<cffunction name="getDataRecordOrder" access="public" returntype="Array" output="false">
		<cfreturn variables.instance.DataRecordOrder />
	</cffunction>

	<cffunction name="setIsSortChanged" access="public" returntype="void" output="false">
		<cfargument name="IsSortChanged" type="boolean" required="true" />
		<cfset variables.instance['issortchanged'] = arguments.IsSortChanged />
	</cffunction>
	<cffunction name="getIsSortChanged" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsSortChanged />
	</cffunction>

	<cffunction name="setDeletedRecords" access="public" returntype="void" output="false">
		<cfargument name="DeletedRecords" type="struct" required="true" />
		<cfset variables.instance['deletedrecords'] = arguments.DeletedRecords />
	</cffunction>
	<cffunction name="getDeletedRecords" access="public" returntype="struct" output="false">
		<cfreturn variables.instance.DeletedRecords />
	</cffunction>
</cfcomponent>	




