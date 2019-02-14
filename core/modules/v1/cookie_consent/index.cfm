<cfoutput>
	<cfparam name="objectparams.statsid" default="cookie_consent">
	<script>
		Mura(function(){
				if(!Mura.readCookie('MURA_CONSENT')){
					Mura('body').appendDisplayObject(
						{
							object:'cta',
							nestedobject:'cookie_consent_cta',
							type:'#this.cookieConsentType#',
							queue:false,
							cssclass:'#this.cookieConsentWrapperClass#',
							width:'#this.cookieConsentWidth#',
							statsid: '#esapiEncode("javascript",objectparams.statsid)#'
						}
					);
				}
		});
	</script>
</cfoutput>
