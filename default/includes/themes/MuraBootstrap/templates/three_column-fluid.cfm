<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<cfinclude template="inc/navbar.cfm">
		<div class="container">
      		<div class="row-fluid">
	      		<div class="span3">
	      		    #$.dspObjects(1)#
	      		</div><!--/span3-->
				<div class="span6 content">
					<cfinclude template="inc/breadcrumb.cfm">
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
		        </div><!--/span6-->
		        <div class="span3">
				    #$.dspObjects(3)#
				</div><!--/span-->
			</div><!--/row-->
		<!-- /.container -->
	<cfinclude template="inc/footer.cfm">
</cfoutput>


