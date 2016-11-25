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
			$.event('contentBean',$.getBean('content').loadBy(filename=''));
			$.siteConfig().registerDisplayObjectDir(dir="/muraWRM/requirements/tests/resources/display_objects");

			var response=$.dspObject(object="unit_test_object",objectparams={response="success"});

			it(
		 		title="Should be able to render display object",
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
