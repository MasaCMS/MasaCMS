<cfscript>
	dbUtility.setTable("tsessiontracking")
	.addColumn(column="fname",datatype="varchar",length=50)
	.addColumn(column="lname",datatype="varchar",length=50)
	.addColumn(column="company",datatype="varchar",length=100);

	dbUtility.setTable("tcontentfeeds")
	.addColumn(column="contentpoolid",datatype="text");
</cfscript>
