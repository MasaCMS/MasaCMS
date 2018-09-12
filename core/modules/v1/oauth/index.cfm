<cfif not m.currentUser().isLoggedIn() and not len(m.event('returnURL'))>
  <cfset m.redirect(location="./?display=login&returnURL=#esapiEncode('url',m.getCurrentURL())#",statuscode=302)>
<cfelse>
  <cfscript>
      if(m.event('grant_type')=='implicit'){
        oauthClient=m.getBean('oauthClient').loadBy(clientid=m.event('client_id'));
      } else {
        oauthClient=m.getBean('oauthClient').loadBy(clientid=m.event('client_id'),client_secret=m.event('client_secret'));
      }

      if(m.event('response_type') eq 'code'){
        m.event('grant_type','authorization_code');
      } else if(m.event('response_type') eq 'token'){
        m.event('grant_type','implicit');
      }

      request.cacheItem=false;
  </cfscript>

  <cfif not oauthClient.exists()>
      <div class="alert alert-danger">Invalid web service.</div>
  <cfelseif not oauthClient.isValidRedirectURI(m.event('redirect_uri'))>
      <div class="alert alert-danger">Invalid redirect_uri variable.</div>
  <cfelseif m.event('grant_type') neq oauthClient.getGrantType()>
      <div class="alert alert-danger">Invalid grant_type variable.</div>
  <cfelse>
      <cfoutput>
          <cfif len(m.event('accept'))
              and isBoolean(m.event('accept'))
              and m.validateCSRFTokens(context=oauthClient.getClientID())
              and oauthClient.exists()
              and oauthClient.isValidRedirectURI(m.event('redirect_uri'))
              and m.event('grant_type') eq oauthClient.getGrantType()
              and (
                oauthClient.getGrantType() eq 'implicit'
                or oauthClient.getGrantType() eq 'authorization_code'
              )>
              <cfscript>
                  if(m.event('accept')){
                      if(find(m.event('redirect_uri'),'?')){
                          delim="&";
                      } else {
                          delim="?";
                      }

                      token=oauthClient.generateToken(granttype=m.event('grant_type'),userid=m.currentUser('userid'));

                      if(m.event('grant_type') eq 'implicit'){
                          m.redirect(m.event('redirect_uri') & delim & 'token_type=Bearer&access_token=' & esapiEncode('url',token.get('token')) & '&expires_in=' & esapiEncode('url',token.getExpiresIn()) & "&state=" & esapiEncode('url',m.event('state')));
                      } else {
                          m.redirect(m.event('redirect_uri') & delim & 'code=' & esapiEncode('url',token.get('accessCode')) & "&state=" & esapiEncode('url',m.event('state')));
                      }
                  } else {
                      m.redirect(m.event('redirect_uri'));
                  }
              </cfscript>
          <cfelse>
              <form id="accept-app-form">
                  <p><strong>"#esapiEncode('html',oauthClient.getName())#"</strong> would like to access information about your account.</p>
                  <button type="button" class="btn accept-app" value="true">Yes</button>&nbsp;<button type="button" class="btn accept-app" value="false">No</button>
                  #variables.m.renderCSRFTokens(format='form',context=oauthClient.getClientID())#
                  <input type="hidden" name="client_id" value="#esapiEncode('html_attr',oauthClient.getClientID())#"/>
                  <input type="hidden" name="client_secret" value="#esapiEncode('html_attr',oauthClient.getClientSecret())#"/>
                  <input type="hidden" name="redirect_uri" value="#esapiEncode('html_attr',m.event('redirect_uri'))#">
                  <input type="hidden" name="accept" value="false">
              </form>

              <script>
                  Mura(function(m){
                      m('.accept-app').click(function(){
                          m('input[name="accept"]').val(m(this).val());
                          m('##accept-app-form').trigger('submit');
                      })
                  });
              </script>
          </cfif>
      </cfoutput>
  </cfif>
</cfif>
<cfset request.cacheItem=false>
