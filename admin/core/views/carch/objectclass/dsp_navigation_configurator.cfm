<cfsilent>
	<cfset rc.rsObjects = application.contentManager.getSystemObjects(rc.siteid)/>
	<cfquery name="rc.rsObjects" dbtype="query">
		select * from rc.rsObjects where object like '%nav%'
	</cfquery>
</cfsilent>
<cfoutput>
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
			<div class="controls">
				<label class="control-label">Select Navigation</label>
				<select id="availableObjectSelector">
					<option value="{object:'system',name:'#esapiEncode('html_attr','Select Navigation')#',objectid:''}">
					--
					</option>
					<cfloop query="rc.rsObjects">
						<option <cfif rc.object eq rc.rsobjects.object>selected </cfif>title="#esapiEncode('html_attr',rc.rsObjects.name)#" value='{"object":"#esapiEncode('javascript',rc.rsobjects.object)#","name":"#esapiEncode('javascript','Navigation')#","objectid":"#createUUID()#"}'>
							#esapiEncode('html',rc.rsObjects.name)#
						</option>
					</cfloop>
				</select>
			</div>
		</div>
	</div>
</div>
</cfoutput>