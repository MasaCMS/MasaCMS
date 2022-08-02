<cfsilent>
	<cfparam name="objectparams.formid" default="1" >
	<cfparam name="objectParams.pretext" default="">
	<cfparam name="objectParams.posttext" default="">
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.modalbuttonlabel" default="">
	<cfparam name="objectParams.displaytype" default="inline">
	<cfparam name="objectParams.url" default="">
	<cfparam name="objectparams._p" default="1" >
	<cfset objectParams.render = "server" />
	<cfset objectParams.async = "true"/>
	
</cfsilent>
<cfoutput>
#$.loadShadowboxJS()#
<div class="masa-module-info">
	<cfif objectParams.displaytype eq "inline">
		<cfif len(objectparams.formid) and IsValid('uuid', objectparams.formid)>
			<cfset local.formid = objectparams.formid>
			<cfinclude template="form.cfm"  />
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,'modules.gatedasset.noformselected')#
		</cfif>
	<cfelseif objectParams.displaytype eq "modal">
		<cfif len(objectparams.formid) and IsValid('uuid', objectparams.formid)>
			<cfset local.formid = objectparams.formid>
			<cfinclude template="modal.cfm"  />
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,'modules.gatedasset.noformselected')#
		</cfif>
	</cfif>
</div>
</cfoutput>