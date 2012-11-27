<cfoutput>
		<div class="container">
			<hr>
			<footer>
				<p class="pull-left">&copy; #HTMLEditFormat($.siteConfig('site'))# #year(now())#</p>
				<p class="pull-right"><a href="##">Back to top</a></p>
			</footer>
		</div><!--- /.container --->

		<!--- Twitter Bootstrap JS --->
		<script src="#$.siteConfig('themeAssetPath')#/assets/bootstrap/js/bootstrap.min.js"></script>

		<!--- CfStatic JS --->
		<cf_CacheOMatic key="globalfooterjs">
			#$.static().include('/js/theme/').renderIncludes('js')#
		</cf_CacheOMatic>

	</body>
</html>
</cfoutput>