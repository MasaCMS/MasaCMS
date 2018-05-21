<cfparam name="objectparams.type" default="bar">
<cfif not isdefined('cookie.mura_accept_cookies')>
	<cfif objectparams.type eq 'bar'>
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
	<cfelse>
		<script>
		Mura(function(){
				Mura('body').appendDisplayObject(
					{
						object:'cta',
						nestedobject:'cookie_consent_cta',
						type:'drawer',
						queue:false
					}
				);
		});
		</script>
	</cfif>
</cfif>
