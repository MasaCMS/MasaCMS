<cfset page_title = "ImageCFC Documentation: writeImage() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.writeImage()</h1>
<h4>Description</h4>
<p>Writes a java BufferedImage object to the file system.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
</table>
<h4>Function Syntax</h4>
<p>writeImage(outputFile, objImage, jpegCompression)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>outputFile</td>
	<td>YES</td>
	<td>-</td>
	<td>File path to write the output.</td>
</tr>

<tr>
	<td>objImage</td>
	<td>YES</td>
	<td>-</td>
	<td>A java image object.</td>
</tr>

<tr>
	<td>jpegCompression</td>
	<td>NO</td>
	<td><a href="imageCFC.cfm#defaultJpegCompression">defaultJpegCompression</a></td>
	<td>jpeg compression quality to use if writing a jpeg file.  0-100.  100 is the highest quality.</td>
</tr>
</table>
<h4>Example</h4>
<p>The following example reads an image from a url and saves it locally to disk using the readImage() and writeImage() methods.</p>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfset img = imageCFC.readImage("http://www.somedomain.com/myimage.jpg")>
&lt;cfset results = imageCFC.writeImage(img, "C:\Inetpub\wwwroot\myimage.jpg")>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
