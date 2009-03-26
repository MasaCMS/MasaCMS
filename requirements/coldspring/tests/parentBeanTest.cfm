<cfsilent>
	<cfset path = ExpandPath('.') />
	<cfset configFile = path & "/parentBeans.xml" />
	<cfset beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
	<cfset beanFactory.loadBeans(configFile) />
</cfsilent>

<!--- <cfset bookmarkService = beanFactory.getBean("bookmarkService")>

<cfdump var="#bookmarkService#"> --->

<cfdump var="#beanFactory.beanCache#">

<cfset beanEight = beanFactory.getBean("beanEight.factory")>

<cfdump var="#beanEight#"/>

<cfset categoryService = beanFactory.beanCache.categoryServiceTarget />

<cfdump var="#categoryService.getCategoriesAsQuery()#">