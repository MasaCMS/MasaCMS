<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cEmail --->
<!--- fuseaction: deleteBounces --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cEmail">
<cfset myFusebox.thisFuseaction = "deleteBounces">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000005','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfset Session.moduleid = "00000000000000000000000000000000005" />
<cfset application.emailManager.deleteBounces(attributes) >
<cflocation url="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
<cfcatch><cfrethrow></cfcatch>
</cftry>

