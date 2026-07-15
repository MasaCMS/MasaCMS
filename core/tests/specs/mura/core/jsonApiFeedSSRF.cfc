/**
* Security regression tests for GHSA-2686-mxpg-p7xx.
*
* processAsyncObject is an unauthenticated JSON API method that copies request
* parameters into display-object params. For the feed display object those params
* can override channelLink/type/isNew/isActive and make the server fetch an
* arbitrary URL (SSRF). filterAsyncFeedParams() strips those trust-state fields
* unless the caller holds the Feeds module permission.
*
* These tests exercise filterAsyncFeedParams() directly. The authorized case uses
* an 'S2' (super user) membership, which getModulePerm short-circuits without a
* database lookup; the unauthenticated case pins memberships to empty so the
* permission evaluates to false deterministically.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.apiUtility = application.settingsManager.getSite('default').getApi('json','v1');

		// Snapshot session membership state so we can simulate different callers
		// without leaking state into other specs.
		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
	}

	function afterAll() {
		session.mura.memberships = variables.originalMemberships;
	}

	private struct function attackerFeedParams() {
		return {
			channelLink = 'http://host.docker.internal:19090/method-param.xml',
			type = 'remote',
			isNew = 0,
			isActive = 1,
			authtype = 'basic',
			maxItems = 1,
			displaySummaries = 'true'
		};
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("JSON API processAsyncObject feed SSRF hardening", function() {

			describe("unauthenticated caller (no Feeds module permission)", function() {

				beforeEach(function() {
					// Anonymous caller: no memberships, so getModulePerm() is false.
					session.mura.memberships = '';
				});

				it("strips channelLink, type, isNew, isActive and authtype from feed params", function() {
					var result = apiUtility.filterAsyncFeedParams('feed', attackerFeedParams(), 'default');

					expect(structKeyExists(result,'channelLink')).toBeFalse("channelLink must be stripped for unauthenticated callers");
					expect(structKeyExists(result,'type')).toBeFalse("type must be stripped");
					expect(structKeyExists(result,'isNew')).toBeFalse("isNew must be stripped");
					expect(structKeyExists(result,'isActive')).toBeFalse("isActive must be stripped");
					expect(structKeyExists(result,'authtype')).toBeFalse("authtype must be stripped");
				});

				it("preserves presentation-only params", function() {
					var result = apiUtility.filterAsyncFeedParams('feed', attackerFeedParams(), 'default');

					expect(structKeyExists(result,'maxItems')).toBeTrue("presentation params must survive");
					expect(structKeyExists(result,'displaySummaries')).toBeTrue("presentation params must survive");
				});

				it("applies to every feed display-object variant that can reach the remote fetch", function() {
					var variants = 'feed,feed_no_summary,feed_slideshow,feed_slideshow_no_summary,feed_table,dragable_feeds';
					for(var variant in listToArray(variants)){
						var result = apiUtility.filterAsyncFeedParams(variant, attackerFeedParams(), 'default');
						expect(structKeyExists(result,'channelLink')).toBeFalse("channelLink must be stripped for object '#variant#'");
						expect(structKeyExists(result,'type')).toBeFalse("type must be stripped for object '#variant#'");
					}
				});

				it("leaves non-feed object params untouched", function() {
					var result = apiUtility.filterAsyncFeedParams('component', attackerFeedParams(), 'default');

					expect(structKeyExists(result,'channelLink')).toBeTrue("non-feed objects are out of scope and unchanged");
					expect(structKeyExists(result,'type')).toBeTrue("non-feed objects are out of scope and unchanged");
				});

				it("returns non-struct params unchanged", function() {
					var result = apiUtility.filterAsyncFeedParams('feed', 'not-a-struct', 'default');

					expect(result).toBe('not-a-struct');
				});

			});

			describe("authorized caller (holds Feeds module permission)", function() {

				beforeEach(function() {
					// Super user: getModulePerm() returns true without a DB lookup.
					session.mura.memberships = 'S2';
				});

				it("retains caller-supplied feed trust-state so the admin preview flow still works", function() {
					var result = apiUtility.filterAsyncFeedParams('feed', attackerFeedParams(), 'default');

					expect(structKeyExists(result,'channelLink')).toBeTrue("authorized callers may override channelLink");
					expect(structKeyExists(result,'type')).toBeTrue("authorized callers may override type");
					expect(structKeyExists(result,'isActive')).toBeTrue("authorized callers may override isActive");
				});

			});

		});

	}

}
