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
		describe("Should be able to use custom eventHandlers", function() {
			application.serviceFactory.getBean('configBean').registerModelDir(dir="/muraWRM/core/tests/resources/model",siteid="default");

			var $=application.serviceFactory.getBean('$').init('default');

			it(
		 		title="Should be able to execute normal events",
			 	body=function(data) {
					arguments.data.$.announceEvent('UnitTestNormal');
				 	expect(arguments.data.$.event('response') ).toBe('success');
				},
				data={
					$=$
				}
			);

			it(
		 		title="Should be able to render custom event",
			 	body=function(data) {
				 	expect(left(trim(arguments.data.$.renderEvent('UnitTestRender')),7)).toBe('success');
				},
				data={
					$=$
				}
			);

		});

	}

}
