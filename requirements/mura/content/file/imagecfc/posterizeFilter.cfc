<cfcomponent name="posterizeFilter">
<!---
	posterizeFilter.cfc written by Rick Root (rick@webworksllc.com)
	
	Related Web Sites:
	- http://www.opensourcecf.com/imagecfc (home page)

	LICENSE
	-------
	Copyright (c) 2006, Rick Root <rick@webworksllc.com>
	All rights reserved.

	Redistribution and use in source and binary forms, with or 
	without modification, are permitted provided that the 
	following conditions are met:

	- Redistributions of source code must retain the above 
	  copyright notice, this list of conditions and the 
	  following disclaimer. 
	- Redistributions in binary form must reproduce the above 
	  copyright notice, this list of conditions and the 
	  following disclaimer in the documentation and/or other 
	  materials provided with the distribution. 
	- Neither the name of the Webworks, LLC. nor the names of 
	  its contributors may be used to endorse or promote products 
	  derived from this software without specific prior written 
	  permission. 

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
	CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
	OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--->

	<cfset variables.amount = 32>
	
	<cfset variables.Math = createobject("java", "java.lang.Math")>
	<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
	<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
	<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>
	<cfset variables.shortClass = createobject("java", "java.lang.Short").TYPE>

<cffunction name="init" access="public" output="false" return="this">
	<cfargument name="amount" required="yes" type="numeric">
	<cfset setAmount(arguments.amount)>
	<cfreturn this>	
</cffunction>

<cffunction name="setAmount" access="public" output="false" return="this">
	<cfargument name="amount" required="yes" type="numeric">
	<cfset variables.amount = arguments.amount>
	<cfreturn this>	
</cffunction>

<cffunction name="getAmount" access="public" output="false" return="this">
	<cfreturn variables.amount>	
</cffunction>

<cffunction name="filter" access="public" output="false" returntype="any">
	<cfargument name="img" required="yes" type="Any">

	<cfset var op = "">
	<cfset var posterizedImage = "">
	<cfset var i = 0>
	<cfset var val = createObject("java","java.lang.Integer")>

	<cfset var posterize = arrObj.newInstance(shortClass, javacast("int",256))>

	<cfloop from="0" to="255" step="1" index="i">
		<cfset val.init(javacast("int",i - (i mod variables.amount)))>
		<cfset arrObj.setShort(posterize, javacast("int",i), val.shortValue())>
	</cfloop>
	<cfscript>
		lut = createObject("java","java.awt.image.ShortLookupTable").init(0, posterize);
		op = createObject("java","java.awt.image.LookupOp");
		posterizedImage = createObject("java","java.awt.image.BufferedImage").init(img.getWidth(), img.getHeight(), img.getType());
		
		op.init(lut, javacast("null",""));
		op.filter(img, posterizedImage);

		return posterizedImage;
	</cfscript>
</cffunction>

</cfcomponent>
