<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=1,siteid=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>

<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

<cfset pluginEventMappings=duplicate($.getBean('pluginManager').getEventMappings(eventName='onGroupEdit',siteid=rc.siteid))>
 <cfif arrayLen(pluginEventMappings)>
		<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset pluginEventMappings[i].eventName='onGroupEdit'>
		</cfloop>
 </cfif>

<cfset tabLabelList='#rc.$.rbKey('user.basic')#'>
<cfset tablist="tabBasic">
<cfif rsSubTypes.recordcount>
	<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.extendedattributes'))>
	<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>

<!--- Header --->
	<cfoutput>
		<h1>#rc.$.rbKey('user.groupform')#</h1>
		<div id="nav-module-specific" class="btn-group">
			<a class="btn" href="##" title="#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#" onclick="window.history.back(); return false;">
				<i class="icon-circle-arrow-left"></i> 
				#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#
			</a>

			<a class="btn" href="#buildURL(action='cusers.list')#">
				<i class="icon-eye-open"></i>
				View All Groups
			</a>

			<cfif !rc.userBean.getIsNew()>
				<a class="btn" href="#buildURL(action='cusers.editgroupmembers', querystring='userid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#')#">
					<i class="icon-group"></i>
					View Group Users
				</a>
			</cfif>
		</div>
	</cfoutput>

<!--- Edit Form --->
	<cfoutput>
		<cfif not structIsEmpty(rc.userBean.getErrors())>
			<p class="alert  alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
		</cfif>

		<form novalidate="novalidate"<cfif not (rsSubTypes.recordcount or arrayLen(pluginEventMappings))> class="fieldset-wrap"</cfif> action="./?muraAction=cUsers.update&amp;userid=#URLEncodedFormat(rc.userid)#" enctype="multipart/form-data" method="post" name="form1" onsubmit="return validate(this);">
	</cfoutput>

		<cfif rsSubTypes.recordcount or arrayLen(pluginEventMappings)>
			<div class="tabbable tabs-left mura-ui">
				<ul class="nav nav-tabs tabs initActiveTab">
					<cfoutput>
						<li>
							<a href="##tabBasic" onclick="return false;"><span>#HTMLEditFormat(rc.$.rbKey('user.basic'))#</span></a>
						</li>
						<cfif rsSubTypes.recordcount>
							<li id="tabExtendedattributesLI" class="hide">
								<a href="##tabExtendedattributes" onclick="return false;">
									<span>#HTMLEditFormat(rc.$.rbKey('user.extendedattributes'))#</span>
								</a>
							</li>
						</cfif>
					</cfoutput>
					<cfif arrayLen(pluginEventMappings)>
						<cfoutput>
							<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
								<cfset tabID="tab" & $.createCSSID(pluginEventMappings[i].pluginName)>
								<li id="###tabID#LI">
									<a href="###tabID#" onclick="return false;">
										<span>#HTMLEditFormat(pluginEventMappings[i].pluginName)#</span>
									</a>
								</li>
							</cfloop>
						</cfoutput>
					</cfif>
				</ul>

				<div class="tab-content">
					<div id="tabBasic" class="tab-pane fade">
		</cfif>

		<cfoutput>
			<div class="fieldset">
				<cfif rsNonDefault.recordcount>
					<div class="control-group">
						<label class="control-label">
							#rc.$.rbKey('user.type')#
						</label>
						<div class="controls">
							<select name="subtype" onchange="userManager.resetExtendedAttributes('#rc.userBean.getUserID()#','1',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
								<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>>
									#rc.$.rbKey('user.default')#
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

				<div class="control-group">
					<div class="span6">
						<label class="control-label">
							#rc.$.rbKey('user.groupname')#
						</label>
						<div class="controls">
							<input type="text" class="span12" name="groupname" value="#HTMLEditFormat(rc.userBean.getgroupname())#" required="true" message="#rc.$.rbKey('user.groupnamerequired')#" <cfif rc.userbean.getPerm()>readonly="readonly"</cfif>>
						</div>
					</div>

					<div class="span6">
						<label class="control-label">
							<!--- #rc.$.rbKey('user.email')# --->
							Group Email
						</label>
						<div class="controls">
							<input type="text" class="span12" name="email" value="#HTMLEditFormat(rc.userBean.getemail())#">
						</div>
					</div>
				</div>

				<cfif not rc.userbean.getperm()>
					<div class="control-group">

						<div class="span6">
							<label class="control-label">
								#rc.$.rbKey('user.tablist')#
							</label>
							<div class="controls">
								<select name="tablist" multiple="true" class="span12">
									<option value=""<cfif not len(rc.userBean.getTablist())> selected</cfif>>All</option>
									<cfloop list="#application.contentManager.getTabList()#" index="t">
										<option value="#t#"<cfif listFindNoCase(rc.userBean.getTablist(),t)> selected</cfif>>
											#rc.$.rbKey("sitemanager.content.tabs.#REreplace(t, "[^\\\w]", "", "all")#")#
										</option>
									</cfloop>
								</select>
							</div>
						</div>

						<cfif true>
							<div class="span6">
								<label class="control-label">
									Group Type
								</label>
								<div class="controls">
									<label class="radio inline">
										<input name="isPublic" type="radio" class="radio inline" value="1" <cfif rc.userBean.getIsPublic() eq 1>Checked</cfif>>
										Member Group
									</label>
									<label class="radio inline">
										<input name="isPublic" type="radio" class="radio inline" value="0" <cfif rc.userBean.getIsPublic() eq 0>Checked</cfif>>
											System Group
									</label>
								</div>
							</div>
						<cfelse>
							<input type="hidden" name="isPublic" value="1" />
						</cfif>

					</div>
				</cfif>
			</div>

			<span id="extendSetsBasic"></span>
		</cfoutput>

		<cfif rsSubTypes.recordcount or arrayLen(pluginEventMappings)>
			</div>

			<cfif rsSubTypes.recordcount>
				<div id="tabExtendedattributes" class='tab-pane'>
					<span id="extendSetsDefault"></span>
				</div>
			</cfif>

			<cfif arrayLen(pluginEventMappings)>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
						<cfset tabLabelList=listAppend(tabLabelList,pluginEventMappings[i].pluginName)/>
						<cfset tabID="tab" & $.createCSSID(pluginEventMappings[i].pluginName)>
						<cfset tabList=listAppend(tabList,tabID)>
						<cfset pluginEvent.setValue("tabList",tabLabelList)>
						<div id="#tabID#" class="tab-pane fade">
							#$.getBean('pluginManager').renderEvent(eventToRender=pluginEventMappings[i].eventName,currentEventObject=$,index=i)#
						</div>
					</cfloop>
				</cfoutput>
			</cfif>

			<cfoutput>
						<div class="form-actions">
							<cfif rc.userid eq ''>
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#rc.$.rbKey('user.add')#" />
							<cfelse>
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rc.$.rbKey('user.deletegroupconfirm'))#');" value="#rc.$.rbKey('user.delete')#" />
								<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#rc.$.rbKey('user.update')#" />
							</cfif>
							<input type="hidden" name="action" value="">
							<input type="hidden" name="type" value="1">
							<input type="hidden" name="contact" value="0">
							<cfif rc.userbean.getPerm()>
								<input type="hidden" name="isPublic" value="0">
							</cfif>
							<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
							<cfif not rsNonDefault.recordcount>
								<input type="hidden" name="subtype" value="Default"/>
							</cfif>
						</div> 
					</div>
				</div>
						
				<cfif rsSubTypes.recordcount>
					<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
					<script type="text/javascript">
						userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','1','#rc.userbean.getSubType()#','#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#'); 
					</script>
				</cfif>
			</cfoutput>
		<cfelse>
			<cfoutput>
				<div class="form-actions">
					<cfif rc.userid eq ''>
						<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#rc.$.rbKey('user.add')#" />
					<cfelse>
						<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rc.$.rbKey('user.deletegroupconfirm'))#');" value="#rc.$.rbKey('user.delete')#" />
						<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#rc.$.rbKey('user.update')#" />
					</cfif>
					<input type="hidden" name="action" value="">
					<input type="hidden" name="type" value="1"><!--- 1=group, 2=user --->
					<input type="hidden" name="contact" value="0">
					<cfif rc.userbean.getPerm()>
						<input type="hidden" name="isPublic" value="0">
					</cfif>
					<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
					<input type="hidden" name="returnurl" value="#HTMLEditFormat(rc.returnurl)#">
					<cfif not rsNonDefault.recordcount>
						<input type="hidden" name="subtype" value="Default"/>
					</cfif>
				</div>
			</cfoutput>
		</cfif>

	</form>
<!--- /Edit Form --->