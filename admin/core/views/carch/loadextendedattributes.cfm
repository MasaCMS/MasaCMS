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
	/core/mura/
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

<cfset request.layout=false />
<cfset returnsets=structNew() />
<cfif isDefined("session.mura.editBean") and isInstanceOf(session.mura.editBean, "mura.content.contentBean") and session.mura.editBean.getContentHistID() eq rc.contentHistID>
	<cfset contentBean=session.mura.editBean />
<cfelse>
	<cfset contentBean=application.contentManager.getcontentVersion(rc.contentHistID,rc.siteID) />
</cfif>
<cfset structDelete(session.mura,"editBean") />
<cfset request.event.setValue('contentBean',contentBean) />
<cfset subtype=application.classExtensionManager.getSubTypeByName(rc.type,rc.subtype,rc.siteid) />

<cfif contentBean.getIsNew()>
	<cfset contentBean.setType(rc.type) />
	<cfset contentBean.setSubType(rc.subtype) />
</cfif>

<cfloop list="#application.contentManager.getTabList()#" index="container">
	<cfif container eq 'Extended Attributes'>
		<cfset container='Default' />
	</cfif>
	<cfset containerID=REreplace(container, "[^\\\w]", "", "all")>
	<cfsavecontent variable="returnsets.#containerID#">
		<cfset extendSets=subtype.getExtendSets(inherit=true,container=container,activeOnly=true) />
		<cfset started=false />
		<cfoutput>
			<cfif arrayLen(extendSets)>
				<cfloop from="1" to="#arrayLen(extendSets)#" index="s">
					<cfset extendSetBean=extendSets[s] />
					<cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif>
					<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
						<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#" />
						<h2>#esapiEncode('html', extendSetBean.getName())#</h2>
						<cfsilent>
							<cfset attributesArray=extendSetBean.getAttributes() />
						</cfsilent>
						<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">
							<cfset attributeBean=attributesArray[a] />
							<cfset attributeValue=contentBean.getvalue(attributeBean.getName(), 'useMuraDefault') />
							<cfset readonly = attributeBean.getAdminOnly() and (not $.currentUser().isSuperUser() and not $.currentUser().isAdminUser()) />

							<!---
								Hidden attributes should be editable via the back-end Admin area
							--->
							<cfif attributeBean.getType() eq 'Hidden'>
								<cfset attributeBean.setType('TextBox') />
							</cfif>

							<div class="mura-control-group">
								<label>
									<cfif len(attributeBean.getHint())>
										<span
											data-toggle="popover"
											title=""
											data-placement="right"
											data-content="#esapiEncode('html_attr', attributeBean.getHint())#"
											data-original-title="#esapiEncode('html_attr', attributeBean.getLabel())#">
											#esapiEncode('html', attributeBean.getLabel())# <i class="mi-question-circle"></i>
										</span>
									<cfelse>
										#esapiEncode('html',attributeBean.getLabel())#
									</cfif>
								</label>

								#attributeBean.renderAttribute(theValue=attributeValue, bean=contentBean, compactDisplay=rc.compactDisplay, size='medium', readonly=readonly)#

								<cfif not readonly and attributeBean.getValidation() eq "URL">
									<cfif len(application.serviceFactory.getBean('settingsManager').getSite(session.siteid).getRazunaSettings().getHostname())>
										<div class="btn-group">
											<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
												<i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.browseassets')#
											</a>
											<ul class="dropdown-menu">
												<li><a href="##" type="button" data-completepath="false" data-target="#esapiEncode('javascript',attributeBean.getName())#" data-resourcetype="user" class="mura-file-type-selector mura-ckfinder" title="Select a File from Server">
													<i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.local')#</a></li>
												<li><a href="##" type="button" onclick="renderRazunaWindow('#esapiEncode('javascript',attributeBean.getName())#');return false;" class="mura-file-type-selector btn-razuna-icon" value="URL-Razuna" title="Select a File from Razuna"><i></i> Razuna</a></li>
											</ul>
										</div>
									<cfelse>
										<div class="btn-group">
											<button type="button" data-target="#esapiEncode('javascript',attributeBean.getName())#" data-resourcetype="user" class="btn mura-file-type-selector mura-ckfinder" title="Select a File from Server"><i class="mi-folder-open"></i> Browse Assets</button>
										</div>
									</cfif>
								</cfif>
							</div>
						</cfloop>
					</span>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	<cfset returnsets[containerID]=trim(returnsets[containerID]) />
</cfloop>
<cftry>
	<cfparam name="rc.tablist" default="tabBasic,tabSEO,tabAdvanced,tabCategorization,tabExtendedAttributes,tabLayoutObjects,tabListDisplayOptions,tabMobile,tabPublishing,tabTags,tabUsagereport">
	<cfloop list="#rc.tablist#" index="tab">
		<cfloop list="top,bottom" index="context">
			<cfsavecontent variable="returnsets.#tab##context#">
				<cfoutput>
					<cf_dsp_rendertabevents context="#context#" tab="#tab#">
				</cfoutput>
			</cfsavecontent>

			<cfset returnsets[tab & context ]=trim(returnsets[tab & context])>
		</cfloop>
	</cfloop>
	<cfcatch>
		<cfoutput>#cfcatch.message#</cfoutput>
	</cfcatch>
</cftry>

<cfset returnsets.hasSummary=subType.getHasSummary() />
<cfset returnsets.hasBody=subType.getHasBody() />
<cfset returnsets.hasAssocFile=subType.getHasAssocFile() />
<cfset returnsets.hasConfigurator=subType.getHasConfigurator() />

<!--- escape control characters in JSON --->
<cfset result = createObject("component","mura.json").encode(returnsets) />
<cfset result = reReplace(result, "[[:cntrl:]]", "", "all") />
<cfcontent type="application/json; charset=utf-8" reset="true"><cfoutput>#result#</cfoutput><cfabort>
