<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<div class="#$.getMBContainerClass()#">
			<header class="#$.getMBRowClass()#">
				<cfinclude template="inc/navbar.cfm">
			</header>
			<div class="#$.getMBRowClass()#">
				<section class="span12">
					<!---
						The Carousel/Slideshow
						This method can be found in the theme's contentRenderer.cfc
					--->
					#$.dspCarouselByFeedName(feedName='Slideshow', showCaption=true, cssID='myCarousel')#
				</section>
				
				<section class="span9 content">
					<!--- The content --->
					#$.dspBody(body=$.content('body'), pageTitle='', crumbList=0, showMetaImage=true)#

					<!--- Display Objects assigned to display region 2 (Main Content) --->
					#$.dspObjects(2)#
				</section>
				
				<aside class="span3">
					<!--- Display Objects assigned to display region 3 (Right Column) --->
					#$.dspObjects(3)#
				</aside>
			</div>
				<cfinclude template="inc/footer.cfm">
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>
