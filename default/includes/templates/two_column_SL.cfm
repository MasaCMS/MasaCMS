<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#renderer.gettopid()#" class="twoColSL">
<div id="container" class="#renderer.CreateCSSid(request.contentBean.getMenuTitle())#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="left" class="sidebar">
			#renderer.dspObjects(1)#
		</div>
		<div id="primary" class="content">
			#renderer.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#
			#renderer.dspBody(request.contentBean.getbody(),request.contentBean.gettitle(),0)#
			#renderer.dspObjects(2)#
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>