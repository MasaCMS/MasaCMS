<cfparam name="tabclass" default="">
<cfif len(tabclass)>
	<cfset tabclass="tab-pane">
<cfelse>
	<cfset tabclass="tab-pane active">
</cfif>
<cfoutput>
<div role="tabpanel" class="#tabclass#" id="alignment">
Alignment
<input type="radio" <cfif listFind(objectParams.class,'mura-left',' ')> checked</cfif> name="alignment" value="mura-left"/> Left
<input type="radio" <cfif listFind(objectParams.class,'mura-center',' ')> checked</cfif>  name="alignment" value="mura-center"/> Center
<input type="radio" <cfif listFind(objectParams.class,'mura-right',' ')> checked</cfif> name="alignment" value="mura-right"/> Right
</div>
</cfoutput>
