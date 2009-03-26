<cfcomponent name="sharpenFilter">
<!---
	sharpenFilter.cfc written by Rick Root (rick@webworksllc.com)
	
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


	<cfset variables.Math = createobject("java", "java.lang.Math")>
	<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
	<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
	<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>

	<cfset variables.kernel = makeKernel()>

<cffunction name="init" access="public" output="false" return="this">
	<cfreturn this>	
</cffunction>

<cffunction name="filter" access="public" output="false" returntype="any">
	<cfargument name="img" required="yes" type="Any">

	<cfset var op = "">
	<cfset var sharpenedImage = "">
	<cfset var i = 0>

	<cfscript>
		op = createObject("java","java.awt.image.ConvolveOp");
		sharpenedImage = createObject("java","java.awt.image.BufferedImage").init(img.getWidth(), img.getHeight(), img.getType());
		
		op.init(variables.kernel, op.EDGE_NO_OP, javacast("null",""));
		op.filter(img, sharpenedImage);

		return sharpenedImage;
	</cfscript>
</cffunction>

<cffunction name="makeKernel" access="private" output="false" returnType="any">
	<cfscript>
		var i = 0;
		var arrSize = javacast("int", 9);
		var matrix = arrObj.newInstance(floatClass, arrSize);

		arrObj.setFloat(matrix, javacast("int",0), javacast("float", 0.0));
		arrObj.setFloat(matrix, javacast("int",1), javacast("float", -1.0));
		arrObj.setFloat(matrix, javacast("int",2), javacast("float", 0.0));
		arrObj.setFloat(matrix, javacast("int",3), javacast("float", -1.0));
		arrObj.setFloat(matrix, javacast("int",4), javacast("float", 5.0));
		arrObj.setFloat(matrix, javacast("int",5), javacast("float", -1.0));
		arrObj.setFloat(matrix, javacast("int",6), javacast("float", 0.0));
		arrObj.setFloat(matrix, javacast("int",7), javacast("float", -1.0));
		arrObj.setFloat(matrix, javacast("int",8), javacast("float", 0.0));

		return createObject("java","java.awt.image.Kernel").init(3, 3, matrix);
	</cfscript>
</cffunction>

</cfcomponent>