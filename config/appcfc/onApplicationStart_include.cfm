<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfparam name="local" default="#structNew()#">
<cfparam name="application.appInitializedTime" default="" />
<cfparam name="application.appInitialized" default="false" />
<cfparam name="application.appAutoUpdated" default="false" />
<cfparam name="application.appReloadKey" default="appreload" />
<cfparam name="application.broadcastInit" default="false" />
<cfparam name="application.sessionTrackingThrottle" default="true"/>
<cfparam name="application.instanceID" default="#createUUID()#" />
<cfparam name="application.CFVersion" default="#listFirst(SERVER.COLDFUSION.PRODUCTVERSION)#" />
<cfparam name="application.setupComplete" default="false" />
<!--- this is here for CF8 compatibility --->
<cfset variables.baseDir=this.baseDir>
<cfprocessingdirective pageencoding="utf-8"/>
<cfsetting requestTimeout = "1000"> 

<!--- do a settings setup check --->
<cfif NOT application.setupComplete OR (not application.appInitialized or structKeyExists(url,application.appReloadKey) )>
	<cfif getProfileString( variables.basedir & "/config/settings.ini.cfm", "settings", "mode" ) eq "production">
		<cfif directoryExists( variables.basedir & "/config/setup" )>
			<cfset application.setupComplete = false />
			<!--- check the settings --->
			<cfparam name="application.setupSubmitButton" default="A#hash( createUUID() )#" />
			<cfparam name="application.setupSubmitButtonComplete" default="A#hash( createUUID() )#" />
			
			<cfif trim( getProfileString( variables.basedir & "/config/settings.ini.cfm" , "production", "datasource" ) ) IS NOT ""
					AND (
						NOT isDefined( "FORM.#application.setupSubmitButton#" )
						AND
						NOT isDefined( "FORM.#application.setupSubmitButtonComplete#" )
						)
				>		
						
				<cfset application.setupComplete = true />
			<cfelse>
				<!--- check to see if the index.cfm page exists in the setup folder --->
				<cfif NOT fileExists( variables.basedir & "/config/setup/index.cfm" )>
					<cfthrow message="Your setup directory is incomplete. Please reset it up from the Mura source." />
				</cfif>

				<cfset application.setupComplete = false />
			</cfif>	
		<cfelse>
			<cfset application.setupComplete = true />
		</cfif>
	<cfelse>		
		<cfset application.setupComplete=true>
	</cfif>
</cfif>	

<cfif application.setupComplete and (not application.appInitialized or structKeyExists(url,application.appReloadKey))>
	<cfif not structKeyExists(server,'railo')>
		<cflock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200">	
			<cfinclude template="onApplicationStart_internals.cfm">
		</cflock>
	<cfelse>
		<cfinclude template="onApplicationStart_internals.cfm">
	</cfif>	
</cfif> 