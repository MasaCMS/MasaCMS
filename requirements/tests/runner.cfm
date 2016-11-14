<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple">
<!--- Directory Runner --->
<cfset r = new testbox.system.TestBox( directory={ mapping = "test.specs", recurse = true } ) >
<cfoutput>#r.run(reporter=url.reporter)#</cfoutput>
