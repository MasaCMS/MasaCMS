/**
* reCAPTCHA server-side verification (GitHub #464).
* Uses Google's public reCAPTCHA v2 test secret against the live siteverify endpoint.
*/
component extends="testbox.system.BaseSpec"{

	variables.testSecret = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WNFKwX';

	function run(){
		describe("reCAPTCHA.verifyResponse", function() {

			it(
				title="returns a boolean instead of throwing on the siteverify call",
				body=function() {
					var reCaptcha = new mura.reCAPTCHA(testSecret);
					var verified = reCaptcha.verifyResponse(response='any-token', remoteip='127.0.0.1');

					expect(isBoolean(verified)).toBeTrue();
				}
			);

			it(
				title="rejects a response token that Google did not issue",
				body=function() {
					var reCaptcha = new mura.reCAPTCHA(testSecret);

					expect(reCaptcha.verifyResponse(response='any-token', remoteip='127.0.0.1')).toBeFalse();
				}
			);

		});
	}

}
