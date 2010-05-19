<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: app --->
<!--- fuseaction: welcome --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "app">
<cfset myFusebox.thisFuseaction = "welcome">
<cfparam name="__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app" default="#createObject('component','default.includes.display_objects.custom.fuseboxtemplates.noxml.controller.app')#" />
<cfif structKeyExists(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app,"prefuseaction") and isCustomFunction(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.prefuseaction)>
<cfset __fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.prefuseaction(myFusebox=myFusebox,event=event) />
</cfif>
<cfif structKeyExists(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app,"welcome") and isCustomFunction(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.welcome)>
<cfset __fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.welcome(myFusebox=myFusebox,event=event) />
<cfelse><cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You specified a Fuseaction of welcome which is not defined in Circuit app.">
</cfif>
<cfif structKeyExists(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app,"postfuseaction") and isCustomFunction(__fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.postfuseaction)>
<cfset __fuseboxCircuitCfc_default_includes_display_objects_custom_fuseboxtemplates_noxml_controller_app.postfuseaction(myFusebox=myFusebox,event=event) />
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

