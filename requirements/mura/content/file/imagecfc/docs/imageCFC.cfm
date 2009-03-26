<cfset page_title = "ImageCFC Documentation: API Overview">
<cftry>
<cfinclude template="above.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
<h3 class="docnav"><a href="http://www.opensourcecf.com/imagecfc/index.cfm">ImageCFC</a>: Documentation</h3>
<h1>ImageCFC Properties</h1>
<table>
<tr class="header">
	<th>Property</th>
	<th>Type</th>
	<th>Access</th>
	<th>Default</th>
	<th>Description</th>
</tr>
<A name="throwOnError"></A>
<tr>
	<td>throwOnError</td>
	<td>Boolean</td>
	<td>private</td>
	<td>No</td>
	<td>When true, imageCFC methods will throw errors instead of returning an errorCode and errorMessage in the results struct.</td>
</tr>
<A name="defaultJpegCompression"></A>
<tr>
	<td>defaultJpegCompression</td>
	<td>integer</td>
	<td>private</td>
	<td>90</td>
	<td>A number that controls the jpeg compression quality, with 100 being the highest quality (least compression) and 0 being the lowest quality (most compression)</td>
</tr>
<A name="interpolation"></A>
<tr>
	<td>interpolation</td>
	<td>string</td>
	<td>private</td>
	<td>bicubic</td>
	<td><p>When performing actions that require rendering, use this interpolation method.</p>
	<p>Accepted values:  bicubic, bilinear, nearest_neighbor</p></td>
</tr>
<A name="textAntiAliasing"></A>
<tr>
	<td>textAntiAliasing</td>
	<td>boolean</td>
	<td>private</td>
	<td>Yes</td>
	<td>When true, imageCFC will anti-alias any text you add using the addText() method.</td>
</tr>
</table>
<h4>ImageCFC Public Methods</h4>
<ul>
<li><a href="getImageInfo.cfm">getImageInfo()</a>: Retrieve information about an image.</li>
<li><a href="readImage.cfm">readImage()</a>: Read an image from a file or URL.</li>
<li><a href="writeImage.cfm">writeImage()</a>: write a BufferedImage object to a file</li>
<li><a href="setOption.cfm">setOption()</a>: Set an ImageCFC option.</li>
<li><a href="getOption.cfm">getOption()</a>: Get an ImageCFC option.</li>
<li><a href="scaleWidth.cfm">scaleWidth()</a>: Resize an image to a specific width.</li>
<li><a href="scaleHeight.cfm">scaleHeight()</a>: Resize an image to a specific height.</li>
<li><a href="resize.cfm">resize()</a>: Resize an image.</li>
<li><a href="crop.cfm">crop()</a>: Crop an image.</li>
<li><a href="watermark.cfm">watermark()</a>: Watermark one image onto another.</li>
<li><a href="addText.cfm">addText()</a>: Add text to an image.</li>
<li><a href="flipHorizontal.cfm">flipHorizontal()</a>: Flip an image horizontally.</li>
<li><a href="flipVertical.cfm">flipVertical()</a>: Flip an image vertically.</li>
<li><a href="rotate.cfm">rotate()</a>: Rotate an image.</li>
<li><a href="convert.cfm">convert()</a>: Convert an image from one format to another.</li>
<li><a href="filterFastBlur.cfm">filterFastBlur()</a>: Apply an simple blur filter to an image. <b>(new in version 2.1)</b></li>
<li><a href="filterSharpen.cfm">filterSharpen()</a>: Sharpen an image. <b>(new in version 2.1)</b></li>
<li><a href="filterPosterize.cfm">filterPosterize()</a>: Apply an posterize filter to an image. <b>(new in version 2.1)</b></li>
</ul>
<cftry>
<cfinclude template="below.cfm"><cfcatch type="any"></CFCATCH>
</cftry>
