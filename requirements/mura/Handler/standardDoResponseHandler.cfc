<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfswitch expression="#event.getValue('contentBean').getType()#">
	<cfcase value="File,Link">
	
		<cfif event.getValue('isOnDisplay') and ((not event.getValue('r').restrict) or (event.getValue('r').restrict and event.getValue('r').allow))>			
			<cfif event.getValue('showMeta') neq 1>
				<cfswitch expression="#event.getValue('contentBean').getType()#">
					<cfcase value="Link">
						<cfif not event.getValue('contentRenderer').showItemMeta("Link") or event.getValue('showMeta') eq 2>
							<cfset event.getHandler('standardLinkTranslation').handle(event) />
						<cfelse>
							<cfset event.getHandler('standardTranslation').handle(event) />	
						</cfif>
					</cfcase>
					<cfcase value="File">		
						<cfif not event.getValue('contentRenderer').showItemMeta(event.getValue('contentBean').getFileExt()) or event.getValue('showMeta') eq 2>
							<cftry>
							<cfset event.getHandler('standardFileTranslation').handle(event) />
							<cfcatch>
								<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteID'))) />
								<cfset event.getHandler('standardTranslation').handle(event) />
							</cfcatch>
						</cftry>
						<cfelse>
							<cfset event.getHandler('standardTranslation').handle(event) />
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset event.getHandler('standardTranslation').handle(event) />
			</cfif>
		<cfelse>
			<cfset event.getHandler('standardTranslation').handle(event) />
		</cfif>
		
	</cfcase>
	
	<cfdefaultcase>
		<cfset event.getHandler('standardTranslation').handle(event) />
	</cfdefaultcase>
	
	</cfswitch>
	
	<cfset event.getValidator('standardForceSSL').validate(event)>

</cffunction>

</cfcomponent>