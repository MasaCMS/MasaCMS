<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: layout --->
<!--- fuseaction: lay_template --->
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "lay_template">
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/layout/prefuseaction.cfm")><cfoutput><cfinclude template="../view/layout/prefuseaction.cfm" /></cfoutput></cfif>
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/layout/lay_template.cfm")><cfoutput><cfinclude template="../view/layout/lay_template.cfm" /></cfoutput><cfelse><cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You specified a Fuseaction of lay_template which is not defined in Circuit layout."></cfif>
<cfif fileExists("/Users/matthewlevine/Sites/Mura_5_2/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../view/layout/postfuseaction.cfm")><cfoutput><cfinclude template="../view/layout/postfuseaction.cfm" /></cfoutput></cfif>

