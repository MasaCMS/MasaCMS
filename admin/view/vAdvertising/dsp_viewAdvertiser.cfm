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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.advertisersummary')#</h2>

<cfset rsAddress=request.userBean.getAddresses()>
<ul class="overview"><li><a href="index.cfm?fuseaction=#iif(request.userBean.getIsPublic(),de('cPublicUsers.editUser'),de('cPrivateUsers.editUser'))#&userid=#attributes.userid#&siteid=#attributes.siteid#&routeid=adManager">#request.userBean.getCompany()#</a></li>
  <li>#request.userBean.getFname()# #request.userBean.getLname()#</li>
  <li>#rsAddress.address1#</li>
  <cfif rsAddress.address2 neq ''><li>#rsAddress.address2#</li></cfif>
  <li>#rsAddress.city#<cfif rsAddress.city neq''>,</cfif> #rsAddress.state# #rsAddress.zip#</li>
  <li>#rsAddress.phone#</li>
</ul>


<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigns')#</h3>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&campaignid=&siteid=#attributes.siteid#&userid=#attributes.userid#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcampaign')#</a></li>
</ul>

<table class="stripe">
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
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCampaign&userid=#request.rsCampaigns.userid#&siteid=#attributes.siteid#&campaignid=#request.rsCampaigns.campaignID#">#request.rsCampaigns.name#</a></td>
		<td>#LSDateFormat(request.rsCampaigns.startdate,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rsCampaigns.enddate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(request.rsCampaigns.isActive)#')#</td>
		<td class="administration"><ul class="three">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCampaign&userid=#request.rsCampaigns.userid#&siteid=#attributes.siteid#&campaignid=#request.rsCampaigns.campaignID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li>
		<li class="viewReport"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.viewcmpaignreport')#" href="index.cfm?fuseaction=cAdvertising.viewReportByCampaign&campaignid=#request.rsCampaigns.campaignid#&userid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewreport')#</a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?fuseaction=cAdvertising.updateCampaign&action=delete&campaignid=#request.rsCampaigns.campaignid#&siteid=#attributes.siteid#&userid=#attributes.userid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecampaignconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
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
<li><a href="index.cfm?fuseaction=cAdvertising.editCreative&creativeid=&siteid=#attributes.siteid#&userid=#attributes.userid#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewcreative')#</a></li>
</ul>

<table class="stripe">
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
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#attributes.userid#&siteid=#attributes.siteid#&creativeid=#request.rsCreatives.creativeID#">#request.rsCreatives.name#</a></td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#request.rsCreatives.creativeType#')#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#request.rsCreatives.mediatype#')#</td>
		<td>#request.rsCreatives.height#</td>
		<td>#request.rsCreatives.width#</td>
		<td>#LSDateFormat(request.rsCreatives.dateCreated,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rsCreatives.lastUpdate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(request.rsCreatives.isActive)#')#</td>
		<td class="administration"><ul class="two">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#attributes.userid#&siteid=#attributes.siteid#&creativeid=#request.rsCreatives.creativeID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" href="index.cfm?fuseaction=cAdvertising.updateCreative&action=delete&creativeid=#request.rsCreatives.creativeid#&siteid=#attributes.siteid#&userid=#attributes.userid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecreativeconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="9"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocreatives')#</cfoutput></td>
	</tr>
</cfif>
</table>
