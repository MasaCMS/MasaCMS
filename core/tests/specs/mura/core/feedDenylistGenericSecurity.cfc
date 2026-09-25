/**
* Security Tests for the table denylist on the generic entity feed (beanFeed) and the
* user feed (userGateway). These builders are separate from the content feed and were
* hardened so that joins, aggregates, grouping and sorting cannot reference restricted
* tables (including the userid-keyed token tables such as tredirects).
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		$ = application.serviceFactory.getBean('$').init('default');
	}

	function afterAll() {}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("Generic entity feed (beanFeed) table denylist", function() {

			it("rejects an aggregate over a denied table", function() {
				expect(function(){
					$.getFeed('category').aggregate('min','tusers.password').getIterator();
				}).toThrow(type="authorization");
			});

			it("rejects a join parameter referencing a denied table (comment-injection form)", function() {
				expect(function(){
					$.getFeed('category').addParam(field="tusers--.userid", criteria="x").getIterator();
				}).toThrow(type="authorization");
			});

			it("allows a plain category feed", function() {
				expect(function(){
					$.getFeed('category').getIterator();
				}).notToThrow();
			});

		});

		describe("User feed (userGateway) table denylist", function() {

			it("rejects an aggregate over the recovery-token table (tredirects)", function() {
				expect(function(){
					$.getFeed('user').aggregate('min','tredirects.URL').getIterator();
				}).toThrow(type="authorization");
			});

			it("still allows a plain user feed (which sorts on its own tusers table)", function() {
				expect(function(){
					$.getFeed('user').getIterator();
				}).notToThrow();
			});

		});

	}

}
