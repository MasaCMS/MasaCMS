<cfoutput>
	<cfparam name="objectparams.ctaid" default="#objectparams.instanceid#">
	<cfif len(m.event('accept_cookies'))>
		<cfset m.getBean('utility').setCookie(name='MURA_ACCEPT_COOKIES',value=true)>
		<script>
			Mura(function(){
					Mura('##mura-cta-#esapiEncode('javascript',objectparams.ctaid)#')
						.find('.mura-cta__item__dismiss').trigger('click');
			});
		</script>
	<cfelse>
		<div class="mura-cta__cookie_consent_wrapper">
			<div class="mura-cta__cookie_consent_message">
				#m.setDynamicContent(m.getBean('content').loadBy(title='Cookie Consent',type='Component').getBody())#
			</div>
			<div class="mura-cta__cookie_consent_controls">
				<form class="mura-cta__cookie_consent">
					<input type="hidden" name="accept_cookies" value="true">
					<button type="submit" class="#this.cookieConsentButtonClass# mura-cta__cookie_consent_btn">#m.rbKey('cookie_consent_cta.gotit')#</button>
				</form>
			</div>
		</div>
	</cfif>
</cfoutput>
