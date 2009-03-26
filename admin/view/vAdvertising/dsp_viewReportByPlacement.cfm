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

<cfsilent>
<cfhtmlhead text="#session.dateKey#">
<cfif not LSisDate(attributes.date1)>
	<cfset attributes.date1=request.placementBean.getStartDate()/>
</cfif>
<cfif not LSisDate(attributes.date2)>
	<cfset attributes.date2=request.placementBean.getEndDate()/>
</cfif>
</cfsilent>
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacementreport')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#attributes.siteid#&userid=#attributes.userid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&&siteid=#attributes.siteid#&userid=#attributes.userid#&campaignid=#attributes.campaignid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtocampaign')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.editPlacement&&siteid=#attributes.siteid#&userid=#attributes.userid#&campaignid=#attributes.campaignid#&placementid=#attributes.placementid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoplacement')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.viewReportByCampaign&campaignid=#attributes.campaignid#&siteid=#attributes.siteid#&userid=#attributes.userid#&date1=#LSDateFormat(attributes.date1,session.dateKeyFormat)#&date2=#LSDateFormat(attributes.date2,session.dateKeyFormat)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewcampaignreport')#</a></li>
</ul>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacementinformation')#</h3>
<ul class="overview">
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.company')#:</strong> #request.userBean.getcompany()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaign')#:</strong> #request.campaignBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#:</strong> #LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.creative')#:</strong> #request.creativeBean.getName()# (#request.creativeBean.getCreativeType()#)</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#:</strong> #request.adZoneBean.getName()#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.placementdaterange')#:</strong> #LSDateFormat(request.placementBean.getStartDate(),session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(request.placementBean.getEndDate(),session.dateKeyFormat)#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#:</strong> #LSDateFormat(attributes.date1,session.dateKeyFormat)#&nbsp;-&nbsp;#LSDateFormat(attributes.date2,session.dateKeyFormat)#<br/>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdatetime')#:</strong> #LSDateFormat(now(),session.dateKeyFormat)# #LSTimeFormat(now(),"short")#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#:</strong> #LSCurrencyFormat(request.placementBean.getBudget())#</li>
<!---<li><strong>Billable:</strong> #dollarFormat(request.placementBean.getBillable())#</li>--->
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.costper1000impressions')#:</strong> #dollarFormat(request.placementBean.getCostPerImp())#</li>
<li><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.costperclick')#:</strong> #dollarFormat(request.placementBean.getCostPerClick())#</li></ul>
<!--- <cfif request.userBean.getaddress() neq ''><strong>Address:</strong> #request.userBean.getaddress()#<br/></cfif>
<cfif request.userBean.getcity() neq '' and request.userBean.getstate() neq '' and request.userBean.getzip() neq ''><strong>City/State/Zip:</strong> #request.userBean.getcity()#, #request.userBean.getstate()#  #request.userBean.getzip()#<br/></cfif>
<cfif request.userBean.getphone1() neq ''><strong>Phone:</strong> #request.userBean.getPhone1()#<br/></cfif>
<cfif request.userBean.getfax() neq ''><strong>Fax:</strong> #request.userBean.getfax()#<br/></cfif>
<cfif request.userBean.getfname() neq '' or request.userBean.getlname() neq ''><strong>Contact:</strong> #request.userBean.getfname()# #request.userBean.getlname()#<br/></cfif>
<cfif request.userBean.getemail() neq ''><strong>Email:</strong> <a href"mailto:#request.userBean.getemail()#">#request.userBean.getemail()#</a><br/></cfif> --->

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.reportdaterange')#</h3>
<form action="index.cfm?fuseaction=cAdvertising.viewReportByPlacement&campaignid=#attributes.campaignid#&userid=#attributes.userid#&placementid=#attributes.placementid#&siteid=#attributes.siteid#" method="post" name="download" onsubmit="return validate(this);">
#application.rbFactory.getKeyValue(session.rb,'advertising.from')# <input type="text" class="text" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.fromvalidate')#" required="true" value="#LSDateFormat(attributes.date1,session.dateKeyFormat)#"><input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=download&field=date1&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;"> &nbsp;#application.rbFactory.getKeyValue(session.rb,'advertising.to')# <input type="text" class="text" name="date2" validate="date" message="#application.rbFactory.getKeyValue(session.rb,'advertising.tovalidate')#" required="true" value="#LSDateFormat(attributes.date2,session.dateKeyFormat)#"><input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=download&field=date2&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;"><a class="submit" href="javascript:document.download.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.view')#</span></a>
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
<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.month')#</h3>

	<h4>#request.rsdataImps.reportMonth#/#request.rsdataImps.reportYear#</h4>
	 <table class="stripe">
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
   placementid='#request.placementBean.getPlacementID()#'
   and type='Click'
   and stathour=#request.rsdataImps.stathour#
   and statdate >= #createodbcdatetime(createdatetime(year(attributes.date1),month(attributes.date1),day(attributes.date1),0,0,0))#
   and statdate <= #createodbcdatetime(createdatetime(year(attributes.date2),month(attributes.date2),day(attributes.date2),23,59,9))#
   </cfquery>
   <cfset clicks=iif(rsClicks.clicks neq '',de('#rsClicks.Clicks#'),de(0))>
   <cfset imps=request.rsdataImps.qty />
   <cfset cTotalImps=cTotalImps+imps />
   <cfset cTotalClicks=cTotalClicks+clicks />
   <cfset cTotalImpsCost=cTotalImpsCost+(imps*request.placementBean.getcostPerImp()) />
   <cfset cTotalClicksCost=cTotalClicksCost+(clicks*request.placementBean.getcostPerClick()) />
  <tr>
  	<td>#LSTimeFormat(createTime(request.rsdataImps.stathour,0,0),"short")#</td>
	<td>#imps#</td>
	<td>#LSCurrencyFormat(request.rsdataImps.qty*request.placementBean.getCostPerImp())#</td>
    <td>#clicks#</td>
    <td>#LSCurrencyFormat(clicks*request.placementBean.getCostPerClick())#</td>
  <td>#LSCurrencyFormat((request.rsdataImps.qty*request.placementBean.getCostPerImp()) + (clicks*request.placementBean.getCostPerClick()))#</td>
   <td>#evaluate(round((clicks/imps)*100))#%</td>
   </tr>
   </cfoutput>
  <tr>
  	<td align="center"><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.subtotal')#</strong></td>
	<td>#cTotalImps#</td>
	<td>#LSCurrencyFormat(cTotalImps*request.placementBean.getCostPerImp())#</td>
    <td>#cTotalClicks#</td>
    <td>#LSCurrencyFormat(cTotalClicks*request.placementBean.getCostPerClick())#</td>
     <td>#LSCurrencyFormat((cTotalImps*request.placementBean.getCostPerImp()) + (cTotalClicks*request.placementBean.getCostPerClick()))#</td></td>
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
	<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</h3>
	
	 <table border="0" cellpadding="3" cellspacing="0" id="metadata" class="stripe">
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
	<td>#LSCurrencyFormat(fTotalImps*request.placementBean.getCostPerImp())#</td>
    <td>#fTotalClicks#</td>
    <td>#LSCurrencyFormat(fTotalClicks*request.placementBean.getCostPerClick())#</td>
     <td>#LSCurrencyFormat((fTotalImps*request.placementBean.getCostPerImp()) + (fTotalClicks*request.placementBean.getCostPerClick()))#</td></td>
  	  <td>#evaluate(round((fTotalClicks/fTotalImps)*100))#%</td>
   <tr>
   </table>
   
   
   </cfoutput>
   <cfelse>
    <p><em><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noplacementactivity')#</cfoutput></em></p>
   </cfif>
