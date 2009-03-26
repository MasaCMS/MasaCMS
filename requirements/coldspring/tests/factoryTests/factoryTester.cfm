<cfsilent>
	<cfset path = ExpandPath('.') />
	<cfset configFile = path & "/beans.xml" />
	<cfset beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
	<cfset beanFactory.loadBeans(configFile) />
	<cfset beanDefinitions = beanFactory.getBeanDefinitionList() />
</cfsilent>

<html>
	<head>
		<title>Bean Factory Test !</title>
	</head>
	
	<body>
		
		<h3>Starting the bean factory...</h3>
		
		<cfoutput>
			
			<cfset testBean = beanFactory.getBean('beanThree') />

			#testBean.getHelper().getMessage()#<br><br>
			#testBean.getInnerBean().sayHi()#<br><br>
			
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
					PropertyValue: #beanProperties[property].getValue()#<br/>
				</cfloop>
				<br>
				Dependencies: #beanDefinitions[beanID].getDependencies(beanID)#<br />
				<br>----------<br><br>
			</cfloop>
			<!--- <cfdump var="#beanDefinitions#" /> --->
			
			<!--- <cfdump var="#testBean#" /> --->
	
		</cfoutput>
	</body>

</html>