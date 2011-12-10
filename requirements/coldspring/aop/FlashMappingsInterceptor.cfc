<cfcomponent name="FlashMappingsInterceptor" extends="coldspring.aop.MethodInterceptor">
	
	<cffunction name="init" access="public" returntype="coldspring.aop.FlashMappingsInterceptor" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setFlashUtilityService" returntype="void" access="public" output="false" hint="Dependency: flash utility service">
		<cfargument name="flashUtilityService" type="coldspring.remoting.flash.flashUtilityService" required="true"/>
		<cfset variables.m_flashUtilityService = arguments.flashUtilityService />
	</cffunction>
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" />
		<cfset var method = methodInvocation.getMethod() />
		<cfset var args = methodInvocation.getArguments() />
		<cfset var flashUtilServiceExists = true>
		<cfset var arg = '' />
		<cfset var rtn = '' />
		
		<!--- make sure flashUtilService exists --->
		<cfif StructKeyExists(variables,"m_flashUtilityService")>
			<cfset flashUtilServiceExists = true>
		</cfif>
		
		<!--- first we need to find any struct vals in args and cast them back to cf structs --->
		<cfif flashUtilServiceExists>
			<cfloop collection="#args#" item="arg">
				<cfif IsStruct(args[arg])>
					<!--- this may get fd up cuz of the pass by ref --->
					<cfset args[arg] = variables.m_flashUtilityService.processServiceMethodParams(args[arg]) />
				</cfif>
			</cfloop>
		</cfif>
		<!--- run method --->
		<cfset rtn = methodInvocation.proceed() />
		
		<cfif isDefined('rtn')>
			<!--- map return vals back to as objects --->
			<cfreturn variables.m_flashUtilityService.processServiceMethodResult(rtn) />
		</cfif>
	</cffunction>
	
</cfcomponent>