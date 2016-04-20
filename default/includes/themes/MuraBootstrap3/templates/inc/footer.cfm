<cfoutput>
	<hr>
	<footer>
		<ul class="col-lg-10 list-inline pull-left breadcrumb">
			<li>&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())#</li>
		</ul>
		<cfset backToTop = '<a class="btn" href="##"><i class="fa fa-arrow-circle-up"></i> Back to top</a>' />
		<div class="col-lg-2 pull-right">
			<p class="hidden-sm hidden-xs pull-right">#backToTop#</p>
			<p class="visible-sm visible-xs pull-left">#backToTop#</p>
		</div>
	</footer>
</cfoutput>