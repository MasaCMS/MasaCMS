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
<cfoutput>


	<!--- Page Title --->
<div class="mura-header">
	<h1>#rbKey('user.usersearchresults')#</h1>

	<!--- Buttons --->
		<div class="nav-module-specific btn-group">

			<!--- Add User --->
				<a class="btn" href="#buildURL(action='cusers.edituser', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
					<i class="mi-plus-circle"></i> 
					#rbKey('user.adduser')#
				</a>

		  <!--- Add Group --->
				<a class="btn" href="#buildURL(action='cusers.editgroup', querystring='siteid=#esapiEncode('url',rc.siteid)#&userid=')#">
					<i class="mi-plus-circle"></i> 
					#rbKey('user.addgroup')#
				</a>

			<!--- View Groups --->
				<a class="btn" href="#buildURL(action='cusers.default', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
					<i class="mi-users"></i>
					#rbKey('user.viewgroups')#
				</a>

			<!--- View Users --->
				<a class="btn" href="#buildURL(action='cusers.listUsers', querystring='siteid=#esapiEncode('url',rc.siteid)#')#">
					<i class="mi-user"></i>
					#rbKey('user.viewusers')#
				</a>

		</div>
	<!--- /Buttons --->

	<div class="mura-item-metadata">

	<!--- User Search --->
	<cfinclude template="inc/dsp_search_form.cfm" />

	</div><!-- /.mura-item-metadata -->
</div> <!-- /.mura-header -->

<div class="block block-constrain">

<!--- Tab Nav (only tabbed for Admin + Super Users) --->
  <cfif rc.isAdmin>

      <ul class="mura-tab-links nav-tabs">

        <!--- Site Members Tab --->
          <li<cfif rc.ispublic eq 1> class="active"</cfif>>
            <a href="#buildURL(action='cusers.search', querystring='siteid=#esapiEncode('url',rc.siteid)#&ispublic=1&search=#esapiEncode('url',rc.search)#')#">
              #rbKey('user.sitemembers')#
            </a>
          </li>

        <!--- System Users Tab --->
          <li<cfif rc.ispublic eq 0> class="active"</cfif>>
            <a href="#buildURL(action='cusers.search', querystring='siteid=#esapiEncode('url',rc.siteid)#&ispublic=0&search=#esapiEncode('url',rc.search)#')#">
              #rbKey('user.systemusers')#
            </a>
          </li>

      </ul>
			<div class="block-content tab-content">

			<!-- start tab -->
			<div id="tab1" class="tab-pane active">
				<div class="block block-bordered">
					<!-- block header -->					
					<div class="block-header">
						<h3 class="block-title"><cfif rc.ispublic eq 1>#rbKey('user.sitemembers')#<cfelse>#rbKey('user.systemusers')#</cfif></h3>
					</div> <!-- /.block header -->						
					<div class="block-content">
						  	
						<cfinclude template="inc/dsp_users_list.cfm" />

					</div> <!-- /.block-content -->
				</div> <!-- /.block-bordered -->
			</div> <!-- /.tab-pane -->

		</div> <!-- /.block-content.tab-content -->
  <cfelse>
		<div class="block block-bordered">
		  <div class="block-content">
		    <h3>#rbKey('user.sitemembers')#</h3>
				<cfinclude template="inc/dsp_users_list.cfm" />
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
  </cfif>
<!--- /Tab Nav --->


</div> <!-- /.block-constrain -->
</cfoutput>