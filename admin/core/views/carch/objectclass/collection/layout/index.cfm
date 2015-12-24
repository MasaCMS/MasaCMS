<cfsilent>
<cfparam name="objectParams.maxitems" default="4">
<cfparam name="objectParams.displaylist" default="Image,Date,Title,Summary,Credits,Tags">
<cfset feed=rc.$.getBean("feed").loadBy(feedID=objectParams.source)>
<cfset feed.set(objectParams)>
<cfparam name="objectParams.sourcetype" default="local">
</cfsilent>
<cfoutput>
	<cfif objectParams.sourcetype neq "remotefeed">		
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.layout')#
			</label>
			<div class="controls">
				<cfset layouts=rc.$.siteConfig().getLayouts('collection/layouts')>
				<cfset layout=feed.getLayout()>
				<cfset layout=(len(layout)) ? layout :' default'>
				<select name="layout" class="objectParam span12">
					<option value="default"<cfif feed.getLayout() eq "default"> selected</cfif>>default</option>
					<cfloop query="layouts">
						<cfif layouts.name neq 'default'>
						<option value="#layouts.name#"<cfif feed.getLayout() eq layouts.name> selected</cfif>>#layouts.name#</option>
						</cfif>
					</cfloop>
				</select>
			</div>
		</div>

		<!---- Begin layout based configuration --->
		<cfset configFile=rc.$.siteConfig('themeIncludePath') & "/display_objects/collection/layouts/#layout#/configurator.cfm">
		<cfif fileExists(expandPath(configFile))>
			<cfinclude template="#configFile#">
		<cfelse>
			<cfset configFile=rc.$.siteConfig('includePath') & "/includes/display_objects/custom/collection/layouts/#layout#/configurator.cfm">
			<cfif fileExists(expandPath(configFile))>
				<cfinclude template="#configFile#">
			<cfelse>
				<cfset configFile=rc.$.siteConfig('includePath') & "/includes/display_objects/collection/layouts/#layout#/configurator.cfm">
				<cfif fileExists(expandPath(configFile))>
					<cfinclude template="#configFile#">
				</cfif>
			</cfif>
		</cfif>
		<script>
			$('select[name="layout"]').on('change',setLayoutOptions);
		</script>
		<!---  End layout based configuration --->

		<cfif objectParams.object eq 'collection'>
			<div class="control-group">
				<div class="span12">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
					</label>
					<div class="controls">
						<input name="viewalllink" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="span12">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
					</label>
					<div class="controls">
						<input name="viewalllabel" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
					</div>
				</div>
			</div>
		</cfif>
		<cfif objectParams.object eq 'collection'>
			<div class="control-group">
				<div class="span6">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
					<div class="controls">
						<select name="maxItems" data-displayobjectparam="maxItems" class="objectParam span12">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
						<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
						</cfloop>
						<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>All</option>
						</select>
					</div>
				</div>
				<div class="span6">
				      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
						<div class="controls"><select name="nextN" data-displayobjectparam="nextN" class="objectParam span12">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
						<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
						</cfloop>
						<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>All</option>
						</select>
					  </div>
				</div>
			</div>
		</cfif>
	<cfelse>
		<cfset displaySummaries=yesNoFormat(feed.getValue("displaySummaries"))>
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#
			</label>
			<div class="controls">
				<label class="radio inline">
					<input name="displaySummaries" type="radio" value="1" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();"<cfif displaySummaries>checked</cfif>>
					#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				</label>
				<label class="radio inline">
					<input name="displaySummaries" type="radio" value="0" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not displaySummaries>checked</cfif>>
					#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</label>
			</div>
		</div>
		<div class="control-group">
			<div class="span12">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
				</label>
				<div class="controls">
					<input name="viewalllink" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="span12">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
				</label>
				<div class="controls">
					<input name="viewalllabel" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
				</div>
			</div>
		</div>
</cfif>
</cfoutput>
