component extends="baseLoginProvider" accessors=true output=false {

	variables.providerName='google';

	public function generateAuthUrl(state) {

		setReturnURL();

		var authUrl = "https://accounts.google.com/o/oauth2/v2/auth?";
		authUrl &= "client_id=#variables.configBean.getGoogleClientID()#&";
		authUrl &= "response_type=code&";
		authUrl &= "scope=openid%20profile%20email&";
		authUrl &= "redirect_uri=#urlEncodedFormat(getCallbackURL())#&";
		authUrl &= "state=#urlEncodedFormat(state)#&";
		authUrl &= "nonce=#createUUID()#"; //UUID on session scope?? Potential problems.

		return authUrl;
	}

	/*
	I handle validating the code result from Google and automatically getting the auth token.
	I should be able to handle any bad result from Google or the user not allowing crap.
	I also validate the state.
	*/
	public struct function validateResult(code, error, remoteState, clientState) {
		var result = {};

		//If error is anything, we have an error
		if(error != "") {
			result.status = false;
			result.message = error;
			return result;
		}

		//Then, ensure states are equal
		if(remoteState != clientState) {
			result.status = false;
			result.message = "State values did not match.";
			return result;
		}

		var token = getAuthToken(code);

		var profile = getProfile(token.access_token);
		profile.username = profile.email;

		getBean('oauthLoginUtility').updateOrCreateUserAccount(profile);

		result.status = true;
		result.token = token;
		result.profile = profile;

		return result;
	}

	public function getProfile(accesstoken) {
		var h = new http();
		h.setURL("https://www.googleapis.com/oauth2/v1/userinfo");
		h.setMethod("get");
		h.addParam(type="header",name="Authorization",value="OAuth #accesstoken#");
		h.addParam(type="header",name="GData-Version",value="3");
		h.setResolveURL(true);
		var result = h.send().getPrefix();
		return deserializeJSON(result.filecontent.toString());
	}

	//Credit: http://www.sitekickr.com/blog/http-post-oauth-coldfusion
	private function getAuthToken(code) {
		var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&";
			 postBody = postBody & "client_id=" & UrlEncodedFormat(variables.configBean.getGoogleClientID()) & "&";
			 postBody = postBody & "client_secret=" & UrlEncodedFormat(variables.configBean.getGoogleClientSecret()) & "&";
			 postBody = postBody & "redirect_uri=" & UrlEncodedFormat(getCallbackURL()) & "&";
			 postBody = postBody & "grant_type=authorization_code";

			var h = new http();
			h.setURL("https://accounts.google.com/o/oauth2/token");
			h.setMethod("post");
			h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded");
			h.addParam(type="body",value="#postBody#");
			h.setResolveURL(true);
			var result = h.send().getPrefix();
			return deserializeJSON(result.filecontent.toString());
	}

}
