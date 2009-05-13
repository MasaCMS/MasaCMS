<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#renderer.gettopid()#" class="home">
<div id="container" class="#renderer.CreateCSSid(request.contentBean.getMenuTitle())#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="primary" class="content">
			#renderer.dspObject('component','COMPONENT_ID',request.siteid)# <!--- SLIDESHOW COMPONENT --->
			#renderer.dspObject('component','COMPONENT_ID',request.siteid)# <!--- FEATURES COMPONENT --->

			#renderer.dspBody(body=request.contentBean.getbody(),pageTitle='',crumbList=0,showMetaImage=0)# <!--- OPTIONAL --->
			#renderer.dspObjects(2)# <!--- OPTIONAL --->
		</div>
		<div id="right" class="sidebar">
			<div class="promo">
				<!--- #renderer.dspObject('feed_no_summary','FEED_ID',request.siteid)# --->
				#renderer.dspObject('feed','FEED_ID',request.siteid)# <!--- 'NEWS & EVENTS' FEED --->
				<a class="more" href="">Read More</a>
			</div>
			<div class="promo">
				#renderer.dspObject('feed','FEED_ID',request.siteid)# <!--- 'FROM OUR BLOG' FEED --->
				<a href="" class="more">Read More</a>
			</div>
		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>