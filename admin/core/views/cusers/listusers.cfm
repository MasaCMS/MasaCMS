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
<cfoutput>

	<!--- Header --->
	<cfinclude template="dsp_users_header.cfm" />

	<!--- TAB NAV --->
	<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>

		<h2>#rc.$.rbKey('user.users')#</h2>

		<ul class="nav nav-tabs">
			<li<cfif rc.ispublic eq 1> class="active"</cfif>>
				<a href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=1&unassigned=#rc.unassigned#')#">
					#rc.$.rbKey('user.sitemembers')#
				</a>
			</li>
			<li<cfif rc.ispublic eq 0> class="active"</cfif>>
				<a href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=0&unassigned=#rc.unassigned#')#">
					#rc.$.rbKey('user.systemusers')#
				</a>
			</li>
		</ul>
	<cfelse>
		<h2>#rc.$.rbKey('user.sitemembers')#</h2>
	</cfif>

	<!--- FILTERS --->
		<div class="well btn-group">
			<a class="btn" href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=#rc.ispublic#&unassigned=#rc.unassignedlink#')#">
				<i class="icon-filter"></i> 
				<cfif rc.unassigned EQ 0>
					#rc.$.rbKey('user.viewunassignedonly')#
				<cfelse>
					#rc.$.rbKey('user.viewall')#
				</cfif>
			</a>

			<a class="btn" href="#buildURL(action='cusers.download', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=#rc.ispublic#&unassigned=#rc.unassigned#')#">
				<i class="icon-cloud-download"></i> 
				#rc.$.rbKey('user.downloadcsv')#
			</a>
		</div>

	<!--- BODY --->
		<cfif rc.rsUsers.recordcount>
			<table id="tbl-users" class="table table-striped table-condensed table-bordered mura-table-grid">
				<thead>
					<tr>
						<th>
							&nbsp;
						</th>
						<th class="var-width">
							#rc.$.rbKey('user.user')#
						</th>
						<th>
							#rc.$.rbKey('user.email')#
						</th>
						<th>
							#rc.$.rbKey('user.datelastupdate')#
						</th>
						<th>
							#rc.$.rbKey('user.timelastupdate')#
						</th>
						<th>
							#rc.$.rbKey('user.lastupdatedby')#
						</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<!--- RECORDS --->
					<cfloop condition="rc.itUsers.hasNext()">
						<cfsilent>
							<cfscript>
								local.user = rc.itUsers.next();
							</cfscript>
						</cfsilent>
						<tr>
							<!--- Icons --->
							<td class="actions">
								<ul>
									<cfif ListFindNoCase(rc.listUnassignedUsers, local.user.getValue('userid'))>
										<li>
											<a rel="tooltip" title="Unassigned">
												<i class="icon-exclamation"></i>
											</a>
										</li>
									</cfif>
									<cfif local.user.getValue('s2') EQ 1>
										<li>
											<a rel="tooltip" title="#rc.$.rbKey('user.superuser')#">
												<i class="icon-bolt"></i>
											</a>
										</li>
									<cfelseif local.user.getValue('isPublic') EQ 0>
										<li>
											<a rel="tooltip" title="#rc.$.rbKey('user.adminuser')#">
												<i class="icon-user"></i>
											</a>
										</li>
									<cfelse>
										<li>
											<a rel="tooltip" title="#rc.$.rbKey('user.sitemember')#">
												<i class="icon-user"></i>
											</a>
										</li>
									</cfif>
								</ul>
							</td>
							<!--- Last Name, First Name --->
							<td class="var-width">
								<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.user.getValue('userid')#&siteid=#rc.siteid#')#">
									#esapiEncode('html',local.user.getValue('lname'))#, #esapiEncode('html',local.user.getValue('fname'))#
								</a>
							</td>
							<!--- Email --->
							<td>
								<cfif Len(local.user.getValue('email'))>
									<a href="mailto:#URLEncodedFormat(local.user.getValue('email'))#">
										#esapiEncode('html',local.user.getValue('email'))#
									</a>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<!--- Date Lastupdate --->
							<td>
								#LSDateFormat(local.user.getValue('lastupdate'), session.dateKeyFormat)#
							</td>
							<!--- Time Lastupdate --->
							<td>
								#LSTimeFormat(local.user.getValue('lastupdate'), 'short')#
							</td>
							<!--- Last Update By --->
							<td>
								#esapiEncode('html',local.user.getValue('lastupdateby'))#
							</td>
							<!--- Actions --->
							<td class="actions">
								<ul>
									<li>
										<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.user.getValue('userid')#&siteid=#rc.siteid#')#" rel="tooltip" title="#rc.$.rbKey('user.edit')#">
											<i class="icon-pencil"></i>
										</a>
									</li>

									<cfif local.user.getValue('perm') eq 0>
										<li>
											<a href="#buildURL(action='cusers.update', querystring='action=delete&userid=#local.user.getValue('userid')#&siteid=#rc.siteid#&type=1#rc.$.renderCSRFTokens(context=local.user.getValue('userid'),format='url')#')#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteuserconfirm'))#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.delete')#">
												<i class="icon-remove-sign"></i>
											</a>
										</li>
									<cfelse>
										<li class="disabled">
											<i class="icon-remove-sign"></i>
										</li>
									</cfif>
								</ul>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		<cfelse>
			<div class="alert alert-info">
				#rc.$.rbKey('user.nousers')#
			</div>
		</cfif>

</cfoutput>