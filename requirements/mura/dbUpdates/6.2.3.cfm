<cfscript>
	dbUtility.setTable("tclassextenddatauseractivity")
		.addIndex('baseID,attributeID');
</cfscript>