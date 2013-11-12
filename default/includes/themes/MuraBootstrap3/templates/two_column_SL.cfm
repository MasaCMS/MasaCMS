<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<cfinclude template="inc/navbar.cfm" />
		<div class="container">
			<div class="row">
				<aside class="col-lg-3 col-md-3 col-sm-4 col-xs-12 sidebar">
					#$.dspObjects(1)#
				</aside><!-- /.span -->
				<section class="col-lg-9 col-md-9 col-sm-8 col-xs-12 content">
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
			</div><!--- /.row --->
			<cfinclude template="inc/footer.cfm" />
		</div><!--- /.container --->
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>