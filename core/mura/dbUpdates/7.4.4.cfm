<!---
	Constraints we want on the database:
	1 all user credentials require a user
		constaint FK_tusercredentials_tusers FOREIGN KEY (UserId) REFERENCES tusers (UserId),
	2 all user credential versions are unique per user so we can enforce absolute ordering
		constaint UQ_tusercredentials_version UNIQUE (UserId, version)
	3 users may have at most 1 active (disabled IS NULL) password (type = 'PASSWORD')
		constaint UQ_tusercredentials_password UNIQUE (UserId) WHERE type = 'PASSWORD' AND disabled IS NULL
	4 active (disabled IS NULL) passkeys (type = 'PASSKEY' AND credentialId IS NOT null) must be unique
		constaint UQ_tusercredentials_passkey UNIQUE (credentialId) WHERE type = 'PASSKEY' AND credentialId IS NOT null AND disabled IS NULL

	Not all databases can do filtered constraints (3 and 4), so some of it will not be enforced in certain databases. This is OK because:
	- if a user has multiple active password, they can not log in
	- if a duplicate passkey is detected, the user can not log in
--->

<!--- Migrate all bcrypt passwords to the new table and drop everything --->
<cffunction name="migrateData">
	<!--- upgrade the default admin password to bcrypt --->
	<cfquery>
		UPDATE tusers 
		SET password = '$2a$14$HPfUojt8zdz8GmvNx4biWeKjIuUP4XRKJP2pnBUjYxREeCjovP4Km' 
		WHERE username = 'admin' and (password = 'admin' OR password = '21232F297A57A5A743894A0E4A801FC3')
	</cfquery>
	<cfquery>
		INSERT INTO tusercredentials (UserId, version, TYPE, alias, created, updated, activity, hash)
		SELECT
			UserId,
			1,
			'PASSWORD',
			'PASSWORD',
			passwordCreated,
			LastUpdate,
			lastLogin,
			password
		FROM tusers
		WHERE tusers.type = 2 
			AND tusers.password like '$%$%$%'
			AND inactive = 0
	</cfquery>
</cffunction>

<cffunction name="dropOldData">
	<cfquery>
		ALTER TABLE tusers DROP COLUMN password, DROP COLUMN passwordCreated
	</cfquery>
</cffunction>

<cfif not dbUtility.setTable('tusercredentials').tableExists()>
	<cfswitch expression="#getDbType()#">
		<cfcase value="mssql">		
			<cftransaction>
				<cfquery>
				CREATE TABLE [dbo].[tusercredentials] (
					UserId varchar(36) not null,
					version integer not null default 1,
					type varchar(36) not null,
					alias varchar(36),
					created datetime not null default now(),
					updated datetime not null default now(),
					disabled datetime default null,
					counter integer not null default 0,
					activity datetime,
					-- for passwords and TOTP
					hash varchar(255) default null,
					-- for passkeys
					credentialId varchar(36) default null,
					challenge varchar(255) default null,
					key varchar(4000) default null,
					constraint PK_tusercredentials PRIMARY KEY (UserId, version),
					constraint FK_tusercredentials_tusers FOREIGN KEY (UserId) REFERENCES tusers (UserId),
					constraint UQ_tusercredentials_credentialId UNIQUE KEY (credentialId, disabled)
				)
				</cfquery>
				<cfset migrateData() />
				<cfset dropOldData() />
			</cftransaction>
		</cfcase>

		<cfcase value="mysql">
			<cftransaction>
				<cfquery>
					CREATE TABLE tusercredentials (
						`UserID` char(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
						version integer not null default 1,
						type varchar(36) not null,
						alias varchar(36),
						created datetime not null default now(),
						updated datetime not null default now(),
						disabled datetime default null,
						counter integer not null default 0,
						activity datetime DEFAULT null,
						-- for passwords and TOTP
						hash varchar(255) default null,
						-- for passkeys
						credentialId varchar(36) default null,
						challenge varchar(255) default null,
						keypass varchar(4000) default null,
						CONSTRAINT PK_tusercredentials PRIMARY KEY (UserId, version),
						CONSTRAINT FK_tusercredentials_tusers FOREIGN KEY (UserId) REFERENCES tusers (UserId),
						CONSTRAINT UQ_tusercredentials_credentialId UNIQUE KEY (credentialId, disabled)
					)
				</cfquery>
				<cfset migrateData() />
				<cfset dropOldData() />
			</cftransaction>	
		</cfcase>

		<cfcase value="postgresql">
			<cftransaction>
				<cfquery>
				</cfquery>
				<cfset migrateData() />
				<cfset dropOldData() />
			</cftransaction>
		</cfcase>

		<cfcase value="nuodb">
			<cftransaction>
				<cfquery>
				</cfquery>
				<cfset migrateData() />
				<cfset dropOldData() />
			</cftransaction>	
		</cfcase>

		<cfcase value="oracle">
			<cftransaction>
				<cfquery>
				</cfquery>
				<cfset migrateData() />
				<cfset dropOldData() />
			</cftransaction>
		</cfcase>
	</cfswitch>
</cfif>
