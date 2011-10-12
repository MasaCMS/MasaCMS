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

<cfif not isBoolean($.event('isBlocked'))>
	<cfset $.event('isBlocked',false)>
</cfif>

<cfoutput>
<#$.getHeaderTag('headline')#>#$.content('title')#</#$.getHeaderTag('headline')#>
<div id="svLoginContainer">

	#$.content('summary')# <!--- The page summary can be used to show some content before the user has logged in. Outputs only if there is content in the summary field. --->
	<#$.getHeaderTag('subhead1')#>#$.rbKey('user.pleaselogin')#</#$.getHeaderTag('subhead1')#>
	<cfif $.event('status') eq 'failed'>
		<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
		<cfset $.event('isBlocked',true) />
		<p id="loginMsg" class="error">#$.rbKey('user.loginblocked')#</p>
		<cfelse>
		<p id="loginMsg" class="error">#$.rbKey('user.loginfailed')#</p>
		</cfif>
	</cfif>
	<cfif not $.event('isBlocked')>
	<form id="login" name="frmLogin" method="post" action="?nocache=1" onsubmit="return validate(this);" novalidate="novalidate" >
		<fieldset>
			<ol>
				<li class="req">
					<label for="txtUsername">#$.rbKey('user.username')#<ins> (#htmlEditFormat($.rbKey('user.required'))#)</ins></label>
					<input type="text" id="txtUsername" class="text" name="username" required="true" message="#htmlEditFormat($.rbKey('user.usernamerequired'))#" />
				</li>
				<li class="req">
					<label for="txtPassword">#$.rbKey('user.password')#<ins> (#htmlEditFormat($.rbKey('user.required'))#)</ins></label>
					<input type="password" id="txtPassword" class="text" name="password" required="true" message="#htmlEditFormat($.rbKey('user.passwordrequired'))#" />
				</li>
				<li>
					<input type="checkbox" id="cbRememberMe" class="checkbox first" name="rememberMe" value="1" />
					<label for="cbRememberMe">#htmlEditFormat($.rbKey('user.rememberme'))#</label>
				</li>
			</ol>
			<div class="buttons">
				<input type="hidden" name="doaction" value="login" />
				<input type="hidden" name="linkServID" value="#HTMLEditFormat($.event('linkServID'))#" />
				<input type="hidden" name="returnURL" value="#HTMLEditFormat($.event('returnURL'))#" />
				<input type="submit" value="#htmlEditFormat($.rbKey('user.login'))#" />
			</div>
		</fieldset>
	</form>
	<p class="required">#$.rbKey('user.requiredfields')#</p>
	
	
	<cfif $.event('doaction') eq 'sendlogin'>
			<cfset msg2=application.userManager.sendLoginByEmail($.event('email'), $.event('siteID'),'#urlencodedformat($.event('returnURL'))#')>
	</cfif>
	
	<form name="form2" method="post" action="?nocache=1" id="sendLogin" onsubmit="return validate(this);" novalidate="novalidate">
		<fieldset>
			<legend>#$.rbKey('user.forgetusernameorpassword')#</legend>
			<p>#$.rbKey('user.forgotloginmessage')#</p>
			<ol>
				<li>
					<label for="txtEmail">#$.rbKey('user.email')#</label>
					<input id="email" name="email" type="text" class="text" validate="email" required="true" message="#htmlEditFormat($.rbKey('user.emailvalidate'))#" />
				</li>
			</ol>
		</fieldset>
		<cfif isdefined('msg2')>
		<cfif FindNoCase('is not a valid',msg2)><div class="error">#HTMLEditFormat($.siteConfig("rbFactory").getResourceBundle().messageFormat($.rbKey('user.forgotnotvalid'),$.event('email')))#<cfelseif FindNoCase('no account',msg2)><div class="error">#HTMLEditFormat($.siteConfig("rbFactory").getResourceBundle().messageFormat($.rbKey('user.forgotnotfound'),$.event('email')))#<cfelse><div class="notice">#$.rbKey('user.forgotsuccess')#</cfif></div>
		</cfif>
		<div class="buttons">
			<input type="hidden" name="doaction" value="sendlogin" />
			<input type="hidden" name="linkServID" value="#HTMLEditFormat($.event('linkServID'))#" />
			<input type="hidden" name="display" value="login" />
			<input type="hidden" name="returnURL" value="#HTMLEditFormat($.event('returnURL'))#" />
			<input type="submit" value="#HTMLEditFormat($.rbKey('user.getpassword'))#" class="submit" />
		</div>
	</form>

	<cfif $.siteConfig('ExtranetPublicReg')>
	<div id="notRegistered">
		<#$.getHeaderTag('subHead1')#>#$.rbKey('user.notregistered')# <a class="callToAction" href="#$.siteConfig('editProfileURL')#&returnURL=#urlencodedformat($.event('returnURL'))#">#$.rbKey('user.signup')#.</a></#$.getHeaderTag('subHead1')#>
	</div>
	</cfif>
	
	<script type="text/javascript">
	<!--
	   document.getElementById("login").elements[0].focus();
	-->
	</script>
		
	</cfif>
</cfoutput>
</div>