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
<cfset request.layout=false>
<cfif not isNumeric(rc.categoryAssignment)>
	<cfset rc.categoryAssignment=0>
</cfif>
<cfoutput>
	<div class="categoryassignmentcontent<cfif rc.categoryAssignment eq '2'> scheduled</cfif>">
		<a class="dropdown-toggle mura-quickEditItem"<cfif rc.categoryAssignment eq '2'> rel="tooltip" title="#esapiEncode('html_attr',LSDateFormat(rc.featurestart,"short"))#&nbsp;-&nbsp;#LSDateFormat(rc.featurestop,"short")#"<cfelse>class="mura-quickEditItem"</cfif>>
			<cfswitch expression="#rc.categoryAssignment#">		
				<cfcase value="0">
					<i class="icon-ban-circle" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.no'))#"></i><span>#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.no'))#</span>
				</cfcase>
				<cfcase value="1">
					<i class="icon-ok" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.yes'))#"></i><span>#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.yes'))#</span>
				</cfcase>
				<cfcase value="2">
					<i class="icon-calendar" title="#esapiEncode('html_attr',LSDateFormat(rc.featurestart,"short"))#&nbsp;-&nbsp;#LSDateFormat(rc.featurestop,"short")#"></i> 
				</cfcase>
				<cfdefaultcase>
					<i class="icon-ban-circle" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.no'))#"></i><span>#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.no"))#</span>
				</cfdefaultcase>
			</cfswitch>
		</a>
		<input type="hidden" id="categoryAssign#rc.catTrim#" name="categoryAssign#rc.catTrim#" value="#esapiEncode('html_attr',rc.categoryAssignment)#"/>
		<cfif rc.categoryAssignment eq 2>
			<input type="hidden" id="featureStart#rc.catTrim#" name="featureStart#rc.catTrim#" value="#LSDateFormat(rc.featureStart,session.dateKeyFormat)#">
			<input type="hidden" id="startHour#rc.catTrim#" name="startHour#rc.catTrim#" value="#esapiEncode('html_attr',rc.startHour)#">
			<input type="hidden" id="startMinute#rc.catTrim#" name="startMinute#rc.catTrim#" value="#esapiEncode('html_attr',rc.startMinute)#">
			<input type="hidden" id="startDayPart#rc.catTrim#" name="startDayPart#rc.catTrim#" value="#esapiEncode('html_attr',rc.startDayPart)#">
			<input type="hidden" id="featureStop#rc.catTrim#" name="featureStop#rc.catTrim#" value="#LSDateFormat(rc.featureStop,session.dateKeyFormat)#">
			<input type="hidden" id="stopHour#rc.catTrim#" name="stopHour#rc.catTrim#" value="#esapiEncode('html_attr',rc.stopHour)#">
			<input type="hidden" id="stopMinute#rc.catTrim#" name="stopMinute#rc.catTrim#" value="#esapiEncode('html_attr',rc.stopMinute)#">
			<input type="hidden" id="stopDayPart#rc.catTrim#" name="stopDayPart#rc.catTrim#" value="#esapiEncode('html_attr',rc.stopDayPart)#">
		</cfif>
	</div>
</cfoutput>