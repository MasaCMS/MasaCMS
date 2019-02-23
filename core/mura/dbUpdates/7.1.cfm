<cfscript>
    getBean('entity').checkSchema();
    dbUtility.setTable("tsettings")
    .addColumn(column="scaffolding",dataType="int");

    dbUtility.setTable("tclustercommands").addIndex("created");

		dbUtility.setTable('tcontentrelated').addIndex("relatedContentSetID");

		try{
			dbUtility.setTable('tcontentfeeditems').addPrimaryKey('feedID,itemID');
		} catch(Any e){
			writeLog(serializeJSON(e));
		}

		try{
				dbUtility.setTable('tformresponsequestions').addPrimaryKey('responseID,formID,formfield');
		} catch(Any e){
			writeLog(serializeJSON(e));
		}
		try{
			dbUtility.setTable('tpermissions').addPrimaryKey('ContentID,GroupID,SiteID,Type');
		} catch(Any e){
			writeLog(serializeJSON(e));
		}

</cfscript>

<cfquery name="rsCheck">
	select siteID from tsettings where siteid not in(
		select siteid from tcontent where type='Module' and moduleID='00000000000000000000000000000000016'
	)
</cfquery>

<cfif rsCheck.recordcount>
	<cfloop query="rsCheck">
		<cfquery>
		INSERT INTO tcontent
		(
			SiteID
			,ModuleID
			,ParentID
			,ContentID
			,ContentHistID
			,Type
			,subType
			,Active
			,Title
      ,Display
			,Approved
			,IsNav
			,forceSSL
		) VALUES  (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheck.siteid#">
			,'00000000000000000000000000000000016'
			,'00000000000000000000000000000000END'
			,'00000000000000000000000000000000016'
			,'#createUUID()#'
			,'Module'
			,'default'
			,1
			,'Mura ORM Scaffolding'
			,1
			,1
			,1
			,0
		)
		</cfquery>
	</cfloop>
</cfif>

<cfscript>
try{
	dbUtility.setTable('tcontent')
		.addPrimaryKey('TContent_ID')
		.addIndex('ContentID')
		.addIndex('ContentHistID')
		.addIndex('SiteID')
		.addIndex('ParentID')
		.addIndex('RemoteID')
		.addIndex('ModuleID')
		.addIndex('changesetID')
		.addIndex('mobileExclude');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentstats')
		.addPrimaryKey('contentID,siteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentassignments')
		.addPrimaryKey('contentID,contentHistID,siteID,userID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentcategories')
		.addPrimaryKey('categoryID')
		.addIndex('siteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentcategoryassign')
		.addPrimaryKey('contentHistID,categoryID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentcomments')
		.addPrimaryKey('commentid')
		.addIndex('contentid');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentfeedadvancedparams')
		.addPrimaryKey('paramID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentfeeds')
		.addPrimaryKey('feedID')
		.addIndex('siteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentobjects')
		.addPrimaryKey('ContentHistID,ObjectID,Object,ColumnID')
		.addIndex('SiteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentratings')
		.addPrimaryKey('contentID,userID,siteID')
		.addIndex('entered');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentrelated')
		.addPrimaryKey('contentHistID,relatedID,contentID,siteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('temails')
		.addPrimaryKey('EmailID')
		.addIndex('siteid');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tfiles')
		.addPrimaryKey('fileID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tformresponsepackets')
		.addPrimaryKey('ResponseID')
		.addIndex('FormID,SiteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tredirects')
		.addPrimaryKey('redirectID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tuseraddresses')
		.addPrimaryKey('addressID')
		.addIndex('longitude')
		.addIndex('latitude')
		.addIndex('userID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tusers')
		.addPrimaryKey('userID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tusersfavorites')
		.addPrimaryKey('favoriteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tusersinterests')
		.addPrimaryKey('userID,categoryID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tusersmemb')
		.addPrimaryKey('UserID,GroupID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontentpublicsubmissionapprovals')
		.addPrimaryKey('contentID,siteID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tcontenttags')
		.addPrimaryKey('tagID')
		.addIndex('contentHistID')
		.addIndex('siteID')
		.addIndex('contentID')
		.addIndex('tag');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tuserstags')
		.addPrimaryKey('tagID')
		.addIndex('userID')
		.addIndex('siteID')
		.addIndex('tag');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tclassextenddatauseractivity')
		.addPrimaryKey('dataID')
		.addIndex('baseID')
		.addIndex('attributeID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tclassextenddata')
		.addPrimaryKey('dataID')
		.addIndex('baseID')
		.addIndex('attributeID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tclassextend')
		.addPrimaryKey('subTypeID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tclassextendattributes')
		.addPrimaryKey('attributeID')
		.addIndex('extendSetID');
} catch(Any e){
	writeLog(serializeJSON(e));
}

try{
	dbUtility.setTable('tclassextendsets')
		.addPrimaryKey('extendSetID')
		.addIndex('subTypeID');
} catch(Any e){
	writeLog(serializeJSON(e));
}
</cfscript>
