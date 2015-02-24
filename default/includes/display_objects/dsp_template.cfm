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

<!---
<cfset request.muraAsyncEditableObject=true>
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<cfoutput>
		<div class="mura-async-object" 
			data-object="#esapiEncode('html_attr',arguments.object)#" 
			data-objectid="#esapiEncode('html_attr',arguments.objectid)#" 
			data-objectparams=#serializeJSON(objectParams)#>
		</div>
	</cfoutput>
<cfelse>
--->
	<cfsilent>
		<cfif isValid("UUID",arguments.objectID)>
			<cfset bean = variables.$.getBean("content").loadBy(contentID=arguments.objectID,siteID=arguments.siteID)>
		<cfelse>
			<cfset bean = variables.$.getBean("content").loadBy(title=arguments.objectID,siteID=arguments.siteID,type='Component')>
		</cfif>
		
		<cfset variables.rsTemplate=bean.getAllValues()>
		<cfset variables.event.setValue("component",variables.rsTemplate)>
		
		<cfset variables.rsTemplate.isOnDisplay=variables.rsTemplate.display eq 1 or 
				(
					variables.rsTemplate.display eq 2 and variables.rsTemplate.DisplayStart lte now()
					AND (variables.rsTemplate.DisplayStop gte now() or variables.rsTemplate.DisplayStop eq "")
				)
				and listFind(variables.rsTemplate.moduleAssign,'00000000000000000000000000000000000')>	
	</cfsilent>

	<cfif not bean.getIsNew()>
		<cfif variables.rsTemplate.isOnDisplay>
			<cfset variables.componentOutput=application.pluginManager.renderEvent("onComponent#bean.getSubType()#BodyRender",variables.event)>
			<cfif not len(variables.componentOutput)>
				<cfset variables.componentOutput=$.dspObject_include(theFile='extensions/dsp_Component_' & REReplace(bean.getSubType(), "[^a-zA-Z0-9_]", "", "ALL") & ".cfm",throwError=false)>
			</cfif>
			<cfif len(variables.componentOutput)>
				<cfoutput>#variables.componentOutput#</cfoutput>
			<cfelse>
				<cfif len(variables.rsTemplate.template) and fileExists("#getSite().getTemplateIncludeDir()#/components/#variables.rsTemplate.template#")>
					<cfset variables.componentBody=variables.rsTemplate.body>
					<cfinclude template="#getSite().getTemplateIncludePath()#/components/#variables.rsTemplate.template#">
				<cfelse>
					<cfoutput>#variables.$.setDynamicContent(variables.rsTemplate.body)#</cfoutput>
				</cfif>
			</cfif>
		</cfif>
		<cfif not variables.rsTemplate.doCache>
			<cfset request.cacheItem=variables.rsTemplate.doCache/>
		</cfif>
	<cfelse>
		<cfset request.muraValidObject=false>
	</cfif>
<!---</cfif>--->
