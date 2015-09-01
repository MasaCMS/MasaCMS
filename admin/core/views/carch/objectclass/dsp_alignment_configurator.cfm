<cfparam name="tabclass" default="">
<cfif len(tabclass)>
	<cfset tabclass="tab-pane">
<cfelse>
	<cfset tabclass="tab-pane active">
</cfif>
<cfoutput>
<div role="tabpanel" class="#tabclass#" id="alignment">
Alignment
</div>
</cfoutput>
