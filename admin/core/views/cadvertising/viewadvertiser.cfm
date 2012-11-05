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
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'advertising.advertisersummary')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<cfset rsAddress=rc.userBean.getAddresses()>
<ul class="metadata"><li><a href="index.cfm?muraAction=#iif(rc.userBean.getIsPublic(),de('cPublicUsers.editUser'),de('cPrivateUsers.editUser'))#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeid=adManager">#rc.userBean.getCompany()#</a></li>
  <li>#rc.userBean.getFname()# #rc.userBean.getLname()#</li>
  <li>#rsAddress.address1#</li>
  <cfif rsAddress.address2 neq ''><li>#rsAddress.address2#</li></cfif>
  <li>#rsAddress.city#<cfif rsAddress.city neq''>,</cfif> #rsAddress.state# #rsAddress.zip#</li>
  <li>#rsAddress.phone#</li>
</ul>

<section>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigns')#</h2>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cAdvertising.editCampaign&campaignid=&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcampaign')#</a>
</div>

<table class="table table-striped table-condensed table-bordered mura-table-grid">
<tr>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="actions">&nbsp;</th>
</tr></cfoutput>
<cfif rc.rsCampaigns.recordcount>
<cfoutput query="rc.rsCampaigns">
	<tr>
		<td class="var-width"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editCampaign&userid=#rc.rsCampaigns.userid#&siteid=#URLEncodedFormat(rc.siteid)#&campaignid=#rc.rsCampaigns.campaignID#">#rc.rsCampaigns.name#</a></td>
		<td>#LSDateFormat(rc.rsCampaigns.startdate,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(rc.rsCampaigns.enddate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(rc.rsCampaigns.isActive)#')#</td>
		<td class="actions"><ul>
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editCampaign&userid=#rc.rsCampaigns.userid#&siteid=#URLEncodedFormat(rc.siteid)#&campaignid=#rc.rsCampaigns.campaignID#"><i class="icon-pencil"></i></a></li>
		<li class="view-report"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.viewcmpaignreport')#" href="index.cfm?muraAction=cAdvertising.viewReportByCampaign&campaignid=#rc.rsCampaigns.campaignid#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-bar-chart"></i></a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?muraAction=cAdvertising.updateCampaign&action=delete&campaignid=#rc.rsCampaigns.campaignid#&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecampaignconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocampaigns')#</cfoutput></td>
	</tr>
</cfif>
</table>
</section>
<cfoutput>
<section>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.creatives')#</h2>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cAdvertising.editCreative&creativeid=&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcreative')#</a>
</div>

<table class="table table-striped table-condensed table-bordered mura-table-grid">
<tr>
	<th class="title">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.datecreated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.dateupdated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="actions">&nbsp;</th>
</tr></cfoutput>
<cfif rc.rsCreatives.recordcount>
<cfoutput query="rc.rsCreatives">
	<tr>
		<td class="var-width"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editCreative&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&creativeid=#rc.rsCreatives.creativeID#">#rc.rsCreatives.name#</a></td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#replace(rc.rsCreatives.creativeType,' ','','all')#')#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#rc.rsCreatives.mediatype#')#</td>
		<td>#rc.rsCreatives.height#</td>
		<td>#rc.rsCreatives.width#</td>
		<td>#LSDateFormat(rc.rsCreatives.dateCreated,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(rc.rsCreatives.lastUpdate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(rc.rsCreatives.isActive)#')#</td>
		<td class="actions"><ul>
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editCreative&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&creativeid=#rc.rsCreatives.creativeID#"><i class="icon-pencil"></i></a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?muraAction=cAdvertising.updateCreative&action=delete&creativeid=#rc.rsCreatives.creativeid#&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecreativeconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="9"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocreatives')#</cfoutput></td>
	</tr>
</cfif>
</table>
</section>