/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Plugins", function() {

		 	config={
				siteId = "default"
			};

			$=application.serviceFactory.getBean('$').init(config.siteid);
			bean=$.getBean('settingsManager').getSite(config.siteid);

		});

	}

}