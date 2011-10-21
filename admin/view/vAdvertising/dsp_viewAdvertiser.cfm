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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.advertisersummary')#</h2>

<cfset rsAddress=request.userBean.getAddresses()>
<ul class="overview"><li><a href="index.cfm?fuseaction=#iif(request.userBean.getIsPublic(),de('cPublicUsers.editUser'),de('cPrivateUsers.editUser'))#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&routeid=adManager">#request.userBean.getCompany()#</a></li>
  <li>#request.userBean.getFname()# #request.userBean.getLname()#</li>
  <li>#rsAddress.address1#</li>
  <cfif rsAddress.address2 neq ''><li>#rsAddress.address2#</li></cfif>
  <li>#rsAddress.city#<cfif rsAddress.city neq''>,</cfif> #rsAddress.state# #rsAddress.zip#</li>
  <li>#rsAddress.phone#</li>
</ul>


<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigns')#</h3>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&campaignid=&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcampaign')#</a></li>
</ul>

<table class="mura-table-grid stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rsCampaigns.recordcount>
<cfoutput query="request.rsCampaigns">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCampaign&userid=#request.rsCampaigns.userid#&siteid=#URLEncodedFormat(attributes.siteid)#&campaignid=#request.rsCampaigns.campaignID#">#request.rsCampaigns.name#</a></td>
		<td>#LSDateFormat(request.rsCampaigns.startdate,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rsCampaigns.enddate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(request.rsCampaigns.isActive)#')#</td>
		<td class="administration"><ul class="three">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCampaign&userid=#request.rsCampaigns.userid#&siteid=#URLEncodedFormat(attributes.siteid)#&campaignid=#request.rsCampaigns.campaignID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li>
		<li class="viewReport"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.viewcmpaignreport')#" href="index.cfm?fuseaction=cAdvertising.viewReportByCampaign&campaignid=#request.rsCampaigns.campaignid#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewreport')#</a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?fuseaction=cAdvertising.updateCampaign&action=delete&campaignid=#request.rsCampaigns.campaignid#&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecampaignconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocampaigns')#</cfoutput></td>
	</tr>
</cfif>
</table>
<cfoutput>
<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'advertising.creatives')#</h3>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.editCreative&creativeid=&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcreative')#</a></li>
</ul>

<table class="mura-table-grid stripe">
<tr>
	<th class="title">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.datecreated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.dateupdated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rsCreatives.recordcount>
<cfoutput query="request.rsCreatives">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&creativeid=#request.rsCreatives.creativeID#">#request.rsCreatives.name#</a></td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#replace(request.rsCreatives.creativeType,' ','','all')#')#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#request.rsCreatives.mediatype#')#</td>
		<td>#request.rsCreatives.height#</td>
		<td>#request.rsCreatives.width#</td>
		<td>#LSDateFormat(request.rsCreatives.dateCreated,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rsCreatives.lastUpdate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(request.rsCreatives.isActive)#')#</td>
		<td class="administration"><ul class="two">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&creativeid=#request.rsCreatives.creativeID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?fuseaction=cAdvertising.updateCreative&action=delete&creativeid=#request.rsCreatives.creativeid#&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecreativeconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="9"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocreatives')#</cfoutput></td>
	</tr>
</cfif>
</table>
