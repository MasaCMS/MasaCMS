<cfoutput>
	<footer>
		<div class="wrap clearfix">
			<ul class="navUtility">
				<li><a href="#$.createHREF(filename='about-us')#">About Us</a></li>
				<li><a href="#$.createHREF(filename='news')#">News</a></li>
				<li><a href="#$.createHREF(filename='blog')#">Blog</a></li>
				<li><a href="#$.createHREF(filename='mura')#">Mura</a></li>
				<li><a href="#$.createHREF(filename='contact')#">Contact</a></li>
				<li class="last"><a href="./?mobileFormat=true">#$.rbKey("mobile.mobileversion")#</a></li>
			</ul>
			<p>&copy;#year(now())# #HTMLEditFormat($.siteConfig('site'))#</p>
		</div>
	</footer>
	<cf_CacheOMatic key="globalfooterjs">
	#$.static()
		.include("/js/ie/lte7/roundies/")
		.renderIncludes("js")#
	</cf_CacheOMatic>	
</cfoutput>