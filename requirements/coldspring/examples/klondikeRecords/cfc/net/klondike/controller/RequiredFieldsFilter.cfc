<!---
Author: Ben Edwards (ben@ben-edwards.com),

RequiredFieldsFilter
	This event-filter tests an event for required fields specified.
	If the required fields are not present (or are blank) then event 
	processing is aborted and a specified event is announced.
	
	If the required fields aren't defined then 'message' and 'missingFields' 
	are set in the event.
	
	Edited by Chris Scott (chris@sealworks.com) to add "allowZeroValues", 
	defaults to true and can be set in config or usage param
	
Configuration Parameters:
	Optional: "allowZeroValues"
	
Event-Handler Parameters:
	"requiredFields" - a comma delimited list of fields required
	"invalidEvent" - the event to announce if all required fields are not in the event
	Optional: "allowZeroValues", "copyEventArgs"
--->

<cfcomponent 
	displayname="RequiredFieldsFilter" 
	extends="MachII.framework.EventFilter"
	output="false"
	hint="An EventFilter for testing that an event's args contain a list of required fields.">
	
	<!--- PROPERTIES --->
	<cfset this.REQUIRED_FIELDS_PARAM = "requiredFields" />
	<cfset this.INVALID_EVENT_PARAM = "invalidEvent" />
	<cfset this.ALLOW_ZERO_VALUES = "allowZeroValues" />
	<cfset this.COPY_EVENT_ARGS = "copyEventArgs" />
	
	<!--- PUBLIC FUNCTIONS --->
	<cffunction name="configure" access="public" returntype="void" output="false">
	</cffunction>
	
	<cffunction name="filterEvent" access="public" returntype="boolean" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<cfargument name="paramArgs" type="struct" required="false" default="#StructNew()#" />
		
		<cfset var isContinue = true />
		<cfset var missingFields = '' />
		<cfset var requiredFields = '' />
		<cfset var invalidEvent = '' />
		<cfset var field = 0 />
		<cfset var fieldVal = '' />
		<cfset var copyEventArgs = false />
		<cfset var newEventArgs = 0 />
		<cfset var allowZeroValues = true />
		
		<!--- ALLOW_ZERO_VALUES, COPY_EVENT_ARGS can be set as a config param and/or overridden as event-handler param --->
		<cfif StructKeyExists(arguments.paramArgs,this.ALLOW_ZERO_VALUES)>
			<cfset allowZeroValues = paramArgs[this.ALLOW_ZERO_VALUES] />
		<cfelse>
			<cfset allowZeroValues = getParameter(this.ALLOW_ZERO_VALUES, true) />
		</cfif>
		<cfif StructKeyExists(arguments.paramArgs,this.COPY_EVENT_ARGS)>
			<cfset copyEventArgs = paramArgs[this.COPY_EVENT_ARGS] />
		<cfelse>
			<cfset copyEventArgs = getParameter(this.COPY_EVENT_ARGS, true) />
		</cfif>
		
		<cfif StructKeyExists(arguments.paramArgs,this.REQUIRED_FIELDS_PARAM) 
				AND StructKeyExists(arguments.paramArgs,this.INVALID_EVENT_PARAM)>
			<cfset requiredFields = arguments.paramArgs[this.REQUIRED_FIELDS_PARAM] />
			<cfset invalidEvent = arguments.paramArgs[this.INVALID_EVENT_PARAM] />
			
			<cfloop index="field" list="#requiredFields#" delimiters=",">
				<cfif NOT event.isArgDefined(field)>
					<cfset missingFields = ListAppend(missingFields, field, ',') />
					<cfset isContinue = false />
				<cfelse>
					<cfset fieldVal = event.getArg(field,'') />
					<cfif (fieldVal EQ '') OR ((NOT allowZeroValues) AND (fieldVal EQ 0))>
						<cfset missingFields = ListAppend(missingFields, field, ',') />
						<cfset isContinue = false />
					</cfif>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset throwUsageException() />
		</cfif>
		
		<cfif isContinue>
			<cfreturn true />
		<cfelse>
			<cfif copyEventArgs>
				<cfset newEventArgs = arguments.event.getArgs() />
			<cfelse>
				<cfset newEventArgs = StructNew() />
			</cfif>
			<cfset newEventArgs['message'] = "Please provide all required fields. Missing fields: " & ReplaceNoCase(missingFields,',',', ','all') & "." />
			<cfset newEventArgs['missingFields'] = missingFields />
			<cfset arguments.eventContext.announceEvent(invalidEvent, newEventArgs) />
			
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<!--- PROTECTED FUNCTIONS --->
	<cffunction name="throwUsageException" access="private" returntype="void" output="false">
		<cfset var throwMsg = "RequiredFieldsFilter requires the following usage parameters: " & this.REQUIRED_FIELDS_PARAM & ", " & this.INVALID_EVENT_PARAM & "." />
		<cfthrow message="#throwMsg#" />
	</cffunction>
	
</cfcomponent>