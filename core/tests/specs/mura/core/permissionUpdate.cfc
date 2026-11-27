/**
* permUtility.update() and updateGroup() save group permissions on every engine (MASA-472).
*
* The permission fields are named "p" plus the group or content ID without dashes. BoxLang's
* replaceList() leaves the dashes in when the replacement list is empty, so no field matched:
* saving deleted the existing permissions and stored none.
*/
component extends="testbox.system.BaseSpec" {

	function beforeAll() {
		variables.siteID = "default";
		variables.permUtility = application.serviceFactory.getBean("permUtility");

		var $ = application.serviceFactory.getBean("$").init(variables.siteID);

		variables.group = $.getBean("user").set({
			siteID = variables.siteID,
			type = 1,
			groupName = "MASA-472 " & createUUID()
		}).save();

		variables.content = $.getBean("content").set({
			siteID = variables.siteID,
			parentID = "00000000000000000000000000000000001",
			type = "Page",
			title = "MASA-472 " & createUUID(),
			approved = 1
		}).save();
	}

	function afterAll() {
		variables.content.delete();
		variables.group.delete();
	}

	private string function fieldName(required string id) {
		return "p" & replace(arguments.id, "-", "", "all");
	}

	private string function savedPermission() {
		return variables.permUtility.getGroupPerm(
			variables.group.getUserID(),
			variables.content.getContentID(),
			variables.siteID
		);
	}

	private void function updateContent(required string level) {
		var data = { siteID = variables.siteID, contentID = variables.content.getContentID() };
		data[fieldName(variables.group.getUserID())] = arguments.level;
		variables.permUtility.update(data);
	}

	private void function updateGroup(required string level) {
		var data = { siteID = variables.siteID, groupID = variables.group.getUserID() };
		data[fieldName(variables.content.getContentID())] = arguments.level;
		variables.permUtility.updateGroup(data);
	}

	function run() {

		describe("permUtility.update()", function(){

			it("saves each permission level a group can have on content", function(){
				for (var level in ["editor", "author", "read", "deny"]) {
					updateContent(level);
					expect(savedPermission()).toBe(level);
				}
			});

			it("removes the permission when the group inherits it", function(){
				updateContent("editor");
				updateContent("none");
				expect(savedPermission()).toBe("none");
			});

		});

		describe("permUtility.updateGroup()", function(){

			it("saves the permission of a group on content", function(){
				updateGroup("editor");
				expect(savedPermission()).toBe("editor");
			});

		});
	}
}
