/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing persistence", function() {

		 	config={
				siteId = "default",
				site = "Unit Test Site",
				domain = "localhost"
			};

			$=application.serviceFactory.getBean('$').init(config.siteid);
			bean=$.getBean('settingsManager').getSite(config.siteid);

			it(
				title="Should exist",
			 	body=function(data) {
				 	expect( arguments.data.bean.exists() ).toBeTrue();
				},
				data={
					bean=bean
				}
			);

		});

	}

}
