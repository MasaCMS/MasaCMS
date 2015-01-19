<!---
 * Frostburg State University
 * Jonathan E Yoder
 * 07 March 2011
--->

<!--- Extend the XmlCommandHandlerBase --->
<cfcomponent output="false" extends="CKFinder_Connector.CommandHandler.XmlCommandHandlerBase">

    <cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">
    
		<!--- Update file entry --->
        <cfset application.permUtility.updatefile(form, session.siteid)  />
        
        <cfreturn true>
        
    </cffunction>    
    
</cfcomponent>


