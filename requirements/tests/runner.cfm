<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple">
<cfset sessionData=application.mura.getSession()>
<cfif not isDefined('sessionData.mura')>
    <cfset application.mura.getBean('userUtility').setUserStruct()>
</cfif>
<cfif application.mura.getBean('configBean').getValue(property='testbox',defaultValue=false) and directoryExists(Expandpath("/testbox"))>
    <cfset r = new testbox.system.TestBox( directory={ mapping = "murawrm.requirements.tests.specs", recurse = true } ) >
    <cfoutput>#r.run(reporter=url.reporter)#</cfoutput>
<cfelse>
    Access Restricted.
</cfif>
