<cfsilent>
	<cfif not StructKeyExists(application,"beanFactoryX")>
		<cfset path = ExpandPath('.') />
		<cfset configFile = path & "/beans.xml" />
		<cfset application.beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
		<cfset application.beanFactory.loadBeans(configFile) />
	</cfif>
	<cfset beanFactory = application.beanFactory />
	<cfset beanDefinitions = beanFactory.getBeanDefinitionList() />
</cfsilent>

<html>
	<head>
		<title>Bean Factory Test !</title>
	</head>
	
	<body>
	
		<!--- get the proxy --->
		<cfset testBean = beanFactory.getBean('myProxy') />
		
		<!--- call the methods to see some aop --->
		<cfoutput>
		TEST SAYHELLO():<br>
		#testBean.sayHello('')#
		<br><br>
		TEST SAY GOODBYE():<br><br>
		#testBean.sayGoodbye('')#
		<br><br>
		
		<!--- just show the factory bean definitions --->
		<cfloop collection="#beanDefinitions#" item="beanID">
			Struct Key: #beanID#<br>
			BeanID: #beanDefinitions[beanID].getBeanID()#<br>
			BeanClass: #beanDefinitions[beanID].getBeanClass()#<br>
			isSingleton: #beanDefinitions[beanID].isSingleton()#<br>
			isConstructed: #beanDefinitions[beanID].isConstructed()#<br>
			<br>
			Properties:<br>
			<cfset beanProperties = beanDefinitions[beanID].getProperties() />
			<cfloop collection="#beanProperties#" item="property">
				PropertyName: #beanProperties[property].getName()#<br/>
				PropertyType: #beanProperties[property].getType()#<br/>
				<!--- PropertyValue: #beanProperties[property].getValue()#<br/> --->
			</cfloop>
			<br>
			Dependencies: #beanDefinitions[beanID].getDependencies(beanID)#<br />
			<br>----------<br><br>
		</cfloop>
		
		</cfoutput>
	</body>
</html>