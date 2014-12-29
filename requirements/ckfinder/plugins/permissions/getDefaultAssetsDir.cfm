<cfsilent>

<!--- Override default "getValue" function --->
<cffunction name="$getValueCascade" output="false" returntype="string">
	<cfargument name="property" type="string" required="true">
    
	<cfset loc = structnew()>
    
    <cfset this.$cacheCascadedFNB = structnew()>
    
	<cfset this.$cacheCascadedFNB.content = this>
    <cfloop condition="this.$cacheCascadedFNB.content.$getValue(arguments.property) eq '' AND NOT this.$cacheCascadedFNB.content.getContentID() eq '00000000000000000000000000000000001'">
        <cfset this.$cacheCascadedFNB.content = this.$cacheCascadedFNB.content.getParent()>
        <cfset this.$cacheCascadedFNB.content.injectMethod("$getValue", $getValue)>
    </cfloop>
    
    <!--- If object to inherit was not found, look at properties of self --->        
    <cfif this.$cacheCascadedFNB.content.$getValue(arguments.property) eq "">
        <cfset this.$cacheCascadedFNB.content = this>
    </cfif>


	<!--- Return property from cached object --->
    <cfreturn this.$cacheCascadedFNB.content.$getValue(arguments.property)>
    
</cffunction>

<cfscript>
if (isDefined("session.muraEditContentID") and Len(session.MuraEditContentID)) {
	$ = application.serviceFactory.getBean("MuraScope").init(session.siteID);

    // Inject $getValue for use of default/original getValue function.
	beanToFind = $.getBean("content").loadBy(contentID=session.muraEditContentID);
    beanToFind.injectMethod("$getValue", beanToFind.getValue);
	beanToFind.injectMethod("getValue", $getValueCascade);

	defaultAssetsDir = trim(beanToFind.getValue("defaultAssetsDir"));

	if (len(defaultAssetsDir) and defaultAssetsDir neq "/") {
		// Make sure path starts with "/"
		if (not defaultAssetsDir.startsWith('/')) {
			defaultAssetsDir = '/' & defaultAssetsDir;
		}
	} else {
		defaultAssetsDir = '/';
	}
}
</cfscript>

</cfsilent><cfif isdefined("defaultAssetsDir")><cfoutput>#defaultAssetsDir#</cfoutput><cfelse><cfoutput>/</cfoutput></cfif>

