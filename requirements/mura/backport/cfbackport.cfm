<cfsilent>
	<!---
	<cfscript>
		local.product = StructNew();
		local.product.major = ListFirst(server.coldfusion.productVersion);
		local.product.minor = ListFirst(Replace(ListDeleteAt(server.coldfusion.productVersion, 1), ",", "."));
		param name="backportdir" default='';
		request.backported=true;
	</cfscript>
	
	<cfif local.product.major lt 9>
		<cfinclude template="#backportdir#cf9.cfm" />
	</cfif>
	--->
	<cfif ListFirst(server.coldfusion.productVersion) lt 10>
		<cfinclude template="#backportdir#cf10.cfm" />
	</cfif>
	<!---
	<cfif local.product.major lt 11 AND local.product.major gte 9>
		<cfinclude template="#backportdir#cf11.cfm" />
	</cfif>
	--->

	<!---
	<cffunction name="tempEncodeForHTML" output="false">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
		<cfreturn encodeForHTML(arguments.inputString)>
	</cffunction>

	<cffunction name="tempEncodeForHTMLAttribute" output="false">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
		<cfreturn encodeForHTMLAttribute(arguments.inputString)>
	</cffunction>

	<cffunction name="tempEncodeForURL" output="false">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
		<cfreturn encodeForURL(arguments.inputString)>
	</cffunction>

	<cffunction name="tempEncodeForJavascript" output="false">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
		<cfreturn encodeForJavascript(arguments.inputString)>
	</cffunction>

	<cffunction name="tempCanonicalize" output="false">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to be encode" />
		<cfreturn canonicalize(arguments.inputString,true,false)>
	</cffunction>

	<cffunction name="tempSessionRotate" output="false">
		<cfset sessionRotate()>
	</cffunction>

	<cffunction name="tempSessionInvalidate" output="false">
		<cfset sessionInvalidate()>
	</cffunction>
	--->
</cfsilent>
