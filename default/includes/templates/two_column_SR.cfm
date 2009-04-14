<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#renderer.gettopid()#" class="twoColSR">
<div id="container" class="#renderer.CreateCSSid(request.contentBean.getMenuTitle())#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="primary" class="content">
			#renderer.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#
			#renderer.dspBody(body=request.contentBean.getbody(),pageTitle=request.contentBean.getTitle(),crumbList=0,showMetaImage=0)#
			#renderer.dspObjects(2)#
		</div>
		<div id="right" class="sidebar">
			#renderer.dspObjects(3)#
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>