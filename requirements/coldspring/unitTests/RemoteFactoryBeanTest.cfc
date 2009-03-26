<cfcomponent name="RemoteFactoryBeanTest" 
			displayname="RemoteFactoryBeanTest" 
			hint="test remote factory bean methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<cfset var path = GetDirectoryFromPath(getMetaData(this).path) />
		<cfset var acu = 0 />
		<cfset var ac = 0 />
		<cfset var bf = 0 />
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	
		<cfset variables.sys.out.println("Loading bean factory...") />
		<!--- set up the bean factory --->
		<cfset bfu = createObject("component","coldspring.beans.util.BeanFactoryUtils").init() />
		<!--- create a new bean factory --->
		<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
		<!--- load the bean defs --->
		<cfset bf.loadBeansFromXmlFile(path&'/klondike-services.xml')/>
		<!--- store in app context --->
		<cfset bfu.setDefaultFactory('application',bf)>
		
		<cfset variables.sys.out.println("Stored default bean factory") />
		
		
	</cffunction>
	
	<cffunction name="testRemoteFactory" access="public" returntype="void" output="false">
		<!--- OK, let's try to get the remoteStub generated --->
		<cfset var bfu = createObject("component","coldspring.beans.util.BeanFactoryUtils").init() />
		<cfset var bf = bfu.getDefaultFactory('application') />
		
		<cfset variables.sys.out.println("Retrieved bean factory") />
		
		<!--- should be the target service returned form the remote factory --->
		<cfset myTarget = bf.getBean('remoteCatalogService') />
		<!--- should be the remote factory itself --->
		<cfset myFactory = bf.getBean('&remoteCatalogService') />
		
		<!--- now load up the remote service object --->
		<cfset myService = createObject("component","klondike.machii.remoting.RemoteCatalogService") />
		
		<!--- dump some data from the remote service! --->
		<cfdump var="#myService.getGenres()#" label="Genres" /><br/><br/>
		<!--- now dump em --->
		<cfdump var="#myTarget#" label="Remote Service Target"><br/><br/>
		<cfdump var="#myFactory#" label="Remote Service Factory"><br/><br/>
		<cfdump var="#myService#" label="Remote Service Facade"><br/><br/>

		<cfset variables.sys.out.println("Done!") />
		
		<cfabort />
	</cffunction>
	
</cfcomponent>