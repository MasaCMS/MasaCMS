<cfcomponent hint="I am a bean ideal for holding config settings." output="false">
  <cffunction name="Init" access="public" output="false" hint="I build a new SimpleConfig bean.">
    <cfset variables.config = structNew() />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetConfig" access="public" return="void" output="false" hint="Set property: config">
    <cfargument name="config" type="struct"/>
    <cfset variables.config=arguments[1] />
  </cffunction>
  
  <cffunction name="GetConfig" access="public" return="struct" output="false" hint="Get property: config">
    <cfreturn duplicate(variables.config) />
  </cffunction>
  
  <cffunction name="GetConfigSetting" access="public" return="struct" output="false" hint="I get a config setting from the config by name.">>
    <cfargument name="name" required="true" type="string">
    <cfreturn variables.config[arguments.name] />
  </cffunction>
</cfcomponent>