<cfsilent>
<cfset strField = "" />
<cfif arguments.field.isrequired>
	<cfset strField = strField & ' data-required="true"' />
</cfif>
<cfif structkeyexists(arguments.field,'size') and len(arguments.field.size)>
	<cfset strField = strField & ' size="#arguments.field.size#"' />
</cfif>
<cfif structkeyexists(arguments.field,'maxlength') and len(arguments.field.maxlength)>
	<cfset strField = strField & ' maxlength="#arguments.field.maxlength#"' />
<cfelseif structkeyexists(arguments.field,'size') and len(arguments.field.size)>
	<cfset strField = strField & ' maxlength="#arguments.field.size#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cols') and len(arguments.field.cols)>
	<cfset strField = strField & ' cols="#arguments.field.cols#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssid') and len(arguments.field.cssid)>
	<cfset strField = strField & ' id="#arguments.field.cssid#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass)>
	<cfset strField = strField & ' class="#arguments.field.cssclass#"' />
</cfif>
<cfif len(arguments.field.validatemessage)>
	<cfset strField = strField & ' data-message="#replace(arguments.field.validatemessage,"""","&quot;","all")#"' />
</cfif>
<cfif len(arguments.field.validatetype)>
	<cfif arguments.field.validatetype eq "regex" and len(arguments.field.validateregex)>
		<cfset strField = strField & ' data-validate="#arguments.field.validatetype# data-regex="#arguments.field.validateregex#"' />
	<cfelse>
		<cfset strField = strField & ' data-validate="#arguments.field.validatetype#"' />
	</cfif>
</cfif>
<cfif len(arguments.field.remoteid)>
	<cfset strField = strField & ' data-remoteid="#arguments.field.remoteid#"' />
</cfif>
</cfsilent>
<cfoutput>#strField#</cfoutput>