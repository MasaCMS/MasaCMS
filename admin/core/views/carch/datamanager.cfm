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
<cfinclude template="js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfparam name="session.datakeywords" default="">
<cfparam name="rc.keywords" default="">
<cfparam name="rc.filterBy" default="">
<cfparam name="session.filterBy" default="">

<cfif isDefined('rc.newSearch')>
<cfset session.filterBy=rc.filterBy />
<cfset session.datakeywords=rc.keywords />
</cfif>

<cfparam name="rc.sortBy" default="#rc.contentBean.getSortBy()#">
<cfparam name="rc.sortDirection" default="#rc.contentBean.getSortDirection()#">

<cfset rc.perm=application.permUtility.getnodePerm(rc.crumbdata)>

<cfif isDefined('rc.responseid') and rc.action eq 'Update'>
	<cfset application.dataCollectionManager.update(rc)/>
<cfelseif isDefined('rc.responseid') and rc.action eq 'Delete'>
	<cfset application.dataCollectionManager.delete('#rc.responseID#')/>
<cfelseif  rc.action eq 'setDisplay'>
	<cfset rc.contentBean.setResponseDisplayFields("#rc.detailList2#~#rc.summaryList2#")/>
	<cfset rc.contentBean.setNextN(rc.nextn)/>
	<cfset rc.contentBean.setSortBy(rc.sortBy)/>
	<cfset rc.contentBean.setSortDirection(rc.sortDirection)/>
	<cfset application.dataCollectionManager.setDisplay(rc.contentBean)/>
	<cfset rc.action=""/>
</cfif>
<cfset rc.rsDataInfo=application.contentManager.getDownloadselect(rc.contentid,rc.siteid) />
<cfset rc.fieldnames=application.dataCollectionManager.getCurrentFieldList(rc.contentid)/>>
</cfsilent>
<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<ul class="metadata"><li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#: <strong>#rc.contentBean.gettitle()#</strong></li>
<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.totalrecordsavailable')#: <strong>#rc.rsDataInfo.CountEntered#</strong></li>
</ul></cfoutput>

<cfif rc.action eq "edit">
<cfinclude template="data_manager/dsp_edit.cfm">
<cfelseif rc.action eq "display">
<cfinclude template="data_manager/dsp_display.cfm">
<cfelse>
<cfinclude template="data_manager/dsp_response.cfm">
</cfif>




