<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfhtmlhead text="#session.dateKey#">
<cfoutput>
<h2>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"advertising.editcampaign"),request.userBean.getCompany())#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<cfif attributes.campaignid neq ""><li><a href="index.cfm?fuseaction=cAdvertising.viewReportByCampaign&campaignid=#URLEncodedFormat(attributes.campaignid)#&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewcampaignreport')#</a></li></cfif>
</ul>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigninformation')#</h3>
#application.utility.displayErrors(request.campaignBean.getErrors())#
<form action="index.cfm?fuseaction=cAdvertising.updateCampaign&siteid=#URLEncodedFormat(attributes.siteid)#" name="form1"  method="post" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</dt>
<dd><input name="name" class="text" required="true" message="The 'Name' field is required." value="#HTMLEditFormat(request.campaignBean.getName())#" maxlength="50"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</dt>
<dd><input name="startDate" class="text" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.startdatevalidate')#" value="#LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)#">
<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</dt>
<dd><input name="endDate" class="text" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.enddatevalidate')#" value="#LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)#">
<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=endDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;" ></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif request.campaignBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label> 
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not request.campaignBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#HTMLEditFormat(request.campaignBean.getNotes())#</textarea></dd>
</dl>
<cfif attributes.campaignid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.add')#</span></a><input type=hidden name="campaignID" value=""><cfelse><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecampaignconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#</span></a><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.update')#</span></a><input type=hidden name="campaignID" value="#request.campaignBean.getCampaignID()#"></cfif>
<input type="hidden" name="action" value="">
<input type="hidden" name="userID" value="#HTMLEditFormat(attributes.userid)#">
</form>
</cfoutput>
<cfif attributes.campaignid neq ''>

	<cfoutput>
	<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacements')#</h3>
	<ul id="navTask">
	<li><a href="index.cfm?fuseaction=cAdvertising.editPlacement&campaignid=#URLEncodedFormat(attributes.campaignid)#&placementid=&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addplacement')#</a></li>
	</ul>
	
	<table class="stripe">
	<tr>
		<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeasset')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.exclusive')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalimpressions')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpm')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalclicks')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpc')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
		<th class="administration">&nbsp;</th>
	</tr></cfoutput>
	<cfif request.rsPlacements.recordcount>
		<cfsilent>
			<cfset cTotalImps=0 />
			<cfset cTotalClicks=0 />
			<cfset cTotalImpsCost=0 />
			<cfset cTotalClicksCost=0 />
			<cfset cTotalBudget=0 />
		</cfsilent>
		<cfoutput query="request.rsPlacements">
		 <cfsilent>
			  <cfquery name="rsClicks" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#request.rsPlacements.placementID#'
			   and type='Click'
	  		 </cfquery>
	  		 <cfquery name="rsImps" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#request.rsPlacements.placementID#'
			   and type='Impression'
	  		 </cfquery>
	  		 <cfset clicks=iif(rsClicks.total neq '',de('#rsClicks.total#'),de(0))>
	  		 <cfset imps=iif(rsImps.total neq '',de('#rsImps.total#'),de(0))>
			
		 	<cfset cTotalImps=cTotalImps+imps />
		 	<cfset cTotalClicks=cTotalClicks+clicks />
		 	<cfset cTotalImpsCost=cTotalImpsCost+(imps*request.rsPlacements.costPerImp) />
		 	<cfset cTotalClicksCost=cTotalClicksCost+(clicks*request.rsPlacements.costPerClick) />
	 		<cfset cTotalBudget=cTotalBudget+request.rsPlacements.budget />
	 	</cfsilent>
			<tr>
				<td class="varWidth"><a href="index.cfm?fuseaction=cAdvertising.editAdZone&siteid=#URLEncodedFormat(attributes.siteid)#&adzoneid=#request.rsplacements.adzoneid#">#request.rsPlacements.Adzone#</a></td>
				<td><a href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#URLEncodedFormat(attributes.userid)#&creativeid=#request.rsplacements.creativeid#&siteid=#URLEncodedFormat(attributes.siteid)#">#request.rsPlacements.creative#</a></td>
				<td>#LSDateFormat(request.rsPlacements.startdate,session.dateKeyFormat)#</td>
				<td>#LSDateFormat(request.rsPlacements.enddate,session.dateKeyFormat)#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(request.rsPlacements.isExclusive)#')#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(request.rsPlacements.isActive)#')#</td>
				<td>#LSCurrencyFormat(request.rsPlacements.budget)#</td>
				<td>#Imps#</td>
				<td>#LSCurrencyFormat(request.rsPlacements.costPerImp*1000)#</td>
				<td>#LSCurrencyFormat(request.rsPlacements.costPerImp*Imps)#</td>
				<td>#Clicks#</td>
				<td>#LSCurrencyFormat(request.rsPlacements.costPerClick)#</td>
				<td>#LSCurrencyFormat(request.rsPlacements.costPerClick*Clicks)#</td>
				<td>#LSCurrencyFormat((request.rsPlacements.costPerClick*Clicks)+(request.rsPlacements.costPerImp*Imps))#</td>
				<td class="administration"><ul class="three">
				<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cAdvertising.editPlacement&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&campaignid=#attributes.campaignID#&placementid=#request.rsplacements.placementid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li>
				<li class="viewReport"><a title="#application.rbFactory.getKeyValue(session.rb,'user.viewplacmentreport')#" href="index.cfm?fuseaction=cAdvertising.viewReportByPlacement&placementid=#request.rsPlacements.placementid#&campaignid=#attributes.campaignid#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.viewplacementrepor')#</a></li>
				<li class="delete"><a title="#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.delete'))#" href="index.cfm?fuseaction=cAdvertising.updatePlacement&action=delete&campaignid=#attributes.campaignid#&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#&placementid=#request.rsplacements.placementid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteplacementconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li></ul>
				</td></tr>
		</cfoutput>
		<cfoutput>
		<tr>
				<td nowrap class="varWidth" align="right" colspan="6">#application.rbFactory.getKeyValue(session.rb,'advertising.totals')#:</td>
				<td>#LSCurrencyFormat(cTotalBudget)#</td>
				<td>#cTotalImps#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalImpsCost)#</td>
				<td>#cTotalClicks#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalClicksCost)#</td>
				<td>#LSCurrencyFormat(cTotalImpsCost+cTotalClicksCost)#</td>
				<td></td>
				</tr>
		</table>
		</cfoutput>
	<cfelse>
		<tr>
			<td nowrap class="varWidth" colspan="15"><em><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocampaignplacements')#</cfoutput></em></td>
		</tr>
		</table>
	</cfif>
</cfif>