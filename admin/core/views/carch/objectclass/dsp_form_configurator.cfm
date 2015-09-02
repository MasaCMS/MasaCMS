
<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
<cfif rc.configuratorMode neq 'backEnd' and content.exists()>
<cfoutput>
<div id="availableObjectParams"
		data-object="#esapiEncode('html_attr',rc.classid)#" 
		data-name="#esapiEncode('html_attr',content.getTitle())#" 
		data-objectid="#esapiEncode('html_attr',rc.objectid)#">
	<cfif listFindNoCase('Author,Editor',application.permUtility.getDisplayObjectPerm(content.getSiteID(),"component",content.getContentID()))>
		<script>
			window.location='#content.getEditURL(compactDisplay=true)#&homeid=#esapiEncode('url',rc.contentid)#';
		</script>
	<cfelse>
		<p class="alert alert-error">
			You do not have permission to edit this form.
		</p>	
	</cfif>
</div>
</cfoutput>
<cfelse>
<cfoutput>
<cfset rc.rsForms = application.contentManager.getComponentType(rc.siteid, 'Form')/>
<div class="fieldset-wrap row-fluid">
	<div class="fieldset">
		<div class="control-group">
			<div class="controls">
				<select id="availableObjectSelector">
					<option value="{object:'form',name:'#esapiEncode('html_attr','Select Form')#',objectid:''}">
						-- Select Form --
					</option>

					<cfloop query="rc.rsForms">

						<cfset title=iif(rc.rsForms.responseChart eq 1, 
						      de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.poll')#'),
						      de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datacollector')#')) 
							& ' - ' 
							& rc.rsForms.menutitle>

						<option <cfif rc.objectid eq rc.rsForms.contentid and rc.object eq 'form'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="{object:'form',name:'#esapiEncode('html_attr',title)#',objectid:'#rc.rsForms.contentid#'}">
							#esapiEncode('html',title)#
						</option>
						<!---
						<cfif rc.rsForms.responseChart neq 1>

							<cfset title=application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.dataresponses')
								& ' - ' 
								& rc.rsForms.menutitle>
								
							<option <cfif rc.objectid eq rc.rsForms.contentid and rc.object eq 'form_responses'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="{'object':'form_responses','name':'#esapiEncode('html_attr',title)#','objectid':'#rc.rsForms.contentid#'}">
								#esapiEncode('html',title)#
							</option>
						</cfif>
						--->
					</cfloop>
				</select>
			</div>
		</div>
	</div>
</div>
</cfoutput>
</cfif>
