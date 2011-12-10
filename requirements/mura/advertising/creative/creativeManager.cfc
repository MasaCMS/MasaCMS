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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="creativeGateway" type="any" required="yes"/>
<cfargument name="creativeDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="fileManager" type="any" required="yes"/>
<cfargument name="trashManager" type="any" required="yes"/>

	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.creativeGateway />
	<cfset variables.instance.DAO=arguments.creativeDAO />
	<cfset variables.instance.globalUtility=arguments.utility />
	<cfset variables.instance.fileManager=arguments.fileManager />
	<cfset variables.instance.trashManager=arguments.trashManager />
	
	<cfreturn this />
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="beanName" default="creative">
	<cfreturn super.getBean(arguments.beanName)>
</cffunction>

<cffunction name="getCreativesByUser" returntype="query" access="public" output="false">
	<cfargument name="userid"  type="string" />

	<cfreturn variables.instance.gateway.getCreativesByUser(arguments.userid) />
</cffunction>

<cffunction name="getCreativesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteid"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.gateway.getCreativesBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var creativeBean=getBean("creativeBean") />
	<cfset creativeBean.set(arguments.data) />
	
	<cfif structIsEmpty(creativeBean.getErrors())>
		<cfset creativeBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfif not (structKeyExists(arguments.data,"creativeID") and len(arguments.data.creativeID))>
			<cfset creativeBean.setCreativeID("#createUUID()#") />
		</cfif>
		<cfset variables.instance.globalUtility.logEvent("CreativeID:#creativeBean.getCreativeID()# Name:#creativeBean.getName()# was created","mura-advertising","Information",true) />
		<cfif structKeyExists(arguments.data,"newFile")>
			<cfset uploadMedia(creativeBean,arguments.data.newFile,arguments.data.siteid) />
		</cfif>
		<cfset variables.instance.DAO.create(creativeBean) />
		<cfset variables.instance.trashManager.takeOut(creativeBean)>
	</cfif>
	<cfreturn creativeBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="creativeID" type="String" />		
	
	<cfreturn variables.instance.DAO.read(arguments.creativeID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var creativeBean=variables.instance.DAO.read(arguments.data.creativeID) />
	<cfset creativeBean.set(arguments.data) />
	
	<cfif structIsEmpty(creativeBean.getErrors())>
		<cfset variables.instance.globalUtility.logEvent("CreativeID:#creativeBean.getCreativeID()# Name:#creativeBean.getName()# was updated","mura-advertising","Information",true) />
		<cfset uploadMedia(creativeBean,arguments.data.newFile,arguments.data.siteid) />
		<cfset creativeBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfset variables.instance.DAO.update(creativeBean) />
	</cfif>
	
	<cfreturn creativeBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="creativeID" type="String" />	
	
	<cfset var creativeBean=variables.instance.DAO.read(arguments.creativeID) />	
	<cfset variables.instance.trashManager.throwIn(creativeBean)>
	<cfset deleteMedia(creativeBean) />
	<cfset variables.instance.DAO.delete(arguments.creativeID) />
	<cfset variables.instance.globalUtility.logEvent("CreativeID:#creativeBean.getCreativeID()# Name:#creativeBean.getName()# was deleted","mura-advertising","Information",true) />

</cffunction>

<cffunction name="uploadMedia" access="private" output="false" returntype="void">
<cfargument name="creativeBean" type="any">
<cfargument name="newFile" type="any">
<cfargument name="siteid" type="string">

<cfset var fileObj = "">

	<cfif arguments.newFile neq ''>
		<cfset deleteMedia(arguments.creativeBean)>
		<cffile action="upload" filefield="NewFile" nameconflict="makeunique" destination="#variables.instance.configBean.getTempDir()#">
		<cffile action="readBinary" file="#variables.instance.configBean.getTempDir()##cffile.serverfile#" variable="fileObj">	
		<cfset arguments.creativeBean.setFileID(variables.instance.fileManager.create(fileObj, arguments.creativeBean.getCreativeID() ,arguments.siteid,cffile.ClientFile,cffile.ContentType,cffile.ContentSubType,cffile.FileSize,'00000000000000000000000000000000006',cffile.serverFileExt,'','')) />
		<cffile action="delete" file="#variables.instance.configBean.getTempDir()##cffile.serverfile#">
	</cfif>	
	
</cffunction>

<cffunction name="deleteMedia" access="private" output="false" returntype="void">
<cfargument name="creativeBean" type="any">

	<cfif arguments.creativeBean.getFileID() neq ''>
			<cfset variables.instance.filemanager.deleteVersion(arguments.creativeBean.getFileID()) />
			<cfset arguments.creativeBean.setFileID("")>
	</cfif>
	
</cffunction>

</cfcomponent>