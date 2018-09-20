<cfoutput>

<!--- new sidebar markup --->
	<div class="mura__edit__controls">
		<div class="mura__edit__controls__scrollable">
			<div class="mura__edit__controls__objects">
				<div id="mura-edit-tabs" class="mura__edit__controls__tabs">

					<div class="mura-panel-group" id="content-panels" role="tablist" aria-multiselectable="true">

						<!--- basic --->
						<cfif rc.type eq "Form">
							<cfif rc.contentBean.getIsNew() and not (isdefined("url.formType") and url.formType eq "editor")>
								<cfset rc.contentBean.setBody( application.serviceFactory.getBean('formBuilderManager').createJSONForm( rc.contentBean.getContentID() ) ) />
							</cfif>
							<cfif isJSON(rc.contentBean.getBody())>
								<cfinclude template="form/dsp_panel_formbuilder.cfm">
							<cfelse>
								<cfinclude template="form/dsp_panel_basic.cfm">
							</cfif>
						<cfelse>
							<cfinclude template="form/dsp_panel_basic.cfm">
						</cfif>
						<!--- /basic --->

						<!--- publishing --->
						<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Publishing')>						
								<cfinclude template="form/dsp_panel_publishing.cfm">
						</cfif>		
						<!--- /publishing --->

						<!--- list display options --->
						<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not rc.$.getContentRenderer().useLayoutManager() and listFindNoCase('Page,Folder,Gallery,Calender',rc.type) and (not len(tabAssignments) or listFindNocase(tabAssignments,'List Display Options')))>
							<cfinclude template="form/dsp_panel_listdisplayoptions.cfm">
						</cfif>
						<!--- /list display options --->

						<!--- layoutobjects,categories,related_content,tags,usage --->
						<cfswitch expression="#rc.type#">
							<cfcase value="Page,Folder,Calendar,Gallery">
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Layout & Objects'))>
									<cfif listFind(session.mura.memberships,'S2IsPrivate')>
										<cfinclude template="form/dsp_panel_layoutobjects.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
									<cfinclude template="form/dsp_panel_related_content.cfm">
								<cfelse>
									<input type="hidden" name="ommitRelatedContentTab" value="true">
								</cfif>
							</cfcase>
							<cfcase value="Link,File">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteid)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
									<cfinclude template="form/dsp_panel_related_content.cfm">
								<cfelse>
									<input type="hidden" name="ommitRelatedContentTab" value="true">
								</cfif>
							</cfcase>
							<cfcase value="Variation">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
							</cfcase>
							<cfcase value="Component">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
									<cfif not rc.contentBean.getIsNew()>
										<cfinclude template="form/dsp_panel_usage.cfm">
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="Form">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
									<cfif not rc.contentBean.getIsNew()>
										<cfinclude template="form/dsp_panel_usage.cfm">
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
						<!--- /layoutobjects,categories,related_content,tags,usage  --->

						<!--- extended attributes --->
						<cfif listFindNoCase(rc.$.getBean('contentManager').ExtendableList,rc.type)>
							<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
								<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid).getExtendSets(activeOnly=true) />
								<cfinclude template="form/dsp_panel_extended_attributes.cfm">
							</cfif>
						</cfif>
						<!--- /extended attributes --->

						<!--- advanced --->
						<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Advanced')>
							<cfif listFind(session.mura.memberships,'S2IsPrivate')>
								<cfinclude template="form/dsp_panel_advanced.cfm">
							<cfelse>
								<input type="hidden" name="ommitAdvancedTab" value="true">
							</cfif>
						</cfif>
						<!--- /advanced --->

						<!--- plugin rendering --->
						<cfif arrayLen(pluginEventMappings)>
							<cfoutput>
								<cfset renderedEvents = '' />
								<cfset eventIdx = 0 />
								<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
									<cfset eventToRender = pluginEventMappings[i].eventName />

									<cfif ListFindNoCase(renderedEvents, eventToRender)>
										<cfset eventIdx++ />
									<cfelse>
										<cfset renderedEvents = ListAppend(renderedEvents, eventToRender) />
										<cfset eventIdx=1 />
									</cfif>

									<cfset renderedEvent=$.getBean('pluginManager').renderEvent(eventToRender=eventToRender,currentEventObject=$,index=eventIdx)>
									<cfif len(trim(renderedEvent))>
										<cfset tabLabel = Len($.event('tabLabel')) && !ListFindNoCase(tabLabelList, $.event('tabLabel')) ? $.event('tabLabel') : pluginEventMappings[i].pluginName />
										<cfset tabLabelList=listAppend(tabLabelList, tabLabel)/>
										<cfset tabID="tab" & $.createCSSID(tabLabel)>
										<cfif ListFind(tabList,tabID)>
											<cfset tabID = tabID & i />
										</cfif>
										<cfset tabList=listAppend(tabList,tabID)>
										<cfset pluginEvent.setValue("tabList",tabLabelList)>
										<div class="mura-panel panel">
											<div class="mura-panel-heading" role="tab" id="heading-#tabID#">
												<h4 class="mura-panel-title">
													<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-#tabID#" aria-expanded="false" aria-controls="panel-#tabID#">#tablabel#</a>
												</h4>
											</div>
											<div id="panel-#tabID#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-#tabID#" aria-expanded="false" style="height: 0px;">
												<div class="mura-panel-body">
													#renderedEvent#
												</div>
											</div>
										</div>
									</cfif>
								</cfloop>
							</cfoutput>
						</cfif>
						<!--- /plugin rendering --->
					</div>	

				</div>
			</div>
		</div>
	</div>

</cfoutput>