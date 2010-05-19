<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: display --->
<!--- fuseaction: dsp_hello --->
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "display">
<cfset myFusebox.thisFuseaction = "dsp_hello">
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/display/prefuseaction.cfm")><cfoutput><cfinclude template="../view/display/prefuseaction.cfm" /></cfoutput></cfif>
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/display/dsp_hello.cfm")><cfoutput><cfinclude template="../view/display/dsp_hello.cfm" /></cfoutput><cfelse><cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You specified a Fuseaction of dsp_hello which is not defined in Circuit display."></cfif>
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/display/postfuseaction.cfm")><cfoutput><cfinclude template="../view/display/postfuseaction.cfm" /></cfoutput></cfif>

