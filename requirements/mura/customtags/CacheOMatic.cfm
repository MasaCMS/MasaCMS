<!--- 
  This file is part of Mura CMS.

  Mura CMS is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, Version 2 of the License.

  Mura CMS is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms and      
  conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant you permission
  to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
  to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
  through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
  provided that these modules (a) may only modify the  /plugins/ directory through the Mura CMS
  plugin installation API, (b) must not alter any default objects in the Mura CMS database
  and (c) must not alter any files in the following directories except in cases where the code contains
  a separately distributed license.

  /admin/
  /tasks/
  /config/
  /requirements/mura/

  You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
  the source code of that other code when and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
  for your modified version; it is your choice whether to do so, or to make such modified version available under
  the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
  to your own modified versions of Mura CMS.
--->

<!--- Either the user provides a name or the tag
uses the query string as the key --->
<cfparam name="request.siteID" default="default">
<cfparam name="request.purgeCache" default="false">
<cfparam name="attributes.key" default="#CGI.script_name##CGI.query_string#">
<cfparam name="attributes.timespan" default="#createTimeSpan(0,0,30,0)#">
<cfparam name="attributes.scope" default="application">
<cfparam name="attributes.nocache" default="0">
<cfparam name="attributes.purgeCache" default="#request.purgeCache#">
<cfparam name="attributes.siteid" default="#request.siteid#">
<cfparam name="attributes.cacheFactory" default="#application.settingsManager.getSite(attributes.siteid).getCacheFactory(name='output')#">
<cfparam name="request.forceCache" default="false">
<cfparam name="request.cacheItem" default="true">
<cfparam name="request.cacheItemTimeSpan" default="">

<cfset variables.tempKey=attributes.key & request.muraOutputCacheOffset>

<cfif not isBoolean(request.cacheItem)>
  <cfset request.cacheItem=true/>
</cfif>

<cfif not isBoolean(attributes.nocache)>
  <cfset attributes.nocache=false/>
</cfif>

<cfif not isBoolean(request.forceCache)>
  <cfset request.forceCache=false/>
</cfif>

<cfif not isBoolean(attributes.purgeCache)>
  <cfset attributes.purgeCache = false />
</cfif> 

<cfif attributes.purgeCache and attributes.cacheFactory.has(variables.tempKey)>
  <cfset attributes.cacheFactory.purge(variables.tempKey) />
</cfif>

<cfif thisTag.executionMode IS "Start">
  <cfset request.cacheItem=true/>
   <cfset request.cacheItemTimeSpan="">
</cfif>

<cfif request.cacheItem and NOT attributes.nocache AND (application.settingsManager.getSite(attributes.siteid).getCache()  OR request.forceCache IS true)>
  <cfset cacheFactory=attributes.cacheFactory/>
       
  <cfif thisTag.executionMode IS "Start">

    <cfif cacheFactory.has( variables.tempKey )>
      <cftry>
        <cfset content=cacheFactory.get( variables.tempKey )>
        <cfoutput>#content#</cfoutput>
        <cfsetting enableCFOutputOnly="No">
        <cfexit method="EXITTAG">   
        <cfcatch></cfcatch>
      </cftry>
    </cfif>
  <cfelse>
   <cfif isDate(request.cacheItemTimeSpan)>
      <cfset cacheFactory.set( key=variables.tempKey, context=thisTag.generatedContent, obj=thisTag.generatedContent, timespan=request.cacheItemTimeSpan)>
   <cfelse>
      <cfset cacheFactory.set( key=variables.tempKey, context=thisTag.generatedContent, obj=thisTag.generatedContent, timespan=attributes.timespan)>
   </cfif>
  </cfif>
</cfif>