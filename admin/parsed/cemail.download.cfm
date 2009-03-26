<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cEmail --->
<!--- fuseaction: download --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cEmail">
<cfset myFusebox.thisFuseaction = "download">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000005','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))>
<cfset application.utility.backUp() >
</cfif>
<cfset Session.moduleid = "00000000000000000000000000000000005" />
<!--- do action="vEmail.download" --->
<cfset myFusebox.thisCircuit = "vEmail">
<cfif not isDefined("attributes.fuseaction")><cfset attributes.fuseaction = "list" /></cfif>
<cfif not isDefined("attributes.subject")><cfset attributes.subject = "" /></cfif>
<cfif not isDefined("attributes.bodytext")><cfset attributes.bodytext = "" /></cfif>
<cfif not isDefined("attributes.bodyhtml")><cfset attributes.bodyhtml = "" /></cfif>
<cfif not isDefined("attributes.createddate")><cfset attributes.createddate = "" /></cfif>
<cfif not isDefined("attributes.deliverydate")><cfset attributes.deliverydate = "" /></cfif>
<cfif not isDefined("attributes.grouplist")><cfset attributes.grouplist = "" /></cfif>
<cfif not isDefined("attributes.groupid")><cfset attributes.groupid = "" /></cfif>
<cfif not isDefined("attributes.emailid")><cfset attributes.emailid = "" /></cfif>
<cfif not isDefined("attributes.status")><cfset attributes.status = "2" /></cfif>
<cfif not isDefined("attributes.lastupdatebyid")><cfset attributes.lastupdatebyid = "" /></cfif>
<cfif not isDefined("attributes.lastupdateby")><cfset attributes.lastupdateby = "" /></cfif>
<cfif not isDefined("session.emaillist.status")><cfset session.emaillist.status = "2" /></cfif>
<cfif not isDefined("session.emaillist.groupid")><cfset session.emaillist.groupid = "" /></cfif>
<cfif not isDefined("session.emaillist.subject")><cfset session.emaillist.subject = "" /></cfif>
<cfif not isDefined("session.emaillist.dontshow")><cfset session.emaillist.dontshow = "1" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vEmail_Broadcaster/act_download.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 16 and right(cfcatch.MissingFileName,16) is "act_download.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse act_download.cfm in circuit vEmail which does not exist (from fuseaction vEmail.download).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

