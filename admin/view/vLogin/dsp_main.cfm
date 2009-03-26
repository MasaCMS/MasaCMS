<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfset isBlocked=false />
<div id="login"><cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'login.pleaselogin')#</h2>
<cfif attributes.status eq 'denied'>
#application.rbFactory.getKeyValue(session.rb,'login.denied')#
<cfelseif attributes.status eq 'failed'>
<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
<cfset isBlocked=true />
#application.rbFactory.getKeyValue(session.rb,'login.blocked')#
<cfelse>
#application.rbFactory.getKeyValue(session.rb,'login.failed')#
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
	<!---<option value="es">Spanish</option>
	<option value="fr">French</option>--->
	</select>
</dd>
</dl>
<p class="rememberMe"><input type="checkbox" id="rememberMe" name="rememberMe" value="1" /> <label for="rememberMe">#application.rbFactory.getKeyValue(session.rb,'login.rememberme')#</label></p>
<a class="submit" href="javascript:document.frmLogin.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'login.login')#</span></a>
	<input name="returnUrl" type="hidden" value="#attributes.returnURL#">
<input type="hidden" name="fuseaction" value="cLogin.login">
 </form>

	<form id="sendLogin"  class="separate" name="sendLogin" method="post" action="index.cfm?fuseaction=cLogin.main" onsubmit="javascript:if(document.sendLogin.email.value !=''){return true;}else{return false;}">
	<dl>
	<dt>#application.rbFactory.getKeyValue(session.rb,'login.forgetpassword')#</dt>
	<dd><cfif attributes.status eq 'sendLogin'>
	  <cfset msg=application.userManager.sendLoginByEmail('#attributes.email#','','#urlencodedformat("#cgi.SERVER_NAME##cgi.SCRIPT_NAME#")#')>
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
		<input name="returnURL" type="hidden" value="#attributes.returnURL#"></dd>
		</dl>
    </form>
</cfif></cfoutput>
</div>