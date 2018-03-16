component extends="mura.cfobject" hint="Google Authenticator"{

	function init(){
		var gauth = 'com.warrenstrange.googleauth.GoogleAuthenticator';
		var qrgen = 'com.warrenstrange.googleauth.GoogleAuthenticatorQRGenerator';

		if(getBean('configBean').getValue(property='legacyJavaLoader',defaultValue=false)){
			variables.googleauth = application.serviceFactory.getBean('javaLoader').create(gauth);
			variables.googleauthqrgenerator = application.serviceFactory.getBean('javaLoader').create(qrgen);
		} else {
			variables.googleauth = CreateObject('java', gauth);
			variables.googleauthqrgenerator = CreateObject('java', qrgen);
		}

		return this;
	}

	function getKey(required credentials) {
		return arguments.credentials.getKey();
	}

	function getVerificationCode(required credentials) {
		return arguments.credentials.getVerificationCode();
	}

	function getOtpAuthURL(required string accountName, required any credentials, string issuer='muraplatform') {
		var qrgen = getQRGenerator();
		return qrgen.getOtpAuthURL(arguments.issuer, arguments.accountName, arguments.credentials);
	}

	function createCredentials() {
		return variables.googleauth.createCredentials();
	}

	function getQRGenerator(){
		return variables.googleauthqrgenerator;
	}

	function authorize(required string secretKey, required string password) {
		return variables.googleauth.authorize(arguments.secretKey, arguments.password);
	}

	function getTotpPassword(required string secretKey) {
		return variables.googleauth.getTotpPassword(arguments.secretKey);
	}

	function getScratchCodes(required credentials) {
		return arguments.credentials.getScratchCodes();
	}

}
