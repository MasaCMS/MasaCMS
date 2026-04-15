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
		describe("Testing Date Helper Functions", function() {

			beforeEach(function() {
				utility = application.serviceFactory.getBean('utility');
			});

			it(
				title="dateMin: Should return the earlier of two dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var result = utility.dateMin(date1, date2);
					
					expect(result).toBe(date1);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin: Should return the earlier date when second is earlier",
				body=function() {
					var date1 = createDate(2026, 1, 20);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMin(date1, date2);
					
					expect(result).toBe(date2);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin: Should handle equal dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMin(date1, date2);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date1, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should return the later of two dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var result = utility.dateMax(date1, date2);
					
					expect(result).toBe(date2);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should return the later date when first is later",
				body=function() {
					var date1 = createDate(2026, 1, 20);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMax(date1, date2);
					
					expect(result).toBe(date1);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should handle equal dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMax(date1, date2);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date1, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin/dateMax: Should preserve date object type (not convert to numeric)",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var minResult = utility.dateMin(date1, date2);
					var maxResult = utility.dateMax(date1, date2);
					
					// Should be dates, not numbers
					expect(isDate(minResult)).toBeTrue();
					expect(isDate(maxResult)).toBeTrue();
					expect(isNumeric(minResult) AND NOT isDate(minResult)).toBeFalse();
					expect(isNumeric(maxResult) AND NOT isDate(maxResult)).toBeFalse();
				}
			);

			it(
				title="dateOnly: Should strip time component from datetime",
				body=function() {
					var datetime = createDateTime(2026, 1, 15, 14, 30, 45);
					var expected = createDate(2026, 1, 15);
					
					var result = utility.dateOnly(datetime);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(expected, 'yyyy-mm-dd'));
					expect(hour(result)).toBe(0);
					expect(minute(result)).toBe(0);
					expect(second(result)).toBe(0);
				}
			);

			it(
				title="dateOnly: Should preserve date object when time is already zero",
				body=function() {
					var date = createDate(2026, 1, 15);
					
					var result = utility.dateOnly(date);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateOnly: Should return date object, not numeric (BoxLang compatibility)",
				body=function() {
					var datetime = createDateTime(2026, 1, 15, 23, 59, 59);
					
					var result = utility.dateOnly(datetime);
					
					// Should be a date, not a number (this is what Fix() would have returned)
					expect(isDate(result)).toBeTrue();
					expect(isNumeric(result) AND NOT isDate(result)).toBeFalse();
				}
			);

			it(
				title="dateOnly: Should handle now() correctly",
				body=function() {
					var currentTime = now();
					
					var result = utility.dateOnly(currentTime);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(currentTime, 'yyyy-mm-dd'));
					expect(hour(result)).toBe(0);
					expect(minute(result)).toBe(0);
				}
			);

			it(
				title="dateArrayMin: Should return the earliest date from an array of dates",
				body=function() {
					var dates = [
						createDate(2026, 4, 15),
						createDate(2026, 4, 10),
						createDate(2026, 4, 20),
						createDate(2026, 4, 5)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-05');
				}
			);

			it(
				title="dateArrayMin: Should return a date object (not a number)",
				body=function() {
					var dates = [
						createDate(2026, 4, 15),
						createDate(2026, 4, 10)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					// Verify it can be used in date operations
					var testAdd = dateAdd('d', 1, result);
					expect(isDate(testAdd)).toBeTrue();
				}
			);

			it(
				title="dateArrayMin: Should handle array with single date",
				body=function() {
					var dates = [createDate(2026, 4, 15)];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-15');
				}
			);

			it(
				title="dateArrayMin: Should work with dates that have time components",
				body=function() {
					var dates = [
						createDateTime(2026, 4, 15, 10, 30, 0),
						createDateTime(2026, 4, 15, 8, 0, 0),
						createDateTime(2026, 4, 15, 14, 45, 0)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					// Should be the 8:00 AM entry
					expect(hour(result)).toBe(8);
					expect(minute(result)).toBe(0);
				}
			);

			it(
				title="dateArrayMin: Should handle dates across different months",
				body=function() {
					var dates = [
						createDate(2026, 5, 1),
						createDate(2026, 3, 15),
						createDate(2026, 4, 20)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-03-15');
				}
			);

			it(
				title="dateArrayMin: Should handle dates across different years",
				body=function() {
					var dates = [
						createDate(2027, 4, 15),
						createDate(2025, 12, 31),
						createDate(2026, 6, 1)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2025-12-31');
				}
			);

			it(
				title="dateArrayMin: Should throw error on empty array",
				body=function() {
					var dates = [];
					var errorThrown = false;
					try {
						utility.dateArrayMin(dates);
					} catch (any e) {
						errorThrown = true;
						expect(e.type).toBe('EmptyArrayException');
					}
					expect(errorThrown).toBeTrue();
				}
			);

		});

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
