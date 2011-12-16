<cfset page_title = "ImageCFC Documentation: readImage() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.readImage()</h1>
<h4>Description</h4>
<p>readss an image from a file or URL.</p>
<h4>Returns</h4>
<p>A java BufferedImage object, suitable for passing into other imageCFC methods.</p>
<h4>Function Syntax</h4>
<p>readImage(source,forModification)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>source</td>
	<td>YES</td>
	<td>-</td>
	<td>A file path or URL to a supported image file.</td>
</tr>
<tr>
	<td>forModification</td>
	<td>NO</td>
	<td>True</td>
	<td>Will cause this method to return an error if the image cannot be manipulated.</td>
</tr>
</table>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfset img1 = imageCFC.readImage("C:\Inetpub\wwwroot\myimage.jpg")>
&lt;cfset img2 = imageCFC.readImage("http://localhost/myimage.jpg")>
&lt;cfdump var="#img1#">
&lt;cfdump var="#img2#">
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
