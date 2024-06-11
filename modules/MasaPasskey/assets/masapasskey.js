/**
 * [MasaAuthenticator](https://github.com/MasaCMS/MasaAuthenticator)
 * By: [We Are Orange BV](https://github.com/weareorange) and [Steve Withington](https://github.com/stevewithington)
 */
if (!window.console) console = {
    log: function () {}
    , warn: function () {}
    , clear: function () {}
};

// Prevent i-frame
this.top.location !== this.location && (this.top.location = this.location);

// Global Vars
var debug = true
    , locationHash = window.location.hash
    , locationHref = window.location.href
    , logData = function (data, clear) {
        if (!debug) {
            return true;
        }
        var clear = clear !== 'undefined' && clear === true;
        if (clear) {
            console.clear();
        }
        console.warn(data);
    };

jQuery(document).ready(function ($) {

    if (typeof MasaPasskey === 'undefined') {
        var MasaPasskey = {
            init: function () {
                var challenge = $('input#masapasskey-challenge').val();
                this.login(JSON.parse(challenge));
            }

            , login: function (loginJson) {
                console.dir(loginJson);
                const credentialsRequestOptions = {
                    ...loginJson,
                    challenge: this.base64urlToByteArray(loginJson.challenge.value)
                };
                console.dir(credentialsRequestOptions);
                navigator.credentials.get({publicKey: credentialsRequestOptions})
                .then((assertion) => {
                    const serializedAssertion = this.serializeAssertion(assertion);
                    $('input#masapasskey-assertion').val(serializedAssertion);
                    $('#masapasskey-verification-form').trigger( "submit" );;
                });
            }
        
            , bufferToBase64: function (buffer) {
                const byteView = new Uint8Array(buffer);
                let str = "";
                for (const charCode of byteView) {
                    str += String.fromCharCode(charCode);
                }
                return btoa(str);
            }

            , bufferToBase64url: function  (buffer) {
                const base64String = this.bufferToBase64(buffer);
                return base64String.replace(/\+/g, "-").replace(/\//g,"_",).replace(/=/g, "");
            }

            , base64urlToByteArray: function  (base64url) {
                return Uint8Array.from(window.atob(base64url), c => c.charCodeAt(0));
            }

            , serializeAssertion: function (assertion) {
                const serializeable = {
                    ...assertion,
                    rawId: this.bufferToBase64url(assertion.rawId),
                    response: {
                        authenticatorData: this.bufferToBase64url(assertion.response.authenticatorData),
                        clientDataJSON: this.bufferToBase64url(assertion.response.clientDataJSON),
                        signature: this.bufferToBase64url(assertion.response.signature),
                        userHandle: this.bufferToBase64url(assertion.response.userHandle)
                    }
                };
                const serialized = JSON.stringify(serializeable);
                return serialized;
            }
        }
    }
    // @end typeof MasaPasskey

    MasaPasskey.init();
});