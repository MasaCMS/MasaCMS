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
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="0"/>
<cfparam name="request.pageNum" default="1"/>
<cfparam name="request.startRow" default="1"/>
<cfparam name="request.filterBy" default=""/>
<cfparam name="request.currentNextNID" default=""/>
<cfif variables.nextN.recordsPerPage gt 1>
<cfset variables.paginationKey="startRow">
<cfelse>
<cfset variables.paginationKey="pageNum">
</cfif>
<cfset variables.qrystr="" />

<cfif len(request.sortBy)>
	<cfset variables.qrystr="&sortBy=#request.sortBy#&sortDirection=#request.sortDirection#"/>
</cfif>
<cfif len(variables.$.event('categoryID'))>
	<cfset variables.qrystr=variables.qrystr & "&categoryID=#variables.$.event('categoryID')#"/>
</cfif>
<cfif len(request.relatedID)>
	<cfset variables.qrystr=variables.qrystr & "&relatedID=#request.relatedID#"/>
</cfif>
<cfif len(request.currentNextNID)>
	<cfset variables.qrystr=variables.qrystr & "&nextNID=#request.currentNextNID#"/>
</cfif>
<cfif len(request.filterBy)>
<cfif isNumeric(request.day) and request.day>
	<cfset variables.qrystr=variables.qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#&filterBy=#request.filterBy#">
</cfif>
<cfelse>
<cfif isNumeric(request.day) and request.day>
	<cfset variables.qrystr=variables.qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#">
</cfif>
</cfif>
</cfsilent>
<cfoutput>
	
	<div <cfif this.ulPaginationWrapperClass neq "">class="#this.ulPaginationWrapperClass#"</cfif>>
		<ul <cfif this.ulPaginationClass neq "">class="#this.ulPaginationClass#"</cfif>>
		<cfif variables.nextN.currentpagenumber gt 1>
		<cfif request.muraExportHtml>
			<cfif variables.nextN.currentpagenumber eq 2>
			<li class="navPrev"><a href="index.html">&laquo;&nbsp;#variables.$.rbKey('list.previous')#</a></li>
			<cfelse>
			<li class="navPrev"><a href="index#evaluate('#variables.nextn.currentpagenumber#-1')#.html">&laquo;&nbsp;#variables.$.rbKey('list.previous')#</a></li>
			</cfif>
		<cfelse>
			<li class="navPrev"><a href="#xmlFormat('?#paginationKey#=#variables.nextN.previous##variables.qrystr#')#">&laquo;&nbsp;#variables.$.rbKey('list.previous')#</a></li>
		</cfif>
		</cfif>
		<cfloop from="#variables.nextN.firstPage#"  to="#variables.nextN.lastPage#" index="i">
			<cfif variables.nextn.currentpagenumber eq i>
				<li class="#this.liCurrentClass#"><a class="#this.aCurrentClass#" href="##">#i#</a></li>
			<cfelse>
				<cfif request.muraExportHtml>
					<cfif i eq 1>
					<li><a href="index.html">#i#</a></li>
					<cfelse>
					<li><a href="index#i#.html">#i#</a></li>
					</cfif>
				<cfelse>
					<li><a href="#xmlFormat('?#paginationKey#=#evaluate('(#i#*#variables.nextN.recordsperpage#)-#variables.nextN.recordsperpage#+1')##variables.qrystr#')#">#i#</a></li>
				</cfif>
			</cfif>
		</cfloop>
		<cfif variables.nextN.currentpagenumber lt variables.nextN.NumberOfPages>
			<cfif request.muraExportHtml>
				<li class="navNext"><a href="index#evaluate('#variables.nextn.currentpagenumber#+1')#.html">#variables.$.rbKey('list.next')#&nbsp;&raquo;</a></li>
			<cfelse>
				<li class="navNext"><a href="#xmlFormat('?#paginationKey#=#variables.nextN.next##variables.qrystr#')#">#variables.$.rbKey('list.next')#&nbsp;&raquo;</a></li>
			</cfif>
		</cfif>
		</ul>
	</div>
</cfoutput>