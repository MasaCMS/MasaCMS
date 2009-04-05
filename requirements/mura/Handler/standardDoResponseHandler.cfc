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
							<cflocation addtoken="no" url="#event.getValue('contentRenderer').setDynamicContent(event.getValue('contentBean').getFilename())#">
						<cfelse>
							<cfset response=event.getValue('TranslatorFactory').get('standardHTML').translate(event) />	
						</cfif>
					</cfcase>
					<cfcase value="File">
						<cfif not event.getValue('contentRenderer').showItemMeta(event.getValue('contentBean').getFileExt()) or event.getValue('showMeta') eq 2>
							<cftry>
							<cfset event.getValue('contentRenderer').renderFile(event.getValue('contentBean').getFileID()) />
							<cfreturn ""/>
							<cfcatch>
								<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteID'))) />
								<cfset response= event.getValue('TranslatorFactory').get('standardHTML').translate(event) />
							</cfcatch>
						</cftry>
						<cfelse>
							<cfset response= event.getValue('TranslatorFactory').get('standardHTML').translate(event) />
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset response= event.getValue('TranslatorFactory').get('standardHTML').translate(event) />
			</cfif>
		<cfelse>
			<cfset response= event.getValue('TranslatorFactory').get('standardHTML').translate(event) />
		</cfif>
		
	</cfcase>
	
	<cfdefaultcase>
		<cfset response= event.getValue('TranslatorFactory').get('standardHTML').translate(event) />
	</cfdefaultcase>
	
	</cfswitch>
	
	<cfset event.getValue('ValidatorFactory').get('standardForceSSL').validate(event)>

	<cfreturn response>
</cffunction>

</cfcomponent>