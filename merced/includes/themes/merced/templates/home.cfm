<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="home">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="primary" class="article">
			#$.dspBody(body=$.content('body'),pageTitle='',crumbList=0,showMetaImage=0)#
			#$.dspObjects(2)#
		</div>
		<div id="right" class="aside">
		#$.dspObjects(3)#
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>