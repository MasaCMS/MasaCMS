<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSHook($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<cfinclude template="inc/navbar.cfm" />
		<!---
			The Carousel/Slideshow
			Refer to the theme's contentRenderer.cfc for details on this method and its arguments/options
			NOTES: 
				* This theme is designed for Mura 7.0+
				* Only content items with an 'Associated Image' will be rendered
				* You can control the crop of the carousel image by using the 
				  custom defined 'carouselimage' image size // 'carouselimage'
		--->
		#$.dspCarouselByFeedName(
			feedName='Slideshow'
			, showCaption=true
			, cssID='myCarousel'
			, size='carouselimage'
			, interval=5000
			, autoStart=true
		)#

		<div class="container">
			<div class="row">
				<section class="col-md-12 content">
					<!--- 
							The Content
							See the file located under '/display_objects/page_default/index.cfm' to override body styling
					--->
					#$.dspBody(
						body=$.content('body')
						, pageTitle=''
						, crumbList=false
						, showMetaImage=false
					)#

					<hr>

					#$.dspObjects(2)#
				</section>
			</div><!--- /.row --->			
		</div><!-- /.container -->
	<cfinclude template="inc/footer.cfm" />
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>