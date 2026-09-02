/**
* Security Tests for the shared ORM loader's orderby handling
* Tests that beanORM.loadBy()'s orderby argument is validated through
* utility.validateSort() rather than concatenated raw into SQL, closing
* the injection primitive behind GHSA-hxq8-42mv-9gjf.
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

		describe("beanORM.loadBy() Security - orderby validation", function() {

			describe("Regression Tests - Ensure Normal Functionality", function() {

				it("should still load by a real property with a plain orderby", function() {
					var entity = $.getBean('entity').loadBy(entityid=createUUID(),orderby="name");
					expect(entity).toBeInstanceOf("mura.bean.beanEntity");
				});

				it("should still load by a real property with an explicit direction", function() {
					var entity = $.getBean('entity').loadBy(entityid=createUUID(),orderby="name desc");
					expect(entity).toBeInstanceOf("mura.bean.beanEntity");
				});

				it("should still fall back to the bean's declared static orderby when none is supplied", function() {
					var entity = $.getBean('entity').loadBy(entityid=createUUID());
					expect(entity).toBeInstanceOf("mura.bean.beanEntity");
				});

			});

			describe("Real-World Attack Scenarios", function() {

				it("should reject a time-based blind SQL injection payload", function() {
					expect(function(){
						$.getBean('entity').loadBy(entityid=createUUID(),orderby="(select sleep(1))");
					}).toThrow();
				});

				it("should reject stacked-query style payloads", function() {
					expect(function(){
						$.getBean('entity').loadBy(entityid=createUUID(),orderby="name; DROP TABLE tentity--");
					}).toThrow();
				});

				it("should reject UNION-based injection attempts", function() {
					expect(function(){
						$.getBean('entity').loadBy(entityid=createUUID(),orderby="name) UNION SELECT * FROM tusers--");
					}).toThrow();
				});

				it("should reject quote-based injection attempts", function() {
					expect(function(){
						$.getBean('entity').loadBy(entityid=createUUID(),orderby="name' OR '1'='1");
					}).toThrow();
				});

			});

		});

	}

}
