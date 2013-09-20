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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
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
<cfargument name="trashManager" type="any" required="yes"/>
	<cfset variables.configBean=arguments.configbean />
	<cfset variables.mailinglistDAO=arguments.mailinglistDAO />
	<cfset variables.mailinglistGateway=arguments.mailinglistGateway />
	<cfset variables.mailinglistUtility=arguments.mailinglistUtility />
	<cfset variables.memberManager=arguments.memberManager />
	<cfset variables.utility=arguments.utility />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.trashManager=arguments.trashManager />
	<cfreturn this />
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="data">
	<cfset var rs="">
	
		<cfif isObject(arguments.data)>
		<cfif listLast(getMetaData(arguments.data).name,".") eq "mailinglistBean">
			<cfset arguments.data=arguments.data.getAllValues()>
		<cfelse>
			<cfthrow type="custom" message="The attribute 'DATA' is not of type 'mura.mailinglist.mailinglistBean'">
		</cfif>
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"mlid")>
		<cfthrow type="custom" message="The attribute 'NLID' is required when saving a mailing list.">
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select * from tmailinglist where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.mlid#">
	</cfquery>

	<cfif not rs.recordcount>
		<cfreturn create(arguments.data)>
	<cfelse>
		<cfreturn update(arguments.data)>
	</cfif>
 </cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="data" type="struct"  />
	
	<cfset var listBean=getBean("mailinglist") />
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
	
	<cfset var listBean=getBean("mailinglist") />
	<cfset listBean.set(arguments.data) />
	<cfif not structKeyExists(arguments.data,"fromMuraTrash")>
		<cfset listBean.setMLID(createuuid()) />
	</cfif>
	<cfset variables.utility.logEvent("MLID:#listBean.getMLID()# Name:#listBean.getName()# was updated","mura-mailinglists","Information",true) />
	<cfset variables.mailinglistDAO.create(listbean) />
	<cfif isdefined('arguments.data.listfile') and arguments.data.listfile neq ''>
		<cfset variables.mailinglistUtility.upload(arguments.data.direction,listbean) />
	</cfif>
	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache() />
	<cfset variables.trashManager.takeOut(listBean)>
	<cfset listbean.setIsNew(0)>
	<cfreturn listBean />
</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cfset var listBean=read(arguments.mlid,arguments.siteid) />
	<cfset variables.trashManager.throwIn(listBean)>
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
	<cfargument name="mlid" type="string" default=""/>
	<cfargument name="siteid" type="string"/>
	<cfargument name="name" required="true" default=""/>
	
	<cfif not len(arguments.mlid) and len(arguments.siteID) and len(arguments.name)>
		<cfreturn variables.mailinglistDAO.readByName(arguments.name, arguments.siteID) />
	</cfif>	
		
	<cfreturn variables.mailinglistDAO.read(arguments.mlid) />
	
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