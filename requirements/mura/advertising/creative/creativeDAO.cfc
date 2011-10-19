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
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="creativeBean" type="any" />
	 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadcreatives (creativeID, UserID,  dateCreated, LastUpdate,
	lastUpdateBy, name, creativeType,  fileID, mediaType, redirectURL, altText, notes, isactive,
	height,width,textBody,title,linkTitle,target)
	values (
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeBean.getCreativeID()#" />,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeBean.getUserID()#" />,
	<cfif isDate(arguments.creativeBean.getDateCreated()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.creativeBean.getDateCreated()#"><cfelse>null</cfif>,
	<cfif isDate(arguments.creativeBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.creativeBean.getLastUpdate()#"><cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getName()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getCreativeType()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getFileID() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getFileID()#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getMediaType() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getMediaType()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getRedirectURL() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getRedirectURL()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getAltText() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getAltText()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.creativeBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getNotes()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.creativeBean.getIsActive()#" />,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.creativeBean.getHeight()),de(arguments.creativeBean.getHeight()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.creativeBean.getWidth()),de(arguments.creativeBean.getWidth()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.creativeBean.getTextBody() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTextBody()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getTitle() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTitle()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getLinkTitle() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getLinkTitle()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getTarget() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTarget()#">

	)
	</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="creativeID" type="string" />

	<cfset var creativeBean=getBean("creative") />
	<cfset var rs ="" />
	
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	Select tadcreatives.*, tfiles.fileExt, tfiles.siteID from tadcreatives 
	left join tfiles on (tadcreatives.fileID=tfiles.fileID) 
	where creativeID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeID#" />
	</cfquery>
	
	
	<!--- <cfquery name="rs" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	Select * from tadcreatives where 
	creativeID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeID#" />
	</cfquery> --->
	
	<cfif rs.recordcount>
	<cfset creativeBean.set(rs) />
	</cfif>
	
	<cfreturn creativeBean />
</cffunction>

<cffunction name="update" returntype="void" access="public" output="false">
	<cfargument name="creativeBean" type="any" />
	 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadcreatives set
	userid = '#arguments.creativeBean.getuserID()#',
	lastupdate = <cfif isDate(arguments.creativeBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.creativeBean.getLastUpdate()#"><cfelse>null</cfif>,
	lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getName()#">,
	creativeType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getCreativeType() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getCreativeType()#">,
	fileID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getFileID() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getFileID()#">,
	mediaType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getMediaType() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getMediaType()#">,
	redirectURL = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getRedirectURL() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getRedirectURL()#">,
	AltText = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getAltText() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getAltText()#">,
	notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.creativeBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getNotes()#">,
	isActive = #arguments.creativeBean.getIsActive()#,
	height = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.creativeBean.getHeight()),de(arguments.creativeBean.getHeight()),de(0))#">,
	width = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(arguments.creativeBean.getWidth()),de(arguments.creativeBean.getWidth()),de(0))#">,
	textBody = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.creativeBean.getTextBody() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTextBody()#">,
	title = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getTitle() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTitle()#">,
	linkTitle = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getLinkTitle() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getLinkTitle()#">,
	target=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.creativeBean.getTarget() neq '',de('no'),de('yes'))#" value="#arguments.creativeBean.getTarget()#">

	where creativeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeBean.getCreativeID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="creativeID" type="String" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadcreatives 
	where creativeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.creativeID#" />
	</cfquery>

</cffunction>
</cfcomponent>