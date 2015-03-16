<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<cfoutput>
		<div class="mura-async-object" 
			data-object="login" 
			data-returnurl="#esapiEncode('html_attr',$.event('returnurl'))#">
		</div>
	</cfoutput>
<cfelse>
	<cfif not isBoolean(variables.$.event('isBlocked'))>
		<cfset variables.$.event('isBlocked',false)>
	</cfif>
	<cfoutput>
		<div id="svLoginContainer" class="mura-login-container #this.loginWrapperClass#">
			<div class="#this.loginWrapperInnerClass#">
				<#variables.$.getHeaderTag('subhead1')#>#variables.$.content('title')#</#variables.$.getHeaderTag('subhead1')#>

				<!--- 
					SUMMARY
					The page summary can be used to show some content before the user has logged in. 
					Outputs only if there is content in the summary field. 
				--->
				#variables.$.content('summary')#

				<cfif variables.$.event('status') eq 'failed'>
					<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
					<cfset variables.$.event('isBlocked',true) />
					<p id="loginMsg" class="#this.alertDangerClass#">#variables.$.rbKey('user.loginblocked')#</p>
					<cfelse>
					<p id="loginMsg" class="#this.alertDangerClass#">#variables.$.rbKey('user.loginfailed')#</p>
					</cfif>
				</cfif>

				<cfif not variables.$.event('isBlocked')>
					<form role="form" id="login" class="mura-login-form #this.loginFormClass# <cfif this.formWrapperClass neq "">#this.formWrapperClass#</cfif>" name="frmLogin" method="post" action="?nocache=1" onsubmit="return mura.validateForm(this);" novalidate="novalidate">
						<fieldset>
							<legend>#variables.$.rbKey('user.pleaselogin')#</legend>
							<!--- Username --->
							<div class="req #this.loginFormGroupWrapperClass#">
								<label for="txtUsername" class="#this.loginFormFieldLabelClass#">
									#variables.$.rbKey('user.username')#
									<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
								</label>
								<div class="#this.loginFormFieldWrapperClass#">
									<input class="#this.loginFormFieldClass#" type="text" id="txtUsername" placeholder="#variables.$.rbKey('user.username')#" name="username" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.usernamerequired'))#" autofocus>
								</div>
							</div>
		
							<!--- Password --->
							<div class="req #this.loginFormGroupWrapperClass#">
								<label for="txtPassword" class="#this.loginFormFieldLabelClass#">
									#variables.$.rbKey('user.password')#
									<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
								</label>
								<div class="#this.loginFormFieldWrapperClass#">
									<input class="#this.loginFormFieldClass#" type="password" id="txtPassword" name="password" placeholder="#variables.$.rbKey('user.password')#" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.passwordrequired'))#">
								</div>
							</div>
		
							<!--- Remember Me --->
							<div class="#this.loginFormGroupWrapperClass#">
								<div class="#this.loginFormPrefsClass#">
									<label class="#this.loginFormCheckboxClass#" for="cbRememberMe" >
										<input type="checkbox" id="cbRememberMe" name="rememberMe" value="1"> #htmlEditFormat(variables.$.rbKey('user.rememberme'))#
									</label>
								</div>
							</div>
		
							<!--- Login Button --->
							<div class="#this.loginFormGroupWrapperClass#">
								<div class="#this.loginFormSubmitWrapperClass#">
									<button type="submit" class="#this.loginFormSubmitClass#">#htmlEditFormat(variables.$.rbKey('user.login'))#</button>
								</div>
							</div>
		
							<input type="hidden" name="doaction" value="login">
							<input type="hidden" name="linkServID" value="#HTMLEditFormat(variables.$.event('linkServID'))#">
							<input type="hidden" name="returnURL" value="#HTMLEditFormat(variables.$.event('returnURL'))#">
						</fieldset>
					</form>


					<cfif variables.$.event('doaction') eq 'sendlogin'>
						<cfset msg2=application.userManager.sendLoginByEmail(variables.$.event('email'), variables.$.event('siteID'),'#urlencodedformat(variables.$.event('returnURL'))#')>
					</cfif>

					<!--- Forgot Username / Password Form --->
					<form name="form2" class="mura-send-login #this.forgotPasswordFormClass# <cfif this.formWrapperClass neq "">#this.formWrapperClass#</cfif>" method="post" action="?nocache=1" id="sendLogin" onsubmit="return mura.validateForm(this);" novalidate="novalidate">
						<fieldset>
							<legend>#variables.$.rbKey('user.forgetusernameorpassword')#</legend>
							<p>#variables.$.rbKey('user.forgotloginmessage')#</p>
		
							<cfif isdefined('msg2')>
								<cfif FindNoCase('is not a valid',msg2)><div class="#this.loginFormErrorClass#">#HTMLEditFormat(variables.$.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.$.rbKey('user.forgotnotvalid'),variables.$.event('email')))#<cfelseif FindNoCase('no account',msg2)><div class="#this.alertDangerClass#">#HTMLEditFormat(variables.$.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.$.rbKey('user.forgotnotfound'),variables.$.event('email')))#<cfelse><div class="#this.alertSuccessClass#">#variables.$.rbKey('user.forgotsuccess')#</cfif></div>
							</cfif>
		
							<!--- Email --->
							<div class="#this.loginFormGroupWrapperClass#">
								<label class="#this.loginFormFieldLabelClass#" for="txtEmail">#variables.$.rbKey('user.email')#</label>
								<div class="#this.loginFormFieldWrapperClass#">
									<input id="txtEmail" name="email" class="#this.loginFormFieldClass#" type="text" placeholder="#variables.$.rbKey('user.email')#" data-validate="email" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.emailvalidate'))#" />
								</div>
							</div>
		
							<!--- Submit Button --->
							<div class="#this.loginFormGroupWrapperClass#">
								<div class="#this.loginFormSubmitWrapperClass#">
									<button type="submit" class="#this.loginFormSubmitClass#">#htmlEditFormat(variables.$.rbKey('user.getpassword'))#</button>
								</div>
							</div>
		
							<input type="hidden" name="doaction" value="sendlogin">
							<input type="hidden" name="linkServID" value="#HTMLEditFormat(variables.$.event('linkServID'))#">
							<input type="hidden" name="display" value="login">
							<input type="hidden" name="returnURL" value="#HTMLEditFormat(variables.$.event('returnURL'))#">
						</fieldset>
					</form>

					<!--- Not Registered? --->
					<cfif variables.$.siteConfig('ExtranetPublicReg')>
						<div id="notRegistered" class="mura-not-registered">
							<#variables.$.getHeaderTag('subHead1')# class="center">#variables.$.rbKey('user.notregistered')# <a class="#this.notRegisteredLinkClass#" href="#variables.$.siteConfig('editProfileURL')#&returnURL=#urlencodedformat(variables.$.event('returnURL'))#">#variables.$.rbKey('user.signup')#</a></#variables.$.getHeaderTag('subHead1')#>
						</div>
					</cfif>

					<script type="text/javascript">
					   document.getElementById("login").elements[0].focus();
					</script>
				</cfif>
			</div>
		</div>
	</cfoutput>
</cfif>