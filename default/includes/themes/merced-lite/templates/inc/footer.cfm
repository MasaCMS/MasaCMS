<cfoutput>
	<div id="footer">
		<div class="wrap clearfix">
			<ul class="navUtility">
				<li><a href="">About Us</a></li>
				<li><a href="">Products</a></li>
				<li><a href="">Services</a></li>
				<li class="last"><a href="">Contact Us</a></li>
			</ul>
			<p>&copy;#year(now())# #HTMLEditFormat($.siteConfig('site'))#</p>
		</div>
	</div>
</cfoutput>