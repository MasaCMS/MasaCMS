<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cPrivateUsers --->
<!--- fuseaction: route --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cPrivateUsers">
<cfset myFusebox.thisFuseaction = "route">
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "default" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not (isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or  isUserInRole('S2'))  and not (listFindNoCase('cPrivateUsers.editAddress,cPrivateUsers.updateAddress',attributes.fuseaction) and  attributes.userID eq listFirst(getAuthUser(),'^'))>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfif not isDefined("request.error")><cfset request.error = "#structnew()#" /></cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.userid")><cfset attributes.userid = "" /></cfif>
<cfif not isDefined("attributes.routeid")><cfset attributes.routeid = "" /></cfif>
<cfif not isDefined("attributes.categoryid")><cfset attributes.categoryid = "" /></cfif>
<cfif attributes.userid eq ''>
<cfif not isDefined("attributes.Action")><cfset attributes.Action = "Add" /></cfif>
<cfelse>
<cfif not isDefined("attributes.Action")><cfset attributes.Action = "Update" /></cfif>
</cfif>
<cfif attributes.routeid eq '' or attributes.routeid eq 'adManager'>
<cflocation url="index.cfm?fuseaction=cPrivateUsers.list&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
</cfif>
<cfset routeBean = "#application.userManager.read(attributes.routeid)#" />
<cfif routeBean.getIsPublic() eq 0>
<cflocation url="index.cfm?fuseaction=cPrivateUsers.editgroup&userid=#attributes.routeid#&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
<cfelse>
<cflocation url="index.cfm?fuseaction=cPublicUsers.editgroup&userid=#attributes.routeid#&siteid=#routeBean.getSiteid()#" addtoken="false">
<cfabort>
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

