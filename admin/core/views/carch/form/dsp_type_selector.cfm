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

� Must not alter any default objects in the Mura CMS database and
� May not alter the default display of the Mura CMS logo within Mura CMS and
� Must not alter any files in the following directories.

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

<cfoutput>
	<cfif listFindNoCase(pageLevelList,rc.type)>
		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#
			</label>
				<select name="typeSelector" onchange="siteManager.resetExtendedAttributes('#rc.contentBean.getcontentID()#','#rc.contentBean.getcontentHistID()#',this.value,'#esapiEncode("Javascript",rc.siteID)#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
				<cfloop list="#baseTypeList#" index="t">
				<cfsilent>
					<cfquery name="rsst" dbtype="query">
						select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')
						<cfif not (rc.$.currentUser().isAdminUser() or rc.$.currentUser().isSuperUser())>
							and (
								adminonly !=1

								or (
									type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rc.contentBean.getType()#">
									and subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rc.contentBean.getSubType()#">
								)
							)

						</cfif>
					</cfquery>
				</cfsilent>
				<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/Default')>
					<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				</cfif>
					<cfif rsst.recordcount>
						<cfloop query="rsst">
							<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/#rsst.subtype#')>
								<option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			</select>
			</div>
	<cfelseif rc.type eq 'File'>
		<cfset t="File"/>
		<cfsilent>
			<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery>
		</cfsilent>
		<cfif rsst.recordcount>
			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#
				</label>
					<select name="typeSelector" onchange="siteManager.resetExtendedAttributes('#rc.contentBean.getcontentID()#','#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
						<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/Default')>
							<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#t#")#</option>
						</cfif>
						<cfif rsst.recordcount>
							<cfloop query="rsst">
								<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/#rsst.subtype#')>
									<option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")# / #rsst.subtype#</option>
								</cfif>
							</cfloop>
						</cfif>
				</select>
				</div>
		</cfif>
	<cfelseif rc.type eq 'Link'>
		<cfset t="Link"/>
		<cfsilent>
			<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery>
		</cfsilent>
		<cfif rsst.recordcount>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#</label>
				<select name="typeSelector"  onchange="siteManager.resetExtendedAttributes('#rc.contentBean.getcontentID()#','#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
					<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/Default')>
						<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
					</cfif>
					<cfif rsst.recordcount>
						<cfloop query="rsst">
							<cfif not len(subtypefilter) or listFindNoCase(subtypefilter,'#t#/#rsst.subtype#')>
								<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
							</cfif>
						</cfloop>
					</cfif>
				</select>
			</div>
		</cfif>
	<cfelseif listFindNoCase('Component,Form',rc.type)>
		<cfset t=rc.type/>
			<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery>
		</cfsilent>
		<cfif rsst.recordcount>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#</label>
				<select name="typeSelector"  onchange="siteManager.resetExtendedAttributes('#rc.contentBean.getcontentID()#','#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
					<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
					<cfif rsst.recordcount>
						<cfloop query="rsst">
							<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
						</cfloop>
					</cfif>
				</select>
			</div>
		</cfif>
	</cfif>



</cfoutput>
