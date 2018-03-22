component extends="mura.cfobject" hint="Google Authenticator"{

	function init(numeric timeStepSizeInSeconds=30, numeric windowSize=3, numeric codeDigits=6) {
		var gauth = 'com.warrenstrange.googleauth.GoogleAuthenticator';
		var qrgen = 'com.warrenstrange.googleauth.GoogleAuthenticatorQRGenerator';
		var gaconfigbuilder = getGAConfigBuilder(argumentCollection=arguments);
		var gaconfig = gaconfigbuilder.build();

		if (getBean('configBean').getValue(property='legacyJavaLoader', defaultValue=false)) {
			variables.googleauth = application.serviceFactory.getBean('javaLoader').create(gauth).init(gaconfig);
			variables.googleauthqrgenerator = application.serviceFactory.getBean('javaLoader').create(qrgen).init();
		} else {
			variables.googleauth = CreateObject('java', gauth).init(gaconfig);
			variables.googleauthqrgenerator = CreateObject('java', qrgen).init();
		}

		return this;
	}

	private function getGAConfigBuilder(numeric timeStepSizeInSeconds=30, numeric windowSize=3, numeric codeDigits=6) {
		var gacb = '';
		var googleAuthenticatorConfigBuilder = 'com.warrenstrange.googleauth.GoogleAuthenticatorConfig$GoogleAuthenticatorConfigBuilder';
		var timeStepSizeInMillis = Val(arguments.timeStepSizeInSeconds) * 1000;

		if (getBean('configBean').getValue(property='legacyJavaLoader', defaultValue=false)) {
			gacb = application.serviceFactory.getBean('javaLoader').create(googleAuthenticatorConfigBuilder);
		} else {
			gacb = CreateObject('java', googleAuthenticatorConfigBuilder);
		}

		gacb
			.setTimeStepSizeInMillis(JavaCast('long', timeStepSizeInMillis))
			.setWindowSize(JavaCast('int', arguments.windowSize))
			.setCodeDigits(JavaCast('int', arguments.codeDigits));

		return gacb;
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
