<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="#$.getMBContainerClass()#">
			<header class="#$.getMBRowClass()#">
				<cfinclude template="inc/navbar.cfm">
			</header>
      		<div class="#$.getMBRowClass()#">
				<section class="span9 content">
					<cfinclude template="inc/breadcrumb.cfm">
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
		        </section><!-- /.span -->
		        <aside class="span3 sidebar">
				    #$.dspObjects(3)#
				</aside><!-- /.span -->
			</div><!-- /.row -->
			<cfinclude template="inc/footer.cfm">
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>