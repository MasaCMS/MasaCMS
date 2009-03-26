<cfset page_title = "ImageCFC Documentation: scaleHeight() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.scaleHeight()</h1>
<h4>Description</h4>
<p>Resizes an image to a specific height, calculating the width to maintain the image's aspect ratio.</p>
<p><i>This method simply calls the resize() method.</i></p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>img</td><td>A java BufferedImage object is returned if no output file is specified</td></tr>
</table>
<h4>Function Syntax</h4>
<p>scaleHeight(objImage,inputFile,outputFile,newHeight,jpegCompression)</p>
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
&lt;cfset imgInfo = imageCFC.scaleHeight("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\tn_myimage.jpg",100)>
&lt;img src="myimage.jpg" height="100" alt="resized image"/>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
