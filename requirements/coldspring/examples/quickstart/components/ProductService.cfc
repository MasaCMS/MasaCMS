<cfcomponent name="ProductService" hint="">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProduct" access="public" returntype="any" output="false" hint="I return a Product based on the passed ID.">
		<cfargument name="productID" type="numeric" required="true" />
		<cfreturn getProductFactory().createInstance(arguments.productID) />
	</cffunction>
	
	<cffunction name="getProductFactory" access="public" returntype="any" output="false" hint="I return the ProductFactory.">
		<cfreturn variables.instance['productFactory'] />
	</cffunction>
		
	<cffunction name="setProductFactory" access="public" returntype="void" output="false" hint="I set the ProductFactory.">
		<cfargument name="productFactory" type="any" required="true" hint="ProductFactory" />
		<cfset variables.instance['productFactory'] = arguments.productFactory />
	</cffunction>

</cfcomponent>