<cfparam name="objectParams.label" default="">
<cfoutput>
<div class="fieldset-wrap">
	<div class="fieldset">
		<div id="labelContainer"class="control-group">
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</label>
			<div class="controls">
				<input name="label" type="text" class="span12 objectParam" value="#esapiEncode('html_attr',objectParams.label)#"/>
			</div>
		</div>	 
	</div>
</div>
</cfoutput>