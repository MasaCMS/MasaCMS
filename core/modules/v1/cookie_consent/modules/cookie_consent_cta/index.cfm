<cfoutput>
	<cfparam name="objectparams.ctaid" default="#objectparams.instanceid#">
	<cfif len(m.event('accept_cookies'))>
		<cfset m.getBean('utility').setCookie(name='MURA_ACCEPT_COOKIES',value=true)>
		<script>
			Mura(function(){
					Mura('##mura-cta-#objectparams.ctaid#')
						.find('.mura-cta__item__dismiss').trigger('click');
			});
		</script>
	<cfelse>
		<form class="mura-cta__cookie_consent">
			<input type="hidden" name="accept_cookies" value="true">
			<p>
				#m.rbKey('cookie_consent_cta.statement')#
			</p> <button type="submit" class="btn btn-primary">#m.rbKey('cookie_consent_cta.gotit')#</button> #m.rbKey('cookie_consent_cta.or')# <a href="#m.createHREF(filename='privacy-statement',complete=true)#">#m.rbKey('cookie_consent_cta.moreinfo')#</a>
		</form>
	</cfif>
</cfoutput>
