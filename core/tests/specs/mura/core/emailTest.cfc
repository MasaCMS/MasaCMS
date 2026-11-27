/**
* The admin's "Test Email Settings" dialog (admin/core/views/carch/emailTest.cfm).
*
* It connects to the mail server through Java Mail: javax.mail on Lucee and Adobe,
* jakarta.mail on BoxLang.
*/
component extends="testbox.system.BaseSpec" {

	// Renders the dialog for the posted mail settings and returns what it says.
	private string function testMailServer(required string host, required string port, string useSSL="false") {
		variables.$ = application.serviceFactory.getBean('$').init('default');
		variables.$.event('mailHost', arguments.host);
		variables.$.event('mailSmtpPort', arguments.port);
		variables.$.event('mailUsername', '');
		variables.$.event('mailPassword', '');
		variables.$.event('mailUseTLS', 'false');
		variables.$.event('mailUseSSL', arguments.useSSL);

		var output = "";
		savecontent variable="output" {
			include "/muraWRM/admin/core/views/carch/emailTest.cfm";
		}
		return output;
	}

	function run() {

		describe("Email settings test", function(){

			it("reports a mail server that cannot be reached", function(){
				var output = testMailServer("unreachable.invalid", "2525");

				expect(output).toInclude("Error: ");
				expect(output).toInclude("unreachable.invalid");
				expect(output).notToInclude("Your email settings are valid");
			});

			it("reports a mail server that cannot be reached over SSL", function(){
				var output = testMailServer("unreachable.invalid", "465", "true");

				expect(output).toInclude("Error: ");
				expect(output).toInclude("unreachable.invalid");
				expect(output).notToInclude("Your email settings are valid");
			});

		});

	}

}
