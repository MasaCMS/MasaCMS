<cfset variables.dbUtility=getBean("dbUtility")>

<cfif not variables.dbUtility.setTable("tremembertokens").tableExists()>
	<cfswitch expression="#getDbType()#">
		<cfcase value="mssql">
			<cfquery>
				CREATE TABLE [dbo].[tremembertokens] (
					[tokenID] char(35) NOT NULL,
					[userID] char(35) NOT NULL,
					[siteID] char(35) NOT NULL,
					[selector] varchar(43) NOT NULL,
					[validatorHash] char(64) NOT NULL,
					[expires] datetime2 NOT NULL,
					[created] datetime2 NOT NULL,
					[lastused] datetime2 NOT NULL,
					CONSTRAINT [PK_tremembertokens] PRIMARY KEY ([tokenID]),
					CONSTRAINT [UQ_tremembertokens_selector] UNIQUE ([selector])
				)
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery>
				CREATE TABLE `tremembertokens` (
					`tokenID` char(35) NOT NULL,
					`userID` char(35) NOT NULL,
					`siteID` char(35) NOT NULL,
					`selector` varchar(43) NOT NULL,
					`validatorHash` char(64) NOT NULL,
					`expires` datetime NOT NULL,
					`created` datetime NOT NULL,
					`lastused` datetime NOT NULL,
					PRIMARY KEY (`tokenID`),
					UNIQUE KEY `UQ_tremembertokens_selector` (`selector`)
				) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
			</cfquery>
		</cfcase>
		<cfcase value="postgresql">
			<cfquery>
				CREATE TABLE tremembertokens (
					tokenID char(35) NOT NULL,
					userID char(35) NOT NULL,
					siteID char(35) NOT NULL,
					selector varchar(43) NOT NULL,
					validatorHash char(64) NOT NULL,
					expires timestamp NOT NULL,
					created timestamp NOT NULL,
					lastused timestamp NOT NULL,
					CONSTRAINT PK_tremembertokens PRIMARY KEY (tokenID),
					CONSTRAINT UQ_tremembertokens_selector UNIQUE (selector)
				)
			</cfquery>
		</cfcase>
		<cfcase value="nuodb">
			<cfquery>
				CREATE TABLE tremembertokens (
					tokenID char(35) NOT NULL,
					userID char(35) NOT NULL,
					siteID char(35) NOT NULL,
					selector varchar(43) NOT NULL,
					validatorHash char(64) NOT NULL,
					expires timestamp NOT NULL,
					created timestamp NOT NULL,
					lastused timestamp NOT NULL,
					PRIMARY KEY (tokenID),
					UNIQUE (selector)
				)
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery>
				CREATE TABLE "TREMEMBERTOKENS" (
					"TOKENID" CHAR(35) NOT NULL,
					"USERID" CHAR(35) NOT NULL,
					"SITEID" CHAR(35) NOT NULL,
					"SELECTOR" VARCHAR2(43) NOT NULL,
					"VALIDATORHASH" CHAR(64) NOT NULL,
					"EXPIRES" TIMESTAMP(6) NOT NULL,
					"CREATED" TIMESTAMP(6) NOT NULL,
					"LASTUSED" TIMESTAMP(6) NOT NULL,
					CONSTRAINT "PK_TREMEMBERTOKENS" PRIMARY KEY ("TOKENID"),
					CONSTRAINT "UQ_TREMEMBERTOKENS_SELECTOR" UNIQUE ("SELECTOR")
				)
			</cfquery>
		</cfcase>
		<cfdefaultcase>
			<cfthrow type="MasaCMS.DatabaseUpdate" message="Remember-me token table is not defined for database type #getDbType()#.">
		</cfdefaultcase>
	</cfswitch>
</cfif>

<cfset variables.dbUtility.purgeCache()>

<cfif not variables.dbUtility.setTable("tremembertokens").indexExists("userID")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_user_site ON tremembertokens (userID, siteID)
	</cfquery>
</cfif>

<cfif not variables.dbUtility.setTable("tremembertokens").indexExists("expires")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_expiry ON tremembertokens (expires, lastused)
	</cfquery>
</cfif>

<cfset variables.dbUtility.purgeCache()>