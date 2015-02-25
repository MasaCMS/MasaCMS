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
<!---
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<cfoutput>
		<div class="mura-async-object" 
			data-object="#esapiEncode('html_attr',arguments.object)#" 
			data-objectid="#esapiEncode('html_attr',arguments.objectid)#" 
			data-objectparams=#serializeJSON(objectParams)#>
		</div>
	</cfoutput>
<cfelse>
--->
	<cfif not structIsEmpty(objectparams)>
		<cfif structKeyExists(objectparams,"displayRSS")>
			<cfset useRSS=objectparams.displayRSS>
		</cfif>
	</cfif>
	<cfparam name="useRss" default="false">
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="variables.rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#variables.$.event('siteID')#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
	<cfif rsSection.recordcount>
	<cfsilent>
	<cfif rsSection.type neq "Calendar">
	<cfset variables.today=now() />
	<cfelse>
	<cfset variables.today=createDate(variables.$.event('year'),variables.$.event('month'),1) />
	</cfif>
	<cfset variables.rs=variables.$.getBean('contentGateway').getKidsCategorySummary(variables.$.event('siteID'),arguments.objectid,variables.$.event('relatedID'),today,variables.rsSection.type)>

	<cfset variables.viewAllURL="#variables.$.siteConfig('context')##getURLStem(variables.$.event('siteID'),rsSection.filename)#">
	<cfif len(variables.$.event('relatedID'))>
		<cfset variables.viewAllURL=variables.viewAllURL & "?relatedID=#HTMLEditFormat(variables.$.event('relatedID'))#">
	</cfif>
	</cfsilent>
	<cfif variables.rs.recordcount>

	<cfoutput>
	<div class="svCatSummary mura-category-summary #this.navWrapperClass#">
	<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('list.categories')#</#variables.$.getHeaderTag('subHead1')#>
	<ul class="#this.ulTopClass#"><cfloop query="variables.rs">
		<cfsilent>
		<cfif len(variables.rs.filename)>
			<cfset variables.categoryURL="#variables.$.siteConfig('context')##getURLStem(variables.$.event('siteID'),variables.rsSection.filename & '/category/' & variables.rs.filename)#">
			<cfif len(variables.$.event('relatedID'))>
				<cfset variables.categoryURL=variables.categoryURL & "?relatedID=#HTMLEditFormat(variables.$.event('relatedID'))#">
			</cfif>
		<cfelse>
			<cfset categoryURL="#variables.$.siteConfig('context')##getURLStem(variables.$.event('siteID'),rsSection.filename)#?categoryID=#rs.categoryID#">
			<cfif len(variables.$.event('relatedID'))>
				<cfset categoryURL=categoryURL & "&relatedID=#HTMLEditFormat(variables.$.event('relatedID'))#">
			</cfif>
		</cfif>
		</cfsilent>
		<cfset class=iif(rs.currentrow eq 1,de('first'),de(''))>
			<li class="#class#<cfif listFind(variables.$.event('categoryID'),variables.rs.categoryID)> current</cfif>"><a href="#categoryURL#">#variables.rs.name# (#variables.rs.count#)</a><cfif useRss><a class="rss" href="#variables.$.globalConfig('context')#/tasks/feed/index.cfm?siteid=#variables.$.event('siteID')#&contentID=#variables.rsSection.contentid#&categoryID=#variables.rs.categoryID#" <cfif listFind(variables.$.event('categoryID'),variables.rs.categoryID)>class="current"</cfif>>RSS</a></cfif></li>
		</cfloop>
		<li class="last"><a href="#variables.viewAllURL#">View All</a><cfif useRss><a class="rss" href="#variables.$.globalConfig('context')#/tasks/feed/index.cfm?siteid=#variables.$.event('siteID')#&contentID=#variables.rsSection.contentid#">RSS</a></cfif></li>
	</ul>
	</div>
	</cfoutput>
	</cfif></cfif>
<!---</cfif>--->