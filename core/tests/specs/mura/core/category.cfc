/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		if(isDefined('bean') && bean.exists()){
			bean.delete();
		}
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("Testing persistence", function() {

			config={
				name="My Unit Test",
				siteID="default",
				categoryID="",
				remoteID="remoteID",
				filename="my-unit-test"
			};

			entityName='category';

			$=application.serviceFactory.getBean('$').init(config.siteid);
			
			bean=$.getBean(entityName).loadBy(categoryid=config.categoryid);

			if(bean.exists()){
				bean.delete();
				bean=$.getBean(entityName).loadBy(categoryid=config.categoryid);
			}

		 	it(
		 		title="Should be able to load an empty categoryBean",
			 	body=function() {
			 		bean=$.getBean(entityName);
				 	expect( bean ).toBeInstanceOf('mura.category.categoryBean');
				},
				bean=bean
			);

			it(
				title="Should not exist",
			 	body=function() {
				 	expect(yesNoFormat(bean.exists()) ).toBeFalse();
				},
				bean=bean
			);

			it(
				title="Should be able to save",
			 	body=function() {
				 	expect( bean.set(config).save().exists() ).toBeTrue;
				},
				bean=bean
			);

			loadChecks=['categoryid','filename'];
			
			for(var key in loadChecks){
				args={'#key#'=config[key]};

				it(
					title="Should be able to load by #key#",
			 		body=function() {
				 		bean=$.getBean(entityName).loadBy(argumentCollection=args);
					 	expect( bean.exists() ).toBeTrue();
					},
					entityName=entityName,
					args=args
				);

			}

		});
	}

	private function isLucee(){
		return ( structKeyExists( server, "lucee" ) );
	}

}