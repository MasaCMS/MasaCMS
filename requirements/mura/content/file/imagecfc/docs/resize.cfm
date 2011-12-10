<cfset page_title = "ImageCFC Documentation: resize() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.resize()</h1>
<h4>Description</h4>
<p>Resizes an image.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>img</td><td>A java BufferedImage object is returned if no output file is specified</td></tr>
</table>
<h4>Function Syntax</h4>
<p>resize(objImage,inputFile,outputFile,newWidth,newHeight,preserveAspect,cropToExact,jpegCompression)</p>
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
	<td>newWidth</td>
	<td>YES</td>
	<td>-</td>
	<td>Width in pixels of the resulting image.  Combine with newHeight=0 to scale the image to this specific width.</td>
</tr>
<tr>
	<td>newHeight</td>
	<td>YES</td>
	<td>-</td>
	<td>Height in pixels of the resulting image.  Combine with newWidth=0 to scale the image to this specific width.</td>
</tr>
<tr>
	<td>preserveAspect</td>
	<td>NO</td>
	<td>false</td>
	<td>Specifies whether or not to preserve the aspect ratio of the original image.  Setting this to true, when combined with a specified width and height, will scale the image to fit within the specified dimensions.  The resulting image may be smaller in width or height.</td>
</tr>
<tr>
	<td>cropToExact</td>
	<td>NO</td>
	<td>false</td>
	<td>If this is set to true AND preserveAspect is set to true, the resized image
	is cropped to fit exactly within the specified dimensions.  If preserveAspect is not true, this has no affect.</td>
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
&lt;cfset imgInfo = imageCFC.resize("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage2.jpg",100,200)>
&lt;img src="myimage2.jpg" width="100" height="200" alt="resized image to a specific width and height."/>

&lt;cfset imgInfo = imageCFC.resize("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage3.jpg",100,200,"true")>
&lt;img src="myimage3.jpg" alt="resized image guaranteed to fit within a 100x200 space."/>

&lt;cfset imgInfo = imageCFC.resize("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage4.jpg",100,0)>
&lt;img src="myimage4.jpg" width="100" alt="resized image scaled to 100px wide."/>

&lt;cfset imgInfo = imageCFC.resize("", "C:\Inetpub\wwwroot\myimage.jpg", "C:\Inetpub\wwwroot\myimage5.jpg",0,100)>
&lt;img src="myimage5.jpg" height="100" alt="resized image scaled to 100px high."/>

</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
