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
<cfsilent>
	<cfset variables.$.loadShadowBoxJS() />
</cfsilent>
<cfoutput>
	<cfif variables.$.event('display') neq 'login'>
		<cfif not len(getPersonalizationID())>
			<div id="login" class="mura-user-tools-login #this.userToolsLoginWrapperClass#">
				<form role="form" class="#this.userToolsLoginFormClass#" action="<cfoutput>?nocache=1</cfoutput>" name="loginForm" method="post">
					<legend>#variables.$.rbKey('user.signin')#</legend>

					<!--- Username --->
					<div class="req #this.userToolsFormGroupWrapperClass#">
						<label class="#this.userToolsLoginFormLabelClass#" for="txtUserName">
							#variables.$.rbKey('user.username')#
							<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
						</label>
						<div class="#this.userToolsLoginFormInputWrapperClass#">
							<input type="text" id="txtUserName" name="username" class="#this.userToolsLoginFormInputClass#" placeholder="#variables.$.rbKey('user.username')#">
						</div>
					</div>

					<!--- Password --->
					<div class="req #this.userToolsFormGroupWrapperClass#">
						<label class="#this.userToolsLoginFormLabelClass#" for="txtPassword">
							#variables.$.rbKey('user.password')#
							<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
						</label>
						<div class="#this.userToolsLoginFormInputWrapperClass#">
							<input type="password" id="txtPassword" name="password" class="#this.userToolsLoginFormInputClass#" placeholder="#variables.$.rbKey('user.password')#">
						</div>
					</div>

					<!--- Remember Me --->
					<div class="#this.userToolsFormGroupWrapperClass#">
						<div class="#this.userToolsLoginFormFieldInnerClass#">
							<label class="#this.userToolsLoginFormCheckboxClass#" for="cbRemember">
								<input type="checkbox" id="cbRemember" name="rememberMe" value="1"> #variables.$.rbKey('user.rememberme')#
							</label>
						</div>
					</div>

					<div class="#this.userToolsFormGroupWrapperClass#">
						<div class="#this.userToolsLoginFormFieldInnerClass#">
							<input type="hidden" name="doaction" value="login">
							<button type="submit" class="#this.userToolsLoginFormSubmitClass#">#variables.$.rbKey('user.signin')#</button>
						</div>
					</div>
				</form>
			</div>
			<!--- Not Registered? --->
			<cfif application.settingsManager.getSite(variables.$.event('siteID')).getExtranetPublicReg()>
					<#variables.$.getHeaderTag('subHead2')#>#variables.$.rbKey('user.notregistered')# <a class="#this.userToolsNotRegisteredLinkClass#" href="#variables.$.siteConfig().getEditProfileURL()#&amp;returnURL=#urlEncodedFormat(variables.$.getCurrentURL())#">#variables.$.rbKey('user.signup')#</a></#variables.$.getHeaderTag('subHead2')#>
			</cfif>
		<cfelse>
			<cfif session.mura.isLoggedIn>	
				<div id="svSessionTools" class="mura-user-tools-session #this.userToolsWrapperClass#">
					<p id="welcome">#variables.$.rbKey('user.welcome')#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#</p>
				 	<ul id="navSession">
						<li id="navEditProfile"><a class="#this.userToolsEditProfileLinkClass#" href="#variables.$.siteConfig().getEditProfileURL()#&amp;nocache=1&amp;returnURL=#urlEncodedFormat(variables.$.getCurrentURL())#">#variables.$.rbKey('user.editprofile')#</a></li>
						<li id="navLogout"><a class="#this.userToolsLogoutLinkClass#" href="./?doaction=logout">#variables.$.rbKey('user.logout')#</a></li>
					</ul>
				</div>
			</cfif>
			#dspObject('favorites')#
		</cfif>
	</cfif>
</cfoutput>