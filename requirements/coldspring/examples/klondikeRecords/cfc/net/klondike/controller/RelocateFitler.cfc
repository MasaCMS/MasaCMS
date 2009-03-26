<cfcomponent displayname="RelocateFilter" 
			 hint="Preforms relocation, use after event ends to complete a form submission" 
			 extends="MachII.framework.EventFilter" output="false">
	
	<cffunction name="filterEvent" access="public" returntype="boolean" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="yes" />
		<cfargument name="paramArgs" type="struct" required="no" default="#StructNew()#" />
		
		<cfset var newEvent = '' />
		<!--- <cfset var copyArgs = false /> --->
		<cfset var argsToCopy = '' />
		<cfset var newURL = 'index.cfm?event=' />
		<cfset var eventArgs = 0/>
		<cfset var arg = '' />
		<cfset var val = '' />
		
		<cfif StructKeyExists(paramArgs, 'newEvent')>
			<cfset newEvent = paramArgs.newEvent />
		<cfelse>
			<cfset throwUsageException() />
        </cfif>
        
        <cfif StructKeyExists(paramArgs, 'argsToCopy')>
        		<cfset argsToCopy = paramArgs.argsToCopy />
        </cfif>	
        <!--- 
        <cfif StructKeyExists(paramArgs, 'copyArgs')>
        		<cfset copyArgs = paramArgs.copyArgs />
        </cfif>	
        --->
        
        <!--- start building url string --->
        <cfset newURL = newURL & newEvent />
        <cfloop list="#argsToCopy#" index="arg">
        		<cfset val = event.getArg(arg, '')>
        		<cfif len(val)>
        			<cfset newURL = newURL & "&" & arg & "=" & val />
        		</cfif>
        </cfloop>
        
        <!--- put eventArguments in it, if necessary
        <cfif copyArgs>
        		<cfset eventArgs = arguments.event.getArgs() />
	        <cfloop collection="#eventArgs#" item="arg">
	        		<cfif arg IS NOT 'event'>
	        			<cfset newURL = newURL & "&" & arg & "=" & eventArgs[arg] />
	        		</cfif>
	        </cfloop>
        </cfif>
        --->
        
		<cfoutput>
			<cflocation url="#newURL#" addtoken="no" />
		</cfoutput>
		
		<cfreturn false />
		
	</cffunction>
	
	<!--- PROTECTED FUNCTIONS --->
	<cffunction name="throwUsageException" access="private" returntype="void" output="false">
		<cfset var throwMsg = "RelocateFilter requires a newEvent parameter, an optional list of arguments to copy may also be provided" />
		<cfthrow message="#throwMsg#" />
	</cffunction>
	
</cfcomponent>