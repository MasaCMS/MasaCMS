<cfcomponent extends="mura.cfobject" output="false">
	<cfset variables.table="">

	<cffunction name="init" output="false">
	<cfargument name="table" default="">
		<cfset setTable(arguments.table)>
		<cfreturn this>
	</cffunction>

	<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
		<cfset variables.configBean=arguments.configBean>
		<cfreturn this>
	</cffunction>

	<cffunction name="setTable" output="false">
	<cfargument name="table">
		<cfset variables.table=arguments.table>
		<cfreturn this>
	</cffunction>

	<cffunction name="columns" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rs ="">
	
	<cfset variables.table=arguments.table>
	
	<cfif variables.configBean.getDbType() neq "oracle">
			<cfdbinfo 
			name="rs"
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#"
			table="#arguments.table#"
			type="columns">	
	<cfelse>
		<cfquery
			name="rs" 
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#">
				SELECT column_name, data_length column_size, data_type type_name
				FROM user_tab_cols
				WHERE table_name=UPPER('#arguments.table#')
		</cfquery>
	</cfif>
	
	<cfreturn rs>
</cffunction>

<cffunction name="addIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfset var rsCheck="">
	
	<cfset variables.table=arguments.table>
	
	<cfif not indexExists(arguments.column,arguments.table)>
	<cftry>
		<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		</cfswitch>	
	<cfcatch></cfcatch>
	</cftry>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="dropIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfset variables.table=arguments.table>
	
	<cfif indexExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)#
				</cfquery>
			</cfcase>
		</cfswitch>	
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="transformIndexName" access="private">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql,mysql">
				<cfreturn rereplace(replace("IX_#arguments.table#_#arguments.column#",",","ALL"),"[[:space:]]","","All")>
			</cfcase>
			<cfcase value="oracle">
				<cfreturn rereplace(replace(right("IX_#arguments.table#_#arguments.column#",30),",","ALL"),"[[:space:]]","","All")>
			</cfcase>
		</cfswitch>	
</cffunction>

<cffunction name="dropColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfset var rsCheck=columns(arguments.table)>
	
	<cfset variables.table=arguments.table>
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#arguments.column#'
	</cfquery>
	
	<cfif columnExists(arguments.column,arguments.table)>
	<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
	</cfswitch>	
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="addColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">
	
	<cfset var hasTable=tableExists(arguments.table)>

	<cfset variables.table=arguments.table>

	<cfif not hasTable or not columnExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD
				</cfif>
				
				#arguments.column#  <cfif arguments.autoincrement>INT PRIMARY KEY IDENTITY<cfelse>#transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				
				<cfif not hasTable>) ON [PRIMARY]</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD COLUMN
				</cfif>
				
				#arguments.column#  <cfif arguments.autoincrement>INT(11) NOT NULL AUTO_INCREMENT<cfelse>#transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				
				<cfif not hasTable>
					<cfif arguments.autoincrement>
						,PRIMARY KEY(#arguments.column#)
					</cfif>
					) ENGINE=InnoDB DEFAULT CHARSET=utf8
				</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD <cfif variables.configBean.getDbType() eq "ORACLE">(</cfif>
				</cfif>
				
				#arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>
				
				<cfif not hasTable or variables.configBean.getDbType() eq "ORACLE">)</cfif>
				
				<cfif arguments.datatype eq "longtext">
					lob (#arguments.column#) STORE AS (
					TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
					NOCACHE LOGGING
					STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
					PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
				</cfif>

			</cfquery>
			<cfif arguments.autoincrement>				
				
				<cftry>
				 <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					DROP SEQUENCE seq_#arguments.table#_#arguments.column#
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					CREATE SEQUENCE seq_#arguments.table#_#arguments.column#
					MINVALUE 1
					START WITH 1
					INCREMENT BY 1
					CACHE 10
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					create or replace TRIGGER trg_#arguments.table#_#arguments.column# BEFORE INSERT ON #arguments.table#
					FOR EACH ROW
					BEGIN
					    SELECT  seq_#arguments.table#_#arguments.column#.NEXTVAL INTO :new.#arguments.column# FROM DUAL;
					END;
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TRIGGER "TPLUGINS_PLUGINID_TRG" ENABLE
				</cfquery>
				<cfset addPrimaryKey(argumentCollection=arguments)>
			</cfif>
		</cfcase>
		</cfswitch>	
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="alterColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">

	<cfset variables.table=arguments.table>
	
	<cfif columnExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif arguments.autoincrement>PRIMARY KEY IDENTITY<cfelse><cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# MODIFY COLUMN #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> <cfif arguments.autoincrement>AUTO_INCREMENT<cfelse>default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# RENAME COLUMN #arguments.column# to #arguments.column#2
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# ADD #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					UPDATE #arguments.table# SET #arguments.column#=#arguments.column#2
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#2
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="addPrimaryKey" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfset variables.table=arguments.table>
	
	<cfif not primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
						ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
	    			ADD PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
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

	<cfset variables.table=arguments.table>
	
	<cfif primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT pk_#arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
	    			DROP PRIMARY KEY
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT pk_#arguments.table#
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
	
	<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "nvarchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "int">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "tinyint">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text,longtext">
					<cfquery name="MSSQLversion" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
						EXEC sp_MSgetversion
					</cfquery>
	
					<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>

					<cfif MSSQLversion neq 8>
						<cfreturn "nvarchar(max)">
					<cfelse>
						<cfreturn "ntext">
					</cfif>
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="mysql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "varchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "int(11)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "int(3)">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text">
					<cfreturn "text">
				</cfcase>
				<cfcase value="longtext">
					<cfreturn "longtext">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="oracle">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "varchar2(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "number(10,0)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "number(3,0)">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "date">
				</cfcase>
				<cfcase value="text,longtext">
					<cfreturn "clob">
				</cfcase>
			</cfswitch>
		</cfcase>
	</cfswitch>
</cffunction>

<cffunction name="columnExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var rsCheck=columns(arguments.table)>
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#lcase(arguments.column)#'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="columnMetaData" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var rsCheck=columns(arguments.table)>
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#lcase(arguments.column)#'
	</cfquery>

	<cfreturn rsCheck>
</cffunction>

<cffunction name="tableExists" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">
	
	<cfset variables.table=arguments.table>
	
	<cfif variables.configBean.getDbType() neq "oracle">
		<cfdbinfo 
			name="rsCheck"
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#"
			type="tables">

		<cfquery name="rsCheck" dbtype="query">
			select * from rsCheck where 
			lower(TABLE_TYPE) like 'table' 
			and lower(rsCheck.table_name) like '#arguments.table#'
		</cfquery>
	
	<cfelse>
		<cfquery
			name="rscheck" 
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#">
				SELECT column_name, data_length column_size, data_type type_name
				FROM user_tab_cols
				WHERE table_name=UPPER('#arguments.table#')
		</cfquery>
	</cfif>

	<cfreturn rscheck.recordcount>
</cffunction>

<cffunction name="indexes" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="index">
	<cfreturn rscheck>
</cffunction>

<cffunction name="foreignKeys" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="foreignKeys">
	<cfreturn rscheck>
</cffunction>

<cffunction name="tables" output="false">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		type="tables">
	<cfreturn rscheck>
</cffunction>

<cffunction name="version" output="false">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		type="version">
	<cfreturn rscheck>
</cffunction>

<cffunction name="indexExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck=indexes(arguments.table)>

	<cfset variables.table=arguments.table>

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.column_name) like '#lcase(arguments.column)#'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="primaryKeyExists" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="index">
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like 'primary'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="dropTable" output="false">
	<cfargument name="table" default="#variables.table#">

	<cfset variables.table=arguments.table>
	

	<cfif tableExists(arguments.table)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			DROP TABLE #arguments.table#
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="foreignKeyExists" output="false">
	<cfargument name="column">
	<cfargument name="refColumn">
	<cfargument name="refTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfdbinfo 
		name="rsCheck"
		datasource="#application.configBean.getDatasource()#"
		username="#application.configBean.getDbUsername()#"
		password="#application.configBean.getDbPassword()#"
		table="#arguments.refTable#"
		type="foreignkeys">

	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where 
		lower(rsCheck.fkColumn_NAME) like '#lcase(arguments.column)#'
		AND lower(rsCheck.fkTable_NAME) like '#lcase(arguments.table)#'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="addForeignKey" output="false">
	<cfargument name="column">
	<cfargument name="refColumn">
	<cfargument name="refTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfif not foreignKeyExists(argumentCollection=arguments)>	
		<cfset addIndex(arguments.column,arguments.table)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table#
			ADD CONSTRAINT fk_#arguments.table#_#arguments.column#
			FOREIGN KEY (#arguments.column#)
			REFERENCES #arguments.refTable#(#arguments.refColumn#)

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
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfset variables.table=arguments.table>

	<cfif foreignKeyExists(argumentCollection=arguments)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table#
			DROP <cfif variables.configBean.getDbType() eq 'MySQL'>FOREIGN KEY<cfelse>CONSTRAINT</cfif> fk_#arguments.table#_#arguments.column#
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>


</cfcomponent>