<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="mailinglistDAO" type="any" required="yes"/>
<cfargument name="mailinglistGateway" type="any" required="yes"/>
<cfargument name="mailinglistUtility" type="any" required="yes"/>
<cfargument name="memberManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configbean />
		<cfset variables.mailinglistDAO=arguments.mailinglistDAO />
		<cfset variables.mailinglistGateway=arguments.mailinglistGateway />
		<cfset variables.mailinglistUtility=arguments.mailinglistUtility />
		<cfset variables.memberManager=arguments.memberManager />
		<cfset variables.utility=arguments.utility />
		<cfset variables.settingsManager=arguments.settingsManager />
	<cfreturn this />
	
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct"  />
	
	<cfset var listBean=application.serviceFactory.getBean("mailinglistBean") />
	<cfset listBean.set(arguments.data) />
	<cfset variables.utility.logEvent("MLID:#listBean.getMLID()# Name:#listBean.getName()# was created","mura-mailinglists","Information",true) />
	<cfset variables.mailinglistDAO.update(listbean) />
	<cfif isdefined('arguments.data.listfile') and arguments.data.listfile neq ''>
		<cfset variables.mailinglistUtility.upload(arguments.data.direction,listbean) />
	</cfif>
	<cfif isdefined('arguments.data.clearMembers')>
		<cfset  variables.mailinglistDAO.deleteMembers(arguments.data.mlid,arguments.data.siteid) />
	</cfif>
	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache() />
</cffunction>

<cffunction name="create" access="public" output="false" returntype="any" >
	<cfargument name="data" type="struct"  />
	
	<cfset var listBean=application.serviceFactory.getBean("mailinglistBean") />
	<cfset listBean.set(arguments.data) />
	<cfset listBean.setMLID(createuuid()) />
	<cfset variables.utility.logEvent("MLID:#listBean.getMLID()# Name:#listBean.getName()# was updated","mura-mailinglists","Information",true) />
	<cfset variables.mailinglistDAO.create(listbean) />
	<cfif isdefined('arguments.data.listfile') and arguments.data.listfile neq ''>
		<cfset variables.mailinglistUtility.upload(arguments.data.direction,listbean) />
	</cfif>
	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache() />
	
	<cfreturn listBean />
</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfset var listBean=read(arguments.mlid,arguments.siteid) />
	<cfset variables.utility.logEvent("MLID:#arguments.mlid# Name:#listBean.getName()# was deleted","mura-mailinglists","Information",true) />
	<cfset variables.mailinglistDAO.delete(arguments.mlid,arguments.siteid) />
	<cfset variables.settingsManager.getSite(arguments.siteid).purgeCache() />
	
</cffunction>

<cffunction name="deleteMember" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	<cfset variables.memberManager.delete(arguments.data) />
	
</cffunction>

<cffunction name="deleteMemberAll" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	<cfset variables.memberManager.deleteAll(arguments.data) />
	
</cffunction>

<cffunction name="createMember" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />
	
	<cfset variables.memberManager.create(arguments.data,this) />
	
</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfset var listBean = variables.mailinglistDAO.read(arguments.mlid,arguments.siteid) />
	
	<cfreturn listBean />
	
</cffunction>

<cffunction name="readMember" access="public" output="false" returntype="any" >
	<cfargument name="data" type="struct" />
	
	<cfset var memberBean = variables.memberManager.read(arguments.data) />
	
	<cfreturn memberBean />
	
</cffunction>

<cffunction name="getListMembers" access="public" output="false" returntype="query" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfset var rs = variables.mailinglistGateway.getListMembers(arguments.mlid,arguments.siteid) />
	
	<cfreturn rs />
	
</cffunction>

<cffunction name="deleteMembers" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfset  variables.mailinglistDAO.deleteMembers(arguments.mlid,arguments.siteid) />
	
</cffunction>

<cffunction name="getList" access="public" output="false" returntype="query" >
	<cfargument name="siteid" type="string" />
	
	<cfset var rs = variables.mailinglistGateway.getList(arguments.siteid) />
	
	<cfreturn rs />
	
</cffunction>

<cffunction name="masterSubscribe" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />

	<cfset variables.memberManager.masterSubscribe(arguments.data,this) />

</cffunction>

<cffunction name="validateMember" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct" />

	<cfset variables.memberManager.validateMember(arguments.data) />

</cffunction>

</cfcomponent>