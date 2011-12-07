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
<cfset session.siteManagerTab=1>
<cfset data=structNew()>
</cfsilent>
<cfsavecontent variable="data.html">
<cfoutput>
<h3>Sort by:</h3>
<ul id="navTask" class="">

<li><a href="">Release Date</a></li>
<li><a href="">Title</a></li>
<li><a href="">Last Updated</a></li>
<li><a href="">Created</a></li>
	
</ul>
<table class="mura-table-grid stripe" style="width: 75%;  float: left;">
	<tr>
		<th></th>
	  	<th class="varWidth">Item</th>
		<!--<th>Updated</th> 
		<th>Updated by</th>
		<th>Categories</th>
		<th>Tags</th>-->
		<th nowrap class="administration">&nbsp;</th>
	</tr> 
 
	<tr>
		<td class="add">
		     
				<a href="javascript:;" onmouseover="showMenu('newContentMenu',1,this,'321C5464-0918-4F7B-90826F1A53E9F4A9','321C5464-0918-4F7B-90826F1A53E9F4A9','00000000000000000000000000000000001','dev','Page');">&nbsp;</a>
		</td>
		<td class="varWidth">
			<img src="http://3.bp.blogspot.com/_S-x1Z_8lDxM/Sw6aeMkGmII/AAAAAAAAAB4/gfigUEc-c6Q/s1600/gretsch_jim_1152x864.jpg" width="100" height="100">
			
			
			<p class="lockedOffline">Locked for offline editing by Exene Cervenka</p>
			<h3><a title="Edit" href="">Lorem ipsum dolor sit amet</a></h3>
			
			<ul class="navZoom">	
				<li class="Page"><a href="">Home</a> »</li>
				<li class="Portal"><a href="0">Mura</a> »</li>
				<li class="Portal">
				<a href="">Portal Example</a> »</li>
				<li class="Page"><strong><a href="">Eget Ultrices Velit Dui Sed</a></strong></li>
			</ul>
			
			<dl>
				<dt class="updated-on">Updated on 1/12/12 at 1:11 PM by John Doe</dt>
				<dt class="version">Version:</dt><dd class="version">1.2</dd>
				<dt class="categories">Categories:</dt><dd class="categories">Lorem Ipsum</dd>
				<dt class="tags">Tags:</dt><dd class="tags">Dolor, Sit, Amet</dd>
				<dt class="type">Type:</dt><dd class="type">File (Default)</dd>
				<dt class="size">Size:</dt><dd class="size">800k</dd>
				<dt class="download">Download</dt>
			</dl>
		</td>
		<td class="administration">
			<ul class="three"><li class="edit"><a title="Edit" href="">Edit</a></li>
				<li class="preview"><a title="Preview" href="">Home</a></li>
				<li class="deleteOff">Delete</li>
			</ul>
		</td>
	</tr>
	
	
</table>

<div class="sidebar" style="float: right; width: 20%;">
	
	<h3>Type</h3>
	<ul>
		<li>Page</li>
		<li>Portal</li>
		<li>Link</li>
		<li>File</li>
	</ul>
	
	<h3>Tags</h3>
	<ul>
	<li>Tag 1</li>
	<li>Tag 2</li>
	<li>Tag 3</li>
	</ul>
	
	<h3>Categories</h3>
	<ul>
	<li>Cat 1</li>
	<li>Cat 2</li>
	<li>Cat 3</li>
	</ul>
</div>

</cfoutput>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>