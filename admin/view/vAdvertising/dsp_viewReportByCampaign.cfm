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
<cfif not lsisdate(attributes.date1)>
	<cfset attributes.date1=createDate(year(dateAdd("m", -1, now())),month(dateAdd("m", -1, now())),1)>
<cfelse>
	<cfset attributes.date1=lsParseDateTime(attributes.date1) />
</cfif>
<cfif not lsisdate(attributes.date2)>
	<cfset attributes.date2=createDate(year(now()),month(now()),1)>
<cfelse>
	<cfset attributes.date2=lsParseDateTime(attributes.date2) />
</cfif>
<cfif dateDiff("m", attributes.date1, attributes.date2) gt 12>
	<cfset attributes.date2 = dateAdd("m", 12, attributes.date1)>
</cfif>
<cfset theMonth=createDate(year(attributes.date1),month(attributes.date1),1) /></cfsilent>
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignreport')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#&campaignid=#attributes.campaignid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtocampaign')#</a></li>
</ul> 

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigninformation')#</h3>
<ul class="overview"><li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.company')#:</strong> #request.userBean.getcompany()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaign')#:</strong> #request.campaignBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#:</strong>  #LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#:</strong> #LSDateFormat(attributes.date1,session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(attributes.date2,session.dateKeyFormat)#</li></ul>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#</h3>
<form novalidate="novalidate" action="index.cfm?fuseaction=cAdvertising.viewReportByCampaign&campaignid=#attributes.campaignid#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="download" onsubmit="return validate(this);">
#application.rbFactory.getKeyValue(session.rb,'advertising.from')# <input type="text" class="dateSelect datepicker" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.fromvalidate')#" required="true" value="#LSDateFormat(attributes.date1,session.dateKeyFormat)#" > <!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=download&field=date1&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
&nbsp;#application.rbFactory.getKeyValue(session.rb,'advertising.to')# 
<input type="text" class="dateSelect datepicker" name="date2" validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.tovalidate')#" required="true" value="#LSDateFormat(attributes.date2,session.dateKeyFormat)#"><!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=download&field=date2&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">---> <input type="button" class="submit" onclick="document.download.submit();" value="#application.rbFactory.getKeyValue(session.rb,'advertising.view')#" /></form>


<!--- <cfif request.userBean.getaddress() neq ''><strong>Address:</strong> #request.userBean.getaddress()#<br/></cfif>
<cfif request.userBean.getcity() neq '' and request.userBean.getstate() neq '' and request.userBean.getzip() neq ''><strong>City/State/Zip:</strong> #request.userBean.getcity()#, #request.userBean.getstate()#  #request.userBean.getzip()#<br/></cfif>
<cfif request.userBean.getphone1() neq ''><strong>Phone:</strong> #request.userBean.getPhone1()#<br/></cfif>
<cfif request.userBean.getfax() neq ''><strong>Fax:</strong> #request.userBean.getfax()#<br/></cfif>
<cfif request.userBean.getfname() neq '' or request.userBean.getlname() neq ''><strong>Contact:</strong> #request.userBean.getfname()# #request.userBean.getlname()#<br/></cfif>
<cfif request.userBean.getemail() neq ''><strong>Email:</strong> <a href"mailto:#request.userBean.getemail()#">#request.userBean.getemail()#</a><br/></cfif> --->

	<cfset fTotalImps=0 />
	<cfset fTotalClicks=0 />
	<cfset fTotalImpsCost=0 />
	<cfset fTotalClicksCost=0 />
		
	<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.month')#</h3>
	</cfoutput>
<cfloop condition="#theMonth# lt #attributes.date2#">
	<cfsilent>
		<!---<cfif theMonth gt createdate(2006,1,1)><cfdump var="#theMonth#"><cfabort></cfif>--->
		<cfset theMonthEnd=createDate(Year(theMonth),month(theMonth),daysInMonth(theMonth)) />
		<cfif theMonthEnd gt attributes.date2>
			<cfset theMonthEnd=attributes.date2>
		</cfif>
		<cfset theMonthBegin=theMonth />
		<cfif theMonthBegin lt attributes.date1>
			<cfset theMonthBegin=attributes.date1>
		</cfif>
		
		<cfset rsPlacements=application.advertiserManager.getPlacementsByCampaign(attributes.campaignid,theMonthBegin,theMonthEnd) />
		<cfset cTotalImps=0 />
		<cfset cTotalClicks=0 />
		<cfset cTotalImpsCost=0 />
		<cfset cTotalClicksCost=0 />
		<cfset cTotalBudget=0 />
	</cfsilent>
	
	<cfoutput><h4>#month(theMonth)#/#year(theMonth)#</h4>
	<table class="mura-table-grid stripe">
	<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
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
		<th class="administration">&nbsp;</th>
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
				<td class="varWidth"><a href="index.cfm?fuseaction=cAdvertising.editAdZone&siteid=#URLEncodedFormat(attributes.siteid)#&adzoneid=#rsplacements.adzoneid#">#rsplacements.Adzone#</a></td>
				<td><a href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#URLEncodedFormat(attributes.userid)#&creativeid=#rsplacements.creativeid#&siteid=#URLEncodedFormat(attributes.siteid)#">#rsplacements.creative#</a></td>
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
				<td class="administration"><ul class="two">
				<li class="edit"><a title="Edit" href="index.cfm?fuseaction=cAdvertising.editPlacement&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&campaignid=#attributes.campaignID#&placementid=#rsplacements.placementid#">Edit</a></li>
				<li class="viewReport"><a title="View Placement Report" href="index.cfm?fuseaction=cAdvertising.viewReportByPlacement&placementid=#rsPlacements.placementid#&campaignid=#attributes.campaignid#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#&date1=#LSDateFormat(theMonthBegin,session.dateKeyFormat)#&date2=#LSDateFormat(theMonthEnd,session.dateKeyFormat)#">View Report</a></li></ul>
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
				<td class="administration"></td>
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
	<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</h3>

	<table id="metadata" class="mura-table-grid stripe">
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