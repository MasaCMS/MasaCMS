<cfcomponent extends="mura.cfobject">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfreturn this />
</cffunction>

<cffunction name="purgeCache" returntype="void" access="public" output="false">
	<cfargument name="siteid" required="true" default="">
	<cfset var clusterIPList=variables.configBean.getClusterIPList()>
	<cfset var ip="">
	
	<cfif len(clusterIPList)>
		<cfloop list="#clusterIPList#" index="ip">
			<cfinvoke webservice="http://#ip##variables.configBean.getServerPort()##variables.configBean.getContext()#/MuraProxy.cfc?wsdl" method="purgeSiteCache">
			<cfinvokeargument name="siteID" value="#arguments.siteid#">
		 	</cfinvoke>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="reload" output="false" returntype="void">	
	<cfset var clusterIPList=variables.configBean.getClusterIPList()>
	<cfset var ip="">
	
	<cfif len(clusterIPList)>
		<cfloop list="#clusterIPList#" index="ip">
			<cfinvoke webservice="http://#ip##variables.configBean.getServerPort()##variables.configBean.getContext()#/MuraProxy.cfc?wsdl" method="reload"/>
		</cfloop>
	</cfif>
	
</cffunction>	

</cfcomponent>