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
	<cfinclude template="inc/dsp_users_header.cfm" />

	<!--- Subheading --->
		<h2>#rc.$.rbKey('user.groups')#</h2>

	<!--- Tab Nav (only tabbed for Admin + Super Users) --->
		<cfif ListFind(rc.$.currentUser().getMemberships(), 'Admin;#rc.$.siteConfig('privateUserPoolID')#;0') OR ListFind(rc.$.currentUser().getMemberships(), 'S2')>
				<ul class="nav nav-tabs">
					<!--- Member/Public Groups --->
					<li<cfif rc.ispublic eq 1> class="active"</cfif>>
						<a href="#buildURL(action='cusers.list', querystring='ispublic=1')#">
							#rc.$.rbKey('user.membergroups')#
						</a>
					</li>
					<!--- System/Private Groups --->
					<li<cfif rc.ispublic eq 0> class="active"</cfif>>
						<a href="#buildURL(action='cusers.list', querystring='ispublic=0')#">
							#rc.$.rbKey('user.adminusergroups')#
						</a>
					</li>
				</ul>
		<cfelse>
			<h3>#rc.$.rbKey('user.membergroups')#</h3>
		</cfif>
	<!--- /Tab Nav --->

	<!--- BODY --->
		<cfif rc.rsGroups.recordcount>
			<table id="temp" class="table table-striped table-condensed table-bordered mura-table-grid">
				<thead>
					<tr>
						<th class="var-width">
							#rc.$.rbKey('user.grouptotalmembers')#
						</th>

						<!--- TEMP!!! Take out!! --->
						<th>
							<cfset poolheading = !rc.ispublic ? rc.$.rbKey('siteconfig.sharedresources.systemuserpool') : rc.$.rbKey('siteconfig.sharedresources.memberuserpool') />
							#poolheading#
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
					<cfloop condition="rc.itGroups.hasNext()">
						<cfsilent>
							<cfscript>
								local.group = rc.itGroups.next();
								local.membercount = Len(local.group.getValue('counter'))
									? local.group.getValue('counter')
									: 0;
							</cfscript>
						</cfsilent>
						<tr>
							<td class="var-width">
								<a href="#buildURL(action='cusers.editgroup', querystring='userid=#local.group.getValue('userid')#&siteid=#rc.siteid#')#">
									#esapiEncode('html',local.group.getValue('groupname'))#
								</a>
								(#local.membercount#)
							</td>

							<!--- TEMP!! Take Out!! --->
							<td>
								<cfset poolid = !rc.ispublic ? rc.$.siteConfig('publicUserPoolID') : rc.$.siteConfig('privateUserPoolID') />
								#poolid#
							</td>

							<td>
								<cfif Len(local.group.getValue('email'))>
									<a href="mailto:#URLEncodedFormat(local.group.getValue('email'))#">
										#esapiEncode('html',local.group.getValue('email'))#
									</a>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								#LSDateFormat(local.group.getValue('lastupdate'), session.dateKeyFormat)#
							</td>
							<td>
								#LSTimeFormat(local.group.getValue('lastupdate'), 'short')#
							</td>
							<td>
								#esapiEncode('html',local.group.getValue('lastupdateby'))#
							</td>
							<td class="actions">
								<ul>
									<li>
										<a href="#buildURL(action='cusers.editgroup', querystring='userid=#local.group.getValue('userid')#&siteid=#rc.siteid#')#" rel="tooltip" title="#rc.$.rbKey('user.edit')#">
											<i class="icon-pencil"></i>
										</a>
									</li>

									<cfif local.group.getValue('perm') eq 0>
										<cfscript>
											msgDelete = application.rbFactory.getResourceBundle(session.rb).messageFormat(
												rc.$.rbKey('user.deleteusergroupconfim')
												, [local.group.getValue('groupname')]
											 );
										</cfscript>
										<li>
											<a href="#buildURL(action='cusers.update', querystring='action=delete&userid=#local.group.getValue('userid')#&siteid=#rc.siteid#&type=1#rc.$.renderCSRFTokens(context=rc.rsgroups.UserID,format='url')#')#" onclick="return confirmDialog('#jsStringFormat(msgDelete)#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.delete')#">
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

			<!--- No groups message --->
			<div class="alert alert-info">
				#rc.$.rbKey('user.nogroups')#
			</div>

		</cfif>
</cfoutput>