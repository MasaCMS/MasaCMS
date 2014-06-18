<cfoutput>

	<!--- Header --->
	<cfinclude template="dsp_users_header.cfm" />

	<!--- TAB NAV --->
	<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>

		<h2>#rc.$.rbKey('user.groups')#</h2>

		<ul class="nav nav-tabs">
			<!--- Public Groups --->
			<li<cfif rc.ispublic eq 1> class="active"</cfif>>
				<a href="#buildURL(action='cusers.list', querystring='ispublic=1')#">
					#rc.$.rbKey('user.membergroups')#
				</a>
			</li>
			<!--- Private Groups --->
			<li<cfif rc.ispublic eq 0> class="active"</cfif>>
				<a href="#buildURL(action='cusers.list', querystring='ispublic=0')#">
					#rc.$.rbKey('user.adminusergroups')#
				</a>
			</li>
		</ul>
	<cfelse>
		<h2>#rc.$.rbKey('user.membergroups')#</h2>
	</cfif>

	<!--- BODY --->
		<cfif rc.rsGroups.recordcount>
				<table id="temp" class="table table-striped table-condensed table-bordered mura-table-grid">
					<thead>
						<tr>
							<th class="var-width">
								<!--- <a rel="tooltip" title="Group (Total Members)"> --->
									<!--- <i class="icon-group"></i> --->
								<!--- </a> --->
								Group (Total Members)
							</th>
							<th>
								<!--- <a rel="tooltip" title="Email"> --->
									<!--- <i class="icon-envelope"></i> --->
								<!--- </a> --->
								Email
							</th>
							<th>
								<!--- <a rel="tooltip" title="Date Last Update"> --->
									<!--- <i class="icon-calendar"></i> --->
								<!--- </a> --->
								Date Last Update
							</th>
							<th>
								<!--- <a rel="tooltip" title="Time Last Update"> --->
									<!--- <i class="icon-time"></i> --->
								<!--- </a> --->
								Time Last Update
							</th>
							<th>
								<!--- <a rel="tooltip" title="Last Update By"> --->
									<!--- <i class="icon-wrench"></i> --->
								<!--- </a> --->
								Last Update By
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
										#HTMLEditFormat(local.group.getValue('groupname'))#
									</a>
									(#local.membercount#)
								</td>
								<td>
									<cfif Len(local.group.getValue('email'))>
										<a href="mailto:#URLEncodedFormat(local.group.getValue('email'))#">
											#HTMLEditFormat(local.group.getValue('email'))#
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
									#HTMLEditFormat(local.group.getValue('lastupdateby'))#
								</td>
								<td class="actions">
									<ul>
										<li>
											<a title="Edit" href="#buildURL(action='cusers.editgroup', querystring='userid=#local.group.getValue('userid')#&siteid=#rc.siteid#')#">
												<i class="icon-pencil"></i>
											</a>
										</li>

										<cfif local.group.getValue('perm') eq 0>
											<li>
												<a title="Delete" href="#buildURL(action='cusers.update', querystring='action=delete&userid=#local.group.getValue('userid')#&siteid=#rc.siteid#&type=1')#" onclick="return confirmDialog('Delete the #jsStringFormat("'#local.group.getValue('groupname')#'")# User Group?',this.href)">
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
					<p>No groups exist at this time &hellip; carry on.</p>
				</div>
		</cfif>

</cfoutput>