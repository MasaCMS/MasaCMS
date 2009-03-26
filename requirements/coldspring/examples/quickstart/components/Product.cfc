<cfcomponent name="Product" hint="I model a Product.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfargument name="productID" type="numeric" required="true" />
		<cfset setProductID(arguments.productID) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProductID" access="public" returntype="numeric" output="false" hint="I return the ProductID.">
		<cfreturn variables.instance['productID'] />
	</cffunction>
		
	<cffunction name="setProductID" access="public" returntype="void" output="false" hint="I set the ProductID.">
		<cfargument name="productID" type="numeric" required="true" hint="ProductID" />
		<cfset variables.instance['productID'] = arguments.productID />
	</cffunction>

</cfcomponent>