component extends="mura.cfobject" accessors=true output=false {

	variables.providerName='google';

	function init(configBean,utility){
		variables.configBean=arguments.configBean;
		variables.utility=arguments.utility;
		return this;
	}

	function getCallbackURL(){
		variables.utility.getRequestProtocol() & variables.utility.getRequestHost() & variables.configBean.getServerPort() & variables.configBean.getContext() & '?#variables.providerName#';
	}

	function setReturnURL(){
		session.mura.returnURL='';

		if(isDefined('form.returnURL')){
			session.mura.returnURL = form.returnURL;
		} else if(isDefined('url.returnURL')){
				session.mura.returnURL = url.returnURL;
		} else {
			 session.mura.returnURL = getBean('configBean').getContext();
		}
	}

	public function generateAuthUrl(state) {

		setReturnURL();

		var authUrl = "https://accounts.google.com/o/oauth2/v2/auth?";
		authUrl &= "client_id=#variables.configBean.getGoogleClientID()#&";
		authUrl &= "response_type=code&";
		authUrl &= "scope=openid%20profile%20email&";
		authUrl &= "redirect_uri=#urlEncodedFormat(variables.utility.getRequestProtocol() & variables.utility.getRequestHost() & variables.configBean.getServerPort() & variables.configBean.getContext() & '?google')#&";
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

		var token = getGoogleToken(code);

		var profile = getProfile(token.access_token);
		profile.username = profile.email;

		application.oauth.updateOrCreateUserAccount(profile);

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
	private function getGoogleToken(code) {
		var callback=variables.utility.getRequestProtocol() & variables.utility.getRequestHost() & variables.configBean.getServerPort() & variables.configBean.getContext() & '?google';

		var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&";
			 postBody = postBody & "client_id=" & UrlEncodedFormat(variables.configBean.getGoogleClientID()) & "&";
			 postBody = postBody & "client_secret=" & UrlEncodedFormat(variables.configBean.getGoogleClientSecret()) & "&";
			 postBody = postBody & "redirect_uri=" & UrlEncodedFormat(callback) & "&";
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
