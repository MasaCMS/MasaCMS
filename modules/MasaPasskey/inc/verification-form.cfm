<cfset local.isadminlogin = IsBoolean(arguments.m.event('isadminlogin')) ? arguments.m.event('isadminlogin') : false />
<cfoutput>
    <h1>Security Verification</h1>

    <form class="masaauth" novalidate="novalidate" id="masapasskey-verification-form" name="masapasskey-verification-form" method="post" action="index.cfm" onsubmit="return submitForm(this);">
        <div class="masa-focus-actions">
            <button id="masapasskey-verify-submit" class="btn btn-primary" type="submit">Submit</button>
        </div>
        <cfif local.isadminlogin>
            <input type="hidden" name="muraAction" value="cLogin.login" />
        <cfelse>
            <input type="hidden" name="doaction" value="login" />
        </cfif>
        <input type="hidden" id="masapasskey-challenge" name="challenge" value="#htmleditformat(session.challenge)#" />
        <input type="hidden" id="masapasskey-assertion" name="authcode" />
        <input type="hidden" name="status" value="challenge" />
        <input type="hidden" name="attemptChallenge" value="true" />
        <input type="hidden" name="isadminlogin" value="#local.isadminlogin#" />
        #m.renderCSRFTokens(format='form',context='login')#
    </form>
</cfoutput>