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
				title="Should throw exception for dots in field name 'table.field'",
				body=function(){
					expect(function(){
						utility.validateSortBy('table.field');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);
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
				title="Should throw exception for dot in field 'table.field ASC'",
				body=function(){
					expect(function(){
						utility.validateSort('table.field ASC');
					}).toThrow(type='Masa.InvalidSortBy');
				}
			);
		});
	}
}
