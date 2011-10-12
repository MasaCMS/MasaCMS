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

<cfsilent><cfparam name="attributes.siteID" default="">
<cfparam name="attributes.parentID" default="">
<cfparam name="attributes.nestLevel" default="1">
<cfparam name="request.catNo" default="0">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
</cfsilent>

<cfif rslist.recordcount>
<ul>
<cfoutput query="rslist">
<cfsilent>
<cfset request.catNo=request.catNo+1 />	
<cfquery name="rsIsMember" dbtype="query">
select * from request.rsCategoryAssign
where categoryID='#rslist.categoryID#' and ContentHistID='#request.contentBean.getcontentHistID()#'
</cfquery>
<cfset catTrim=replace(rslist.categoryID,'-','','ALL') />
<cfif not application.permUtility.getCategoryPerm(rslist.restrictGroups,attributes.siteid)>
<cfset disabled="disabled" />
<cfelse>
<cfset disabled="" />
</cfif>
</cfsilent>
<li><div <cfif request.catNo mod 2>class="alt"</cfif>>#rslist.name#<cfif rslist.isOpen eq 1>
<div class="column" <cfif request.catNo mod 2>class="alt"</cfif>>
<select class="displayOptions" class="categoryid" categoryid="#rslist.categoryID#" name="categoryAssign#catTrim#" #disabled#  onchange="javascript: this.selectedIndex==3?loadCategoryFeatureStartStop('editDates#catTrim#',true,'#attributes.siteID#'):loadCategoryFeatureStartStop('editDates#catTrim#',false,'#attributes.siteID#');checkExtendSetTargeting(this.value);">
<option <cfif not rsIsMember.recordcount>selected</cfif> value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
<option <cfif rsIsMember.recordcount and not rsIsMember.isFeature>selected</cfif> value="0">#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
<option value="1" <cfif rsIsMember.recordcount and rsIsMember.isFeature eq 1>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.feature')#</option>
<option value="2" <cfif rsIsMember.recordcount and rsIsMember.isFeature eq 2>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.scheduledfeature')#</option>
</select>
	  <dl id="editDates#catTrim#" <cfif not (rsIsMember.recordcount and rsIsMember.isFeature eq 2)>style="display: none;"</cfif>>
		<cfif rsIsMember.recordcount and rsIsMember.isFeature eq 2><dt class="start">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</dt>
		<dd class="start"><input type="text" name="featureStart#catTrim#" #disabled#  <cfif LSisDate(rsIsMember.featurestart)>value="#LSDateFormat(rsIsMember.featurestart,session.dateKeyFormat)#"<cfelse>value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdate')#" onclick="if(this.value=='Start Date'){this.value=''};"</cfif> class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" #disabled#  hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStart#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
		<select name="starthour#catTrim#" #disabled#  class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rsIsMember.featurestart)  and h eq 12 or (LSisDate(rsIsMember.featurestart) and (hour(rsIsMember.featurestart) eq h or (hour(rsIsMember.featurestart) - 12) eq h or hour(rsIsMember.featurestart) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
		<select name="startMinute#catTrim#" #disabled# class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rsIsMember.featurestart) and minute(rsIsMember.featurestart) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="startDayPart#catTrim#" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rsIsMember.featurestart) and hour(rsIsMember.featurestart) gte 12>selected</cfif>>PM</option></select>
		</dd>
		<dt class="stop">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</dt>
		<dd class="stop"><input type="text" name="featureStop#catTrim#" #disabled# <cfif LSisDate(rsIsMember.featurestop)>value="#LSDateFormat(rsIsMember.featurestop,session.dateKeyFormat)#"<cfelse>value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdate')#"  onclick="if(this.value=='Stop Date'){this.value=''};"</cfif> class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" #disabled#  hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStop#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
	<select name="stophour#catTrim#" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rsIsMember.featurestop)  and h eq 11 or (LSisDate(rsIsMember.featurestop) and (hour(rsIsMember.featurestop) eq h or (hour(rsIsMember.featurestop) - 12) eq h or hour(rsIsMember.featurestop) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
		<select name="stopMinute#catTrim#" #disabled#  class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rsIsMember.featurestop) and m eq 59) or (LSisDate(rsIsMember.featurestop) and minute(rsIsMember.featurestop) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="stopDayPart#catTrim#" #disabled# class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rsIsMember.featurestop) and (hour(rsIsMember.featurestop) gte 12)) or not LSisDate(rsIsMember.featurestop)>selected</cfif>>PM</option></select>
		</dd></cfif>
		</dl>
		</div>
</cfif></div>
<cfif rslist.hasKids>
<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="#rslist.categoryID#" nestLevel="#evaluate(attributes.nestLevel +1)#" >
</cfif>
</li>
</cfoutput>
</ul>
</cfif>