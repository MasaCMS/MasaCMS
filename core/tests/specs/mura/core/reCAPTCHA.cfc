/**
* reCAPTCHA server-side verification (GitHub #464).
*/
component extends="testbox.system.BaseSpec"{

	// Google's public reCAPTCHA v2 test secret
	variables.testSecret = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WNFKwX';

	function run(){
		describe("reCAPTCHA.verifyResponse", function() {

			it(
				title="returns false with check-siteVerifyUrl when the verify endpoint is unreachable",
				body=function() {
					var reCaptcha = new mura.reCAPTCHA(testSecret);
					reCaptcha._siteVerifyUrl = 'http://127.0.0.1:1/';

					expect(reCaptcha.verifyResponse(response='any-token', remoteip='127.0.0.1')).toBeFalse();
					expect(reCaptcha.getErrorCodes()).toBe(['check-siteVerifyUrl']);
				}
			);

			it(
				title="parses Google's rejection of a token it did not issue",
				labels="network",
				body=function() {
					var reCaptcha = new mura.reCAPTCHA(testSecret);

					expect(reCaptcha.verifyResponse(response='any-token', remoteip='127.0.0.1')).toBeFalse();
					expect(reCaptcha.getErrorCodes()).toInclude('invalid-input-response', 'siteverify was not reached or its response was not parsed');
				}
			);

		});
	}

}
