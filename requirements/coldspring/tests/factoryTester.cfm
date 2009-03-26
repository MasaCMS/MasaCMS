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
			
			<ul>
			<cfloop collection="#beanDefinitions#" item="beanID">
				<li>
				Struct Key: #beanID#<br>
				BeanID: #beanDefinitions[beanID].getBeanID()#<br>
				BeanClass: #beanDefinitions[beanID].getBeanClass()#<br>
				isSingleton: #beanDefinitions[beanID].isSingleton()#<br>
				isConstructed: #beanDefinitions[beanID].isConstructed()#<br>
				<br>
				Constructor-args:<br>
				<ul>
				<cfset beanConstructorArgs = beanDefinitions[beanID].getConstructorArgs() />
				<cfloop collection="#beanConstructorArgs#" item="arg">
					<li>
					Constructor-Arg Name: #beanConstructorArgs[arg].getName()#<br/>
					Constructor-Arg Type: #beanConstructorArgs[arg].getType()#<br/>
					Constructor-Arg Value: <cfdump var="#beanConstructorArgs[arg].getValue()#"><br/>
					</li>
				</cfloop>
				</ul>
				Properties:<br>
				<cfset beanProperties = beanDefinitions[beanID].getProperties() />
				<ul>
				<cfloop collection="#beanProperties#" item="property">
					<li>
					PropertyName: #beanProperties[property].getName()#<br/>
					PropertyType: #beanProperties[property].getType()#<br/>
					PropertyValue: <cfdump var="#beanProperties[property].getValue()#"><br/>
					</li>
				</cfloop>
				</ul>
				<br>
				Dependencies: #beanDefinitions[beanID].getDependencies(beanID)#<br />
				<br /><br />-----------------------<br /><br />     
				</li>
			</cfloop>
			</ul>
			<!--- <cfdump var="#beanDefinitions#" /> --->
			
			<cfset testBean = beanFactory.getBean('beanThree') />

			#testBean.getHelper().getMessage()#<br><br>
			#testBean.getInnerBean().sayHi()#
			
			<br />
			<br />   
			<cfset testBean = beanFactory.getBean('beanTwo') />
			#testBean.sayHiWithInnerBean()#

<br /><br />
			<cfset testBean = beanFactory.getBean('beanNine') />
			<cfdump var="#testBean#">

  
			<!--- <cfdump var="#testBean#" /> --->
	
		</cfoutput>
	</body>

</html>