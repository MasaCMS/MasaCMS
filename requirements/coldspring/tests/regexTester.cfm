<cfsilent>
	<!--- <cfset testObj = CreateObject('component','coldspring.tests.beanEight').init() /> --->
	<cfset testObj = CreateObject('component','net.klondike.component.catalogGateway').init() />
	<cfset pointcut = CreateObject('component','coldspring.aop.support.RegexMethodPointcut').init() />
	<!--- FN Horray! It's it! --->
	<cfset pointcut.setPattern("^((?![g|s]et).)*$") /> 
	<cfset pointcut.setPattern("[g|s]et+") /> --->
	<cfset pointcut.setPattern("^((?!get[G|A]).)*$") />
	<cfset md = getMetaData(testObj) />
</cfsilent>

<html>
<body>
<cfoutput>
	
<!--- get some metadata, see if the pointcut matches the methods --->
Checking pointcut with pattern: #pointcut.getPattern()#<br>
<table>
	<tr>
		<td>Method Name</td>
		<td>Matches</td>
	</tr>
	<cfif structKeyExists(md,"functions")>
		<cfloop from="1" to="#arraylen(md.functions)#" index="ix">
		<cfset methodName = md.functions[ix].name />
			
			<tr>
				<td>#methodName#</td>
				<td>#pointcut.matches(methodName)#</td>
			</tr>
			
		</cfloop>
	</cfif>
</table>

</cfoutput>
</body>
</html>