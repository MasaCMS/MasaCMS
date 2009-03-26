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
<cfsilent>
<cfset tags=application.contentGateway.getTagCloud(request.siteID,arguments.parentID,arguments.categoryID,arguments.rsContent) />
<cfset  tagValueArray = ListToArray(ValueList(tags.tagCount))>
<cfset  max = ArrayMax(tagValueArray)>
<cfset min = ArrayMin(tagValueArray)>
<cfset diff = max - min>
<cfset distribution = diff / >
<cfset rbFactory=getSite().getRBFactory()/>
</cfsilent>

<cfoutput>
<div id="svTagCloud">
<h3>#rbFactory.getKey('tagcloud.tagcloud')#</h3>
<cfif tags.recordcount>
<ol>
<cfloop query="tags"><cfsilent>
		<cfif tags.tagCount EQ min>
		<cfset class="not-popular">
	<cfelseif tags.tagCount EQ max>
		<cfset class="ultra-popular">
	<cfelseif tags.tagCount GT (min + (distribution*2))>
		<cfset class="somewhat-popular">
	<cfelseif tags.tagCount GT (min + distribution)>
		<cfset class="mediumTag">
	<cfelse>
		<cfset class="not-very-popular">
	</cfif>
</cfsilent><li class="#class#"><span>#tags.tagcount#<cfif tags.tagcount gt 1> items are <cfelse>item is </cfif> tagged with </span><a href="?tag=#urlEncodedFormat(tags.tag)#&newSearch=true&display=search" class="tag">#tag#</a></li>
</cfloop>
</ol>
<cfelse>
<p>#rbFactory.getKey('tagcloud.notags')#</p>
</cfif>
</div>
</cfoutput>