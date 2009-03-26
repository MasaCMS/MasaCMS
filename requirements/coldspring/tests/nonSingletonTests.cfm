<cfsilent>
	<cfset path = ExpandPath('.') />
	<cfset configFile = path & "/beans.xml" />
	<cfset beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
	<cfset beanFactory.loadBeans(configFile) />
</cfsilent>

<!--- loop a hell of a lot over non-singletons --->
<cfset numBeans = 200 />
<cfset startTime = getTickCount() />

<cfloop from="1" to="#numBeans#" index="i">
	<cfset beanFactory.getBean("beanSeven") />
</cfloop>

<cfset endTime = getTickCount() />
<cfset testLength = endTime-startTime />

<!--- loop a hell of a lot over non-singletons --->
<cfset startTime = getTickCount() />

<cfloop from="1" to="#numBeans#" index="i">
	<cfset CreateObject('component', 'coldspring.tests.beanSeven').init(
			CreateObject('component', 'coldspring.tests.beanEight')) />
</cfloop>

<cfset endTime = getTickCount() />
<cfset rawCreateLength = endTime-startTime />

<cfset CSdiff = testLength-rawCreateLength />
<cfset CSperbean = CSdiff/numBeans />

<h2>Non singleton tests...</h2>
<cfoutput>
	CS getBeans length: #testLength# <br/>
	CreateObject length: #rawCreateLength# <br/>
	CS Diff: #CSdiff# <br/>
	CS Overhead: #CSperbean# <br/>
</cfoutput>