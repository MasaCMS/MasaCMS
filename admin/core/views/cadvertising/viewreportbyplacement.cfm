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
<cfif not LSisDate(rc.date1)>
	<cfset rc.date1=rc.placementBean.getStartDate()/>
</cfif>
<cfif not LSisDate(rc.date2)>
	<cfset rc.date2=rc.placementBean.getEndDate()/>
</cfif>
</cfsilent>
<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacementreport')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacementinformation')#</h2>
<ul class="overview">
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.company')#:</strong> #rc.userBean.getcompany()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaign')#:</strong> #rc.campaignBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#:</strong> #LSDateFormat(rc.campaignBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(rc.campaignBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.creative')#:</strong> #rc.creativeBean.getName()# (#rc.creativeBean.getCreativeType()#)</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#:</strong> #rc.adZoneBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.placementdaterange')#:</strong> #LSDateFormat(rc.placementBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(rc.placementBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#:</strong> #LSDateFormat(rc.date1,session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(rc.date2,session.dateKeyFormat)#<br/>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdatetime')#:</strong> #LSDateFormat(now(),session.dateKeyFormat)# #LSTimeFormat(now(),"short")#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#:</strong> #LSCurrencyFormat(rc.placementBean.getBudget())#</li>
<!---<li><strong>Billable:</strong> #dollarFormat(rc.placementBean.getBillable())#</li>--->
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.costper1000impressions')#:</strong> #dollarFormat(rc.placementBean.getCostPerImp())#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.costperclick')#:</strong> #dollarFormat(rc.placementBean.getCostPerClick())#</li></ul>

<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#</h2>
<form novalidate="novalidate" action="index.cfm?muraAction=cAdvertising.viewReportByPlacement&campaignid=#rc.campaignid#&userid=#URLEncodedFormat(rc.userid)#&placementid=#rc.placementid#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" name="download" onsubmit="return validate(this);">
#application.rbFactory.getKeyValue(session.rb,'advertising.from')# <input type="text" class="text datepicker" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.fromvalidate')#" required="true" value="#LSDateFormat(rc.date1,session.dateKeyFormat)#"><input type="button" class="btn" onclick="document.download.submit();" value="#application.rbFactory.getKeyValue(session.rb,'advertising.view')#" />
</form>
</cfoutput>
<cfset m=0>

  <cfif request.rsdataImps.recordcount>
  
    <cfoutput query="request.rsdataImps" group="reportMonth">
  	<cfif request.rsdataImps.reportMonth neq m>
  	<cfset cTotalImps=0 />
	<cfset cTotalClicks=0 />
	<cfset cTotalImpsCost=0 />
	<cfset cTotalClicksCost=0 />
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.month')#</h2>

	<h3>#request.rsdataImps.reportMonth#/#request.rsdataImps.reportYear#</h3>
	 <table class="table table-striped table-condensed table-bordered mura-table-grid">
	 	<tr>
			  	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.hour')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'advertising.impressions')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.clicks')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
				 <th>#application.rbFactory.getKeyValue(session.rb,'advertising.clickratio')#</th>
			  </tr>
  	<cfset  m=request.rsdataImps.reportMonth>
  	</cfif>
  <cfoutput>
   <cfquery name="rsClicks" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
   select sum(counter) as Clicks from tadstats where 
   placementid='#rc.placementBean.getPlacementID()#'
   and type='Click'
   and stathour=#request.rsdataImps.stathour#
   and statdate >= #createodbcdatetime(createdatetime(year(rc.date1),month(rc.date1),day(rc.date1),0,0,0))#
   and statdate <= #createodbcdatetime(createdatetime(year(rc.date2),month(rc.date2),day(rc.date2),23,59,9))#
   </cfquery>
   <cfset clicks=iif(rsClicks.clicks neq '',de('#rsClicks.Clicks#'),de(0))>
   <cfset imps=request.rsdataImps.qty />
   <cfset cTotalImps=cTotalImps+imps />
   <cfset cTotalClicks=cTotalClicks+clicks />
   <cfset cTotalImpsCost=cTotalImpsCost+(imps*rc.placementBean.getcostPerImp()) />
   <cfset cTotalClicksCost=cTotalClicksCost+(clicks*rc.placementBean.getcostPerClick()) />
  <tr>
  	<td>#LSTimeFormat(createTime(request.rsdataImps.stathour,0,0),"short")#</td>
	<td>#imps#</td>
	<td>#LSCurrencyFormat(request.rsdataImps.qty*rc.placementBean.getCostPerImp())#</td>
    <td>#clicks#</td>
    <td>#LSCurrencyFormat(clicks*rc.placementBean.getCostPerClick())#</td>
  <td>#LSCurrencyFormat((request.rsdataImps.qty*rc.placementBean.getCostPerImp()) + (clicks*rc.placementBean.getCostPerClick()))#</td>
   <td>#evaluate(round((clicks/imps)*100))#%</td>
   </tr>
   </cfoutput>
  <tr>
  	<td align="center"><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.subtotal')#</strong></td>
	<td>#cTotalImps#</td>
	<td>#LSCurrencyFormat(cTotalImps*rc.placementBean.getCostPerImp())#</td>
    <td>#cTotalClicks#</td>
    <td>#LSCurrencyFormat(cTotalClicks*rc.placementBean.getCostPerClick())#</td>
     <td>#LSCurrencyFormat((cTotalImps*rc.placementBean.getCostPerImp()) + (cTotalClicks*rc.placementBean.getCostPerClick()))#</td></td>
	 <td>#evaluate(round((cTotalClicks/cTotalImps)*100))#%</td>
   <tr>
   </table>

   </cfoutput>
   <cfoutput>
   <cfsilent>
   <cfif request.rsTotalClicks.total eq ''>
   	<cfset fTotalClicks=0>
   <cfelse>
   	<cfset fTotalClicks=request.rsTotalClicks.total>
   </cfif>
   <cfif request.rsTotalImps.total eq ''>
   	<cfset fTotalImps=0>
   <cfelse>
   	<cfset fTotalImps=request.rsTotalImps.total>
   </cfif>
   </cfsilent>
	<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</h2>
	
	 <table border="0" cellpadding="3" cellspacing="0" id="metadata" class="table table-striped table-condensed table-bordered mura-table-grid">
			<tr>
			  	<th>&nbsp;</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'advertising.impressions')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.clicks')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
			    <th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
				 <th>#application.rbFactory.getKeyValue(session.rb,'advertising.clickratio')#</th>
			  </tr>
    <tr>
  	<td align="center"><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</strong></td>
	<td>#fTotalImps#</td>
	<td>#LSCurrencyFormat(fTotalImps*rc.placementBean.getCostPerImp())#</td>
    <td>#fTotalClicks#</td>
    <td>#LSCurrencyFormat(fTotalClicks*rc.placementBean.getCostPerClick())#</td>
     <td>#LSCurrencyFormat((fTotalImps*rc.placementBean.getCostPerImp()) + (fTotalClicks*rc.placementBean.getCostPerClick()))#</td></td>
  	  <td>#evaluate(round((fTotalClicks/fTotalImps)*100))#%</td>
   <tr>
   </table>
   
   
   </cfoutput>
   <cfelse>
   <p class="alert"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noplacementactivity')#</cfoutput></p class="alert"
   </cfif>
