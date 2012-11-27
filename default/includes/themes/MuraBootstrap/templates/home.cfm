<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<cfinclude template="inc/navbar.cfm">
		<div class="container">
			<div class="content">
				#$.dspBody(body=$.content('body'),pageTitle='',crumbList=0,showMetaImage=1)#
				#$.dspObjects(2)#
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/footer.cfm">
</cfoutput>