<cfscript>
	param name="objectparams.response" default="failure";
	if(!listFindNoCase('success,failure',objectparams.response)){
		objectparams.response="failure";
	}
</cfscript>
<cfoutput>
#objectparams.response#
</cfoutput>
