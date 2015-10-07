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
				<select id="availableObjectSelector">
					<option value="{object:'navigation',name:'#esapiEncode('html_attr','Select Navigation')#',objectid:''}">
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
</cf_objectconfigurator>
