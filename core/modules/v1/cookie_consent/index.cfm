<cfif not isdefined('cookie.mura_consent')>
	<cfoutput>
			<script>
			Mura(function(){
					Mura('body').appendDisplayObject(
						{
							object:'cta',
							nestedobject:'cookie_consent_cta',
							type:'#this.cookieConsentType#',
							queue:false,
							cssclass:'#this.cookieConsentWrapperClass#',
							width:'#this.cookieConsentWidth#'
						}
					);
			});
			</script>
	</cfoutput>
</cfif>
