<cfif not isdefined('cookie.mura_accept_cookies')>
	<cfset cookieConsentComponent=m.getBean('content').loadBy(title='Cookie Consent',type='Component')>
	<cfif cookieConsentComponent.exists()>
		<cfif this.cookieConsentType eq 'drawer'>
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
		<cfelse>
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
	</cfif>
</cfif>
