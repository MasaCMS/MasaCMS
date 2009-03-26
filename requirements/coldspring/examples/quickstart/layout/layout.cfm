<cfif thisTag.executionMode eq "start">
<cfparam name="attributes.section" default="home" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
Copyright: Daemon Pty Limited 2006, http://www.daemon.com.au
Community: Mollio http://www.mollio.org $
License: Released Under the "Common Public License 1.0", 
http://www.opensource.org/licenses/cpl.php
License: Released Under the "Creative Commons License", 
http://creativecommons.org/licenses/by/2.5/
License: Released Under the "GNU Creative Commons License", 
http://creativecommons.org/licenses/GPL/2.0/
-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ColdSpring Quickstart Guide and Examples</title>
<link rel="stylesheet" type="text/css" href="css/main.css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/print.css" media="print" />
<!--[if lte IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6_or_less.css" />
<![endif]-->
<script type="text/javascript" src="/coldspring/examples/quickstart/js/common.js"></script>

<!-- Include the SyntaxHighlighter stylesheet -->
<style type="text/css" media="screen">@import url("/coldspring/examples/quickstart/js/syntaxhighlighter/styles/syntaxHighlighter.css");</style>
<!-- Include the core SyntaxHighlighter library -->
<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shCore.js"></script>

<script language="javascript">
window.onload = function () {
 // Set the path to the flash component to enable 'copy to clipboard' in firefox
 dp.SyntaxHighlighter.ClipboardSwf = '/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/clipboard.swf';
 // Highlight page elements with the name "code"
 // For configuration options see http://code.google.com/p/syntaxhighlighter/wiki/HighlightAll
 dp.SyntaxHighlighter.HighlightAll('code', true, true, false, 1, false);
}
</script>

<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shBrushCss.js"></script>
<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shBrushJScript.js"></script>
<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shBrushSql.js"></script>
<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shBrushXml.js"></script>
<script language="javascript" src="/coldspring/examples/quickstart/js/syntaxhighlighter/scripts/shBrushColdFusion.js"></script>

</head>
<body id="type-a">
<div id="wrap">

	<div id="header">
		<div id="site-name" style="margin-bottom:10px">ColdSpring Quickstart Guide And Examples</div>
		<div id="search">
		</div>
		<ul id="nav">
		<li <cfif attributes.section eq "home">class="first active"<cfelse>class="first"</cfif>><a href="index.cfm?page=home">Home</a></li>
		<li <cfif attributes.section eq "intro">class="active"</cfif>><a href="index.cfm?page=intro">ColdSpring in 5 Minutes</a></li>
		<li <cfif ListFindNoCase('advanced,constructor,beanproperties,dynamicproperties,parentbeans,singletons,factory', attributes.section)>class="active"</cfif>><a href="index.cfm?page=advanced">More Advanced</a>
			<ul>
			<li <cfif attributes.section eq "constructor">class="first active"<cfelse>class="first"</cfif>><a href="index.cfm?page=constructor">Constructor Arguments</a></li>
			<li <cfif attributes.section eq "beanproperties">class="active"</cfif>><a href="index.cfm?page=beanproperties">Bean Properties</a></li>
			<li <cfif attributes.section eq "dynamicproperties">class="active"</cfif>><a href="index.cfm?page=dynamicproperties">Dynamic Properties</a></li>
			<li <cfif attributes.section eq "parentbeans">class="active"</cfif>><a href="index.cfm?page=parentbeans">Parent Beans</a></li>
			<li <cfif attributes.section eq "singletons">class="active"</cfif>><a href="index.cfm?page=singletons">Singletons vs. Transients</a></li>
			<li <cfif attributes.section eq "factory">class="last active"<cfelse>class="last"</cfif>><a href="index.cfm?page=factory">Factory Beans</a></li>
			</ul>
		</li>
		<li <cfif attributes.section eq "aop">class="active"</cfif>><a href="index.cfm?page=aop">AOP Examples</a></li>
		<li <cfif attributes.section eq "remote">class="active"</cfif>><a href="index.cfm?page=remote">Remote Proxies</a></li>
		<li <cfif attributes.section eq "extensions">class="active"</cfif>><a href="index.cfm?page=extensions">Extensions</a></li>
		<li <cfif attributes.section eq "resources">class="last active"<cfelse>class="last"</cfif>><a href="index.cfm?page=resources">Additional Resources</a></li>
		</ul>
	</div>
	
	<div id="content-wrap">
	
		<div id="content">
			<!--- 
			<div id="breadcrumb">
			<a href="homepage.cfm">Home</a> / <a href="devtodo">Section Name</a> / <strong>Page Name</strong>			
			</div> 
			--->
<cfelse>
	<cfif StructKeyExists(attributes, 'showCSS')>
			<h1>Heading 1 Consect etuer adipisci ngon.</h1>
			<h2>Heading 2 Consect etuer adipisci ngon.</h2>
			<h3>Heading 3 Consect etuer adipisci ngon.</h3>
			<h4>Heading 4 Consect etuer adipisci ngon.</h4>
			<h5>Heading 5 Consect etuer adipisci ngon.</h5>
			<h6>Heading 6 Consect etuer adipisci ngon.</h6>

			<hr />
			
			<p>A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, </p>
			
			<hr />
			
			<p class="highlight">A paragraph of text with class="highlight", A paragraph of text with class="highlight", A paragraph of text with class="highlight", A paragraph of text with class="highlight", A paragraph of text with class="highlight", </p>
			
			<hr />
			
			<p class="subdued">A paragraph of text with class="subdued", A paragraph of text with class="subdued", A paragraph of text with class="subdued", A paragraph of text with class="subdued", A paragraph of text with class="subdued", </p>
			
			<hr />
			
			<p class="error">A paragraph of text with class="error", A paragraph of text with class="error", A paragraph of text with class="error", A paragraph of text with class="error", A paragraph of text with class="error", </p>
			
			<hr />
			
			<p class="success">A paragraph of text with class="success", A paragraph of text with class="success", A paragraph of text with class="success", A paragraph of text with class="success", A paragraph of text with class="success", </p>
			
			<hr />
			
			<p class="caption">A paragraph of text with class="caption", A paragraph of text with class="caption", A paragraph of text with class="caption", A paragraph of text with class="caption", A paragraph of text with class="caption", </p>
			
			<hr />
			
			<p><small>A paragraph of text with the text with &lt;small&gt; tags, A paragraph of text with the text with &lt;small&gt; tags, A paragraph of text with the text with &lt;small&gt; tags, A paragraph of text with the text with &lt;small&gt; tags, A paragraph of text with the text with &lt;small&gt; tags, </small></p>
			
			<hr />
			
			<p><em>A paragraph of text with the text with &lt;em&gt; tags, A paragraph of text with the text with</em></p>
			
			<hr />
			
			<p><strong>A paragraph of text with the text with &lt;strong&gt; tags, A paragraph of text with the text with &lt;strong&gt; tags, A paragraph of text with the text with &lt;strong&gt; tags, A paragraph of text with the text with &lt;strong&gt; tags, A paragraph of text with the text with &lt;strong&gt; tags, </strong></p>
			
			<hr />
			
			<div class="featurebox"><h3>A h3 level heading inside a "featurebox" div</h3><p>A normal paragraph of text within a div with a class="featurebox", A normal paragraph of text within a div with a class="featurebox", A normal paragraph of text within a div with a class="featurebox", A normal paragraph of text within a div with a class="featurebox", A normal paragraph of text within a div with a class="featurebox", A normal paragraph of text within a div with a class="featurebox" <a href="devtodo" class="morelink" title="A h3 level heading inside a featurebox div">More <span>about: A h3 level heading inside a featurebox div</span></a></p></div>
			
			<hr />
			
			<div class="featurebox2"><h3>A h3 level heading inside a "featurebox2" div</h3><p>A normal paragraph of text within a div with a class="featurebox2", A normal paragraph of text within a div with a class="featurebox2", A normal paragraph of text within a div with a class="featurebox2", A normal paragraph of text within a div with a class="featurebox2", A normal paragraph of text within a div with a class="featurebox2", A normal paragraph of text within a div with a class="featurebox2" <a href="devtodo" class="morelink" title="A h3 level heading inside a featurebox2 div">More <span>about: A h3 level heading inside a featurebox2 div</span></a></p></div>
			
			<hr />
			
			<ul>
			<li><a href="devtodo">A list of links</a></li>
			<li><a href="devtodo">A list of links</a></li>
			<li><a href="devtodo">A list of links</a></li>
			</ul>
			
			<hr />
			
			<p>A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, A normal paragraph of text, </p>
			<ul class="related">
			<li><a href="devtodo">A list of related links</a></li>
			<li><a href="devtodo">A list of related links</a></li>
			<li><a href="devtodo">A list of related links</a></li>
			</ul>
			
			<hr />
			
			<ul>
			<li>An unordered list</li>
			<li>An unordered list</li>
			<li>An unordered list</li>
			</ul>
			
			<hr />
			
			<ol>
			<li>An ordered list</li>
			<li>An ordered list</li>
			<li>An ordered list</li>
			</ol>
			
			<hr />
			
			<dl>
			<dt>A definition list - and this is the dt</dt>
			<dd>A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, </dd>
			<dt>A definition list - and this is the dt</dt>
			<dd>A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, A definition list - and this is the dd, </dd>
			</dl>
			
			<hr />
			
			<h4><span class="date">29 July 2005</span> Headline and associate teaser</h4>
			<p>Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Donec pharetra. <a href="devtodo" class="morelink" title="Headline and associate teaser">More <span>about: Headline and associate teaser</span></a></p>
			
			<h4><span class="date">29 July 2005</span> Headline and associate teaser</h4>
			<p>Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Donec pharetra. <a href="devtodo" class="morelink" title="Headline and associate teaser">More <span>about: Headline and associate teaser</span></a></p>
			
			<hr />
			
			<h4><span class="date">29 July 2005</span> Headline and associate teaser and thumbnail</h4>
			<p><span class="thumbnail"><a href="devtodo"><img src="images/thumb_100wide.gif" alt="Demo" width="100" height="75" /></a></span>Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Donec pharetra. <a href="devtodo" class="morelink" title="Headline and associate teaser">More <span>about: Headline and associate teaser</span></a></p>
			
			<hr />
			
			<h4><span class="date">29 July 2005</span> Headline and associate teaser and thumbnail</h4>
			<p><span class="thumbnail"><a href="devtodo"><img src="images/thumb_100wide.gif" alt="Demo" width="100" height="75" /></a></span>Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Lorem ipsum dolor sit amsum dolor sit amet, consectetet, consectetuer adipiscing elit. Donec pharetra. <a href="devtodo" class="morelink" title="Headline and associate teaser">More <span>about: Headline and associate teaser</span></a></p>
			
			<hr />
			
			<div class="pagination">
			<p><span><strong>Previous</strong></span> <span>1</span> <a href="devtodo">2</a> <a href="devtodo">3</a> <a href="devtodo">4</a> <a href="devtodo">5</a> <a href="devtodo"><strong>Next</strong></a></p>
			<h4>Page 1 of 5</h4>
			</div>
			
			<hr />
			
			<h1>Search Results</h1>
			
			<div id="resultslist-wrap">
				<ol>
				<li>
					<dl>
					<dt><a href="devtodo">Fringilla tortor. Sed ullamcorper imperdiet metus.</a></dt>
					<dd class="desc">Maecenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris at enim. Ut vestibulum erat at tellus.</dd>
					<dd class="filetype">HTML</dd>
					<dd class="date">22 April 2005</dd>
					</dl>
				</li>
				<li>
					<dl>
					<dt><a href="devtodo">Fringilla tortor. Sed ullamcorper imperdiet metus.</a></dt>
					<dd class="desc">Maecenas nec ante vitae turpis intecenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris cenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris cenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris cenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris rdum placerat. Duis in nisi. Mauris at enim. Ut vestibulum erat at tellus.</dd>
					<dd class="filetype">HTML</dd>
					<dd class="date">22 April 2005</dd>
					</dl>
				</li>
				<li>
					<dl>
					<dt><a href="devtodo">Fringilla tortor. Sed ullamcorper imperdiet metus.</a></dt>
					<dd class="desc">Maecenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris at enim. Ut vestibulum erat at tellus.</dd>
					<dd class="filetype">PDF</dd>
					<dd class="date">22 April 2005</dd>
					</dl>
				</li>
				<li>
					<dl>
					<dt><a href="devtodo">Fringilla tortor. Sed ullamcorper imperdiet metus.</a></dt>
					<dd class="desc">Maecenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris cenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris cenas nec ante vitae turpis interdum placerat. Duis in nisi. Mauris at enim. Ut vestibulum erat at tellus.</dd>
					<dd class="filetype">WORD</dd>
					<dd class="date">22 April 2005</dd>
					</dl>
				</li>
				</ol>
			</div>
			
			<hr />
			
			<table class="table1">
			<thead>
				<tr>
				<th colspan="3">Table Heading</th>
				</tr>
			</thead>
			<tbody>
				<tr>
				<th>Col 1</th>
				<th>Col 2</th>
				<th>Col 3</th>
				</tr>
				<tr>
				<th class="sub">Sub head 1</th>
				<td>209385</td>
				<td>45</td>
				</tr>
				<tr>
				<th class="sub">Sub head 2</th>
				<td>4577</td>
				<td>22</td>
				</tr>
				<tr>
				<th class="sub">Sub head 3</th>
				<td>69765</td>
				<td>75</td>
				</tr>
			</tbody>
			</table>
			
			<hr />
			
			<table class="table1 calendar">
			<thead>
				<tr>
				<th colspan="7">October</th>
				</tr>
			</thead>
			<tbody>
				<tr>
				<th>S</th>
				<th>M</th>
				<th>T</th>
				<th>W</th>
				<th>T</th>
				<th>F</th>
				<th>S</th>
				</tr>
				<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
				</tr>
				<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
				</tr>
				<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
				</tr>
				<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
				</tr>
			</tbody>
			</table>
			
			<hr />
			
			<form action="forms.html" method="post" class="f-wrap-1">
			
			<div class="req"><b>*</b> Indicates required field</div>
			
			<fieldset>
			
			<h3>Form title here</h3>
			
			<label for="firstname"><b><span class="req">*</span>First name:</b>
			<input id="firstname" name="firstname" type="text" class="f-name" tabindex="1" /><br />
			</label>
			
			<label for="lastname"><b><span class="req">*</span>Last name:</b>
			<input id="lastname" name="lastname" type="text" class="f-name" tabindex="2" /><br />
			</label>
			
			<label for="emailaddress"><b><span class="req">*</span>Email Address:</b>
			<input id="emailaddress" name="emailaddress" type="text" class="f-email" tabindex="3" /><br />
			</label>
			
			<label for="enquiry"><b>Enquiry Type:</b>
			<select id="enquiry" name="enquiry" tabindex="4">
			<option>Select...</option>
			<option>c nulla. Fusce tincidu</option>
			<option>Maecenas digniss</option>
			<option>tincidunt arcu eget sapien</option>
			</select>
			<br />
			</label>
			
			<fieldset class="f-checkbox-wrap">
			
			<b>Colour:</b>
			
				<fieldset>
				
				<label for="blue">
				<input id="blue" type="checkbox" name="checkbox" value="checkbox" class="f-checkbox" tabindex="5" />
				sit amet, consectetu</label>
				
				<label for="green">
				<input id="green" type="checkbox" name="checkbox2" value="checkbox" class="f-checkbox" tabindex="6" />
				c nulla. Fusce tincidu</label>
				
				<label for="yellow">
				<input id="yellow" type="checkbox" name="checkbox3" value="checkbox" class="f-checkbox" tabindex="7" />
				tincidunt arcu eget </label>
				</fieldset>
				
			</fieldset> 
			
			<fieldset class="f-radio-wrap">
		
			<b>Country:</b>
			
				<fieldset>
				
				<label for="australia">
				<input id="australia" type="radio" name="radio" value="Australia" class="f-radio" tabindex="8" />
				Australia</label>
				
				<label for="newzealand">
				<input id="newzealand" type="radio" name="radio" value="New Zealand" class="f-radio" tabindex="9" />
				New Zealand</label>
				
				<label for="antarctica">
				<input id="antarctica" type="radio" name="radio" value="Antarctica" class="f-radio" tabindex="10" />
				Antarctica</label>
	
				</fieldset>
			
			</fieldset>
			
			<label for="comments"><b>Comments:</b>
			<textarea id="comments" name="comments" class="f-comments" rows="6" cols="20" tabindex="11"></textarea><br />
			</label>
			
			<div class="f-submit-wrap">
			<input type="submit" value="Submit" class="f-submit" tabindex="12" /><br />
			</div>
			</fieldset>
			</form>
		</cfif>
			
			<div id="footer">
			<p><a href="http://www.mollio.org/">Layout thanks to the Mollio project from Daemon</a></p>
			</div>
			
		</div>
		
	</div>
	
</div>
</body>
</html>
</cfif>