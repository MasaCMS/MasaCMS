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
<cfhtmlhead text="#session.dateKey#">
<cfparam name="session.datakeywords" default="">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.filterBy" default="">
<cfparam name="session.filterBy" default="">

<cfif isDefined('attributes.newSearch')>
<cfset session.filterBy=attributes.filterBy />
<cfset session.datakeywords=attributes.keywords />
</cfif>

<cfparam name="attributes.sortBy" default="#request.contentBean.getSortBy()#">
<cfparam name="attributes.sortDirection" default="#request.contentBean.getSortDirection()#">

<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)>

<cfif isDefined('attributes.responseid') and attributes.action eq 'Update'>
	<cfset application.dataCollectionManager.update(attributes)/>
<cfelseif isDefined('attributes.responseid') and attributes.action eq 'Delete'>
	<cfset application.dataCollectionManager.delete('#attributes.responseID#')/>
<cfelseif  attributes.action eq 'setDisplay'>
	<cfset request.contentBean.setResponseDisplayFields(attributes.responseDisplayFields)/>
	<cfset request.contentBean.setNextN(attributes.nextn)/>
	<cfset request.contentBean.setSortBy(attributes.sortBy)/>
	<cfset request.contentBean.setSortDirection(attributes.sortDirection)/>
	<cfset application.dataCollectionManager.setDisplay(request.contentBean)/>
	<cfset attributes.action=""/>
</cfif>
<cfset request.rsDataInfo=application.contentManager.getDownloadselect(attributes.contentid,attributes.siteid) />
<cfset attributes.fieldnames=application.dataCollectionManager.getCurrentFieldList(attributes.contentid)/>>
</cfsilent>
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cArch.hist&contentid=#URLEncodedFormat(attributes.contentid)#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a> </li>
<cfif attributes.action neq ''>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedate')#" href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&type=Form&topid=00000000000000000000000000000000004&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
</cfif>
<cfif request.perm eq 'editor'>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.editdisplay')#" href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&type=Form&action=display&topid=00000000000000000000000000000000004&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.editdisplay')#</a></li>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?fuseaction=cArch.update&contentid=#URLEncodedFormat(attributes.contentid)#&type=Form&action=deleteall&topid=00000000000000000000000000000000004&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004" onClick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteformconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteform')#</a></li>
</cfif>
<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')><li><a href="index.cfm?fuseaction=cPerm.main&contentid=#URLEncodedFormat(attributes.contentid)#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=00000000000000000000000000000000004&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li></cfif>
</ul>

<ul class="overview"><li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#: <strong>#request.contentBean.gettitle()#</strong></li>
<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.totalrecordsavailable')#: <strong>#request.rsDataInfo.CountEntered#</strong></li>
</ul></cfoutput>

<cfif attributes.action eq "edit">
<cfinclude template="data_manager/dsp_edit.cfm">
<cfelseif attributes.action eq "display">
<cfinclude template="data_manager/dsp_display.cfm">
<cfelse>
<cfinclude template="data_manager/dsp_response.cfm">
</cfif>




