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
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent displayname="fieldtypeBean" output="false"  extends="mura.cfobject">
	<cfproperty name="FieldTypeID" type="uuid" default="" required="true" maxlength="35" />
	<cfproperty name="Label" type="string" default="" required="true" maxlength="45" />
	<cfproperty name="RbLabel" type="string" default="" maxlength="35" />
	<cfproperty name="Fieldtype" type="string" default="" required="true" maxlength="25" />
	<cfproperty name="Bean" type="string" default="" required="true" maxlength="50" />
	<cfproperty name="IsData" type="boolean" default="0" required="true" />
	<cfproperty name="IsLong" type="boolean" default="0" required="true" />
	<cfproperty name="ModuleID" type="uuid" default="" maxlength="35" />
	<cfproperty name="DateCreate" type="date" default="" required="true" />
	<cfproperty name="DateLastUpdate" type="date" default="" required="true" />
	<cfproperty name="Displaytype" type="string" default="field" required="true" maxlength="25" />
	
	<cfset variables.instance = StructNew() />

	<!--- INIT --->
	<cffunction name="init" access="public" returntype="fieldtypeBean" output="false">
		
		<cfargument name="FieldTypeID" type="uuid" required="false" default="#CreateUUID()#" />
		<cfargument name="Label" type="string" required="false" default="" />
		<cfargument name="RbLabel" type="string" required="false" default="" />
		<cfargument name="Fieldtype" type="string" required="false" default="" />
		<cfargument name="Bean" type="string" required="false" default="" />
		<cfargument name="IsData" type="boolean" required="false" default="0" />
		<cfargument name="IsLong" type="boolean" required="false" default="0" />
		<cfargument name="ModuleID" type="string" required="false" default="" />
		<cfargument name="DateCreate" type="string" required="false" default="" />
		<cfargument name="DateLastUpdate" type="string" required="false" default="" />
		<cfargument name="Displaytype" type="string" required="false" default="field" />

		
		<cfset setFieldTypeID( arguments.FieldTypeID ) />
		<cfset setLabel( arguments.Label ) />
		<cfset setRbLabel( arguments.RbLabel ) />
		<cfset setFieldtype( arguments.Fieldtype ) />
		<cfset setBean( arguments.Bean ) />
		<cfset setIsData( arguments.IsData ) />
		<cfset setIsLong( arguments.IsLong ) />
		<cfset setModuleID( arguments.ModuleID ) />
		<cfset setDateCreate( arguments.DateCreate ) />
		<cfset setDateLastUpdate( arguments.DateLastUpdate ) />
		<cfset setDisplaytype( arguments.Displaytype ) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="setAllValues" access="public" returntype="FieldtypeBean" output="false">
		<cfargument name="values" type="struct" required="yes"/>
		<cfset variables.instance = arguments.values />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllValues" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>
	
	<cffunction name="setFieldTypeID" access="public" returntype="void" output="false">
		<cfargument name="FieldTypeID" type="uuid" required="true" />
		<cfset variables.instance['fieldtypeid'] = arguments.FieldTypeID />
	</cffunction>
	<cffunction name="getFieldTypeID" access="public" returntype="uuid" output="false">
		<cfreturn variables.instance.FieldTypeID />
	</cffunction>
	
	<cffunction name="setLabel" access="public" returntype="void" output="false">
		<cfargument name="Label" type="string" required="true" />
		<cfset variables.instance['label'] = arguments.Label />
	</cffunction>
	<cffunction name="getLabel" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Label />
	</cffunction>
	
	<cffunction name="setRbLabel" access="public" returntype="void" output="false">
		<cfargument name="RbLabel" type="string" required="true" />
		<cfset variables.instance['rblabel'] = arguments.RbLabel />
	</cffunction>
	<cffunction name="getRbLabel" access="public" returntype="string" output="false">
		<cfreturn variables.instance.RbLabel />
	</cffunction>
	
	<cffunction name="setFieldtype" access="public" returntype="void" output="false">
		<cfargument name="Fieldtype" type="string" required="true" />
		<cfset variables.instance['fieldtype'] = arguments.Fieldtype />
	</cffunction>
	<cffunction name="getFieldtype" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Fieldtype />
	</cffunction>
	
	<cffunction name="setBean" access="public" returntype="void" output="false">
		<cfargument name="Bean" type="string" required="true" />
		<cfset variables.instance['bean'] = arguments.Bean />
	</cffunction>
	<cffunction name="getBean" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Bean />
	</cffunction>
	
	<cffunction name="setIsData" access="public" returntype="void" output="false">
		<cfargument name="IsData" type="boolean" required="true" />
		<cfset variables.instance['isdata'] = arguments.IsData />
	</cffunction>
	<cffunction name="getIsData" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsData />
	</cffunction>
	
	<cffunction name="setIsLong" access="public" returntype="void" output="false">
		<cfargument name="IsLong" type="boolean" required="true" />
		<cfset variables.instance['islong'] = arguments.IsLong />
	</cffunction>
	<cffunction name="getIsLong" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsLong />
	</cffunction>
	
	<cffunction name="setModuleID" access="public" returntype="void" output="false">
		<cfargument name="ModuleID" type="string" required="true" />
		<cfset variables.instance['moduleid'] = arguments.ModuleID />
	</cffunction>
	<cffunction name="getModuleID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ModuleID />
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
	
	<cffunction name="setDisplaytype" access="public" returntype="void" output="false">
		<cfargument name="Displaytype" type="string" required="true" />
		<cfset variables.instance['displaytype'] = arguments.Displaytype />
	</cffunction>
	<cffunction name="getDisplaytype" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Displaytype />
	</cffunction>
</cfcomponent>	



