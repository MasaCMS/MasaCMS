<cffunction name="getCodeSnippet" access="public" returntype="string" output="false" hint="">
	<cfargument name="snippetFile" type="string" required="true" />
	<cfargument name="codeType" type="string" required="false" default="coldfusion" />
	<cfset var testSnippet = "" />
	<cffile action="read" file="#ExpandPath('/coldspring/examples/quickstart/#arguments.snippetFile#')#" variable="codeSnippet" />
	<cfreturn '<pre class="#arguments.codeType#" name="code">#HTMLEditFormat(Trim(codeSnippet))#</pre>' />
</cffunction>

<cffunction name="createColdSpring" access="public" returntype="void" output="false" hint="">
	<cfargument name="configFile" type="string" required="false" default="coldspring.xml" />
	<cfset var local = StructNew() />
	<cfset var coldspringConfig = ExpandPath('config/#arguments.configFile#') />
	<cfset beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
	<cfset beanFactory.loadBeans(coldspringConfig) />
</cffunction>