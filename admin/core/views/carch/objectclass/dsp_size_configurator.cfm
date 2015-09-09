<cfparam name="tabclass" default="">
<cfif len(tabclass)>
	<cfset tabclass="tab-pane">
<cfelse>
	<cfset tabclass="tab-pane active">
</cfif>
<cfoutput>
<div role="tabpanel" class="#tabclass#" id="size">
Size
<input type="radio" <cfif listFind(objectParams.class,'mura-width-quarter',' ')> checked</cfif> name="size" value="mura-width-quarter"/> One Quarter
<input type="radio" <cfif listFind(objectParams.class,'mura-width-half',' ')> checked</cfif> name="size" value="mura-width-half"/> Half
<input type="radio" <cfif listFind(objectParams.class,'mura-width-three-quarter')> checked</cfif>  name="size" value="mura-width-three-quarter"/> Three Quarters
<input type="radio" <cfif listFind(objectParams.class,'mura-width-full',' ')> checked</cfif> name="size" value="mura-width-full"/> Full
</div>
</cfoutput>