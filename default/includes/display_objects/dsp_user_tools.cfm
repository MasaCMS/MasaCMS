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
<cfsilent>
<cfset loadShadowBoxJS() />
<cfset rbFactory=getSite().getRBFactory()/>
</cfsilent>
<cfif request.display neq 'login'>
<cfif not len(getPersonalizationID())>
<cfoutput>
	<div id="login" class="clearfix">
		<h3>#rbFactory.getKey('user.signin')#</h3>
		<form action="<cfoutput>#application.configBean.getIndexFile()#?nocache=1</cfoutput>" name="loginForm" method="post">
			<ol>
				<li>
					<label for="txtUserName">#rbFactory.getKey('user.username')#</label>
					<input type="text" id="txtUserName" class="text" name="username" />
				</li>
				<li>
					<label for="txtPassword">#rbFactory.getKey('user.password')#</label>
					<input type="password" id="txtPassword" class="text" name="password" />
				</li>
				<li>
					<input type="checkbox" id="cbRemember" class="checkbox first" name="rememberMe" value="1" />
					<label for="cbRemember">#rbFactory.getKey('user.rememberme')#</label>
				</li>
			</ol>
			<div class="buttons">
				<input type="hidden" name="doaction" value="login" />
				<button type="submit" class="submit">#rbFactory.getKey('user.signin')#</button>
			</div>
			<cfif application.settingsManager.getSite(request.siteid).getExtranetPublicReg()><p>#rbFactory.getKey('user.notregistered')# <a href="#application.settingsManager.getSite(request.siteid).getEditProfileURL()#&returnURL=#urlEncodedFormat(application.contentRenderer.getCurrentURL())#">#rbFactory.getKey('user.signup')#</a></p></cfif>
		</form>
	</div>
</cfoutput>
<cfelse>
<cfoutput>
<cfif len(getAuthUser())>	
<div id="svSessionTools" class="clearfix">
	<p id="welcome">#rbFactory.getKey('user.welcome')#, #listGetAt(getAuthUser(),2,"^")#</p>
 	<ul id="navSession">
		<li id="navEditProfile"><a href="#application.settingsManager.getSite(request.siteid).getEditProfileURL()#&nocache=1&returnURL=#urlEncodedFormat(application.contentRenderer.getCurrentURL())#">#rbFactory.getKey('user.editprofile')#</a></li>
		<li id="navLogout"><a href="?doaction=logout">#rbFactory.getKey('user.logout')#</a></li>
	</ul>
</div>
</cfif>

#dspObject('favorites','','#request.siteid#')#
</cfoutput>
</cfif>
</cfif>