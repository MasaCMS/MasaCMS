<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="container">
			<div class="row">
				<cfinclude template="inc/navbar.cfm">
			</div>
      		<div class="row">
	      		<div class="span3">
	      		    #$.dspObjects(1)#
	      		</div><!--/span3-->
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
			<div class="row">
				<cfinclude template="inc/footer.cfm">
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>