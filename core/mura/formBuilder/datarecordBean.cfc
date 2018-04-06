<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent displayname="DataRecordBean" output="false" extends="mura.cfobject" hint="This provides dataRecordBean functionality">

	<cfproperty name="DataRecordID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="DatasetID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="Label" type="string" default="" required="true" maxlength="150" />
	<cfproperty name="Value" type="string" default="" maxlength="35" />
	<cfproperty name="OrderNo" type="numeric" default="0" required="true" />
	<cfproperty name="IsSelected" type="numeric" default="0" required="true" />
	<cfproperty name="RemoteID" type="string" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />

	<cfset variables.instance = StructNew() />

	<!--- INIT --->
	<cffunction name="init" returntype="DataRecordBean" output="false">

		<cfargument name="DataRecordID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="DatasetID" type="string" required="false" default="" />
		<cfargument name="Label" type="string" required="false" default="" />
		<cfargument name="Value" type="string" required="false" default="" />
		<cfargument name="OrderNo" type="numeric" required="false" default="0" />
		<cfargument name="IsSelected" type="numeric" required="false" default="0" />
		<cfargument name="RemoteID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />

		<cfset super.init( argumentcollection=arguments ) />


		<cfset setDataRecordID( arguments.DataRecordID ) />
		<cfset setDatasetID( arguments.DatasetID ) />
		<cfset setLabel( arguments.Label ) />
		<cfset setValue( arguments.Value ) />
		<cfset setOrderNo( arguments.OrderNo ) />
		<cfset setRemoteID( arguments.RemoteID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		<cfset setIsSelected( arguments.IsSelected ) />

		<cfreturn this />
	</cffunction>

	<cffunction name="setAllValues" returntype="DatasetBean" output="false">
		<cfargument name="AllValues" type="struct" required="yes"/>
		<cfset variables.instance = arguments.AllValues />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllValues" returntype="struct" output="false">
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setDataRecordID" output="false">
		<cfargument name="DataRecordID" type="uuid" required="true" />
		<cfset variables.instance['datarecordid'] = arguments.DataRecordID />
	</cffunction>
	<cffunction name="getDataRecordID" returntype="uuid" output="false">
		<cfreturn variables.instance.DataRecordID />
	</cffunction>

	<cffunction name="setDatasetID" output="false">
		<cfargument name="DatasetID" type="string" required="true" />
		<cfset variables.instance['datasetid'] = arguments.DatasetID />
	</cffunction>
	<cffunction name="getDatasetID" output="false">
		<cfreturn variables.instance.DatasetID />
	</cffunction>

	<cffunction name="setLabel" output="false">
		<cfargument name="Label" type="string" required="true" />
		<cfset variables.instance['label'] = arguments.Label />
	</cffunction>
	<cffunction name="getLabel" output="false">
		<cfreturn variables.instance.Label />
	</cffunction>

	<cffunction name="setValue" output="false">
		<cfargument name="Value" type="string" required="true" />
		<cfset variables.instance['value'] = arguments.Value />
	</cffunction>
	<cffunction name="getValue" output="false">
		<cfreturn variables.instance.Value />
	</cffunction>

	<cffunction name="setOrderNo" output="false">
		<cfargument name="OrderNo" type="numeric" required="true" />
		<cfset variables.instance['orderno'] = arguments.OrderNo />
	</cffunction>
	<cffunction name="getOrderNo" output="false">
		<cfreturn variables.instance.OrderNo />
	</cffunction>

	<cffunction name="setIsSelected" output="false">
		<cfargument name="IsSelected" type="numeric" required="true" />
		<cfset variables.instance['isselected'] = arguments.IsSelected />
	</cffunction>
	<cffunction name="getIsSelected" output="false">
		<cfreturn variables.instance.IsSelected />
	</cffunction>

	<cffunction name="setRemoteID" output="false">
		<cfargument name="RemoteID" type="string" required="true" />
		<cfset variables.instance['remoteid'] = arguments.RemoteID />
	</cffunction>
	<cffunction name="getRemoteID" output="false">
		<cfreturn variables.instance.RemoteID />
	</cffunction>

	<cffunction name="setDateCreate" output="false">
		<cfargument name="DateCreate" type="string" required="true" />
		<cfset variables.instance['datecreate'] = arguments.DateCreate />
	</cffunction>
	<cffunction name="getDateCreate" output="false">
		<cfreturn variables.instance.DateCreate />
	</cffunction>

	<cffunction name="setDateLastUpdate" output="false">
		<cfargument name="DateLastUpdate" type="string" required="true" />
		<cfset variables.instance['datelastupdate'] = arguments.DateLastUpdate />
	</cffunction>
	<cffunction name="getDateLastUpdate" output="false">
		<cfreturn variables.instance.DateLastUpdate />
	</cffunction>
</cfcomponent>
