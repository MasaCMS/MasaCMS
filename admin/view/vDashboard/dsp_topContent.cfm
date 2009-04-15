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
<cfset rsList=application.dashboardManager.getTopContent(attributes.siteID,attributes.limit,attributes.membersOnly,attributes.visitorStatus,attributes.startDate,attributes.stopDate) />
<cfset rsTotal=application.dashboardManager.getTotalHits(attributes.siteID,attributes.membersOnly,attributes.visitorStatus,attributes.startDate,attributes.stopDate) />
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.topviewedcontent")#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"params.daterange")#</h3>
<form name="searchFrm" onsubmit="return validate(this);" id="advancedSearch">
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.from")#</dt>
<dd>
<input type="input" name="startDate" value="#LSDateFormat(attributes.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.to")#</dt>
<dd>
<input type="input" name="stopDate" value="#LSDateFormat(attributes.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=stopDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.numberofitems")#</dt>
<dd><select name="limit">
		<cfloop list="10,20,30,40,50,75,100" index="i">
		<option value="#i#" <cfif attributes.limit eq i>selected</cfif>>#i#</option>
		</cfloop>
	</select>
</dd>
<dd><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.searchFrm);"><span>#application.rbFactory.getKeyValue(session.rb,"params.search")#</span></a></dd>
</dl>
<input type="hidden" value="#attributes.siteID#" name="siteID"/>
<input type="hidden" value="cDashboard.topContent" name="fuseaction"/>
</form>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalviews")#: <strong>#rstotal.hits#</strong></h3>
<table class="stripe">
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.content")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.percent")#</th>
<th>&nbsp;</th>
</tr>
<cfif rslist.recordcount>
<cfloop query="rslist">
<cfsilent>
<cfset crumbdata=application.contentManager.getCrumbList(rsList.contentid, attributes.siteid)/>
</cfsilent>
<tr>
<td class="varWidth">#application.contentRenderer.dspZoom(crumbdata,rslist.fileEXT)#</td>
<td>#rsList.hits#</td>
<td>#decimalFormat((rsList.hits/rstotal.hits)*100)#%</td>
<td class="administration">
<ul class="one">
		<cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		</cfswitch>	
		</ul></td>
</tr>
</cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="4">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
</tr>
</cfif>
</table>
</cfoutput>


