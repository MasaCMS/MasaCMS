component extends="mura.bean.beanORM" table="tremembertokens" entityName="rememberMeToken" bundleable=false hint="This provides remember-me selector/validator token persistence" {
	property name="tokenID" fieldtype="id";
	// Plain columns instead of many-to-one so no token accessors are synthesized onto the core user/site beans.
	property name="userID" datatype="char" length="35" required=true;
	property name="siteID" datatype="varchar" length="25" required=true;
	property name="selector" datatype="varchar" length="43" required=true;
	property name="validatorHash" datatype="char" length="64" required=true;
	property name="expires" datatype="datetime" required=true;
	property name="created" datatype="datetime" required=true;
	property name="lastused" datatype="datetime" required=true;

	// Tokens are single-row lookups by selector; skip the cache and its cluster purge on every rotation.
	function getUseCache(){
		return false;
	}

	// Compare-and-swap on the current validator hash; save() can only update by primary key.
	boolean function rotate(required string oldValidatorHash, required string validatorHash, required date expires, required date lastused){
		var updateResult={recordCount=0};

		queryExecute(
			sql="UPDATE #getTable()#
				SET validatorHash=:validatorHash, expires=:expires, lastused=:lastused
				WHERE tokenID=:tokenID AND validatorHash=:oldValidatorHash",
			params={
				validatorHash={value=arguments.validatorHash, cfsqltype="varchar"},
				expires={value=arguments.expires, cfsqltype="timestamp"},
				lastused={value=arguments.lastused, cfsqltype="timestamp"},
				tokenID={value=get('tokenID'), cfsqltype="varchar"},
				oldValidatorHash={value=arguments.oldValidatorHash, cfsqltype="varchar"}
			},
			options={result="local.updateResult"}
		);

		if(updateResult.recordCount == 1){
			set('validatorHash',arguments.validatorHash);
			set('expires',arguments.expires);
			set('lastused',arguments.lastused);
			return true;
		}

		return false;
	}

	function deleteExpired(required date lastUsedBefore){
		queryExecute(
			sql="DELETE FROM #getTable()# WHERE expires <= :now OR lastused <= :lastUsedBefore",
			params={
				now={value=now(), cfsqltype="timestamp"},
				lastUsedBefore={value=arguments.lastUsedBefore, cfsqltype="timestamp"}
			}
		);
		return this;
	}
}
