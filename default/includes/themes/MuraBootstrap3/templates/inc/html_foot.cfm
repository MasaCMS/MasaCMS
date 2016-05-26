<cfoutput>
		<!--- Bootstrap JavaScript --->
		<script src="#$.siteConfig('themeAssetPath')#/assets/bootstrap/js/bootstrap.min.js"></script>
    <!--- Theme JavaScript --->
    <script src="#$.siteConfig('themeAssetPath')#/js/theme/theme.min.js"></script>
	<script>
		m(function(){
			m('.mura-object').on('asyncObjectRendered',function(){
				alert(22)
			});
		})
	</script>
	</body>
</html>
</cfoutput>
