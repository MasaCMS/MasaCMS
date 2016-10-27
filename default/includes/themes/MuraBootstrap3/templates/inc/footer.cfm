<cfoutput>
	<footer class="footer-wrapper">
		<div class="container">
			<div class="row footer-top">
				<div class="col-md-3">
					<h4>Follow</h4>
					<ul class="nav nav-pills nav-social">
						<li>
							<a class="github" href="https://github.com/blueriver/MuraCMS"><i class="fa fa-github"></i></a>
						</li>
						<li>
							<a class="twitter" href="https://twitter.com/muracms"><i class="fa fa-twitter"></i></a>
						</li>
						<li>
							<a class="google" href="https://groups.google.com/forum/##!forum/mura-cms-developers"><i class="fa fa-google"></i></a>
						</li>
						<li>
							<a class="linkedin" href="https://www.linkedin.com/groups/1883780"><i class="fa fa-linkedin"></i></a>
						</li>
					</ul>
				</div>

				<div class="col-md-3">
					<h4>Contact Info</h4>
					<ul class="nav nav-stacked">
						<li>
							<a href="tel:1-916-608-8608"><i class="fa fa-phone"></i> +1(916)608-8608 <strong>Local</strong></a>
						</li>
						<li>
							<a href="tel:1-800-466-7525"><i class="fa fa-phone"></i> +1(800)466-7525 <strong>Toll Free</strong></a>
						</li>
						<li>
							<a href="mailto:info@blueriver.com"><i class="fa fa-envelope"></i> info@blueriver.com</a>
						</li>
					</ul>
				</div>

				<div class="col-md-6">
					<h4>About</h4>
					<p>Mura CMS's rich feature set and powerful extensibility provides a toolkit for tackling and completing challenging Web projects, even those requiring deep integration and custom development. Our professional services team can assist your developers or lead the project from conception to delivery.</p>
				</div>
			</div>

			<div class="row footer-bottom">
				<div class="col-lg-10">
					<ul class="pull-left breadcrumb">
						<li>&copy; #esapiEncode('html', $.siteConfig('site'))# #year(now())#</li>

						<!---
							These links are dependent upon specific Pages to exist within Mura,
							and are used with the MuraBootstrap3 Bundle
							<li><a href="#$.createHref(filename='site-map')#">Site Map</a></li>
							<li><a href="#$.createHref(filename='font-awesome')#">Font Awesome</a></li>
							<li><a href="#$.createHref(filename='bootstrap')#">Bootstrap</a></li>
						--->

						<li><a href="##myModal" data-toggle="modal">Sample Modal Window</a></li>
						<li><a href="http://www.getmura.com"><i class="fa fa-plug"></i> Powered by Mura</a></li>
					</ul>
				</div>
				<cfset backToTop = '<a class="btn back-to-top" href="##"><i class="fa fa-chevron-up"></i></a>' />
				<div class="col-lg-2">
					<p class="scroll-top hidden-sm hidden-xs pull-right">#backToTop#</p>
					<p class="scroll-top visible-sm visible-xs pull-left">#backToTop#</p>
				</div>
			</div>
		</div>
	</footer>
	#$.dspThemeInclude('display_objects/examples/sampleModalWindow.cfm')#
</cfoutput>
