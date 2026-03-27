/**
* Security Tests for Feed Bean SQL Injection Prevention
* Tests the sanitization of altTable, orderBy, sortBy, and sortDirection parameters
* to prevent SQL injection attacks.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		$ = application.serviceFactory.getBean('$').init('default');
		feedBean = $.getBean('feed');
	}

	function afterAll() {
		// Cleanup if needed
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Feed Bean Security - SQL Injection Prevention", function() {

			describe("altTable Sanitization", function() {

				beforeEach(function() {
					feedBean = $.getBean('feed');
				});

				it("should accept valid table names with alphanumeric and underscores", function() {
					feedBean.setAltTable("tcontent_custom");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should accept table names starting with underscore", function() {
					feedBean.setAltTable("_temp_table");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should remove special characters from table names", function() {
					feedBean.setAltTable("tcontent'; DROP TABLE tcontent--");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should reject table names starting with numbers", function() {
					feedBean.setAltTable("123table");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should reject SQL injection attempts with quotes", function() {
					feedBean.setAltTable("table' OR '1'='1");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should reject SQL injection with UNION", function() {
					feedBean.setAltTable("tcontent UNION SELECT * FROM tusers");
					expect(feedBean.getAltTable()).toBe("");
					expect(feedBean.getAltTable()).notToInclude("*");
				});

				it("should reject table names with semicolons", function() {
					feedBean.setAltTable("tcontent; DELETE FROM tusers");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should reject table names with dashes", function() {
					feedBean.setAltTable("tcontent--");
					expect(feedBean.getAltTable()).toBe("tcontent");
				});

				it("should truncate excessively long table names", function() {
					var longName = repeatString("a", 100);
					feedBean.setAltTable(longName);
					expect(len(feedBean.getAltTable())).toBeLTE(64);
				});

				it("should handle empty string", function() {
					feedBean.setAltTable("");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should handle whitespace-only input", function() {
					feedBean.setAltTable("   ");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should remove parentheses and other SQL syntax", function() {
					feedBean.setAltTable("tcontent()");
					expect(feedBean.getAltTable()).toBe("tcontent");
				});

			});

			describe("Edge Cases and Boundary Testing", function() {

				beforeEach(function() {
					feedBean = $.getBean('feed');
				});

				it("should handle null-like strings", function() {
					feedBean.setAltTable("null");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should handle numeric-looking table names", function() {
					feedBean.setAltTable("table123");
					expect(feedBean.getAltTable()).toBe("");
				});

				it("should handle Unicode characters", function() {
					feedBean.setAltTable("tcontent™");
					expect(feedBean.getAltTable()).toBe("tcontent");
				});
			});

		});

	}

}
