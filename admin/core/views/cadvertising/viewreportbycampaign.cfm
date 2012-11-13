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
<cfif not lsisdate(rc.date1)>
	<cfset rc.date1=createDate(year(dateAdd("m", -1, now())),month(dateAdd("m", -1, now())),1)>
<cfelse>
	<cfset rc.date1=lsParseDateTime(rc.date1) />
</cfif>
<cfif not lsisdate(rc.date2)>
	<cfset rc.date2=createDate(year(now()),month(now()),1)>
<cfelse>
	<cfset rc.date2=lsParseDateTime(rc.date2) />
</cfif>
<cfif dateDiff("m", rc.date1, rc.date2) gt 12>
	<cfset rc.date2 = dateAdd("m", 12, rc.date1)>
</cfif>
<cfset theMonth=createDate(year(rc.date1),month(rc.date1),1) /></cfsilent>
<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignreport')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigninformation')#</h2>
<ul class="overview"><li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.company')#:</strong> #rc.userBean.getcompany()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaign')#:</strong> #rc.campaignBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#:</strong>  #LSDateFormat(rc.campaignBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(rc.campaignBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#:</strong> #LSDateFormat(rc.date1,session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(rc.date2,session.dateKeyFormat)#</li></ul>

<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#</h2>
<form novalidate="novalidate" action="index.cfm?muraAction=cAdvertising.viewReportByCampaign&campaignid=#rc.campaignid#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" name="download" onsubmit="return validate(this);">
#application.rbFactory.getKeyValue(session.rb,'advertising.from')# 
<input type="text" class="dateSelect datepicker" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.fromvalidate')#" required="true" value="#LSDateFormat(rc.date1,session.dateKeyFormat)#" > 
&nbsp;#application.rbFactory.getKeyValue(session.rb,'advertising.to')# 
<input type="text" class="dateSelect datepicker" name="date2" validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.tovalidate')#" required="true" value="#LSDateFormat(rc.date2,session.dateKeyFormat)#"> 
<input type="button" class="btn" onclick="document.download.submit();" value="#application.rbFactory.getKeyValue(session.rb,'advertising.view')#" />
</form>


	<cfset fTotalImps=0 />
	<cfset fTotalClicks=0 />
	<cfset fTotalImpsCost=0 />
	<cfset fTotalClicksCost=0 />
		
	<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.month')#</h2>
	</cfoutput>
<cfloop condition="#theMonth# lt #rc.date2#">
	<cfsilent>
		<!---<cfif theMonth gt createdate(2006,1,1)><cfdump var="#theMonth#"><cfabort></cfif>--->
		<cfset theMonthEnd=createDate(Year(theMonth),month(theMonth),daysInMonth(theMonth)) />
		<cfif theMonthEnd gt rc.date2>
			<cfset theMonthEnd=rc.date2>
		</cfif>
		<cfset theMonthBegin=theMonth />
		<cfif theMonthBegin lt rc.date1>
			<cfset theMonthBegin=rc.date1>
		</cfif>
		
		<cfset rsPlacements=application.advertiserManager.getPlacementsByCampaign(rc.campaignid,theMonthBegin,theMonthEnd) />
		<cfset cTotalImps=0 />
		<cfset cTotalClicks=0 />
		<cfset cTotalImpsCost=0 />
		<cfset cTotalClicksCost=0 />
		<cfset cTotalBudget=0 />
	</cfsilent>
	
	<cfoutput><h3>#month(theMonth)#/#year(theMonth)#</h3>
	<table class="table table-striped table-condensed table-bordered mura-table-grid">
	<tr>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.creative')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.exclusive')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalm')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpm')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalclicks')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpc')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
		<th class="actions">&nbsp;</th>
	</tr>
		</cfoutput>
		<cfoutput query="rsPlacements">
		 <cfsilent>
			  <cfquery name="rsClicks" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#rsPlacements.placementID#'
			   and type='Click'
			     <cfif LSisDate(theMonthBegin)>and statdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(theMonthBegin),month(theMonthBegin),day(theMonthBegin),0,0,0)#"></cfif>
				<cfif LSisDate(theMonthEnd)>and statdate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(theMonthEnd),month(theMonthEnd),day(theMonthEnd),23,59,9)#"></cfif>
	  		 </cfquery>
	  		 <cfquery name="rsImps" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#rsPlacements.placementID#'
			   and type='Impression'
			    <cfif LSisDate(theMonthBegin)>and statdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(theMonthBegin),month(theMonthBegin),day(theMonthBegin),0,0,0)#"></cfif>
				<cfif LSisDate(theMonthEnd)>and statdate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(theMonthEnd),month(theMonthEnd),day(theMonthEnd),23,59,9)#"></cfif>
	  		 </cfquery>
	  		 <cfset clicks=iif(rsClicks.total neq '',de('#rsClicks.total#'),de(0))>
	  		 <cfset imps=iif(rsImps.total neq '',de('#rsImps.total#'),de(0))>
			
		 	<cfset cTotalImps=cTotalImps+imps />
		 	<cfset cTotalClicks=cTotalClicks+clicks />
		 	<cfset cTotalImpsCost=cTotalImpsCost+(imps*rsPlacements.costPerImp) />
		 	<cfset cTotalClicksCost=cTotalClicksCost+(clicks*rsPlacements.costPerClick) />
		 	<cfset cTotalBudget=cTotalBudget+rsPlacements.budget />
	 	</cfsilent>
	
	<tr>
				<td class="var-width"><a href="index.cfm?muraAction=cAdvertising.editAdZone&siteid=#URLEncodedFormat(rc.siteid)#&adzoneid=#rsplacements.adzoneid#">#rsplacements.Adzone#</a></td>
				<td><a href="index.cfm?muraAction=cAdvertising.editCreative&userid=#URLEncodedFormat(rc.userid)#&creativeid=#rsplacements.creativeid#&siteid=#URLEncodedFormat(rc.siteid)#">#rsplacements.creative#</a></td>
				<td>#LSDateFormat(rsplacements.startdate,session.dateKeyFormat)#</td>
				<td>#LSDateFormat(rsplacements.enddate,session.dateKeyFormat)#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(rsplacements.isExclusive)#')#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(rsplacements.isactive)#')#</td>
				<td>#LSCurrencyFormat(rsplacements.budget)#</td>
				<td>#Imps#</td>
				<td>#LSCurrencyFormat(rsplacements.costPerImp*1000)#</td>
				<td>#LSCurrencyFormat(rsplacements.costPerImp*Imps)#</td>
				<td>#Clicks#</td>
				<td>#LSCurrencyFormat(rsplacements.costPerClick)#</td>
				<td>#LSCurrencyFormat(rsplacements.costPerClick*Clicks)#</td>
				<td>#LSCurrencyFormat((rsplacements.costPerClick*Clicks)+(rsplacements.costPerImp*Imps))#</td>
				<td class="actions"><ul>
				<li class="edit"><a title="Edit" href="index.cfm?muraAction=cAdvertising.editPlacement&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&campaignid=#rc.campaignID#&placementid=#rsplacements.placementid#"><i class="icon-pencil"></i></a></li>
				<li class="view-report"><a title="View Placement Report" href="index.cfm?muraAction=cAdvertising.viewReportByPlacement&placementid=#rsPlacements.placementid#&campaignid=#rc.campaignid#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&date1=#LSDateFormat(theMonthBegin,session.dateKeyFormat)#&date2=#LSDateFormat(theMonthEnd,session.dateKeyFormat)#"><i class="icon-bar-chart"></i></a></li></ul>
				</td>
				</tr>
		
	</cfoutput>
	<cfoutput>
	<tr>
				<td class="title" colspan="6" align="right">#application.rbFactory.getKeyValue(session.rb,'advertising.totals')#:</td>
				<td>#LSCurrencyFormat(cTotalBudget)#</td>
				<td>#cTotalImps#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalImpsCost)#</td>
				<td>#cTotalClicks#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalClicksCost)#</td>
				<td>#LSCurrencyFormat(cTotalImpsCost+cTotalClicksCost)#</td>
				<td class="actions"></td>
				</tr>
		</table><br />
			</cfoutput>
			<cfset theMonth=dateadd("m",1,theMonth) />
			<cfset fTotalImps=fTotalImps+cTotalImps />
		 	<cfset fTotalClicks=fTotalClicks+cTotalClicks />
		 	<cfset fTotalImpsCost=fTotalImpsCost+cTotalImpsCost />
		 	<cfset fTotalClicksCost=fTotalClicksCost+cTotalClicksCost />
		</cfloop>
<cfoutput>
	<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</h2>

	<table id="metadata" class="table table-striped table-condensed table-bordered mura-table-grid">
	<tr>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalm')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalclicks')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
		
	</tr>
		<tr>
				<td>#fTotalImps#</td>
				<td>#LSCurrencyFormat(fTotalImpsCost)#</td>
				<td>#fTotalClicks#</td>
				<td>#LSCurrencyFormat(fTotalClicksCost)#</td>
				<td>#LSCurrencyFormat(fTotalImpsCost+fTotalClicksCost)#</td>
		</tr>
		</table></cfoutput>