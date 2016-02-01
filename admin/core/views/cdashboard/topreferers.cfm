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
<cfinclude template="js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfset rsList=application.dashboardManager.getTopReferers(rc.siteID,rc.limit,rc.startDate,rc.stopDate) />
<cfset rsTotal=application.dashboardManager.getTotalReferers(rc.siteID,rc.startDate,rc.stopDate) />
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.topreferers")#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<h3>#application.rbFactory.getKeyValue(session.rb,"params.daterange")#</h3>
<form novalidate="novalidate" name="searchFrm" onsubmit="return validate(this);" id="advancedSearch" class="fieldset-wrap">

<div class="fieldset">
	<div class="control-group">
	<div class="span2">
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,"params.from")#
	</label>
	      <div class="controls">
			<input type="text" class="datepicker span12" name="startDate" value="#LSDateFormat(rc.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
	     </div>
	 </div>
	
	<div class="span2">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,"params.to")#
		</label>
	      <div class="controls">
			<input type="text" class="datepicker span12" name="stopDate" value="#LSDateFormat(rc.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
	     </div>
	 </div>
	
	<div class="span2">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,"params.numberofitems")#
		</label>
	      <div class="controls"><select name="limit" class="span6">
			<cfloop list="10,20,30,40,50,75,100" index="i">
			<option value="#i#" <cfif rc.limit eq i>selected</cfif>>#i#</option>
			</cfloop>
		</select>
	    </div>
	</div>
	</div>
</div>
<div class="form-actions">
	<input type="button" class="btn" onclick="submitForm(document.forms.searchFrm);" value="#application.rbFactory.getKeyValue(session.rb,"params.search")#" /></dd>
</div>

<input type="hidden" value="#esapiEncode('html_attr',rc.siteid)#" name="siteID"/>
<input type="hidden" value="cDashboard.topReferers" name="muraAction"/>
</form>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalreferrals")#: <strong>#rstotal.referals#</strong></h3>
<table class="mura-table-grid">
<tr>
<th class="var-width">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.referer")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.count")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.percent")#</th>
</tr>
<cfif rslist.recordcount>
<cfloop query="rslist">
<tr>
<td class="var-width"><cfif rslist.referer neq 'Unknown'><a href="#rsList.referer#" target="_blank">#esapiEncode('html',left(rslist.referer,120))#</a><cfelse>#esapiEncode('html',rslist.referer)#</cfif></td>
<td>#rsList.referals#</td>
<td>#decimalFormat((rsList.referals/rstotal.referals)*100)#%</td>
</tr>
</cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="3">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
</tr>
</cfif>
</table>
</cfoutput>



