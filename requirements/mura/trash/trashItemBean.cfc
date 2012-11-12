<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.trashManager="">

<cffunction name="setTrashManager" output="false">
<cfargument name="trashManager">
<cfset variables.trashManager=arguments.trashManager>
<cfreturn this>
</cffunction>

<cffunction name="setAllValues" output="false">
<cfargument name="instance">
<cfset variables.instance=arguments.instance>
<cfreturn this>
</cffunction>

<cffunction name="getAllValues" output="false">
<cfreturn variables.instance>
</cffunction>

<cffunction name="getObjectID" output="false">
<cfreturn variables.instance.objectID>
</cffunction>

<cffunction name="getSiteID" output="false">
<cfreturn variables.instance.siteID>
</cffunction>

<cffunction name="getParentID" output="false">
<cfreturn variables.instance.parentID>
</cffunction>

<cffunction name="getObjectClass" output="false">
<cfreturn variables.instance.objectClass>
</cffunction>

<cffunction name="getObjectLabel" output="false">
<cfreturn variables.instance.objectLabel>
</cffunction>

<cffunction name="getObjectType" output="false">
<cfreturn variables.instance.objectType>
</cffunction>

<cffunction name="getObjectSubType" output="false">
<cfreturn variables.instance.objectSubType>
</cffunction>

<cffunction name="getDeletedDate" output="false">
<cfreturn variables.instance.deletedDate>
</cffunction>

<cffunction name="getDeletedBy" output="false">
<cfreturn variables.instance.deletedBy>
</cffunction>

<cffunction name="getDeleteID" output="false">
<cfreturn variables.instance.deleteID>
</cffunction>

<cffunction name="getOrderNO" output="false">
<cfreturn variables.instance.orderno>
</cffunction>

<cffunction name="getObject" output="false">
<cfreturn variables.trashManager.getObject(variables.instance.objectID)>
</cffunction>

</cfcomponent>