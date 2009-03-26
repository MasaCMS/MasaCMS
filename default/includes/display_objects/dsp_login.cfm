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
<cfparam name="request.status" default="">
<cfparam name="request.linkServID" default="">
<cfparam name="request.isBlocked" default="false">
<cfset rbFactory=getSite().getRBFactory() />
<cfoutput>
<h2>#request.contentBean.getTitle()#</h2>
<div id="svLoginContainer">

	#request.contentBean.getSummary()# <!--- The page summary can be used to show some content before the user has logged in. Outputs only if there is content in the summary field. --->
	<h3>#rbFactory.getKey('user.pleaselogin')#</h3>
	<cfif request.status eq 'failed'>
		<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
		<cfset request.isBlocked=true />
		<p id="loginMsg" class="error">Your access has been temporarily blocked. <br/>Please try again later or contact your site administrator for assistance.</p>
		<cfelse>
		<p id="loginMsg" class="error">We're sorry, there is no user that matches <br />that Username and Password. Please try again.</p>
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
				<input type="hidden" name="linkServID" value="#request.linkServID#" />
				<input type="hidden" name="returnURL" value="#request.returnURL#" />
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
			<input type="hidden" name="linkServID" value="#request.linkServID#" />
			<input type="hidden" name="display" value="login" />
			<input type="hidden" name="returnURL" value="#request.returnURL#" />
			<cfif isdefined('msg2')>
			<span class="required"><cfif find('is not a valid',msg2)>#rbFactory.getResourceBundle().messageFormat(rbFactory.getKey('user.forgetnotvalid'),request.email)#<cfelse>#rbFactory.getKey('user.forgotsuccess')#</cfif></span></cfif>
			<input type="submit" value="Get password" class="submit" />
		</div>
	</form>

	<cfif application.settingsManager.getSite(request.siteid).getExtranetPublicReg()>
	<div id="notRegistered">
		<h3>#rbFactory.getKey('user.notregistered')# <a class="callToAction" href="#application.settingsManager.getSite(request.siteid).getEditProfileURL()#&returnURL=#urlencodedformat(request.returnURL)#">#rbFactory.getKey('user.signup')#.</a></h3>
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