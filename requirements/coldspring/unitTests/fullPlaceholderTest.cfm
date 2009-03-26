

	
	<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset bf.loadBeansFromXmlFile(expandPath("testBeans.xml"))/>
	
	
	<cfset stringBean = bf.getBean("stringBean") />
	<cfset structBean = bf.getBean("structBean") />
	
	<cfdump var="#stringBean#"/>
	
	<br><br>
	
	<cfdump var="#structBean#" />
	