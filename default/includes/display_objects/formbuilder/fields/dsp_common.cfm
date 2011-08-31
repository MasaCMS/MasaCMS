<cfif field.isrequired>
	<cfset strField = strField & ' data-required="true"' />
</cfif>
<cfif structkeyexists(field,'size') and len(field.size)>
	<cfset strField = strField & ' size="#field.size#"' />
</cfif>
<cfif structkeyexists(field,'maxlength') and len(field.maxlength)>
	<cfset strField = strField & ' maxlength="#field.maxlength#"' />
<cfelseif structkeyexists(field,'size') and len(field.size)>
	<cfset strField = strField & ' maxlength="#field.size#"' />
</cfif>
<cfif structkeyexists(field,'cols') and len(field.cols)>
	<cfset strField = strField & ' cols="#field.cols#"' />
</cfif>
<cfif structkeyexists(field,'cssid') and len(field.cssid)>
	<cfset strField = strField & ' id="#field.cssid#"' />
</cfif>
<cfif structkeyexists(field,'cssclass') and len(field.cssclass)>
	<cfset strField = strField & ' class="#field.cssclass#"' />
</cfif>
<cfif len(field.validatemessage)>
	<cfset strField = strField & ' data-message="#replace(field.validatemessage,"""","&quot;","all")#"' />
</cfif>
<cfif len(field.validatetype)>
	<cfif field.validatetype eq "regex" and len(field.validateregex)>
		<cfset strField = strField & ' data-validate="#field.validatetype# data-regex="#field.validateregex#"' />
	<cfelse>
		<cfset strField = strField & ' data-validate="#field.validatetype#"' />
	</cfif>
</cfif>
<cfif len(field.remoteid)>
	<cfset strField = strField & ' data-remoteid="#field.remoteid#"' />
</cfif>