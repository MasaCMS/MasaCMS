<cfscript>
  dbUtility.dropTable(table="trazunasettings");

  // Remember-me tokens: beanORM creates the table and columns. The indexes use raw SQL because
  // dbUtility.addIndex() can't create unique or composite indexes, or choose the index name.
  getBean("rememberMeToken").checkSchema();
  dbUtility.purgeCache();

  rememberMeIndexNames="";
  for ( rememberMeIndex in dbUtility.indexes("tremembertokens") ) {
    rememberMeIndexNames=listAppend(rememberMeIndexNames,rememberMeIndex.name);
  }

  if ( !listFindNoCase(rememberMeIndexNames,"UQ_tremembertokens_selector") ) {
    queryExecute("CREATE UNIQUE INDEX UQ_tremembertokens_selector ON tremembertokens (selector)");
  }
  if ( !listFindNoCase(rememberMeIndexNames,"IX_tremembertokens_user_site") ) {
    queryExecute("CREATE INDEX IX_tremembertokens_user_site ON tremembertokens (userID, siteID)");
  }
  if ( !listFindNoCase(rememberMeIndexNames,"IX_tremembertokens_expiry") ) {
    queryExecute("CREATE INDEX IX_tremembertokens_expiry ON tremembertokens (expires, lastused)");
  }

  dbUtility.purgeCache();
</cfscript>
