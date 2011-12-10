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
<cfsilent>
<cfscript>
	data=structNew();
	
	$=application.serviceFactory.getBean("MuraScope");
	
	session.flatViewArgs[rc.siteID].moduleid=$.event("moduleid");
	session.flatViewArgs[rc.siteID].sortBy=$.event("sortby");
	session.flatViewArgs[rc.siteID].sortDirection=$.event("sortdirection");
	session.flatViewArgs[rc.siteID].lockid=$.event("lockid");
	session.flatViewArgs[rc.siteID].assignments=$.event("assignments");
	session.flatViewArgs[rc.siteID].categoryid=$.event("categoryid");
	session.flatViewArgs[rc.siteID].tag=$.event("tag");
	session.flatViewArgs[rc.siteID].startrow=$.event("startrow");
	session.flatViewArgs[rc.siteID].type=$.event("type");
	session.flatViewArgs[rc.siteID].subtype=$.event("subtype");
	 
	feed=$.getBean("feed");
	feed.setMaxItems(500);
	feed.setNextN(20);
	feed.setLiveOnly(0);
	feed.setShowNavOnly(0);
	
	if(len($.event("tag"))){
		feed.addParam(field="tcontent.tags",criteria=$.event("tag"),condition="in");
	}
	
	if(len($.event("type"))){
		feed.addParam(field="tcontent.type",criteria=$.event("type"),condition="in");	
	}
	
	if(len($.event("subtype"))){
		feed.addParam(field="tcontent.subtype",value=$.event("subtype"));	
	}
	
	if(len($.event("categoryID"))){
		feed.setCategoryID($.event("categoryID"));	
	}
	
	if(len($.event("sortBy"))){
		feed.setSortBy($.event("sortBy"));	
	}
	
	if(len($.event("sortDirection"))){
		feed.setSortDirection($.event("sortDirection"));	
	}
	
	iterator=feed.getIterator();
</cfscript>
</cfsilent>
<cfsavecontent variable="data.html">
<cfoutput>
<div class="navSort">
	<h3>Sort by:</h3>
	<ul id="navTask">
		<!---<li><a href="" data-sortby="releasedate">Release Date</a></li>--->	
		<li><a href="" data-sortby="lastupdate"<cfif $.event("sortBy") eq "lastUpate"> class="active"</cfif>>Last Updated</a></li>
		<li><a href="" data-sortby="created"<cfif $.event("sortBy") eq "created"> class="active"</cfif>>Created</a></li>
		<!---<li><a href="" data-sortby="releasedate"<cfif $.event("sortBy") eq "releasedate"> class="active"</cfif>>Release Date</a></li>--->
		<li><a href="" data-sortby="menutitle"<cfif $.event("sortBy") eq "menutitle"> class="active"</cfif>>Title</a></li>
	</ul>
</div>
<table class="mura-table-grid stripe">
	<tr>
		<th></th>
	  	<th class="item">Item</th>
		<th nowrap class="administration">&nbsp;</th>
	</tr> 
 	<cfif iterator.hasNext()>
	<cfloop condition="iterator.hasNext()">
	<cfset item=iterator.next()>
	<tr>
		<td class="add"><a href="javascript:;" onmouseover="">&nbsp;</a></td>
		<td class="varWidth item">
		<h3 class="pdf"><a title="Edit" href="">#HTMLEditFormat(item.getMenuTitle())#</a></h3>
			<p class="locked-offline">The associated file is locked for offline editing by Exene Cervenka</p>
			
			<ul class="nodeMeta">
				<li class="thumbnail"><img src="http://3.bp.blogspot.com/_S-x1Z_8lDxM/Sw6aeMkGmII/AAAAAAAAAB4/gfigUEc-c6Q/s1600/gretsch_jim_1152x864.jpg" /></li>
				<li class="updated">Updated on 1/12/12 at 1:11 PM by John Doe</li>
				<li class="version">Version: <strong>1.2</strong></li>
				<li class="expiration">Expiration: <strong>1/6/12</strong></li>
				<li class="type">Type: <strong>File (Default)</strong></li>
				<li class="size">Size: <strong>800k</strong></li>
				<li class="categories">Categories: <strong>Lorem Ipsum, Lorem ipsum dolor sit amet</strong></dd>
				<li class="tags">Tags: <strong>Dolor, Sit, Amet</strong></li>
			</ul>
			
			<ul class="navZoom">	
				<li class="Page"><a href="">Home</a> &raquo;</li>
				<li class="Portal"><a href="0">Mura</a> &raquo;</li>
				<li class="Portal">
				<a href="">Portal Example</a> &raquo;</li>
				<li class="pdf"><strong><a href="">Eget Ultrices Velit Dui Sed</a></strong></li>
			</ul>
		</td> 
		<td class="administration">
			<ul class="four"><li class="edit"><a title="Edit" href="">Edit</a></li>
				<li class="preview"><a title="Preview" href="">Preview</a></li>
				<li class="download"><a title="Download" href="">Download</a></li>
				<li class="delete"><a title="Delete" href="">Delete</a></li>
			</ul>
		</td>
	</tr>
	</cfloop>
	<cfelse>
		<tr>
			<td colspan="3">Your search returned no results.</td>
		</tr>	
	</cfif>
	
	
</table>

<div class="sidebar">
	<p>
	<h3>Type</h3>
	<select name="contentTypeFilter" id="contentTypeFilter">
		<option value="">All</option>
		<cfloop list="#$.getBean('contentManager').TreeLevelList#" index="i">
		<option value="#i#"<cfif listfind($.event('type'),i)> selected</cfif>>#i#</option>
		</cfloop>
	</select>
	</p>
	<p>
	<h3>Tags</h3>
	<cfsilent>
		<cfset tags=$.getBean('contentGateway').getTagCloud($.event('siteID')) />
		<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
		<cfset max = ArrayMax(tagValueArray)>
		<cfset min = ArrayMin(tagValueArray)>
		<cfset diff = max - min>
		<cfset distribution = diff>
		<cfset rbFactory=$.siteConfig().getRBFactory()>
	</cfsilent>
	</p>	

	<div id="svTagCloud">
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
		</cfsilent><li class="#class#"><span><cfif tags.tagcount gt 1> #rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemsare'), args)#<cfelse>#rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemis'), args)#</cfif> tagged with </span><a class="tag<cfif listFind($.event('tag'),tags.tag)> active</cfif>">#HTMLEditFormat(tags.tag)#</a></li>
		</cfloop>
		</ol>
	<cfelse>
		<p>#$.rbKey('tagcloud.notags')#</p>
	</cfif>
	</div>

	<cfif $.getBean("categoryManager").getCategoryCount($.event("siteID"))>
	<h3>Categories</h3>
	<cf_dsp_categories_nest siteID="#$.event('siteID')#" parentID="" nestLevel="0" categoryid="#$.event('categoryid')#">
	</cfif>
	
	<input type="button" name="filterList" value="Filter" onclick="loadSiteFlatByFilter();"/>
</div>

</cfoutput>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
