<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: time --->
<!--- fuseaction: act_get_time --->
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "time">
<cfset myFusebox.thisFuseaction = "act_get_time">
<cfif fileExists("C:/Inetpub/sava/Sava/trunk/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../model/time/prefuseaction.cfm")><cfoutput><cfinclude template="../model/time/prefuseaction.cfm" /></cfoutput></cfif>
<cfif fileExists("C:/Inetpub/sava/Sava/trunk/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../model/time/act_get_time.cfm")><cfoutput><cfinclude template="../model/time/act_get_time.cfm" /></cfoutput><cfelse><cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You specified a Fuseaction of act_get_time which is not defined in Circuit time."></cfif>
<cfif fileExists("C:/Inetpub/sava/Sava/trunk/www/default/includes/display_objects/custom/fuseboxtemplates/noxml/parsed/../model/time/postfuseaction.cfm")><cfoutput><cfinclude template="../model/time/postfuseaction.cfm" /></cfoutput></cfif>

