<cfscript>
    getBean('entity').checkSchema();

    getBean('content').registerAsEntity();
    getBean('user').registerAsEntity();
		getBean('group').registerAsEntity();
		getBean('address').registerAsEntity();
		getBean('changeset').registerAsEntity();
		getBean('feed').registerAsEntity();
		getBean('category').registerAsEntity();
		getBean('contentCategoryAssign').registerAsEntity();
		getBean('file').registerAsEntity();
		getBean('changesetCategoryAssignment').registerAsEntity();
		getBean('comment').registerAsEntity();
		getBean('stats').registerAsEntity();
    getBean('site').registerAsEntity();
</cfscript>
