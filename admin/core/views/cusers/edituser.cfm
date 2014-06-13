<cfsilent>
<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfparam name="rc.activeTab" default="0" />
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

<cfset pluginEventMappings=duplicate($.getBean('pluginManager').getEventMappings(eventName='onUserEdit',siteid=rc.siteid))>
 <cfif arrayLen(pluginEventMappings)>
		<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset pluginEventMappings[i].eventName='onUserEdit'>
		</cfloop>
 </cfif>
 
<cfset tabLabelList='#rc.$.rbKey('user.basic')#,#rc.$.rbKey('user.addressinformation')#,#rc.$.rbKey('user.groupmemberships')#,#rc.$.rbKey('user.interests')#'>
<cfset tablist="tabBasic,tabAddressinformation,tabGroupmemberships,tabInterests">
<cfif rsSubTypes.recordcount>
<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.extendedattributes'))>
<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>
<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.advanced'))>
<cfset tabList=listAppend(tabList,"tabAdvanced")></cfsilent>
<cfoutput><form novalidate="novalidate" action="./?muraAction=cUsers.update&amp;userid=#URLEncodedFormat(rc.userid)#&amp;routeid=#rc.routeid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h1>#rc.$.rbKey('user.edituserform')#</h1>
	
	<div id="nav-module-specific" class="btn-group">
	<a class="btn" href="##" title="#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="icon-circle-arrow-left"></i> #HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#</a>
	</div>
	
	<cfif len(rc.userBean.getUsername())>
		<cfset strikes=createObject("component","mura.user.userstrikes").init(rc.userBean.getUsername(),application.configBean)>
		<cfif structKeyExists(rc,"removeBlock")>
			<cfset strikes.clear()>
		</cfif>
		<cfif strikes.isBlocked()>
			<p class="alert alert-error">
			#rc.$.rbKey('user.blocked')#: #LSTimeFormat(strikes.blockedUntil(),"short")#
			<a href="?muraAction=cUsers.edituser&amp;userid=#URLEncodedFormat(rc.userid)#&amp;type=2&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;removeBlock">[#rc.$.rbKey('user.remove')#]</a>
			</p>
		</cfif>
	</cfif>
	
	<cfif not structIsEmpty(rc.userBean.getErrors())>
		<p class="alert alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
	</cfif>
	
	<p>#rc.$.rbKey('user.requiredtext')#</p>
</cfoutput>	
<cfsavecontent variable="tabContent">
<cfoutput>	
<div id="tabBasic" class="tab-pane fade">	
	<div class="fieldset">
		<cfif rsNonDefault.recordcount>	
			<div class="control-group">
						<label class="control-label">#rc.$.rbKey('user.type')#</label>
					<div class="controls">
						<select name="subtype"  onchange="userManager.resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');">
						<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #rc.$.rbKey('user.default')#</option>
						<cfloop query="rsNonDefault">
							<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
						</cfloop>
					</select>
				</div>
				</div>
		</cfif>
			
		<div class="control-group">
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.fname')#*</label>
					<div class="controls">
						<input id="fname" name="fname" type="text" value="#HTMLEditFormat(rc.userBean.getfname())#"  required="true" message="#rc.$.rbKey('user.fnamerequired')#" class="span12">
					</div>
				</div>
			
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.lname')#*</label>
					<div class="controls">
							<input id="lname" name="lname" type="text" value="#HTMLEditFormat(rc.userBean.getlname())#"  required="true" message="#rc.$.rbKey('user.lnamerequired')#" class="span12">
					</div>
				</div>
			</div>
			
		<div class="control-group">
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.company')#</label>
					<div class="controls"><input id="organization" name="company" type="text" value="#HTMLEditFormat(rc.userBean.getcompany())#"  class="span12"></div>
				</div>
				
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.jobtitle')#</label>
					<div class="controls"><input id="jobtitle" name="jobtitle" type="text" value="#HTMLEditFormat(rc.userBean.getjobtitle())#"  class="span12"></div>
				</div>
		</div>
		
		<div class="control-group">
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.email')#*</label>
					<div class="controls"><input id="email" name="email" type="text" value="#HTMLEditFormat(rc.userBean.getemail())#" class="span12" required="true" validate="email" message="#rc.$.rbKey('user.emailvalidate')#"></div>
				</div>
				
			<div class="span6">
					<label class="control-label">#rc.$.rbKey('user.mobilephone')#</label>
					<div class="controls"><input id="mobilePhone" name="mobilePhone" type="text" value="#HTMLEditFormat(rc.userBean.getMobilePhone())#" class="span12"></div>
				</div>
			</div>
			
		<div class="control-group">
			<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.username')#*</label>
				<div class="controls"><input id="username"  name="usernameNoCache" type="text" value="#HTMLEditFormat(rc.userBean.getusername())#" class="span12" required="true" message="The 'Username' field is required" autocomplete="off"></div>
				</div>
		</div>
			
		<div class="control-group">
			<div class="span6">
						<label class="control-label">#rc.$.rbKey('user.newpassword')#**</label>
					<div class="controls">
						<input name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="span12"  message="#rc.$.rbKey('user.passwordmatchvalidate')#">
					</div>
				</div>
			
			<div class="span6">
						<label class="control-label">#rc.$.rbKey('user.newpasswordconfirm')#**</label>
						<div class="controls">
							<input  name="password2" autocomplete="off" type="password" value="" class="span12"  message="#rc.$.rbKey('user.passwordconfirm')#">
						</div>
				</div>
		</div>
		
		<div class="control-group">
					<label class="control-label">#rc.$.rbKey('user.image')#</label>
					<div class="controls">
						<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
					</div>
					<cfif len(rc.userBean.getPhotoFileID())>
						<div class="controls">
							<a href="./index.cfm?muraAction=cArch.imagedetails&amp;userid=#rc.userBean.getUserID()#&amp;siteid=#rc.userBean.getSiteID()#&amp;fileid=#rc.userBean.getPhotoFileID()#"><img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rc.userBean.getPhotoFileID()#&amp;cacheID=#createUUID()#" /></a>
							<label class="checkbox inline"><input type="checkbox" name="removePhotoFile" value="true"> #rc.$.rbKey('user.delete')#</label>
						</div>
					</cfif>
		</div>

	</div>

	<span id="extendSetsBasic"></span>
	
</div>

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
	
	<div class="control-group">
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.address1')#</label>
				<div class="controls"><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rc.address1)#"  class="span12"></div>
			</div>
			
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.address2')#</label>
				<div class="controls"><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rc.address2)#"  class="span12"></div>
			</div>
		</div>		

	<div class="control-group">
		<div class="span5">
				<label class="control-label">#rc.$.rbKey('user.city')#</label>
				<div class="controls"><input id="city" name="city" type="text" value="#HTMLEditFormat(rc.city)#" class="span12"></div>
			</div>
			
		<div class="span1">
				<label class="control-label">#rc.$.rbKey('user.state')#</label>
				<div class="controls"><input id="state" name="state" type="text" value="#HTMLEditFormat(rc.state)#" class="span12"></div>
			</div>
		
		<div class="span2">
				<label class="control-label">#rc.$.rbKey('user.zip')#</label>
				<div class="controls"><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rc.zip)#" class="span12"></div>
			</div>
		
		<div class="span4">
				<label class="control-label">#rc.$.rbKey('user.country')#</label>
				<div class="controls"><input id="country" name="country" type="text" value="#HTMLEditFormat(rc.country)#" class="span12"></div>
			</div>
		</div>
		
	<div class="control-group">
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.phone')#</label>
				<div class="controls"><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rc.phone)#" class="span12"></div>
			</div>	
			
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.fax')#</label>
				<div class="controls"><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rc.fax)#" class="span12"></div>
			</div> 
	</div>		
	
	<div class="control-group">
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.website')# (#rc.$.rbKey('user.includehttp')#)</label>
				<div class="controls"><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rc.addressURL)#" class="span12"></div>
			</div>
			
		<div class="span6">
				<label class="control-label">#rc.$.rbKey('user.email')#</label>
				<div class="controls"><input id="addressEmail" name="addressEmail" validate="email" message="#rc.$.rbKey('user.emailvalidate')#" type="text" value="#HTMLEditFormat(rc.addressEmail)#" class="span12"></div>
			</div>
	</div>
		
	<div class="control-group">
			<label class="control-label">#rc.$.rbKey('user.hours')#</label>
			<div class="controls"><textarea id="hours" name="hours" rows="6" class="span6" >#HTMLEditFormat(rc.hours)#</textarea></div>
		</div>

	<input type="hidden" name="isPrimary" value="1" />
		
	<cfelse>
		<div class="control-group">
			<ul class="navTask nav nav-pills"><li><a href="./?muraAction=cUsers.editAddress&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;routeID=#rc.routeid#&amp;addressID="><i class="icon-plus-sign"></i> #rc.$.rbKey('user.addnewaddress')#</a></li></ul>
			<cfset rsAddresses=rc.userBean.getAddresses()>
		
			<cfif rsAddresses.recordcount>
				<table class="mura-table-grid">
				<tr><th>#rc.$.rbKey('user.primary')#</th><th>#rc.$.rbKey('user.address')#</th><th class="adminstration"></th></tr>
				<cfloop query="rsAddresses">
				<tr>
					<td>
					<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
					</td>
					<td class="var-width">
					<cfif rsAddresses.addressName neq ''><a title="#rc.$.rbKey('user.edit')#" href="./?muraAction=cUsers.editAddress&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;routeID=#URLEncodedFormat(rc.routeid)#&amp;addressID=#rsAddresses.addressID#">#rsAddresses.addressName#</a><br /></cfif>
					<cfif rsAddresses.address1 neq ''>#HTMLEditFormat(rsAddresses.address1)#<br /></cfif>
					<cfif rsAddresses.address2 neq ''>#HTMLEditFormat(rsAddresses.address2)#<br /></cfif>
					<cfif rsAddresses.city neq ''>#HTMLEditFormat(rsAddresses.city)# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #HTMLEditFormat(rsAddresses.state)# </cfif><cfif rsaddresses.zip neq ''> #HTMLEditFormat(rsAddresses.zip)#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
					<cfif rsAddresses.phone neq ''>#rc.$.rbKey('user.phone')#: #HTMLEditFormat(rsAddresses.phone)#<br/></cfif>
					<cfif rsAddresses.fax neq ''>#rc.$.rbKey('user.fax')#: #HTMLEditFormat(rsAddresses.fax)#<br/></cfif>
					<cfif rsAddresses.addressURL neq ''>#rc.$.rbKey('user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#HTMLEditFormat(rsAddresses.addressURL)#</a><br/></cfif>
					<cfif rsAddresses.addressEmail neq ''>#rc.$.rbKey('user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#HTMLEditFormat(rsAddresses.addressEmail)#</a></cfif>
					</td>
					<td nowrap class="actions"><ul class="users"><li class="edit"><a title="#rc.$.rbKey('user.edit')#" href="./?muraAction=cUsers.editAddress&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;routeID=#rc.routeid#&amp;addressID=#rsAddresses.addressID#"><i class="icon-pencil"></i></a></li>
					<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="./?muraAction=cUsers.updateAddress&amp;userid=#URLEncodedFormat(rc.userid)#&amp;action=delete&amp;siteid=#URLEncodedFormat(rc.siteid)#&amp;routeID=#URLEncodedFormat(rc.routeid)#&amp;addressID=#rsAddresses.addressID#" onclick="return confirmDialog('#jsStringFormat(rc.$.rbKey('user.deleteaddressconfirm'))#',this.href);"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled">#rc.$.rbKey('user.delete')#</li></cfif></ul></td>
				</tr>
				</cfloop>
				</table>
			<cfelse>
				<em>#rc.$.rbKey('user.noaddressinformation')#</em>
			</cfif>
		</div>	
	</cfif>
</div>
</div>

<!--- Group Memberships --->
	<div id="tabGroupmemberships" class="tab-pane fade">
		<div class="fieldset">
				
			<!--- Private Groups --->
				<cfif not rc.userBean.getIsPublic()>
					<div class="control-group">
						<label class="control-label">
							#rc.$.rbKey('user.admingroups')#
						</label>
						<div class="controls">
							<cfloop query="rc.rsPrivateGroups">
								<label class="checkbox">
									<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPrivateGroups.UserID) or listfind(rc.groupid,rc.rsPrivateGroups.UserID)>checked</cfif>>
									#rc.rsPrivateGroups.groupname#
								</label>
							</cfloop>
						</div>
					</div>
				</cfif>
				
			<!--- Public Groups --->
				<cfif rc.rsPublicGroups.recordcount>
					<div class="control-group">
						<label class="control-label">
							#rc.$.rbKey('user.membergroups')#
						</label>
						<div class="controls">
							<cfloop query="rc.rsPublicGroups">
								<label class="checkbox">
									<input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPublicGroups.UserID) or listfind(rc.groupid,rc.rsPublicGroups.UserID)>checked</cfif>>
										#rc.rsPublicGroups.site# - #rc.rsPublicGroups.groupname#
								</label>
							</cfloop>
						</div>
					</div>
				</cfif>

		</div>
	</div>

<!--- Interests --->
<div id="tabInterests" class="tab-pane fade">
	<div class="fieldset">
		<div id="mura-list-tree" class="control-group">
			<cfloop collection="#application.settingsManager.getSites()#" item="site">
				<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
						<cfoutput><label class="control-label">#application.settingsManager.getSite(site).getSite()#</label></cfoutput>
						<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" categoryID="#rc.categoryID#" nestLevel="0"  userBean="#rc.userBean#">
				</cfif>
			</cfloop> 
		</div>
	</div>
</div>
	
<cfif rsSubTypes.recordcount>
<div id="tabExtendedattributes" class="tab-pane fade">
		<span id="extendSetsDefault"></span>
		<script type="text/javascript">
		userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#userPoolID#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');
		</script>	
</div>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
</cfif>

<div id="tabAdvanced" class="tab-pane fade">
<div class="fieldset">

	<div class="control-group">
		<cfif listFind(session.mura.memberships,'S2')>
		<div class="span6">
			 <label class="control-label">#rc.$.rbKey('user.superadminaccount')#</label>
			 <div class="controls">
				<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="1" <cfif rc.userBean.gets2() eq 1>Checked</cfif>>#rc.$.rbKey('user.yes')#</label>
				<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="0" <cfif rc.userBean.gets2() eq 0>Checked</cfif>>
					#rc.$.rbKey('user.no')#
					</label>
					</div>
				</div>
		</cfif>
		
		<div class="span6">
			 <label class="control-label">#rc.$.rbKey('user.emailbroadcaster')#</label>
			 <div class="controls">
				<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>Yes</label>
				<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>No</label>
			 </div>
			 </div>
			</div>
		
		<div class="control-group">
			<!--- Active --->
				<div class="span6">
					<label class="control-label">
						#rc.$.rbKey('user.inactive')#
					</label>
					<div class="controls">
						<label class="radio inline">
							<input name="InActive" type="radio" class="radio inline" value="0"<cfif rc.userBean.getInActive() eq 0 >Checked</cfif>> 
							#rc.$.rbKey('user.yes')#
						</label>
						<label class="radio inline"><input name="InActive" type="radio" class="radio inline" value="1"<cfif rc.userBean.getInActive() eq 1 >Checked</cfif>> 
							#rc.$.rbKey('user.no')#
						</label>
					</div>
				</div>
		
			<!--- IsPublic --->
				<div class="span6">
					<label class="control-label">
						#rc.$.rbKey('user.usertype')#
					</label>

					<div class="controls">
						<label class="radio inline">
							<input name="isPublic" type="radio" class="radio inline" value="1"<cfif rc.userBean.getIsPublic()> Checked</cfif>> 
							#rc.$.rbKey('user.sitemember')#
						</label>

						<label class="radio inline">
							<input name="isPublic" type="radio" class="radio inline" value="0"<cfif not rc.userBean.getIsPublic()> Checked</cfif>> 
							#rc.$.rbKey('user.adminuser')#
						</label>
					</div>
				</div>
		</div>
		
		<div class="control-group">
			<div class="span6">
				 <label class="control-label">#rc.$.rbKey('user.tags')#</label>
				 <div class="controls"><input id="tags" name="tags" type="text" value="#HTMLEditFormat(rc.userBean.getTags())#" class="span12"></div>
				 </div>
			<div class="span6">
				 <label class="control-label">#rc.$.rbKey('user.remoteid')#</label>
				<div class="controls"><input id="remoteID" name="remoteID" type="text" value="#HTMLEditFormat(rc.userBean.getRemoteID())#"  class="span12"></div>
			</div>
		</div>
</div>		
</div>
</cfoutput>
<cfif arrayLen(pluginEventMappings)>
	<cfoutput>
	<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
		<cfset renderedEvent=$.getBean('pluginManager').renderEvent(eventToRender=pluginEventMappings[i].eventName,currentEventObject=$,index=i)>
		<cfif len(trim(renderedEvent))>
			<cfset tabLabelList=listAppend(tabLabelList,pluginEventMappings[i].pluginName)/>
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
<li<cfif listGetAt(tabList,t) eq 'tabExtendedattributes'> id="tabExtendedattributesLI" class="hide"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div class="tab-content">
#tabContent#
<div class="load-inline tab-preloader"></div>
<script>$('.tab-preloader').spin(spinnerArgs2);</script>
<div class="form-actions">
	<cfif rc.userid eq ''>
		<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#rc.$.rbKey('user.add')#" />
		<cfelse>
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rc.$.rbKey('user.deleteuserconfirm'))#');" value="#rc.$.rbKey('user.delete')#" /> 
		<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#rc.$.rbKey('user.update')#" />
	</cfif>
</div>
</div>
</div>
	
<input type="hidden" name="type" value="2">
<input type="hidden" name="action" value="">
<input type="hidden" name="contact" value="0">
<input type="hidden" name="groupid" value="">
<input type="hidden" name="ContactForm" value="">
<input type="hidden" name="returnurl" value="#HTMLEditFormat(rc.returnurl)#">
<cfif not rsNonDefault.recordcount><input type="hidden" name="subtype" value="Default"/></cfif>
</cfoutput>

</form>