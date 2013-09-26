<cfoutput>
	<cfinclude template="inc/html_head.cfm" />
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<cfinclude template="inc/navbar.cfm" />
		<!---
			The Carousel/Slideshow
			Refer to the theme's contentRenderer.cfc for details on this method and its arguments/options
			NOTES: 
				* This theme is designed for Mura 6.1+
				* Only content items with an 'Associated Image' will be rendered
				* You can control the crop of the carousel image by using the custom defined 'carouselimage' image size // 'carouselimage'
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
				<section class="col-lg-8 col-md-8 col-sm-12 col-xs-12 content">
					<!--- The content --->
					#$.dspBody(
						body=$.content('body')
						, pageTitle=''
						, crumbList=false
						, showMetaImage=false
					)#
					<!--- Display Objects assigned to display region 2 (Main Content) --->
					#$.dspObjects(2)#
				</section>
				<aside class="col-lg-3 col-md-4 col-sm-12 col-xs-12">
					<!--- Display Objects assigned to display region 3 (Right Column) --->
					#$.dspObjects(3)#
				</aside>
			</div><!--- /.row --->
			<cfinclude template="inc/footer.cfm" />
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm" />
</cfoutput>