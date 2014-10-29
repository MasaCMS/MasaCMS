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
	independent software modules (plugixns, themes and bundles), and to distribute these plugins, themes and bundles without 
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
<cfset $=request.event.getValue('MuraScope')>
<cfset poweruser=$.currentUser().isSuperUser() or $.currentUser().isAdminUser()>
<cfinclude template="js.cfm">
<cfswitch expression="#rc.moduleID#">
	<cfcase value="00000000000000000000000000000000003,00000000000000000000000000000000004">
		<cfset rc.perm=application.permUtility.getPerm(rc.moduleid,rc.siteid)>

		<cfparam name="rc.sortBy" default="menutitle">
		<cfparam name="rc.sortDirection" default="asc">
		<cfparam name="rc.searchString" default="">

		<cfset titleDirection = "asc">
		<cfset displayDirection = "asc">
		<cfset lastUpdatedDirection = "desc">

		<cfswitch expression="#rc.sortBy#">
			<cfcase value="title">
				<cfif rc.sortDirection eq "asc">
					<cfset titleDirection = "desc">
				</cfif>
			</cfcase>
			<cfcase value="display">
				<cfif rc.sortDirection eq "asc">
					<cfset displayDirection = "desc">
				</cfif>
			</cfcase>
			<cfcase value="lastupdate">
				<cfif rc.sortDirection eq "desc">
					<cfset lastUpdatedDirection = "asc">
				</cfif>
			</cfcase>
		</cfswitch>

		<cfoutput>
			<cfif rc.moduleid eq '00000000000000000000000000000000004'>
				<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.formsmanager')#</h1>
			<cfelse>
				<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.componentmanager')#</h1> 
			</cfif>
			<cfinclude template="dsp_secondary_menu.cfm">
		</cfoutput>

		<div class="row-fluid">
			<div id="main" class="span9">
				<table class="mura-table-grid">
					<cfoutput>
						<thead>
							<tr> 
				  				<th class="var-width">
				  					<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&topid=#esapiEncode('url',rc.topid)#&parentid=#esapiEncode('url',rc.parentid)#&moduleid=#rc.moduleID#&sortBy=title&sortDirection=#titleDirection#">
				  						#application.rbFactory.getKeyValue(session.rb,'sitemanager.title')#
				  					</a>
				  				</th>

				  				<th>
				  					<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&topid=#esapiEncode('url',rc.topid)#&parentid=#esapiEncode('url',rc.parentid)#&moduleid=#rc.moduleID#&sortBy=display&sortDirection=#displayDirection#">
				  						#application.rbFactory.getKeyValue(session.rb,'sitemanager.display')#
				  					</a>
				  				</th>
				  				<th>
				  					<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&topid=#esapiEncode('url',rc.topid)#&parentid=#esapiEncode('url',rc.parentid)#&moduleid=#rc.moduleID#&sortBy=lastUpdate&sortDirection=#lastUpdatedDirection#">
				  						#application.rbFactory.getKeyValue(session.rb,'sitemanager.lastupdated')#
				  					</a>
				  				</th>
				  				<th class="actions">&nbsp;</th>
							</tr>
						</thead>
					</cfoutput>

					<tbody>
						<cfif rc.rstop.recordcount>
							<cfoutput query="rc.rsTop" maxrows="#rc.nextn.recordsperPage#" startrow="#rc.startrow#">
								<cfsilent>
									<cfset isLockedBySomeoneElse=$.siteConfig('hasLockableNodes') and len(rc.rsTop.lockid) and rc.rsTop.lockid neq session.mura.userid> 
									<cfif rc.perm neq 'editor'>
										<cfset verdict=application.permUtility.getPerm(rc.rstop.contentid, rc.siteid)>
					
										<cfif verdict neq 'deny'>
											<cfif verdict eq 'none'>
												<cfset verdict=rc.perm>
											</cfif>
										<cfelse>
											<cfset verdict = "none">
										</cfif>
					
									<cfelse>
										<cfset verdict='editor'>
									</cfif>
								</cfsilent>
								<tr>
									<!--- Title --->
				 					<td class="var-width">
				 						<cfif verdict neq 'none'>
				 							<a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" href="./?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#">
				 								#left(rc.rstop.menutitle,90)#
				 							</a>
				 						<cfelse>
				 							#left(rc.rstop.menutitle,90)#
				 						</cfif>
				 					</td>
				 					<!--- /Title --->

				  					<!--- Display Start/Stop --->
									<td>
										<cfif rc.rstop.Display and (rc.rstop.Display eq 1 and rc.rstop.approved)>
											<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#"></i>
											<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</span>
										<cfelseif(rc.rstop.Display eq 2 and rc.rstop.approved)>
											#LSDateFormat(rc.rstop.displaystart,"short")# - #LSDateFormat(rc.rstop.displaystop,"short")#
										<cfelse>
											<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#"></i>
											<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</span>
										</cfif>
									</td>
									<!--- /Display Start/Stop --->

									<!--- Last Update --->
									<td>
										#LSDateFormat(rc.rstop.lastupdate,session.dateKeyFormat)# 
										#LSTimeFormat(rc.rstop.lastupdate,"medium")#
									</td>
									<!--- /Last Update --->
									
									<!--- Actions --->
									<td class="actions">
										<ul class="#lcase(rc.rstop.type)#">
											<cfif verdict neq 'none'>
												<li class="edit<cfif isLockedBySomeoneElse> disabled</cfif>">
													<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" href="./?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#">
														<i class="icon-pencil"></i>
													</a>
												</li>
												<li class="version-history">
													<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" href="./?muraAction=cArch.hist&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#">
														<i class="icon-book"></i>
													</a>
												</li>
												<cfif rc.moduleid eq '00000000000000000000000000000000004'>
													<li class="manage-data">
														<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#" href="./?muraAction=cArch.datamanager&contentid=#rc.rstop.ContentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&contenthistid=#rc.rstop.ContentHistID#&topid=#esapiEncode('url',rc.topid)#&parentid=#esapiEncode('url',rc.parentid)#&type=Form">
															<i class="icon-wrench"></i>
														</a>
													</li>
												</cfif>
												<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
													<li class="permissions">
														<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#" href="./?muraAction=cPerm.main&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">
															<i class="icon-group"></i>
														</a>
													</li>
												</cfif>
											<cfelse>
												<li class="edit disabled">
													<a>
														<i class="icon-pencil"></i>
													</a>
												</li>
												<li class="version-history disabled">
													<i class="icon-book"></i>
												</li>
												<cfif rc.moduleid eq '00000000000000000000000000000000004'>
													<li class="manage-dataOff disabled">
														<i class="icon-wrench"></i>
													</li>
												</cfif>
												<li class="permissions disabled">
													<a>
														<i class="icon-group"></i>
													</a>
												</li>
											</cfif>
											<cfif (((rc.locking neq 'all') or (rc.parentid eq '#rc.topid#' and rc.locking eq 'none')) and (verdict eq 'editor') and not rc.rsTop.isLocked eq 1) and not isLockedBySomeoneElse>
												<li class="delete">
													<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="./?muraAction=cArch.update&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&action=deleteall&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&parentid=#esapiEncode('url',rc.parentid)##rc.$.renderCSRFTokens(context=rc.rstop.contentid & 'deleteall',format='url')#" onClick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)">
														<i class="icon-remove-sign"></i>
													</a>
												</li>
											<cfelseif rc.locking neq 'all'>
												<li class="delete disabled">
													<i class="icon-remove-sign"></i>
												</li>
											</cfif>
										</ul>
									</td>
									<!--- /Actions --->
								</tr>
							</cfoutput>
						<cfelse>
							<tr> 
								<td colspan="7" class="noResults">
									<cfoutput>
										#application.rbFactory.getKeyValue(session.rb,'sitemanager.noitemsinsection')#
									</cfoutput>
								</td>
							</tr>
						</cfif>
					</tbody>
				</table>

				<cfif rc.nextn.numberofpages gt 1>
					<cfoutput> 
						<cfset args=arrayNew(1)>
						<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
						<cfset args[2]=rc.nextn.totalrecords>

						<div class="mura-results-wrapper">
							<p class="clearfix search-showing">
								#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
							</p>
							<div class="pagination">
								<ul>
									<cfif rc.nextN.currentpagenumber gt 1>
					
										<li>    
											<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&topid=#esapiEncode('url',rc.topid)#&startrow=#rc.nextN.previous#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">
												&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.prev')#
											</a>
										</li>
									 </cfif>
						
									<cfloop from="#rc.nextn.firstPage#"  to="#rc.nextn.lastPage#" index="i">
										<cfif rc.nextn.currentpagenumber eq i> 
											<li class="active"><a href="##">#i#</a></li> 
										<cfelse> 
											<li>
												<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&topid=#esapiEncode('url',rc.topid)#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">
													#i#
												</a>
											</li>
										</cfif>
									</cfloop>
						<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
							<li>
								<a href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&topid=#esapiEncode('url',rc.topid)#&startrow=#rc.nextN.next#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.next')#&nbsp;&raquo;</a>
							</li>
						</cfif>
						</ul>
						</div>
					</div>
				</cfoutput>
					
		   </cfif>
		</div>

		<cfoutput>
			<div class="sidebar span3">
				<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#</h2>
				<form class="form-inline" novalidate="novalidate" id="filterByTitle" action="index.cfm" method="get">
					  <input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#" />
					  <input type="hidden" name="topid" value="#rc.topID#" />
					  <input type="hidden" name="parentid" value="#rc.parentID#" />
					  <input type="hidden" name="moduleid" value="#rc.moduleID#" />
					  <input type="hidden" name="sortBy" value="" />
					  <input type="hidden" name="sortDirection" value="" />
					  <input type="hidden" name="muraAction" value="cArch.list" />
			   
					<div id="filters" class="module well">
					<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.keywords")#</h3>
					 <input type="text" name="searchString" id="searchString" value="#esapiEncode('html_attr',rc.searchString)#" class="text" size="20">
					</div>

					<div class="module well" id="mura-filter-tags">
						<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</h3>

						<div id="tags" class="tagSelector">
							<cfloop list="#$.event('tags')#" index="i">
								<span class="tag">
								#esapiEncode('html',i)# <a><i class="icon-remove-sign"></i></a>
								<input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
								</span>
							</cfloop>
							<input type="text" name="tags">
						</div>
					</div>

					<cfif len($.siteConfig('customTagGroups'))>
						<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
							<div class="module well" id="mura-filter-tags">
								<h3>#g# #application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</h3>
								<div id="#g#tags" class="tagSelector">
									<cfloop list="#$.event('#g#tags')#" index="i">
										<span class="tag">
										#esapiEncode('html',i)# <a><i class="icon-remove-sign"></i></a>
										<input name="#g#tags" type="hidden" value="#esapiEncode('html_attr',i)#">
										</span>
									</cfloop>
									<input type="text" name="#g#tags">
								</div>
							</div>
						</cfloop>
					</cfif>

					<cfif $.getBean("categoryManager").getCategoryCount($.event("siteID"))>
						<div class="module well" id="mura-list-tree">
							<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#</h3>
							<cf_dsp_categories_nest siteID="#$.event('siteID')#" parentID="" nestLevel="0" categoryid="#$.event('categoryid')#">
						</div>
					</cfif>

					<input type="submit" class="btn" name="filterList" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")#"/>
					<cfif len($.event('categoryID') & $.event('tags') & $.event('searchString'))>
					<input type="button" class="btn" name="removeFilter" id="removeFilter" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")#" onclick=""/>
					</cfif>
				 </form>

				 <script>
					var customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups'),"^,"))#;

					$(function(){
						$.ajax({
							url:'?muraAction=carch.loadtagarray&siteid=' + siteid,
							dataType: 'text',
							success: function(data){
								var tagArray=eval('(' + data + ')'); 
								$('##tags').tagSelector(tagArray, 'tags');
							}
						});

						if(customtaggroups.length){
							for(var g=0;g < customtaggroups.length; g++){
								
								if(window[customtaggroups[g]]){
									$('##' + customtaggroups[g] + 'tags').tagSelector(window[customtaggroups[g]], customtaggroups[g] + 'tags');
								}else{
									$.ajax({url:'?muraAction=carch.loadtagarray&siteid=' + siteid + '&taggroup=' + customtaggroups[g],
											context:{taggroup:customtaggroups[g]},
											dataType: 'text',
											success:function(data){
												window[this.taggroup]=eval('(' + data + ')'); 
												$('##' + this.taggroup + 'tags').tagSelector(window[this.taggroup], this.taggroup + 'tags');
											}
										});
								}
								
							}
						}
					});     

					$('##removeFilter').click(
						function(){
							$('span.tag').remove();
							$("input[name='tags']").val('');
							$('##searchString').val('');
							$('input[name=categoryID]').attr('checked', false);
							<cfif len($.siteConfig('customTagGroups'))>
							<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
							$("input[name='#g#tags']").val('');
							</cfloop>
							</cfif>
							document.getElementById('filterByTitle').submit();

						}
					 ); 

				</script>
			</div>
		</cfoutput>

		<cfinclude template="draftpromptjs.cfm">
	</cfcase>

	<cfcase value="00000000000000000000000000000000000">
		<cfsilent>
			<cfset crumbdata=application.contentManager.getCrumbList(rc.topid,rc.siteid)>

			<cfif isdefined('rc.nextN') and rc.nextN gt 0>
			  <cfset session.mura.nextN=rc.nextN>
			  <cfset rc.startrow=1>
			</cfif>

			<cfif not isDefined('rc.saveSort')>
			  <cfset rc.sortBy=rc.rstop.sortBy />
			  <cfset rc.sortDirection=rc.rstop.sortDirection />
			</cfif>

			<cfparam name="rc.sortBy" default="#rc.rstop.sortBy#" />
			<cfparam name="rc.sortDirection" default="#rc.rstop.sortDirection#" />
			<cfparam name="rc.sorted" default="false" />
			<cfparam name="rc.lockid" default="" />
			<cfparam name="rc.assignments" default="false" />
			<cfparam name="rc.categoryid" default="" />
			<cfparam name="rc.tags" default="" />
			<cfparam name="rc.type" default="" />
			<cfparam name="rc.page" default="1" />
			<cfparam name="rc.subtype" default="" />

			<cfif len($.siteConfig('customTagGroups'))>
				<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
					<cfparam name="rc.#g#tags" default="" />
				</cfloop>
			</cfif>

			<cfparam name="session.copyContentID" default="">
			<cfparam name="session.copySiteID" default="">
			<cfparam name="session.copyAll" default="false">
			<cfparam name="session.flatViewArgs" default="#structNew()#">
			<cfparam name="session.flatViewArgs" default="#structNew()#">

			<cfscript>
				if(not structKeyExists(session.flatViewArgs,session.siteid)){
					session.flatViewArgs["#session.siteid#"]=structNew();
				}

				if(structkeyExists(rc,'refreshFlatview')){
					session.flatViewArgs["#session.siteid#"].report=rc.report;
					if(structKeyExists(rc,'reportSortBy')){
						session.flatViewArgs["#session.siteid#"].sortby=rc.reportSortBy;
					}
					if(structKeyExists(rc,'reportSortDirection')){
						session.flatViewArgs["#session.siteid#"].direction=rc.reportSortDirection;
					}
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"moduleid")){
					session.flatViewArgs["#session.siteid#"].moduleid=rc.moduleid;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortby")){
					session.flatViewArgs["#session.siteid#"].sortby="lastupdate";
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortdirection")){
					session.flatViewArgs["#session.siteid#"].sortdirection="desc";
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"lockid")){
					session.flatViewArgs["#session.siteid#"].lockid=rc.lockid;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"assignments")){
					session.flatViewArgs["#session.siteid#"].assignments=rc.assignments;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"categoryid")){
					session.flatViewArgs["#session.siteid#"].categoryid=rc.categoryid;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tags")){
					session.flatViewArgs["#session.siteid#"].tags=rc.tags;
				}

				if(len($.siteConfig('customTagGroups'))){
					taggrouparray=listToArray($.siteConfig('customTagGroups'),"^,");
					for(g=1;g <= arrayLen(taggrouparray);g++){
						if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"#taggrouparray[g]#tags")){
							session.flatViewArgs["#rc.siteID#"]["#taggrouparray[g]#tags"]=rc["#taggrouparray[g]#tags"];
						}
					}
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"page")){
					session.flatViewArgs["#session.siteid#"].page=rc.page;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"type")){
					session.flatViewArgs["#session.siteid#"].type="";
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"subtype")){
					session.flatViewArgs["#session.siteid#"].subtype=rc.subtype;
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"report")){
					session.flatViewArgs["#session.siteid#"].report="";
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"keywords")){
					session.flatViewArgs["#session.siteid#"].keywords="";
				}
				
				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tab")){
					session.flatViewArgs["#session.siteid#"].tab=0;
				}

				if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"filtered") or not isBoolean((session.flatViewArgs["#session.siteid#"].filtered))){
					session.flatViewArgs["#session.siteid#"].filtered=false;
				}
			</cfscript>

			<cfif not isdefined("url.activeTab")>
				<cfset rc.activeTab=session.flatViewArgs["#session.siteID#"].tab/>
			</cfif>

			<cfif isdefined("url.keywords")>
				<cfif session.flatViewArgs["#session.siteID#"].keywords neq url.keywords>
					<cfset session.flatViewArgs["#session.siteID#"].page=1>
				</cfif>
				<cfset session.flatViewArgs["#session.siteID#"].keywords=url.keywords/>
				<cfset session.flatViewArgs["#session.siteID#"].report=""/>
				<cfset session.keywords=url.keywords/>
			</cfif>

			<cfhtmlhead text='<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-pulse.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>

			<cfif isdefined('rc.orderperm') and (rc.orderperm eq 'editor' or (rc.orderperm eq 'author' and application.configBean.getSortPermission() eq "author"))>
				<cflock type="exclusive" name="editingContent#rc.siteid#" timeout="60">
					<cfif rc.sorted>
						<cfset current=application.serviceFactory.getBean("content").loadBy(contentID=rc.topID, siteid=rc.siteID)>
						<cfif rc.sortBy eq 'orderno'>
							<cfset rc.sortDirection='asc'>
						</cfif>
						<cfset current.setSortBy(rc.sortBy)>
						<cfset current.setSortDirection(rc.sortDirection)>
						<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
						<cfset variables.pluginEvent.setValue("contentBean")>
						<cfset application.pluginManager.announceEvent("onBeforeContentSort",pluginEvent)>
					</cfif>
					
					<cfif isdefined('rc.orderid') >
						<cfloop from="1" to="#listlen(rc.orderid)#" index="i">
							<cfset newOrderNo=(rc.startrow+i)-1>
							<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
							update tcontent set orderno= #newOrderNo# where contentid ='#listgetat(rc.orderid,i)#'
							</cfquery>
						</cfloop>
					</cfif>

					<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
					update tcontent set sortBy='#rc.sortBy#',sortDirection='#rc.sortDirection#' where contentid ='#rc.topid#'
					</cfquery>

					<cfif rc.sortBy eq 'orderno' and  not isdefined('rc.orderid')>
						<cfset rsSetOrder=application.contentManager.getNest('#rc.topid#',rc.siteid,rc.rsTop.sortBy,rc.rsTop.sortDirection)>
						<cfloop query="rsSetOrder">
							<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
							update tcontent set orderno= #rsSetOrder.currentrow# where contentid ='#rsSetOrder.contentID#'
							</cfquery>
						</cfloop>
					</cfif>
					
					<cfif rc.sorted>
						<cfset application.pluginManager.announceEvent("onAfterContentSort",pluginEvent)>
					</cfif>
					
					<cfset application.settingsManager.getSite(rc.siteid).purgeCache()>
				</cflock>
			</cfif>

			<cfif not len(crumbdata[1].siteid)>
				<cflocation url="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001" addtoken="false"/>
			</cfif>
		</cfsilent>

		<cfoutput>
			<script>
				siteID='#session.siteID#';
				<cfif session.copySiteID eq rc.siteID>
				copyContentID = '#session.copyContentID#';
				copySiteID = '#session.copySiteID#';
				copyAll = '#session.copyAll#';
				<cfelse>
				copyContentID = '';
				copySiteID = '';
				copyAll = 'false';
				</cfif>
			</script>
		 
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h1>

			<form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
				<div class="input-append">
					<input name="keywords" value="#esapiEncode('html_attr',session.keywords)#" type="text" class="text" />
					<button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);">
						<i class="icon-search"></i>
					</button>
				</div>
				<input type="hidden" name="muraAction" value="cArch.list">
				<input type="hidden" name="activetab" value="1">
				<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
				<input type="hidden" name="moduleid" value="#rc.moduleid#">
			</form>

			<div class="tabbable">
				<ul id="viewTabs" class="nav nav-tabs tabs initActiveTab">
					<li><a href="##tabArchitectural" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.architectural")#</a></li>
					<li><a href="##tabFlat" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.flat")#</a></li>
				</ul>
				<div class="tab-content"> 
					<div id="tabArchitectural" class="tab-pane fade">
						<div id="gridContainer">
							
						</div>
					</div>
					<div id="tabFlat" class="tab-pane fade">
						<div id="flatViewContainer">
							
						</div>
					</div>
				</div>
			</div>

			<script type="text/javascript">
				var archViewLoaded=false;
				var flatViewLoaded=false;
				var tabsInited=false;
				var customtaggroups=#serializeJSON(listToArray($.siteConfig('customTagGroups'),"^,"))#;

				function initFlatViewArgs(){
					return {
						siteid:'#esapiEncode('javascript',session.siteID)#', 
						moduleid:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].moduleid)#', 
						sortby:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].sortby)#', 
						sortdirection:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].sortdirection)#', 
						page:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].page)#',   
						tags:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].tags)#',
						categoryid:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].categoryid)#',
						lockid:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].lockid)#',
						type:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].type)#',
						subtype:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].subtype)#',
						report:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].report)#',
						keywords:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].keywords)#',
						filtered: '#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].filtered)#'
						<cfif len($.siteConfig('customTagGroups'))>
							<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
								,#g#tags:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"]["#g#tags"])#'  
							</cfloop>   
						</cfif>
					};
				}

				var newContentMenuTitle='#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.selectcontenttype"))#';
				var flatViewArgs=initFlatViewArgs();

				function initSiteManagerTabContent(index){
					jQuery.get("./index.cfm","muraAction=carch.siteManagerTab&tab=" + index);
					
					if(!tabsInited){
						jQuery("##viewTabs a[href='##tabArchitectural']").click(function(e){
							e.preventDefault();
							initSiteManagerTabContent(0);
						});
						jQuery("##viewTabs a[href='##tabFlat']").click(function(e){
							e.preventDefault();
							initSiteManagerTabContent(1);
						});
						tabsInited=true;
					}   

					switch(index){
						case 0:
						if (!archViewLoaded) {
							jQuery('##viewTabs a[href="##tabArchitectural"]').tab('show');
							siteManager.loadSiteManager('#esapiEncode('javascript',rc.siteID)#', '#esapiEncode('javascript',rc.topid)#', '#esapiEncode('javascript',rc.moduleid)#', '#esapiEncode('javascript',rc.sortby)#', '#esapiEncode('javascript',rc.sortdirection)#', '#esapiEncode('javascript',rc.ptype)#', '#esapiEncode('javascript',rc.startrow)#');
							archViewLoaded = true;
						}
						break;
						case 1:
						if (!flatViewLoaded) {
							jQuery('##viewTabs a[href="##tabFlat"]').tab('show');
							siteManager.loadSiteFlat(flatViewArgs);
							flatViewLoaded = true;
						}
					}
				}


				jQuery(document).ready(function(){
					initSiteManagerTabContent(#rc.activeTab#);  
				});
			</script>
		</cfoutput>
		<cfinclude template="draftpromptjs.cfm">
	</cfcase>
</cfswitch>