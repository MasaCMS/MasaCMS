<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="oneCol depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<article>
			<nav>#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#</nav>
			#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
			#$.dspObjects(2)#
		</article>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>