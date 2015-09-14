<cfset rc.rsmailinglists = application.contentUtility.getMailingLists(rc.siteid)/>
<cfoutput>
<div class="fieldset-wrap row-fluid">
	<div class="fieldset">
		<div class="control-group">
			<div class="controls">
			<select id="availableObjectSelector">
				<option value="{object:'system',name:'#esapiEncode('html_attr','Select Mailing List')#',objectid:''}">
						-- Select Mailing List --
					</option>

				<option <cfif rc.object eq 'mailing_list_master'>selected </cfif>value="{'object':'mailing_list_master','name':'#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mastermailinglistsignupform'))#','objectid':'none'}">
					#application.rbFactory.getKeyValue(session.rb, 
				                                    'sitemanager.content.fields.mastermailinglistsignupform')#
				</option>
				<cfloop query="rc.rsmailinglists">
					<option <cfif rc.object eq 'mailing_list' and rc.objectid eq rc.rsmailinglists.mlid>selected </cfif>value="{'object':'mailing_list','name':'#esapiEncode('html_attr','Mailing List')#','objectid':'#rc.rsmailinglists.mlid#'}">
						#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.mailinglist')# 
						- 
						#rc.rsmailinglists.name#
					</option>
				</cfloop>
			</select>
			</div>
		</div>
	</div>
</div>
</cfoutput>