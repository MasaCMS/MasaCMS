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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfset isBlocked=false/>
<cfparam name="msg" default="">

<cfoutput>

<cfsavecontent variable="focusblockheader">
  <div class="focus-block-header">
  	<img src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/images/mura-logo-black@2x.png" class="mura-logo">
  </div><!-- /focus-block-header -->
</cfsavecontent>

<div id="mura-login">
<!---
		<cfif rc.$.event('status') eq 'challenge' and isdefined('session.mfa')>
			<cfif rc.compactDisplay eq 'true'>
				<h1 class="page-heading">#rc.$.rbKey('login.authorizationcode')#</h1>
			<cfelse>
				<h1 class="page-heading">#rc.$.rbKey('login.authorizationcode')#</h1>
			</cfif>
		<cfelse>
			<cfif rc.compactDisplay eq 'true'>
				<h1 class="page-heading">#rc.$.rbKey('login.pleaselogin')#</h1>
			<cfelse>
				<h1 class="page-heading">#rc.$.rbKey('login.pleaselogin')#</h1>
			</cfif>
		</cfif>
--->
	<div class="block mura-focus-block animated" <cfif rc.status eq 'sendLogin'>style="display:none;"</cfif> id="mura-login-panel">

		#focusblockheader#

	    <div class="block-content">

				<cfset errorMessage = '' />
				<cfset isBlocked = StructKeyExists(session, "blockLoginUntil") and isDate(session.blockLoginUntil) and session.blockLoginUntil gt now() />

				<cfif isBlocked>
					<cfset errorMessage = rc.$.rbKey('login.blocked') />
				<cfelseif rc.status eq 'denied'>
					<cfset errorMessage = rc.$.rbKey('login.denied') />
				<cfelseif rc.status eq 'failed'>
					<cfset errorMessage = rc.$.rbKey('login.failed') />
				<cfelseif rc.$.event('failedchallenge') eq 'true'>
					<cfset errorMessage = rc.$.rbKey('login.incorrectauthorizationcode') />
				</cfif>

				<cfif Len(errorMessage)>
					<div class="alert alert-error">
						<span>#errorMessage#</span>
					</div>
				</cfif>

				<!--- Do not change the html comment below --->
				<!-- mura-primary-login-token -->

				<cfif not isBlocked>
					<cfif rc.$.event('status') eq 'challenge' and isdefined('session.mfa')>
						<cfset output=rc.$.renderEvent('onAdminMFAChallengeRender')>
						<cfif len(output)>
							#output#
						<cfelse>
							<cfif rc.$.getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false) and not len(rc.$.event('authcode'))>
								<div class="alert alert-error"><span>#rc.$.rbKey('login.newdevice')#</span></div>
							</cfif>

							<cfif len(rc.$.event('authcode'))>
								<div class="alert alert-error"><span>#rc.$.rbKey('login.authcodeerror')#</span></div>
							</cfif>

							<form novalidate="novalidate" id="loginForm" name="frmLogin" method="post" action="index.cfm" onsubmit="return submitForm(this);">

							<div class="mura-control-group">
				      			<label>#rc.$.rbKey('login.enteremailedauthcode')#</label>
								<div class="input-prepend">
								  	<span class="add-on"><i class="mi-envelope"></i></span><input autocomplete="off" id="authcode" name="authcode" type="text" placeholder="#esapiEncode('html_attr',rc.$.rbKey('login.authorizationcode'))#" />
								</div>
								<cfif rc.$.getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false)>
									<input type="hidden" name="rememberdevice" value="1"/>
									<!---
									<div id="remember-device">
							      	<input type="checkbox" id="rememberdevice" name="rememberdevice" value="1" />
							     	<label for="rememberdevice">#rc.$.rbKey('login.rememberdevice')#
							      	</label>
									</div>
									--->
								</cfif>
							</div>
							<div class="mura-focus-actions">
								<input type="submit" class="btn" value="#rc.$.rbKey('login.submit')#" />
							</div>
							<input type="hidden" name="muraAction" value="cLogin.login">
							<input type="hidden" name="status" value="challenge">
							<input type="hidden" name="attemptChallenge" value="true">
							<input type="hidden" name="isadminlogin" value="true">
							#rc.$.renderCSRFTokens(format='form',context='login')#
							</form>
						</cfif>
					<cfelse>
						<form novalidate="novalidate" id="loginForm" name="frmLogin" method="post" action="index.cfm" onsubmit="return submitForm(this);">
						  <cfif listFindNoCase($.globalConfig().getEnableOauth(), 'google') or
						   		listFindNoCase($.globalConfig().getEnableOauth(), 'facebook')>
								<div class="mura-login-auth-wrapper">
			              <!--- Use Google oAuth Button --->
			              <cfif listFindNoCase($.globalConfig().getEnableOauth(), 'google')>
			                    <a href="#$.getBean('googleLoginProvider').generateAuthUrl(session.urltoken)#" title="#rc.$.rbKey('login.loginwithgoogle')#" class="mura-login-auth-btn ggl">
			                    	<i class="mi-google"></i>
			                    	<span>#rc.$.rbKey('login.loginwithgoogle')#</span>
			                    </a>
			              </cfif>
			              <!--- Use Facebook oAuth Button --->
			              <cfif listFindNoCase($.globalConfig().getEnableOauth(), 'facebook')>
			                  <a href="#$.getBean('facebookLoginProvider').generateAuthUrl(session.urltoken)#" title="#rc.$.rbKey('login.loginwithfacebook')#" class="mura-login-auth-btn fb">
			                  	<i class="mi-facebook"></i>
			                  	<span>#rc.$.rbKey('login.loginwithfacebook')#</span>
			                  </a>
			              </cfif>
			              <div class="text-divider"><span>#rc.$.rbKey('login.or')#</span></div>
										<h3 class="center mura-login-auth-heading">#rc.$.rbKey('login.loginwithcredentials')#</h3>
       					</div>
			        </cfif>

							<div class="mura-control-group">
						    <label>
						    	#rc.$.rbKey('login.username')#
						    </label>
								<input id="username" name="username" type="text" autofocus="autofocus">
							</div>

							<div class="mura-control-group">
								<label>#rc.$.rbKey('login.password')#</label>
								<input id="password" type="password" name="password" autocomplete="off">
					  	</div>

							<cfif rc.$.getBean('configBean').getValue(property='MFA',defaultValue=false)>
    							<div class="mura-control-group half">
    								<!--- <label>Language</label> --->
    								<label></label>
    				      	<select name="rb">
    									<option value="en_US">English</option>
											<!---<option value="zh_CN"<cfif cookie.rb eq "zh_CN"> selected</cfif>>Chinese</option>--->
											<option value="da"<cfif cookie.rb eq "da"> selected</cfif>>Danish</option>
    									<option value="de"<cfif cookie.rb eq "de"> selected</cfif>>Deutsch</option>
    									<option value="nl"<cfif cookie.rb eq "nl"> selected</cfif>>Dutch</option>
											<option value="fil"<cfif cookie.rb eq "fil"> selected</cfif>>Filipino</option>
    									<option value="fr"<cfif cookie.rb eq "fr"> selected</cfif>>Fran&ccedil;ais</option>
    									<option value="hu"<cfif cookie.rb eq "hu"> selected</cfif>>Hungarian</option>
											<option value="id"<cfif cookie.rb eq "id"> selected</cfif>>Indonesian</option>
    									<option value="it"<cfif cookie.rb eq "it"> selected</cfif>>Italian</option>
    									<option value="pt"<cfif cookie.rb eq "pt"> selected</cfif>>Portuguese</option>
                      <option value="ru"<cfif cookie.rb eq "ru"> selected</cfif>>Русский</option>
    									<option value="es"<cfif cookie.rb eq "es"> selected</cfif>>Spanish</option>
    								</select>
    						  	</div>
							<cfelse>
								<div class="mura-control-group half" id="remember-me">
        				          <label class="css-input switch switch-sm switch-primary">
        				              <input type="checkbox" id="rememberMe" name="rememberMe" value="1" ><span></span> #rc.$.rbKey('login.rememberme')#
        				          </label>
								</div>
								<div class="mura-control-group half">
									<!--- <label>Language</label> --->
									<label></label>
								  <select name="rb">
										<option value="en_US">English</option>
										<!---<option value="zh_CN"<cfif cookie.rb eq "zh_CN"> selected</cfif>>Chinese</option>--->
										<option value="da"<cfif cookie.rb eq "da"> selected</cfif>>Danish</option>
										<option value="de"<cfif cookie.rb eq "de"> selected</cfif>>Deutsch</option>
										<option value="nl"<cfif cookie.rb eq "nl"> selected</cfif>>Dutch</option>
										<option value="fil"<cfif cookie.rb eq "fil"> selected</cfif>>Filipino</option>
										<option value="fr"<cfif cookie.rb eq "fr"> selected</cfif>>Fran&ccedil;ais</option>
										<option value="hu"<cfif cookie.rb eq "hu"> selected</cfif>>Hungarian</option>
										<option value="id"<cfif cookie.rb eq "id"> selected</cfif>>Indonesian</option>
										<option value="it"<cfif cookie.rb eq "it"> selected</cfif>>Italian</option>
										<option value="pt"<cfif cookie.rb eq "pt"> selected</cfif>>Portuguese</option>
										<option value="ru"<cfif cookie.rb eq "ru"> selected</cfif>>Русский</option>
										<option value="es"<cfif cookie.rb eq "es"> selected</cfif>>Spanish</option>
									</select>
								</div>

							</cfif>

							<div class="mura-focus-actions">
								<button type="submit"> #rc.$.rbKey('login.login')#</button>
							</div>

							<input name="returnUrl" type="hidden" value="#esapiEncode('html_attr',rc.returnURL)#">
							<input type="hidden" name="muraAction" value="cLogin.login">
							<input type="hidden" name="isAdminLogin" value="true">
							<input type="hidden" name="compactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#">
							#rc.$.renderCSRFTokens(format='form',context='login')#
						</form>

						<cfif not isBoolean(application.configBean.getValue('showadminloginhelp')) or application.configBean.getValue('showadminloginhelp')>
							<div id="pw-link">
								<label><a href="##" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,'login.forgetpassword')#</a></label>
							</div>
						</cfif>

				</div><!-- /block-content -->
			</div><!-- /mura-focus-block -->

		<div class="block mura-focus-block animated" id="mura-password-panel" <cfif not rc.status eq 'sendLogin'>style="display:none;"</cfif>>

			#focusblockheader#

	  	  <div class="block-content">

						<cfif not isBoolean(application.configBean.getValue('showadminloginhelp')) or application.configBean.getValue('showadminloginhelp')>
							<form novalidate="novalidate" id="sendLogin" name="sendLogin" method="post" action="./?muraAction=cLogin.main" onsubmit="return submitForm(this);">

							<div class="mura-control-group">
								<h2>#rc.$.rbKey('login.forgetpassword')#</h2>
									  <cfset alertclass = ''>
										<cfsavecontent variable="pwresponse">
										<cfif rc.status eq 'sendLogin'>
										  <cfset msg=application.userManager.sendLoginByEmail('#rc.email#','','#esapiEncode("url","#listFirst(cgi.http_host,":")##cgi.SCRIPT_NAME#")#')>
												<cfif left(msg,2) eq "No">
												#esapiEncode('html',application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("login.noaccountexists"),rc.email))#
												<cfset alertclass = "alert alert-error">
												<cfelseif left(msg,4) eq "Your">
												#esapiEncode('html',application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("login.messagesent"),rc.email))#
												<cfset alertclass = "alert">
												<cfelse>	#esapiEncode('html',application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("login.invalidemail"),rc.email))#
												<cfset alertclass = "alert alert-error">
												</cfif>
											<cfelse>
											#rc.$.rbKey('login.enteremail')#
											</cfif>
								</cfsavecontent>
									<p id="pw-response" class="#alertclass# clear-both">#pwresponse#</p>
									<div class="mura-control-group">
										<label>#rc.$.rbKey('login.emailaddress')#</label>
										<input id="email" name="email" type="text" autofocus="autofocus">
									</div>
							</div>
							<div class="mura-focus-actions">
							 	<input type="submit" class="btn" value="#rc.$.rbKey('login.submit')#" />
							 </div>
							<input type="hidden" name="status" value="sendlogin" />
							<input name="returnURL" type="hidden" value="#esapiEncode('html_attr',rc.returnURL)#">
							<input type="hidden" name="isAdminLogin" value="true">
							<input type="hidden" name="compactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#">
						   </form>

						<div id="login-link">
							 <label><a href="##" onclick="return false;">Return to login</a></label>
						</div>

						</cfif>
					</cfif>
				</cfif>

			</div><!-- /block-content -->
		</div><!-- /mura-focus-block -->

</div><!-- /mura-login -->
</cfoutput>

<script type="text/javascript">
jQuery(document).ready(function(){
<cfif rc.compactDisplay eq "true">
	if (top.location != self.location) {
		if(jQuery("#ProxyIFrame").length){
			jQuery("#ProxyIFrame").load(
				function(){
					frontEndProxy.post({cmd:'setWidth',width:400});
				}
			);
		} else {
			frontEndProxy.post({cmd:'setWidth',width:400});
		}
	}
</cfif>

	jQuery('#pw-link a').click(function(){
		jQuery('#mura-login-panel').removeClass('flipInY').addClass('flipOutY').hide();
		jQuery('#mura-password-panel').removeClass('flipOutY').show().addClass('flipInY');
		document.getElementById('email').focus();
	});
	jQuery('#login-link a').click(function(){
		jQuery('#mura-password-panel').removeClass('flipInY').addClass('flipOutY').hide();
		jQuery('#pw-response').removeClass('alert').removeClass('alert-error').html('<cfoutput>#esapiEncode('html_attr',rc.$.rbKey('login.enteremail'))#</cfoutput>');
		jQuery('#mura-login-panel').removeClass('flipOutY').show().addClass('flipInY');
		document.getElementById('username').focus();
	});

});
</script>
