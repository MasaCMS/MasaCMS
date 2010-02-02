<cfcomponent output="false">



  <cffunction name="getName" output="false">
    <cfreturn "Widget">
  </cffunction>



  <cffunction name="nonExistantMethod" output="false">
    <cfthrow type="Application" message="The method nonExistantMethod was not found"
                                detail="Ensure that the method is defined">
  </cffunction>



</cfcomponent>
