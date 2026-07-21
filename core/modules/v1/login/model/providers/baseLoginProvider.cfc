component extends="mura.cfobject" accessors=true output=false {

	variables.providerName='base';

	function init(configBean,utility){
		variables.configBean=arguments.configBean;
		variables.utility=arguments.utility;
		return this;
	}

	function getCallbackURL(){
		return variables.utility.getRequestProtocol() & "://" &  variables.utility.getRequestHost() & variables.configBean.getServerPort() & variables.configBean.getContext() & '/?loginProvider=#variables.providerName#';
	}

	function setReturnURL(){
		session.mura.returnURL='';

		// Neutralise off-site redirect targets before storing them in the session; the stored
		// value is later handed to location() in the OAuth callback handler (authHandler.cfc).
		if(isDefined('form.returnURL')){
			session.mura.returnURL = variables.utility.sanitizeHref(form.returnURL);
		} else if(isDefined('url.returnURL')){
				session.mura.returnURL = variables.utility.sanitizeHref(url.returnURL);
		} else {
			 session.mura.returnURL = getBean('configBean').getContext();
		}
	}

	public function generateAuthUrl(state) {
      throw(message="missing method implementation");
	}

	public struct function validateResult(code, error, remoteState, clientState) {
    throw(message="missing method implementation");
	}

	public function getProfile(accesstoken) {
		throw(message="missing method implementation");
	}

	private function getAuthToken(code) {
    throw(message="missing method implementation");
  }
}
