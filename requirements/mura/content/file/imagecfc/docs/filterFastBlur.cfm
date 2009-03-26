<cfset page_title = "ImageCFC Documentation: filterFastBlur() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.filterFastBlur()</h1>
<h4>Description</h4>
<p>Applies a simple blur filter to an image.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>img</td><td>A java BufferedImage object is returned if no output file is specified</td></tr>
</table>
<h4>History</h4>
<p>Added to image.cfc version 2.10</p>
<h4>Function Syntax</h4>
<p>filterFastBlur(objImage,inputFile,outputFile,blurAmount,iterations,jpegCompression)</p>
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
	<td>blurAmount</td>
	<td>YES</td>
	<td>-</td>
	<td>The amount of the blur (a positive integer).  <b>NOTE:</b>  Keep this number small, as this method cannot handle blurring the edges of an image, based on the blur amount.  If the blur amount is 10, then the outer 10 pixels of the image will not be blurred.</td>
</tr>
<tr>
	<td>iterations</td>
	<td>YES</td>
	<td>-</td>
	<td>How many times to perform the blur (a positive integer)  <b>NOTE:</b>  Don't overdo it!  Applying this blur method many times will lead to edge distortion.</td>
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
&lt;cfset imgInfo = imageCFC.filterFastBlur("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage2.jpg",1,5)>
&lt;img src="myimage2.jpg" alt="filtered image"/>

</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
