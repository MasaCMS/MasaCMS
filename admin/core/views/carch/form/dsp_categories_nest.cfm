<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent>
	<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
	</cfscript>
	<cfparam name="attributes.siteID" default="" />
	<cfparam name="attributes.parentID" default="" />
	<cfparam name="attributes.nestLevel" default="1" />
	<cfparam name="attributes.disabled" default="false" />
	<cfparam name="request.catNo" default="0" />
	<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
</cfsilent>
<cfif rslist.recordcount>
	<ul class="categorylist"<cfif len(attributes.parentid)> style="display:none"<cfelse> id="mura-nodes"</cfif>>
		<cfoutput query="rslist">
			<cfsilent>
				<cfset catTrim=replace(rslist.categoryID,'-','','ALL') />
				<cfset request.catNo=request.catNo+1 />
				<cfif not len(attributes.contentBean.getValue('categoryAssign#catTrim#'))>
					<cfquery name="rsIsMember" dbtype="query">
					SELECT *
					FROM attributes.rsCategoryAssign
					WHERE categoryID='#rslist.categoryID#'
						AND ContentHistID='#attributes.contentBean.getcontentHistID()#'
					</cfquery>
				<cfelse>
					<cfset rsIsMember={
						recordcount=listFind(attributes.contentBean.getCategoryID(),rslist.categoryid),
						isFeature=attributes.contentBean.getValue('categoryAssign#catTrim#'),
						featureStart=attributes.contentBean.getValue('featureStart#catTrim#'),
						featureStop=attributes.contentBean.getValue('featureStop#catTrim#'),
						startHour=attributes.contentBean.getValue('startHour#catTrim#'),
						startMinute=attributes.contentBean.getValue('startMinute#catTrim#'),
						startDayPart=attributes.contentBean.getValue('startDayPart#catTrim#'),
						stopHour=attributes.contentBean.getValue('stopHour#catTrim#'),
						stopMinute=attributes.contentBean.getValue('stopMinute#catTrim#'),
						stopDayPart=attributes.contentBean.getValue('stopDayPart#catTrim#')
					}>
				</cfif>
				<cfparam name="request.opencategorylist" default="">

				<cfif rsIsMember.recordcount>
					<cfset request.opencategorylist=listAppend(request.opencategorylist,rslist.categoryid)>
				</cfif>

				<cfif not attributes.disabled and not application.permUtility.getCategoryPerm(rslist.restrictGroups,attributes.siteid)>
					<cfset attributes.disabled=true />
				</cfif>
			</cfsilent>
			<li data-siteID="#attributes.contentBean.getSiteID()#" data-categoryid="#rslist.categoryid#" data-cattrim="#catTrim#" data-disabled="#attributes.disabled#">
				<dl class="categoryitem">
					<!--- title --->
					<dt class="categorytitle">
						<span class="<cfif rslist.hasKids> hasChildren closed</cfif>"></span>
						<label>
							<cfif rslist.isOpen eq 1><input name="categoryid"<cfif attributes.disabled>
								disabled="true"
							</cfif> value="#rslist.categoryid#" type="checkbox" <cfif rsIsMember.recordcount>	checked="true"</cfif>/> </cfif>#esapiEncode('html',rslist.name)#</label>
							<cfif attributes.disabled>
								<input name="categoryid" value="#rslist.categoryid#" type="hidden" />
							</cfif>
					</dt>
					<!--- assignment --->
					<dd class="categoryassignmentwrapper">
						<cfif rslist.isOpen eq 1 and rslist.isFeatureable eq 1 or rslist.isFeatureable eq ''>
							<div id="categoryLabelContainer#cattrim#" class="categoryLabelContainer">
								<div class="categoryassignment<cfif rsIsMember.recordcount and rsIsMember.isFeature eq 2> scheduled</cfif>">
									<!--- Quick Edit --->
									<a class="dropdown-toggle<cfif not attributes.disabled> mura-quickEditItem</cfif>"<cfif rsIsMember.isFeature eq 2> rel="tooltip" title="#esapiEncode('html_attr',LSDateFormat(rsIsMember.featurestart,"short"))#&nbsp;-&nbsp;#LSDateFormat(rsIsMember.featurestop,"short")#"</cfif>>
										<cfswitch expression="#rsIsMember.isFeature#">
											<cfcase value="0">
											<i class="mi-ban" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#"></i>
												<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#</span>
											</cfcase>
											<cfcase value="1">
												<i class="mi-check" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#"></i>
												<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</span>
											</cfcase>
											<cfcase value="2">
												<i class="mi-calendar" title="#esapiEncode('html_attr',LSDateFormat(rsIsMember.featurestart,"short"))#&nbsp;-&nbsp;#LSDateFormat(rsIsMember.featurestop,"short")#"></i>
											</cfcase>
											<cfdefaultcase>
												<i class="mi-ban" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#"></i><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#</span>
											</cfdefaultcase>
										</cfswitch>
									</a><!--- /.mura-quickEditItem --->
									<cfif not rsIsMember.recordcount or not yesNoFormat(rsIsMember.isFeature)>
										<input type="hidden" id="categoryAssign#catTrim#" name="categoryAssign#catTrim#" value="0"/>
									<cfelseif rsIsMember.recordcount and rsIsMember.isFeature eq 1>
										<input type="hidden" id="categoryAssign#catTrim#" name="categoryAssign#catTrim#" value="1"/>
									<cfelseif rsIsMember.recordcount and rsIsMember.isFeature eq 2>
										<input type="hidden" id="categoryAssign#catTrim#" name="categoryAssign#catTrim#" value="2"/>
											<input type="hidden" id="featureStart#catTrim#" name="featureStart#catTrim#" value="#LSDateFormat(rsIsMember.featurestart,session.dateKeyFormat)#">
										<cfif isDate(rsIsMember.featurestart)>
											<cfif session.localeHasDayParts>
												<cfif hour(rsIsMember.featurestart) lt 12>
													<input type="hidden" id="startHour#catTrim#" name="startHour#catTrim#" value="#hour(rsIsMember.featurestart)#">
													<input type="hidden" id="startDayPart#catTrim#" name="startDayPart#catTrim#" value="AM">
												<cfelse>
													<input type="hidden" id="startHour#catTrim#" name="startHour#catTrim#" value="#val(hour(rsIsMember.featurestart)-12)#">
													<input type="hidden" id="startDayPart#catTrim#" name="startDayPart#catTrim#" value="PM">
												</cfif>
											<cfelse>
												<input type="hidden" id="startHour#catTrim#" name="startHour#catTrim#" value="#hour(rsIsMember.featurestart)#">
												<input type="hidden" id="startDayPart#catTrim#" name="startDayPart#catTrim#" value="">
											</cfif>
											<input type="hidden" id="startMinute#catTrim#" name="startMinute#catTrim#" value="#minute(rsIsMember.featurestart)#">
										<cfelse>
											<input type="hidden" id="startHour#catTrim#" name="startHour#catTrim#" value="">
											<input type="hidden" id="startMinute#catTrim#" name="startMinute#catTrim#" value="">
											<input type="hidden" id="startDayPart#catTrim#" name="startDayPart#catTrim#" value="">
										</cfif>
										<!--- feature stop --->
										<input type="hidden" id="featureStop#catTrim#" name="featureStop#catTrim#" value="#LSDateFormat(rsIsMember.featureStop,session.dateKeyFormat)#">
										<cfif isDate(rsIsMember.featureStop)>
											<cfif session.localeHasDayParts>
												<cfif hour(rsIsMember.featureStop) lt 12>
													<input type="hidden" id="stopHour#catTrim#" name="stopHour#catTrim#" value="#hour(rsIsMember.featureStop)#">
													<input type="hidden" id="stopDayPart#catTrim#" name="stopDayPart#catTrim#" value="AM">
												<cfelse>
													<input type="hidden" id="stopHour#catTrim#" name="stopHour#catTrim#" value="#val(hour(rsIsMember.featureStop)-12)#">
													<input type="hidden" id="stopDayPart#catTrim#" name="stopDayPart#catTrim#" value="PM">
												</cfif>
											<cfelse>
												<input type="hidden" id="stopHour#catTrim#" name="stopHour#catTrim#" value="#hour(rsIsMember.featureStop)#">
													<input type="hidden" id="stopDayPart#catTrim#" name="stopDayPart#catTrim#" value="">
											</cfif>
											<input type="hidden" id="stopMinute#catTrim#" name="stopMinute#catTrim#" value="#minute(rsIsMember.featureStop)#">
										<cfelse>
											<input type="hidden" id="stopHour#catTrim#" name="stopHour#catTrim#" value="">
											<input type="hidden" id="stopMinute#catTrim#" name="stopMinute#catTrim#" value="">
											<input type="hidden" id="stopDayPart#catTrim#" name="stopDayPart#catTrim#" value="">
										</cfif>
									</cfif>
								</div><!--- /.categoryassignmentcontent --->
							</div><!--- /.categoryLabelContainer --->

						<cfelse>
							<input type="hidden" id="categoryAssign#catTrim#" name="categoryAssign#catTrim#" value="0"/>
						</cfif>
					</dd><!--- /.categoryassignment --->
				</dl><!--- /dl --->
				<cfif rslist.hasKids>
					<cf_dsp_categories_nest
						siteID="#attributes.siteID#"
						parentID="#rslist.categoryID#"
						nestLevel="#val(attributes.nestLevel +1)#"
						contentBean="#attributes.contentBean#"
						rsCategoryAssign="#attributes.rsCategoryAssign#"
						disabled="#attributes.disabled#">
				</cfif>
			</li><!--- /.categoryitem --->
		</cfoutput>
	</ul><!--- /.categorylist --->
</cfif>
