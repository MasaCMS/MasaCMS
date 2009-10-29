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
<cfparam name="request.status" default="">
<cfparam name="request.linkServID" default="">
<cfparam name="request.isBlocked" default="false">
<cfset rbFactory=getSite().getRBFactory() />
<cfoutput>
<#getHeaderTag('headline')#>#request.contentBean.getTitle()#</#getHeaderTag('headline')#>
<div id="svLoginContainer">

	#request.contentBean.getSummary()# <!--- The page summary can be used to show some content before the user has logged in. Outputs only if there is content in the summary field. --->
	<h3>#rbFactory.getKey('user.pleaselogin')#</h3>
	<cfif request.status eq 'failed'>
		<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
		<cfset request.isBlocked=true />
		<p id="loginMsg" class="error">#rbFactory.getKey('user.loginblocked')#</p>
		<cfelse>
		<p id="loginMsg" class="error">#rbFactory.getKey('user.loginfailed')#</p>
		</cfif>
	</cfif>
	<cfif not request.isBlocked>
	<form id="login" name="form1" method="post" action="#application.configBean.getIndexFile()#?nocache=1" onsubmit="return validate(this);">
		<fieldset>
			<ol>
				<li class="req">
					<label for="txtUsername">#rbFactory.getKey('user.username')#<ins> (#htmlEditFormat(rbFactory.getKey('user.required'))#)</ins></label>
					<input type="text" id="txtUsername" class="text" name="username" required="true" message="#htmlEditFormat(rbFactory.getKey('user.usernamerequired'))#" />
				</li>
				<li class="req">
					<label for="txtPassword">#rbFactory.getKey('user.password')#<ins> (#htmlEditFormat(rbFactory.getKey('user.required'))#)</ins></label>
					<input type="password" id="txtPassword" class="text" name="password" required="true" message="#htmlEditFormat(rbFactory.getKey('user.passwordrequired'))#" />
				</li>
				<li>
					<input type="checkbox" id="cbRememberMe" class="checkbox first" name="rememberMe" value="1" />
					<label for="cbRememberMe">#htmlEditFormat(rbFactory.getKey('user.rememberme'))#</label>
				</li>
			</ol>
			<div class="buttons">
				<input type="hidden" name="doaction" value="login" />
				<input type="hidden" name="linkServID" value="#HTMLEditFormat(request.linkServID)#" />
				<input type="hidden" name="returnURL" value="#HTMLEditFormat(request.returnURL)#" />
				<input type="submit" value="#htmlEditFormat(rbFactory.getKey('user.login'))#" />
			</div>
		</fieldset>
	</form>
	<p class="required">#rbFactory.getKey('user.requiredfields')#</p>
	<form name="form2" method="post" action="#application.configBean.getIndexFile()#?nocache=1" id="sendLogin" onsubmit="return validate(this);">
		<fieldset>
			<legend>#rbFactory.getKey('user.forgetusernameorpassword')#</legend>
			<cfif request.doaction eq 'sendlogin'>
			<cfset msg2=application.userManager.sendLoginByEmail('#request.email#', '#request.siteid#','#urlencodedformat("#request.returnURL#")#')>
			<cfelse>
			<p>#rbFactory.getKey('user.forgotloginmessage')#</p>
			</cfif>
			<ol>
				<li>
					<label for="txtEmail">#rbFactory.getKey('user.email')#</label>
					<input id="email" name="email" type="text" class="text" validate="email" required="true" message="#htmlEditFormat(rbFactory.getKey('user.emailvalidate'))#" />
				</li>
			</ol>
		</fieldset>
		<div class="buttons">
			<input type="hidden" name="doaction" value="sendlogin" />
			<input type="hidden" name="linkServID" value="#HTMLEditFormat(request.linkServID)#" />
			<input type="hidden" name="display" value="login" />
			<input type="hidden" name="returnURL" value="#HTMLEditFormat(request.returnURL)#" />
			<cfif isdefined('msg2')>
			<span class="required"><cfif find('is not a valid',msg2)>#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('user.forgetnotvalid'),request.email)#<cfelse>#rbFactory.getKey('user.forgotsuccess')#</cfif></span></cfif>
			<input type="submit" value="#HTMLEditFormat(rbFactory.getKey('user.getpassword'))#" class="submit" />
		</div>
	</form>

	<cfif application.settingsManager.getSite(request.siteid).getExtranetPublicReg()>
	<div id="notRegistered">
		<#getHeaderTag('subHead1')#>#rbFactory.getKey('user.notregistered')# <a class="callToAction" href="#application.settingsManager.getSite(request.siteid).getEditProfileURL()#&returnURL=#urlencodedformat(request.returnURL)#">#rbFactory.getKey('user.signup')#.</a></#getHeaderTag('subHead1')#>
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