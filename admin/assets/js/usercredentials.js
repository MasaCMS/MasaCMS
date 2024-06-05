function bufferToBase64 (buffer) {
    const byteView = new Uint8Array(buffer);
    let str = "";
    for (const charCode of byteView) {
        str += String.fromCharCode(charCode);
    }
    return btoa(str);
}
function bufferToBase64url (buffer) {
    const base64String = bufferToBase64(buffer);
    return base64String.replace(/\+/g, "-").replace(/\//g,"_",).replace(/=/g, "");
}
function base64urlToByteArray (base64url) {
    return Uint8Array.from(window.atob(base64url), c => c.charCodeAt(0));
}
function serializePublicKeyCredential (credential) {
    const serializeable = {
        ...credential,
        rawId: bufferToBase64url(credential.rawId),
        response: {
            attestationObject: bufferToBase64url(credential.response.attestationObject),
            clientDataJSON: bufferToBase64url(credential.response.clientDataJSON)
        }
    };
    const serialized = JSON.stringify(serializeable);
    return serialized;
}
function serializeAssertion (assertion) {
    const serializeable = {
        ...assertion,
        rawId: bufferToBase64url(assertion.rawId),
        response: {
            authenticatorData: bufferToBase64url(assertion.response.authenticatorData),
            clientDataJSON: bufferToBase64url(assertion.response.clientDataJSON),
            signature: bufferToBase64url(assertion.response.signature),
            userHandle: bufferToBase64url(assertion.response.userHandle)
        }
    };
    const serialized = JSON.stringify(serializeable);
    return serialized;
}

async function registerCredentials() {
    const challengeRequest = await fetch("?muraAction=cusers.registerCredentialsStep1");
    const optionsJson = await challengeRequest.json();
    const publicKeyCredentialCreationOptions = {
        ...optionsJson,
        challenge: base64urlToByteArray(optionsJson.challenge.value),
        user: {
            ...optionsJson.user,
            id: base64urlToByteArray(optionsJson.user.id),
        }
    };
    /*
    const publicKeyCredentialCreationOptions = {
        ...publicKeyCredentialCreationOptionsJson,
        challenge,
        rp: publicKeyCredentialCreationOptionsJson.rp,
        user: {
            id: userId,
            name: publicKeyCredentialCreationOptionsJson.user.name,
            displayName: publicKeyCredentialCreationOptionsJson.user.displayName,
        },
        pubKeyCredParams: [{alg: -7, type: "public-key"}, {alg: -257, type: "public-key"}],
        authenticatorSelection: {authenticatorAttachment: "cross-platform"},
        timeout: 60000,
        attestation: "direct"
    };
    */
    console.dir(publicKeyCredentialCreationOptions);

    //This activates the browser
    credential = await navigator.credentials.create({publicKey: publicKeyCredentialCreationOptions});

    const serializedCredential = serializePublicKeyCredential(credential);
    console.log(serializedCredential);
    const response = await fetch("?muraAction=cusers.registerCredentialsStep2", {
        method: "POST",
        body: serializedCredential
    });
    console.log(await response.json());
}

async function login() {
    const loginRequest = await fetch("/login-step1.cfm");
    const loginJson = await loginRequest.json();
    console.dir(loginJson);
    const credentialsRequestOptions = {
        ...loginJson,
        challenge: base64urlToByteArray(loginJson.challenge.value)
    };
    /*
    const credentialsRequestOptions = {
        challenge: base64urlToByteArray(loginChallenge.challenge.value),
        allowCredentials: loginChallenge.credentials ? loginChallenge.credentials.map((c) => {
            return {
                id: base64urlToByteArray(c.id),
                type: 'public-key'
            }
        }) : null,
        timeout: 60000,
    };
    */
    console.dir(credentialsRequestOptions);
    const assertion = await navigator.credentials.get({publicKey: credentialsRequestOptions});
    console.log(assertion);
    const serializedAssertion = serializeAssertion(assertion);
    console.log(serializedAssertion);
    const response = await fetch("/login-step2.cfm", {
        method: "POST",
        body: serializedAssertion
    });
}