<cfset page_title = "ImageCFC Documentation: watermark() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.watermark()</h1>
<h4>Description</h4>
<p>adds text to an image.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>img</td><td>A java BufferedImage object is returned if no output file is specified</td></tr>
</table>
<h4>Function Syntax</h4>
<p>watermark(objImage1,objImage2,inputFile1,inputFile2,alpha,placeAtX,placeAtY,outputFile,jpegCompression)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>objImage1</td>
	<td>YES</td>
	<td>-</td>
	<td>A java image object, or a blank string.</td>
</tr>
<tr>
	<td>objImage2</td>
	<td>YES</td>
	<td>-</td>
	<td>A java image object to be watermarked on the original image, or a blank string.</td>
</tr>
<tr>
	<td>inputFile1</td>
	<td>YES</td>
	<td>-</td>
	<td>File path or URL to an image, or a blank string.</td>
</tr>
<tr>
	<td>inputFile2</td>
	<td>YES</td>
	<td>-</td>
	<td>File path or URL to an image to be watermarked on the original image, or a blank string.</td>
</tr>
<tr>
	<td>alphpa</td>
	<td>YES</td>
	<td>-</td>
	<td>Alpha transparency value of the watermark image.  0.0 = invisible, 1.0 = not transparent at all.</td>
</tr>

<tr>
	<td>placeAtX</td>
	<td>YES</td>
	<td>-</td>
	<td>X coordinate where the upper left corner of the watermarked image will be placed.</td>
</tr>
<tr>
	<td>placeAtY</td>
	<td>YES</td>
	<td>-</td>
	<td>Y coordinate where the upper left corner of the watermarked image will be placed.</td>
</tr>


<tr>
	<td>outputFile</td>
	<td>YES</td>
	<td>-</td>
	<td>File path to write the output, or a blank string.</td>
</tr>

<tr>
	<td>jpegCompression</td>
	<td>NO</td>
	<td><a href="imageCFC.cfm#defaultJpegCompression">defaultJpegCompression</a></td>
	<td>jpeg compression quality to use if writing a jpeg file.  0-100.  100 is the highest quality.</td>
</tr>
</table>
<p><i>For each element of the water mark (the base image and the overlay), you 
must supply either an image object or a file path to a source image.</i></p>
<h4>Example</h4>
<p>This example takes "myimage.jpg", and places "featuer.gif" on top of it as an overlay
with 50% transparency, and writes the results to "watermarked.jpg".</p>
<pre>
&lt;cfset results1 = imageCFC.watermark(
	"", "", &lt;!--- original image and watermark image objects --->
	"C:\Inetpub\wwwroot\myimage.jpg",  &lt;!--- original image file --->
	"C:\Inetpub\wwwroot\feather.gif", &lt;!--- watermark image file --->
	0.5, &lt;!--- alpha level (0 = invisible, 1 = solid) --->
	50, 50, &lt;!--- X and Y location of watermarked image. --->
	"C:\Inetpub\wwwroot\watermarked.jpg" &lt;!--- output image file --->
	)>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
