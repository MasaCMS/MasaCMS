<cfoutput>
		<hr>
		<footer>
			<!--- <p class="pull-left">&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())#</p> --->

			<ul class="breadcrumb pull-left">
				<li>&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())# <span class="divider">|</span></li>
				<li><a href="#$.createHref(filename='privacy')#">Privacy</a> <span class="divider">|</span></li>
				<li><a href="#$.createHref(filename='site-map')#">Site Map</a>  <span class="divider">|</span></li>
				<li><a href="##myModal" data-toggle="modal">Sample Modal Window</a></li>
			</ul>

			<p class="pull-right"><a href="##">Back to top</a></p>
		</footer>
	#$.dspThemeInclude('display_objects/sampleModalWindow.cfm')#
</cfoutput>