<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<div class="#$.getMBContainerClass()#">
			<div class="#$.getMBRowClass()#">
				<cfinclude template="inc/navbar.cfm">
			</div>
			<div class="content-container #$.getMBRowClass()#">
				<div class="span12 content">

					<!---
						The Carousel/Slideshow
						This method can be found in the theme's contentRenderer.cfc
					--->
					#$.dspCarouselByFeedName(feedName='Slideshow', showCaption=true, cssID='myCarousel')#

					<!--- The content --->
					#$.dspBody(body=$.content('body'), pageTitle='', crumbList=0, showMetaImage=true)#

					<!--- Display Objects assigned to display region 2 (Main Content) --->
					#$.dspObjects(2)#

				</div>
			</div>
			<div class="#$.getMBRowClass()#">
				<cfinclude template="inc/footer.cfm">
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>
