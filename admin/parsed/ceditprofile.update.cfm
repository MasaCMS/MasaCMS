<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cEditProfile --->
<!--- fuseaction: update --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cEditProfile">
<cfset myFusebox.thisFuseaction = "update">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isDefined("attributes.categoryid")><cfset attributes.categoryid = "" /></cfif>
<cfset request.userBean = application.userManager.update(attributes,false) >
<cfif not structIsEmpty(request.userBean.getErrors())>
<!--- do action="cEditProfile.Edit" --->
<cfset myFusebox.thisFuseaction = "Edit">
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isDefined("attributes.categoryid")><cfset attributes.categoryid = "" /></cfif>
<cfif not isdefined('request.userBean')>
<cfset request.userBean = application.userManager.read(session.mura.userID) >
</cfif>
<!--- do action="vPrivateUsers.editprofile" --->
<cfset myFusebox.thisCircuit = "vPrivateUsers">
<cfset myFusebox.thisFuseaction = "editprofile">
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
<cfoutput><cfinclude template="../view/vPrivateUsers/dsp_userprofile.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "dsp_userprofile.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_userprofile.cfm in circuit vPrivateUsers which does not exist (from fuseaction vPrivateUsers.editprofile).">
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
<cfset myFusebox.thisCircuit = "cEditProfile">
<cfset myFusebox.thisFuseaction = "update">
<cfelse>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

