<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>#getSite().getSite()# - #request.contentBean.getTitle()#</title>
		<!-- 
		Title: StyleMap v2
		Author: Scott Jehl, http://www.scottjehl.com
		Date: May 2007
		USAGE: Free to use, please do not remove this top credits area.
	 	-->
	<meta name="author" content="Scott Jehl, http://www.scottjehl.com" />

<!---	<link rel="stylesheet" href="/#request.siteid#/css/style.css" type="text/css" media="all" /> --->
	<link rel="stylesheet" type="text/css" href="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/iasitemap/css/styleMap.css" />

<!---	<script src="/#request.siteid#/js/global.js" type="text/javascript"></script> --->
<!---	<script src="/#request.siteid#/js/prototype.js" type="text/javascript"></script> --->
<!---	<script src="/#request.siteid#/js/scriptaculous/src/scriptaculous.js?load=effects" type="text/javascript"></script> --->
	<script src="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/iasitemap/script/styleMap.js" type="text/javascript" charset="utf-8"></script>

</head>
<body id="svIAsiteMap">
<!-- optional "no javascript" warning --><p id="noJS">To view this outline in map view, you must enable javascript.</p><!-- /optional "no javascript" warning -->
<h1><a href="/#request.siteid#/">#getSite().getSite()#:</a> #request.contentBean.getTitle()#</h1>
<h2>#LSDateFormat(now(),"long")# #LSTimeFormat(now(),"short")#</h2>
<div id="contain">
	<ul id="sitemap">
		<li><div><a href="#application.configBean.getContext()#/#request.siteID#/">Home</a></div>
				#createObject("component","IASitemap").init().dspNestedItems("00000000000000000000000000000000001",10,1,"orderno","asc")#	
		</li>
	</ul>
</div>
</cfoutput>

</body>
</html>