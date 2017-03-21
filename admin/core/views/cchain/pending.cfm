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
<cfset chain=$.getBean('approvalChain').loadBy(chainId=rc.chainID)>
<cfset members=chain.getMembershipsIterator()>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>

<cfoutput>
	<div class="mura-header">
		<h1>#application.rbFactory.getKeyValue(session.rb,"approvalchains")#</h1>
		<cfinclude template="dsp_secondary_menu.cfm">
	</div>
	<!-- /.mura-header -->
	<div class="block block-constrain">
		<div class="block block-bordered">
			<div class="block-content">
				<h2>#application.rbFactory.getKeyValue(session.rb,'approvalchains.pendingrequests')#</h2>
				<h3>#esapiEncode('html', chain.getName())#</h3>

				<cfif Len(chain.getDescription())>
					<p>#esapiEncode('html', chain.getDescription())#</p>
				</cfif>

				<cfif members.hasNext()>
					<hr />
					<cfloop condition="members.hasNext()">
						<cfset member=members.next()>
						<h4>#members.getRecordIndex()#. #esapiEncode('html',member.getGroup().getGroupName())#</h4>
						<cfset requests=member.getPendingContentIterator()>

						<cfif requests.hasNext()>
							<table class="mura-table-grid">
								<tr>
									<th class="actions"></th>
									<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
									<cfif hasChangesets>
										<th>#application.rbFactory.getKeyValue(session.rb,'approvalchains.changeset')#</th>
									</cfif>
									<th>
										Request By</th>
									<th>
										Request Date</th>
								</tr>
								<cfloop condition="requests.hasNext()">
									<cfsilent>
										<cfset item=requests.next()>
										<cfset editlink="./?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#esapiEncode('url',item.getType())#&parentid=#item.getParentID()#&siteid=#esapiEncode('url',item.getSiteID())#&moduleid=#item.getModuleID()#&return=chain">
									</cfsilent>
									<tr>
										<td class="actions">
											<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);">
												<i class="mi-ellipsis-v"></i>
											</a>
											<div class="actions-menu hide">
												<ul class="actions-list">
													<li class="edit">
														<a href="#editlink#">
															<i class="mi-pencil"></i> Edit
														</a>
													</li>
													<cfswitch expression="#esapiEncode('url',item.getType())#">
														<cfcase value="Page,Folder,Calendar,Gallery,Link,File">
															<cfset previewURL='#item.getURL(complete=1,queryString="previewid=#item.getcontenthistid()#")#'>
															<cfif rc.compactDisplay eq 'true'>
																<li class="preview">
																	<a href="##" onclick="frontEndProxy.post({cmd:'setLocation',location:encodeURIComponent('#esapiEncode('javascript',previewURL)#')});return false;">
																		<i class="mi-globe"></i> #application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.preview')#</a>
																</li>
															<cfelse>
																<li class="preview">
																	<a href="##" onclick="return preview('#previewURL#','');">
																		<i class="mi-globe"></i> #application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.preview')#</a>
																</li>
															</cfif>
														</cfcase>
													</cfswitch>
													<li class="version-history">
														<a href="./?muraAction=cArch.hist&contentid=#item.getContentID()#&type=#esapiEncode('url',item.getType())#&parentid=#item.getParentID()#&siteid=#esapiEncode('url',item.getSiteID())#&moduleid=#item.getModuleID()#">
															<i class="mi-history"></i> #application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.versionhistory')#</a>
													</li>
												</ul>
											</div>
										</td>
										<td class="title var-width">#$.dspZoom(item.getCrumbArray())#</td>
										<cfif hasChangesets>
											<td>
												<cfif isDate(item.getchangesetPublishDate())>
													<a href="##" rel="tooltip" title="#esapiEncode('html_attr',LSDateFormat(item.getchangesetPublishDate()," short"))#">
														<i class="mi-calendar"></i>
													</a>
												</cfif>
												<a href="./?muraAction=cChangesets.assignments&siteID=#item.getSiteID()#&changesetID=#item.getChangeSetID()#">#esapiEncode('html',item.getChangesetName())#</a>
											</td>
										</cfif>
										<td>#esapiEncode('html',item.getLastUpdateBy())#</td>
										<td>#LSDateFormat(item.getCreated(),session.dateKeyFormat)# #LSTimeFormat(item.getCreated(),"medium")#</td>
									</tr>
								</cfloop>
							</table>
						<cfelse>
							<div class="help-block-empty">No pending requests exist for this group in the approval chain.</div>
						</cfif>

					</cfloop>
				<cfelse>
					<div class="help-block-empty">No groups have been assigned to this approval chain yet.</div>
				</cfif>

			</div>
			<!-- /.block-content -->
		</div>
		<!-- /.block-bordered -->
	</div>
	<!-- /.block-constrain -->
</cfoutput>
