<cfset page_title = "ImageCFC Documentation: addText() method">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>:
<A href="imageCFC.cfm">Documentation</A>:
Method Description</h3>
<h1>imageCFC.addText()</h1>
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
<p>addText(objImage,inputFile,outputFile,x,y,fontDetails,content,jpegCompression)</p>
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
	<td>x</td>
	<td>YES</td>
	<td>-</td>
	<td>X coordinate where the text is to be placed.</td>
</tr>
<tr>
	<td>y</td>
	<td>YES</td>
	<td>-</td>
	<td>Y coordinate where the text is to be placed.</td>
</tr>

<tr>
	<td>fontDetails</td>
	<td>YES</td>
	<td>-</td>
	<td>
		A struct containing font information, containing these keys:
		<ul>
			<li>fontFile (optional) - path to specific truetype font file</li>
			<li>fontName (optional) - logical java font name, one of "Serif" (default), "SansSerif", or "Monospaced".  Used when fontFile is not specified.</li>
			<li>style (optional) - string reference to a java font style constant, used only when also using the fontName attribute.  Can be "font.PLAIN", "font.BOLD", or "font.ITALIC" - probably case senstive, see Java documentation (java.awt.Font) for further details.</li>
			<li>size (optional) - Font size in points, default is "12"</li>
			<li>color - Color to be used, either an RGB value, like "ffcccc", or a named color, like "black" (default)</li>
	</ul>
	</td>
</tr>
<tr>
	<td>content</td>
	<td>YES</td>
	<td>-</td>
	<td>The string to be added to the image.</td>
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
&lt;cfset fontDetails = StructNew()>
&lt;cfset fontDetails.fontName = "Serif">
&lt;cfset fontDetails.style = "font.BOLD">
&lt;cfset fontDetails.color = "maroon">
&lt;cfset fontDetails.size = 20>

&lt;cfset results = imageCFC.addtext("", "#ExpandPath(".")#/myimage.jpg", "#ExpandPath(".")#/myimage2.jpg", 10, 10, fontDetails, "Sample Text")>

</pre>
<h4>Special Considerations</h4>
<p>When you use the addText() method with a truetype font file, you 
will find that java creates temp files somewhere on your system.
In the Linux world, it seems to be /tmp and the files are named
JF*.tmp
</p>
<p>These don't get cleaned up!!! You'll need to write some kind
of script to clean them up manually.  For example, I use
this as a cron job:
</p>
<pre>* * * * * /usr/bin/find /tmp -cmin +2 -name \*JF\*.tmp | /usr/bin/xargs /bin/rm</pre>

<p>For further discussion, see <a href="http://www.opensourcecf.com/forums/messages.cfm?threadid=C5E1D7AC-F742-E671-16AD1BD0A8BF4C87">this thread</a> in the imageCFC forums:</p>


<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
