<cfset page_title = "ImageCFC Documentation: getOption() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.getOption()</h1>
<h4>Description</h4>
<p>Retrieve one of the ImageCFC options (see <a href="imageCFC.cfm#options">options</a></p>
<h4>Returns</h4>
<p>A string value</p>
<h4>Function Syntax</h4>
<p>getOption(key)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>key</td>
	<td>YES</td>
	<td>-</td>
	<td>The name of the option to be retrieved.</td>
</tr>

</table>
<h4>Example</h4>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfoutput>Default Jpeg Compression: #imageCFC.getOption("defaultJpegCompression")#&lt;/cfoutput>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
