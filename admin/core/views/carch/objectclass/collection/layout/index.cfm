<cfsilent>
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfset params=deserializeJSON(form.params)>
<cfparam name="params.maxitems" default="4">
<cfparam name="params.displaylist" default="Date,Title,Summary,Credits,Tags">
<cfset feed=$.getBean("feed").loadBy(feedID=params.source)>
<cfset feed.set(params)>
<cfparam name="params.sourcetype" default="local">

</cfsilent>
<cfoutput>
	<cfif params.sourcetype neq "remotefeed">		
		<div class="control-group">
			<div class="span12">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.layout')#
				</label>
				<div class="controls">
					<select name="layout" class="objectParam span12">
						<cfloop list="a,b,c,d,e" index="i">
							<option name="#i#"<cfif feed.getLayout() eq i> selected</cfif>>#i#</option>
						</cfloop>
					</select>
				</div>
			</div>
		</div>
		

		<div class="control-group" id="availableFields">
			<label class="control-label">
				<span class="span6">Selected Fields</span>
				<button id="editFields" class="btn">Edit</button>
				<script>
					$(function(){
						$('##editFields').click(function(){
							frontEndProxy.post({
								cmd:'openModal',
								src:'?muraAction=cArch.selectfields&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&displaylist=' + $("##displayList").val()
								}
							);
						});
					});
				</script>	
			</label>
			<div id="sortableFields" class="controls sortable-sidebar">
				<cfset displayList=feed.getDisplayList()>
				<ul id="displayListSort" class="displayListSortOptions">
					<cfloop list="#displayList#" index="i">
						<li class="ui-state-highlight">#trim(i)#</li>
					</cfloop>
				</ul>
				
				<input type="hidden" id="displayList" class="objectParam" value="#esapiEncode('html_attr',feed.getDisplayList())#" name="displayList"  data-displayobjectparam="displayList"/>
			</div>	
		</div>
		<!---
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
		--->

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
