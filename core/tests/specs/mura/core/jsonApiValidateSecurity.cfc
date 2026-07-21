/**
* Security Tests for JSON API validate() Method
* Tests that data.loadby cannot be used to reach beanORM.loadBy()'s internal
* control arguments (orderby, returnFormat, cachedWithin), which was the root
* cause of GHSA-hxq8-42mv-9gjf (unauthenticated SQL injection via
* POST /index.cfm/_api/json/v1/{siteid}/?method=validate with
* data.loadby=orderby).
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		$ = application.serviceFactory.getBean('$').init('default');
		apiUtility = $.siteConfig().getApi('json','v1');
	}

	function afterAll() {
		// Cleanup if needed
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("JSON API validate() Security - loadby denylist", function() {

			it("should reject loadby=orderby (the confirmed SQL injection vector)", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="orderby",
						orderby="(select sleep(1))",
						fields="name"
					}, siteId="default");
				}).toThrow(type="invalidParameters");
			});

			it("should reject loadby=orderby with a benign value too", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="orderby",
						orderby="name",
						fields="name"
					}, siteId="default");
				}).toThrow(type="invalidParameters");
			});

			it("should reject loadby=returnFormat", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="returnFormat",
						returnFormat="query",
						fields="name"
					}, siteId="default");
				}).toThrow(type="invalidParameters");
			});

			it("should reject loadby=cachedWithin", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="cachedWithin",
						cachedWithin="1",
						fields="name"
					}, siteId="default");
				}).toThrow(type="invalidParameters");
			});

			it("should reject denylisted loadby values regardless of case", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="OrderBy",
						orderby="name",
						fields="name"
					}, siteId="default");
				}).toThrow(type="invalidParameters");
			});

			it("should still allow a real property as loadby", function() {
				expect(function(){
					apiUtility.validate(data={
						siteid="default",
						bean="entity",
						loadby="entityid",
						entityid=createUUID(),
						fields="name"
					}, siteId="default");
				}).notToThrow();
			});

		});

	}

}
