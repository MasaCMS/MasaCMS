component extends="mura.cfobject" accessors=true output=false {

	variables.providerName='facebook';

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

		var authUrl = "https://www.facebook.com/v2.12/dialog/oauth?";
		authUrl &= "response_type=code&";
	  authUrl &= "client_id=#configBean.getFacebookClientID()#&";
		authUrl &= "scope=public_profile%20email&";
	  authUrl &= "redirect_uri=#urlEncodedFormat(getCallbackURL())#&";
	  authUrl &= "state=#urlEncodedFormat(state)#&";

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

		var token = getFacebookToken(code);

		var profile = getProfile(token.access_token);

		// Handle for difference between facebook and Google returned oAuth objects
		profile.given_name = profile.first_name;
		profile.family_name = profile.last_name;
		profile.username = profile.email;

		application.oauth.updateOrCreateUserAccount(profile);

		result.status = true;
		result.token = token;
		result.profile = profile;

		return result;
	}

	public function getProfile(accesstoken) {
		var h = new http();
		h.setURL("https://graph.facebook.com/me");
		h.setMethod("get");
		h.addParam(type="url",name="fields",value="email,name,first_name,last_name");
		h.addParam(type="url",name="access_token",value="#accesstoken#");
		h.setResolveURL(true);
		var result = h.send().getPrefix();
		return deserializeJSON(result.filecontent.toString());
	}

	private function getFacebookToken(code) {

		var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&";
			 postBody = postBody & "client_id=" & UrlEncodedFormat(configBean.getFacebookClientID()) & "&";
			 postBody = postBody & "client_secret=" & UrlEncodedFormat(configBean.getFacebookClientSecret()) & "&";
			 postBody = postBody & "redirect_uri=" & UrlEncodedFormat(getCallbackURL()) & "&";
			 // postBody = postBody & "grant_type=authorization_code";

			var h = new http();
			h.setURL("https://graph.facebook.com/v2.12/oauth/access_token");
			h.setMethod("post");
			h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded");
			h.addParam(type="body",value="#postBody#");
			h.setResolveURL(true);
			var result = h.send().getPrefix();
			return deserializeJSON(result.filecontent.toString());
	}

}
