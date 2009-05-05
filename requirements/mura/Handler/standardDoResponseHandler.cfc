<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfswitch expression="#event.getValue('contentBean').getType()#">
	<cfcase value="File,Link">
	
		<cfset application.pluginManager.executeScripts('onRenderStart',event.getValue('siteID'), event)/>
			
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