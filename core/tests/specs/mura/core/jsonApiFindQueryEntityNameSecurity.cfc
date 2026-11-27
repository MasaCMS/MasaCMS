/**
* Security regression tests for GHSA-7w25-7h2g-j54c.
*
* An expanded findQuery request could override the feed's entityName through
* params.entityName after the entity authorization check. Feed metadata lookups
* interpolated that name into isDefined(), which on Lucee evaluates bracket
* expressions, so the request could execute arbitrary CFML.
*
* Every probe below embeds a harmless expression that would set a request-scope
* marker if it were ever evaluated. The specs assert the marker is never set and
* that ordinary entity names, columns and expanded filters keep working.
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		variables.$ = application.serviceFactory.getBean('$').init('default');
		variables.apiUtility = application.settingsManager.getSite('default').getApi('json','v1');
	}

	private string function probe(string prefix='entity') {
		return arguments.prefix & "[structInsert(request,'ghsa7w25Probe',1,true)]";
	}

	private boolean function probeHit() {
		return structKeyExists(request, 'ghsa7w25Probe');
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("GHSA-7w25-7h2g-j54c: feed entityName expression evaluation", function() {

			beforeEach(function() {
				structDelete(request, 'ghsa7w25Probe');
			});

			describe("findQuery with expanded params", function() {

				it("ignores a nested params.entityName and never evaluates it", function() {
					var result = apiUtility.findQuery(
						entityName='entity',
						siteid='default',
						params={entityName=probe()},
						queryString='',
						expanded=1
					);

					expect(probeHit()).toBeFalse();
					expect(result).toHaveKey('items');
				});

				it("still applies ordinary expanded filters", function() {
					var result = apiUtility.findQuery(
						entityName='entity',
						siteid='default',
						params={name='content'},
						queryString='',
						expanded=1
					);

					expect(result.items).toHaveLength(1);
				});

			});

			describe("beanFeed routing setters", function() {

				it("does not let addParam change the entityName", function() {
					var feed = $.getBean('entity').getFeed();
					feed.addParam(column='entityName', criteria='user');

					expect(feed.getEntityName()).toBe('entity');
				});

				it("rejects an entityName that is not a valid variable name", function() {
					var feed = $.getBean('entity').getFeed();

					expect(function() {
						feed.setEntityName(probe());
					}).toThrow();
					expect(feed.getEntityName()).toBe('entity');
					expect(probeHit()).toBeFalse();
				});

			});

			describe("beanFeed metadata lookups", function() {

				it("does not evaluate a malicious entityName in hasDiscriminatorColumn, getIsHistorical or hasColumn", function() {
					var feed = $.getBean('entity').getFeed();
					// Bypass setEntityName so the lookups are tested on their own.
					feed.getAllValues().entityName = probe();

					expect(feed.hasDiscriminatorColumn()).toBeFalse();
					expect(feed.getIsHistorical()).toBeFalse();
					expect(feed.hasColumn('name')).toBeFalse();
					expect(probeHit()).toBeFalse();
				});

				it("does not evaluate a malicious column name in hasColumn", function() {
					var feed = $.getBean('entity').getFeed();

					expect(feed.hasColumn(probe('name'))).toBeFalse();
					expect(probeHit()).toBeFalse();
				});

				it("still finds real columns", function() {
					var feed = $.getBean('entity').getFeed();

					expect(feed.hasColumn('name')).toBeTrue();
					expect(feed.hasColumn('doesNotExist')).toBeFalse();
				});

			});

			describe("beanORM.hasColumn", function() {

				it("does not evaluate a malicious column name", function() {
					var entity = $.getBean('entity');

					expect(entity.hasColumn(probe('name'))).toBeFalse();
					expect(probeHit()).toBeFalse();
				});

				it("still finds real columns", function() {
					var entity = $.getBean('entity');

					expect(entity.hasColumn('name')).toBeTrue();
					expect(entity.hasColumn('doesNotExist')).toBeFalse();
				});

			});

			describe("jsonApiUtility.getRelationship", function() {

				it("does not evaluate a malicious entity name", function() {
					var result = apiUtility.getRelationship(from=probe(), to='content');

					expect(result).toBeEmpty();
					expect(probeHit()).toBeFalse();
				});

			});

			describe("contentNavBean accessors", function() {

				it("does not evaluate a malicious property name in getValue", function() {
					var nav = $.getBean('contentNavBean').set({siteID='default'}, '');

					try {
						nav.getValue(probe('title'));
					} catch (any e) {
						// Only the absence of evaluation matters here.
					}
					expect(probeHit()).toBeFalse();
				});

				it("does not evaluate a malicious property name in setValue", function() {
					var nav = $.getBean('contentNavBean').set({siteID='default'}, '');

					try {
						nav.setValue(probe('title'), 'x');
					} catch (any e) {
						// Only the absence of evaluation matters here.
					}
					expect(probeHit()).toBeFalse();
				});

				it("still reads values from the nav struct", function() {
					var nav = $.getBean('contentNavBean').set({menutitle='Nav Title'}, '');

					expect(nav.getValue('menutitle')).toBe('Nav Title');
				});

			});

		});

	}

}
