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
<cfhtmlhead text="#session.dateKey#">
<cfoutput>
<h2>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"advertising.editcampaignplacement"),request.campaignBean.getName())#</h2> 
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<li><a href="index.cfm?fuseaction=cAdvertising.editCampaign&&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#&campaignid=#URLEncodedFormat(attributes.campaignid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtocampaign')#</a></li>
<cfif attributes.placementid neq ""><li><a href="index.cfm?fuseaction=cAdvertising.viewReportByPlacement&placementid=#URLEncodedFormat(attributes.placementid)#&campaignid=#URLEncodedFormat(attributes.campaignid)#&userid=#URLEncodedFormat(attributes.userid)#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewplacementreport')#</a></li></cfif>
</ul> 
<p class="overview">#application.rbFactory.getKeyValue(session.rb,'advertising.campaigndaterange')#: #LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)# - #LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)#</p>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.placementinformation')#</h3>
#application.utility.displayErrors(request.placementBean.getErrors())#

<form novalidate="novalidate" action="index.cfm?fuseaction=cAdvertising.updatePlacement&siteid=#URLEncodedFormat(attributes.siteid)#&userid=#URLEncodedFormat(attributes.userid)#&campaignid=#URLEncodedFormat(attributes.campaignid)#" method="post" name="form1" onsubmit="return validate(this);">
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
<option value="#request.rsCreatives.creativeID#" <cfif request.rsCreatives.creativeID eq request.placementBean.getCreativeID()>selected</cfif>>#request.rsCreatives.name# (#application.rbFactory.getKeyValue(session.rb,'advertising.heightinitial')# #request.rsCreatives.height# X #application.rbFactory.getKeyValue(session.rb,'advertising.widthinitial')# #request.rsCreatives.width# - #application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#replace(request.rsCreatives.creativeType,' ','','all')#')#)</option>
</cfloop>
</select></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</dt>
<dd><input name="startDate" class="text datepicker" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.startdatevalidate')#" value="#iif(request.placementBean.getStartDate() eq '',de(LSDateFormat(request.campaignBean.getStartDate(),session.dateKeyFormat)),de(LSDateFormat(request.placementBean.getStartDate(),session.dateKeyFormat)))#">
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">---></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</dt>
<dd><input name="endDate" class="text datepicker" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.enddatevalidate')#" value="#iif(request.placementBean.getEndDate() eq '',de(LSDateFormat(request.campaignBean.getEndDate(),session.dateKeyFormat)),de(LSDateFormat(request.placementBean.getEndDate(),session.dateKeyFormat)))#">
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=endDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">---></dd>
<dd class="divide">
<script>
function checkAllHours() {
		 for(i=0;i<document.form1.hour.length;i++){document.form1.hour[i].checked=true;}
		}
		
function uncheckAllHours() {
		 for(i=0;i<document.form1.hour.length;i++){document.form1.hour[i].checked=false;}
		}
</script>
<table border="0" cellspacing="10" cellpadding="0">
<tr>
  <td><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.daysofweek')# </strong></td>
    <td colspan="4"><strong>#application.rbFactory.getKeyValue(session.rb,'advertising.hoursinday')#</strong> (<a href="javascript:void();" onclick="javascript:checkAllHours();return false;"> #application.rbFactory.getKeyValue(session.rb,'advertising.selectall')#</a> | <a href="javascript:void();" onclick="javascript:uncheckAllHours();return false;">#application.rbFactory.getKeyValue(session.rb,'advertising.removeall')#</a> )</td>
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
<cfif application.categoryManager.getCategoryCount(attributes.siteid)>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.categoryfilters')#</dt>
<dd class="categories">
<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" nestLevel="0" placementID="#attributes.placementID#">
<dd>

</cfif>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.costper1000impressions')#</dt>
<dd><input name="costPerM" class="text" required="true" validate="numeric" message="#application.rbFactory.getKeyValue(session.rb,'advertising.cpmvalidate')#" value="#request.placementBean.getCostPerM()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.costperclick')#</dt>
<dd><input name="costPerClick" class="text" required="true" validate="numeric" message="#application.rbFactory.getKeyValue(session.rb,'advertising.cpcvalidate')#" value="#request.placementBean.getCostPerClick()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#</dt>
<dd><input name="budget" class="text" required="true" validate="numeric" message="#application.rbFactory.getKeyValue(session.rb,'advertising.budgetvalidate')#" value="#request.placementBean.getBudget()#"></dd>
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
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.add')#" />
	<input type=hidden name="placementID" value="">
<cfelse>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteplacementconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" />
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.update')#" />
	<input type=hidden name="placementID" value="#request.placementBean.getplacementID()#"></cfif><input type="hidden" name="action" value=""></form>
</cfoutput>