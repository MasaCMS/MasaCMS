<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#" data-spy="scroll" data-target=".subnav" data-offset="50">
		<cfinclude template="inc/navbar.cfm">
		<div class="container">
			<div class="content row">
			
			<cfset feed=$.getBean("feed").loadBy(name="Slideshow")>
			<cfset iterator=feed.getIterator()>
			<cfif iterator.hasNext()>
			<cfoutput>
			<!--- Slideshow hard-coded below, but the MuraBootStrap Carousel plugin can be used as well --->
			<div id="myCarousel" class="carousel slide" style="height:400px; width:1000px;">
               <div class="carousel-inner">
               <cfloop condition="iterator.hasNext()">
	               <cfset item=iterator.next()>
               	<div class="item">
                   <img src="#item.getImageURL(width=1000,height=400)#" alt="#HTMLEditFormat(item.getTitle())#">
                   <div class="carousel-caption">
                     <h4><a href="#item.getURL()#">#HTMLEditFormat(item.getTitle())#</a></h4>
                     <p>#item.getSummary()#</p>
                   </div>
                 </div>
               </cfloop>
                 </div>
                 <a class="left carousel-control" href="##myCarousel" data-slide="prev">&lsaquo;</a>
                 <a class="right carousel-control" href="##myCarousel" data-slide="next">&rsaquo;</a>
            </div>
			</cfoutput>
			<cfelse>
				<p class=”notice”>Your feed has no items.</p>
			</cfif>
				#$.dspBody(body=$.content('body'),pageTitle='',crumbList=0,showMetaImage=1)#
				#$.dspObjects(2)#
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/footer.cfm">
</cfoutput>
