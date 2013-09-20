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
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var page = "" />
	<cfset var themePath=arguments.event.getSite().getThemeAssetPath()  />
	<cfset var $=arguments.event.getValue("MuraScope")>
	<cfset var mura=arguments.event.getValue("MuraScope")>
	<cfset var renderer="">
	<cfset var siteRenderer=arguments.event.getContentRenderer()>
	<cfset var themeRenderer=arguments.event.getThemeRenderer()>
	<cfset var modal="">
	<cfset var tracePoint=0>
	<cfset var inheritedObjectsPerm="">
	<cfset var inheritedObjectsContentID="">
	
	<cfif not isNumeric(arguments.event.getValue('startRow'))>
		<cfset arguments.event.setValue('startRow',1)>
	</cfif>
	<cfif not isNumeric(arguments.event.getValue('pageNum'))>
		<cfset arguments.event.setValue('pageNum',1)>
	</cfif>
	
	<cfif session.mura.isLoggedIn and siteRenderer.showEditableObjects>
		<cfset inheritedObjectsContentID=$.getBean("contentGateway").getContentIDFromContentHistID(contentHistID=$.event('inheritedObjects') )>
		<cfif len(inheritedObjectsContentID)>
			<cfset inheritedObjectsPerm=$.getBean('permUtility').getNodePerm($.getBean('contentGateway').getCrumblist(inheritedObjectsContentID,$.event('siteID')))>
		<cfelse>
			<cfset inheritedObjectsPerm="none">
		</cfif>
		<cfset $.event("inheritedObjectsPerm",inheritedObjectsPerm)>
	</cfif>
	
	<cfif isObject(themeRenderer) and structKeyExists(themeRenderer,"renderHTMLHeadQueue")>
		<cfset renderer=themeRenderer>
	<cfelse>
		<cfset renderer=siteRenderer>
	</cfif>
	
	<cfset arguments.event.setValue('themePath',themePath)>
	
	<cfsavecontent variable="page">
		<cfif fileExists(expandPath("#$.siteConfig('templateIncludePath')#/#renderer.getTemplate()#") )>
		<cfset tracePoint=initTracePoint("#arguments.event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#")>
		<cfinclude template="#arguments.event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#">
		<cfset commitTracePoint(tracePoint)>
		<cfelse>
		<cfset tracePoint=initTracePoint("#arguments.event.getSite().getTemplateIncludePath()#/default.cfm")>
		<cfinclude template="#arguments.event.getSite().getTemplateIncludePath()#/default.cfm">
		<cfset commitTracePoint(tracePoint)>
		</cfif>
	</cfsavecontent>
	
	<cfset page=replaceNoCase(page,"</head>", renderer.renderHTMLQueue("Head") & "</head>")>
	<cfset page=replaceNoCase(page,"</body>", renderer.renderHTMLQueue("Foot") & "</body>")>
	<cfset arguments.event.setValue('__MuraResponse__',trim(page))>
</cffunction>

</cfcomponent>