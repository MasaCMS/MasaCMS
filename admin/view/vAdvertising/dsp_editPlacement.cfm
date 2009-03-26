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
<cfhtmlhead text="#session.dateKey#">
<cfoutput>
<h2>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"advertising.editcampaignplacement"),request.campaignBean.getName())#</h2> 
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#attributes.siteid#&userid=#attributes.userid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&&siteid=#attributes.siteid#&userid=#attributes.userid#&campaignid=#attributes.campaignid#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtocampaign')#</a></li>
<cfif attributes.placementid neq ""><li><a href="index.cfm?fuseaction=cAdvertising.viewReportByPlacement&placementid=#attributes.placementid#&campaignid=#attributes.campaignid#&userid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewplacementreport')#</a></li></cfif>
</ul> 
<p class="overview">#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#: #LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)# - #LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)#</p>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.placementinformation')#</h3>
#application.utility.displayErrors(request.placementBean.getErrors())#

<form action="index.cfm?fuseaction=cAdvertising.updatePlacement&siteid=#attributes.siteid#&userid=#attributes.userid#&campaignid=#attributes.campaignid#" method="post" name="form1" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')# (<em>#application.rbFactory.getKeyValue(session.rb,'advertising.dimensionscreativetype')#</em>)</dt>
<dd><select name="adZoneID">
<cfloop query="request.rsAdzones">
<option value="#request.rsAdzones.adZoneID#" <cfif request.rsAdzones.adZoneID eq request.placementBean.getAdZoneID()>selected</cfif>>#request.rsAdzones.name# (#application.rbFactory.getKeyValue(session.rb,'advertising.heightinitial')# #request.rsAdzones.height# X #application.rbFactory.getKeyValue(session.rb,'advertising.widthinitial')# #request.rsAdzones.width# - #application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#request.rsAdzones.creativeType#')#)</option>
</cfloop>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeasset')# (<em>#application.rbFactory.getKeyValue(session.rb,'advertising.dimensionscreativetype')#</em>)</dt>
<dd><select name="creativeID">
<cfloop query="request.rsCreatives">
<option value="#request.rsCreatives.creativeID#" <cfif request.rsCreatives.creativeID eq request.placementBean.getCreativeID()>selected</cfif>>#request.rsCreatives.name# (#application.rbFactory.getKeyValue(session.rb,'advertising.heightinitial')# #request.rsCreatives.height# X #application.rbFactory.getKeyValue(session.rb,'advertising.widthinitial')# #request.rsCreatives.width# - #application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#request.rsCreatives.creativeType#')#)</option>
</cfloop>
</select></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</dt>
<dd><input name="startDate" class="text" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.startdatevalidate')#" value="#iif(request.placementBean.getStartDate() eq '',de(LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)),de(LSDateFormat(request.placementBean.getStartDate(),session.dateKeyFormat)))#">
<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</dt>
<dd><input name="endDate" class="text" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.enddatevalidate')#" value="#iif(request.placementBean.getEndDate() eq '',de(LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)),de(LSDateFormat(request.placementBean.getEndDate(),session.dateKeyFormat)))#">
<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=endDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;"></dd>
<dd class="divide">
<table border="0" cellspacing="10" cellpadding="0">
<tr>
  <td><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.daysofweek')# </strong></td>
    <td colspan="4"><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.hoursinday')#</strong> (<a href="javascript:void();" onclick="javascript:for(i=0;i<document.form1.hour.length;i++){document.form1.hour[i].checked=true;}return false;"> #application.rbFactory.getKeyValue(session.rb,'advertising.selectall')#</a> | <a href="javascript:void();" onclick="javascript:for(i=0;i<document.form1.hour.length;i++){document.form1.hour[i].checked=false;}return false;">#application.rbFactory.getKeyValue(session.rb,'advertising.removeall')#</a> )</td>
</tr>
<tr>
<td valign="top" nowrap>
<cfloop from="1" to="7" index="wd">
<input name="weekday" id="day#wd#"type="checkbox" value="#wd#" <cfif listfind(request.placementBean.getweekday(),wd)>checked</cfif>> <label for="day#wd#">#dayOfWeekAsString(wd)#</label> <br/>
</cfloop>
</td>
<td valign="top" nowrap>
<cfloop from="0" to="6" index="h">
<input name="hour" id="hour#h#" type="checkbox" value="#h#" <cfif listfind(request.placementBean.gethour(),h)>checked</cfif>> <label for="hour#h#">#LSTimeFormat(createTime(h,0,0),"short")#</label><br/>
</cfloop>

<td valign="top" nowrap>
<cfloop from="7" to="13" index="h">
<input name="hour" id="hour#h#" type="checkbox" value="#h#" <cfif listfind(request.placementBean.gethour(),h)>checked</cfif>> <label for="hour#h#">#LSTimeFormat(createTime(h,0,0),"short")#</label><br/>
</cfloop>
</td>
<td valign="top" nowrap>
<cfloop from="14" to="20" index="h">
<input name="hour" id="hour#h#" type="checkbox" value="#h#" <cfif listfind(request.placementBean.gethour(),h)>checked</cfif>> <label for="hour#h#">#LSTimeFormat(createTime(h,0,0),"short")#</label><br/>
</cfloop>
</td>
<td valign="top" nowrap>
<cfloop from="21" to="23" index="h">
<input name="hour" id="hour#h#" type="checkbox" value="#h#" <cfif listfind(request.placementBean.gethour(),h)>checked</cfif>> <label for="hour#h#">#LSTimeFormat(createTime(h,0,0),"short")#</label><br/>
</cfloop>
</td>
</tr>
</table>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.costper1000impressions')#</dt>
<dd><input name="costPerM" class="text" required="true" validate="float" message="#application.rbFactory.getKeyValue(session.rb,'advertising.cpmvalidate')#" value="#request.placementBean.getCostPerM()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.costperclick')#</dt>
<dd><input name="costPerClick" class="text" required="true" validate="float" message="#application.rbFactory.getKeyValue(session.rb,'advertising.cpcvalidate')#" value="#request.placementBean.getCostPerClick()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#</dt>
<dd><input name="budget" class="text" required="true" validate="integer" message="#application.rbFactory.getKeyValue(session.rb,'advertising.budgetvalidate')#" value="#request.placementBean.getBudget()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.exclusive')#</dt>
<dd>
<input name="isExclusive" id="isExclusiveYes" type="radio" value="1" <cfif request.placementBean.getisExclusive()>checked</cfif>> <label for="isExclusiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label> 
<input name="isExclusive" id="isExclusiveNo" type="radio" value="0" <cfif not request.placementBean.getisExclusive()>checked</cfif>> <label for="isExclusiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label> 
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif request.placementBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label>
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not request.placementBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#request.placementBean.getNotes()#</textarea></dd>
</dl>
<cfif attributes.placementid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.add')#</span></a><input type=hidden name="placementID" value=""><cfelse> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteplacementconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#</span></a> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.update')#</span></a>
<input type=hidden name="placementID" value="#request.placementBean.getplacementID()#"></cfif><input type="hidden" name="action" value=""></form>
</cfoutput>