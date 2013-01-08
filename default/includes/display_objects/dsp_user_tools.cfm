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
<cfsilent>
<cfset variables.$.loadShadowBoxJS() />
</cfsilent>
<cfif variables.$.event('display') neq 'login'>
<cfif not len(getPersonalizationID())>
<cfoutput>
	<div id="login" class="well clearfix">
		<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('user.signin')#</#variables.$.getHeaderTag('subHead1')#>
		<form action="<cfoutput>?nocache=1</cfoutput>" name="loginForm" method="post">
			<ol>
				<li class="control-group">
					<label class="control-label" for="txtUserName">#variables.$.rbKey('user.username')#</label>
					<input type="text" id="txtUserName" name="username" />
				</li>
				<li class="control-group">
					<label class="control-label" for="txtPassword">#variables.$.rbKey('user.password')#</label>
					<input type="password" id="txtPassword" name="password" />
				</li>
				<li class="control-group">
					<label class="checkbox" for="cbRemember"><input type="checkbox" id="cbRemember" class="checkbox first" name="rememberMe" value="1" />
					#variables.$.rbKey('user.rememberme')#</label>
				</li>
			</ol>
			<div class="buttons">
				<input type="hidden" name="doaction" value="login" />
				<button type="submit" class="submit btn">#variables.$.rbKey('user.signin')#</button>
			</div>
			<cfif application.settingsManager.getSite(variables.$.event('siteID')).getExtranetPublicReg()><p>#variables.$.rbKey('user.notregistered')# <a href="#variables.$.siteConfig().getEditProfileURL()#&returnURL=#urlEncodedFormat(variables.$.getCurrentURL())#">#variables.$.rbKey('user.signup')#</a></p></cfif>
		</form>
	</div>
</cfoutput>
<cfelse>
<cfoutput>
<cfif session.mura.isLoggedIn>	
<div id="svSessionTools" class="clearfix">
	<p id="welcome">#variables.$.rbKey('user.welcome')#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#</p>
 	<ul id="navSession">
		<li id="navEditProfile"><a href="#variables.$.siteConfig().getEditProfileURL()#&nocache=1&returnURL=#urlEncodedFormat(variables.$.getCurrentURL())#"><i class="icon-user"></i> #variables.$.rbKey('user.editprofile')#</a></li>
		<li id="navLogout"><a href="?doaction=logout"><i class="icon-signout"></i> #variables.$.rbKey('user.logout')#</a></li>
	</ul>
</div>
</cfif>

#dspObject('favorites')#
</cfoutput>
</cfif>
</cfif>