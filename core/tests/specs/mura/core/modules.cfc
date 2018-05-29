/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Display Objects", function() {
			var $=application.serviceFactory.getBean('$').init('default');
			var response='';

			$.event('contentBean',$.getBean('content').loadBy(filename=''));
			$.siteConfig().registerDisplayObjectDir(dir="/muraWRM/core/tests/resources/modules");

			response=$.dspObject(object="unit_test_object",objectparams={response="success"});

			it(
		 		title="Should be able to render display object",
			 	body=function(data) {
				 	expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);


			response=$.dspObject(object="unit_test_object_sub",objectparams={response="success"});

			it(
		 		title="Should be able to render display object registered as sub-module",
			 	body=function(data) {
				 	expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbKey('testprop');

			it(
		 		title="Should be able to render key from resource_bundles directory",
			 	body=function(data) {
				 	expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbKey('testpropfromsub');

			it(
				title="Should be able to render key from resource_bundles directory in sub module",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

		});

	}

}
