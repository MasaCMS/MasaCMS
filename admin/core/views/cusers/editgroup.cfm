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

						<!--- 
							Group Type
							** Only allow 'Admin' or Super Users to modify Group Types
						--->
						<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') OR ListFind(session.mura.memberships,'S2')>
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
							<input type="hidden" name="isPublic" value="1">
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