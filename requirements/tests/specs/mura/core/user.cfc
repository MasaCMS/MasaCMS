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
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing persistence", function() {

		 	config={
				userId = "0655DC32-C8FE-494D-98FC593D387A88BS",
				siteId = "default",
				fname = "Unit",
				lname = "Test",
				username = "unitTest",
				remoteid = "unit-test-remote-user-id",
				email = "unitTest2@email.com",
				type = 2
			};

			entityName='user';
			entityClass='mura.user.userBean';

			$=application.serviceFactory.getBean('$').init(config.siteid);
			$.getBean(entityName).loadBy(userid=config.userid).delete();
			bean=$.getBean(entityName);

		 	it(
		 		title="Should be able to load an empty userBean",
			 	body=function(data) {
				 	expect( arguments.data.bean ).toBeInstanceOf(arguments.data.entityClass);
				},
				data={
					bean=bean,
					entityClass=entityClass
				}
			);

			/*
			it(
				title="Should not exist",
			 	body=function(data) {
				 	expect( arguments.data.bean.getIsNew() ).toBeTrue();
				},
				data={
					bean=bean
				}
			);
			*/

			bean.set(config).save();

			it(
				title="Should be able to save",
			 	body=function(data) {
				 	expect( structIsEmpty(arguments.data.bean.getErrors()) ).toBeTrue();
				},
				data={
					bean=bean
				}
			);


			loadChecks=['userid','remoteid','username'];

			for(var key in loadChecks){
				args={'#key#'=config[key]};

				bean=$.getBean(entityName).loadBy(argumentCollection=args);

				it(
					title="Should be able to load by #key#",
			 		body=function(data) {
					 	expect( arguments.data.bean.exists() ).toBeTrue();
					},
					data={
						bean=bean
					}
				);

			}

			var objInstance=evaluate('bean.getMembershipsIterator()');
			it(
				title='user.getMembershipsIterator() should return valid object',
				body=function(data){
					expect(
						(right(getMetaData(arguments.data.objInstance).fullname,len('iterator'))=='iterator')
						).toBeTrue();
				},
				data={objInstance=objInstance}
			);

			objInstance=evaluate('bean.getInterestGroupsIterator()');
			it(
				title='user.getInterestGroupsIterator() should return valid object',
				body=function(data){
					expect(
						(right(getMetaData(arguments.data.objInstance).fullname,len('iterator'))=='iterator')
						).toBeTrue();
				},
				data={objInstance=objInstance}
			);

			objInstance=evaluate('bean.getAddressesIterator()');
			it(
				title='user.getAddressesIterator() should return valid object',
				body=function(data){
					expect(
						(right(getMetaData(arguments.data.objInstance).fullname,len('iterator'))=='iterator')
						).toBeTrue();
				},
				data={objInstance=objInstance}
			);
		});

	}

}
