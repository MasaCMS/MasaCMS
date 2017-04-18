<cfscript>
    oauthClient=m.getBean('oauthClient').loadBy(clientid=m.event('client_id'),client_secret=m.event('client_secret'));
</cfscript>

<cfif not oauthClient.exists()>
    <div class="alert alert-danger">Invalid web service.</div>
<cfelseif not oauthClient.isValidRedirectURI(m.event('redirect_uri'))>
    <div class="alert alert-danger">Invalid redirect_uri variable.</div>
<cfelseif m.event('grant_type') neq oauthClient.getGrantType()>
    <div class="alert alert-danger">Invalid grant_type variable.</div>
<cfelse>
    <cfoutput>
        <cfif len(m.event('accept')) and isBoolean(m.event('accept')) and m.validateCSRFTokens(context=oauthClient.getClientID())>
            <cfscript>
                if(m.event('accept')){
                    if(find(m.event('redirect_uri'),'?')){
                        delim="&";
                    } else {
                        delim="?";
                    }

                    token=oauthClient.generateToken(granttype='authorization_code',userid=m.currentUser('userid'));

                    m.redirect(m.event('redirect_uri') & delim & 'code=' & esapiEncode('url',token.get('accessCode')) & "&state=" & esapiEncode('url',m.event('state')));
                } else {
                    m.redirect(m.event('redirect_uri'));
                }
            </cfscript>
        <cfelse>
            <form id="accept-app-form">
                <p><strong>#esapiEncode('html',oauthClient.getName())#</strong> would like to your account.</p>
                <button type="button" class="btn accept-app" value="true">Yes</button><button type="button" class="btn accept-app" value="true">No</button>
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
