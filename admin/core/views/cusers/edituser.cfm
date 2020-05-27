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
<cfhtmlhead text="#session.dateKey#" />
<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
<cfsilent>
	<cfscript>
		event = request.event;
		userPoolID = rc.ispublic == 0 && rc.isAdmin
			? rc.$.siteConfig('privateUserPoolID')
			: rc.$.siteConfig('publicUserPoolID');

		rsSubTypes = application.classExtensionManager.getSubTypesByType(type=2, siteid=userPoolID, activeOnly=true);

		q = new Query();
		q.setDbType('query');
		q.setAttributes(rs=rsSubTypes);
		q.addParam(name='subType', value='Default', cfsqltype='cf_sql_varchar');
		q.setSQL('SELECT * FROM rs WHERE subtype <> :subType');
		rsNonDefault = q.execute().getResult();

		variables.pluginEvent = CreateObject("component","mura.event").init(event.getAllValues());
		pluginEventMappings = Duplicate(rc.$.getBean('pluginManager').getEventMappings(eventName='onUserEdit', siteid=rc.siteid));

		if ( ArrayLen(pluginEventMappings) ) {
			for ( i=1; i <= ArrayLen(pluginEventMappings); i++) {
				pluginEventMappings[i].eventName = 'onUserEdit';
			}
		}

		tabLabelList = '#rbKey('user.basic')#,#rbKey('user.addressinformation')#,#rbKey('user.groupmemberships')#,#rbKey('user.interests')#';
		tablist = 'tabBasic,tabAddressinformation,tabGroupmemberships,tabInterests';
		if ( rsSubTypes.recordcount ) {
			tabLabelList = ListAppend(tabLabelList,rbKey('user.extendedattributes'));
			tabList = ListAppend(tabList,"tabExtendedattributes");
		}
		tabLabelList = ListAppend(tabLabelList,rbKey('user.advanced'));
		tabList = ListAppend(tabList,"tabAdvanced");

		lockedSuper=(rc.userBean.exists() and rc.userBean.get('s2') and not rc.$.getCurrentUser().isSuperUser());
	</cfscript>
</cfsilent>

<cfoutput>

<div class="mura-header">
	<h1>#rbKey('user.usermaintenanceform')#</h1>
	<div class="nav-module-specific btn-group">
		<a class="btn" href="##" title="#esapiEncode('html',rbKey('sitemanager.back'))#" onclick="actionModal();window.history.back(); return false;">
				<i class="mi-arrow-circle-left"></i> #esapiEncode('html',rbKey('sitemanager.back'))#
		</a>
	</div>
</div> <!-- /.mura-header -->

<cfif len(rc.userBean.getUsername())>
	<cfset strikes=createObject("component","mura.user.userstrikes").init(rc.userBean.getUsername(),application.configBean)>
	<cfif structKeyExists(rc,"removeBlock")>
		<cfset strikes.clear()>
	</cfif>
	<cfif strikes.isBlocked()>
		<div class="alert alert-error"><span>#rbKey('user.blocked')#: #LSTimeFormat(strikes.blockedUntil(),"short")# <a href="?muraAction=cUsers.edituser&amp;userid=#esapiEncode('url',rc.userid)#&amp;type=2&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;removeBlock">[#rbKey('user.remove')#]</a></span>
		</div>
	</cfif>
</cfif>

<cfif lockedSuper>
	<div class="alert alert-info"><span>#rc.$.rbKey("user.locksupers")#</span></div>
<cfelseif not structIsEmpty(rc.userBean.getErrors())>
	<div class="alert alert-error"><span>#application.utility.displayErrors(rc.userBean.getErrors())#</span></div>
</cfif>

<form novalidate="novalidate" action="#buildURL(action='cUsers.update', querystring='userid=#rc.userBean.getUserID()#&routeid=#rc.routeid#')#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return userManager.submitForm(this);;" autocomplete="off">

	<div class="block block-constrain">

		</cfoutput>

		<cfsavecontent variable="tabContent">
			<cfoutput>

				<!--- Basic Tab --->
					<div id="tabBasic" class="tab-pane active">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Basic Settings</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

							<div class="help-block-inline">#rbKey('user.requiredtext')#</div>

							<!--- Subtype --->
							<cfif rsNonDefault.recordcount>
								<div class="mura-control-group">
									<label>#rbKey('user.type')#</label>
										<select name="subtype"  onchange="userManager.resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');">
											<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>>
												#rbKey('user.default')#
											</option>
											<cfloop query="rsNonDefault">
												<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>
													#rsNonDefault.subtype#
												</option>
											</cfloop>
										</select>
									</div>
							</cfif>

							<!--- Name --->
							<div class="mura-control-group">
									<label for="fname">#rbKey('user.fname')#*</label>
									<input id="fname" name="fname" type="text" value="#esapiEncode('html',rc.userBean.getfname())#"  required="true" message="#rbKey('user.fnamerequired')#">
								</div>

							<div class="mura-control-group">
									<label for="lname">#rbKey('user.lname')#*</label>
									<input id="lname" name="lname" type="text" value="#esapiEncode('html',rc.userBean.getlname())#"  required="true" message="#rbKey('user.lnamerequired')#">
							</div>

							<!--- Company + Title --->
							<div class="mura-control-group">
								<label for="organization">#rbKey('user.company')#</label>
								<input id="organization" name="company" type="text" value="#esapiEncode('html',rc.userBean.getcompany())#">
								</div>

							<div class="mura-control-group">
								<label for="jobtitle">#rbKey('user.jobtitle')#</label>
								<input id="jobtitle" name="jobtitle" type="text" value="#esapiEncode('html',rc.userBean.getjobtitle())#">
							</div>

							<!--- Email + Phone --->
							<div class="mura-control-group">
								<label for="email">#rbKey('user.email')#*</label>
								<input <cfif lockedSuper>disabled</cfif> id="email" name="email" type="text" value="#esapiEncode('html',rc.userBean.getemail())#" required="true" validate="email" message="#rbKey('user.emailvalidate')#">
								</div>

							<div class="mura-control-group">
								<label for="mobilePhone">#rbKey('user.mobilephone')#</label>
								<input id="mobilePhone" name="mobilePhone" type="text" value="#esapiEncode('html',rc.userBean.getMobilePhone())#">
							</div>

							<!--- Username --->
							<div class="mura-control-group">
								<label for="username">#rbKey('user.username')#*</label>
								<input <cfif lockedSuper>disabled</cfif> id="username"  name="usernameNoCache" type="text" value="#esapiEncode('html',rc.userBean.getusername())#" required="true" message="The 'Username' field is required" autocomplete="off">
							</div>
							<cfif not lockedSuper>

								<cfif $.globalConfig().passwordsExpire()>
									<div id="passwordexpired" class="help-block-inline" <cfif not rc.userBean.getPasswordExpired()> style="display:none;"</cfif>>#$.rbKey('user.passwordexpired')#</div>
									
									<div id="expirepassword" class="mura-control-group" <cfif rc.userBean.getPasswordExpired()> style="display:none;"</cfif>>
										<button type="button" id="expirepasswordbtn" class="btn">#$.rbKey('user.expirepassword')#</button>
									</div>
									<script>
										$(function(){
											$('##expirepasswordbtn').on('click',function(){
												confirmDialog(
													"#esapiEncode('javascript',$.rbKey('user.expirepasswordconfirm'))#",
													function(){
														Mura.get('./?muraAction=cusers.expirepassword&userid=#esapiEncode('url',rc.userBean.getUserID())#&siteid=#esapiEncode('url',rc.userBean.getSiteID())#')
														.then(function(){
															Mura('##expirepassword').hide();
															Mura('##passwordexpired').show();
														})
													}
												);
											})
										});
									</script>
								</cfif>
								
								<cfif isBoolean($.globalConfig('strongpasswords')) and $.globalConfig('strongpasswords')>
									<div class="help-block-inline">#$.rbKey('user.passwordstrengthhelptext')#</div>
								</cfif>

								<!--- Password --->
								<div class="mura-control-group">
									<label for="passwordNoCache">#rbKey('user.newpassword')#**</label>
									<input id="passwordNoCache" name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value=""  message="#rbKey('user.passwordmatchvalidate')#">
									</div>

								<div class="mura-control-group">
									<label for="password2">#rbKey('user.newpasswordconfirm')#**</label>
									<input id="password2" name="password2" autocomplete="off" type="password" value=""  message="#rbKey('user.passwordconfirm')#">
								</div>
							</cfif>

							<!--- Image --->
							<div class="mura-control-group">
								<label for="newFile">#rbKey('user.image')#</label>
								<cf_fileselector name="newfile" property="photofileid" bean="#rc.userBean#" deleteKey="removePhotoFile" compactDisplay="#rc.compactDisplay#" examplefileext="JPG">
							</div>

							<span id="extendSetsBasic"></span>

						</div> <!-- /.block-content -->
					</div> <!-- /.block-bordered -->
				</div> <!-- /.tab-pane -->
				<!--- /Basic Tab --->

				<!--- Address Tab --->
					<div id="tabAddressinformation" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Address Information</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

						<cfsilent>
							<cfparam name="rc.address1" default=""/>
							<cfparam name="rc.address2" default=""/>
							<cfparam name="rc.city" default=""/>
							<cfparam name="rc.state" default=""/>
							<cfparam name="rc.zip" default=""/>
							<cfparam name="rc.country" default=""/>
							<cfparam name="rc.phone" default=""/>
							<cfparam name="rc.fax" default=""/>
							<cfparam name="rc.addressURL" default=""/>
							<cfparam name="rc.addressEmail" default=""/>
							<cfparam name="rc.hours" default=""/>
						</cfsilent>
							<cfif rc.userid eq ''>

								<!--- Address1 + Address2 --->
								<div class="mura-control-group">
									<label>#rbKey('user.address1')#</label>
									<input id="address1" name="address1" type="text" value="#esapiEncode('html',rc.address1)#">
									</div>

								<div class="mura-control-group">
									<label>#rbKey('user.address2')#</label>
									<input id="address2" name="address2" type="text" value="#esapiEncode('html',rc.address2)#">
								</div>

								<!--- City, State, Zip, Country --->
								<div class="mura-control-group">
									<label>#rbKey('user.city')#</label>
									<input id="city" name="city" type="text" value="#esapiEncode('html',rc.city)#">
								</div>

								<div class="mura-control-group">
									<label>#rbKey('user.state')#</label>
									<input id="state" name="state" type="text" value="#esapiEncode('html',rc.state)#">
								</div>

								<div class="mura-control-group">
									<label>#rbKey('user.zip')#</label>
									<input id="zip" name="zip" type="text" value="#esapiEncode('html',rc.zip)#">
								</div>

								<div class="mura-control-group">
									<label>#rbKey('user.country')#</label>
									<input id="country" name="country" type="text" value="#esapiEncode('html',rc.country)#">
								</div>

								<!--- Phone + Fax --->
								<div class="mura-control-group">
									<label>#rbKey('user.phone')#</label>
									<input id="phone" name="phone" type="text" value="#esapiEncode('html',rc.phone)#">
								</div>

								<div class="mura-control-group">
									<label>#rbKey('user.fax')#</label>
									<input id="fax" name="fax" type="text" value="#esapiEncode('html',rc.fax)#">
								</div>

								<!---URL + Email --->
								<div class="mura-control-group">
									<label>#rbKey('user.website')# (#rbKey('user.includehttp')#)</label>
									<input id="addressURL" name="addressURL" type="text" value="#esapiEncode('html',rc.addressURL)#">
								</div>

								<div class="mura-control-group">
									<label>#rbKey('user.email')#</label>
									<input id="addressEmail" name="addressEmail" validate="email" message="#rbKey('user.emailvalidate')#" type="text" value="#esapiEncode('html',rc.addressEmail)#">
								</div>

								<!--- Hours --->
								<div class="mura-control-group">
									<label>#rbKey('user.hours')#</label>
									<textarea id="hours" name="hours" rows="6">#esapiEncode('html',rc.hours)#</textarea>
								</div>

								<input type="hidden" name="isPrimary" value="1" />

							<cfelse>

								<!--- Add Address --->
								<div class="mura-control-group">
									<ul class="navTask nav nav-pills">
										<li>
											<a href="./?muraAction=cUsers.editAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#rc.routeid#&amp;addressID=">
												<i class="mi-plus-circle"></i> #rbKey('user.addnewaddress')#
											</a>
										</li>
									</ul>

									<cfset rsAddresses=rc.userBean.getAddresses()>

									<cfif rsAddresses.recordcount>
										<table class="table table-striped table-condensed table-bordered mura-table-grid">
											<tr>
												<th>#rbKey('user.primary')#</th>
												<th>#rbKey('user.address')#</th>
												<th class="adminstration"></th>
											</tr>
											<cfloop query="rsAddresses">
												<tr>
													<td>
														<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
													</td>
													<td class="var-width">
														<cfif rsAddresses.addressName neq ''>
															<a title="#rbKey('user.edit')#" href="./?muraAction=cUsers.editAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#esapiEncode('url',rc.routeid)#&amp;addressID=#rsAddresses.addressID#">
																#rsAddresses.addressName#
															</a><br />
														</cfif>

														<cfif rsAddresses.address1 neq ''>
															#esapiEncode('html',rsAddresses.address1)#<br />
														</cfif>

														<cfif rsAddresses.address2 neq ''>
															#esapiEncode('html',rsAddresses.address2)#<br />
														</cfif>

														<cfif rsAddresses.city neq ''>
															#esapiEncode('html',rsAddresses.city)#
														</cfif>

														<cfif rsAddresses.state neq ''>
															<cfif rsaddresses.city neq ''>,</cfif>
															#esapiEncode('html',rsAddresses.state)#
														</cfif>

														<cfif rsaddresses.zip neq ''>
															#esapiEncode('html',rsAddresses.zip)#
														</cfif>

														<cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''>
															<br/>
														</cfif>

														<cfif rsAddresses.phone neq ''>
															#rbKey('user.phone')#: #esapiEncode('html',rsAddresses.phone)#<br/>
														</cfif>

														<cfif rsAddresses.fax neq ''>
															#rbKey('user.fax')#: #esapiEncode('html',rsAddresses.fax)#<br/>
														</cfif>

														<cfif rsAddresses.addressURL neq ''>
															#rbKey('user.website')#:
															<a href="#rsAddresses.addressURL#" target="_blank">
																#esapiEncode('html',rsAddresses.addressURL)#
															</a><br/>
														</cfif>

														<cfif rsAddresses.addressEmail neq ''>
															#rbKey('user.email')#:
															<a href="mailto:#rsAddresses.addressEmail#">
																#esapiEncode('html',rsAddresses.addressEmail)#
															</a>
														</cfif>
													</td>

													<td nowrap class="actions">
														<ul>
															<li class="edit">
																<a title="#rbKey('user.edit')#" href="./?muraAction=cUsers.editAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#rc.routeid#&amp;addressID=#rsAddresses.addressID#">
																	<i class="mi-pencil"></i>
																</a>
															</li>
															<cfif rsAddresses.isPrimary neq 1>
																<li class="delete">
																	<a title="Delete" href="./?muraAction=cUsers.updateAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;action=delete&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#esapiEncode('url',rc.routeid)#&amp;addressID=#rsAddresses.addressID#" onclick="return confirmDialog('#jsStringFormat(rbKey('user.deleteaddressconfirm'))#',this.href);">
																		<i class="mi-trash"></i>
																	</a>
																</li>
															<cfelse>
																<li class="delete"><i class="mi-trash"></i></li>
															</cfif>
														</ul>
													</td>
												</tr>
											</cfloop>
										</table>
									<cfelse>
										<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</div>
									</cfif>
								</div>
								<!--- /Add Address --->

							</cfif>
						</div> <!-- /.block-content -->
					</div> <!-- /.block-bordered -->
				</div> <!-- /.tab-pane -->
				<!--- /Address Tab --->

				<!--- Group Memberships Tab --->
					<div id="tabGroupmemberships" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Group Memberships</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

							<!---
								User Type
								** Must be an 'Admin' or Super User to modify User Type
							--->
							<cfif rc.isAdmin>
								<div class="mura-control-group">
									<label>
										#rbKey('user.usertype')#
									</label>

										<label class="radio inline">
											<input <cfif lockedSuper>disabled </cfif>name="isPublic" type="radio" class="radio inline" value="1"<cfif rc.tempIsPublic> Checked</cfif>>
											#rbKey('user.sitemember')#
										</label>

										<label class="radio inline">
											<input <cfif lockedSuper>disabled </cfif>name="isPublic" type="radio" class="radio inline" value="0"<cfif not rc.tempIsPublic> Checked</cfif>>
											#rbKey('user.adminuser')#
										</label>
									</div>

								<script>
									jQuery(document).ready(function($){

										$('input[name="isPublic"]').click(function(e){

											if($('input[name="isPublic"]:checked').val()==1){
												$('##privateGroupsList').hide();
											} else {
												$('##privateGroupsList').show();
											}
										});

										$('input[name="s2"]').click(function(e){
											if($('input[name="s2"]:checked').val()==1){
												$('input[name="isPublic"][value="0"]').attr('checked',true);
												$('input[name="isPublic"]').trigger('clicked');
											}
										});

									});
								</script>
							<cfelse>
								<input name="isPublic" type="hidden" value="1">
							</cfif>

							<!---
								Private Groups
								** Must be an 'Admin' or Super User to add/edit Private Group Members
							--->
								<cfif rc.isAdmin>
									<div id="privateGroupsList" class="mura-control-group"<cfif rc.tempIsPublic> style="display:none"</cfif>>
										<label>
											#rbKey('user.admingroups')#
										</label>

										<!--- private groups listing --->
										<!---
										<script>
											// only show the Private Groups list, if the User is a 'System User'
											jQuery(document).ready(function($) {
												$('input[name="isPublic"]').on('change', function() {
													var privateGroups = $('##privateGroupsList');
													var msg = $('##privateGroupsNotice');
													var isPublic = $(this).val();

													if ( isPublic == 1 ) {
														privateGroups.hide();
														msg.show();
													} else {
														privateGroups.show();
														msg.hide();
													}
												});
											});
										</script>
										--->
										<!---
										<cfif rc.tempIsPublic>
											<div id="privateGroupsNotice">
												<p class="help-block-empty">
													#rbKey('user.systemgroupmessage')#
												</p>
											</div>
										</cfif>
										--->
											<cfif rc.rsPrivateGroups.recordcount>
												<cfloop query="rc.rsPrivateGroups">
													<label class="checkbox">
														<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPrivateGroups.UserID) or Listfind(rc.groupid,rc.rsPrivateGroups.UserID)>checked</cfif>>
														#rc.rsPrivateGroups.groupname#
													</label>
												</cfloop>
											<cfelse>
												<p class="help-block-empty">
													#rbKey('user.nogroups')#
												</p>
											</cfif>
										</div>
								</cfif>

							<!--- Public Groups --->
							<div class="mura-control-group">
								<label>
									#rbKey('user.membergroups')#
								</label>
									<cfif rc.rsPublicGroups.recordcount>
										<cfloop query="rc.rsPublicGroups">
											<label class="checkbox">
												<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPublicGroups.UserID) or listfind(rc.groupid,rc.rsPublicGroups.UserID)>checked</cfif>>
													#rc.rsPublicGroups.site# - #rc.rsPublicGroups.groupname#
											</label>
										</cfloop>
									<cfelse>
										<p class="help-block-empty">
											#rbKey('user.nogroups')#
										</p>
									</cfif>
								</div>

						</div> <!-- /.block-content -->
					</div> <!-- /.block-bordered -->
				</div> <!-- /.tab-pane -->
				<!--- /Group Memberships Tab --->

				<!--- Interests Tab --->
					<div id="tabInterests" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Interests</h3>
							</div> <!-- /.block header -->
							<div class="block-content">
							<div id="mura-list-tree" class="mura-control-group">

								<cf_dsp_categories_nest
									siteID="#rc.siteID#"
									parentID=""
									categoryID="#rc.categoryID#"
									nestLevel="0"
									userBean="#rc.userBean#">

							</div>
						</div> <!-- /.block-content -->
					</div> <!-- /.block-bordered -->
				</div> <!-- /.tab-pane -->
				<!--- /Interests Tab --->

				<!--- Extended Attributes Tab --->
					<cfif rsSubTypes.recordcount>
						<div id="tabExtendedattributes" class="tab-pane">
							<div class="block block-bordered">
								<!-- block header -->
								<div class="block-header">
									<h3 class="block-title">Extended Attributes</h3>
								</div> <!-- /.block header -->
								<div class="block-content">

								<span id="extendSetsDefault"></span>
								<script type="text/javascript">
									userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#userPoolID#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');
								</script>
								</div> <!-- /.block-content -->
							</div> <!-- /.block-bordered -->
						</div> <!-- /.tab-pane -->
					</cfif>
				<!--- /Extended Attributes Tab --->

				<!--- Advanced Tab --->
					<div id="tabAdvanced" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Advanced</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

							<!--- Super Admin + Email Broadcaster --->
								<cfif rc.$.currentUser().isSuperUser()>
								<div class="mura-control-group">
									<label>
											#rbKey('user.superadminaccount')#
										</label>
											<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="1" <cfif rc.userBean.gets2() eq 1>Checked</cfif>>
												#rbKey('user.yes')#
											</label>
											<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="0" <cfif rc.userBean.gets2() eq 0>Checked</cfif>>
												#rbKey('user.no')#
											</label>
										</div>
								</cfif>

						<!--- Email Broadcaster --->
						<cfif YesNoFormat(rc.$.siteConfig('EmailBroadcaster'))>
							<div class="mura-control-group">
								<label>#rbKey('user.emailbroadcaster')#</label>
								<label class="radio inline">
									<input name="subscribe" type="radio" class="radio inline" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>
									#rbKey('user.yes')#
								</label>
								<label class="radio inline">
									<input name="subscribe" type="radio" class="radio inline" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>
									#rbKey('user.no')#
								</label>
							</div>
						</cfif>

							<!--- Active + User Type --->
							<div class="mura-control-group">
								<!--- Active --->
								<label>
										#rbKey('user.inactive')#
									</label>
										<label class="radio inline">
											<input <cfif lockedSuper>disabled </cfif>name="InActive" type="radio" class="radio inline" value="0"<cfif rc.userBean.getInActive() eq 0 >Checked</cfif>>
											#rbKey('user.yes')#
										</label>
										<label class="radio inline">
											<input <cfif lockedSuper>disabled </cfif>name="InActive" type="radio" class="radio inline" value="1"<cfif rc.userBean.getInActive() eq 1 >Checked</cfif>>
											#rbKey('user.no')#
										</label>
									</div>

								<!--- SiteID --->
								<cfif rc.$.currentUser().isSuperUser()>
								<div class="mura-control-group">
									<label>
											#rbKey('user.site')#
										</label>
										<select name="siteid">
											<cfloop query="rc.rsSiteList">
												<option value="#esapiEncode('html_attr', rc.rsSiteList.siteid)#" <cfif (rc.userBean.exists() and rc.userBean.getSiteID() eq rc.rsSiteList.siteid) or session.siteid eq rc.rsSiteList.siteid >selected="selected"</cfif>>
													#esapiEncode('html', rc.rsSiteList.site)#
												</option>
											</cfloop>
										</select>
									</div>
								<cfelse>
									<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
								</cfif>

							<!--- Tags + RemoteID --->
							<div class="mura-control-group">
								<label>#rbKey('user.tags')#</label>
								<input id="tags" name="tags" type="text" value="#esapiEncode('html',rc.userBean.getTags())#">
								</div>

							<div class="mura-control-group">
								<label>#rbKey('user.remoteid')#</label>
								<input id="remoteID" name="remoteID" type="text" value="#esapiEncode('html',rc.userBean.getRemoteID())#">
							</div>

							<cfif rc.userBean.exists()>
								<cfset tokens=rc.$.getFeed('oauthtoken')
									.where()
									.prop('userID').isEQ(rc.userBean.getUserID())
									.andProp('granttype').isEQ('refresh_token')
									.getIterator()>

								<div class="mura-control-group">
									<span data-toggle="popover" title="" data-placement="right" data-content="Check to remove connection to web service." data-original-title="Web Services">
							  		Web Services <i class="mi-question-circle"></i></span>
									<cfif tokens.hasNext()>
									<cfloop condition="tokens.hasNext()">
										<cfset token=tokens.next()>
										<label for="removeToken#tokens.getCurrentIndex()#" class="checkbox"><input name="removeToken" id="removeToken#tokens.getCurrentIndex()#" type="CHECKBOX" value="#token.getToken()#" class="checkbox"> #esapiEncode('html',token.getClient().getName())#</label>
									</cfloop>
									<cfelse>
										<div class="alert alert-info"><p>This user has not connected through any web services.</p></div>
									</cfif>
								</div>
							</cfif>

						</div> <!-- /.block-content -->
					</div> <!-- /.block-bordered -->
				</div> <!-- /.tab-pane -->
				<!--- /Advanced Tab --->
			</cfoutput>

			<cfif arrayLen(pluginEventMappings)>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
						<cfset renderedEvent=$.getBean('pluginManager').renderEvent(eventToRender=pluginEventMappings[i].eventName,currentEventObject=$,index=i)>
						<cfif len(trim(renderedEvent))>
							<cfset tabLabelList=listAppend(tabLabelList,pluginEventMappings[i].pluginName)>
							<cfset tabID="tab" & $.createCSSID(pluginEventMappings[i].pluginName)>
							<cfset tabList=listAppend(tabList,tabID)>
							<cfset pluginEvent.setValue("tabList",tabLabelList)>
							<div id="#tabID#" class="tab-pane">
								<div class="block block-bordered">
									<!-- block header -->
									<div class="block-header">
								<h3 class="block-title">Plugin Settings</h3>
									</div> <!-- /.block header -->
									<div class="block-content">
								#renderedEvent#
									</div> <!-- /.block-content -->
								</div> <!-- /.block-bordered -->
							</div> <!-- /.tab-pane -->
						</cfif>
					</cfloop>
				</cfoutput>
			</cfif>
		</cfsavecontent>

		<cfoutput>
			<ul class="mura-tabs nav-tabs" data-toggle="tabs">
				<cfloop from="1" to="#listlen(tabList)#" index="t">
					<li<cfif listGetAt(tabList,t) eq 'tabExtendedattributes'> id="tabExtendedattributesLI" class="hide"<cfelseif t eq 1> class="active"</cfif>>
						<a href="###listGetAt(tabList,t)#" onclick="return false;">
							<span>#listGetAt(tabLabelList,t)#</span>
						</a>
					</li>
				</cfloop>
			</ul>

			<div class="tab-content block-content">
				#tabContent#
				<div class="load-inline tab-preloader"></div>
				<script>$('.tab-preloader').spin(spinnerArgs2);</script>

				<div class="mura-actions">
					<div class="form-actions">
						<cfif rc.userid eq '' or not rc.userBean.exists()>
							<button type="button" class="btn mura-primary" onclick="userManager.submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>#rbKey('user.add')#</button>
						<cfelse>
							<cfif not lockedSuper><button type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rbKey('user.deleteuserconfirm'))#');"><i class="mi-trash"></i>#rbKey('user.delete')#</button></cfif>
							<button type="button" class="btn mura-primary" onclick="userManager.submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>#rbKey('user.update')#</button>
						</cfif>
					</div>
				</div>

				<input type="hidden" name="type" value="2"><!--- 2=user, 1=group --->
				<cfset tempAction = (!Len(rc.userid) or not rc.userBean.exists()) ? 'Add' : 'Update' />
				<input type="hidden" name="action" value="#tempAction#">
				<input type="hidden" name="contact" value="0">
				<input type="hidden" name="groupid" value="">
				<input type="hidden" name="ContactForm" value="">
				<input type="hidden" name="returnurl" value="#buildURL(action='cUsers.listUsers', querystring='ispublic=#rc.tempIsPublic#')#">

				<cfif not rsNonDefault.recordcount>
					<input type="hidden" name="subtype" value="Default"/>
				</cfif>

				#rc.$.renderCSRFTokens(context=rc.userBean.getUserID(),format="form")#


			</div> <!-- /.block-content.tab-content -->
		</cfoutput>

	</div> <!-- /.block-constrain -->
</form>
