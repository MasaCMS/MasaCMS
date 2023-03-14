<cfsilent>
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.buttonsize" default="">
	<cfparam name="objectParams.target" default="">
	<cfparam name="objectParams.url" default="">
	<cfset objectParams.render="server">
</cfsilent>
<cfoutput>
	<div class="masa-module-button">
		<a href="#objectParams.url#"<cfif len(objectParams.target)> target="#objectParams.target#"</cfif> class="btn btn-primary<cfif len(objectParams.buttonsize)> #objectParams.buttonsize#</cfif>">#objectParams.buttonlabel#</a>
	</div>
</cfoutput>