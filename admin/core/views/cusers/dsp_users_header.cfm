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
<cfoutput>

	<!--- User Search --->		
		<form class="form-inline" novalidate="novalidate" action="index.cfm" method="get" name="form1" id="siteSearch">
			<div class="input-append">
				<input id="search" name="search" type="text" placeholder="#rc.$.rbKey('user.searchforusers')#" />
				<button type="button" class="btn" onclick="submitForm(document.forms.form1);">
					<i class="icon-search"></i>
				</button>
				<button type="button" class="btn" onclick="window.location='./?muraAction=cUsers.advancedSearch&amp;ispublic=#esapiEncode('url',rc.ispublic)#&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;newSearch=true'" value="#rc.$.rbKey('user.advanced')#">
					#rc.$.rbKey('user.advanced')#
				</button>
				<input type="hidden" name="siteid" value="#esapiEncode('html',rc.siteid)#" />
				<input type="hidden" name="muraAction" value="cUsers.search" />
				<input type="hidden" name="ispublic" value="#esapiEncode('html',rc.ispublic)#" />
			</div>
		</form>

	<!--- Page Title --->
		<h1>#rc.$.rbKey('user.groupsandusers')#</h1>

	<!--- Buttons --->
		<div id="nav-module-specific" class="btn-group">

			<!--- Add User --->
			<a class="btn" href="#buildURL(action='cusers.edituser', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
		  	<i class="icon-plus-sign"></i> 
		  	#rc.$.rbKey('user.adduser')#
		  </a>

		  <!--- Add Group --->
		  <a class="btn" href="#buildURL(action='cusers.editgroup', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
		  	<i class="icon-plus-sign"></i> 
		  	#rc.$.rbKey('user.addgroup')#
		  </a>

			<cfif rc.muraaction eq 'core:cusers.listusers'>
				<!--- View Groups --->
				<a class="btn" href="#buildURL(action='cusers.default', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
		  		<i class="icon-eye-open"></i>
		  		#rc.$.rbKey('user.viewgroups')#
		  	</a>
		  <cfelse>
		  	<!--- View Users --->
				<a class="btn" href="#buildURL(action='cusers.listUsers', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
					<i class="icon-eye-open"></i>
					#rc.$.rbKey('user.viewusers')#
				</a>
			</cfif>

			<!--- Permissions --->
			<cfif ( ListFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') OR ListFind(session.mura.memberships,'S2') ) AND ( rc.ispublic )>
				<a class="btn" href="./?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000008&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;moduleid=00000000000000000000000000000000008">
					<i class="icon-legal"></i> 
					#rc.$.rbKey('user.permissions')#
				</a>
			</cfif>
		</div>

		<h4><span style="color:orange;">Memberships:</span> #rc.$.currentUser().getMemberships()#</h4>

</cfoutput>