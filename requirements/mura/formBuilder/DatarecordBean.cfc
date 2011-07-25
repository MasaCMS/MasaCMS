<cfcomponent displayname="DataRecordBean" output="false" extends="mura.cfobject">
	
	<cfproperty name="DataRecordID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="DatasetID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="Label" type="string" default="" required="true" maxlength="150" />
	<cfproperty name="Rblabel" type="string" default="" maxlength="50" />
	<cfproperty name="Value" type="string" default="" maxlength="35" />
	<cfproperty name="IsDefault" type="boolean" default="0" required="true" />
	<cfproperty name="OrderNo" type="numeric" default="0" required="true" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	
	<cfproperty name="IsInSet" type="boolean" default="0" required="true" />
	<cfproperty name="Config" type="Any" default="" required="true" />
	
	<cfset variables.instance = StructNew() />

	<!--- INIT --->
	<cffunction name="init" access="public" returntype="DataRecordBean" output="false">
		
		<cfargument name="DataRecordID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="DatasetID" type="string" required="false" default="" />
		<cfargument name="Label" type="string" required="false" default="" />
		<cfargument name="Rblabel" type="string" required="false" default="" />
		<cfargument name="Price" type="numeric" required="false" default="0.00" />
		<cfargument name="Weight" type="numeric" required="false" default="0.00" />
		<cfargument name="CustomID" type="string" required="false" default="" />
		<cfargument name="Value" type="string" required="false" default="" />
		<cfargument name="IsActive" type="boolean" required="false" default="0" />
		<cfargument name="IsDefault" type="boolean" required="false" default="0" />
		<cfargument name="OrderNo" type="numeric" required="false" default="0" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />
		
		<cfargument name="BeanExists" type="boolean" required="false" default="false" />
		<cfargument name="IsInSet" type="boolean" required="false" default="0" />
		<cfargument name="Config" type="Any" required="false" default="#StructNew()#" />

		<cfset super.init( argumentcollection=arguments ) />

		
		<cfset setDataRecordID( arguments.DataRecordID ) />
		<cfset setDatasetID( arguments.DatasetID ) />
		<cfset setLabel( arguments.Label ) />
		<cfset setRblabel( arguments.Rblabel ) />
		<cfset setPrice( arguments.Price ) />
		<cfset setWeight( arguments.Weight ) />
		<cfset setCustomID( arguments.CustomID ) />
		<cfset setValue( arguments.Value ) />
		<cfset setIsActive( arguments.IsActive ) />
		<cfset setIsDefault( arguments.IsDefault ) />
		<cfset setOrderNo( arguments.OrderNo ) />
		<cfset setRemoteID( arguments.RemoteID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		
		<cfset setBeanExists( arguments.BeanExists ) />
		<cfset setIsInSet( arguments.IsInSet ) />
		<cfset setConfig( arguments.Config ) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="setMemento" access="public" returntype="DataRecordBean" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
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
	
	<cffunction name="setRblabel" access="public" returntype="void" output="false">
		<cfargument name="Rblabel" type="string" required="true" />
		<cfset variables.instance['rblabel'] = arguments.Rblabel />
	</cffunction>
	<cffunction name="getRblabel" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Rblabel />
	</cffunction>
	
	<cffunction name="setPrice" access="public" returntype="void" output="false">
		<cfargument name="Price" type="numeric" required="true" />
		<cfset variables.instance['price'] = arguments.Price />
	</cffunction>
	<cffunction name="getPrice" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Price />
	</cffunction>
	
	<cffunction name="setWeight" access="public" returntype="void" output="false">
		<cfargument name="Weight" type="numeric" required="true" />
		<cfset variables.instance['weight'] = arguments.Weight />
	</cffunction>
	<cffunction name="getWeight" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Weight />
	</cffunction>
	
	<cffunction name="setCustomID" access="public" returntype="void" output="false">
		<cfargument name="CustomID" type="string" required="true" />
		<cfset variables.instance['customid'] = arguments.CustomID />
	</cffunction>
	<cffunction name="getCustomID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CustomID />
	</cffunction>
	
	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="Value" type="string" required="true" />
		<cfset variables.instance['value'] = arguments.Value />
	</cffunction>
	<cffunction name="getValue" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Value />
	</cffunction>
	
	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="IsActive" type="boolean" required="true" />
		<cfset variables.instance['isactive'] = arguments.IsActive />
	</cffunction>
	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsActive />
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
	

	<!--- Services --->
	<cffunction name="save" access="public" output="true" return="boolean">
		<cfif not getServiceExists()>
			<cfreturn false />
		</cfif>
		
		<cfif getBeanExists()>
			<cfset getDataRecordService().updateDataRecord( this ) />
		<cfelse>
			<cfset getDataRecordService().saveDataRecord( this ) />
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="update" access="public" output="true" return="boolean">
		<cfreturn save()>
	</cffunction>

	<cffunction name="delete" access="public" output="true" return="boolean">
		<cfset var sArgs = StructNew() />

		<cfif not getServiceExists()>
			<cfreturn false />
		</cfif>
		<cfset sArgs['DatasetID'] = getDatasetID() /> 
		
		<cfset getDataRecordService().deleteDataRecord( argumentCollection=sArgs  ) />
		<cfreturn true>
	</cffunction>

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#getMemento()#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<cffunction name="setBeanExists" access="public" output="false" returntype="void">
		<cfargument name="BeanExists" type="boolean" required="true" />
		<cfset variables.BeanExists = arguments.BeanExists >
	</cffunction>
	<cffunction name="BeanExists" access="public" output="false" returntype="boolean">
		<cfreturn variables.BeanExists>
	</cffunction>
	<cffunction name="getBeanExists" access="public" output="false" returntype="boolean">
		<cfreturn variables.BeanExists>
	</cffunction>

	<cffunction name="setDataRecordService" access="public" returntype="void" output="false">
		<cfargument name="DataRecordService" type="any" required="yes"/>
		<cfset variables.DataRecordService = arguments.DataRecordService />
	</cffunction>
	<cffunction name="getDataRecordService" access="public" returntype="any" output="false" >
		<cfif getServiceExists()>
			<cfreturn variables.DataRecordService />
		</cfif>
	</cffunction>
	<cffunction name="getServiceExists" access="public" returntype="boolean" output="false" >
		<cfreturn StructKeyExists(variables,"DataRecordService")>
	</cffunction>



	<cffunction name="getConfig" access="public" returntype="struct" output="false">
		<cfargument name="mode" type="string" required="false" default="json" />

		<cfif arguments.mode eq "object">
			<cfreturn deserializeJSON( variables.instance.config ) />
		<cfelse>
			<cfreturn variables.instance.config />
		</cfif>
	</cffunction>
	<cffunction name="setConfig" access="public" returntype="void" output="false">
		<cfargument name="Config" type="struct" required="true" />
		<cfif isJSON( arguments.Config )>
			<cfset variables.instance['config'] = arguments.config>
		<cfelse>
			<cfset variables.instance['config'] = serializeJSON( arguments.config )>
		</cfif>		
	</cffunction>

	<cffunction name="setIsInSet" access="public" returntype="void" output="false">
		<cfargument name="IsInSet" type="boolean" required="true" />
		<cfset variables.instance['isinset'] = arguments.IsInSet />
	</cffunction>
	<cffunction name="getIsInSet" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsInSet />
	</cffunction>

</cfcomponent>	




