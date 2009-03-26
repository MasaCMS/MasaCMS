

	<cfset fname = "/coldspring/unitTests/myprops.properties" />
	<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset bf.loadBeansFromXmlFile(expandPath("testBeans.xml"))/>
	<cfset propBean = CreateObject("component","coldspring.beans.factory.config.PropertyPlaceholderConfigurer").init() />
	<cfset propBean.setLocation(fname) />
	<cfset propBean.postProcessBeanFactory(bf) />
	
	
	<cfset stringBean = bf.getBean("stringBean") />
	<cfset structBean = bf.getBean("structBean") />
	
	<cfdump var="#stringBean#"/>
	
	<br><br>
	
	<cfdump var="#structBean#" />
	