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
the preparation of a derivative work based on Mura CMS. Thus, the terms 
and conditions of the GNU General Public License version 2 ("GPL") cover 
the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant 
you permission to combine Mura CMS with programs or libraries that are 
released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS 
grant you permission to combine Mura CMS with independent software modules 
(plugins, themes and bundles), and to distribute these plugins, themes and 
bundles without Mura CMS under the license of your choice, provided that 
you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories:

	/admin/
	/tasks/
	/config/
	/requirements/mura/
	/Application.cfc
	/index.cfm
	/MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
meets the above guidelines as a combined work under the terms of GPL for 
Mura CMS, provided that you include the source code of that other code when 
and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not 
obligated to grant this special exception for your modified version; it is 
your choice whether to do so, or to make such modified version available 
under the GNU General Public License version 2 without this exception.  You 
may, if you choose, apply this exception to your own modified versions of 
Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" output="false">

	<cfproperty name="emailID" type="string" default="" required="true" />
	<cfproperty name="siteID" type="string" default="" required="true" />
	<cfproperty name="subject" type="string" default=""/>
	<cfproperty name="bodyHTML" type="string" default=""/>
	<cfproperty name="bodyText" type="string" default=""/>
	<cfproperty name="format" type="string" default=""/>
	<cfproperty name="createdDate" type="date" default=""/>
	<cfproperty name="deliveryDate" type="date" default=""/>
	<cfproperty name="status" type="string" default=""/>
	<cfproperty name="groupID" type="string" default=""/>
	<cfproperty name="lastUpdate" type="date" default=""/>
	<cfproperty name="lastUpdateBy" type="string" default=""/>
	<cfproperty name="LastUpdateByID" type="string" default=""/>
	<cfproperty name="numberSent" type="numeric" default="0" required="true" />
	<cfproperty name="replyTo" type="string" default=""/>
	<cfproperty name="fromLabel" type="string" default=""/>
	<cfproperty name="template" type="string" default="" />

	<cffunction name="Init" access="public" output="false" returntype="any">
		<cfset super.init(argumentCollection=arguments)>
		
		<cfset variables.instance.emailID="" />
		<cfset variables.instance.siteid="" />
		<cfset variables.instance.subject="" />
		<cfset variables.instance.bodyhtml="" />
		<cfset variables.instance.bodytext="" />
		<cfset variables.instance.format="" />
		<cfset variables.instance.createdDate="#now()#" />
		<cfset variables.instance.deliveryDate="" />
		<cfset variables.instance.status="" />
		<cfset variables.instance.groupID="" />
		<cfset variables.instance.LastUpdateBy = "" />
		<cfset variables.instance.LastUpdateByID = "" />
		<cfset variables.instance.numberSent=0 />
		<cfset variables.instance.ReplyTo="" />
		<cfset variables.instance.FromLabel="" />
		<cfset variables.instance.template="" />

		<cfset variables.primaryKey = 'emailid'>
		<cfset variables.entityName = 'email'>
			
		<cfreturn this />
	</cffunction>

	<cffunction name="setEmailManager" access="public" output="false" returntype="any">
		<cfargument name="emailManager">
		<cfset variables.emailManager=arguments.emailManager>
		<cfreturn this>
	</cffunction>

	<cffunction name="setConfigBean" access="public" output="false" returntype="any">
		<cfargument name="configBean">
		<cfset variables.configBean=arguments.configBean>
		<cfreturn this>
	</cffunction>

	<cffunction name="getEmailID" access="public" output="false" returntype="any">
	    <cfif not len(variables.instance.EmailID)>
			<cfset variables.instance.EmailID = createUUID() />
		</cfif>
		<cfreturn variables.instance.EmailID />
		<cfreturn this>
	</cffunction>

	<cffunction name="setCreatedDate" access="public" output="false" returntype="any">
	    <cfargument name="CreatedDate" type="string" required="true">
		<cfset variables.instance.CreatedDate = parseDateArg(arguments.CreatedDate)/>
		<cfreturn this>
	</cffunction>

	<cffunction name="setDeliveryDate" access="public" output="false" returntype="any">
	    <cfargument name="DeliveryDate" type="string" required="true">
		<cfset variables.instance.DeliveryDate = parseDateArg(arguments.DeliveryDate)/>
		<cfreturn this>
	</cffunction>

	<cffunction name="setLastUpdateBy" access="public" output="false" returntype="any">
	    <cfargument name="LastUpdateBy" type="string" required="true">
	    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
		<cfreturn this>
	</cffunction>

	<cffunction name="setGroupList" access="public" output="false" returntype="any">
	    <cfargument name="groupList" type="string" required="true">
	    <cfset variables.instance.groupID = arguments.groupList />
		<cfreturn this>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="any">
		<cfset setAllValues(variables.emailManager.save(this).getAllValues())>
		<cfreturn this>
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfset variables.emailManager.delete(getEmailID())>
	</cffunction>

	<cffunction name="getPrimaryKey" access="public" output="false" returntype="string">
		<cfreturn "emailID">
	</cffunction>

</cfcomponent>