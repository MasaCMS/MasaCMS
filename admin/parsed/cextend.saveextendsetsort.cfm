<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cExtend --->
<!--- fuseaction: saveExtendSetSort --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cExtend">
<cfset myFusebox.thisFuseaction = "saveExtendSetSort">
<cfif not isDefined("attributes.subTypeID")><cfset attributes.subTypeID = "" /></cfif>
<cfif not isDefined("attributes.extendSetID")><cfset attributes.extendSetID = "" /></cfif>
<cfif not isDefined("attributes.attibuteID")><cfset attributes.attibuteID = "" /></cfif>
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfset application.classExtensionManager.saveExtendSetSort(attributes.extendSetID) >
<cfcatch><cfrethrow></cfcatch>
</cftry>

