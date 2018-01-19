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
		describe("Testing Content Types", function() {
			var $=application.serviceFactory.getBean('$').init('default');
			$=application.serviceFactory.getBean('$').init('default');
			$.event('contentBean',$.getBean('content').set({
			    title="Unit Test Content",
			    display=1,
			    subtype="UnitTest",
			    body="success"
			}));
			$.event('r',{allow=1,restrict=0,perm="editor"});
			$.event('isOnDisplay',1);
			$.event('crumbData',$.content().getCrumbArray());
			$.getContentRenderer().inject('crumbData',$.event('crumbData'));
			$.siteConfig().registerContentTypeDir(dir="/muraWRM/core/tests/resources/content_types");

			var response=$.dspBody();

			it(
		 		title="Should be able to render custom content types body",
			 	body=function(data) {
				 	expect(data.response ).toBe('success');
				},
				data={
					response=trim(response)
				}
			);

		});

	}

}
