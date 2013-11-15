<cfoutput>
	<hr>
	<footer>
		<div class="col-lg-10">
			<ul class="list-inline pull-left breadcrumb">
				<li>&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())#</li>
				<li><a href="#$.createHref(filename='site-map')#">Site Map</a></li>
				<li><a href="#$.createHref(filename='font-awesome')#">Font Awesome</a></li>
				<li><a href="#$.createHref(filename='bootstrap')#">Bootstrap</a></li>
				<li><a href="##myModal" data-toggle="modal">Sample Modal Window</a></li>
			</ul>
		</div>
		<cfset backToTop = '<a class="btn" href="##"><i class="fa fa-arrow-circle-up"></i> Back to top</a>' />
		<div class="col-lg-2">
			<p class="hidden-sm hidden-xs pull-right">#backToTop#</p>
			<p class="visible-sm visible-xs pull-left">#backToTop#</p>
		</div>
	</footer>
	#$.dspThemeInclude('display_objects/examples/sampleModalWindow.cfm')#
</cfoutput>