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

	<cfset CacheFN=application.configBean.getFileDir() & application.configBean.getFileDelim() & attributes.siteid & application.configBean.getFileDelim() & "cache" & application.configBean.getFileDelim() & "component" & application.configBean.getFileDelim() & hash(attributes.key) & ".cache">

	<cfif thisTag.executionMode IS "Start">
		<cfif fileExists(cacheFN)>
			<cfdirectory action="LIST"
				directory="#getDirectoryFromPath(cacheFN)#"
				filter="#getFileFromPath(cacheFN)#"
				name="qDate">
			<cfif val(qDate.dateLastModified+attributes.expiration) gt val(now()+0)>
				<cffile action="read" file="#cacheFN#" variable="foo">
				<cfoutput>#foo#</cfoutput>
				<cfsetting enableCFOutputOnly="No">
				<cfexit method="EXITTAG">
			<cfelse>
				<cffile action="DELETE" file="#cacheFN#">
			</cfif>
		</cfif>
	<cfelseif isBoolean(request.cacheItem) and request.cacheItem>
		<cffile action="Write" file="#cacheFN#" output="#thisTag.generatedContent#">
		<cfset request.cacheItem=true/>
	</cfif>
<cfelse>
	<cfif thisTag.executionMode IS "Start">
		<cfoutput>#thisTag.generatedContent#</cfoutput>
		<cfset request.cacheItem=true/>
	</cfif>
</cfif>







