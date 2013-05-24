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
<cfparam name="arguments.rc.objectid" default=""/>

<cfif listLen(rc.subclassid) gt 1>
	<cfset rc.objectid = listLast(rc.subclassid)>
	<cfset rc.subclassid = listFirst(rc.subclassid)>
</cfif>
<cfset rc.rsPlugins = application.pluginManager.getDisplayObjectsBySiteID(siteID=rc.siteid, 
                                                                              modulesOnly=true)/>
<cfoutput>
<div class="control-group">
	<div class="controls">
	<select name="subClassSelector" 
	        onchange="siteManager.loadObjectClass('#rc.siteid#','plugins',this.value,'#rc.contentid#','#rc.parentid#','#rc.contenthistid#',0,0);" 
	        class="dropdown">
		<option value="">
			#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.selectplugin')#
		</option>
		<cfloop query="rc.rsPlugins">
			<cfif application.permUtility.getModulePerm(rc.rsPlugins.moduleID, rc.siteid)>
				<option value="#rc.rsPlugins.moduleID#" <cfif rc.rsPlugins.moduleID eq rc.subclassid>selected</cfif>>#HTMLEditFormat(rc.rsPlugins.title)#</option>
			</cfif>
		</cfloop>
	</select>
	</div>
</cfoutput>

<cfif len(rc.subclassid)>

	<cfset prelist = application.pluginManager.getDisplayObjectsBySiteID(siteID=rc.siteid, 
	                                                                    moduleID=rc.subclassid)/>
	<cfset customOutputList = "">
	<cfset customOutput = "">
	<cfset customOutput1 = "">
	<cfset customOutput2 = "">
	<cfloop query="prelist">
		<cfif listLast(prelist.displayObjectFile, ".") neq "cfm">
			<cfset displayObject = application.pluginManager.getComponent("plugins.#prelist.directory#.#prelist.displayobjectfile#", 
			                                                              prelist.pluginID,
			                                                              rc.siteID,prelist.docache)>
			<cfif structKeyExists(displayObject, "#prelist.displayMethod#OptionsRender")>
				<cfset customOutputList = listAppend(customOutputList, prelist.objectID)>
				<cfif rc.objectID eq prelist.objectID>
					<cfset event = createObject("component", "mura.event").init(rc)>
					<cfset muraScope = event.getValue("muraScope")>
					<cfsavecontent variable="customOutput1">
			<cfinvoke component="#displayObject#" method="#prelist.displaymethod#OptionsRender" returnvariable="customOutput2">
				<cfinvokeargument name="event" value="#event#">
				<cfinvokeargument name="$" value="#muraScope#">
				<cfinvokeargument name="mura" value="#muraScope#">
			</cfinvoke>
			</cfsavecontent>
					<cfif isdefined("customOutput2")>
						<cfset customOutput = trim(customOutput2)>
					<cfelse>
						<cfset customOutput = trim(customOutput1)>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfif len(customOutputList)>
		<cfquery name="rs" dbtype="query">
			select * from prelist where
			objectID in (''
			<cfloop list="#customOutputList#" index="i">
				,'#i#'
			</cfloop>
			)
		</cfquery>
		<cfoutput>
		<div class="controls">
			<select name="customObjectSelector" 
			        onchange="siteManager.loadObjectClass('#rc.siteid#','plugins',this.value,'#rc.contentid#','#rc.parentid#','#rc.contenthistid#',0,0);" 
			        class="dropdown">
				<option value="">
					#application.rbFactory.getKeyValue(session.rb, 
				                                    'sitemanager.content.fields.selectplugindisplayobjectclass')#
				</option>
				<cfloop query="rs">
					<cfif application.permUtility.getModulePerm(rs.moduleID, rc.siteid)>
						<option value="#rs.moduleID#,#rs.objectID#" <cfif rs.objectID eq rc.objectID>selected</cfif>>#HTMLEditFormat(rs.name)#</option>
					</cfif>
				</cfloop>
			</select>
			</div>
		</cfoutput>
	</cfif>
	<cfif not len(customOutput)>
		<cfquery name="rs" dbtype="query">
			select * from prelist where
			objectID not in (''
			<cfloop list="#customOutputList#" index="i">
				,'#i#'
			</cfloop>
			)
		</cfquery>
		<cfif rs.recordcount>
			<div class="controls">
			<cfoutput>
				<select name="availableObjects" id="availableObjects" class="multiSelect" 
				        size="#evaluate((application.settingsManager.getSite(rc.siteid).getcolumnCount() * 6)-4)#" 
				        style="width:310px;">
			</cfoutput>
			<cfoutput query="rs">
				<option value="{'object':'plugin','name':'#JSStringFormat('#rs.title# - #rs.name#')#','objectid':'#rs.objectID#'}">
					#rs.name#					
				</option>
			</cfoutput>
			<cfoutput>
				</select>
			</cfoutput>
			</div>
		</cfif>
	<cfelse>
		<cfoutput>#customOutput#</cfoutput>
	</cfif>
</cfif>
</div>