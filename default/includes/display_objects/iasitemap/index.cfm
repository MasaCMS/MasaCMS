<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
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