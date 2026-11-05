/**
* Regression tests for beanORM.save() on an existing row (UPDATE path).
* The UPDATE's WHERE clause uses :primarykey, which must be bound in the
* query params (https://github.com/MasaCMS/MasaCMS/issues/447).
*/
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		session.siteid = 'default';
		application.serviceFactory.getBean('configBean').registerModelDir(dir="/muraWRM/core/tests/resources/model", siteid="default");
		variables.$ = application.serviceFactory.getBean('$').init('default');
		$.getBean('testWidget').checkSchema();
		$.getBean('testOption').checkSchema();
		variables.widgetIDs = [];
	}

	function afterAll() {
		for (var widgetID in variables.widgetIDs) {
			var widget = $.getBean('testWidget').loadBy(widgetid=widgetID);
			if (widget.exists()) {
				widget.delete();
			}
		}
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

		describe("beanORM.save() on an existing row", function() {

			it("should update the existing row instead of throwing", function() {
				var widget = createSavedWidget('Original Name');

				widget.setName('Updated Name').save();

				expect(widget.hasErrors()).toBeFalse();
				var reloaded = $.getBean('testWidget').loadBy(widgetid=widget.getWidgetID());
				expect(reloaded.getName()).toBe('Updated Name');
			});

			it("should only change the row being saved", function() {
				var target = createSavedWidget('Target Widget');
				var other = createSavedWidget('Other Widget');

				target.setName('Target Widget Updated').save();

				var reloadedOther = $.getBean('testWidget').loadBy(widgetid=other.getWidgetID());
				expect(reloadedOther.getName()).toBe('Other Widget');
				var rs = queryExecute(
					sql = "select widgetid from testwidget where widgetid = :widgetid",
					params = { widgetid: { value: target.getWidgetID(), cfsqltype: "varchar" } }
				);
				expect(rs.recordcount).toBe(1);
			});

		});

	}

	/*********************************** HELPERS ***********************************/

	private any function createSavedWidget(required string name) {
		var widget = $.getBean('testWidget').set({
			name = arguments.name,
			email = 'example@example.com',
			description = 'beanORM update regression test',
			intVar = 1,
			smallintVar = 1,
			floatVar = 1,
			doubleVar = 1,
			dateVar = now()
		}).save();

		arrayAppend(variables.widgetIDs, widget.getWidgetID());
		expect(widget.exists()).toBeTrue();
		return widget;
	}

}
