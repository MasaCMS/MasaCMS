<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<!--- Either the user provides a name or the tag 
uses the query string as the key --->

<cfparam name="Attributes.key" default="#CGI.script_name##CGI.query_string#">
<cfparam name="Attributes.expiration" default="#createTimeSpan(0,0,30,0)#">
<cfparam name="Attributes.scope" default="application">
<cfparam name="Attributes.nocache" default="0">
<cfparam name="Attributes.siteid" default="#request.siteid#">
<cfparam name="request.cacheItem" default="true">

<cfif NOT attributes.nocache and application.settingsManager.getSite(request.siteid).getCache()>
	<cfset cacheFactory=application.settingsManager.getSite(request.siteid).getCacheFactory()/>
	
	<cfif thisTag.executionMode IS "Start">
		<cfif cacheFactory.has( attributes.key )>
			<cfset content=cacheFactory.get( attributes.key )>
			<cfoutput>#content#</cfoutput>
			<cfsetting enableCFOutputOnly="No">
			<cfexit method="EXITTAG">	
		</cfif>
	<cfelseif isBoolean(request.cacheItem) and request.cacheItem>	
		<cfset cacheFactory.get( attributes.key ,thisTag.generatedContent)>
		<cfset request.cacheItem=true/>
	</cfif>
<cfelse>
	<cfif thisTag.executionMode IS "Start">
		<cfoutput>#thisTag.generatedContent#</cfoutput>
		<cfset request.cacheItem=true/>
	</cfif>
</cfif>







