<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<cfinclude template="inc/navbar.cfm" />
		<div class="container">
			<div class="row">
				<section class="content col-lg-12 col-md-12 col-sm-12 col-xs-12">
					<cfinclude template="inc/breadcrumb.cfm" />
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1,metaImageClass='thumbnail')#
					#$.dspObjects(2)#
				</section>
			</div>
			<cfinclude template="inc/footer.cfm" />
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>