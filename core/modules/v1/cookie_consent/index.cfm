<cfif not isdefined('cookie.mura_accept_cookies')>
	<script>
	Mura(function(){
			Mura('body').appendDisplayObject(
				{
					object:'cta',
					nestedobject:'cookie_consent_cta',
					type:'bar',
					width:'full',
					queue:false
				}
			);
	});
	</script>
</cfif>
