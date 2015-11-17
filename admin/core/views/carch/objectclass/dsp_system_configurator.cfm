<cfsilent>
	<cfset rc.rsObjects = application.contentManager.getSystemObjects(rc.siteid)/>
	<cfquery name="rc.rsObjects" dbtype="query">
		select * from rc.rsObjects where object not like '%nav%'
		<cfif not application.settingsManager.getSite(rc.siteid).getHasComments()>
			and object != 'comments'
		</cfif>
		and object != 'payPalCart'
		and object != 'related_content'
		and object != 'tag_cloud'
		and object != 'goToFirstChild'
	</cfquery>
</cfsilent>
<cf_objectconfigurator>
<cfoutput>
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Select System Object</label>
			<div class="controls">
				<select id="availableObjectSelector" class="span12">
					<option  value="{object:'system',name:'#esapiEncode('html_attr','Select System Object')#',objectid:''}">
						Select System Object
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
</cf_objectconfigurator>