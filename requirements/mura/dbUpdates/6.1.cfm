<cfscript>
	getBean('approvalChain').checkSchema();
	getBean('approvalChainMembership').checkSchema();
	getBean('approvalRequest').checkSchema();
	getBean('approvalAction').checkSchema();
	getBean('approvalChainAssignment').checkSchema();
	getBean('changesetRollBack').checkSchema();
	getBean('contentSourceMap').checkSchema();
	getBean('relatedContentSet').checkSchema();
	getBean('fileMetaData').checkSchema();
	getBean('file').checkSchema();


	dbUtility.setTable("tclassextend")
	.addColumn(column="iconclass",dataType="varchar",length="50");

	dbUtility.setTable("tsettings")
	.addColumn(column="contentApprovalScript",dataType="longtext")
	.addColumn(column="contentRejectionScript",dataType="longtext");

	dbUtility.setTable('temails')
	.addColumn(column='template',dataType='varchar');

	dbUtility.setTable("tchangesets")
	.addColumn(column="closeDate",dataType="datetime");

	dbUtility.setTable("tcontent")
	.addIndex('filename')
	.addIndex('title')
	.addIndex('subtype')
	.addIndex('isnav');
	
	// drop primary key before adding relatedContentID
	if (!dbUtility.setTable("tcontentrelated").columnExists("relatedContentID")) {
		try{
			dbUtility.setTable("tcontentrelated").dropPrimaryKey();
		} catch (e any){}
	}
	
	dbUtility.setTable("tcontentrelated")
	.addColumn(column="relatedContentSetID",dataType="varchar",length="35")
	.addColumn(column="orderNo",dataType="int")
	.addColumn(column="relatedContentID",autoincrement=true)
	.addPrimaryKey('relatedContentSetID');

	dbUtility.setTable("tcontentcategories")
	.addColumn(column="isfeatureable",dataType="int")
	.addIndex('name')
	.addIndex('urltitle')
	.addIndex('parentid')
	.addIndex('filename');
	
	dbUtility.setTable("tsettings")
	.addColumn(column="enableLockdown",datatype="varchar",length=255)
	.addColumn(column="ExtranetPublicRegNotify",datatype="varchar",length=255)
	.addColumn(column="customTagGroups",datatype="varchar",length=255)
	.addColumn(column="siteid",datatype="varchar",length=25,nullable=false,default='')
	.addPrimaryKey('siteid');

	dbUtility.setTable("tcontenttags")
	.addColumn(column="taggroup",datatype="varchar",length=255);

	dbUtility.setTable("tcontentfeeds")
	.addColumn(column="useCategoryIntersect",dataType="int");

	dbUtility.setTable('tcontentcategoryassign')
	.addIndex('contentID')
	.addIndex('categoryID');

</cfscript>