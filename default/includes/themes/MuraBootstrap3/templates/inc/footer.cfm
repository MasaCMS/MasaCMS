<cfoutput>
	<hr>
	<footer>
		<ul class="list-inline pull-left">
			<li>&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())#</li>
			<li><a href="#$.createHref(filename='site-map')#">Site Map</a></li>
			<li><a href="#$.createHref(filename='font-awesome')#">Font Awesome</a></li>
			<li><a href="#$.createHref(filename='bootstrap')#">Bootstrap</a></li>
			<li><a href="##myModal" data-toggle="modal">Sample Modal Window</a></li>
		</ul>
		<p class="pull-right"><a href="##">Back to top</a></p>
	</footer>
	#$.dspThemeInclude('display_objects/examples/sampleModalWindow.cfm')#
</cfoutput>