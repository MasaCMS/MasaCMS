<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfhtmlhead text="#session.dateKey#">

<h2>Plugin Settings</h2>
<cfoutput>
<ul class="metadata">
<li><strong>Name:</strong> #htmlEditFormat(request.pluginXML.plugin.name.xmlText)#</li>
<li><strong>Category:</strong> #htmlEditFormat(request.pluginXML.plugin.category.xmlText)#</li>
<li><strong>Version:</strong> #htmlEditFormat(request.pluginXML.plugin.version.xmlText)#</li>
<li><strong>Provider:</strong> #htmlEditFormat(request.pluginXML.plugin.provider.xmlText)#</li>
<li><strong>Provider URL:</strong> <a href="#request.pluginXML.plugin.providerURL.xmlText#" target="_blank">#htmlEditFormat(request.pluginXML.plugin.providerURL.xmlText)#</a></li>
</ul>

<cfset rsPlugin=application.pluginManager.getPlugin(attributes.moduleID)>
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

<cfif structKeyExists(request.pluginXML.plugin.scripts,"script")>
<cfset scriptsLen=arraylen(request.pluginXML.plugin.scripts.script)/>
<cfelse>
<cfset scriptsLen=0>
</cfif>

<cfif structKeyExists(request.pluginXML.plugin.displayobjects,"displayobject")>
<cfset objectsLen=arraylen(request.pluginXML.plugin.displayobjects.displayobject)/>
<cfelse>
<cfset objectsLen=0>
</cfif>
</cfsilent>

<dl class="oneColumn">
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
	<li>#htmlEditFormat(request.pluginXML.plugin.scripts.script[i].XmlAttributes.runat)#</li>
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

