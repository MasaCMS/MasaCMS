<cfoutput>
		<!--- Twitter Bootstrap JS --->
		<script src="#$.siteConfig('themeAssetPath')#/assets/bootstrap/js/bootstrap.min.js"></script>

		<!--- CfStatic JS --->
		<cf_CacheOMatic key="globalfooterjs">
			#$.static().include('/js/theme/').renderIncludes('js')#
		</cf_CacheOMatic>

	</body>
</html>
</cfoutput>