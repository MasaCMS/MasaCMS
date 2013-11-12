<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<cfinclude template="inc/navbar.cfm" />
		<div class="container">
			<div class="row">
				<aside class="col-lg-3 col-md-3 col-sm-4 col-xs-12">
					#$.dspObjects(1)#
				</aside>
				<div class="clearfix visible-xs"></div>
				<section class="col-lg-6 col-md-6 col-sm-8 col-xs-12 content">
					<cfinclude template="inc/breadcrumb.cfm" />
					#$.dspBody(
						body=$.content('body')
						, pageTitle=$.content('title')
						, crumbList=false
						, showMetaImage=true
						, metaImageClass='thumbnail'
					)#
					#$.dspObjects(2)#
				</section>
				<aside class="col-lg-3 col-md-3 col-sm-4 col-xs-12">
					#$.dspObjects(3)#
				</aside>
			</div><!--- /.row --->
		<cfinclude template="inc/footer.cfm" />
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>