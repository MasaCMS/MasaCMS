<cfcomponent name="ProductFactory" hint="I build Product domain objects.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createInstance" access="public" returntype="any" output="false" hint="I get an instance of a Product object.">
		<cfargument name="productID" type="numeric" required="true" />
		
		<!--- 
		In a real application, this might query the database to get the product data for
		that ID and use it to populate the Product. You might call a Gateway object to
		actually run the query, and of course the Gateway could be injected into the
		Factory with ColdSpring!
		--->
		<cfreturn CreateObject('component', 'Product').init(arguments.productID) />
	</cffunction>

</cfcomponent>