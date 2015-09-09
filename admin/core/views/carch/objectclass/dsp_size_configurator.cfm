<cfparam name="tabclass" default="">
<cfif len(tabclass)>
	<cfset tabclass="tab-pane">
<cfelse>
	<cfset tabclass="tab-pane active">
</cfif>
<cfoutput>
<div role="tabpanel" class="#tabclass#" id="size">
Size
<input type="radio" <cfif listFind(objectParams.class,'mura-one-third',' ')> checked</cfif> name="size" value="mura-one-third"/> One Third
<input type="radio" <cfif listFind(objectParams.class,'mura-one-half',' ')> checked</cfif> name="size" value="mura-one-half"/> One Half
<input type="radio" <cfif listFind(objectParams.class,'mura-two-thirds')> checked</cfif>  name="size" value="mura-two-thirds"/> Two Thirds
<input type="radio" <cfif listFind(objectParams.class,'mura-full-width',' ')> checked</cfif> name="size" value="mura-full-width"/> Full
</div>
</cfoutput>