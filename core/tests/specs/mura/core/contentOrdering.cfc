/**
* Regression test for PR #415 / topOrBottom="bottom" orderNo assignment.
*
* Bug: contentManager.save() picks the new orderNo for bottom-inserted content by
* selecting max(orderno) as theBottom for the parent, then only assigning
* theBottom + 1 when theBottom is numeric AND not equal to the new bean's own
* (still unsaved) orderNo -- otherwise it falls back to orderNo = 1.
*
* A freshly instantiated contentBean defaults getOrderNo() to 1 (see contentBean.cfc),
* and is not yet persisted at this point (contentDAO.create() runs later in save()).
* So once a parent already has exactly one active child (theBottom == 1), the next
* bottom-inserted sibling's own default orderNo (1) coincidentally equals theBottom,
* the "not equal" check is false, and it falls back to orderNo = 1 again instead of
* 2 -- colliding with the existing child. Every subsequent insert repeats the same
* collision, so every child after the first is stuck at orderNo = 1.
*
* This is currently reproduced via content sync/import (core/mura/publisher.cfc sets
* topOrBottom="bottom" for every imported item), but is just as reachable by adding a
* second item to the bottom of any folder that already has one child.
*
* This spec currently FAILS on the unfixed code and is expected to pass once the
* "not equal to the bean's own orderNo" comparison is removed (PR #415).
*/
component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';

		entityName='content';

		$=application.serviceFactory.getBean('$').init('default');

		// A parentID dedicated to this spec so ordering here can't be polluted by,
		// or pollute, any other content on the site.
		parentID="0000000000000000000orderNoBugParent";

		childIDs=[
			"0000000000000000000orderNoBugChild1",
			"0000000000000000000orderNoBugChild2",
			"0000000000000000000orderNoBugChild3"
		];

		// Clean up any leftovers from a previous, interrupted run.
		for(var id in childIDs){
			var existing=$.getBean(entityName).loadBy(contentid=id);
			if(existing.exists()){
				existing.delete();
			}
		}
	}

	function afterAll(){
		for(var id in childIDs){
			var existing=$.getBean(entityName).loadBy(contentid=id);
			if(existing.exists()){
				existing.delete();
			}
		}
		console( "Executed afterAll() at #now()#" );
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe("Assigning orderNo to new content inserted with topOrBottom='bottom'", function(){

			it(
				title="Should place the first child of an empty parent at orderNo 1",
				body=function(){

					var child=$.getBean(entityName).set({
						title="OrderNo Bug Child 1",
						menutitle="OrderNo Bug Child 1",
						filename="orderno-bug-child-1",
						urltitle="orderno-bug-child-1",
						siteID="default",
						parentID=parentID,
						contentID=childIDs[1],
						type="Page",
						subtype="Default",
						topOrBottom="bottom"
					}).save();

					expect(child.exists()).toBeTrue();
					expect(child.getOrderNo()).toBe(1);
				}
			);

			it(
				title="Should place a second bottom-inserted child after the first, not on top of it",
				body=function(){

					var firstChild=$.getBean(entityName).loadBy(contentid=childIDs[1]);

					var secondChild=$.getBean(entityName).set({
						title="OrderNo Bug Child 2",
						menutitle="OrderNo Bug Child 2",
						filename="orderno-bug-child-2",
						urltitle="orderno-bug-child-2",
						siteID="default",
						parentID=parentID,
						contentID=childIDs[2],
						type="Page",
						subtype="Default",
						topOrBottom="bottom"
					}).save();

					expect(secondChild.exists()).toBeTrue();

					// This is the bug under test: on the unfixed code, secondChild's
					// default orderNo (1) coincidentally matches the parent's current
					// max orderNo (1, from firstChild), so the buggy "neq" check skips
					// re-assignment and secondChild collides with firstChild at 1
					// instead of landing at 2.
					expect(secondChild.getOrderNo()).notToBe(firstChild.getOrderNo());
					expect(secondChild.getOrderNo()).toBe(2);
				}
			);

			it(
				title="Should keep appending sequentially for a third bottom-inserted child",
				body=function(){

					var thirdChild=$.getBean(entityName).set({
						title="OrderNo Bug Child 3",
						menutitle="OrderNo Bug Child 3",
						filename="orderno-bug-child-3",
						urltitle="orderno-bug-child-3",
						siteID="default",
						parentID=parentID,
						contentID=childIDs[3],
						type="Page",
						subtype="Default",
						topOrBottom="bottom"
					}).save();

					expect(thirdChild.exists()).toBeTrue();
					expect(thirdChild.getOrderNo()).toBe(3);
				}
			);

		});

	}

}
