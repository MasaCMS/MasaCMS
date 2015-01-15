<cfcomponent extends="mura.cfobject" output="false">
	<cfset variables.table="">

	<cfset variables.tableLookUp=structNew()>
	<cfset variables.tableMetaDataLookUp=structNew()>
	<cfset variables.tableIndexLookUp=structNew()>
	<cfset variables.dbSchema = "">

<cffunction name="init" output="false">
		<cfargument name="configBean">
		<cfargument name="utility">
		<cfset variables.utility=arguments.utility>
		<cfset variables.configBean=arguments.configBean>
		<cfset variables.dbtype=variables.configBean.getDbType()>

		<cfset purgeCache()>
		<cfreturn this>
</cffunction>

<cffunction name="purgeCache" output="false">
	<cfset variables.tableLookUp=structNew()>
	<cfset variables.tableMetaDataLookUp=structNew()>
	<cfset variables.tableIndexLookUp=structNew()>
</cffunction>

<cffunction name="version" output="false">
	<cfset var rscheck="">

	<cfdbinfo
		name="rsCheck"
		type="version">

	<cfreturn variables.utility.queryRowToStruct(rscheck,1)>
</cffunction>

<!------------- TABLE ----------------->
<cffunction name="setTable" output="false">
	<cfargument name="table">
	<cfset variables.table=arguments.table>
	<cfreturn this>
</cffunction>

<cffunction name="dropTable" output="false">
	<cfargument name="table" default="#variables.table#">

	<cfif tableExists(arguments.table)>
		<cfquery>
			DROP TABLE #arguments.table#
		</cfquery>
		<cfset structDelete(variables.tableLookUp,arguments.table)>
		<cfset structDelete(variables.tableMetaDataLookUp,arguments.table)>
		<cfset structDelete(variables.tableIndexLookUp,arguments.table)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="tableExists" output="false">
	<cfargument name="table" default="#variables.table#">

	<cfif not structKeyExists(variables.tableLookUp,arguments.table) or variables.tableLookUp[arguments.table] eq false>
		<cfset variables.tableLookUp[arguments.table]=structKeyExists(tables(),arguments.table)>
	</cfif>
	<cfreturn variables.tableLookUp[arguments.table]>
</cffunction>

<cffunction name="tables" output="false">
	<cfset var rscheck="">
	<cfset var tableStruct={}>

	<cfif variables.dbtype eq 'postgresql'>
		<cfquery name="rscheck" >
			select table_name from information_schema.tables where table_schema = current_schema()
		</cfquery>
	<cfelseif variables.dbtype neq 'oracle'>
		<cfdbinfo
			name="rsCheck"
			type="tables">

			<!---
			<cfif variables.dbtype eq "nuodb">
				<cfquery name="rscheck" dbtype="query">
					select tablename as table_name from rscheck
				</cfquery>
			</cfif>
			--->

	<cfelse>
		<cfquery name="rscheck">
			select TABLE_NAME from user_tables
		</cfquery>
	</cfif>

	<cfloop query="rscheck">
		<cfset tableStruct[rsCheck.table_name]=variables.utility.queryRowToStruct(rsCheck,rsCheck.currentRow)>
	</cfloop>

	<cfreturn tableStruct>
</cffunction>


<!----------------- COLUMNS ----------------->

<cffunction name="columns" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rs ="">

	<cfif not structKeyExists(variables.tableMetaDataLookUp,arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="oracle">
				<cfquery
				name="rs">
					SELECT column_name,
					data_length column_size,
					data_type type_name,
					data_default column_default_value,
					nullable is_nullable,
					 data_precision
					FROM user_tab_cols
					WHERE table_name=UPPER('#arguments.table#')
			</cfquery>
			</cfcase>
			<!---
			<cfcase value="nuodb">
				<cfquery
				name="rs"
				datasource="#variables.datasource#"
				username="#variables.dbusername#"
				password="#variables.dbpassword#">
					SELECT field ,
					length,
					datatype ,
					defaultvalue,
					1  is_nullable,
					precision
					FROM system.fields
					WHERE tablename='#ucase(arguments.table)#'
			</cfquery>
			<cfquery
				name="rs"
				dbtype="query">
					SELECT field column_name,
					length column_size,
					datatype type_name,
					defaultvalue column_default_value,
					is_nullable,
					precision data_precision
					FROM rs
			</cfquery>
			</cfcase>
			--->
			<cfcase value="mssql">
			<cfquery
				name="rs">
					select column_name,
					character_maximum_length column_size,
					data_type type_name,
					column_default column_default_value,
					is_nullable,
					numeric_precision data_precision
					from INFORMATION_SCHEMA.COLUMNS
					where TABLE_NAME='#arguments.table#'
			</cfquery>
			</cfcase>
			<cfdefaultcase>
				<cfdbinfo
				name="rs"
				table="#qualifySchema(arguments.table)#"
				type="columns">
			</cfdefaultcase>
		</cfswitch>

		<cfset variables.tableMetaDataLookUp[arguments.table]=transformColumnMetaData(rs,arguments.table)>
	</cfif>

	<cfreturn variables.tableMetaDataLookUp[arguments.table]>
</cffunction>

<cffunction name="dropColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfif columnExists(arguments.column,arguments.table)>
	<cfswitch expression="#variables.dbtype#">
		<cfcase value="mssql">
			<cfquery>
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="mysql,nuodb">
			<cfquery>
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="postgresql">
			<cfquery>
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery>
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfset structDelete(variables.tableMetaDataLookUp,arguments.table)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="addColumn" output="false">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int,float,double">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var existing=structNew()>
	<cfset var hasTable=tableExists(arguments.table)>

	<cfif arguments.autoincrement>
		<cfset arguments.datatype="int">
		<cfset arguments.nullable=false>
	</cfif>

	<cfif hasTable>
		<cfset existing=columnMetaData(arguments.column,arguments.table)>
	<cfelse>
		<cfset existing=getDefaultColumnMetaData()>
	</cfif>

	<cfif arguments.datatype eq "any">
		<cfset arguments.datatype="varchar">
	</cfif>

	<cfif len(existing.column)
			and (existing.dataType neq arguments.datatype
			and not arguments.autoincrement
			or (
				listFindNoCase("char,varchar",arguments.datatype)
				and arguments.length neq existing.length
				)
			or existing.nullable neq arguments.nullable
			or existing.default neq arguments.default
			)
		>
			<cftry>
			<cfset alterColumn(argumentCollection=arguments)>
			<cfcatch>
			<!---
			<cfdump var="#existing#">
			<cfdump var="#arguments#">
			<cfdump var="#cfcatch#">
			<cfabort>
			--->
			</cfcatch>
			</cftry>

	<cfelseif not hasTable or not len(existing.column)>

		<cfswitch expression="#variables.dbtype#">
		<cfcase value="mssql">
			<cfquery>
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD
				</cfif>

				#arguments.column#
				<cfif arguments.autoincrement>
					INT PRIMARY KEY IDENTITY
				<cfelse>
					#transformDataType(arguments.datatype,arguments.length)#
					<cfif not arguments.nullable> not null </cfif>
					<cfif not(not arguments.nullable and arguments.default eq 'null')>
						default
						<cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>
							#arguments.default#
						<cfelse>
								'#arguments.default#'
						</cfif>
					</cfif>
				</cfif>

				<cfif not hasTable>) ON [PRIMARY]</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery>
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD COLUMN
				</cfif>

				#arguments.column#

				<cfif arguments.autoincrement>
					INT(10) NOT NULL AUTO_INCREMENT
				<cfelse>
					#transformDataType(arguments.datatype,arguments.length)#
					<cfif not arguments.nullable> not null </cfif>
					<cfif not(not arguments.nullable and arguments.default eq 'null')>
						default
						<cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>
							#arguments.default#
						<cfelse>
							'#arguments.default#'
						</cfif>
					</cfif>
				</cfif>

				<cfif not hasTable>
					<cfif version().database_productname neq 'h2'>
						<cfif arguments.autoincrement>
							,PRIMARY KEY(#arguments.column#)
						</cfif>
						)

						ENGINE=#variables.configBean.getMySQLEngine()# DEFAULT CHARSET=utf8
					<cfelse>
						)
					</cfif>
				<cfelseif version().database_productname neq 'h2'>
				 	 <cfif arguments.autoincrement>
					 	, ADD PRIMARY KEY (#arguments.column#)
					</cfif>
				</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="postgresql">
			<cfquery>
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
						#arguments.column#
						<cfif arguments.autoincrement>SERIAL<cfelse>#transformDataType(arguments.datatype,arguments.length)#</cfif> <cfif not arguments.nullable>NOT NULL</cfif>
						<cfif not arguments.autoincrement>
							<cfif not(not arguments.nullable and arguments.default eq 'null')>
								DEFAULT
								<cfif arguments.default eq 'null' or listFindNoCase('int,smallint',arguments.datatype)>
									#arguments.default#
								<cfelse>
									'#arguments.default#'
								</cfif>
							</cfif>
						</cfif>
					)
				<cfelse>
					ALTER TABLE #arguments.table# ADD COLUMN #arguments.column# <cfif arguments.autoincrement>SERIAL<cfelse>#transformDataType(arguments.datatype,arguments.length)#</cfif>;
					<cfif not arguments.nullable>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# SET NOT NULL;
					</cfif>
					<cfif not arguments.autoincrement>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# SET DEFAULT <cfif arguments.default eq 'null' or listFindNoCase('int,smallint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>;
					</cfif>
				</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="nuodb">
			<cfquery>
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD COLUMN
				</cfif>

				#arguments.column#
				<cfif arguments.autoincrement>
					integer generated always as identity (seq_#arguments.table#)
				<cfelse>
					#transformDataType(arguments.datatype,arguments.length)#
					<cfif not arguments.nullable> not null </cfif>
					<cfif not(not arguments.nullable and arguments.default eq 'null')>
						default
						<cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>
							#arguments.default#
						<cfelse>
							'#arguments.default#'
						</cfif>
					</cfif>
				</cfif>
				<cfif not hasTable>
					<cfif arguments.autoincrement>
						,PRIMARY KEY(#arguments.column#)
					</cfif>
					)
				</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery>
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD <cfif variables.dbtype eq "ORACLE">(</cfif>
				</cfif>

				#arguments.column# #transformDataType(arguments.datatype,arguments.length)#
				<cfif not(not arguments.nullable and arguments.default eq 'null')>
					default
					<cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>
						#arguments.default#
					<cfelse>
						'#arguments.default#'
					</cfif>
				</cfif>

				<cfif not hasTable or variables.dbtype eq "ORACLE">)</cfif>

				<cfif arguments.datatype eq "longtext">
					lob (#arguments.column#) STORE AS (
					TABLESPACE #variables.configBean.getDbTablespace()# ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
					NOCACHE LOGGING
					STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
					PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
				</cfif>

			</cfquery>

			<cftry>
				<cfif not arguments.nullable>
					<cfquery>
						ALTER TABLE #arguments.table# MODIFY (#arguments.column# NOT NULL ENABLE)
					</cfquery>
				<cfelse>
					<cfquery>
						ALTER TABLE #arguments.table# MODIFY (#arguments.column# NOT NULL DISABLE)
					</cfquery>
				</cfif>
				<cfcatch></cfcatch>
			</cftry>

			<cfif arguments.autoincrement>
				<cfset var seq_name=left('seq_#arguments.table#_#arguments.column#',30)>
				<cfset var trg_name=left('trg_#arguments.table#_#arguments.column#',30)>

				<cftry>
				 <cfquery>
					DROP SEQUENCE #seq_name#
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>

				<cfquery>
					CREATE SEQUENCE #seq_name#
					MINVALUE 1
					START WITH 1
					INCREMENT BY 1
					CACHE 10
				</cfquery>
				<cfquery>
					create or replace TRIGGER #trg_name# BEFORE INSERT ON #arguments.table#
					FOR EACH ROW
					BEGIN
					    SELECT  #seq_name#.NEXTVAL INTO :new.#arguments.column# FROM DUAL;
					END;
				</cfquery>
				<cfquery>
					ALTER TRIGGER #trg_name# ENABLE
				</cfquery>
				<cfset addPrimaryKey(argumentCollection=arguments)>
			</cfif>
		</cfcase>
		</cfswitch>

		<cfset structDelete(variables.tableMetaDataLookUp,arguments.table)>

		<!--- if we just added the table, update the tableLookUp--->
		<cfif not hasTable>
			<cfset variables.tableLookUp[arguments.table] = true>
		</cfif>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="alterColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int,float,double">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var tempName="">

	<cfif arguments.autoincrement>
		<cfset arguments.datatype="int">
		<cfset arguments.nullable=false>
	</cfif>

	<cfif arguments.datatype eq "any">
		<cfset arguments.datatype="varchar">
	</cfif>

	<cfif tableExists(arguments.table) and columnExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql">
				<cfquery>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null <cfelse> null </cfif>
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery>
					ALTER TABLE #arguments.table#
					<cfif version().database_productname eq 'H2'>
						ALTER
					<cfelse>
						MODIFY
					</cfif>

					COLUMN #arguments.column#
					<cfif arguments.autoincrement>
						INT(10) NOT NULL AUTO_INCREMENT
					<cfelse>
						#transformDataType(arguments.datatype,arguments.length)#
						<cfif not arguments.nullable> not null </cfif>
						<cfif not(not arguments.nullable and arguments.default eq 'null')>
							default
							<cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>
								#arguments.default#
							<cfelse>
								'#arguments.default#'
							</cfif>
						</cfif>
					</cfif>
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# TYPE <cfif arguments.autoincrement>SERIAL<cfelse>#transformDataType(arguments.datatype,arguments.length)#</cfif>;
					<cfif not arguments.nullable>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# SET NOT NULL;
					</cfif>
					<cfif not arguments.autoincrement and not(not arguments.nullable and arguments.default eq 'null')>
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# SET DEFAULT <cfif arguments.default eq 'null' or listFindNoCase('int,smallint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>;
					</cfif>
				</cfquery>
			</cfcase>
			<cfcase value="nuodb">
				<cftransaction>
					<cfset tempName="F" & left(hash(arguments.column),15)>
					<cfif columnExists(table=arguments.table,column=tempName)>
						<cfset dropColumn(table=arguments.table,column=tempName)>
					</cfif>
					<cfquery>
						ALTER TABLE #arguments.table# ADD COLUMN #tempName# #transformDataType(arguments.datatype,arguments.length)# <cfif arguments.autoincrement>integer generated always as identity (seq_#arguments.table#)<cfelse><cfif not arguments.nullable> not null </cfif>
						<cfif not(not arguments.nullable and arguments.default eq 'null')>
							default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
						</cfif>
					</cfquery>
					<cfquery>
						UPDATE #arguments.table# set #tempName#=#arguments.column#
					</cfquery>
					<cftry>
						<cfquery>
						ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
					</cfquery>
					<cfcatch><cfdump var="#cfcatch#" abort></cfcatch>
					</cftry>

					<cfquery>
						ALTER TABLE #arguments.table# ADD COLUMN #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif arguments.autoincrement>integer generated always as identity (seq_#arguments.table#)<cfelse><cfif not arguments.nullable> not null </cfif>
						<cfif not(not arguments.nullable and arguments.default eq 'null')>
							default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
						</cfif>
					</cfquery>
					<cfquery>
						UPDATE #arguments.table# set #arguments.column#=#tempName#
					</cfquery>
					<cfquery>
						ALTER TABLE #arguments.table# DROP COLUMN #tempName#
					</cfquery>
				</cftransaction>
			</cfcase>
			<cfcase value="oracle">
				<cftransaction>
					<cfset tempName="F" & left(hash(arguments.column),15)>
					<cfif columnExists(table=arguments.table,column=tempName)>
						<cfset dropColumn(table=arguments.table,column=tempName)>
					</cfif>
					<cfquery>
						ALTER TABLE #arguments.table# RENAME COLUMN #arguments.column# to #tempName#
					</cfquery>
					<cfquery>
						ALTER TABLE #arguments.table# ADD #arguments.column# #transformDataType(arguments.datatype,arguments.length)#
						<cfif not(not arguments.nullable and arguments.default eq 'null')>
							default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>
						</cfif>
					</cfquery>

					<cftry>
						<cfif not arguments.nullable>
							<cfquery>
								ALTER TABLE #arguments.table# MODIFY (#arguments.column# NOT NULL ENABLE)
							</cfquery>
						<cfelse>
							<cfquery>
								ALTER TABLE #arguments.table# MODIFY (#arguments.column# NOT NULL DISABLE)
							</cfquery>
						</cfif>
						<cfcatch></cfcatch>
					</cftry>

					<cfquery>
						UPDATE #arguments.table# SET #arguments.column#=#tempName#
					</cfquery>
					<cfquery>
						ALTER TABLE #arguments.table# DROP COLUMN #tempName#
					</cfquery>
				</cftransaction>
			</cfcase>
		</cfswitch>

		<cfset structDelete(variables.tableMetaDataLookUp,arguments.table)>
	<cfelse>
		<cfset addColumn(argumentCollection=arguments)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="renameColumn" output="false">
	<cfargument name="column">
	<cfargument name="newcolumn">
	<cfargument name="table" default="#variables.table#">
	<cfset var columnData={}>
	<cfset var columnDataAdjusted={}>

	<cfif tableExists(arguments.table) and columnExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql">
				<cfquery>
					EXEC sp_rename '#arguments.table#.[#arguments.column#]', '#arguments.newcolumn#', 'COLUMN'
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfset columnData=columnMetaData(argumentCollection=arguments)>
				<cfquery>
					ALTER TABLE #arguments.table# change #arguments.column# #arguments.newcolumn# <cfif columnData.autoincrement>INT(10) NOT NULL AUTO_INCREMENT<cfelse>#transformDataType(columnData.datatype,columnData.length)# <cfif not columnData.nullable> not null </cfif> default <cfif columnData.default eq 'null' or listFindNoCase('int,tinyint',columnData.datatype)>#columnData.default#<cfelse>'#columnData.default#'</cfif></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
					ALTER TABLE #arguments.table# RENAME COLUMN #arguments.column# TO #arguments.newcolumn#
				</cfquery>
			</cfcase>
			<cfcase value="nuodb">
				<cfset columnData=columnMetaData(argumentCollection=arguments)>
				<cfset columnDataAdjusted=structCopy(columnData)>
				<cfset columnDataAdjusted.column=columnData.newcolumn >
				<cfset columnDataAdjusted.table=arguments.table >
				<cfset addColumn(argumentCollection=columnDataAdjusted)>

				<cfquery>
					update #arguments.table# set #arguments.column# = #arguments.newColumn#
				</cfquery>

				<cfquery>
					alter table drop column #arguments.column#
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery>
					ALTER TABLE #arguments.table# RENAME COLUMN #arguments.column# to #arguments.newColumn#
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="transformDataType" access="private">
	<cfargument name="datatype" default="varchar">
	<cfargument name="length" default="50">
	<cfset var MSSQLversion=0>

	<cfswitch expression="#variables.dbtype#">
		<cfcase value="mssql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar,string">
					<cfreturn "nvarchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int,integer">
					<cfreturn "int">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "tinyint">
				</cfcase>
				<cfcase value="boolean">
+					<cfreturn "bit">
+				</cfcase>
				<cfcase value="date,datetime,timestamp">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text,longtext">
					<cftry>
						<cfquery name="MSSQLversion">
							SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) as version
						</cfquery>
						<cfset MSSQLversion=listFirst(MSSQLversion.version,".")>
						<cfcatch></cfcatch>
					</cftry>

					<cfif not MSSQLversion>
						<cfquery name="MSSQLversion">
							EXEC sp_MSgetversion
						</cfquery>

						<cftry>
							<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>
							<cfcatch>
								<cfset MSSQLversion=mid(MSSQLversion.COMPUTED_COLUMN_1,1,find(".",MSSQLversion.COMPUTED_COLUMN_1)-1)>
							</cfcatch>
						</cftry>
					</cfif>

					<cfif MSSQLversion neq 8>
						<cfreturn "[nvarchar](max)">
					<cfelse>
						<cfreturn "[ntext]">
					</cfif>
				</cfcase>
				<cfcase value="float,numeric">
					<cfreturn "float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "Decimal">
				</cfcase>
				<cfcase value="blob">
					<cfreturn "varbinary">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="mysql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar,string">
					<cfreturn "varchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int,integer">
					<cfreturn "int(10)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "tinyint">
				</cfcase>
				<cfcase value="boolean">
					<cfreturn "tinyint(1)">
				</cfcase>
				<cfcase value="date,datetime,timestamp">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text">
					<cfreturn "text">
				</cfcase>
				<cfcase value="longtext">
					<cfreturn "longtext">
				</cfcase>
				<cfcase value="float,numeric">
					<cfreturn "float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "double">
				</cfcase>
				<cfcase value="blob">
					<cfreturn "longblob">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="postgresql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar,string">
					<cfreturn "varchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char,bpchar">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int,integer,int4">
					<cfreturn "integer">
				</cfcase>
				<cfcase value="tinyint,int2">
					<cfreturn "smallint">
				</cfcase>
				<cfcase value="date,datetime,timestamp">
					<cfreturn "timestamp">
				</cfcase>
				<cfcase value="text">
					<cfreturn "text">
				</cfcase>
				<cfcase value="longtext">
					<cfreturn "text">
				</cfcase>
				<cfcase value="float,numeric">
					<cfreturn "real">
				</cfcase>
				<cfcase value="double">
					<cfreturn "double precision">
				</cfcase>
				<cfcase value="blob">
					<cfreturn "bytea">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="nuodb">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar,string">
					<cfreturn "varchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int,integer">
					<cfreturn "integer">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "smallint">
				</cfcase>
				<cfcase value="date,datetime,timestamp">
					<cfreturn "timestamp">
				</cfcase>
				<cfcase value="text">
					<cfreturn "clob">
				</cfcase>
				<cfcase value="longtext">
					<cfreturn "clob">
				</cfcase>
				<cfcase value="float,numeric">
					<cfreturn "float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "double">
				</cfcase>
				<cfcase value="blob">
					<cfreturn "blob">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="oracle">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar,string">
					<cfreturn "varchar2(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int,integer">
					<cfreturn "number(10,0)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "number(3,0)">
				</cfcase>
				<cfcase value="boolean">
					<cfreturn "number(1,0)">
				</cfcase>
				<cfcase value="date,datetime,timestamp">
					<cfreturn "date">
				</cfcase>
				<cfcase value="text,longtext">
					<cfreturn "clob">
				</cfcase>
				<cfcase value="float,numeric">
					<cfreturn "binary_float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "binary_double">
				</cfcase>
				<cfcase value="blob">
					<cfreturn "blob">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfdefaultcase>
			<cfthrow type="muraorm" message="Unrecognized ORM dbtype #arguments.datatype#. Valid dbtypes are mssqlm mysql, postgresql, nuodb, oracle." />
		</cfdefaultcase>
	</cfswitch>
	<cfthrow type="muraorm" message="Unrecognized ORM datatype #arguments.datatype#. Valid datatypes are varchar, string, char,int, integer, tinyint, boolean, date, datetime, timestamp, text, longtext, float, numeric, double, blob." />
</cffunction>

<cffunction name="columnExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">

	<cfreturn structKeyExists(columns(arguments.table),arguments.column)>

</cffunction>

<cffunction name="transformColumnMetaData" access="private" output="false">
<cfargument name="rs">
<cfargument name="table">
	<cfset var columnsStruct={}>
	<cfset var columnArgs={}>

	<cfset var defaultArgs=getDefaultColumnMetaData()>

	<cfloop query="arguments.rs">
		<cfset columnArgs=structCopy(defaultArgs)>
		<cfset columnArgs.column=arguments.rs.column_name>
		<cfset columnArgs.table=arguments.table>

		<cfswitch expression="#arguments.rs.type_name#">
			<cfcase value="varchar,nvarchar,varchar2">
				<!--- Add MSSQL nvarchar(max)--->
				<cfset columnArgs.datatype="varchar">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="char,bpchar">
				<cfset columnArgs.datatype="char">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="int,integer,int4">
				<cfset columnArgs.datatype="int">
			</cfcase>
			<cfcase value="number">
				<cfif arguments.rs.data_precision eq 3>
					<cfset columnArgs.datatype="tinyint">
				<cfelse>
					<cfset columnArgs.datatype="int">
				</cfif>
			</cfcase>
			<cfcase value="tinyint,smallint,int2">
				<cfset columnArgs.datatype="tinyint">
			</cfcase>
			<cfcase value="date,datetime,timestamp">
				<cfset columnArgs.datatype="datetime">
			</cfcase>
			<cfcase value="ntext,longtext,clob,nclob">
				<cfset columnArgs.datatype="longtext">
			</cfcase>
			<cfcase value="text">
				<cfset columnArgs.datatype="text">
			</cfcase>
			<cfcase value="float,binary_float">
				<cfset columnArgs.datatype="float">
			</cfcase>
			<cfcase value="double,decimal,binary_double">
				<cfset columnArgs.datatype="double">
			</cfcase>
			<cfcase value="blob,longblob,bytea,varbinary">
				<cfset columnArgs.datatype="blob">
			</cfcase>
		</cfswitch>

		<cfif columnArgs.datatype eq 'blob' or arguments.rs.is_nullable eq "y" or (isBoolean(arguments.rs.is_nullable) and arguments.rs.is_nullable)>
			<cfset columnArgs.nullable=true>
		<cfelse>
			<cfset columnArgs.nullable=false>
		</cfif>

		<cfif isdefined('arguments.rs.column_default_value') and not (columnArgs.nullable and not len(arguments.rs.column_default_value))>
			<cfset columnArgs.default=arguments.rs.column_default_value>
		</cfif>

		<cfif len(columnArgs.default)
			and listFindNoCase("tinyint,int,float,double",columnArgs.datatype)
			and not (
						isNumeric(columnArgs.default)
						and columnArgs.default neq "null")
			>
			<cfset columnArgs.default=_parseInt(columnArgs.default)>
		</cfif>

		<cfif variables.dbtype eq 'nuodb' and len(columnArgs.default) gte 2>
			<cfif left(columnArgs.default,1) eq "'">
				<cfset columnArgs.default=right(columnArgs.default,len(columnArgs.default)-1)>
			</cfif>
			<cfif right(columnArgs.default,1) eq "'">
				<cfif len(columnArgs.default) eq 1>
					<cfset columnArgs.default="">
				<cfelse>
					<cfset columnArgs.default=left(columnArgs.default,len(columnArgs.default)-1)>
				</cfif>
				<cfset columnArgs.default=mid(columnArgs.default,2,len(columnArgs.default)-1)>
			</cfif>
		</cfif>

		<cfif listFindNoCase("tinyint,int,float,double",columnArgs.datatype) and not (isNumeric(columnArgs.default) or columnArgs.default eq 'null')>
			<cfif columnArgs.nullable>
				<cfset columnArgs.default='null'>
			<cfelse>
				<cfset columnArgs.default=0>
			</cfif>
		</cfif>

		<cfif not columnArgs.nullable and columnArgs.datatype eq "int" and isDefined('rs.is_primarykey') and arguments.rs.is_primarykey>
			<cfset columnArgs.autoincrement=true>
		</cfif>

		<cfset columnsStruct["#columnArgs.column#"]=columnArgs>
	</cfloop>

	<cfreturn columnsStruct>

</cffunction>

<cffunction name="columnMetaData" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var columnsStruct=columns(arguments.table)>

	<cfif structKeyExists(columnsStruct,arguments.column)>
		<cfreturn columnsStruct[arguments.column]>
	</cfif>

	<cfreturn getDefaultColumnMetaData()>
</cffunction>

<cffunction name="getDefaultColumnMetaData" output="false">
	<cfreturn {
				column="",
				table="",
				datatype="varchar",
				default="null",
				nullable=true,
				autoincrement=false,
				length=50
				}>
</cffunction>

<!---------------- INDEXES --------------------------->
<cffunction name="addIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfset var rsCheck="">

	<cfif not indexExists(arguments.column,arguments.table)>
		<cftry>
			<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql,nuodb">
				<cfquery>
				CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery>
				CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
				CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery>
				CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
				</cfquery>
			</cfcase>
			</cfswitch>
		<cfcatch></cfcatch>
		</cftry>
		<cfset structDelete(variables.tableIndexLookUp,arguments.table)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="dropIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfif indexExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql">
				<cfquery>
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery>
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="oracle,nuodb">
				<cfquery>
				DROP INDEX #transformIndexName(argumentCollection=arguments)#
				</cfquery>
			</cfcase>
		</cfswitch>

		<cfset structDelete(variables.tableIndexLookUp,arguments.table)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="transformIndexName" access="public">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql,mysql,postgresql,nuodb">
				<cfreturn rereplace(replace("IX_#arguments.table#_#arguments.column#",",","ALL"),"[[:space:]]","","All")>
			</cfcase>
			<cfcase value="oracle">
				<cfreturn rereplace(replace(right("IX_#arguments.table#_#arguments.column#",30),",","ALL"),"[[:space:]]","","All")>
			</cfcase>
		</cfswitch>
</cffunction>

<cffunction name="indexes" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rs="">

	<cfif not structKeyExists(variables.tableIndexLookUp,arguments.table)>
	<cfdbinfo
		name="rs"
		table="#qualifySchema(arguments.table)#"
		type="index">
	<cfset variables.tableIndexLookUp[arguments.table]= buildIndexMetaData(rs,arguments.table)>
	</cfif>

	<cfreturn variables.tableIndexLookUp[arguments.table]>
</cffunction>

<cffunction name="buildIndexMetaData" access="private" output="false">
	<cfargument name="rs">
	<cfargument name="table">
	<cfset var index={}>
	<cfset var indexArray=[]>

 	<cfif rs.recordcount>
		<cfloop query="rs">
			<cfset index={table=arguments.table,
					column=rs.column_name,
					name=rs.index_name
					}>
			<cfif not isBoolean(rs.NON_UNIQUE) or not rs.NON_UNIQUE>
				<cfset index.unique=false>
			<cfelse>
				<cfset index.unique=true>
			</cfif>
			<cfset arrayAppend(indexArray,index)>
		</cfloop>
	</cfif>
	<cfreturn indexArray>
</cffunction>

<cffunction name="indexExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var indexArray=indexes(arguments.table)>
	<cfset var i="">
	<cfif arrayLen(indexArray)>
		<cfloop from="1" to="#arrayLen(indexArray)#" index="i">
			<cfif indexArray[i].column eq arguments.column>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="indexMetaData" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var indexArray=indexes(arguments.table)>
	<cfset var i="">

	<cfif arrayLen(indexArray)>
		<cfloop from="1" to="#arrayLen(indexArray)#" index="i">
			<cfif indexArray[i].column eq arguments.column>
				<cfreturn indexArray[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn structNew()>
</cffunction>

<!--------- PRIMARY KEY -------------------->
<cffunction name="primaryKeyExists" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo
		name="rsCheck"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like '%primary%'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
		or lower(rsCheck.INDEX_NAME) like '%_pkey'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="primaryKeyConstraintName" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo
		name="rsCheck"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like 'primary%'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
		or lower(rsCheck.INDEX_NAME) like '%_pkey'
	</cfquery>

	<cfreturn rsCheck.INDEX_NAME>
</cffunction>

<cffunction name="primaryKeyMetaData" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo
		name="rsCheck"
		table="#qualifySchema(arguments.table)#"
		type="index">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like 'primary%'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
		or lower(rsCheck.INDEX_NAME) like '%_pkey'
	</cfquery>

	<cfreturn buildIndexMetatData(rsCheck,arguments.table)>
</cffunction>

<cffunction name="addPrimaryKey" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfif not primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql">
				<cfquery>
					ALTER TABLE #arguments.table#
						ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="mysql,nuodb">
				<cfquery>
					ALTER TABLE #arguments.table#
	    			ADD PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
					ALTER TABLE #arguments.table#
	    			ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery>
					ALTER TABLE #arguments.table#
					ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="dropPrimaryKey" output="false">
	<cfargument name="table" default="#variables.table#">

	<cfif primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.dbtype#">
			<cfcase value="mssql">
				<cfquery>
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT #primaryKeyConstraintName(arguments.table)#
				</cfquery>
			</cfcase>
			<cfcase value="mysql,nuodb">
				<cfquery>
					ALTER TABLE #arguments.table#
	    			DROP PRIMARY KEY
				</cfquery>
			</cfcase>
			<cfcase value="postgresql">
				<cfquery>
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT #primaryKeyConstraintName(arguments.table)#
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery>
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT #primaryKeyConstraintName(arguments.table)#
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>


<!------------ FOREIGN KEYS ------------------------->

<cffunction name="foreignKeyExists" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">

	<cfset var fkArray=foreignKeys(argumentCollection=arguments)>
	<cfset var i="">

	<cfif arrayLen(fkArray)>
		<cfloop from="1" to="#arrayLen(fkArray)#" index="i">
			<cfif fkArray[i].fkColumn eq arguments.fkColumn
			and fkArray[i].fkTable eq arguments.fkTable>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="foreignKeyMetaData" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var fkArray=foreignKeys(argumentCollection=arguments)>
	<cfset var i="">

	<cfif arrayLen(fkArray)>
		<cfloop from="1" to="#arrayLen(fkArray)#" index="i">
			<cfif fkArray[i].fkColumn eq arguments.fkColumn
			and fkArray[i].fkTable eq arguments.fkTable>
				<cfreturn fkArray[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn structNew()>
</cffunction>

<cffunction name="addForeignKey" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfif not foreignKeyExists(
							table=arguments.fkTable,
							column=arguments.fkColumn,
							fkTable=arguments.table,
							fkColumn=arguments.column
						)>
		<cfset addIndex(arguments.column,arguments.table)>
		<cfquery>
			ALTER TABLE #arguments.table#
			ADD CONSTRAINT fk_#arguments.fktable#_#arguments.fkcolumn#
			FOREIGN KEY (#arguments.column#)
			REFERENCES #arguments.fktable#(#arguments.fkcolumn#)

			<!---
			MySQL
			ON DELETE reference_option
		    ON UPDATE reference_option
		    --->
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="dropForeignKey" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfif not foreignKeyExists(
							table=arguments.fkTable,
							column=arguments.fkColumn,
							fkTable=arguments.table,
							fkColumn=arguments.column
						)>
		<cfquery>
			ALTER TABLE #arguments.table#
			DROP <cfif variables.dbtype eq 'MySQL'>FOREIGN KEY<cfelse>CONSTRAINT</cfif> fk_#arguments.fktable#_#arguments.fkcolumn#
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="buildForeignKeyMetaData" access="private" output="false">
	<cfargument name="rs">
	<cfargument name="table">
	<cfset var fk={}>
	<cfset var fkArray=[]>

	<cfif rs.recordcount>
		<cfloop query="rs">

			<cfset fk={table=arguments.table,
					fkTable=rs.fkTable_name,
					fkColumn=rs.fkcolumn_name,
					deleteRule=rs.delete_rule,
					updateRule=rs.update_rule}>
			<cfset arrayAppend(fkArray,fk)>
		</cfloop>
	</cfif>
	<cfreturn fkArray>
</cffunction>

<cffunction name="foreignKeys" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo
		name="rsCheck"
		table="#qualifySchema(arguments.table)#"
		type="foreignKeys">

	<cfreturn buildForeignKeyMetaData(	
		rs = rsCheck,
		table = arguments.table
	)>
</cffunction>

<cfscript>
/**
 * Parse out the first set of numbers in a string.
 *
 * @param string      String to parse. (Required)
 * @return Returns a string.
 * @author Marco G. Williams (email@marcogwilliams.com)
 * @version 1, May 22, 2003
 */
function _parseInt(String){
    var NewString = "";
    var i = 1;

    for(i=1; i lt Len(arguments.String); i = i + 1) {
        if( isNumeric( mid(arguments.String,i,1) ) ) { newString = val( mid( arguments.String,i,Len(arguments.String) ) ); break;}
    }
    return NewString;
}
</cfscript>

<cffunction name="columnParamType" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">

	<cfreturn transformParamType(columnMetaData(argumentCollection=arguments).datatype)>

</cffunction>

<cffunction name="transformParamType" output="false">
	<cfargument name="paramType">

	<cfswitch expression="#arguments.paramType#">
		<cfcase value="varchar,nvarchar,varchar2,char">
			<!--- Add MSSQL nvarchar(max)--->
			<cfreturn "varchar">
		</cfcase>
		<cfcase value="int,number,tinyint">
			<cfreturn "numeric">
		</cfcase>
		<cfcase value="datetime,timestamp">
			<cfreturn "timestamp">
		</cfcase>
		<cfcase value="date">
			<cfreturn "date">
		</cfcase>
		<cfcase value="ntext,longtext,clob,text">
			<cfreturn "longvarchar">
		</cfcase>
		<cfcase value="float,binary_float">
			<cfreturn "float">
		</cfcase>
		<cfcase value="double,decimal,binary_double">
			<cfreturn "double">
		</cfcase>
		<cfdefaultcase>
			<cfreturn "varchar">
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="buildSchemaFromProperties" output="false">
	<cfargument name="obj">
	<cfset var properties=getMetaData(arguments.obj)>
	<cfdump var="#properties#" abort="true">
</cffunction>

<cffunction name="qualifySchema" output="false" hint="Add schema to table name where required">
	<cfargument name="table">
	<cfset var rs = "">

	<cfif variables.dbtype eq "postgresql">
		<cfif variables.dbSchema eq "">
			<cfquery name="rs">
				SELECT current_schema() AS schema
			</cfquery>
			<cfset variables.dbSchema = rs.schema>
		</cfif>
		<cfset arguments.table = variables.dbSchema & "." & arguments.table>
	</cfif>

	<cfreturn arguments.table>
</cffunction>

</cfcomponent>