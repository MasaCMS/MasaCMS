
<cfcomponent name="beanFour">

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="sayHi" access="public" returntype="string">
		<cfreturn "I'm an inner bean!" />
	</cffunction>
	
	<cffunction name="setMyList" access="public" returntype="void" output="false">
		<cfargument name="list" type="Array" required="true"/>
		<cfset this.myList = arguments.list />
	</cffunction>
	
	<cffunction name="setMyMap" access="public" returntype="void" output="false">
		<cfargument name="map" type="Struct" required="true"/>
		<cfset this.myMap = arguments.map />
	</cffunction>
	
</cfcomponent>