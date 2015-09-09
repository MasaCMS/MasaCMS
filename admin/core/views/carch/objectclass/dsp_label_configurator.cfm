<cfparam name="tabclass" default="">
<cfparam name="objectParams.addlabel" default="false">
<cfparam name="objectParams.label" default="">
<cfif len(tabclass)>
	<cfset tabclass="tab-pane">
<cfelse>
	<cfset tabclass="tab-pane active">
</cfif>
<cfoutput>
<div role="tabpanel" class="#tabclass#" id="label">
	Add Label?<br/>
	<select name="addlabel" class="objectParam">
		<option value="false"<cfif objectParams.addlabel eq 'true'> selected</cfif>>False</option>
		<option value="true"<cfif objectParams.addlabel eq 'true'> selected</cfif>>True</option>
	</select><br/>
	<div id="labelContainer">
	Label<br/>
	<input name="label"  class="objectParam" value="#esapiEncode('html_attr',objectParams.label)#"/>
	</div>
</div>
</cfoutput>