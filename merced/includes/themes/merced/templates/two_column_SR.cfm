<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="twoColSR depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="primary" class="article">
			#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#
			#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
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