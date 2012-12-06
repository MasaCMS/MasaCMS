<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="#$.getMBContainerClass()#">
			<cfinclude template="inc/navbar.cfm" />
      		<div class="row-fluid">
	      		<aside class="span3">
	      		    #$.dspObjects(1)#
	      		</aside><!--/span3-->
				<section class="span6 content">
					<cfinclude template="inc/breadcrumb.cfm" />
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
			    </section><!--/span6-->
				<aside class="span3">
					#$.dspObjects(3)#
				</aside><!--/span-->
			</div><!--/row-->
			<cfinclude template="inc/footer.cfm" />
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>