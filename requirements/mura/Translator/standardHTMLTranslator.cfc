<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="mura.cfobject" output="false">
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var page = "" />
	<cfset var themePath=event.getSite().getThemeAssetPath()  />
	<cfset var $=event.getValue("MuraScope")>
	<cfset var mura=event.getValue("MuraScope")>
	<cfset var renderer="">
	<cfset var siteRenderer=arguments.event.getContentRenderer()>
	<cfset var themeRenderer=arguments.event.getThemeRenderer()>
	<cfset var modal="">
	
	<cfif isObject(themeRenderer) and structKeyExists(themeRenderer,"renderHTMLHeadQueue")>
		<cfset renderer=themeRenderer>
	<cfelse>
		<cfset renderer=siteRenderer>
	</cfif>
	
	<cfset event.setValue('themePath',themePath)>
	
	<cfsavecontent variable="page">
		<cfif fileExists(expandPath("#$.siteConfig('templateIncludePath')#/#renderer.getTemplate()#") )>
		<cfinclude template="#event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#">
		<cfelse>
		<cfinclude template="#event.getSite().getTemplateIncludePath()#/default.cfm">
		</cfif>
	</cfsavecontent>
	
	<cfset page=replaceNoCase(page,"</head>", renderer.renderHTMLQueue("Head") & "</head>")>
	<cfset page=replaceNoCase(page,"</body>", renderer.renderHTMLQueue("Foot") & "</body>")>
	<cfset event.setValue('__MuraResponse__',trim(page))>
</cffunction>

</cfcomponent>