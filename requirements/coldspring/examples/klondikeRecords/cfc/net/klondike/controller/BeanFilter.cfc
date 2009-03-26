<cfcomponent displayname="BeanFilter" 
	extends="MachII.framework.EventFilter" 
	output="false" 
	hint="A filter to retrieve a bean from a specific struct and place it into the event. Like JSP:useBean">
	
	<!--- PROPERTIES --->
	<cfset this.ID_PARAM = "ID" />
	<cfset this.BEAN_CLASS_PARAM = "class" />
	<cfset this.SCOPE_PARAM = "scope" />
	
	<cffunction name="filterEvent" access="public" returntype="boolean" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="yes" />
		<cfargument name="paramArgs" type="struct" required="no" default="#StructNew()#" />
		
		<cfset var ID = '' />
		<cfset var class = '' />
		<cfset var scope = '' />
		<cfset var bean = '' />
		
		<!--- get values from arguments (or params) --->
		<cfif StructKeyExists(arguments.paramArgs,this.ID_PARAM)>
			<cfset ID = paramArgs[this.ID_PARAM] />
		<cfelse>
			<cfset ID = getParameter(this.ID_PARAM,'') />
		</cfif>
		<cfif StructKeyExists(arguments.paramArgs,this.BEAN_CLASS_PARAM)>
			<cfset class = paramArgs[this.BEAN_CLASS_PARAM] />
		<cfelse>
			<cfset class = getParameter(this.BEAN_CLASS_PARAM,'') />
		</cfif>
		<cfif StructKeyExists(arguments.paramArgs,this.SCOPE_PARAM)>
			<cfset scope = paramArgs[this.SCOPE_PARAM] />
		<cfelse>
			<cfset scope = getParameter(this.SCOPE_PARAM,'') />
		</cfif>
		
		<!--- if params are empty throw usage error --->
		<cfif not len(ID) or not len(class) or not len(scope)>
			<cfset throwUsageException() />
		<cfelse>
			<!--- else, look for bean in the event or the scope --->
			<cfif request.event.isArgDefined(ID)>
			<!--- Do nothing, it's already there. --->
			<cfelseif isDefined( scope & "." & ID ) >
				<!--- Take bean from the session and put in the event. --->
				<cfset arguments.event.setArg(ID, evaluate("#scope#.#ID#") ) />
			<cfelse>
				<!--- Create a new bean. --->
				<cfset bean = CreateObject('component', class).init() />
				<cfset "#scope#.#ID#" = bean  />
				<cfset arguments.event.setArg(ID, bean) />
			</cfif>
			
			<cfreturn true />
		</cfif>
		
	</cffunction>
	
	
	<!--- PROTECTED: usage Exception --->
	<cffunction name="throwUsageException" access="private" returntype="void" output="false">
		<cfset var throwMsg = "BeanFilter filter requires the following parameters: " & 
							 this.ID_PARAM & ", " & this.BEAN_CLASS_PARAM & ", " & 
							 this.SCOPE_PARAM />
		<cfthrow message="#throwMsg#" />
	</cffunction>
	
</cfcomponent>