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
			#renderer.dspBody(body=request.contentBean.getbody(),pageTitle=request.contentBean.getTitle(),crumbList=0,showMetaImage=1)#
			#renderer.dspObjects(2)#
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>