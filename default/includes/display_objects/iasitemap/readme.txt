Title: StyleMap v2
Author: Scott Jehl, http://www.scottjehl.com
Date: May 2007


Included files
------------------------------------------------------------------------------------------------
> styleMap.html: This is the HTML file that you'll edit to make your sitemap.
> css/styleMap.css: Necessary stylesheet for map viewing
> script/styleMap.js: Necessary javascript for map viewing
> images/ : Contains 3 images necessary for map viewing
> styleMap_non_javascript_version.html: This html page shows how the classes are added by javascript. Unless you need to run StyleMap without JS, you can ignore this file.

Notes
------------------------------------------------------------------------------------------------
> StyleMap is a technique used to produce visual tree structures out of an HTML unordered list. 
> Be sure to follow this basic structure of an embedded UL with each LI containing a Div and and A:
**************************************************************************************************
	<div id="contain">
		<ul id="sitemap">
			<li><div><a href="#">Home</a></div>
				<ul>
					<li><div><a href="#">About</a></div></li>
				</ul>
			</li>
		</ul>
	</div>
**************************************************************************************************


USAGE
------------------------------------------------------------------------------------------------
Free to use, please do not remove the top credits area in the various files.