<cfsilent>
	<cfset rc.rsObjects = application.contentManager.getSystemObjects(rc.siteid)/>
	<cfquery name="rc.rsObjects" dbtype="query">
		select * from rc.rsObjects where object like '%nav%'
	</cfquery>
</cfsilent>

<cf_objectconfigurator>
<cfoutput>
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Select Navigation</label>
			<div class="controls">
				<select id="availableObjectSelector" class="span12">
					<option value="{object:'navigation',name:'#esapiEncode('html_attr','Select Navigation')#',objectid:''}">
						Select Navigation
					</option>
					<cfloop query="rc.rsObjects">
						<option <cfif rc.object eq rc.rsobjects.object>selected </cfif>title="#esapiEncode('html_attr',rc.rsObjects.name)#" value='{"object":"#esapiEncode('javascript',rc.rsobjects.object)#","name":"#esapiEncode('javascript','Navigation')#","objectid":"#createUUID()#"}'>
							#esapiEncode('html',rc.rsObjects.name)#
						</option>
					</cfloop>
					<option <cfif rc.object eq 'archive_nav'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation'))#" value='{"object":"archive_nav","name":"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation'))#","objectid":"none"}'>
							#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation'))#
						</option>
						<option <cfif rc.object eq 'category_summary'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary'))#" value='{"object":"category_summary","name":"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary'))#","objectid":"none"}'>
							#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary'))#
						</option>
						<option <cfif rc.object eq 'calendar_nav'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation'))#" value='{"object":"calendar_nav","name":"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation'))#","objectid":"none"}'>
							#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation'))#
						</option>
						<option <cfif rc.object eq 'tag_cloud'>selected </cfif>title="Tag Cloud" value='{"object":"tag_cloud","name":"Tag Cloud","objectid":"none"}'>
							Tag Cloud
						</option>
				</select>
			</div>
		</div>
	</div>
</div>
</cfoutput>
</cf_objectconfigurator>
