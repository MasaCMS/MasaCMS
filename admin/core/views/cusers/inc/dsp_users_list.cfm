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
<cfoutput>
	<cfif IsDefined('rc.it')>

		<cfif rc.it.hasNext()>

			<table id="tbl-users" class="table table-striped table-condensed table-bordered mura-table-grid">

				<thead>
					<tr>
						<th class="actions"></th>
						<th class="actions"></th>
						<th class="var-width">
							#rbKey('user.user')#
						</th>
						<th>
							#rbKey('user.email')#
						</th>
						<th class="hidden-xs">
							#rbKey('user.datelastupdate')#
						</th>
						<th class="hidden-xs hidden-sm">
							#rbKey('user.timelastupdate')#
						</th>
						<th class="hidden-xs">
							#rbKey('user.lastupdatedby')#
						</th>
					</tr>
				</thead>

				<tbody>

					<!--- Users Iterator --->
						<cfloop condition="rc.it.hasNext()">
							<cfscript>
								local.item = rc.it.next();
								local.canEdit = rc.$.currentUser().isInGroup('Admin') || rc.$.currentUser().isSuperUser() || local.item.getValue('isPublic') == 1;
							</cfscript>
							<tr>

								<!--- Actions --->
									<td class="actions">
										<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
										<div class="actions-menu hide">
											<ul class="actions-list">

												<!--- Edit --->
													<cfif local.canEdit>
														<li>
															<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.item.getValue('userid')#&siteid=#esapiEncode('url',rc.siteid)#')#" rel="tooltip" onclick="actionModal(); window.location=this.href;">
																<i class="mi-pencil"></i>#rbKey('user.edit')#
															</a>
														</li>
														<!--- <cfelse>
														<li class="disabled">
															<i class="mi-pencil"></i>
														</li> --->
													</cfif>

												<!--- Remove From Group --->
													<cfif ListLast(rc.muraAction, '.') eq 'editgroupmembers'>
														<li class="remove">
															<a href="#buildURL(action='cusers.removefromgroup', querystring='userid=#local.item.getValue('userid')#&routeid=#rc.userid#&groupid=#rc.userid#&siteid=#esapiEncode('url',rc.siteid)#')#" onclick="return confirmDialog('#jsStringFormat(rbKey('user.removeconfirm'))#',this.href)" rel="tooltip">
																<i class="mi-minus-circle"></i>#rbKey('user.removeconfirm')#
															</a>
														</li>
													</cfif>

												<!--- Delete --->
													<cfif local.canEdit>
														<li class="delete">
															<a href="#buildURL(action='cusers.update', querystring='action=delete&ispublic=#local.item.getValue('ispublic')#&userid=#local.item.getValue('userid')#&siteid=#esapiEncode('url',rc.siteid)#&type=1#rc.$.renderCSRFTokens(context=local.item.getValue('userid'),format='url')#')#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteuserconfirm'))#',this.href)" rel="tooltip">
																<i class="mi-trash"></i>#rbKey('user.delete')#
															</a>
														</li>
														<!--- <cfelse>
														<li class="disabled">
															<i class="mi-trash"></i>
														</li> --->
													</cfif>

										</ul>
										</div>
									</td>
								<!--- /Actions --->

								<!--- Icons --->
									<td class="actions">
										<ul>
											<cfif IsDefined('rc.listUnassignedUsers') and ListFindNoCase(rc.listUnassignedUsers, local.item.getValue('userid'))>
												<li>
													<a rel="tooltip" title="Unassigned">
														<i class="mi-exclamation"></i>
													</a>
												</li>
											</cfif>
											<cfif local.item.getValue('s2') EQ 1>
												<li>
													<a rel="tooltip" title="#rbKey('user.superuser')#">
														<i class="mi-star"></i>
													</a>
												</li>
											<cfelseif local.item.getValue('isPublic') EQ 0>
												<li>
													<a rel="tooltip" title="#rbKey('user.adminuser')#">
														<i class="mi-user"></i>
													</a>
												</li>
											<cfelse>
												<li>
													<a rel="tooltip" title="#rbKey('user.sitemember')#">
														<i class="mi-user"></i>
													</a>
												</li>
											</cfif>
										</ul>
									</td>
								<!--- /Icons --->

								<!--- Last Name, First Name --->
									<td class="var-width">
										<cfif local.canEdit>
											<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.item.getValue('userid')#&siteid=#esapiEncode('url',rc.siteid)#')#" onclick="actionModal();">
												#esapiEncode('html', local.item.getValue('lname'))#, #esapiEncode('html', local.item.getValue('fname'))#
											</a>
										<cfelse>
											#esapiEncode('html', local.item.getValue('lname'))#, #esapiEncode('html', local.item.getValue('fname'))#
										</cfif>
									</td>

								<!--- Email --->
									<td>
										<cfif Len(local.item.getValue('email'))>
											<a href="mailto:#esapiEncode('url',local.item.getValue('email'))#">
												#esapiEncode('html', local.item.getValue('email'))#
											</a>
										<cfelse>
											&nbsp;
										</cfif>
									</td>

								<!--- Date Lastupdate --->
									<td class="hidden-xs">
										#LSDateFormat(local.item.getValue('lastupdate'), session.dateKeyFormat)#
									</td>

								<!--- Time Lastupdate --->
									<td class="hidden-xs hidden-sm">
										#LSTimeFormat(local.item.getValue('lastupdate'), 'short')#
									</td>

								<!--- Last Update By --->
									<td class="hidden-xs">
										#esapiEncode('html', local.item.getValue('lastupdateby'))#
									</td>

							</tr>
						</cfloop>

				</tbody>
			</table>

			<cfinclude template="dsp_nextn.cfm" />

		<cfelse>

			<!--- No Users Message --->
				<div class="help-block-empty">
					<cfif IsDefined('rc.noUsersMessage')>
						#esapiEncode('html', rc.noUsersMessage)#
					<cfelse>
						#rbKey('user.nousers')#
					</cfif>
				</div>

		</cfif>

	</cfif>
</cfoutput>
