<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<cfinclude template="inc/navbar.cfm">
		<div class="container">
      		<div class="row">
	      		<div class="span3">
	      		    #$.dspObjects(1)#
	      		</div><!--/span4-->
				<div class="span6">
					<div class="content">
						<cfinclude template="inc/breadcrumb.cfm">
						#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
						#$.dspObjects(2)#
					</div>
			    </div><!--/span6-->
				<div class="span3">
					#$.dspObjects(3)#
				</div><!--/span-->
			</div><!--/row-->
		<!-- /.container -->
	<cfinclude template="inc/footer.cfm">
</cfoutput>