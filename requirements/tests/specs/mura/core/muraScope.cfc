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
		describe("Testing Variable Access", function() {

		 	structAppend(url,{
				siteId = "default",
				testURLVar="fromurl"
			});

			structAppend(form,{
				testFormVar="fromform"
			});

			var $=application.serviceFactory.getBean('$').init('default');

			it(
		 		title="Should be able to access url variables through EVENT scope",
			 	body=function(data) {
				 	expect(arguments.data.testURLVar).toBe('fromurl');
				},
				data={
					testURLVar=$.event('testURLVar')
				}
			);

			it(
		 		title="Should be able to access form variables through EVENT scope",
			 	body=function(data) {
				 	expect(arguments.data.testFormVar).toBe('fromform');
				},
				data={
					testFormVar=$.event('testFormVar')
				}
			);

			$.event(
				'contentBean',
				$.getBean('content').loadBy(filename='')
			);

			it(
		 		title="Should be able to access content variables through CONTENT scope",
			 	body=function(data) {
				 	expect( len(arguments.data.$.content('title')) ).toBeTrue();
				},
				data={
					$=$
				}
			);

			it(
		 		title="Should be able to access content methods",
			 	body=function(data) {
				 	expect( len(arguments.data.$.getTitle()) ).toBeTrue();
				},
				data={
					$=$
				}
			);


			//This obviously won't pass if you are not logged into Mura
			if($.currentUser().isLoggedIn()){
				it(
			 		title="Should be able to access the current user variables through CURRENTUSER scope",
				 	body=function(data) {
					 	expect( len(arguments.data.$.currentUser('username')) ).toBeTrue();
					},
					data={
						$=$
					}
				);
			}
			it(
		 		title="Should be able to access the rendering methods",
			 	body=function(data) {
				 	expect( len(arguments.data.$.createHREF(filename='test')) ).toBeTrue();
				},
				data={
					$=$
				}
			);

		});

	}

}
