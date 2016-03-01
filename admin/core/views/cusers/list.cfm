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

	<cfinclude template="inc/dsp_users_header.cfm" />

<div class="block block-constrain">

	<!--- Tab Nav (only tabbed for Admin + Super Users) --->
		<cfif ListFind(rc.$.currentUser().getMemberships(), 'Admin;#rc.$.siteConfig('privateUserPoolID')#;0') OR ListFind(rc.$.currentUser().getMemberships(), 'S2')>

				<ul id="viewTabs" class="mura-tabs nav-tabs nav-tabs-alt">

					<!--- Member/Public Groups --->
						<li<cfif rc.ispublic eq 1> class="active"</cfif>>
							<a href="#buildURL(action='cusers.list', querystring='ispublic=1')#" onclick="actionModal();">
								#rbKey('user.membergroups')#
							</a>
						</li>

					<!--- System/Private Groups --->
						<li<cfif rc.ispublic eq 0> class="active"</cfif>>
							<a href="#buildURL(action='cusers.list', querystring='ispublic=0')#" onclick="actionModal();">
								#rbKey('user.adminusergroups')#
							</a>
						</li>

				</ul>

		<cfelse>
			<h3>#rbKey('user.membergroups')#</h3>
		</cfif>
	<!--- /Tab Nav --->

	<div class="block-content tab-content">

		<!-- start tab -->
		<div class="tab-pane active">
		
			<div class="block block-bordered">
				<!-- block header -->
				<div class="block-header bg-gray-lighter">
					<ul class="block-options">
						<li>Something here?</li>
						<li>
							<button type="button" data-toggle="block-option" data-action="refresh_toggle" data-action-mode="demo"><i class="si si-refresh"></i></button>
						</li>
						<li>
							<button type="button" data-toggle="block-option" data-action="content_toggle"><i class="si si-arrow-up"></i></button>
						</li>
					</ul>
					<h3 class="block-title">
						<cfif ListFind(rc.$.currentUser().getMemberships(), 'Admin;#rc.$.siteConfig('privateUserPoolID')#;0') OR ListFind(rc.$.currentUser().getMemberships(), 'S2')>
							#rbKey('user.groups')#
						<cfelse>
							#rbKey('user.membergroups')#
						</cfif>
	
					</h3>
				</div> <!-- /.block header -->						
				<div class="block-content">

	<!--- Group Listing --->
		<cfif rc.it.hasNext()>
			<table id="temp" class="table table-striped table-condensed table-bordered mura-table-grid">

				<thead>
					<tr>
						<th class="var-width">
							#rbKey('user.grouptotalmembers')#
						</th>
						<th>
							#rbKey('user.groupemail')#
						</th>
						<th>
							#rbKey('user.datelastupdate')#
						</th>
						<th>
							#rbKey('user.timelastupdate')#
						</th>
						<th>
							#rbKey('user.lastupdatedby')#
						</th>
						<th>&nbsp;</th>
					</tr>
				</thead>

				<tbody>
					<cfloop condition="rc.it.hasNext()">
						<cfsilent>
							<cfscript>
								local.item = rc.it.next();
								local.membercount = Len(local.item.getValue('counter'))
									? local.item.getValue('counter')
									: 0;
							</cfscript>
						</cfsilent>
						<tr>

							<!--- Group Name --->
								<td class="var-width">
									<a href="#buildURL(action='cusers.editgroup', querystring='userid=#local.item.getValue('userid')#&siteid=#rc.siteid#')#" onclick="actionModal();">
										#esapiEncode('html',local.item.getValue('groupname'))#</a>
									(#Val(local.membercount)#)
								</td>

							<!--- Group Email --->
								<td>
									<cfif Len(local.item.getValue('email'))>
										<a href="mailto:#URLEncodedFormat(local.item.getValue('email'))#">
											#esapiEncode('html',local.item.getValue('email'))#
										</a>
									<cfelse>
										&nbsp;
									</cfif>
								</td>

							<!--- Date Last Update --->
								<td>
									#LSDateFormat(local.item.getValue('lastupdate'), session.dateKeyFormat)#
								</td>

							<!--- Time Last Update --->
								<td>
									#LSTimeFormat(local.item.getValue('lastupdate'), 'short')#
								</td>

							<!--- Last Update By --->
								<td>
									#esapiEncode('html',local.item.getValue('lastupdateby'))#
								</td>

							<!--- Actions --->
								<td class="actions">
									<ul>

										<!--- Edit --->
											<li>
												<a href="#buildURL(action='cusers.editgroup', querystring='userid=#local.item.getValue('userid')#&siteid=#rc.siteid#')#" rel="tooltip" title="#rbKey('user.edit')#" onclick="actionModal(); window.location=this.href;">
																<i class="mi-pencil"></i>
												</a>
											</li>

										<!--- Delete --->
											<cfif local.item.getValue('perm') eq 0>

												<cfset msgDelete = rc.$.getBean('resourceBundle').messageFormat(
														rbKey('user.deleteusergroupconfim')
														, [local.item.getValue('groupname')]
												) />

												<li>
													<a href="#buildURL(action='cusers.update', querystring='action=delete&userid=#local.item.getValue('userid')#&siteid=#rc.siteid#&type=1#rc.$.renderCSRFTokens(context=local.item.getValue('userid'),format='url')#')#" onclick="return confirmDialog('#esapiEncode('javascript', msgDelete)#',this.href)" rel="tooltip" title="#rbKey('user.delete')#">
																	<i class="mi-times-circle"></i>
													</a>
												</li>
											<cfelse>
												<li class="disabled">
																<i class="mi-times-circle"></i>
												</li>
											</cfif>

									</ul>
								</td>
							<!--- /Actions --->

						</tr>
					</cfloop>
				</tbody>

			</table>

			<cfinclude template="inc/dsp_nextn.cfm" />
		<cfelse>

			<!--- No groups message --->
			<div class="alert alert-info">
				#rbKey('user.nogroups')#
			</div>

		</cfif>

					</div> <!-- /.block-content -->
				</div> <!-- /.block-bordered -->
			</div> <!-- /.tab-pane -->

	</div> <!-- /.block-content.tab-content -->
</div> <!-- /.block-constrain -->

</cfoutput>