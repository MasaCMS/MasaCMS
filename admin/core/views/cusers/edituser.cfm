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
<cfhtmlhead text="#session.dateKey#" />
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
	</cfscript>
</cfsilent>

<cfoutput>
	<form novalidate="novalidate" action="#buildURL(action='cUsers.update', querystring='userid=#rc.userBean.getUserID()#&routeid=#rc.routeid#')#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);" autocomplete="off">

		<h1>#rbKey('user.usermaintenanceform')#</h1>
		
		<div id="nav-module-specific" class="btn-group">
			<a class="btn" href="##" title="#esapiEncode('html',rbKey('sitemanager.back'))#" onclick="actionModal();window.history.back(); return false;">
				<i class="icon-circle-arrow-left"></i> #esapiEncode('html',rbKey('sitemanager.back'))#
			</a>
		</div>
		
		<cfif len(rc.userBean.getUsername())>
			<cfset strikes=createObject("component","mura.user.userstrikes").init(rc.userBean.getUsername(),application.configBean)>
			<cfif structKeyExists(rc,"removeBlock")>
				<cfset strikes.clear()>
			</cfif>
			<cfif strikes.isBlocked()>
				<p class="alert alert-error">
					#rbKey('user.blocked')#: #LSTimeFormat(strikes.blockedUntil(),"short")#
					<a href="?muraAction=cUsers.edituser&amp;userid=#esapiEncode('url',rc.userid)#&amp;type=2&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;removeBlock">[#rbKey('user.remove')#]</a>
				</p>
			</cfif>
		</cfif>
		
		<cfif not structIsEmpty(rc.userBean.getErrors())>
			<p class="alert alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
		</cfif>
		
		<p>#rbKey('user.requiredtext')#</p>
		</cfoutput>

		<cfsavecontent variable="tabContent">
			<cfoutput>

				<!--- Basic Tab --->
					<div id="tabBasic" class="tab-pane fade">
						<div class="fieldset">

							<!--- Subtype --->
							<cfif rsNonDefault.recordcount>
								<div class="control-group">
									<label class="control-label">#rbKey('user.type')#</label>
									<div class="controls">
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
								</div>
							</cfif>

							<!--- Name --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label" for="fname">#rbKey('user.fname')#*</label>
									<div class="controls">
										<input id="fname" name="fname" type="text" value="#esapiEncode('html',rc.userBean.getfname())#"  required="true" message="#rbKey('user.fnamerequired')#" class="span12">
									</div>
								</div>
						
								<div class="span6">
									<label class="control-label" for="lname">#rbKey('user.lname')#*</label>
									<div class="controls">
										<input id="lname" name="lname" type="text" value="#esapiEncode('html',rc.userBean.getlname())#"  required="true" message="#rbKey('user.lnamerequired')#" class="span12">
									</div>
								</div>
							</div>
						
							<!--- Company + Title --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label" for="organization">#rbKey('user.company')#</label>
									<div class="controls">
										<input id="organization" name="company" type="text" value="#esapiEncode('html',rc.userBean.getcompany())#"  class="span12">
									</div>
								</div>

								<div class="span6">
									<label class="control-label" for="jobtitle">#rbKey('user.jobtitle')#</label>
									<div class="controls">
										<input id="jobtitle" name="jobtitle" type="text" value="#esapiEncode('html',rc.userBean.getjobtitle())#"  class="span12">
									</div>
								</div>
							</div>
					
							<!--- Email + Phone --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label" for="email">#rbKey('user.email')#*</label>
									<div class="controls">
										<input id="email" name="email" type="text" value="#esapiEncode('html',rc.userBean.getemail())#" class="span12" required="true" validate="email" message="#rbKey('user.emailvalidate')#">
									</div>
								</div>
							
								<div class="span6">
									<label class="control-label" for="mobilePhone">#rbKey('user.mobilephone')#</label>
									<div class="controls">
										<input id="mobilePhone" name="mobilePhone" type="text" value="#esapiEncode('html',rc.userBean.getMobilePhone())#" class="span12">
									</div>
								</div>
							</div>
						
							<!--- Username --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label" for="username">#rbKey('user.username')#*</label>
									<div class="controls">
										<input id="username"  name="usernameNoCache" type="text" value="#esapiEncode('html',rc.userBean.getusername())#" class="span12" required="true" message="The 'Username' field is required" autocomplete="off">
									</div>
								</div>
							</div>
						
							<!--- Password --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label" for="passwordNoCache">#rbKey('user.newpassword')#**</label>
									<div class="controls">
										<input id="passwordNoCache" name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="span12"  message="#rbKey('user.passwordmatchvalidate')#">
									</div>
								</div>
								
								<div class="span6">
									<label class="control-label" for="password2">#rbKey('user.newpasswordconfirm')#**</label>
									<div class="controls">
										<input id="password2" name="password2" autocomplete="off" type="password" value="" class="span12"  message="#rbKey('user.passwordconfirm')#">
									</div>
								</div>
							</div>
					
							<!--- Image --->
							<div class="control-group">
								<label class="control-label" for="newFile">#rbKey('user.image')#</label>
								<div class="controls">
									<input type="file" id="newFile" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
								</div>
								<cfif len(rc.userBean.getPhotoFileID())>
									<div class="controls">
										<a href="./index.cfm?muraAction=cArch.imagedetails&amp;userid=#rc.userBean.getUserID()#&amp;siteid=#rc.userBean.getSiteID()#&amp;fileid=#rc.userBean.getPhotoFileID()#">
											<img id="assocImage" src="#application.configBean.getContext()#/index.cfm/_api/render/medium/?fileid=#rc.userBean.getPhotoFileID()#&amp;cacheID=#createUUID()#" />
										</a>
										<label class="checkbox inline">
											<input type="checkbox" name="removePhotoFile" value="true"> 
											#rbKey('user.delete')#
										</label>
									</div>
								</cfif>
							</div>
						</div>
						<!--- /fieldset --->

						<span id="extendSetsBasic"></span>
					</div>
				<!--- /Basic Tab --->

				<!--- Address Tab --->
					<div id="tabAddressinformation" class="tab-pane fade">
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
						<div class="fieldset">	
							<cfif rc.userid eq ''>

								<!--- Address1 + Address2 --->
								<div class="control-group">
									<div class="span6">
										<label class="control-label">#rbKey('user.address1')#</label>
										<div class="controls">
											<input id="address1" name="address1" type="text" value="#esapiEncode('html',rc.address1)#"  class="span12">
										</div>
									</div>
										
									<div class="span6">
										<label class="control-label">#rbKey('user.address2')#</label>
										<div class="controls">
											<input id="address2" name="address2" type="text" value="#esapiEncode('html',rc.address2)#"  class="span12">
										</div>
									</div>
								</div>		

								<!--- City, State, Zip, Country --->
								<div class="control-group">
									<div class="span5">
										<label class="control-label">#rbKey('user.city')#</label>
										<div class="controls">
											<input id="city" name="city" type="text" value="#esapiEncode('html',rc.city)#" class="span12">
										</div>
									</div>
										
									<div class="span1">
										<label class="control-label">#rbKey('user.state')#</label>
										<div class="controls">
											<input id="state" name="state" type="text" value="#esapiEncode('html',rc.state)#" class="span12">
										</div>
									</div>
									
									<div class="span2">
										<label class="control-label">#rbKey('user.zip')#</label>
										<div class="controls">
											<input id="zip" name="zip" type="text" value="#esapiEncode('html',rc.zip)#" class="span12">
										</div>
									</div>
									
									<div class="span4">
										<label class="control-label">#rbKey('user.country')#</label>
										<div class="controls">
											<input id="country" name="country" type="text" value="#esapiEncode('html',rc.country)#" class="span12">
										</div>
									</div>
								</div>
				
								<!--- Phone + Fax --->
								<div class="control-group">
									<div class="span6">
										<label class="control-label">#rbKey('user.phone')#</label>
										<div class="controls">
											<input id="phone" name="phone" type="text" value="#esapiEncode('html',rc.phone)#" class="span12">
										</div>
									</div>	
										
									<div class="span6">
										<label class="control-label">#rbKey('user.fax')#</label>
										<div class="controls">
											<input id="fax" name="fax" type="text" value="#esapiEncode('html',rc.fax)#" class="span12">
										</div>
									</div> 
								</div>		
				
								<!---URL + Email --->
								<div class="control-group">
									<div class="span6">
										<label class="control-label">#rbKey('user.website')# (#rbKey('user.includehttp')#)</label>
										<div class="controls">
											<input id="addressURL" name="addressURL" type="text" value="#esapiEncode('html',rc.addressURL)#" class="span12">
										</div>
									</div>
										
									<div class="span6">
										<label class="control-label">#rbKey('user.email')#</label>
										<div class="controls">
											<input id="addressEmail" name="addressEmail" validate="email" message="#rbKey('user.emailvalidate')#" type="text" value="#esapiEncode('html',rc.addressEmail)#" class="span12">
										</div>
									</div>
								</div>

								<!--- Hours --->
								<div class="control-group">
									<label class="control-label">#rbKey('user.hours')#</label>
									<div class="controls">
										<textarea id="hours" name="hours" rows="6" class="span6" >#esapiEncode('html',rc.hours)#</textarea>
									</div>
								</div>

								<input type="hidden" name="isPrimary" value="1" />

							<cfelse>

								<!--- Add Address --->
								<div class="control-group">
									<ul class="navTask nav nav-pills">
										<li>
											<a href="./?muraAction=cUsers.editAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#rc.routeid#&amp;addressID=">
												<i class="icon-plus-sign"></i> #rbKey('user.addnewaddress')#
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
																	<i class="icon-pencil"></i>
																</a>
															</li>
															<cfif rsAddresses.isPrimary neq 1>
																<li class="icon-remove-sign">
																	<a title="Delete" href="./?muraAction=cUsers.updateAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;action=delete&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;routeID=#esapiEncode('url',rc.routeid)#&amp;addressID=#rsAddresses.addressID#" onclick="return confirmDialog('#jsStringFormat(rbKey('user.deleteaddressconfirm'))#',this.href);">
																		<i class="icon-remove-sign"></i>
																	</a>
																</li>
															<cfelse>
																<li class="icon-remove-sign"></li>
															</cfif>
														</ul>
													</td>
												</tr>
											</cfloop>
										</table>
									<cfelse>
										<em>#rbKey('user.noaddressinformation')#</em>
									</cfif>
								</div>
								<!--- /Add Address --->

							</cfif>
						</div>
						<!--- /fieldset --->
					</div>
				<!--- /Address Tab --->

				<!--- Group Memberships Tab --->
					<div id="tabGroupmemberships" class="tab-pane fade">
						<div class="fieldset">
							<!--- 
								User Type 
								** Must be an 'Admin' or Super User to modify User Type
							--->
							<cfif rc.isAdmin>
								<div class="control-group">
									<label class="control-label">
										#rbKey('user.usertype')#
									</label>

									<div class="controls">
										<label class="radio inline">
											<input name="isPublic" type="radio" class="radio inline" value="1"<cfif rc.tempIsPublic> Checked</cfif>> 
											#rbKey('user.sitemember')#
										</label>

										<label class="radio inline">
											<input name="isPublic" type="radio" class="radio inline" value="0"<cfif not rc.tempIsPublic> Checked</cfif>> 
											#rbKey('user.adminuser')#
										</label>
									</div>
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
									<div id="privateGroupsList" class="control-group"<cfif rc.tempIsPublic> style="display:none"</cfif>>
										<label class="control-label">
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
											<div id="privateGroupsNotice" class="controls">
												<p class="alert alert-notice">
													#rbKey('user.systemgroupmessage')#
												</p>
											</div>
										</cfif>
										--->
										<div class="controls">
											<cfif rc.rsPrivateGroups.recordcount>
												<cfloop query="rc.rsPrivateGroups">
													<label class="checkbox">
														<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPrivateGroups.UserID) or Listfind(rc.groupid,rc.rsPrivateGroups.UserID)>checked</cfif>>
														#rc.rsPrivateGroups.groupname#
													</label>
												</cfloop>
											<cfelse>
												<p class="alert alert-notice">
													#rbKey('user.nogroups')#
												</p>
											</cfif>
										</div>
									</div>
								</cfif>
								
							<!--- Public Groups --->
							<div class="control-group">
								<label class="control-label">
									#rbKey('user.membergroups')#
								</label>
								<div class="controls">
									<cfif rc.rsPublicGroups.recordcount>
										<cfloop query="rc.rsPublicGroups">
											<label class="checkbox">
												<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPublicGroups.UserID) or listfind(rc.groupid,rc.rsPublicGroups.UserID)>checked</cfif>>
													#rc.rsPublicGroups.site# - #rc.rsPublicGroups.groupname#
											</label>
										</cfloop>
									<cfelse>
										<p class="alert alert-notice">
											#rbKey('user.nogroups')#
										</p>
									</cfif>
								</div>
							</div>
						</div>
					</div>
				<!--- /Group Memberships Tab --->

				<!--- Interests Tab --->
					<div id="tabInterests" class="tab-pane fade">
						<div class="fieldset">
							<div id="mura-list-tree" class="control-group">

								<cf_dsp_categories_nest 
									siteID="#rc.siteID#" 
									parentID="" 
									categoryID="#rc.categoryID#" 
									nestLevel="0" 
									userBean="#rc.userBean#">

							</div>
						</div>
					</div>
				<!--- /Interests Tab --->

				<!--- Extended Attributes Tab --->
					<cfif rsSubTypes.recordcount>
						<div id="tabExtendedattributes" class="tab-pane fade">
							<span id="extendSetsDefault"></span>
							<script type="text/javascript">
								userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#userPoolID#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');
							</script>	
						</div>
						<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
					</cfif>
				<!--- /Extended Attributes Tab --->

				<!--- Advanced Tab --->
					<div id="tabAdvanced" class="tab-pane fade">
						<div class="fieldset">

							<!--- Super Admin + Email Broadcaster --->
							<div class="control-group">
								<cfif rc.$.currentUser().isSuperUser()>
									<div class="span6">
										<label class="control-label">
											#rbKey('user.superadminaccount')#
										</label>
										<div class="controls">
											<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="1" <cfif rc.userBean.gets2() eq 1>Checked</cfif>>
												#rbKey('user.yes')#
											</label>
											<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="0" <cfif rc.userBean.gets2() eq 0>Checked</cfif>>
												#rbKey('user.no')#
											</label>
										</div>
									</div>
								</cfif>
					
								<div class="span6">
									<label class="control-label">#rbKey('user.emailbroadcaster')#</label>
									<div class="controls">
										<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>
											#rbKey('user.yes')#
										</label>
										<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>
											#rbKey('user.no')#
										</label>
									</div>
								</div>
							</div>
			
							<!--- Active + User Type --->
							<div class="control-group">
								<!--- Active --->							
								<div class="span6">
									<label class="control-label">
										#rbKey('user.inactive')#
									</label>
									<div class="controls">
										<label class="radio inline">
											<input name="InActive" type="radio" class="radio inline" value="0"<cfif rc.userBean.getInActive() eq 0 >Checked</cfif>> 
											#rbKey('user.yes')#
										</label>
										<label class="radio inline"><input name="InActive" type="radio" class="radio inline" value="1"<cfif rc.userBean.getInActive() eq 1 >Checked</cfif>> 
											#rbKey('user.no')#
										</label>
									</div>
								</div>

								<!--- SiteID --->
								<cfif rc.$.currentUser().isSuperUser()>
									<div class="span6">
										<label class="control-label">
											#rbKey('user.site')#
										</label>
										<select name="siteid">
											<cfloop query="rc.rsSiteList">
												<option value="#esapiEncode('html_attr', siteid)#" <cfif (rc.userBean.exists() and rc.userBean.getSiteID() eq siteid) or session.siteid eq siteid >selected="selected"</cfif>>
													#esapiEncode('html', site)#
												</option>
											</cfloop>
										</select>
									</div>
								<cfelse>
									<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
								</cfif>
							</div>

							<!--- Tags + RemoteID --->
							<div class="control-group">
								<div class="span6">
									<label class="control-label">#rbKey('user.tags')#</label>
									<div class="controls">
										<input id="tags" name="tags" type="text" value="#esapiEncode('html',rc.userBean.getTags())#" class="span12">
									</div>
								</div>

								<div class="span6">
									<label class="control-label">#rbKey('user.remoteid')#</label>
									<div class="controls">
										<input id="remoteID" name="remoteID" type="text" value="#esapiEncode('html',rc.userBean.getRemoteID())#"  class="span12">
									</div>
								</div>
							</div>

						</div>
						<!--- /fieldset --->
					</div>
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
							<div id="#tabID#" class="tab-pane fade">
								#renderedEvent#
							</div>
						</cfif>
					</cfloop>
				</cfoutput>
			</cfif>
		</cfsavecontent>

		<cfoutput>
			<div class="tabbable tabs-left mura-ui">

				<ul class="nav nav-tabs tabs initActiveTab">
					<cfloop from="1" to="#listlen(tabList)#" index="t">
						<li<cfif listGetAt(tabList,t) eq 'tabExtendedattributes'> id="tabExtendedattributesLI" class="hide"</cfif>>
							<a href="###listGetAt(tabList,t)#" onclick="return false;">
								<span>#listGetAt(tabLabelList,t)#</span>
							</a>
						</li>
					</cfloop>
				</ul>

				<!--- Buttons: Add, Delete, Update --->
					<div class="tab-content">
						#tabContent#
						<div class="load-inline tab-preloader"></div>
						<script>$('.tab-preloader').spin(spinnerArgs2);</script>
						<div class="form-actions">
							<cfif rc.userid eq ''>
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#rbKey('user.add')#" />
							<cfelse>
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rbKey('user.deleteuserconfirm'))#');" value="#rbKey('user.delete')#" /> 
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#rbKey('user.update')#" />
							</cfif>
						</div>
					</div>
				<!--- /Buttons --->
			</div>
			
			<input type="hidden" name="type" value="2"><!--- 2=user, 1=group --->
			<cfset tempAction = !Len(rc.userid) ? 'Add' : 'Update' />
			<input type="hidden" name="action" value="#tempAction#">
			<input type="hidden" name="contact" value="0">
			<input type="hidden" name="groupid" value="">
			<input type="hidden" name="ContactForm" value="">
			<input type="hidden" name="returnurl" value="#buildURL(action='cUsers.listUsers', querystring='ispublic=#rc.tempIsPublic#')#">

			<cfif not rsNonDefault.recordcount>
				<input type="hidden" name="subtype" value="Default"/>
			</cfif>

			#rc.$.renderCSRFTokens(context=rc.userBean.getUserID(),format="form")#
		</cfoutput>
	</form>