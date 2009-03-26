<cfoutput>
	<div id="footer" class="clearfix">
		<p>&copy;#year(now())# #renderer.getSite().getSite()#</p>
		<!--- Sample footer navigation: --->
		<!--- <ul>
			<li class="privacy first"><a href="#application.configBean.getContext()#/#request.siteid#/index.cfm/privacy-policy">Privacy Policy</a></li>
			<li class="sitemap"><a href="#application.configBean.getContext()#/#request.siteid#/index.cfm/sitemap">Sitemap</a></li>
			<li class="rss"><a href="#application.configBean.getContext()#/#request.siteid#/index.cfm/rss">RSS</a></li>
			<li class="contact last"><a href="#application.configBean.getContext()#/#request.siteid#/index.cfm/contact">Contact</a></li>
		</ul> --->
	</div>
</cfoutput>