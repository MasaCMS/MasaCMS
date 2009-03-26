<!---
	image.cfc v2.00b3, written by Rick Root (rick@webworksllc.com)
	Derivative of work originally done originally by James Dew.
	
	Related Web Sites:
	- http://www.opensourcecf.com/imagecfc (home page)
	- http://www.cfopen.org/projects/imagecfc (project page)

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

	============================================================	
	This is a derivative work.  Following is the original 
	Copyright notice.
	============================================================	
	
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
--->
<!---
	SPECIAL NOTE FOR HEADLESS SYSTEMS
	---------------------------------
	If you get a "cannot connect to X11 server" when running certain
	parts of this component under Bluedragon (Linux), you must
	add "-Djava.awt.headless=true" to the java startup line in
	<bluedragon>/bin/StartBluedragon.sh.  This isssue is discussed
	in the Bluedragon Installation Guide section 3.8.1 for
	Bluedragon 6.2.1.

	Bluedragon may also report a ClassNotFound exception when trying
	to instantiate the java.awt.image.BufferedImage class.  This is
	most likely the same issue.

	If you get "This graphics environment can be used only in the
	software emulation mode" when calling certain parts of this
	component under Coldfusion MX, you should refer to Technote
	ID #18747:  http://www.macromedia.com/go/tn_18747 
--->

<cfcomponent displayname="Image">
<cfproperty name="throwOnError" type="boolean" default="No">

<cfset this.throwOnError = "No">

<cffunction name="setThrowOnError" access="public" output="false" returnType="void">
	<cfargument name="setting" required="yes" type="Boolean">
	<cfset this.throwOnError = setting>
</cffunction>

<cffunction name="getImageInfo" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	
	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var img = "">
	
	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cftry>
		<cfset retVal.width = img.getWidth()>
		<cfset retVal.height = img.getHeight()>
		<cfset retVal.colorModel = img.getColorModel().toString()>
		<cfset retVal.sampleModel = img.getSampleModel().toString()>
		<cfset retVal.imageType = img.getType()>
		<cfset retVal.misc = img.toString()>
		<cfcatch type="any">
			<cfset retVal.errorcode = 1>
			<cfset retVal.errorMessage="#cfcatch.message#: #cfcatch.detail#">
			<cfif this.throwOnError><cfthrow message="#cfcatch.message#" detail="#cfcatch.detail#"></cfif>
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction name="flipHorizontal" access="public" output="true" returntype="struct" hint="Flip an image horizontally.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfreturn flipflop(objImage, inputFile, outputFile, "horizontal", jpegCompression)>
</cffunction>

<cffunction name="flipVertical" access="public" output="true" returntype="struct" hint="Flop an image vertically.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfreturn flipflop(objImage, inputFile, outputFile, "vertical", jpegCompression)>	
</cffunction>

<cffunction name="scaleX" access="public" output="true" returntype="struct" hint="Scale an image to a specific width.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfreturn resize(objImage, inputFile, outputFile, newWidth, 0, jpegCompression)>
</cffunction>

<cffunction name="scaleY" access="public" output="true" returntype="struct" hint="Scale an image to a specific height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfreturn resize(objImage, inputFile, outputFile, 0, newHeight, jpegCompression)>
</cffunction>

<cffunction name="resizeOld" access="public" output="true" returntype="struct" hint="Resize an image to a specific width and height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var at = "">
	<cfset var op = "">
	<cfset var w = "">
	<cfset var h = "">
	<cfset var scale = 1>
	<cfset var resizedImage = "">
	<cfset var rh = getRenderingHints()>
	<cfset var img = "" />

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	<cfscript>
		resizedImage = CreateObject("java", "java.awt.image.BufferedImage");
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");

		w = img.getWidth();
		h = img.getHeight();

		if (newWidth gt 0 and newHeight eq 0) {
			scale = newWidth / w;
			w = newWidth;
			h = round(h*scale);
		} else if (newHeight gt 0 and newWidth eq 0) {
			scale = newHeight / h;
			h = newHeight;
			w = round(w*scale);
		} else if (newHeight gt 0 and newWidth gt 0) {
			w = newWidth;
			h = newHeight;
		} else {
			retval.errorCode = 1;
			retVal.errorMessage = "You cannot resize an image to 0x0 pixels.";
			if (this.throwOnError) {
				throw("Trapped Error Occurred During Image Manipulation", retVal.errorMessage);
			}

			return retVal;
		}
		resizedImage.init(javacast("int",w),javacast("int",h),img.getType());

		w = w / img.getWidth();
		h = h / img.getHeight();

		op.init(at.getScaleInstance(w,h), rh);
		op.filter(img, resizedImage);

		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = resizedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, resizedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="resize" access="public" output="true" returntype="struct" hint="Resize an image to a specific width and height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="preserveAspect" required="no" type="boolean" default="FALSE">
	<cfargument name="cropToExact" required="no" type="boolean" default="FALSE">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var at = "">
	<cfset var op = "">
	<cfset var w = "">
	<cfset var h = "">
	<cfset var scale = 1>
	<cfset var scaleX = 1>
	<cfset var scaleY = 1>
	<cfset var resizedImage = "">
	<cfset var rh = getRenderingHints()>
	<cfset var specifiedWidth = arguments.newWidth>
	<cfset var specifiedHeight = arguments.newHeight>
	<cfset var imgInfo = "">
	<cfset var img = "">
	<cfset var cropImageResult = "">
	<cfset var cropOffsetX = "">
	<cfset var cropOffsetY = "">
	<cfset var targetHeight= arguments.newWidth>
	<cfset var targetWidth= arguments.newHeight>
	<cfset var g2= "">
	<cfset var temp= "">
	
	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	<cfif img.getType() eq 0>
		<cfset img = convertImageObject(img,img.TYPE_3BYTE_BGR)>
	</cfif>
	<cfscript>

		//at = CreateObject("java", "java.awt.geom.AffineTransform");
		//op = CreateObject("java", "java.awt.image.AffineTransformOp");

		w = img.getWidth();
		h = img.getHeight();

		if (preserveAspect and cropToExact and newHeight gt 0 and newWidth gt 0)
		{
			if (w / h gt newWidth / newHeight){
				newWidth = 0;
			} else if (w / h lt newWidth / newHeight){
				newHeight = 0;
		    }
		} else if (preserveAspect and newHeight gt 0 and newWidth gt 0) {
			if (w / h gt newWidth / newHeight){
				newHeight = 0;
			} else if (w / h lt newWidth / newHeight){
				newWidth = 0;
		    }
		}
		if (newWidth gt 0 and newHeight eq 0) {
			scale = newWidth / w;
			targetWidth = newWidth;
			targetHeight = round(h*scale);
		} else if (newHeight gt 0 and newWidth eq 0) {
			scale = newHeight / h;
			targetHeight = newHeight;
			targetWidth = round(w*scale);
		} else if (newHeight gt 0 and newWidth gt 0) {
			targetWidth = newWidth;
			targetHeight = newHeight;
		} else {
			retVal = throw( retVal.errorMessage);
			return retVal;
		}
	
		resizedImage = CreateObject("java", "java.awt.image.BufferedImage");

		while(targetWidth neq or targetHeight neq h){
			if(w gt targetWidth){
				w=w/2;
				if(w gt targetWidth){
					w=targetWidth;
				}
			}

			if(h gt targetHeight){
				h=h/2;
				if(w gt targetHeight){
					h=targetHeight;
				}
			}
		
			tmp= CreateObject("java", "java.awt.image.BufferedImage");
			tmp.init(javacast("int",w),javacast("int",h),img.getType());
			g2=tmp.createGraphics();
			g2.setRenderingHints(getRenderingHints());
			g2.drawImage(resizedImage, 0, 0,javacast("int",w),javacast("int",h), javacast("null", ""));
			g2.dispose();
			
			resizedImage=tmp;

		}
		

		
		imgInfo = getimageinfo(resizedImage, "");
		if (imgInfo.errorCode gt 0)
		{
			return imgInfo;
		}

		cropOffsetX = max( Int( (imgInfo.width/2) - (newWidth/2) ), 0 );
		cropOffsetY = max( Int( (imgInfo.height/2) - (newHeight/2) ), 0 );
		// There is a chance that the image is exactly the correct 
		// width and height and don't need to be cropped 
		if 
			(
			preserveAspect and cropToExact
			and
			(imgInfo.width IS NOT specifiedWidth OR imgInfo.height IS NOT specifiedHeight)
			)
		{
			// Get the correct offset to get the center of the image
			cropOffsetX = max( Int( (imgInfo.width/2) - (specifiedWidth/2) ), 0 );
			cropOffsetY = max( Int( (imgInfo.height/2) - (specifiedHeight/2) ), 0 );
			
			cropImageResult = crop( resizedImage, "", "", cropOffsetX, cropOffsetY, specifiedWidth, specifiedHeight );
			if ( cropImageResult.errorCode GT 0)
			{
				return cropImageResult;
			} else {
				resizedImage = cropImageResult.img;
			}
		}
		if (outputFile eq "")
		{
			retVal.img = resizedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, resizedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="crop" access="public" output="true" returntype="struct" hint="Crop an image.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="fromX" required="yes" type="numeric">
	<cfargument name="fromY" required="yes" type="numeric">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var croppedImage = "">
	<cfset var rh = getRenderingHints()>
	<cfset var img = "" />

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cfscript>
		if (fromX + newWidth gt img.getWidth()
			OR
			fromY + newHeight gt img.getHeight()
			)
		{
			retVal.errorCode = 1;
			retVal.errorMessage = "The cropped image dimensions go beyond the original image dimensions.";
			if (this.throwOnError) {
				throw("Trapped Error Occurred During Image Manipulation", retVal.errorMessage);
			}
			return retVal;
		}
		croppedImage = img.getSubimage(javaCast("int", fromX), javaCast("int", fromY), javaCast("int", newWidth), javaCast("int", newHeight) );
		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = croppedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, croppedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="rotate" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="degrees" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var img = "">
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var at = "">
	<cfset var op = "">
	<cfset var w = 0>
	<cfset var h = 0>
	<cfset var iw = 0>
	<cfset var ih = 0>
	<cfset var x = 0>
	<cfset var y = 0>
	<cfset var rotatedImage = "">
	<cfset var rh = getRenderingHints()>

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cfif ListFind("-270,-180,-90,90,180,270",degrees) is 0>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "At this time, image.cfc only supports rotating images (+/-)90, (+/-)180, or (+/-)270 degrees.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	</cfif>

	<cfscript>
		rotatedImage = CreateObject("java", "java.awt.image.BufferedImage");
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");

		iw = img.getWidth(); h = iw;
		ih = img.getHeight(); w = ih;

		if(arguments.degrees eq 180) { w = iw; h = ih; }
				
		x = (w/2)-(iw/2);
		y = (h/2)-(ih/2);
		
		rotatedImage.init(w,h,img.getType());

		at.rotate(arguments.degrees * 0.0174532925,w/2,h/2);
		at.translate(x,y);
		op.init(at, rh);
		
		op.filter(img, rotatedImage);

		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = rotatedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, rotatedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="convert" access="public" output="true" returntype="struct" hint="Convert an image from one format to another.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">
	
	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var img = "" />

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cfscript>
		if (outputFile eq "")
		{
			retVal.errorCode = 1;
			retVal.errorMessage = "The convert method requires a valid output filename.";
			if (this.throwOnError) {
				throw("Trapped Error Occurred During Image Manipulation", retVal.errorMessage);
			}
			return retVal;
		} else {
			saveImage = writeImage(outputFile, img, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="getRenderingHints" access="private" output="false" returnType="any" hint="Internal method controls various aspects of rendering quality.">
	<cfset var rh = CreateObject("java","java.awt.RenderingHints")>
	<cfset var initMap = CreateObject("java","java.util.HashMap")>
	<cfset initMap.init()>
	<cfset rh.init(initMap)>
	<cfset rh.put(rh.KEY_ALPHA_INTERPOLATION, rh.VALUE_ALPHA_INTERPOLATION_QUALITY)> <!--- QUALITY, SPEED, DEFAULT --->
	<cfset rh.put(rh.KEY_ANTIALIASING, rh.VALUE_ANTIALIAS_ON)> <!--- ON, OFF, DEFAULT --->
	<cfset rh.put(rh.KEY_COLOR_RENDERING, rh.VALUE_COLOR_RENDER_QUALITY)>  <!--- QUALITY, SPEED, DEFAULT --->
	<cfset rh.put(rh.KEY_DITHERING, rh.VALUE_DITHER_DISABLE)> <!--- DISABLE, ENABLE, DEFAULT --->
	<cfset rh.put(rh.KEY_INTERPOLATION, rh.VALUE_INTERPOLATION_BICUBIC)> <!--- NEAREAST_NEIGHBOR, BILINEAR, BICUBIC --->
	<cfset rh.put(rh.KEY_RENDERING, rh.VALUE_RENDER_QUALITY)> <!--- QUALITY, SPEED, DEFAULT --->
	<cfreturn rh>
</cffunction>

<cffunction name="readImage" access="private" output="true" returntype="struct" hint="Reads an image from a local file.  Requires an absolute path.">
	<cfargument name="source" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">

	<cfif isURL(source)>
		<cfreturn readImageFromURL(source, forModification)>
	<cfelse>
		<cfreturn readImageFromFile(source, forModification)>
	</cfif>
</cffunction>

<cffunction name="readImageFromFile" access="private" output="true" returntype="struct" hint="Reads an image from a local file.  Requires an absolute path.">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">
	
	<cfset var retVal = StructNew()>
	<cfset var img = "">
	<cfset var inFile = "">
	<cfset var filename = getFileFromPath(inputFile)>
	<cfset var extension = lcase(listLast(inputFile,"."))>
	<cfset var imageIO = CreateObject("java", "javax.imageio.ImageIO")>
	<cfset var validExtensionsToRead = ArrayToList(imageIO.getReaderFormatNames())>
	
	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">
	
	<cfif not fileExists(arguments.inputFile)>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "The specified file #Chr(34)##arguments.inputFile##Chr(34)# could not be found.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelseif listLen(filename,".") lt 2>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "Sorry, image files without extensions cannot be manipulated.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelseif listFindNoCase(validExtensionsToRead, extension) is 0>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "Java is unable to read #extension# files.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelse>
		<cfset img = CreateObject("java", "java.awt.image.BufferedImage")>
		<cfset inFile = CreateObject("java", "java.io.File")>
		<cfset inFile.init(arguments.inputFile)>
		<cfif NOT inFile.canRead()>
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "Unable to open source file #Chr(34)##arguments.inputFile##Chr(34)#.">
			<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
			<cfreturn retVal>
		<cfelse>
			<cfset img = imageIO.read(inFile)>
			<cfif forModification AND img.getType() eq img.TYPE_CUSTOM>
				<!--- cannot modify TYPE_CUSTOM im ages, probably an RGB png --->
				<cfset retVal.errorCode = 1>
				<cfset retVal.errorMessage = "The image format or subformat cannot be modified by the image.cfc component.  For example, RGB format PNGs are not supported, even though indexed color PNGs are supported.  Technical detail:  The requested image was of type java.awt.image.BufferedImage.TYPE_CUSTOM.">
				<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
				<cfreturn retVal>
			<cfelse>
				<cfset retVal.img = img>
				<cfset retVal.errorCode = 0>
				<cfset retVal.errorMessage = "">
				<cfreturn retVal>
			</cfif>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="readImageFromURL" access="private" output="true" returntype="struct" hint="Read an image from a URL.  Requires an absolute URL.">
	<cfargument name="inputURL" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">

	<cfset var retVal = StructNew()>
	<cfset var img = CreateObject("java", "java.awt.image.BufferedImage")>
	<cfset var inURL	= CreateObject("java", "java.net.URL")>
	<cfset var imageIO = CreateObject("java", "javax.imageio.ImageIO")>
	
	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">


	<cfset inURL.init(arguments.inputURL)>
	<cfset img = imageIO.read(inURL)>
	<cfif forModification AND img.getType() eq img.TYPE_CUSTOM>
		<!--- cannot modify TYPE_CUSTOM im ages, probably an RGB png --->
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "The image format or subformat cannot be modified by the image.cfc component.  For example, RGB format PNGs are not supported, even though indexed color PNGs are supported.  Technical detail:  The requested image was of type java.awt.image.BufferedImage.TYPE_CUSTOM.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelse>
		<cfset retVal.img = img>
		<cfset retVal.errorCode = 0>
		<cfset retVal.errorMessage = "">
		<cfreturn retVal>
	</cfif>
</cffunction>

<cffunction name="writeImage" access="private" output="true" returntype="struct" hint="Write an image to disk.">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="img" required="yes" type="any">
	<cfargument name="jpegCompression" required="yes" type="numeric">

	<cfset var retVal = StructNew()>
	<cfset var outFile = "">
	<cfset var filename = getFileFromPath(outputFile)>
	<cfset var extension = lcase(listLast(filename,"."))>
	<cfset var imageIO = CreateObject("java", "javax.imageio.ImageIO")>
	<cfset var validExtensionsToWrite = ArrayToList(imageIO.getWriterFormatNames())>
	<cfset var emptyIIOMetaData = "">
	<cfset var emptyArrayList = "">
	<cfset var its = ""> <!--- object for ImageTypeSpecifier --->
	
	<!--- the following are used for the NEW write method --->
	<cfset var iter = "">
	<cfset var writer = "">
	<cfset var ios = "">
	<cfset var iwparam = "">
	<cfset var iioImage = "">
	
	<cfif listFindNoCase(validExtensionsToWrite, extension) eq 0>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "Java is unable to write #extension# files.  Valid formats include: #validExtensionsToWrite#">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelse>
		<cfset outFile = CreateObject("java", "java.io.File")>
		<cfset outFile.init(arguments.outputFile)>
		<cfif NOT outFile.canWrite() AND 1 eq 0>
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "Unable to write destination file #Chr(34)##arguments.outputFile##Chr(34)#.">
			<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
			<cfreturn retVal>
		<cfelse>
			<!--- new write method --->
			<cfscript>
				iter = ImageIO.getImageWritersBySuffix(extension);
				if (iter.hasNext()) {
					writer = iter.next();
				} else {
					retVal.errorCode = 1;
					retVal.errorMessage = "Sorry, java doesn't seem to have the ability to write files with a #CHr(34)##extension##Chr(34)#.";
					if (this.throwOnError) {
						throw("Trapped Error Occurred During Image Manipulation", retVal.errorMessage);
					}
					return retVal;
				}
				
				// Prepare output file
				ios = ImageIO.createImageOutputStream(outfile);
				if ( not isDefined("ios") )
				{
					retVal.errorCode = 1;
					retVal.errorMessage = "Unable to write destination file #outputFile# - permission denied or directory path error.";
					if (this.throwOnError) {
                                                throw("Trapped Error Occurred During Image Manipulation", retVal.errorMessage);
					}
					return retVal;
				}
				writer.setOutput(ios);
			
				// iwparam = createObject("java", "javax.imageio.plugins.jpeg.JPEGImageWriteParam");
				// iwparam.init(CreateObject("java","java.util.Locale").init("en_US"));
				iwparam = writer.getDefaultWriteParam();
				if (iwparam.canWriteCompressed())
				{
					// Set the compression quality
					// note this only works for jpg right now.
					if (jpegCompression gt 100 or jpegCompression lt 0) { 
						jpegCompression = 1.0;
					} else if (jpegCompression gt 1) {
						jpegCompression = jpegCompression / 100;
					}
					iwparam.setCompressionMode(iwparam.MODE_EXPLICIT) ;
					iwparam.setCompressionQuality(jpegCompression);
				}
				iioImage = createObject("java", "javax.imageio.IIOImage");

				its = createObject("java","javax.imageio.ImageTypeSpecifier");
				its.init(img);

				emptyIIOMetadata = writer.getDefaultImageMetadata(its, iwparam);
				emptyArrayList = CreateObject("java","java.util.ArrayList");

				// workaround for Bluedragon 6.2
				// Don't ask me why this is necessary!
				foo = emptyIIOMetadata.toString();
				foo2 = emptyArrayList.toString();
				
				iioImage.init(img, emptyArrayList, emptyIIOMetadata);
				
				// Write the image
				writer.write(emptyIIOMetaData , iioImage, iwparam);
				
				// Cleanup
				ios.flush();
				writer.dispose();
				ios.close();
			</cfscript>
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
			<cfreturn retVal>
		</cfif>
	</cfif>
	
</cffunction>

<cffunction name="flipflop" access="private" output="true" returntype="struct" hint="Internal method used for flipping and flopping images.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="direction" required="yes" type="string"><!--- horizontal or vertical --->
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var flippedImage = "">
	<cfset var at = ""><!--- AffineTransform --->
	<cfset var op = ""><!--- AffineTransformOp --->
	<cfset var rh = getRenderingHints()>
	<cfset var img = "" />

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	
	
	<cfscript>
		flippedImage = CreateObject("java", "java.awt.image.BufferedImage");
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");

		flippedImage.init(img.getWidth(), img.getHeight(), img.getType());

		if (direction eq "horizontal") {
			at = at.getScaleInstance(-1, 1);
			at.translate(-img.getWidth(), 0);
		} else {
			at = at.getScaleInstance(1,-1);
			at.translate(0, -img.getHeight());
		}
		op.init(at, rh);
		op.filter(img, flippedImage);

		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = flippedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, flippedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="addText" access="public" output="true" returntype="struct" hint="Add text to an image.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="x" required="yes" type="numeric">
	<cfargument name="y" required="yes" type="numeric">
	<cfargument name="fontDetails" required="yes" type="struct">
	<cfargument name="content" required="yes" type="String">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var g2d = "">
	<cfset var bgImage = "">
	<cfset var fontImage = "">
	<cfset var overlayImage = "">
	<cfset var Color = "">
	<cfset var font = "">
	<cfset var font_stream = "">
	<cfset var ac = "">
	<cfset var rgb = "" />
	<cfset var img = "" />
	<cfset var fontdetails = "" />

	<cfparam name="fontDetails.size" default="12">
	<cfparam name="fontDetails.color" default="black">

	<cfif not StructKeyExists(fontDetails,"fontFile")>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "Unable to draw text because no font filename was specified.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	<cfelseif not fileExists(fontDetails.fontFile)>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "The specified font file #Chr(34)##arguments.inputFile##Chr(34)# could not be found on the server.">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	</cfif>
<cftry>
	<cfset rgb = getRGB(fontDetails.color, "Yes")>
	<cfcatch type="any">
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "Invalid color #Chr(34)##fontDetails.color##Chr(34)#">
		<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
		<cfreturn retVal>
	</cfcatch>
</cftry>
	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset img = loadImage.img>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cfscript>
		// load objects
		bgImage = CreateObject("java", "java.awt.image.BufferedImage");
		fontImage = CreateObject("java", "java.awt.image.BufferedImage");
		overlayImage = CreateObject("java", "java.awt.image.BufferedImage");
		Color = CreateObject("java","java.awt.Color");
		font = createObject("java","java.awt.Font");
		font_stream = createObject("java","java.io.FileInputStream");
		ac = CreateObject("Java", "java.awt.AlphaComposite");
	
		// set up basic needs
		fontColor = Color.init(javacast("int", rgb.red), javacast("int", rgb.green), javacast("int", rgb.blue));
		font_stream.init(fontDetails.fontFile);
		font = font.createFont(font.TRUETYPE_FONT, font_stream);
		font = font.deriveFont(javacast("float",fontDetails.size));
		
		// get font metrics using a 1x1 bufferedImage
		fontImage.init(1,1,img.getType());
		g2 = fontImage.createGraphics();
		g2.setRenderingHints(getRenderingHints());
		fc = g2.getFontRenderContext();
		bounds = font.getStringBounds(content,fc);
		
		g2 = img.createGraphics();
		g2.setRenderingHints(getRenderingHints());
		g2.setFont(font);
		g2.setColor(fontColor);
		// in case you want to change the alpha
		// g2.setComposite(ac.getInstance(ac.SRC_OVER, 0.50));

		// the location (fontDetails.size+y) doesn't really work
		// the way I want it to.
		g2.drawString(content,javacast("int",x),javacast("int",fontDetails.size+y));
		
		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = img;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, img, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="watermark" access="public" output="false">
	<cfargument name="objImage1" required="yes" type="Any">
	<cfargument name="objImage2" required="yes" type="Any">
	<cfargument name="inputFile1" required="yes" type="string">
	<cfargument name="inputFile2" required="yes" type="string">
	<cfargument name="alpha" required="yes" type="numeric">
	<cfargument name="placeAtX" required="yes" type="numeric">
	<cfargument name="placeAtY" required="yes" type="numeric">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="90">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var originalImage = "">
	<cfset var wmImage = "">
	<cfset var saveImage = StructNew()>
	<cfset var ac = "">
	<cfset var at = ""><!--- AffineTransform --->
	<cfset var op = ""><!--- AffineTransformOp --->
	<cfset var rh = getRenderingHints()>

	<cfif inputFile1 neq "">
		<cfset loadImage = readImage(inputFile1, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset originalImage = loadImage.img>
		</cfif>
	<cfelse>
		<cfset originalImage = objImage1>
	</cfif>

	<cfif inputFile2 neq "">
		<cfset loadImage = readImage(inputFile2, "NO")>
		<cfif loadImage.errorCode gt 0>
			<cfreturn loadImage>
		<cfelse>
			<cfset wmImage = loadImage.img>
		</cfif>
	<cfelse>
		<cfset wmImage = objImage2>
	</cfif>


	<cfscript>
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");
		ac = CreateObject("Java", "java.awt.AlphaComposite");
		gfx = originalImage.getGraphics();
		gfx.setComposite(ac.getInstance(ac.SRC_OVER, alpha));
		
		at.init();
		// op.init(at,op.TYPE_BILINEAR);
		op.init(at, rh);
		
		gfx.drawImage(wmImage, op, arguments.placeAtX, arguments.placeAtY);
		gfx.dispose();

		if (outputFile eq "")
		{
			retVal.errorCode = 0;
			retVal.errorMessage = "";
			retVal.img = originalImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, originalImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="mydump" access="private" output="true" returnType="void" hint="Internal method used for dumping from within cfscript.">
	<cfargument name="Arg" type="any" required="yes">
	<cfdump var="#arg#">
</cffunction>

<cffunction name="isURL" access="private" output="false" returnType="boolean">
	<cfargument name="stringToCheck" required="yes" type="string">
	<cfif REFindNoCase("^(((https?:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$",stringToCheck) NEQ 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- function returns RGB values in a structure for hex or the 16
	HTML named colors --->
<cffunction name="getRGB" access="private" output="true" returnType="struct">
	<cfargument name="color" type="string" required="yes">
	<cfargument name="throwOnInvalidColor" type="boolean" required="no" default="yes">

	<cfset var retVal = structNew()>
	<cfset var cnt = 0>
	<cfset var namedColors = "aqua,black,blue,fuchsia,gray,green,lime,maroon,navy,olive,purple,red,silver,teal,white,yellow">
	<cfset var namedColorsHexValues = "00ffff,000000,0000ff,ff00ff,808080,008000,00ff00,800000,000080,808080,ff0000,c0c0c0,008080,ffffff,ffff00">
	<cfset var color = "" />
	<cfset retVal.red = 0>
	<cfset retVal.green = 0>
	<cfset retVal.blue = 0>
	
	<cfset color = trim(color)>
	<cfif len(color) is 0>
		<cfif throwOnInvalidColor>
			<cfthrow message="1">
		<cfelse>
			<cfreturn retVal>
		</cfif>
	<cfelseif listFind(namedColors, color) gt 0>
		<cfset color = listGetAt(namedColorsHexValues, listFind(namedColors, color))>
	</cfif>
	<cfif left(color,1) eq "##">
		<cfset color = right(color,len(color)-1)>
	</cfif>
	<cfif len(color) neq 6>
		<cfif throwOnInvalidColor>
			<cfthrow message="1">
		<cfelse>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cftry>
			<cfset retVal.red = InputBaseN(mid(color,1,2),16)>
			<cfset retVal.green = InputBaseN(mid(color,3,2),16)>
			<cfset retVal.blue = InputBaseN(mid(color,5,2),16)>
			<cfcatch type="any">
				<Cfif throwOnInvalidColor>
					<cfthrow message="1">
				<cfelse>
					<cfset retVal.red = 0>
					<cfset retVal.green = 0>
					<cfset retVal.blue = 0>
					<cfreturn retVal>
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>
	<cfreturn retVal>
</cffunction>

<cffunction name="throw" access="private" output="false" returnType="void">
	<cfargument name="message" type="string" required="yes">
	<cfargument name="detail" type="string" required="yes">
	<cfthrow detail="#arguments.detail#" message="#arguments.message#">
</cffunction>

</cfcomponent>

