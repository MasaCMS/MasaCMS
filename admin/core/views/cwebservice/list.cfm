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

<cfset services=$.getFeed('oauthClient').setSiteID(session.siteid).getIterator()>

<cfoutput>
<div class="mura-header">
	<h1>Web Services</h1>

    <div class="nav-module-specific btn-group">
        <a class="btn" href="./?muraAction=cwebservice.edit&clientid=&siteid=&#esapiEncode('url',rc.siteid)#"><i class="mi-plus-circle"></i> Add New Web Service</a>
    </div>
</div> <!-- /.mura-header -->

<cfif not rc.$.siteConfig('useSSL')>
   <div class="alert alert-error"><span>When using web services in production, this site should be set to use SSL (HTTPS).</span></div>
</cfif>

<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">

		  <cfif not services.hasNext()>
			  <div class="help-block-empty">There currently are no web services configured for this site.</div>
		  <cfelse>
			<table class="mura-table-grid">
			<thead>
				<tr>
					<th class="actions"></th>
					<th class="var-width">Name</th>
					<th class="var-width">Auth Mode</th>
					<th>Last Update</th>
				</tr>
			</thead>
			<tbody class="nest">
				<cfloop condition="services.hasNext()">
				<cfset service=services.next()>
				<tr>
					<td class="actions">
						<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
						<div class="actions-menu hide">
							<ul class="actions-list">
								<li class="edit">
									<a href="./?muraAction=cwebservice.edit&clientid=#service.getClientID()#&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-pencil"></i>Edit</a>
								</li>
								<li class="delete">
									<a href="./?muraAction=cwebservice.delete&clientid=#service.getClientID()#&siteid=#esapiEncode('url',rc.siteid)##rc.$.renderCSRFTokens(context=service.getClientID(),format='url')#" onClick="return confirmDialog('Delete Web Service?',this.href)"><i class="mi-trash"></i>Delete</a>
								</li>
							</ul>
						</div>
					</td>
					<td class="var-width">
						<a title="Edit" href="./?muraAction=cwebservice.edit&clientid=#service.getClientID()#&siteid=#esapiEncode('url',rc.siteid)#">#esapiEncode('html',service.getName())#</a>
					</td>
					<td>
						<cfif service.getGrantType() eq 'client_credentials'>OAuth2 (client_credentials)<cfelseif service.getGrantType() eq 'authorization_code'>OAuth2 (authorization_code)<cfelseif service.getGrantType() eq 'implicit'>OAuth2 (implicit)<cfelseif service.getGrantType() eq 'password'>OAuth2 (password)<cfelse>Basic</cfif>
					</td>
					<td>
						#LSDateFormat(service.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(service.getLastUpdate(),"medium")#
					</td>
				</tr>
				</cfloop>
			</tbody>
			</table>
			</cfif>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->
</cfoutput>
