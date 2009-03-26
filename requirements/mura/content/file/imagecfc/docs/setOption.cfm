<cfset page_title = "ImageCFC Documentation: setOption() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.setOption()</h1>
<h4>Description</h4>
<p>Sets one of the ImageCFC options (see <a href="imageCFC.cfm#options">options</a></p>
<h4>Returns</h4>
<p>Nothing.</p>
<h4>Function Syntax</h4>
<p>setOption(key, val)</p>
<table>
<tr class="header"><th>Parameter</th><th>Required?</th><th>Default</th><th>Description</th></tr>
<tr>
	<td>key</td>
	<td>YES</td>
	<td>-</td>
	<td>The name of the option to be set.</td>
</tr>

<tr>
	<td>val</td>
	<td>YES</td>
	<td>-</td>
	<td>The value of the option to be set.</td>
</tr>

<h4>Example</h4>
<pre>
&lt;cfset imageCFC = createObject("component","image")>
&lt;cfset imageCFC.setOption("defaultJpegCompression","70")>
&lt;cfset imageCFC.setOption("throwOnError","Yes")>
&lt;cfset imageCFC.setOption("textAntiAliasing","No")>
&lt;cfset imageCFC.setOption("interpolation","bilinear")>
</pre>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
