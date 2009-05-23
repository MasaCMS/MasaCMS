<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfhtmlhead text="#session.dateKey#">
<cfset rsPlugin=application.pluginManager.getPlugin(attributes.moduleID)>
<h2>Plugin Settings</h2>
<cfoutput>
<ul class="metadata">
<li><strong>Name:</strong> #htmlEditFormat(request.pluginXML.plugin.name.xmlText)#</li>
<li><strong>Category:</strong> #htmlEditFormat(request.pluginXML.plugin.category.xmlText)#</li>
<li><strong>Version:</strong> #htmlEditFormat(request.pluginXML.plugin.version.xmlText)#</li>
<li><strong>Provider:</strong> #htmlEditFormat(request.pluginXML.plugin.provider.xmlText)#</li>
<li><strong>Provider URL:</strong> <a href="#request.pluginXML.plugin.providerURL.xmlText#" target="_blank">#htmlEditFormat(request.pluginXML.plugin.providerURL.xmlText)#</a></li>
<li><strong>Plugin ID:</strong> #rsplugin.pluginID#</li>
</ul>


<cfif rsPlugin.recordcount and rsPlugin.deployed>
<ul id="navTask"
<li><a href="index.cfm?fuseaction=cSettings.updatePluginVersion&moduleid=#attributes.moduleid#">Update Plugin Version</a></li>
</ul></cfif>


<form method="post" name="frmSettings" action="index.cfm?fuseaction=cSettings.updatePlugin" onsubmit="return validateForm(this);">
<cfsilent>

<cfquery name="rsLocation" datasource="#application.configbean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select location from tplugindisplayobjects
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ModuleID#">
</cfquery>
		
<cfif len(rsLocation.location)>
	<cfset location=rsLocation.location>
<cfelse>
	<cfif structKeyExists(request.pluginXML.plugin.displayobjects.xmlAttributes,"location")>
		<cfset location=request.pluginXML.plugin.displayobjects.xmlAttributes.location>
	<cfelse>
		<cfset location="global">
	</cfif>
</cfif>

<cfif structKeyExists(request.pluginXML.plugin.settings,"setting")>
<cfset settingsLen=arraylen(request.pluginXML.plugin.settings.setting)/>
<cfelse>
<cfset settingsLen=0>
</cfif>


<cfif structKeyExists(request.pluginXML.plugin,"scripts") and structKeyExists(request.pluginXML.plugin.scripts,"script")>
<cfset scriptsLen=arraylen(request.pluginXML.plugin.scripts.script)/>
<cfelse>
<cfset scriptsLen=0>
</cfif>


<cfif structKeyExists(request.pluginXML.plugin,"eventHandlers") and structKeyExists(request.pluginXML.plugin.eventHandlers,"eventHandler")>
<cfset eventHandlersLen=arraylen(request.pluginXML.plugin.eventHandlers.eventHandler)/>
<cfelse>
<cfset eventHandlersLen=0>
</cfif>


<cfif structKeyExists(request.pluginXML.plugin.displayobjects,"displayobject")>
<cfset objectsLen=arraylen(request.pluginXML.plugin.displayobjects.displayobject)/>
<cfelse>
<cfset objectsLen=0>
</cfif>

<cfif rsPlugin.deployed>
	<cfset package=rsPlugin.package>
<cfelse>
	<cfif structKeyExists(request.pluginXML.plugin,"package") and len(request.pluginXML.plugin.package.xmlText)>
		<cfset package=request.pluginXML.plugin.package.xmlText>
	<cfelse>
		<cfset package="">
	</cfif>
</cfif>
</cfsilent>
<dl class="oneColumn">
	<dt>Plugin Name (Alias)</dt>	
	<dd><input name="pluginalias" type="text" value="#htmlEditFormat(rsPlugin.name)#" required="true" message="The 'Name' field is required." maxlength="100"/></dd>
	<dt>Package (Base of Install Directory)</dt>	
	<dd><input name="package" type="text" value="#htmlEditFormat(package)#" maxlength="100"/></dd>
<cfif settingsLen>
<cfloop from="1" to="#settingsLen#" index="i">
		<cfsilent>
		<cfset settingBean=application.pluginManager.getAttributeBean(request.pluginXML.plugin.settings.setting[i],attributes.moduleID)/>		
		<cfif not len(settingBean.getSettingValue())
				and not rsPlugin.deployed and structKeyExists(request.pluginXML.plugin.settings.setting[i],'defaultValue')>
			<cfset settingBean.setSettingValue(request.pluginXML.plugin.settings.setting[i].defaultValue.xmlText)>
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
<li>#htmlEditFormat(request.pluginXML.plugin.displayobjects.displayobject[i].XmlAttributes.name)#</li>
</cfloop>
</ul>
</dd>
<dt>Display Objects Location</dt>
<dd><select name="location" onchange="if(this.value=='local'){$('ov').style.display='block';}else{$('ov').style.display='none';}">
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
	<li><cfif structKeyExists(request.pluginXML.plugin.scripts.script[i].XmlAttributes,"runat")>#htmlEditFormat(request.pluginXML.plugin.scripts.script[i].XmlAttributes.runat)#<cfelse>#htmlEditFormat(request.pluginXML.plugin.scripts.script[i].XmlAttributes.event)#</cfif></li>
</cfloop>
</ul>
</dd>
</cfif> 

<cfif eventHandlersLen>
<dt>Event Handlers</dt>
<dd><ul>
<cfloop from="1" to="#eventHandlersLen#" index="i">
	<li><cfif structKeyExists(request.pluginXML.plugin.eventHandlers.eventHandler[i].XmlAttributes,"runat")>#htmlEditFormat(request.pluginXML.plugin.eventHandlers.eventHandler[i].XmlAttributes.runat)#<cfelse>#htmlEditFormat(request.pluginXML.plugin.eventHandlers.eventHandler[i].XmlAttributes.event)#</cfif></li>
</cfloop>
</ul>
</dd>
</cfif> 

<cfset rsAssigned=application.pluginManager.getAssignedSites(attributes.moduleID)>
<dt>Site Assignment</dt>
<dd><ul>
<cfloop query="request.rsSites">
<li><input type="checkbox" value="#request.rsSites.siteID#" name="siteAssignID"<cfif listFind(valuelist(rsAssigned.siteID),request.rsSites.siteID)> checked</cfif>> #request.rsSites.site#</li>
</cfloop>
</ul></dd>
</dl>

<input type="hidden" name="moduleID" value="#attributes.moduleID#">
</cfoutput>
<input type="submit" value="Update">
</form>

