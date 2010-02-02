<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfset isBlocked=false />
<div id="login"><cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'login.pleaselogin')#</h2>
<cfif attributes.status eq 'denied'>
<p class="error">#application.rbFactory.getKeyValue(session.rb,'login.denied')#</p>
<cfelseif attributes.status eq 'failed'>
<cfif structKeyExists(session, "blockLoginUntil") and isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
<cfset isBlocked=true />
<p class="error">#application.rbFactory.getKeyValue(session.rb,'login.blocked')#</p>
<cfelse>
<p class="error">#application.rbFactory.getKeyValue(session.rb,'login.failed')#</p>
</cfif>
</cfif>

<cfif not isBlocked>
<form id="loginForm" name="frmLogin" method="post" action="index.cfm">
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,'login.username')#</dt>
<dd><input id="username" name="username" type="text" class="text"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'login.password')#</dt>
<dd><input id="password" type="password" name="password" class="text" onKeyPress="checkKeyPressed(event, 'loginForm')"></dd>
<dt>Language</dt>
<dd><select name="rb">
	<option value="en">English</option>
	<option value="de"<cfif cookie.rb eq "de"> selected</cfif>>Deutsch</option>
	<option value="fr"<cfif cookie.rb eq "fr"> selected</cfif>>Fran&ccedil;ais</option>
	<option value="hu"<cfif cookie.rb eq "hu"> selected</cfif>>Hungarian</option>
	<!---<option value="es">Spanish</option>--->
	</select>
</dd>
</dl>
<p class="rememberMe"><input type="checkbox" id="rememberMe" name="rememberMe" value="1" /> <label for="rememberMe">#application.rbFactory.getKeyValue(session.rb,'login.rememberme')#</label></p>
<a class="submit" href="javascript:document.frmLogin.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'login.login')#</span></a>
	<input name="returnUrl" type="hidden" value="#HTMLEditFormat(attributes.returnURL)#">
<input type="hidden" name="fuseaction" value="cLogin.login">
 </form>

	<form id="sendLogin"  class="separate" name="sendLogin" method="post" action="index.cfm?fuseaction=cLogin.main" onsubmit="javascript:if(document.sendLogin.email.value !=''){return true;}else{return false;}">
	<dl>
	<dt>#application.rbFactory.getKeyValue(session.rb,'login.forgetpassword')#</dt>
	<dd><cfif attributes.status eq 'sendLogin'>
	  <cfset msg=application.userManager.sendLoginByEmail('#attributes.email#','','#urlencodedformat("#listFirst(cgi.http_host,":")##cgi.SCRIPT_NAME#")#')>
	<cfif left(msg,2) eq "No">
	#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"login.noaccountexists"),attributes.email)#		
	<cfelseif left(msg,4) eq "Your">
	#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"login.messagesent"),attributes.email)#
	<cfelse>	#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"login.invalidemail"),attributes.email)#
	</cfif>
	<cfelse>
	#application.rbFactory.getKeyValue(session.rb,'login.enteremail')#
	</cfif></dd>
        <dd><input id="email" name="email" type="text" class="text" align="absmiddle" onKeyPress="checkKeyPressed(event, 'sendLogin')"/>
 		<a class="submit" href="javascript:document.sendLogin.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'login.submit')#</span></a>
		<input type="hidden" name="status" value="sendlogin" />
		<input name="returnURL" type="hidden" value="#HTMLEditFormat(attributes.returnURL)#"></dd>
		</dl>
    </form>
</cfif></cfoutput>
</div>