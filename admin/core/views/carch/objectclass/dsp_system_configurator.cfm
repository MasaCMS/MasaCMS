<cfsilent>
	<cfset rc.rsObjects = application.contentManager.getSystemObjects(rc.siteid)/>
	<cfquery name="rc.rsObjects" dbtype="query">
		select * from rc.rsObjects where object not like '%nav%'
		<cfif not application.settingsManager.getSite(rc.siteid).getHasComments()>
			and object != 'comments'
		</cfif>
		and object != 'payPalCart'
		and object != 'related_content'
		and object != 'goToFirstChild'
	</cfquery>
</cfsilent>
<cfoutput>
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
			<div class="controls">
				<select id="availableObjectSelector">
					<option  value="{object:'system',name:'#esapiEncode('html_attr','Select System Object')#',objectid:''}">
						-- Select System Object --
					</option>

					<cfloop query="rc.rsObjects">
						<option <cfif rc.object eq rc.rsobjects.object>selected </cfif>title="#esapiEncode('html_attr',rc.rsObjects.name)#" value='{"object":"#esapiEncode('javascript',rc.rsobjects.object)#","name":"#esapiEncode('javascript',rc.rsObjects.name)#","objectid":"#createUUID()#"}'>
							#esapiEncode('html',rc.rsObjects.name)#
						</option>
					</cfloop>
				</select>
			</div>
		</div>
	</div>
</div>
</cfoutput>