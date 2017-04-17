<cfscript>
    oauthClient=m.getBean('oauthClient').loadBy(clientid=m.event('client_id'),client_secret=m.event('client_secret'));
</cfscript>

<cfif not oauthClient.exists()>
    <div class="alert alert-error">Invalid web service.</div>
<cfelseif not oauthClient.isValidRedirectURI(m.event('redirect_uri'))>
    <div class="alert alert-error">Invalid redirect_uri variable.</div>
<cfelseif m.event('grant_type') neq oauthClient.getGrantType()>
    <div class="alert alert-error">Invalid grant_type variable.</div>
<cfelse>
    <cfoutput>
        <cfif len(m.event('accept')) and isBoolean(m.event('accept')) and m.validateCSRFTokens(context=oauthClient.getClientID())>
            <cfscript>
                if(m.event('accept')){
                    if(find(arguments.redirect_uri,'?')){
                        delim="&";
                    } else {
                        delim="?";
                    }

                    token=oauthClient.generateToken(granttype='authorization_code',userid=m.currentUser('userid'));

                    m.redirect(arguments.redirect_uri & delim & 'code=' & esapiEncode('url',token.get('accessCode')) & "&state=" & esapiEncode('url',arguments.state));
                } else {
                    m.redirect(arguments.redirect_uri);
                }
            </cfscript>
        <cfelse>
            <form>
                <p><strong>#esapiEncode('html',oauthClient.getName())#</strong> would like to your account.</p>
                <button type="submit" name="accept" value="true" class="btn">Yes</button><button type="submit" name="accept" value="false" class="btn">No</button>
                #variables.m.renderCSRFTokens(format='form',context=oauthClient.getClientID())#
                <input type="hidden" name="client_id" value="#esapiEncode('form',oauthClient.getClientID())#"/>
                <input type="hidden" name="client_secret" value="#esapiEncode('form',oauthClient.getClientSecret())#"/>
                <input type="hidden" name="redirect_uri" value="#esapiEncode('form',m.event('redirect_uri'))#">
            </form>
        </cfif>
    </cfoutput>
</cfif>
