<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cPrivateUsers --->
<!--- fuseaction: editgroup --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cPrivateUsers">
<cfset myFusebox.thisFuseaction = "editgroup">
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "default" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not (isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or  isUserInRole('S2'))>
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
<cfif not isdefined('request.userBean')>
<cfset request.userBean = application.userManager.read(attributes.userid) >
</cfif>
<cfset request.rsSiteList = application.settingsManager.getList() >
<cfset request.rsGroupList = application.userManager.readGroupMemberships(attributes.userid) >
<cfset request.nextn = application.utility.getNextN(request.rsGroupList,15,attributes.startrow) >
<!--- do action="vPrivateUsers.editgroup" --->
<cfset myFusebox.thisCircuit = "vPrivateUsers">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.Type")><cfset attributes.Type = "0" /></cfif>
<cfif not isDefined("attributes.ContactForm")><cfset attributes.ContactForm = "0" /></cfif>
<cfif not isDefined("attributes.isPublic")><cfset attributes.isPublic = "0" /></cfif>
<cfif not isDefined("attributes.username")><cfset attributes.username = "" /></cfif>
<cfif not isDefined("attributes.email")><cfset attributes.email = "" /></cfif>
<cfif not isDefined("attributes.jobtitle")><cfset attributes.jobtitle = "" /></cfif>
<cfif not isDefined("attributes.password")><cfset attributes.password = "" /></cfif>
<cfif not isDefined("attributes.lastupdate")><cfset attributes.lastupdate = "" /></cfif>
<cfif not isDefined("attributes.lastupdateby")><cfset attributes.lastupdateby = "" /></cfif>
<cfif not isDefined("attributes.lastupdatebyid")><cfset attributes.lastupdatebyid = "0" /></cfif>
<cfif not isDefined("rsGrouplist.recordcount")><cfset rsGrouplist.recordcount = "0" /></cfif>
<cfif not isDefined("attributes.groupname")><cfset attributes.groupname = "" /></cfif>
<cfif not isDefined("attributes.fname")><cfset attributes.fname = "" /></cfif>
<cfif not isDefined("attributes.lname")><cfset attributes.lname = "" /></cfif>
<cfif not isDefined("attributes.address")><cfset attributes.address = "" /></cfif>
<cfif not isDefined("attributes.city")><cfset attributes.city = "" /></cfif>
<cfif not isDefined("attributes.state")><cfset attributes.state = "" /></cfif>
<cfif not isDefined("attributes.zip")><cfset attributes.zip = "" /></cfif>
<cfif not isDefined("attributes.phone1")><cfset attributes.phone1 = "" /></cfif>
<cfif not isDefined("attributes.phone2")><cfset attributes.phone2 = "" /></cfif>
<cfif not isDefined("attributes.fax")><cfset attributes.fax = "" /></cfif>
<cfif not isDefined("attributes.perm")><cfset attributes.perm = "0" /></cfif>
<cfif not isDefined("attributes.groupid")><cfset attributes.groupid = "" /></cfif>
<cfif not isDefined("attributes.routeid")><cfset attributes.routeid = "" /></cfif>
<cfif not isDefined("attributes.s2")><cfset attributes.s2 = "0" /></cfif>
<cfif not isDefined("attributes.InActive")><cfset attributes.InActive = "0" /></cfif>
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("request.error")><cfset request.error = "#structnew()#" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vPrivateUsers/dsp_group.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "dsp_group.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_group.cfm in circuit vPrivateUsers which does not exist (from fuseaction vPrivateUsers.editgroup).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="layout.display" --->
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "display">
<cfif not isDefined("fusebox.ajax")><cfset fusebox.ajax = "" /></cfif>
<cfif not isDefined("fusebox.layout")><cfset fusebox.layout = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/layouts/template.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "template.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse template.cfm in circuit layout which does not exist (from fuseaction layout.display).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

