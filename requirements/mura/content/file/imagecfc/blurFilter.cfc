 <cfcomponent name="blurFilter">
<!---
	blurFilter.cfc written by Rick Root (rick@webworksllc.com)
	
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

	<cfset variables.blurAmount = javacast("float",0)>
	<cfset variables.kernel = createObject("java","java.awt.image.Kernel")>

	<cfset variables.Math = createobject("java", "java.lang.Math")>
	<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
	<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
	<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>

<cffunction name="init" access="public" output="false" return="this">
	<cfargument name="blurAmount" type="numeric" required="yes">
	<cfset setBlurAmount(arguments.blurAmount)>
	<cfreturn this>	
</cffunction>

<cffunction name="setBlurAmount" access="public" output="false" returnType="void">
	<cfargument name="blurAmount" type="numeric" required="yes">
	<cfscript>
		variables.blurAmount = javacast("int",blurAmount);
		variables.kernel = makeKernel(variables.blurAmount);
	</cfscript>
</cffunction>

<cffunction name="getBlurAmount" access="public" output="false" returnType="numeric">
	<cfreturn variables.blurAmount>
</cffunction>

<cffunction name="filter" access="public" output="false" returntype="any">
	<cfargument name="img" required="yes" type="Any">

	<cfset var op = "">
	<cfset var blurredImage = "">
	<cfset var i = 0>
	
	<cfscript>
		op = createObject("java","java.awt.image.ConvolveOp");
		blurredImage = createObject("java","java.awt.image.BufferedImage").init(img.getWidth(), img.getHeight(), img.getType());
		
		op.init(variables.kernel, op.EDGE_NO_OP, javacast("null",""));
		op.filter(img, blurredImage);

		return blurredImage;
	</cfscript>
</cffunction>

<cffunction name="makeKernel" access="private" output="false" returnType="any">
	<cfscript>
		var i = 0;
		var arrSize = javacast("int",variables.blurAmount*variables.blurAmount);
		var matrix = arrObj.newInstance(floatClass, arrSize);

		for (i=0; i lt arrSize; i=i+1)
		{
			arrObj.setFloat(matrix, javacast("int",i), javacast("float",1/arrSize));
		}
		return createObject("java","java.awt.image.Kernel").init(variables.blurAmount, variables.blurAmount, matrix);
	</cfscript>
</cffunction>

</cfcomponent>