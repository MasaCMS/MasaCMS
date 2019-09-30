<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple">
<cfset sessionData=application.mura.getSession()>
<cfif not isDefined('sessionData.mura')>
    <cfset application.mura.getBean('userUtility').setUserStruct()>
</cfif>
<cfif application.mura.getBean('configBean').getValue(property='testbox',defaultValue=false) and directoryExists(Expandpath("/testbox"))>
    <cfset r = new testbox.system.TestBox( directory={ mapping = "muraWRM.core.tests.specs", recurse = true } ) >
    <cfoutput>#r.run(reporter=url.reporter)#</cfoutput>
<cfelse>
    <h1>Access Restricted.</h1>
    <cfoutput>
      <br/>Testbox enabled: #application.mura.getBean('configBean').getValue(property='testbox',defaultValue=false)#
      <br/>Testbox installed: #directoryExists(Expandpath("/testbox"))#
    </cfoutput>
</cfif>
