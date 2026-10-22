/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
		variables.$=application.serviceFactory.getBean('$').init('default');
		variables.createdCategoryIDs=[];
	}

	function afterAll(){
		// Clean up by the IDs this run created; loadBy(filename/name) can return an array when duplicates exist
		for(var categoryID in variables.createdCategoryIDs){
			var bean=variables.$.getBean('category').loadBy(categoryid=categoryID);
			if(bean.exists()){
				bean.delete();
			}
		}
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("Testing persistence", function() {

			// Unique per run so leftovers from an earlier, crashed run can't collide.
			// The filename is derived from the name on save, so it is read back from the saved bean.
			var runID=createUUID();

			variables.config={
				name="My Unit Test #runID#",
				siteID="default",
				remoteID="unit-test-category-#runID#"
			};

		 	it(
		 		title="Should be able to load an empty categoryBean",
			 	body=function() {
				 	expect( variables.$.getBean('category') ).toBeInstanceOf('mura.category.categoryBean');
				}
			);

			it(
				title="Should not exist",
			 	body=function() {
				 	expect( variables.$.getBean('category').loadBy(name=variables.config.name).exists() ).toBeFalse();
				}
			);

			it(
				title="Should be able to save",
			 	body=function() {
					var bean=variables.$.getBean('category').set(variables.config).save();

					if(len(bean.getCategoryID())){
						arrayAppend(variables.createdCategoryIDs,bean.getCategoryID());
					}

					variables.savedCategoryID=bean.getCategoryID();
					variables.savedFilename=bean.getFilename();

				 	expect( structIsEmpty(bean.getErrors()) ).toBeTrue();
				 	expect( bean.exists() ).toBeTrue();
				}
			);

			it(
				title="Should be able to load by categoryid",
		 		body=function() {
			 		var bean=variables.$.getBean('category').loadBy(categoryid=variables.savedCategoryID);
				 	expect( bean.exists() ).toBeTrue();
				 	expect( bean.getName() ).toBe( variables.config.name );
				}
			);

			it(
				title="Should be able to load by filename",
		 		body=function() {
			 		var bean=variables.$.getBean('category').loadBy(filename=variables.savedFilename);
				 	expect( bean.exists() ).toBeTrue();
				 	expect( bean.getCategoryID() ).toBe( variables.savedCategoryID );
				}
			);

		});
	}

	private function isLucee(){
		return ( structKeyExists( server, "lucee" ) );
	}

}
