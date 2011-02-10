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
<cfsilent>
<cfset tags=application.contentGateway.getTagCloud(request.siteID,arguments.parentID,arguments.categoryID,arguments.rsContent) />
<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
<cfset max = ArrayMax(tagValueArray)>
<cfset min = ArrayMin(tagValueArray)>
<cfset diff = max - min>
<cfset distribution = diff>
<cfset rbFactory=getSite().getRBFactory()>
</cfsilent>

<cfoutput>
<div id="svTagCloud">
<#getHeaderTag('subHead1')#>#rbFactory.getKey('tagcloud.tagcloud')#</#getHeaderTag('subHead1')#>
<cfif tags.recordcount>
<ol>
<cfloop query="tags"><cfsilent>
		<cfif tags.tagCount EQ min>
		<cfset class="not-popular">
	<cfelseif tags.tagCount EQ max>
		<cfset class="ultra-popular">
	<cfelseif tags.tagCount GT (min + (distribution/2))>
		<cfset class="somewhat-popular">
	<cfelseif tags.tagCount GT (min + distribution)>
		<cfset class="mediumTag">
	<cfelse>
		<cfset class="not-very-popular">
	</cfif>
	<cfset args = ArrayNew(1)>
     <cfset args[1] = tags.tagcount>
</cfsilent><li class="#class#"><span><cfif tags.tagcount gt 1> #rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('tagcloud.itemsare'), args)#<cfelse>#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('tagcloud.itemis'), args)#</cfif> tagged with </span><a href="?tag=#urlEncodedFormat(tags.tag)#&newSearch=true&display=search" class="tag">#tags.tag#</a></li>
</cfloop>
</ol>
<cfelse>
<p>#rbFactory.getKey('tagcloud.notags')#</p>
</cfif>
</div>
</cfoutput>