<cfset local.user = m.getBean('user').loadBy(userid=session.mfa.userid) />
<cfset local.isBlocked = StructKeyExists(session, "blockLoginUntil") and IsDate(session.blockLoginUntil) and DateCompare(session.blockLoginUntil, Now()) eq 1 />
<cfoutput>
    <script>
        jQuery(document).ready(function($) {
            Mura.loader()
                .loadcss('#arguments.m.globalConfig('context')#/modules/MasaPasskey/assets/masapasskey.css')
                .loadjs('#arguments.m.globalConfig('context')#/modules/MasaPasskey/assets/masapasskey.js');
        });
    </script>

    <div class="masaauth-challenge-wrapper">

        <cfif local.isBlocked>
            <div class="alert alert-error">
                <span>#arguments.m.rbKey('login.blocked')#</span>
            </div>
        <cfelse>

            <cftry>
                <cfinclude template="verification-form.cfm" />
                <cfcatch>
                    <cfdump var="#cfcatch#" />
                </cfcatch>
            </cftry>

        </cfif>

    </div>
</cfoutput>