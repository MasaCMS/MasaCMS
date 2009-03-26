<cfset page_title = "ImageCFC Documentation: crop() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.crop()</h1>
<h4>Description</h4>
<p>crops an image.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>img</td><td>A java BufferedImage object is returned if no output file is specified</td></tr>
</table>
<h4>Function Syntax</h4>
<p>crop(objImage,inputFile,outputFile,startX,startY,newWidth,newHeight,jpegCompression)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>objImage</td>
	<td>YES</td>
	<td>-</td>
	<td>A java image object, or a blank string.</td>
</tr>
<tr>
	<td>inputFile</td>
	<td>YES</td>
	<td>-</td>
	<td>File path or URL to an image, or a blank string.</td>
</tr>
<tr>
	<td>outputFile</td>
	<td>YES</td>
	<td>-</td>
	<td>File path to write the output, or a blank string.</td>
</tr>
<tr>
	<td>fromX</td>
	<td>YES</td>
	<td>-</td>
	<td>X coordinate of the upper left corner of the cropped image.</td>
</tr>
<tr>
	<td>fromY</td>
	<td>YES</td>
	<td>-</td>
	<td>Y coordinate of the upper left corner of the cropped image.</td>
</tr>

<tr>
	<td>newWidth</td>
	<td>YES</td>
	<td>-</td>
	<td>Width in pixels of the resulting image.</td>
</tr>
<tr>
	<td>newHeight</td>
	<td>YES</td>
	<td>-</td>
	<td>Height in pixels of the resulting image.</td>
</tr>

<tr>
	<td>jpegCompression</td>
	<td>NO</td>
	<td><a href="imageCFC.cfm#defaultJpegCompression">defaultJpegCompression</a></td>
	<td>jpeg compression quality to use if writing a jpeg file.  0-100.  100 is the highest quality.</td>
</tr>
</table>
<p><i>You must supply either an image object or a file path to a source image.</i></p>
<h4>Example</h4>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfset imgInfo = imageCFC.crop("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage2.jpg",1,1,100,200)>
&lt;img src="myimage2.jpg" width="100" height="200" alt="cropped image to 100x200 starting at the upper left corner."/>

</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
