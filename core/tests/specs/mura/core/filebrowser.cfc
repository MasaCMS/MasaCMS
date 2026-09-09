/**
* Regression tests for the Shared File Pool URL bug (PR #427):
* "Shared file pool URLs generate incorrect paths causing 404 errors".
*
* When a site is configured to share another site's File Pool (Admin > Sites >
* <site> > Sharing Settings > File Pool, i.e. FilePoolID), filebrowser.browse()
* already lists the right *files* - the on-disk lookup resolves via
* settingsBean.getAssetDir()/getFileAssetPath(), which are FilePoolID-aware.
* But the *url* returned for each item was historically built from
* getBaseResourcePath(), which (in at least one branch) ignores FilePoolID and
* falls back to the current site's own siteid - so a sharing site lists someone
* else's files under a URL that 404s in the browser.
*
* These specs need an authenticated ('S2' / super user) session because
* filebrowser.checkPerms() calls permUtility.getModulePerm(), which fails for an
* anonymous session even for the User_Assets resourcePath.
*/
component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid = 'default';

		// A site's FilePoolID always defaults to its own SiteID the moment the
		// bean is populated (see settingsBean.set()), so the pool owner itself is
		// always a valid "no shared pool" example - independent of how any other
		// site's sharing settings happen to be configured.
		variables.ownerSiteID  = 'default';

		// Expected, per this environment's setup, to share ownerSiteID's File Pool
		// (Admin > Sites > test-modules > Sharing Settings, or a direct tsettings
		// edit of FilePoolID). See poolIsShared below - the shared-pool spec is
		// skipped rather than failed when that hasn't been set up.
		variables.pooledSiteID = 'test-modules';

		variables.fixtureDir  = 'filebrowserUnitTestProbe';
		variables.fixtureFile = 'probe.txt';

		// filebrowser's checkPerms()/hasPermission() require an 'S2' (super user)
		// membership. Snapshot the current value so we don't leak state into
		// other specs that run in the same session.
		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
		session.mura.memberships = 'S2';

		variables.$ = application.serviceFactory.getBean('$').init(ownerSiteID);
		variables.settingsManager = $.getBean('settingsManager');

		// The pool owner's physical asset directory - this is the one and only
		// physical location shared by any site whose FilePoolID points at
		// ownerSiteID, regardless of which site's siteid the URL ends up using.
		variables.physicalDir = settingsManager.getSite(ownerSiteID).getAssetDir() & '/assets/' & fixtureDir;

		if( directoryExists(physicalDir) ){
			directoryDelete(physicalDir, true);
		}
		directoryCreate(physicalDir);
		fileWrite(physicalDir & '/' & fixtureFile, 'filebrowser unit test probe file - safe to delete');

		variables.poolIsShared = ( settingsManager.getSite(pooledSiteID).getFilePoolID() eq ownerSiteID );
	}

	function afterAll(){
		session.mura.memberships = variables.originalMemberships;

		if( directoryExists(physicalDir) ){
			directoryDelete(physicalDir, true);
		}
	}

	private function browseFixture(required string siteid){
		var fb = $.getBean('filebrowser');
		return fb.browse(
			siteid=arguments.siteid,
			directory='/#fixtureDir#',
			resourcePath='User_Assets'
		);
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		// NOTE: run() is called by TestBox to collect the suite tree (describe/it)
		// *before* beforeAll() runs, so the "skip" flag below can't rely on
		// anything beforeAll() sets up - it re-derives the same check independently.
		var settingsManager = application.serviceFactory.getBean('$').init('default').getBean('settingsManager');
		var poolIsSharedAtCollectionTime = ( settingsManager.getSite('test-modules').getFilePoolID() eq 'default' );

		describe("filebrowser.browse() - File Pool URL resolution", function(){

			it(
				title="without a shared pool: a site's own browse() returns a url scoped to its own storage",
				body=function(){
					var response = browseFixture(ownerSiteID);

					expect(response.success).toBeTrue();
					expect(response.items).toHaveLength(1);
					expect(response.items[1].url).toInclude('/#ownerSiteID#/');
				}
			);

			it(
				title="with a shared pool: the sharing site's browse() must return the SAME url as the pool owner's, not one built from its own siteid",
				skip=!poolIsSharedAtCollectionTime,
				body=function(){
					var ownerResponse  = browseFixture(ownerSiteID);
					var pooledResponse = browseFixture(pooledSiteID);

					expect(ownerResponse.success).toBeTrue();
					expect(pooledResponse.success).toBeTrue();
					expect(ownerResponse.items).toHaveLength(1);
					expect(pooledResponse.items).toHaveLength(1);

					var ownerURL  = ownerResponse.items[1].url;
					var pooledURL = pooledResponse.items[1].url;

					// The bug: pooledURL was historically built from pooledSiteID's
					// own siteid ("/#pooledSiteID#/assets/...") even though the file
					// physically lives under ownerSiteID's storage - a 404 in the browser.
					expect(pooledURL).notToInclude('/#pooledSiteID#/');
					expect(pooledURL).toBe(ownerURL);
				}
			);

		});

	}

}
