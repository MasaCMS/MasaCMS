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
	feed=$.getBean("feed");
	feed.setMaxItems(500);
	feed.setNextN(20);
	feed.setLiveOnly(0);
	
	if(len($.event("tag"))){
		feed.addParam(field="tcontent.tags",criteria=$.event("tag"));	
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
		<li><a href="">Release Date</a></li>
		<li><a href="">Title</a></li>
		<li><a href="">Last Updated</a></li>
		<li><a href="">Created</a></li>
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
		<p class="locked-offline">The associated file is locked for offline editing by Exene Cervenka</p>
			
			<h3><a title="Edit" href="">#HTMLEditFormat(item.getMenuTitle())#</a></h3>
			
			<dl>
				<dt class="updated">Updated on 1/12/12 at 1:11 PM by John Doe</dt>
				<dt class="version">Version:</dt><dd class="version">1.2</dd>
				<dt class="categories">Categories:</dt><dd class="categories">Lorem Ipsum</dd>
				<dt class="tags">Tags:</dt><dd class="tags">Dolor, Sit, Amet</dd>
				<dt class="type">Type:</dt><dd class="type">File (Default)</dd>
				<dt class="size">Size:</dt><dd class="size">800k</dd>
				<dt class="download">Download</dt>
				<dd class="preview"><img src="http://3.bp.blogspot.com/_S-x1Z_8lDxM/Sw6aeMkGmII/AAAAAAAAAB4/gfigUEc-c6Q/s1600/gretsch_jim_1152x864.jpg" /></dd>
			</dl>
			
			<ul class="navZoom">	
				<li class="Page"><a href="">Home</a> &raquo;</li>
				<li class="Portal"><a href="0">Mura</a> &raquo;</li>
				<li class="Portal">
				<a href="">Portal Example</a> &raquo;</li>
				<li class="Page"><strong><a href="">Eget Ultrices Velit Dui Sed</a></strong></li>
			</ul>
		</td> 
		<td class="administration">
			<ul class="four"><li class="edit"><a title="Edit" href="">Edit</a></li>
				<li class="preview"><a title="Preview" href="">Preview</a></li>
				<li class="download"><a title="Download" href="">Download</a></li>
				<li class="delete">Delete</li>
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
	
	<h3>Type</h3>
	<ul>
		<cfloop list="#$.getBean('contentManager').TreeLevelList#" index="i">
		<li><input type="checkbox" name="type" value="#i#"<cfif not len($.event('type')) or listfind($.event('type'),i)> checked</cfif>>#i#</li>
		</cfloop>
	</ul>
	
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
		</cfsilent><li class="#class#"><span><cfif tags.tagcount gt 1> #rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemsare'), args)#<cfelse>#rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemis'), args)#</cfif> tagged with </span><a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(tags.tag)#')#" class="tag">#tags.tag#</a></li>
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
	
	<input type="button" name="filterList" value="Filter"/>
</div>

</cfoutput>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>