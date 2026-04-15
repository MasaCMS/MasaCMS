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

		});

		describe("removeLeadingDoubleSlash() - Open Redirect Protection", function() {

			var utility=application.serviceFactory.getBean('utility');

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

		describe("Testing validateSortDirection", function() {

			var utility=application.serviceFactory.getBean('utility');

			it(
				title="Should accept 'asc' and return normalized lowercase",
				body=function(){
					expect(utility.validateSortDirection('asc')).toBe('asc');
				}
			);

			it(
				title="Should accept 'desc' and return normalized lowercase",
				body=function(){
					expect(utility.validateSortDirection('desc')).toBe('desc');
				}
			);

			it(
				title="Should be case-insensitive for 'ASC'",
				body=function(){
					expect(utility.validateSortDirection('ASC')).toBe('asc');
				}
			);

			it(
				title="Should be case-insensitive for 'DESC'",
				body=function(){
					expect(utility.validateSortDirection('DESC')).toBe('desc');
				}
			);

			it(
				title="Should be case-insensitive for mixed case 'Asc'",
				body=function(){
					expect(utility.validateSortDirection('Asc')).toBe('asc');
				}
			);

			it(
				title="Should be case-insensitive for mixed case 'Desc'",
				body=function(){
					expect(utility.validateSortDirection('Desc')).toBe('desc');
				}
			);

			it(
				title="Should trim whitespace from ' asc '",
				body=function(){
					expect(utility.validateSortDirection(' asc ')).toBe('asc');
				}
			);

			it(
				title="Should trim whitespace from ' desc '",
				body=function(){
					expect(utility.validateSortDirection(' desc ')).toBe('desc');
				}
			);

			it(
				title="Should throw exception for invalid input 'invalid'",
				body=function(){
					expect(function(){
						utility.validateSortDirection('invalid');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for SQL injection attempt 'asc; DROP TABLE'",
				body=function(){
					expect(function(){
						utility.validateSortDirection('asc; DROP TABLE');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for SQL injection attempt 'desc OR 1=1'",
				body=function(){
					expect(function(){
						utility.validateSortDirection('desc OR 1=1');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for empty string",
				body=function(){
					expect(function(){
						utility.validateSortDirection('');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for special characters '@##$%'",
				body=function(){
					expect(function(){
						utility.validateSortDirection('@##$%');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for numeric input '123'",
				body=function(){
					expect(function(){
						utility.validateSortDirection('123');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);
		});

		describe("Testing validateSortBy", function() {

			var utility=application.serviceFactory.getBean('utility');

			it(
				title="Should accept valid single field name 'username'",
				body=function(){
					expect(utility.validateSortBy('username')).toBe('username');
				}
			);

			it(
				title="Should accept valid multiple field names 'username,email,created_date'",
				body=function(){
					expect(utility.validateSortBy('username,email,created_date')).toBe('username,email,created_date');
				}
			);

			it(
				title="Should accept field names with numbers 'field1,field2,user_id'",
				body=function(){
					expect(utility.validateSortBy('field1,field2,user_id')).toBe('field1,field2,user_id');
				}
			);

			it(
				title="Should accept field names with underscores 'first_name,last_name,user_id'",
				body=function(){
					expect(utility.validateSortBy('first_name,last_name,user_id')).toBe('first_name,last_name,user_id');
				}
			);

			it(
				title="Should trim spaces around commas 'field1 , field2 , field3'",
				body=function(){
					expect(utility.validateSortBy('field1 , field2 , field3')).toBe('field1,field2,field3');
				}
			);

			it(
				title="Should trim leading and trailing spaces ' field1, field2 '",
				body=function(){
					expect(utility.validateSortBy(' field1, field2 ')).toBe('field1,field2');
				}
			);

			it(
				title="Should return empty string as-is",
				body=function(){
					expect(utility.validateSortBy('')).toBe('');
				}
			);

			it(
				title="Should return whitespace-only string as-is",
				body=function(){
					expect(utility.validateSortBy('   ')).toBe('   ');
				}
			);

			it(
				title="Should throw exception for field with space 'user name'",
				body=function(){
					expect(function(){
						utility.validateSortBy('user name');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for SQL injection 'field1;DROP TABLE users'",
				body=function(){
					expect(function(){
						utility.validateSortBy('field1;DROP TABLE users');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for SQL injection 'field1 OR 1=1'",
				body=function(){
					expect(function(){
						utility.validateSortBy('field1 OR 1=1');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for SQL injection 'field1 UNION SELECT'",
				body=function(){
					expect(function(){
						utility.validateSortBy('field1 UNION SELECT');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for special characters 'field@domain.com'",
				body=function(){
					expect(function(){
						utility.validateSortBy('field@domain.com');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for dash in field name 'field-name'",
				body=function(){
					expect(function(){
						utility.validateSortBy('field-name');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should handle consecutive commas 'field1,,field2'",
				body=function(){
					expect(utility.validateSortBy('field1,,field2')).toBe('field1,field2');
				}
			);

			it(
				title="Should handle leading comma ',field1,field2'",
				body=function(){
					expect(utility.validateSortBy(',field1,field2')).toBe('field1,field2');
				}
			);

			it(
				title="Should handle trailing comma 'field1,field2,'",
				body=function(){
					expect(utility.validateSortBy('field1,field2,')).toBe('field1,field2');
				}
			);

			it(
				title="Should throw exception for parentheses 'COUNT(*)'",
				body=function(){
					expect(function(){
						utility.validateSortBy('COUNT(*)');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should accept dots in field name 'table.field'",
				body=function(){
					expect(utility.validateSortBy('table.field')).toBe('table.field');
				}
			);
		});

		describe("Testing sanitizeHref() - URL Security & Domain Validation", function() {

			var utility=application.serviceFactory.getBean('utility');
			var siteid='default';

			// Note: These tests assume 'localhost' is the configured site domain
			// and is in the allowed domain list for the default site

			describe("Relative Path Handling", function() {
				
				it("should preserve simple relative path unchanged", function() {
					var result = utility.sanitizeHref('/feedback-thank-you/', siteid);
					expect(result).toBe('/feedback-thank-you/');
				});

				it("should preserve relative path with multiple segments", function() {
					var result = utility.sanitizeHref('/admin/login/index', siteid);
					expect(result).toBe('/admin/login/index');
				});

				it("should preserve relative path with query string", function() {
					var result = utility.sanitizeHref('/search?q=test&page=1', siteid);
					expect(result).toBe('/search?q=test&page=1');
				});

				it("should preserve relative path with fragment", function() {
					var result = utility.sanitizeHref('/page##section', siteid);
					expect(result).toBe('/page##section');
				});

				it("should preserve root path", function() {
					var result = utility.sanitizeHref('/', siteid);
					expect(result).toBe('/');
				});

				it("should preserve relative path with file extension", function() {
					var result = utility.sanitizeHref('/downloads/file.pdf', siteid);
					expect(result).toBe('/downloads/file.pdf');
				});

			});

			describe("Absolute URL Handling - HTTP Protocol", function() {

				it("should preserve http URL with localhost domain (allowed)", function() {
					var result = utility.sanitizeHref('http://localhost/page', siteid);
					expect(result).toBe('http://localhost/page');
				});

				it("should preserve http URL with localhost and port (allowed)", function() {
					var result = utility.sanitizeHref('http://localhost:8080/admin', siteid);
					expect(result).toBe('http://localhost:8080/admin');
				});

				it("should preserve http URL with localhost and query string (allowed)", function() {
					var result = utility.sanitizeHref('http://localhost/search?q=test', siteid);
					expect(result).toBe('http://localhost/search?q=test');
				});

				it("should replace external domain with site domain", function() {
					var result = utility.sanitizeHref('http://evil.com/page', siteid);
					// Should replace evil.com with localhost (the site domain)
					expect(result).notToInclude('evil.com');
					expect(result).toBe('http://localhost/page');
				});

			});

			describe("Absolute URL Handling - HTTPS Protocol", function() {

				it("should preserve https URL with localhost domain (allowed)", function() {
					var result = utility.sanitizeHref('https://localhost/secure', siteid);
					expect(result).toBe('https://localhost/secure');
				});

				it("should preserve https URL with localhost and port (allowed)", function() {
					var result = utility.sanitizeHref('https://localhost:443/admin', siteid);
					expect(result).toBe('https://localhost:443/admin');
				});

				it("should replace external domain with site domain", function() {
					var result = utility.sanitizeHref('https://malicious.com/phishing', siteid);
					// Should replace malicious.com with localhost
					expect(result).notToInclude('malicious.com');
					expect(result).toBe('https://localhost/phishing');
				});

			});

			describe("Domain-Only Strings (No Protocol)", function() {

				it("should handle domain with port (no protocol)", function() {
					var result = utility.sanitizeHref('localhost:8080', siteid);
					expect(result).toBe('localhost:8080');
				});

				it("should preserve ambiguous string as relative path (no protocol)", function() {
					// example.com/path has no protocol, so should be treated as relative path
					var result = utility.sanitizeHref('example.com/path', siteid);
					expect(result).toBe('example.com/path');
				});

			});

			describe("Edge Cases & Special Characters", function() {

				it("should handle empty string", function() {
					var result = utility.sanitizeHref('', siteid);
					expect(result).toBe('');
				});

				it("should handle URL with encoded characters", function() {
					var result = utility.sanitizeHref('/path/to/page%20with%20spaces', siteid);
					expect(result).toBe('/path/to/page%20with%20spaces');
				});

				it("should handle URL with special characters in query", function() {
					var result = utility.sanitizeHref('/search?name=John+Doe&email=test@example.com', siteid);
					expect(result).toBe('/search?name=John+Doe&email=test@example.com');
				});

				it("should handle multiple query parameters", function() {
					var result = utility.sanitizeHref('/page?param1=value1&param2=value2&param3=value3', siteid);
					expect(result).toBe('/page?param1=value1&param2=value2&param3=value3');
				});

			});

			describe("Real-World Use Cases", function() {

				it("should handle form redirect_url (the bug case)", function() {
					// This was the original bug: relative path was treated as domain
					var result = utility.sanitizeHref('/feedback-thank-you/', siteid);
					expect(result).toBe('/feedback-thank-you/');
					// Should NOT become 'localhost' or any other transformation
					expect(result).notToInclude('localhost/');
				});

				it("should handle login return URL (relative)", function() {
					var result = utility.sanitizeHref('/admin/login', siteid);
					expect(result).toBe('/admin/login');
				});

				it("should handle gated asset redirect (relative)", function() {
					var result = utility.sanitizeHref('/downloads/protected-file.pdf', siteid);
					expect(result).toBe('/downloads/protected-file.pdf');
				});

				it("should sanitize external login return URL by replacing domain", function() {
					var result = utility.sanitizeHref('http://attacker.com/steal-session', siteid);
					// Should replace attacker.com domain with site domain
					expect(result).notToInclude('attacker.com');
					expect(result).toBe('http://localhost/steal-session');
				});

			});

			describe("Scheme-Relative URLs (// prefix) - Security", function() {

				it("should remove leading // from scheme-relative URL", function() {
					var result = utility.sanitizeHref('//example.com/path', siteid);
					// Leading // should be removed to prevent open redirect
					expect(result).toBe('/example.com/path');
					expect(result).notToInclude('//');
				});

				it("should remove leading // from malicious scheme-relative URL", function() {
					var result = utility.sanitizeHref('//evil.com/phishing', siteid);
					expect(result).toBe('/evil.com/phishing');
					expect(result).notToInclude('//');
				});

				it("should remove leading // with port number", function() {
					var result = utility.sanitizeHref('//attacker.com:8080/steal', siteid);
					expect(result).toBe('/attacker.com:8080/steal');
					expect(result).notToInclude('//');
				});

				it("should remove leading // with query parameters", function() {
					var result = utility.sanitizeHref('//external.com/page?redirect=evil', siteid);
					expect(result).toBe('/external.com/page?redirect=evil');
					expect(result).notToInclude('//');
				});

				it("should remove leading // with fragment", function() {
					var result = utility.sanitizeHref('//external.com/page##section', siteid);
					expect(result).toBe('/external.com/page##section');
					expect(result).notToInclude('//');
				});

				it("should handle whitespace before // in scheme-relative URL", function() {
					var result = utility.sanitizeHref('  //evil.com/test', siteid);
					expect(result).toBe('/evil.com/test');
					expect(result).notToInclude('//');
				});

				it("should handle just // as scheme-relative URL", function() {
					var result = utility.sanitizeHref('//', siteid);
					expect(result).toBe('/');
					expect(result).notToInclude('//');
				});

			});

			describe("Security & Open Redirect Prevention", function() {

				it("should prevent open redirect via external domain in absolute URL", function() {
					var result = utility.sanitizeHref('http://evil.com/fake-login', siteid);
					// Domain should be replaced with site domain
					expect(result).notToInclude('evil.com');
					expect(result).toBe('http://localhost/fake-login');
				});

				it("should prevent open redirect via external domain in absolute URL path", function() {
					var result = utility.sanitizeHref('http://localhost//evil.com/fake-login', siteid);
					// Should not contain evil.com after sanitization
					expect(result).notToInclude('evil.com');
				});

				it("should pass through data URI unchanged (not HTTP/HTTPS)", function() {
					// Data URIs don't have http/https protocol and no // prefix
					// Function should pass them through (actual security filtering should happen elsewhere)
					var result = utility.sanitizeHref('data:text/html,<script>alert(1)</script>', siteid);
					expect(result).toBe('data:text/html,<script>alert(1)</script>');
				});

				it("should pass through javascript URI unchanged (not HTTP/HTTPS)", function() {
					// Javascript pseudo-protocol is dangerous but this function only validates HTTP(S) domains
					// XSS prevention should happen at a different layer
					var result = utility.sanitizeHref('javascript:alert(1)', siteid);
					expect(result).toBe('javascript:alert(1)');
				});

			});

		});

		describe("Testing validateSort", function() {

			var utility=application.serviceFactory.getBean('utility');

			it(
				title="Should accept valid single field with direction 'username ASC'",
				body=function(){
					expect(utility.validateSort('username ASC')).toBe('username asc');
				}
			);

			it(
				title="Should accept valid single field without direction 'username' and default to asc",
				body=function(){
					expect(utility.validateSort('username')).toBe('username asc');
				}
			);

			it(
				title="Should accept valid multiple fields with explicit directions 'field1 ASC, field2 DESC'",
				body=function(){
					expect(utility.validateSort('field1 ASC, field2 DESC')).toBe('field1 asc,field2 desc');
				}
			);

			it(
				title="Should accept valid multiple fields without directions 'field1, field2'",
				body=function(){
					expect(utility.validateSort('field1, field2')).toBe('field1 asc,field2 asc');
				}
			);

			it(
				title="Should accept valid mixed fields 'field1 ASC, field2, field3 DESC'",
				body=function(){
					expect(utility.validateSort('field1 ASC, field2, field3 DESC')).toBe('field1 asc,field2 asc,field3 desc');
				}
			);

			it(
				title="Should normalize case for 'field1 DESC'",
				body=function(){
					expect(utility.validateSort('field1 DESC')).toBe('field1 desc');
				}
			);

			it(
				title="Should normalize case for 'field1 desc'",
				body=function(){
					expect(utility.validateSort('field1 desc')).toBe('field1 desc');
				}
			);

			it(
				title="Should normalize case for 'field1 Desc'",
				body=function(){
					expect(utility.validateSort('field1 Desc')).toBe('field1 desc');
				}
			);

			it(
				title="Should trim whitespace ' field1  ASC  ,  field2  DESC '",
				body=function(){
					expect(utility.validateSort(' field1  ASC  ,  field2  DESC ')).toBe('field1 asc,field2 desc');
				}
			);

			it(
				title="Should handle multiple spaces between field and direction 'field1    ASC'",
				body=function(){
					expect(utility.validateSort('field1    ASC')).toBe('field1 asc');
				}
			);

			it(
				title="Should accept field with underscore and numbers 'user_id_123 DESC'",
				body=function(){
					expect(utility.validateSort('user_id_123 DESC')).toBe('user_id_123 desc');
				}
			);

			it(
				title="Should return empty string as-is",
				body=function(){
					expect(utility.validateSort('')).toBe('');
				}
			);

			it(
				title="Should return whitespace-only string as-is",
				body=function(){
					expect(utility.validateSort('   ')).toBe('   ');
				}
			);

			it(
				title="Should throw exception for field with space 'user name ASC'",
				body=function(){
					expect(function(){
						utility.validateSort('user name ASC');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for SQL injection in field 'field1;DROP TABLE ASC'",
				body=function(){
					expect(function(){
						utility.validateSort('field1;DROP TABLE ASC');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for special chars in field 'field@domain.com DESC'",
				body=function(){
					expect(function(){
						utility.validateSort('field@domain.com DESC');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for invalid direction 'field1 INVALID'",
				body=function(){
					expect(function(){
						utility.validateSort('field1 INVALID');
					}).toThrow(type='Masa.InvalidSortDirection');
				}
			);

			it(
				title="Should throw exception for SQL injection in direction 'field1 ASC OR 1=1'",
				body=function(){
					expect(function(){
						utility.validateSort('field1 ASC OR 1=1');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should throw exception for both invalid field and direction 'bad field INVALID'",
				body=function(){
					expect(function(){
						utility.validateSort('bad field INVALID');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should handle complex valid case 'created_date DESC, username ASC, id'",
				body=function(){
					expect(utility.validateSort('created_date DESC, username ASC, id')).toBe('created_date desc,username asc,id asc');
				}
			);

			it(
				title="Should throw exception for dash in field 'user-name ASC'",
				body=function(){
					expect(function(){
						utility.validateSort('user-name ASC');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);

			it(
				title="Should accept dot in field 'table.field ASC'",
				body=function(){
					expect(utility.validateSort('table.field ASC')).toBe('table.field asc');
				}
			);
		});
	}
}
