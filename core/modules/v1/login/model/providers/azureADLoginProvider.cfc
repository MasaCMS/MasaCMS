component extends="baseLoginProvider" accessors=true output=false {

	variables.providerName='azuread';

	public function generateAuthUrl(state) {
		var authUrl = "";
		var azureADTenant = lcase(variables.configBean.getAzureADTenant());

		setReturnURL();

		if(azureADTenant != ""){
			authUrl = "https://login.microsoftonline.com/#azureADTenant#/oauth2/v2.0/authorize?";
			authUrl &= "tenant=#variables.configBean.getAzureADTenantID()#&";
		} else {
			authUrl = "https://login.microsoftonline.com/#variables.configBean.getAzureADTenantID()#/oauth2/v2.0/authorize?";
		}

		authUrl &= "client_id=#variables.configBean.getAzureADClientID()#&";
		authUrl &= "response_type=code&";
		authUrl &= "redirect_uri=#urlEncodedFormat(getCallbackURL())#&";
		authUrl &= "response_mode=query&";
		authUrl &= "scope=https%3A%2F%2Fgraph.microsoft.com%2Fuser.read&";
		authUrl &= "state=#urlEncodedFormat(state)#&";

		return authUrl;
	}

	/*
	I handle validating the code result from Azure AD and automatically getting the auth token.
	I should be able to handle any bad result from Azuez AD or the user not allowing crap.
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

		profile.username = len(profile.mail) ? profile.mail : profile.userPrincipalName;
		profile.given_name = !isNull(profile.givenName) ? profile.givenName : '';
		profile.family_name = !isNull(profile.surname) ? profile.surname : '';
		profile.jobTitle = !isNull(profile.jobTitle) ? profile.jobTitle : '';
		profile.mobilePhone = !isNull(profile.mobilePhone) ? profile.mobilePhone : '';
		profile.email = profile.mail;

		getBean('oauthLoginUtility').updateOrCreateUserAccount(profile);

		result.status = true;
		result.token = token;
		result.profile = profile;

		return result;
	}

	public function getProfile(accesstoken) {
		var h = new http();
		h.setURL("https://graph.microsoft.com/v1.0/me");
		h.setMethod("get");
		h.addParam(type="header",name="Authorization",value="Bearer #accesstoken#");
		h.addParam(type="header",name="Content-Type",value="application/json");
		h.setResolveURL(true);
		var result = h.send().getPrefix();
		return deserializeJSON(result.filecontent.toString());
	}

	//Credit: http://www.sitekickr.com/blog/http-post-oauth-coldfusion
	private function getAuthToken(code) {
		var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&";
			 postBody = postBody & "client_id=" & UrlEncodedFormat(variables.configBean.getAzureADClientID()) & "&";
			 postBody = postBody & "client_secret=" & UrlEncodedFormat(variables.configBean.getAzureADClientSecret()) & "&";
			 postBody = postBody & "redirect_uri=" & UrlEncodedFormat(getCallbackURL()) & "&";
			 postBody = postBody & "response_type=code&";
			 postBody = postBody & "response_mode=query&";
			 postBody = postBody & "scope=https%3A%2F%2Fgraph.microsoft.com%2Fuser.read&";
			 postBody = postBody & "grant_type=authorization_code";

			var h = new http();
			h.setURL("https://login.microsoftonline.com/#variables.configBean.getAzureADTenantID()#/oauth2/v2.0/token?");
			h.setMethod("post");
			h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded");
			h.addParam(type="body",value="#postBody#");
			h.setResolveURL(true);
			var result = h.send().getPrefix();
			return deserializeJSON(result.filecontent.toString());
	}

}
