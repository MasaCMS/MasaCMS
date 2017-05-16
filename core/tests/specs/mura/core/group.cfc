/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){}

	function afterAll(){
		if(isDefined('variables.bean') && variables.bean.exists()){
			variables.bean.delete();
		}
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing persistence", function() {

		 	config={
				userid = "0655DC32-C8FE-494D-98FC593D387A88XX",
				siteId = "default",
				groupname='unit test group',
				remoteid = "unit-test-remote-group-id",
				email = "unitTest1@email.com",
				type = 1
			};

			entityName='user';
			entityClass='mura.user.userBean';

			$=application.serviceFactory.getBean('$').init(config.siteid);
			$.getBean(entityName).loadBy(userid=config.userid).delete();
			variables.bean=$.getBean(entityName);

		 	it(
		 		title="Should be able to load an empty userBean",
			 	body=function(data) {
				 	expect( arguments.data.bean ).toBeInstanceOf(arguments.data.entityClass);
				},
				data={
					bean=variables.bean,
					entityClass=entityClass
				}
			);

			/*
			it(
				title="Should not exist",
			 	body=function(data) {
				 	expect( arguments.data.bean.getIsNew()).toBeTrue();
				},
				data={
					bean=variables.bean,
					config=config
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

			loadChecks=['userid','remoteid','groupname'];

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

			args={groupid=config['userid']};

			bean=$.getBean(entityName).loadBy(argumentCollection=args);

			it(
				title="Should be able to load by groupid",
		 		body=function(data) {
				 	expect( arguments.data.bean.exists() ).toBeTrue();
				},
				data={
					bean=bean
				}
			);


			var objInstance=evaluate('bean.getMembersIterator()');
			it(
				title='group.getMembersIterator() should return valid object',
				body=function(data){
					expect(
						(right(getMetaData(arguments.data.objInstance).fullname,len('iterator'))=='iterator')
						).toBeTrue();
				},
				data={objInstance=objInstance}
			);


		});



		$.getBean('group').loadBy(groupid='0655DC32-C8FE-494D-98FC593D387A88XX').delete();
	}

}
