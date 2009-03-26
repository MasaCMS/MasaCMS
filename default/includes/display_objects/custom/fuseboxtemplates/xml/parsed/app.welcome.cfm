<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: app --->
<!--- fuseaction: welcome --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "app">
<cfset myFusebox.thisFuseaction = "welcome">
<cfif myFusebox.applicationStart or
		not myFusebox.getApplication().applicationStarted>
	<cflock name="#application.ApplicationName#_fusebox_#FUSEBOX_APPLICATION_KEY#_appinit" type="exclusive" timeout="30">
		<cfif not myFusebox.getApplication().applicationStarted>
<!--- fuseaction action="time.initialize" --->
<cfset myFusebox.trace("Runtime","&lt;fuseaction action=""time.initialize""/&gt;") >
<cfset myFusebox.thisCircuit = "time">
<cfset myFusebox.thisFuseaction = "initialize">
<cfset myFusebox.getApplication().getApplicationData().startTime = "#now()#" />
<cfset myFusebox.thisCircuit = "app">
<cfset myFusebox.thisFuseaction = "welcome">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<!--- do action="time.getTime" --->
<cfset myFusebox.trace("Runtime","&lt;do action=""time.getTime""/&gt;") >
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "time">
<cfset myFusebox.thisFuseaction = "getTime">
<cfset myFusebox.trace("Runtime","&lt;include template=""act_get_time.cfm"" circuit=""time""/&gt;") >
<cftry>
<cfoutput><cfinclude template="../model/time/act_get_time.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 16 and right(cfcatch.MissingFileName,16) is "act_get_time.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse act_get_time.cfm in circuit time which does not exist (from fuseaction time.getTime).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="display.sayHello" --->
<cfset myFusebox.trace("Runtime","&lt;do action=""display.sayHello""/&gt;") >
<cfset myFusebox.thisCircuit = "display">
<cfset myFusebox.thisFuseaction = "sayHello">
<cfset myFusebox.trace("Runtime","&lt;include template=""dsp_hello.cfm"" circuit=""display""/&gt;") >
<cftry>
<cfsavecontent variable="body"><cfoutput><cfinclude template="../view/display/dsp_hello.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "dsp_hello.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_hello.cfm in circuit display which does not exist (from fuseaction display.sayHello).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="layout.mainLayout" --->
<cfset myFusebox.trace("Runtime","&lt;do action=""layout.mainLayout""/&gt;") >
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "mainLayout">
<cfset myFusebox.trace("Runtime","&lt;include template=""lay_template.cfm"" circuit=""layout""/&gt;") >
<cftry>
<cfoutput><cfinclude template="../view/layout/lay_template.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 16 and right(cfcatch.MissingFileName,16) is "lay_template.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_template.cfm in circuit layout which does not exist (from fuseaction layout.mainLayout).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

