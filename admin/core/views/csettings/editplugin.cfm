<!--- This file is part of Mura CMS.

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
<cfsilent>
	<cfhtmlhead text="#session.dateKey#">
	<cfset rsPlugin=application.pluginManager.getPlugin(rc.moduleID)>
	<cfif structKeyExists(rc.pluginXML.plugin,"package") and len(rc.pluginXML.plugin.package.xmlText)>
		<cfset package=rc.pluginXML.plugin.package.xmlText>
	<cfelse>
		<cfset package="">
	</cfif>
</cfsilent>
<cfoutput>

	<h1>Plugin Settings</h1>

	<ul class="metadata">
		<li><strong>Name:</strong> #esapiEncode('html',rc.pluginXML.plugin.name.xmlText)#</li>
		<li><strong>Category:</strong> #esapiEncode('html',rc.pluginXML.plugin.category.xmlText)#</li>
		<li><strong>Version:</strong> #esapiEncode('html',rc.pluginXML.plugin.version.xmlText)#</li>
		<li><strong>Provider:</strong> <a href="#esapiEncode('url',rc.pluginXML.plugin.providerURL.xmlText)#" target="_blank">#esapiEncode('html',rc.pluginXML.plugin.provider.xmlText)#</a></li>
		<!---<li><strong>Provider URL:</strong> <a href="#rc.pluginXML.plugin.providerURL.xmlText#" target="_blank">#esapiEncode('html',rc.pluginXML.plugin.providerURL.xmlText)#</a></li>--->
		<li><strong>Plugin ID:</strong> #rsplugin.pluginID#</li>
		<li><strong>Package:</strong> <cfif len(package)>#esapiEncode('html',package)#<cfelse>N/A</cfif></li>
	</ul>

	<cfif rsPlugin.recordcount and rsPlugin.deployed and application.configBean.getJavaEnabled()>
		<ul class="navTask nav nav-pills">
			<li><a href="./?muraAction=cSettings.updatePluginVersion&moduleid=#esapiEncode('url',rc.moduleid)#">Update Plugin Version</a></li>
			<li><a href="./index.cfm?muraAction=cSettings.createBundle&moduleid=#esapiEncode('url',rc.moduleid)#&siteID=&BundleName=#esapiEncode('url',application.serviceFactory.getBean('contentUtility').formatFilename(rsPlugin.name))#">Create and Download Plugin Bundle</a></li>
		</ul>
	</cfif>

	<cfset errors=application.userManager.getCurrentUser().getValue("errors")>
	<cfif isStruct(errors) and not structIsEmpty(errors)>
		<div class="alert alert-error">#application.utility.displayErrors(errors)#</div>
	</cfif>
	<cfset application.userManager.getCurrentUser().setValue("errors","")>

	<form novalidate="novalidate" class="fieldset-wrap" method="post" name="frmSettings" action="./?muraAction=cSettings.updatePlugin" onsubmit="return submitForm(document.frmSettings);">
		<div class="fieldset">
			<cfsilent>
				<cfquery name="rsLocation" datasource="#application.configbean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
					select location from tplugindisplayobjects
					where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.ModuleID#">
				</cfquery>

				<!---
				<cfif len(rsLocation.location)>
					<cfset location=rsLocation.location>
				<cfelse>
					<cfif structKeyExists(rc.pluginXML.plugin.displayobjects.xmlAttributes,"location")>
						<cfset location=rc.pluginXML.plugin.displayobjects.xmlAttributes.location>
					<cfelse>
				--->
						<cfset location="global">
				
				<!---
					</cfif>
				</cfif>
				--->

				<cfif structKeyExists(rc.pluginXML.plugin.settings,"setting")>
					<cfset settingsLen=arraylen(rc.pluginXML.plugin.settings.setting)/>
				<cfelse>
					<cfset settingsLen=0>
				</cfif>

				<cfif structKeyExists(rc.pluginXML.plugin,"extensions") 
				and structKeyExists(rc.pluginXML.plugin.extensions,"extension")>
					<cfset extensionsLen=arraylen(rc.pluginXML.plugin.extensions.extension)/>
				<cfelse>
					<cfset extensionsLen=0>
				</cfif>

				<cfif structKeyExists(rc.pluginXML.plugin,"scripts") and structKeyExists(rc.pluginXML.plugin.scripts,"script")>
					<cfset scriptsLen=arraylen(rc.pluginXML.plugin.scripts.script)/>
				<cfelse>
					<cfset scriptsLen=0>
				</cfif>

				<cfif structKeyExists(rc.pluginXML.plugin,"eventHandlers") and structKeyExists(rc.pluginXML.plugin.eventHandlers,"eventHandler")>
					<cfset eventHandlersLen=arraylen(rc.pluginXML.plugin.eventHandlers.eventHandler)/>
				<cfelse>
					<cfset eventHandlersLen=0>
				</cfif>

				<cfif structKeyExists(rc.pluginXML.plugin.displayobjects,"displayobject")>
					<cfset objectsLen=arraylen(rc.pluginXML.plugin.displayobjects.displayobject)/>
				<cfelse>
					<cfset objectsLen=0>
				</cfif>
			</cfsilent>

			<cfset licenseFile="#application.configBean.getPluginDir()#/#rsPlugin.directory#/license.txt">

			<cfif not fileExists(licenseFile)>
				<cfset licenseFile="#application.configBean.getPluginDir()#/#rsPlugin.directory#/plugin/license.txt">
			</cfif>

			<cfset hasLicense= isNumeric(rsPlugin.deployed) and not rsPlugin.deployed eq 1
			and fileExists(licenseFile)>
			<cfif hasLicense>
				<cffile file="#licenseFile#" action="read" variable="license">
				<div class="control-group" id="plugin-license">
					<label class="control-label">End User License Agreement</label>
					<div class="controls">
						<textarea readonly="true" rows="16" class="span12">
							#license#
						</textarea>
					</div>
					<div class="controls">
						<select class="span3" name="licenseStatus" required="true" message="You Must Accept the End User License Agreement in Order to Proceed." onchange="if(this.value=='accept'){document.getElementById('settingsContainter').style.display='block';}else{document.getElementById('settingsContainter').style.display='none';}">
							<option value="">I Do Not Accept</option>
							<option value="accept">I Accept</option>
						</select>
					</div>
				</div>
				<span id="settingsContainter" style="display:none">
			</cfif>

			<div class="control-group">
				<div class="span3">
					<label class="control-label">Plugin Name (Alias)</label>
					<div class="controls"><input name="pluginalias" class="span12" type="text" value="#esapiEncode('html_attr',rsPlugin.name)#" required="true" message="The 'Name' field is required." maxlength="100"/></div>
			    </div>

				<div class="span6">
					<label class="control-label">Load Priority</label>
					<div class="controls">
						<select name="loadPriority" class="span2">
							<cfloop from="1" to="10" index="i">
								<option value="#i#" <cfif rsPlugin.loadPriority eq i>selected</cfif>>#i#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</div>

			<cfif settingsLen>
				<cfloop from="1" to="#settingsLen#" index="i">
					<cfsilent>
						<cfset settingBean=application.pluginManager.getAttributeBean(rc.pluginXML.plugin.settings.setting[i],rc.moduleID)/>		
						<cfif not len(settingBean.getSettingValue())
								and not rsPlugin.deployed>
							<cfif structKeyExists(rc.pluginXML.plugin.settings.setting[i],"defaultValue")>
								<cfset settingBean.setSettingValue(rc.pluginXML.plugin.settings.setting[i].defaultValue.xmlText)>
							<cfelseif structKeyExists(rc.pluginXML.plugin.settings.setting[i].xmlAttributes,"defaultValue")>
								<cfset settingBean.setSettingValue(rc.pluginXML.plugin.settings.setting[i].xmlAttributes.defaultValue)>
							</cfif>
						</cfif>
					</cfsilent>
					<div class="control-group">
				     	<label class="control-label">
							<cfif len(settingBean.getHint())>
								<a href="##" rel="tooltip" title="#esapiEncode('html_attr',settingBean.gethint())#">#settingBean.getLabel()# <i class="icon-question-sign"></i></a>
							<cfelse>
								#settingBean.getLabel()#
							</cfif>
						</label>
				      	<div class="controls">#settingBean.renderSetting(settingBean.getSettingValue())#</div>
					</div>
				</cfloop>
			</cfif>

			<cfif objectsLen>
				<div class="fieldset">
					<div class="control-group">
						<div class="span3">
							<label class="control-label">Display Objects</label>
							<div class="controls">
								<ul>
									<cfloop from="1" to="#objectsLen#" index="i">
									<li>#esapiEncode('html',rc.pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.name)#</li>
									</cfloop>
								</ul>
							</div>
						</div>
						<!---
						<div class="span3">
							<label class="control-label">Display Objects Location</label>
							<div class="controls">
								<select class="span6" name="location" onchange="if(this.value=='local'){jQuery('##ov').show();}else{jQuery('##ov').hide();}">
									<option value="global" <cfif location eq "global">selected</cfif>>Global</option>
									<option value="local" <cfif location eq "local">selected</cfif>>Local</option>
								</select>
							</div>
						</div>

						<span id="ov"<cfif location eq "global"> style="display:none;"</cfif>>
							<div class="span3">
								<label class="control-label">If Display Object Already Exists?</label>
								<div class="controls">
									<select name="overwrite">
										<option value="false">Do not overwrite </option>
										<option value="true">Overwrite</option>
									</select>
								</div>
							</div>
						</span>
						--->
					</div>
				</div>
			<cfelse>
				<input type="hidden" name="location" value="global">
			</cfif>

			<cfif scriptsLen>
				<div class="fieldset">
					<div class="control-group">
						<label class="control-label">Scripts</label>
						<div class="controls">
							<ul>
								<cfloop from="1" to="#scriptsLen#" index="i">
									<li><cfif structKeyExists(rc.pluginXML.plugin.scripts.script[i].XmlAttributes,"runat")>#esapiEncode('html',rc.pluginXML.plugin.scripts.script[i].xmlAttributes.runat)#<cfelse>#esapiEncode('html',rc.pluginXML.plugin.scripts.script[i].xmlAttributes.event)#</cfif></li>
								</cfloop>
							</ul>
						</div>
					</div>
				</div>
			</cfif> 

			<cfif eventHandlersLen>
				<div class="fieldset">
					<div class="control-group">
						<label class="control-label">Event Handlers</label>
						<div class="controls">
							<ul>
								<cfloop from="1" to="#eventHandlersLen#" index="i">
									<li><cfif structKeyExists(rc.pluginXML.plugin.eventHandlers.eventHandler[i].XmlAttributes,"runat")>#esapiEncode('html',rc.pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.runat)#<cfelse>#esapiEncode('html',rc.pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.event)#</cfif></li>
								</cfloop>
							</ul>
						</div>
					</div>
				</div>
			</cfif> 

			<cfif extensionsLen>
				<div class="fieldset">
					<div class="control-group">
						<label class="control-label">Class Extensions</label>
						<div class="controls">
							<ul>
								<cfloop from="1" to="#extensionsLen#" index="i">
									<li>#esapiEncode('html',rc.pluginXML.plugin.extensions.extension[i].xmlAttributes.type)#/<cfif structKeyExists(rc.pluginXML.plugin.extensions.extension[i].XmlAttributes,"subtype")>#esapiEncode('html',rc.pluginXML.plugin.extensions.extension[i].xmlAttributes.subtype)#<cfelse>Default</cfif></li>
								</cfloop>
							</ul>
						</div>
					</div>
				</div>
			</cfif>

			<cfset rsAssigned=application.pluginManager.getAssignedSites(rc.moduleID)>
			<div class="fieldset">
				<div class="control-group">
					<label class="control-label">Site Assignment</label>
					<div class="controls">
						<cfloop query="rc.rsSites">
							<label class="checkbox"><input type="checkbox" value="#rc.rsSites.siteID#" name="siteAssignID"<cfif listFind(valuelist(rsAssigned.siteID),rc.rsSites.siteID)> checked</cfif>> #esapiEncode('html',rc.rsSites.site)#</label>
						</cfloop>
					</div>
				</div>
			</div>

			<cfif hasLicense>
				</span>
			</cfif>

			<input name="package" type="hidden" value="#esapiEncode('html_attr',package)#"/>
			<input type="hidden" name="moduleID" value="#esapiEncode('html_attr',rc.moduleID)#">
			#rc.$.renderCSRFTokens(context=rc.moduleID,format="form")#
		</div>

		<div class="form-actions">
			<button type="submit" class="btn"><i class="icon-ok-sign"></i> Update</button>
		</div>
	</form>

</cfoutput>