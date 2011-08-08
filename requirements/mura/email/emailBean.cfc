<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="emailID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="subject" type="string" default="" required="true" />
<cfproperty name="bodyHTML" type="string" default="" required="true" />
<cfproperty name="bodyText" type="string" default="" required="true" />
<cfproperty name="format" type="string" default="" required="true" />
<cfproperty name="createdDate" type="date" default="" required="true" />
<cfproperty name="deliveryDate" type="date" default="" required="true" />
<cfproperty name="status" type="string" default="" required="true" />
<cfproperty name="groupID" type="string" default="" required="true" />
<cfproperty name="lastUpdate" type="date" default="" required="true" />
<cfproperty name="lastUpdateBy" type="string" default="" required="true" />
<cfproperty name="LastUpdateByID" type="string" default="" required="true" />
<cfproperty name="numberSent" type="numeric" default="0" required="true" />
<cfproperty name="replyTo" type="string" default="" required="true" />
<cfproperty name="fromLabel" type="string" default="" required="true" />

<cffunction name="Init" access="public" returntype="any" output="false">
	
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
		
	<cfreturn this />
</cffunction>

<cffunction name="getEmailID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.EmailID)>
		<cfset variables.instance.EmailID = createUUID() />
	</cfif>
	<cfreturn variables.instance.EmailID />
</cffunction>

<cffunction name="setCreatedDate" returnType="void" output="false" access="public">
    <cfargument name="CreatedDate" type="string" required="true">
	<cfif isDate(arguments.CreatedDate)>
    <cfset variables.instance.CreatedDate = parseDateTime(arguments.CreatedDate) />
	<cfelse>
	<cfset variables.instance.CreatedDate = ""/>
	</cfif>
</cffunction>

<cffunction name="setDeliveryDate" returnType="void" output="false" access="public">
    <cfargument name="DeliveryDate" type="string" required="true">
	<cfif lsisDate(arguments.DeliveryDate)>
		<cftry>
		<cfset variables.instance.DeliveryDate = lsparseDateTime(arguments.DeliveryDate) />
		<cfcatch>
			<cfset variables.instance.DeliveryDate = arguments.DeliveryDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.DeliveryDate = ""/>
	</cfif>
</cffunction>

<cffunction name="setLastUpdateBy" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
</cffunction>

<cffunction name="save" output="false">
<cfset setAllValues(getBean("emailManager").save(this).getAllValues())>
<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
<cfset getBean("emailManager").delete(getEmailID())>
</cffunction>
</cfcomponent>