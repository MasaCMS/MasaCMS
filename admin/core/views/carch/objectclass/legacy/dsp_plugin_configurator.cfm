<cfsilent>
	<cfparam name="rc.subclassid" default="">

	<cfif listLen(rc.subclassid) gt 1>
		<cfset rc.objectid = listLast(rc.subclassid)>
		<cfset rc.subclassid = listFirst(rc.subclassid)>
	</cfif>

	<cfif isDefined("form.params") and isJSON(form.params)>
		<cfset structAppend(rc,deserializeJSON(form.params))>
	</cfif>

	<cfset rc.rsPlugins = application.pluginManager.getDisplayObjectsBySiteID(
		siteID=rc.siteid,
	    modulesOnly=true
	)/>

	<cfif (!isdefined('rc.subclassid') or !len(rc.subclassid)) && isdefined('rc.moduleid') and len(rc.moduleid)>
		<cfset rc.subclassid=rc.moduleid>
	</cfif>
</cfsilent>
<cfoutput>
<cf_objectconfigurator>
	<div class="mura-layout-row">
		<div class="mura-control-group">
			<label>Select Plugin</label>
			<select name="subClassSelector"
			        onchange="siteManager.loadObjectClass('#rc.siteid#','plugin',this.value,'#rc.contentid#','#rc.parentid#','#rc.contenthistid#',0,0);">
				<option value="">
					#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.selectplugin')#
				</option>
				<cfloop query="rc.rsPlugins">
					<cfif application.permUtility.getModulePerm(rc.rsPlugins.moduleID, rc.siteid)>
						<option title="#esapiEncode('html_attr',rc.rsPlugins.title)#" value="#rc.rsPlugins.moduleID#" <cfif rc.rsPlugins.moduleID eq rc.subclassid>selected</cfif>>#esapiEncode('html',rc.rsPlugins.title)#</option>
					</cfif>
				</cfloop>
			</select>
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

						<select name="customObjectSelector"
						        onchange="siteManager.loadObjectClass('#rc.siteid#','plugin',this.value,'#rc.contentid#','#rc.parentid#','#rc.contenthistid#',0,0);">
							<option value="">
								#application.rbFactory.getKeyValue(session.rb,
							                                    'sitemanager.content.fields.selectplugindisplayobjectclass')#
							</option>
							<cfloop query="rs">
								<cfif application.permUtility.getModulePerm(rs.moduleID, rc.siteid)>
									<option title="#esapiEncode('html_attr',rs.name)#" value="#rs.moduleID#,#rs.objectID#" <cfif rs.objectID eq rc.objectID>selected</cfif>>#esapiEncode('html',rs.name)#</option>
								</cfif>
							</cfloop>
						</select>
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
						<select id="availableObjectSelector" class="multiSelect"
				        size="#evaluate((application.settingsManager.getSite(rc.siteid).getcolumnCount() * 6)-4)#">
							<cfloop query="rs">
								<option value="{'object':'plugin','name':'#esapiEncode('javascript','#rs.name#')#','objectid':'#rs.objectID#',moduleid:'#rs.moduleid#'}" <cfif rc.objectid eq rs.objectid>selected</cfif>>
									#rs.name#
								</option>
							</cfloop>
						</select>
					</cfif>
				<cfelse>
					#customOutput#
				</cfif>
			</cfif>
		</div>
	</div>
</cf_objectconfigurator>
</cfoutput>
