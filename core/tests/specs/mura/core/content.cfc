/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';

		config={
			title="My Unit Test",
			menutitle="My Unit Testing Calendar",
			filename="my-unit-test",
			urltitle="my-unit-test",
			siteID="default",
			parentID="00000000000000000000000000000000001",
			contentID="0000000000000000000000000000000test",
			type="Page",
			subtype="Default",
			remoteID="remoteIDforUnitTest"
		};

		entityName='content';
		entityClass='mura.content.contentBean';

		$=application.serviceFactory.getBean('$').init(config.siteid);

		bean=$.getBean(entityName).loadBy(contentid=config.contentid);

		if(bean.exists()){
			bean.delete();
			bean=$.getBean(entityName).loadBy(contentid=config.contentid);
		}

		bean=$.getBean(entityName);

	}

	function afterAll(){
		$.getBean('content').loadBy(contentid=config.contentid).delete();
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing persistence", function() {
		 	it(
		 		title="Should be able to load an empty contentBean",
			 	body=function() {
				 	expect( bean ).toBeInstanceOf(entityClass);
				}
			);

			it(
				title="Should not exist",
			 	body=function() {
				 	expect(yesNoFormat(bean.exists()) ).toBeFalse();
				}
			);

			it(
				title="Should be able to save",
			 	body=function() {
				 	expect( bean.set(config).save().exists() ).toBeTrue();
				}
			);



			describe("Loading Tests", function() {

				it(
					title="Should be able to load by contentid",
			 		body=function() {
						var loadArgs={
							contentid=config.contentid
						};

				 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
					 	expect( bean.exists() ).toBeTrue();

					}
				);

				it(
					title="Should be able to load by remoteid",
			 		body=function() {
						var loadArgs={
							remoteid=config.remoteid
						};

				 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
					 	expect( bean.exists() ).toBeTrue();

					}
				);

				it(
					title="Should be able to load by filename",
			 		body=function() {
						var loadArgs={
							filename=config.filename
						};

				 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
					 	expect( bean.exists() ).toBeTrue();

					}
				);

				it(
					title="Should be able to load by title",
			 		body=function() {
						var loadArgs={
							title=config.title
						};

				 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
					 	expect( bean.exists() ).toBeTrue();
					}
				);

				it(
					title="Should be able to load by urltitle",
			 		body=function() {
						var loadArgs={
							urltitle=config.urltitle
						};

				 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
					 	expect( bean.exists() ).toBeTrue();

					}
				);

			});

			if(application.mura.getBean('settingsManager').getSite('default').getCache()){
				describe("Cache Tests", function() {
					it(
						title="Should be able to load by contentid from cache",
				 		body=function() {
							var loadArgs={
								contentid=config.contentid
							};

					 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
						 	expect( bean.getFromMuraCache() ).toBeTrue();
						}
					);

					it(
						title="Should be able to load by remoteid from cache",
				 		body=function() {
							var loadArgs={
								remoteid=config.remoteid
							};

					 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
						 	expect( bean.getFromMuraCache() ).toBeTrue();

						}
					);

					it(
						title="Should be able to load by filename from cache",
				 		body=function() {
							var loadArgs={
								filename=config.filename
							};

					 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
						 	expect( bean.getFromMuraCache() ).toBeTrue();

						}
					);

					it(
						title="Should be able to load by title from cache",
				 		body=function() {
							var loadArgs={
								title=config.title
							};

					 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
						 	expect( bean.getFromMuraCache() ).toBeTrue();
						}
					);

					it(
						title="Should be able to load by urltitle from cache",
				 		body=function() {
							var loadArgs={
								urltitle=config.urltitle
							};

					 		var bean=$.getBean(entityName).loadBy(argumentCollection=loadArgs);
						 	expect( bean.getFromMuraCache() ).toBeTrue();


						}
					);

					//#2904
					it(
						title="Should be add param on field that exists in tcontent and tparent",
				 		body=function() {
							try{
					 			var it=$.getBean('Feed').where().prop('type').isEq('File').getIterator();
								expect( 1 ).toBeTrue();
							} catch (Any e){
									expect( 0 ).toBeTrue();
							}
						}
					);
				});
			}

		});

	}

}
