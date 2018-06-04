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
				 	expect(data.response ).toBe('success1');
				},
				data={
					response=response
				}
			);

			response=$.rbKey('testpropfromsub');

			it(
				title="Should be able to render key from resource_bundles directory in sub module",
				body=function(data) {
					expect(data.response ).toBe('success2');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('layout.contentmanager');

			it(
				title="Should be able to render key from core resource bundles",
				body=function(data) {
					expect(data.response ).toBe('Content');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('globalmodule.mycustomkey');

			it(
				title="Should be able to render key from global modules resource bundles",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('sitemodule.mycustomkey');

			it(
				title="Should be able to render key from site modules resource bundles",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('global.mycustomkey');

			it(
				title="Should be able to render key from root resource bundles",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('thememodule.mycustomkey');

			it(
				title="Should be able to render key from theme module resource bundles",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.rbkey('themeroot.mycustomkey');

			it(
				title="Should be able to render key from theme root resource bundles",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.dspObject(object="global_module_test",objectparams={response="success"});

			it(
				title="Should be able to render global level module",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.dspObject(object="theme_module_test",objectparams={response="success"});

			it(
				title="Should be able to render theme level module",
				body=function(data) {
					expect(data.response ).toBe('success');
				},
				data={
					response=response
				}
			);

			response=$.dspObject(object="site_module_test",objectparams={response="success"});

			it(
				title="Should be able to render site level module",
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
