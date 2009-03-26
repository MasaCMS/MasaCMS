<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cPublicUsers --->
<!--- fuseaction: updateAddress --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cPublicUsers">
<cfset myFusebox.thisFuseaction = "updateAddress">
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "default" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000008','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfif not isDefined("request.error")><cfset request.error = "#structnew()#" /></cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.userid")><cfset attributes.userid = "" /></cfif>
<cfif not isDefined("attributes.routeid")><cfset attributes.routeid = "" /></cfif>
<cfif not isDefined("attributes.categoryid")><cfset attributes.categoryid = "" /></cfif>
<cfif not isDefined("attributes.search")><cfset attributes.search = "" /></cfif>
<cfif not isDefined("attributes.newSearch")><cfset attributes.newSearch = "false" /></cfif>
<cfif attributes.userid eq ''>
<cfif not isDefined("attributes.Action")><cfset attributes.Action = "Add" /></cfif>
<cfelse>
<cfif not isDefined("attributes.Action")><cfset attributes.Action = "Update" /></cfif>
</cfif>
<cfif attributes.action eq 'Update'>
<cfset application.userManager.updateAddress(attributes) >
</cfif>
<cfif attributes.action eq 'Delete'>
<cfset application.userManager.deleteAddress(attributes.addressid) >
</cfif>
<cfif attributes.action eq 'Add'>
<cfset application.userManager.createAddress(attributes) >
</cfif>
<cflocation url="index.cfm?fuseaction=cPublicUsers.editUser&siteid=#attributes.siteid#&userID=#attributes.UserID#&routeid=#attributes.routeID#&activeTab=1" addtoken="false">
<cfabort>
<cfcatch><cfrethrow></cfcatch>
</cftry>

