/**
* Security regression tests for the unauthenticated remote-feed SSRF.
*
* processAsyncObject is an unauthenticated JSON API method that copies request
* parameters into display-object params. For a remote feed those params can
* override channelLink/type/isNew/isActive/authtype and make the server fetch an
* arbitrary URL (SSRF).
*
* The guard is feedManager.filterRemoteFeedParams(), called at the single place
* that can reach the remote fetch: the feedBean.set(objectparams) in
* core/modules/v1/feed/index.cfm. Because the guard sits at that sink and does
* not key off the display-object name or the param encoding, it closes every
* entry point (object=feed, object=collection with sourcetype=remotefeed, custom
* display objects, and double-URL-encoded objectparams) with one check. This
* replaces an earlier object-name-based filter, which was bypassable via
* object=collection and via JSON-string params.
*
* The unit suite exercises filterRemoteFeedParams() directly. The integration
* suite renders the display objects through $.dspObject() with
* feedManager.getRemoteFeedData() swapped for a recording stub, so it asserts
* that no fetch happens without needing outbound network access, and it fails
* if the guard is ever removed from the feed module.
*
* The authorized case uses an 'S2' (super user) membership, which getModulePerm
* short-circuits without a database lookup; the unauthenticated case pins
* memberships to empty so the Feeds permission evaluates to false
* deterministically.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.feedManager = application.serviceFactory.getBean('feedManager');

		// Snapshot session membership state so we can simulate different callers
		// without leaking state into other specs.
		param name="session.mura" default={};
		param name="session.mura.memberships" default="";
		variables.originalMemberships = session.mura.memberships;
	}

	function afterAll() {
		session.mura.memberships = variables.originalMemberships;
	}

	// Replace the remote fetch on the feedManager singleton with a stub that
	// records the requested URL instead of making an HTTP request.
	private void function stubRemoteFetch() {
		request.ssrfFetchedURLs = [];
		variables.originalGetRemoteFeedData = feedManager.getRemoteFeedData;
		feedManager.getRemoteFeedData = function(feedURL) {
			arrayAppend(request.ssrfFetchedURLs, arguments.feedURL);
			return {maxItems = 0};
		};
	}

	private void function restoreRemoteFetch() {
		feedManager.getRemoteFeedData = variables.originalGetRemoteFeedData;
	}

	// Render a display object the way processAsyncObject does once params are
	// parsed: through $.dspObject(), with params as a struct or a JSON string.
	private string function renderObject(required string object, required any params) {
		var $ = application.serviceFactory.getBean('$').init('default');
		$.event('contentBean', $.getBean('content').loadBy(filename=''));
		// Public visitor's permission on the page, as set on a front-end request.
		$.event('r', {perm = 'none', restrict = 0, allow = 1});
		return $.dspObject(object=arguments.object, params=arguments.params, cacheKey=createUUID());
	}

	private struct function remoteFeedPayload(required string channelLink) {
		return {
			sourcetype = 'remotefeed',
			type = 'remote',
			isNew = 0,
			isActive = 1,
			maxitems = 2,
			channelLink = arguments.channelLink
		};
	}

	// Trust-state fields an attacker needs to turn a feed into an outbound fetch,
	// plus presentation-only fields that must survive for normal rendering.
	private struct function attackerFeedParams() {
		return {
			channelLink = 'http://host.docker.internal:19090/method-param.xml',
			type = 'remote',
			isNew = 0,
			isActive = 1,
			authtype = 'basic',
			siteid = 'evil',
			feedid = '00000000000000000000000000000000099',
			maxItems = 1,
			displaySummaries = 'true'
		};
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("feedManager.filterRemoteFeedParams (remote feed SSRF guard)", function() {

			describe("unauthenticated caller (no Feeds module permission)", function() {

				beforeEach(function() {
					// Anonymous caller: no memberships, so getModulePerm() is false.
					session.mura.memberships = '';
				});

				it("strips every feed trust-state field", function() {
					var result = feedManager.filterRemoteFeedParams(attackerFeedParams(), 'default');

					expect(structKeyExists(result,'channelLink')).toBeFalse("channelLink must be stripped for unauthenticated callers");
					expect(structKeyExists(result,'type')).toBeFalse("type must be stripped");
					expect(structKeyExists(result,'isNew')).toBeFalse("isNew must be stripped");
					expect(structKeyExists(result,'isActive')).toBeFalse("isActive must be stripped");
					expect(structKeyExists(result,'authtype')).toBeFalse("authtype must be stripped");
					expect(structKeyExists(result,'siteid')).toBeFalse("siteid must be stripped");
					expect(structKeyExists(result,'feedid')).toBeFalse("feedid must be stripped");
				});

				it("preserves presentation-only params", function() {
					var result = feedManager.filterRemoteFeedParams(attackerFeedParams(), 'default');

					expect(structKeyExists(result,'maxItems')).toBeTrue("presentation params must survive");
					expect(structKeyExists(result,'displaySummaries')).toBeTrue("presentation params must survive");
				});

				it("does not modify the caller's params struct", function() {
					var params = attackerFeedParams();
					feedManager.filterRemoteFeedParams(params, 'default');

					expect(structKeyExists(params,'channelLink')).toBeTrue("the filter must work on a copy");
				});

			});

			describe("authorized caller (holds Feeds module permission)", function() {

				beforeEach(function() {
					// Super user: getModulePerm() returns true without a DB lookup.
					session.mura.memberships = 'S2';
				});

				it("retains caller-supplied feed trust-state so the admin preview flow still works", function() {
					var result = feedManager.filterRemoteFeedParams(attackerFeedParams(), 'default');

					expect(structKeyExists(result,'channelLink')).toBeTrue("authorized callers may override channelLink");
					expect(structKeyExists(result,'type')).toBeTrue("authorized callers may override type");
					expect(structKeyExists(result,'isActive')).toBeTrue("authorized callers may override isActive");
				});

			});

		});

		describe("remote feed rendering through dspObject (SSRF integration)", function() {

			beforeEach(function() {
				stubRemoteFetch();
			});

			afterEach(function() {
				restoreRemoteFetch();
			});

			describe("unauthenticated caller", function() {

				beforeEach(function() {
					session.mura.memberships = '';
				});

				it("does not fetch for object=collection with struct params", function() {
					renderObject('collection', remoteFeedPayload('http://ssrf.invalid/collection-struct.xml'));

					expect(request.ssrfFetchedURLs).toBeEmpty("collection must not fetch a caller-supplied channelLink");
				});

				it("does not fetch for object=collection with JSON-string params", function() {
					renderObject('collection', serializeJSON(remoteFeedPayload('http://ssrf.invalid/collection-json.xml')));

					expect(request.ssrfFetchedURLs).toBeEmpty("JSON-string params must not bypass the guard");
				});

				it("does not fetch for object=feed with JSON-string params", function() {
					renderObject('feed', serializeJSON(remoteFeedPayload('http://ssrf.invalid/feed-json.xml')));

					expect(request.ssrfFetchedURLs).toBeEmpty("object=feed must not fetch a caller-supplied channelLink");
				});

				it("does not fetch when remotefeed is written with a JSON unicode escape", function() {
					var params = replace(serializeJSON(remoteFeedPayload('http://ssrf.invalid/feed-escaped.xml')), 'remotefeed', 'remote\u0066eed');

					renderObject('collection', params);

					expect(request.ssrfFetchedURLs).toBeEmpty("an escaped sourcetype must not bypass the guard");
				});

			});

			describe("authorized caller (control)", function() {

				beforeEach(function() {
					session.mura.memberships = 'S2';
				});

				it("fetches the caller-supplied channelLink, proving the stub sees real fetches", function() {
					renderObject('collection', remoteFeedPayload('http://ssrf.invalid/admin-preview.xml'));

					expect(request.ssrfFetchedURLs).toBe(['http://ssrf.invalid/admin-preview.xml']);
				});

			});

		});

	}

}
