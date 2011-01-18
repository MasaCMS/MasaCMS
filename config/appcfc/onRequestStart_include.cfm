<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfparam name="local" default="#structNew()#">
<cfif ( NOT structKeyExists( application, "setupComplete" ) or not application.appInitialized or structKeyExists(url,application.appReloadKey)) and isDefined("onApplicationStart")>
	<cfset onApplicationStart()>
</cfif>

<cfprocessingdirective pageencoding="utf-8"/>
<cfsetting requestTimeout = "1000">
	
<!--- Making sure that session is valid --->
<cfif structKeyExists(session,"mura")>
	<cfif 
		(not session.mura.isLoggedIn and isValid("UUID",listFirst(getAuthUser(),"^")))
			or
		(session.mura.isLoggedIn and not isValid("UUID",listFirst(getAuthUser(),"^")))	>
		
		<cfset application.loginManager.logout()>	
	</cfif>
</cfif>
	
<cfset application.userManager.setUserStructDefaults()>
	
<!---settings.custom.vars.cfm reference is for backwards compatability --->
<cfif fileExists(expandPath("/muraWRM/config/settings.custom.vars.cfm"))>
	<cfinclude template="/muraWRM/config/settings.custom.vars.cfm">
</cfif>
<cfif not StructKeyExists(cookie, 'userid')>
	  <cfcookie name="userid" expires="never" value="">
</cfif>
	
<cfif not StructKeyExists(cookie, 'userHash')>
   <cfcookie name="userHash" expires="never" value="">
</cfif>
	
<cfif not IsDefined("Cookie.CFID") AND IsDefined("Session.CFID")>
	<cfcookie name="CFID" value="#Session.CFID#">
	<cfcookie name="CFTOKEN" value="#Session.CFTOKEN#">
</cfif>
	
<cftry>
	<cfif cookie.userid eq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 1 and session.mura.isLoggedIn>
	<cfcookie name="userid" value="#session.mura.userID#" expires="never" />
	<cfcookie name="userHash" value="#encrypt(application.userManager.readUserHash(session.mura.userID).userHash,application.configBean.getEncryptionKey(),'cfmx_compat','hex')#" expires="never" />
	</cfif>
	
	<cfif cookie.userid neq '' and not session.mura.isLoggedIn>
	<cfset application.loginManager.rememberMe(cookie.userid,decrypt(cookie.userHash,application.configBean.getEncryptionKey(),"cfmx_compat",'hex')) />
	</cfif>
	
	<cfif cookie.userid neq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 0 and session.mura.isLoggedIn>
	<cfcookie name="userid" value="" expires="never" />
	<cfcookie name="userHash" value="" expires="never" />
	</cfif>
	
	<cfif not structKeyExists(cookie,"originalURLToken")>
	<cfparam name="session.trackingID" default="#application.utility.getUUID()#">
	<cfcookie name="originalURLToken" value="#session.trackingID#" expires="never" />
	</cfif>
<cfcatch></cfcatch>
</cftry>

<!--- look to see is there is a custom remote IP header in the settings.ini.cfm --->
<cfset remoteIPHeader=application.configBean.getValue("remoteIPHeader")>
<cfif len(remoteIPHeader)>
	<cftry>
		<cfif StructKeyExists(GetHttpRequestData().headers, remoteIPHeader)>
	    	<cfset request.remoteAddr = GetHttpRequestData().headers[remoteIPHeader]>
	    <cfelse>
			<cfset request.remoteAddr = CGI.REMOTE_ADDR>
	    </cfif>
		<cfcatch type="any"><cfset request.remoteAddr = CGI.REMOTE_ADDR></cfcatch>
	</cftry>
<cfelse>
	<cfset request.remoteAddr = CGI.REMOTE_ADDR>
</cfif>

<cfif isDefined("form.mobileFormat") and isBoolean(form.mobileFormat)>
	<cfcookie name="mobileFormat" value="#form.mobileFormat#" expires="never" />	
<cfelseif isDefined("url.mobileFormat") and isBoolean(url.mobileFormat)>
	<cfcookie name="mobileFormat" value="#url.mobileFormat#" expires="never" />
</cfif>

<cfif not isdefined("cookie.mobileFormat")>
	<cfif reFindNoCase("android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
		<cfcookie name="mobileFormat" value="true" expires="never" />
	<cfelse>	
		<cfcookie name="mobileFormat" value="false" expires="never" />
	</cfif>	
</cfif>

<cfset request.muraMobileRequest=cookie.mobileFormat>

<cfif not request.hasCFApplicationCFM and not fileExists("#expandPath('/muraWRM/config')#/cfapplication.cfm")>
	<cfset application.serviceFactory.getBean("fileWriter").writeFile(file="#expandPath('/muraWRM/config')#/cfapplication.cfm", output='<!--- Add Custom Application.cfc Vars Here --->')>	
</cfif>

<cfif isDefined("application.changesetManager")>
	<cfset application.changesetManager.publishBySchedule()>
</cfif>

<cfif structKeyExists(request,"doMuraGlobalSessionStart")>
	<cfset application.pluginManager.executeScripts('onGlobalSessionStart')>
</cfif>
<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">

