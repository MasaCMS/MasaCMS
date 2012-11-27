<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="container-fluid">
			<div class="row-fluid">
				<cfset navbarContainerClass = 'container-fluid'>
				<cfinclude template="inc/navbar.cfm">
			</div>
      		<div class="row-fluid">
				<div class="span9 content">
					<cfinclude template="inc/breadcrumb.cfm">
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
		        </div><!-- /.span9 -->
		        <div class="span3 sidebar">
				    #$.dspObjects(3)#
				</div><!-- /.span3 -->
			</div><!-- /.row-fluid -->
			<div class="row-fluid">
				<cfinclude template="inc/footer.cfm">
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>