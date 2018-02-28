component extends="baseLoginProvider" accessors=true output=false {

	variables.providerName='github';

	public function generateAuthUrl(state) {

		setReturnURL();

		var authUrl = "https://github.com/login/oauth/authorize?";
		authUrl &= "response_type=code&";
	  authUrl &= "client_id=#variables.configBean.getGithubClientID()#&";
		authUrl &= "scope=user:email&";
	  authUrl &= "state=#urlEncodedFormat(state)#&";
		authUrl &= "redirect_uri=#urlEncodedFormat(getCallbackURL())#&";

		return authUrl;
	}

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

		// Handle for difference between github and Google returned profile objects
		if (!structKeyExists(profile, 'given_name')) {
			profile.given_name = profile.name.split(' ')[1];
		}
		if (!structKeyExists(profile, 'family_name')) {
			nameArray = profile.name.split(" ");
			profile.family_name = ArrayToList(arraySlice(nameArray, 2), " ");
		}

		if (isNull(profile.email)) {
			profile.email = 'donotreply@domain.com';
			profile.username = profile.name & createUUID();
		} else {
			profile.username = profile.email;
		}

		getBean('oauthLoginUtility').updateOrCreateUserAccount(profile);

		result.status = true;
		result.token = token;
		result.profile = profile;

		return result;
	}

	public function getProfile(accesstoken) {
		var h = new http();
		h.setURL("https://api.github.com/user");
		h.setMethod("get");
		h.addParam(type="url",name="access_token",value="#accesstoken#");
		h.setResolveURL(true);
		var result = h.send().getPrefix();
		return deserializeJSON(result.filecontent.toString());
	}

	private function getAuthToken(code) {

		var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&";
			 postBody = postBody & "client_id=" & UrlEncodedFormat(variables.configBean.getGithubClientID()) & "&";
			 postBody = postBody & "client_secret=" & UrlEncodedFormat(variables.configBean.getGithubClientSecret()) & "&";
			 postBody = postBody & "redirect_uri=" & UrlEncodedFormat(getCallbackURL()) & "&";

			var h = new http();
			h.setURL("https://github.com/login/oauth/access_token");
			h.setMethod("post");
			h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded");
			h.addParam(type="header",name="Accept",value="application/json");
			h.addParam(type="body",value="#postBody#");
			h.setResolveURL(true);
			var result = h.send().getPrefix();

			return deserializeJSON(result.filecontent.toString());
	}

}
