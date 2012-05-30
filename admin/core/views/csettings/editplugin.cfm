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
<h2>Plugin Settings</h2>
<cfoutput>
<ul class="metadata">
<li><strong>Name:</strong> #htmlEditFormat(rc.pluginXML.plugin.name.xmlText)#</li>
<li><strong>Category:</strong> #htmlEditFormat(rc.pluginXML.plugin.category.xmlText)#</li>
<li><strong>Version:</strong> #htmlEditFormat(rc.pluginXML.plugin.version.xmlText)#</li>
<li><strong>Provider:</strong> <a href="#rc.pluginXML.plugin.providerURL.xmlText#" target="_blank">#htmlEditFormat(rc.pluginXML.plugin.provider.xmlText)#</a></li>
<!---<li><strong>Provider URL:</strong> <a href="#rc.pluginXML.plugin.providerURL.xmlText#" target="_blank">#htmlEditFormat(rc.pluginXML.plugin.providerURL.xmlText)#</a></li>--->
<li><strong>Plugin ID:</strong> #rsplugin.pluginID#</li>
<li><strong>Package:</strong> <cfif len(package)>#htmlEditFormat(package)#<cfelse>N/A</cfif></li>
</ul>


<cfif rsPlugin.recordcount and rsPlugin.deployed>
<ul id="navTask">
<li><a href="index.cfm?muraAction=cSettings.updatePluginVersion&moduleid=#rc.moduleid#">Update Plugin Version</a></li>
<li><a href="index.cfm?muraAction=cSettings.createBundle&moduleid=#rc.moduleid#&siteID=&BundleName=#URLEncodedFormat(application.serviceFactory.getBean('contentUtility').formatFilename(rsPlugin.name))#">Create and Download Plugin Bundle</a></li>
</ul></cfif>

<cfset errors=application.userManager.getCurrentUser().getValue("errors")>
<cfif isStruct(errors) and not structIsEmpty(errors)>
<p class="error">#application.utility.displayErrors(errors)#</p>
</cfif>
<cfset application.userManager.getCurrentUser().setValue("errors","")>

<form novalidate="novalidate" class="clear" method="post" name="frmSettings" action="index.cfm?muraAction=cSettings.updatePlugin" onsubmit="return validateForm(this);">
<cfsilent>

<cfquery name="rsLocation" datasource="#application.configbean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select location from tplugindisplayobjects
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.ModuleID#">
</cfquery>
		
<cfif len(rsLocation.location)>
	<cfset location=rsLocation.location>
<cfelse>
	<cfif structKeyExists(rc.pluginXML.plugin.displayobjects.xmlAttributes,"location")>
		<cfset location=rc.pluginXML.plugin.displayobjects.xmlAttributes.location>
	<cfelse>
		<cfset location="global">
	</cfif>
</cfif>

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
<dl class="oneColumn">

<cfset licenseFile="#application.configBean.getPluginDir()##application.configBean.getFileDelim()##rsPlugin.directory##application.configBean.getFileDelim()#license.txt">

<cfif not fileExists(licenseFile)>
	<cfset licenseFile="#application.configBean.getPluginDir()##application.configBean.getFileDelim()##rsPlugin.directory##application.configBean.getFileDelim()#plugin#application.configBean.getFileDelim()#license.txt">
</cfif>

<cfset hasLicense= isNumeric(rsPlugin.deployed) and not rsPlugin.deployed eq 1
and fileExists(licenseFile)>

<cfif hasLicense>
<cffile file="#licenseFile#" action="read" variable="license">
<dt>End User License Agreement</dt>
<dd>
<textarea readonly="true">
#license#
</textarea>
</dd>
<select name="licenseStatus" required="true" message="You Must Accept the End User License Agreement in Order to Proceed." onchange="if(this.value=='accept'){document.getElementById('settingsContainter').style.display='block';}else{document.getElementById('settingsContainter').style.display='none';}">
<option value="">I Do Not Accept</option>
<option value="accept">I Accept</option>
</select>
</dd>
<span id="settingsContainter" style="display:none">
</cfif>

<dt>Plugin Name (Alias)</dt>	
<dd><input name="pluginalias" type="text" value="#htmlEditFormat(rsPlugin.name)#" required="true" message="The 'Name' field is required." maxlength="100"/></dd>

<dt>Load Priority</dt>
<dd><select name="loadPriority">
	<cfloop from="1" to="10" index="i">
	<option value="#i#" <cfif rsPlugin.loadPriority eq i>selected</cfif>>#i#</option>
	</cfloop>
	</select>
</dd>

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
		<dt>
		<cfif len(settingBean.getHint())>
		<a href="##" class="tooltip">#settingBean.getLabel()# <span>#settingBean.gethint()#</span></a>
		<cfelse>
		#settingBean.getLabel()#
		</cfif>
		</dt>
		<dd>#settingBean.renderSetting(settingBean.getSettingValue())#</dd>
</cfloop>
</cfif>

<cfif objectsLen>
<dt>Display Objects</dt>	
<dd><ul>
<cfloop from="1" to="#objectsLen#" index="i">
<li>#htmlEditFormat(rc.pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.name)#</li>
</cfloop>
</ul>
</dd>
<dt>Display Objects Location</dt>
<dd><select name="location" onchange="if(this.value=='local'){jQuery('##ov').show();}else{jQuery('##ov').hide();}">
	<option value="global" <cfif location eq "global">selected</cfif>>global</option>
	<option value="local" <cfif location eq "local">selected</cfif>>local</option>
	</select>
</dd>
<span id="ov"<cfif location eq "global"> style="display:none;"</cfif>>
<dt>If Display Object Already Exists?</dt>
<dd>
<select name="overwrite">
		<option value="false">Do not overwrite </option>
		<option value="true">Overwrite</option>
</select>
</dd>
</span>
<cfelse>
<input type="hidden" name="location" value="global">
</cfif>


<cfif scriptsLen>
<dt>Scripts</dt>
<dd><ul>
<cfloop from="1" to="#scriptsLen#" index="i">
	<li><cfif structKeyExists(rc.pluginXML.plugin.scripts.script[i].XmlAttributes,"runat")>#htmlEditFormat(rc.pluginXML.plugin.scripts.script[i].xmlAttributes.runat)#<cfelse>#htmlEditFormat(rc.pluginXML.plugin.scripts.script[i].xmlAttributes.event)#</cfif></li>
</cfloop>
</ul>
</dd>
</cfif> 

<cfif eventHandlersLen>
<dt>Event Handlers</dt>
<dd><ul>
<cfloop from="1" to="#eventHandlersLen#" index="i">
	<li><cfif structKeyExists(rc.pluginXML.plugin.eventHandlers.eventHandler[i].XmlAttributes,"runat")>#htmlEditFormat(rc.pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.runat)#<cfelse>#htmlEditFormat(rc.pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.event)#</cfif></li>
</cfloop>
</ul>
</dd>
</cfif> 

<cfif extensionsLen>
<dt>Class Extensions</dt>
<dd><ul>
<cfloop from="1" to="#extensionsLen#" index="i">
	<li>#htmlEditFormat(rc.pluginXML.plugin.extensions.extension[i].xmlAttributes.type)#/<cfif structKeyExists(rc.pluginXML.plugin.extensions.extension[i].XmlAttributes,"subtype")>#htmlEditFormat(rc.pluginXML.plugin.extensions.extension[i].xmlAttributes.subtype)#<cfelse>Default</cfif></li>
</cfloop>
</ul>
</dd>

</cfif>

<cfset rsAssigned=application.pluginManager.getAssignedSites(rc.moduleID)>
<dt>Site Assignment</dt>
<dd><ul>
<cfloop query="rc.rsSites">
<li><input type="checkbox" value="#rc.rsSites.siteID#" name="siteAssignID"<cfif listFind(valuelist(rsAssigned.siteID),rc.rsSites.siteID)> checked</cfif>> #rc.rsSites.site#</li>
</cfloop>
</ul></dd>
<cfif hasLicense>
</span>
</cfif>
</dl>
<input name="package" type="hidden" value="#htmlEditFormat(package)#"/>
<input type="hidden" name="moduleID" value="#rc.moduleID#">
</cfoutput>
<input type="submit" value="Update">
</form>

