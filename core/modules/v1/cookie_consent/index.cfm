<cfif not isdefined('cookie.mura_consent')>
	<cfoutput>
		<cfif this.cookieConsentType eq 'drawer'>
			<script>
			Mura(function(){
					Mura('body').appendDisplayObject(
						{
							object:'cta',
							nestedobject:'cookie_consent_cta',
							type:'drawer',
							queue:false,
							cssclass:'#this.cookieConsentWrapperClass#',
							width:'#this.cookieConsentWidth#'
						}
					);
			});
			</script>
		<cfelseif this.cookieConsentType eq 'bar'>
			<script>
			Mura(function(){
					Mura('body').appendDisplayObject(
						{
							object:'cta',
							nestedobject:'cookie_consent_cta',
							type:'bar',
							width:'full',
							queue:false,
							cssclass:'#this.cookieConsentWrapperClass#',
							width:'#this.cookieConsentWidth#'
						}
					);
			});
			</script>
		</cfif>
	</cfoutput>
</cfif>
