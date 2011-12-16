<cfset page_title = "ImageCFC Documentation: getImageInfo() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.getImageInfo()</h1>
<h4>Description</h4>
<p>Get a variety of information about an image.</p>
<h4>Returns</h4>
<p>A structure containing the following fields:</p>
<table>
<tr class="header"><th>key</th><th>value</th></tr>
<tr><td>errorCode</td><td>0 for success, non-zero for failure.   Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>errorMessage</td><td>A description of the error.  Always returned, but not really used if the <a href="imageCFC.cfm#throwOnError">throwOnError</a> option is set to true.</td></tr>
<tr><td>width</td><td>the images width in pixels</td></tr>
<tr><td>height</td><td>the images height, in pixels</td></tr>
<tr><td>colorModel</td><td>a string representation of the color model</td></tr>
<tr><td>sampleModel</td><td>a string representation of the sample model</td></tr>
<tr><td>imageType</td><td>the type of image</td></tr>
<tr><td>misc</td><td>a (useless) string representation of the image object</td></tr>
</table>
<h4>Function Syntax</h4>
<p>getImageInfo(objImage,inputFile)</p>
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
</table>
<p><i>You must supply either an image object or a file path to a source image.</i></p>

<h4>Example</h4>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfset imgInfo = imageCFC.getImageInfo("", "C:\Inetpub\wwwroot\myimage.jpg")>
&lt;cfoutput>
Image Dimensions: #imgInfo.width# x #imgInfo.height#
&lt;/cfoutput>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
