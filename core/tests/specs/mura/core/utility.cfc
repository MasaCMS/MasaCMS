/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Utilities", function() {

			var utility=application.serviceFactory.getBean('utility');

			it(
				title="Should be able to set cookie",
				body=function( data ){
					utility.setCookie(name='mura_testing',value=true);
				},
				data={utility=utility  }
			);

			describe("removeLeadingDoubleSlash() - Open Redirect Protection", function() {

				it("should remove leading // from malicious URLs", function() {
					var result = utility.removeLeadingDoubleSlash("//evil.com/test");
					expect(result).toBe("/evil.com/test");
				});

				it("should handle whitespace before //", function() {
					var result = utility.removeLeadingDoubleSlash("  //evil.com/test");
					expect(result).toBe("/evil.com/test");
				});

				it("should preserve http:// URLs unchanged", function() {
					var result = utility.removeLeadingDoubleSlash("http://legitimate.com/page");
					expect(result).toBe("http://legitimate.com/page");
				});

				it("should preserve https:// URLs unchanged", function() {
					var result = utility.removeLeadingDoubleSlash("https://secure.com/page");
					expect(result).toBe("https://secure.com/page");
				});

				it("should preserve normal relative paths", function() {
					var result = utility.removeLeadingDoubleSlash("/normal/path");
					expect(result).toBe("/normal/path");
				});

				it("should preserve relative paths without leading slash", function() {
					var result = utility.removeLeadingDoubleSlash("relative/path");
					expect(result).toBe("relative/path");
				});

				it("should handle edge case of just //", function() {
					var result = utility.removeLeadingDoubleSlash("//");
					expect(result).toBe("/");
				});

				it("should preserve single slash", function() {
					var result = utility.removeLeadingDoubleSlash("/");
					expect(result).toBe("/");
				});

				it("should handle empty string", function() {
					var result = utility.removeLeadingDoubleSlash("");
					expect(result).toBe("");
				});

				it("should handle complex malicious URL with path", function() {
					var result = utility.removeLeadingDoubleSlash("//attacker.com/path/to/phishing");
					expect(result).toBe("/attacker.com/path/to/phishing");
				});

				it("should handle URL with query parameters", function() {
					var result = utility.removeLeadingDoubleSlash("//evil.com/page?param=value");
					expect(result).toBe("/evil.com/page?param=value");
				});

				it("should preserve domain-like paths starting with single /", function() {
					var result = utility.removeLeadingDoubleSlash("/example.com/test");
					expect(result).toBe("/example.com/test");
				});

				it("should handle whitespace-only string", function() {
					var result = utility.removeLeadingDoubleSlash("   ");
					expect(result).toBe("");
				});

				it("should handle tabs and newlines before //", function() {
					var result = utility.removeLeadingDoubleSlash("	" & chr(10) & "//evil.com");
					expect(result).toBe("/evil.com");
				});

				it("should handle URL fragments", function() {
					var result = utility.removeLeadingDoubleSlash("//evil.com##fragment");
					expect(result).toBe("/evil.com##fragment");
				});

				it("should handle URL with port number", function() {
					var result = utility.removeLeadingDoubleSlash("//evil.com:8080/test");
					expect(result).toBe("/evil.com:8080/test");
				});

			});


		});

	}

}
