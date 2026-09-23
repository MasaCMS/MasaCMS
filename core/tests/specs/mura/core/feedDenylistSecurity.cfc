/**
* Security Tests for the content feed table denylist.
* Verifies that public content feed parameters cannot be used to join to or
* aggregate over sensitive tables (e.g. tusers), and that the comment-injection
* form of the table name is neutralised. This covers the SQL-injection link of
* the reported unauthenticated RCE chain.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		$ = application.serviceFactory.getBean('$').init('default');
	}

	function afterAll() {
		// Cleanup if needed
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Content feed table denylist", function() {

			it("should reject a feed parameter that references a denied table (tusers)", function() {
				expect(function(){
					$.getBean('Feed').addParam(field="tusers.userid", criteria="x").getIterator();
				}).toThrow(type="authorization");
			});

			it("should reject the comment-injection form of a denied table (tusers--)", function() {
				expect(function(){
					$.getBean('Feed').addParam(field="tusers--.userid", criteria="x").getIterator();
				}).toThrow(type="authorization");
			});

			it("should reject a denied table regardless of case (TUSERS)", function() {
				expect(function(){
					$.getBean('Feed').addParam(field="TUSERS.password", criteria="x").getIterator();
				}).toThrow(type="authorization");
			});

			it("should still allow a legitimate content-table parameter", function() {
				expect(function(){
					$.getBean('Feed').where().prop('type').isEq('File').getIterator();
				}).notToThrow();
			});

		});

	}

}
