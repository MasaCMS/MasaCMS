<!--- 
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
<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=1,siteid=userPoolID,activeOnly=true)>
<cfquery name="rsNonDefault" dbtype="query">
	SELECT * 
	FROM rsSubTypes 
	WHERE subType <> 'Default'
</cfquery>

<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())>

<!--- Header --->
	<cfoutput>
		<h1>#rc.$.rbKey('user.groupform')#</h1>

		<!--- Buttons --->
		<div id="nav-module-specific" class="btn-group">
			<!--- Back --->
			<a class="btn" href="##" title="#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#" onclick="window.history.back(); return false;">
				<i class="icon-circle-arrow-left"></i> 
				#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#
			</a>
			<!--- View All Groups --->
			<a class="btn" href="#buildURL(action='cusers.list')#">
				<i class="icon-eye-open"></i>
				#rc.$.rbKey('user.viewallgroups')#
			</a>
			<!--- Edit Group Settings --->
			<a class="btn" href="#buildURL(action='cusers.editgroup', querystring='userid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#')#">
				<i class="icon-pencil"></i>
				#rc.$.rbKey('user.editgroupsettings')#
			</a>
		</div>

		<h2>
			<strong>#rc.userBean.getgroupname()#</strong> #rc.$.rbKey('user.users')#
		</h2>
	</cfoutput>

<!--- Group Members --->
	<cfif rc.userid neq ''>
		<cfoutput> 
			<table class="mura-table-grid">
				<tr> 
					<th class="var-width">#rc.$.rbKey('user.name')#</th>
					<th>#rc.$.rbKey('user.email')#</th>
					<th>#rc.$.rbKey('user.update')#</th>
					<th>#rc.$.rbKey('user.time')#</th>
					<th>#rc.$.rbKey('user.authoreditor')#</th>
					<th>&nbsp;</th>
				</tr>
			</cfoutput>

			<cfif rc.rsgrouplist.recordcount>
				<cfoutput query="rc.rsgrouplist" maxrows="#rc.nextN.recordsperPage#" startrow="#rc.startrow#"> 
					<tr> 
						<td class="var-width">
							<a href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#">
								#rc.rsgrouplist.lname#, #rc.rsgrouplist.fname# 
								<cfif rc.rsgrouplist.company neq ''> (#rc.rsgrouplist.company#)</cfif>
							</a>
						</td>
						<td>
							<cfif rc.rsgrouplist.email gt "">
								<a href="mailto:#rc.rsgrouplist.email#">
									#rc.rsgrouplist.email#
								</a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>#LSDateFormat(rc.rsgrouplist.lastupdate,session.dateKeyFormat)#</td>
						<td>#LSTimeFormat(rc.rsgrouplist.lastupdate,"short")#</td>
						<td>#rc.rsgrouplist.LastUpdateBy#</td>

						<!--- Actions --->
						<td class="actions">
							<ul class="group">
								<li class="edit">
									<a href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" rel="tooltip" title="#rc.$.rbKey('user.edit')#">
										<i class="icon-pencil"></i>
									</a>
								</li>
								<li class="remove">
									<a href="./?muraAction=cUsers.removefromgroup&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;groupid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(rc.$.rbKey('user.removeconfirm'))#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.removeconfirm')#">
										<i class="icon-minus-sign"></i>
									</a>
								</li>
								<li class="delete">
									<a href="./?muraAction=cUsers.update&amp;action=delete&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;groupid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(rc.$.rbKey('user.deleteuserconfirm'))#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.delete')#">
										<i class="icon-remove-sign"></i>
									</a>
								</li>
							</ul>
						</td>
					</tr>
				</cfoutput> 
			<cfelse>
				<tr> 
					<td class="noResults" colspan="6">
						<cfoutput>#rc.$.rbKey('user.nogroupmembers')#</cfoutput>
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>
<!--- /Group Members --->

<!--- Pagination --->
	<cfif rc.nextN.numberofpages gt 1> 
		<cfoutput>
			<cfset args=arrayNew(1)>
			<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
			<cfset args[2]=rc.nextn.totalrecords>
			<div class="mura-results-wrapper">
				<p class="clearfix search-showing">
					#application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("sitemanager.paginationmeta"),args)#
				</p> 
				<div class="pagination">
					<ul>
						<cfif rc.nextN.currentpagenumber gt 1>
							<li>
					 			<a href="./?muraAction=cUsers.editgroup&amp;startrow=#rc.nextN.previous#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">&laquo;&nbsp;#rc.$.rbKey('user.prev')#</a>
					 		</li> 
						</cfif>
						<cfloop from="#rc.nextn.firstPage#"  to="#rc.nextN.lastPage#" index="i">
							<cfif rc.nextN.currentpagenumber eq i>
								<li class="active"><a href="##">#i#</a></li>
							<cfelse> 
								<li>
									<a href="./?muraAction=cUsers.editgroup&amp;startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">#i#</a> 
								</li>
							</cfif>
						</cfloop>
						<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
							<li>
								<a href="./?muraAction=cUsers.editgroup&amp;startrow=#rc.nextN.next#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">#rc.$.rbKey('user.next')#&nbsp;&raquo;</a>
							</li>
						</cfif>
					</ul>
				</div>
			</div>
		</cfoutput>
	</cfif>
<!--- /Pagination --->