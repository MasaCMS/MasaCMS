/**
* getCalendarItems() receives its range as date strings from the calendar's JSON API (MASA-475).
*
* It used to compare the end and start dates with Fix(). Lucee and ACF convert a date string
* to a number there, BoxLang doesn't: "Can't cast [2025-01-20] to a Number."
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		session.siteid = 'default';
		variables.$ = application.serviceFactory.getBean('$').init('default');
		variables.runID = createUUID();

		variables.calendar = createContent(
			name = "calendar",
			type = "Calendar",
			parentID = "00000000000000000000000000000000001"
		);
		variables.early = createEvent("early", createDate(2025, 1, 13));
		variables.late = createEvent("late", createDate(2025, 1, 27));
	}

	function afterAll() {
		// Deleting the calendar also deletes the events under it
		var bean = variables.$.getBean('content').loadBy(contentid=variables.calendar.getContentID());
		if (bean.exists()) {
			bean.delete();
		}
	}

	private function createContent(required string name, required string type, required string parentID, struct properties={}) {
		var title = "Calendar Spec #arguments.name# #variables.runID#";
		var data = {
			title: title,
			menutitle: title,
			filename: "calendar-spec-#arguments.name#-#variables.runID#",
			urltitle: "calendar-spec-#arguments.name#-#variables.runID#",
			siteID: "default",
			parentID: arguments.parentID,
			type: arguments.type,
			approved: "1"
		};
		structAppend(data, arguments.properties);
		return variables.$.getBean('content').set(data).save();
	}

	// A one hour event on the given day
	private function createEvent(required string name, required date day) {
		return createContent(
			name = arguments.name,
			type = "Page",
			parentID = variables.calendar.getContentID(),
			properties = {
				display: 2,
				displayStart: dateAdd('h', 10, arguments.day),
				displayStop: dateAdd('h', 11, arguments.day)
			}
		);
	}

	// The content IDs of the calendar items in the range, in display order
	private array function getItemIDs(required string start, string end='') {
		var rs = variables.$.getCalendarUtility().getCalendarItems(
			calendarid = variables.calendar.getContentID(),
			siteid = 'default',
			start = arguments.start,
			end = arguments.end,
			categoryid = '',
			tag = ''
		);
		var ids = [];
		for (var row in rs) {
			arrayAppend(ids, row.contentid);
		}
		return ids;
	}

	function run() {

		describe("getCalendarItems() with date strings", function(){

			it("returns the items between the start and end date", function(){
				expect(getItemIDs('2025-01-01', '2025-01-20')).toBe([variables.early.getContentID()]);
			});

			it("keeps an end date on the same day as the start date", function(){
				// Extending the range to the end of the month would return the late event
				expect(getItemIDs('2025-01-14', '2025-01-14')).toBe([]);
			});

			it("runs to the end of the start month when the end date is before the start date", function(){
				expect(getItemIDs('2025-01-20', '2025-01-01')).toBe([variables.late.getContentID()]);
			});

			it("runs to the end of the start month without an end date", function(){
				expect(getItemIDs('2025-01-1')).toBe([variables.early.getContentID(), variables.late.getContentID()]);
			});

		});
	}

}
