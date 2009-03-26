	<!---
	$Id: image.cfc,v 1.2 2004/08/31 15:37:41 jdew Exp $
	Purpose: This is a small image manipulation component.
	
	
	Modified by Rick Root (rick@webworksllc.com) for inclusion
	in the CFFM Coldfusion File Manager (cfopen.org/projects/cffm)
	
	Copyright (c) 2004 James F. Dew <jdew@yggdrasil.ca>
	
	Permission to use, copy, modify, and distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.
	
	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
	
	SPECIAL NOTE: To use this tag if you get error messages such as 
	"cannot connect to X11 server..." when trying to use the WATERMARK routine,
	you must add: "-Djava.awt.headless=true" to the startup java line.
	EG: "$JAVA_HOME/bin/java" -server $HEAPSIZES -classpath "$NEW_CLASSPATH" \
	-Djava.awt.headless=true com.newatlanta.webserver.BlueDragon &
	--->
	
	<cfcomponent displayname="Image">
	<cfscript>
	myImage = CreateObject("java", "java.awt.image.BufferedImage");
	imageIO = CreateObject("java", "javax.imageio.ImageIO");
	validExtensionsToRead = ArrayToList(imageIO.getReaderFormatNames());
	validExtensionsToWrite = ArrayToList(imageIO.getWriterFormatNames());
	inFile  = CreateObject("java", "java.io.File");
	inURL = CreateObject("java", "java.net.URL");
	outFile = CreateObject("java", "java.io.File");
	</cfscript>

	<cfset variables.Math = createobject("java", "java.lang.Math")>
	<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
	<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
	<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>
	<cfset variables.shortClass = createobject("java", "java.lang.Short").TYPE>


<cffunction name="dump" output="yes" returnType="void">
	<cfargument name="vartodump" required="yes" type="any">
	<cfargument name="abort" required="no" type="boolean" default="false">
	<cfoutput>Dumping data:<br></cfoutput>
	<cfdump var="#vartodump#">
	<cfif abort>
		<cfabort>
	</cfif>
</cffunction>
	
<cffunction name="readImage" access="public" output="false" returntype="boolean">
	<cfargument name="inputType" required="yes" type="string"><!-- "FILE" or "URL" --->
	<cfargument name="inputSource" required="yes" type="string">
	<cfset var tmp = "">
	<cfscript>
		extension = lcase(listLast(inputSource,"."));
		if (listFindNoCase(validExtensionsToRead,extension) is 0)
		{
			return false;
		}
		inputType = lcase(inputType);
		if (inputType eq "url")
		{
			inURL.init(arguments.inputSource);
			myImage = imageIO.read(inURL);
		} else {
			inFile.init(arguments.inputSource);
			myImage = imageIO.read(inFile);
		}

		if (myImage.getType() eq 0){
			myImage = convertImageObject(myImage,myImage.TYPE_3BYTE_BGR);
		}
	</cfscript>
	<cftry>
		<cfset tmp = myImage.getWidth()>
		<cfcatch type="Any">
			<cfset myImage = "">
			<cfreturn false>
		</cfcatch>
	</cftry>
	<cfreturn true>
</cffunction>
	
<cffunction name="writeImage" access="public" output="true" returntype="boolean">
	<cfargument name="outputFile" required="yes" type="string">
	<cfscript>
		var extension = lcase(listLast(outputFile,"."));
		//dump("extension = #extension##Chr(10)#",0);
		//dump("validExtensionsToWrite = #validExtensionsToWrite##Chr(10)#",0);
		if (listFindNoCase(validExtensionsToWrite,extension) gt 0)
		{
			outFile.init(arguments.outputFile);
			results = imageIO.write(myImage, extension, outFile);
			return results;
		} else {
			return false;
		}
	</cfscript>
</cffunction>
	
<cffunction name="width" access="public" output="false" returnType="any">
	<cfreturn myImage.getWidth()>
</cffunction>
	
<cffunction name="height" access="public" output="false" returnType="any">
	<cfreturn myImage.getHeight()>
</cffunction>
	
<cffunction name="flip" access="public" output="false">
	<cfscript>
	var flippedImage = CreateObject("java", "java.awt.image.BufferedImage");
	var at = CreateObject("java", "java.awt.geom.AffineTransform");
	var op = CreateObject("java", "java.awt.image.AffineTransformOp");

	flippedImage.init(myImage.getWidth(), myImage.getHeight(), myImage.getType());
	
	at = at.getScaleInstance(1,-1);
	at.translate(0, -myImage.getHeight());
	op.init(at, op.TYPE_NEAREST_NEIGHBOR);
	op.filter(myImage, flippedImage);
	myImage = flippedImage;
	</cfscript>
</cffunction>
	
<cffunction name="flop" access="public" output="false">
	<cfscript>
	var floppedImage = CreateObject("java", "java.awt.image.BufferedImage");
	var at = CreateObject("java", "java.awt.geom.AffineTransform");
	var op = CreateObject("java", "java.awt.image.AffineTransformOp");
	
	floppedImage.init(myImage.getWidth(), myImage.getHeight(), myImage.getType());
	
	at = at.getScaleInstance(-1,1);
	at.translate(-myImage.getWidth(), 0);
	op.init(at, op.TYPE_NEAREST_NEIGHBOR);
	op.filter(myImage, floppedImage);
	
	myImage = floppedImage;
	</cfscript>
</cffunction>
	
<cffunction name="resize" access="public" output="false">
	<cfargument name="width" required="no" type="numeric" default="0">
	<cfargument name="height" required="no" type="numeric" default="0">
	<cfscript>
	var resizedImage = CreateObject("java", "java.awt.image.BufferedImage");
	var at = CreateObject("java", "java.awt.geom.AffineTransform");
	var op = CreateObject("java", "java.awt.image.AffineTransformOp");
	
	var w = myImage.getWidth();
	var h = myImage.getHeight();
	var scale = 1;
	
	if (width gt 0 and height eq 0) {
	scale = width / w;
	w = width;
	h = round(h*scale);
	} else if (height gt 0 and width eq 0) {
	scale = height / h;
	h = height;
	w = round(w*scale);
	} else if (height gt 0 and width gt 0) {
	w = width;
	h = height;
	} else {
	return;
	}
	resizedImage.init(javacast("int",w),javacast("int",h),myImage.getType());
	
	w = w / myImage.getWidth();
	h = h / myImage.getHeight();
	
	op.init(at.getScaleInstance(w,h), op.TYPE_NEAREST_NEIGHBOR);
	op.filter(myImage, resizedImage);
	
	myImage = resizedImage;
	</cfscript>
</cffunction>
	
<cffunction name="rotate" access="public" output="false">
	<cfargument name="degrees" required="yes" type="numeric">
	<cfscript>
	//degrees must be 90,180, or 270.
	var rotatedImage = CreateObject("java", "java.awt.image.BufferedImage");
	var at = CreateObject("java", "java.awt.geom.AffineTransform");
	var op = CreateObject("java", "java.awt.image.AffineTransformOp");
	
	var iw = myImage.getWidth();
	var ih = myImage.getHeight();
	
	var h = iw;
	var w = ih;
	var x = "";
	var y = "";
	
	if(arguments.degrees eq 180) { w = iw; h = ih; }
	
	x = (w/2)-(iw/2);
	y = (h/2)-(ih/2);
	
	rotatedImage.init(w,h,myImage.getType());
	
	at.rotate(arguments.degrees * 0.0174532925,w/2,h/2);
	at.translate(x,y);
	
	op.init(at, op.TYPE_NEAREST_NEIGHBOR);
	
	op.filter(myImage, rotatedImage);
	
	myImage = rotatedImage;
	</cfscript>
</cffunction>
	
<cffunction name="watermark" access="public" output="false">
	<cfargument name="wmfile" required="yes" type="string">
	<cfargument name="x" required="no" type="numeric" default="0">
	<cfargument name="y" required="no" type="numeric" default="0">
	<cfscript>
	var wm = CreateObject("java", "java.awt.image.BufferedImage");
	var wminFile = CreateObject("java", "java.io.File");
	var at = CreateObject("java", "java.awt.geom.AffineTransform");
	var op = CreateObject("java", "java.awt.image.AffineTransformOp");
	var AlphaComposite = CreateObject("Java", "java.awt.AlphaComposite");
	//var gfx = CreateObject("java", "java.awt.Graphics");
	var gfx = myImage.getGraphics();
	
	wminfile.init(arguments.wmfile);
	wmImage = imageIO.read(wminFile);
	gfx.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.75));
	
	at.init();
	op.init(at,op.TYPE_BILINEAR);
	gfx.drawImage(wmImage, op, arguments.x, arguments.y);
	gfx.dispose();
	</cfscript>
</cffunction>

<cffunction name="convertImageObject" access="private" output="false" returnType="any">
	<cfargument name="bImage" type="Any" required="yes">
	<cfargument name="type" type="numeric" required="yes">

	<cfscript>
	// convert the image to a specified BufferedImage type and return it

	var width = bImage.getWidth();
	var height = bImage.getHeight();
	var newImage = createObject("java","java.awt.image.BufferedImage").init(javacast("int",width), javacast("int",height), javacast("int",type));
	// int[] rgbArray = new int[width*height];
	var rgbArray = variables.arrObj.newInstance(variables.intClass, javacast("int",width*height));

	bImage.getRGB(
		javacast("int",0), 
		javacast("int",0), 
		javacast("int",width), 
		javacast("int",height), 
		rgbArray, 
		javacast("int",0), 
		javacast("int",width)
		);
	newImage.setRGB(
		javacast("int",0), 
		javacast("int",0), 
		javacast("int",width), 
		javacast("int",height), 
		rgbArray, 
		javacast("int",0), 
		javacast("int",width)
		);
	return newImage;
	</cfscript>	

</cffunction>
	</cfcomponent>

