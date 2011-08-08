<cfcomponent displayname="DataRecordBean" output="false" extends="mura.cfobject">
	
	<cfproperty name="DataRecordID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="DatasetID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="Label" type="string" default="" required="true" maxlength="150" />
	<cfproperty name="Value" type="string" default="" maxlength="35" />
	<cfproperty name="IsDefault" type="boolean" default="0" required="true" />
	<cfproperty name="OrderNo" type="numeric" default="0" required="true" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	
	<cfset variables.instance = StructNew() />

	<!--- INIT --->
	<cffunction name="init" access="public" returntype="DataRecordBean" output="false">
		
		<cfargument name="DataRecordID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="DatasetID" type="string" required="false" default="" />
		<cfargument name="Label" type="string" required="false" default="" />
		<cfargument name="Value" type="string" required="false" default="" />
		<cfargument name="IsDefault" type="boolean" required="false" default="0" />
		<cfargument name="OrderNo" type="numeric" required="false" default="0" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />	

		<cfset super.init( argumentcollection=arguments ) />

		
		<cfset setDataRecordID( arguments.DataRecordID ) />
		<cfset setDatasetID( arguments.DatasetID ) />
		<cfset setLabel( arguments.Label ) />
		<cfset setValue( arguments.Value ) />
		<cfset setIsDefault( arguments.IsDefault ) />
		<cfset setOrderNo( arguments.OrderNo ) />
		<cfset setRemoteID( arguments.RemoteID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		
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
	
	<cffunction name="setDataRecordID" access="public" returntype="void" output="false">
		<cfargument name="DataRecordID" type="uuid" required="true" />
		<cfset variables.instance['datarecordid'] = arguments.DataRecordID />
	</cffunction>
	<cffunction name="getDataRecordID" access="public" returntype="uuid" output="false">
		<cfreturn variables.instance.DataRecordID />
	</cffunction>
	
	<cffunction name="setDatasetID" access="public" returntype="void" output="false">
		<cfargument name="DatasetID" type="string" required="true" />
		<cfset variables.instance['datasetid'] = arguments.DatasetID />
	</cffunction>
	<cffunction name="getDatasetID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DatasetID />
	</cffunction>
	
	<cffunction name="setLabel" access="public" returntype="void" output="false">
		<cfargument name="Label" type="string" required="true" />
		<cfset variables.instance['label'] = arguments.Label />
	</cffunction>
	<cffunction name="getLabel" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Label />
	</cffunction>
	
	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="Value" type="string" required="true" />
		<cfset variables.instance['value'] = arguments.Value />
	</cffunction>
	<cffunction name="getValue" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Value />
	</cffunction>
	
	<cffunction name="setIsDefault" access="public" returntype="void" output="false">
		<cfargument name="IsDefault" type="boolean" required="true" />
		<cfset variables.instance['isdefault'] = arguments.IsDefault />
	</cffunction>
	<cffunction name="getIsDefault" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDefault />
	</cffunction>
	
	<cffunction name="setOrderNo" access="public" returntype="void" output="false">
		<cfargument name="OrderNo" type="numeric" required="true" />
		<cfset variables.instance['orderno'] = arguments.OrderNo />
	</cffunction>
	<cffunction name="getOrderNo" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderNo />
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
</cfcomponent>	




