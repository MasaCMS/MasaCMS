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
<cfparam name="rc.keywords" default="">
<cfparam name="session.resourceType" default="assets">
<cfparam name="rc.resourceType" default="">
<cfif len(rc.resourceType)>
  <cfset session.resourceType=rc.resourceType>
</cfif>
<cfoutput>
<div class="mura-header">
	<cfif session.resourceType eq "assets">
	<h1>#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</h1>
	<cfelseif session.resourceType eq "files">
	<h1>#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</h1>
	<cfelseif session.resourceType eq "root">
	<h1>#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</h1>
	</cfif>
			<div class="nav-module-specific btn-group">
			  <a class="btn<cfif session.resourceType eq 'assets'> active</cfif>" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cFilemanager.default&siteid=#session.siteid#&&resourceType=assets"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a>
  <cfif listFind(session.mura.memberships,'S2')>
	  <cfif application.configBean.getValue(property='fmShowSiteFiles',defaultValue=true)>
				 	 <a class="btn<cfif session.resourceType eq 'files'> active</cfif>" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=files"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a>
	  </cfif>
	  <cfif listFind(session.mura.memberships,'S2') and application.configBean.getValue(property='fmShowApplicationRoot',defaultValue=true)>
				  	<a class="btn<cfif session.resourceType eq 'root'> active</cfif>" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=root"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a>
	  </cfif>
  </cfif>
			</div>
</div> <!-- /.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">
			<script type="text/javascript">
			var finder = new CKFinder();
			finder.basePath = '#application.configBean.getContext()#/core/vendor/ckfinder/';
			finder.language = '#lcase(session.rb)#';
			finder.height="600";
			<cfif session.resourceType eq "assets">
			finder.resourceType="#esapiEncode('javascript','#session.siteID#_User_Assets')#";
			<cfelseif session.resourceType eq "files" and application.configBean.getValue(property='fmShowSiteFiles',defaultValue=true)>
			finder.resourceType="#esapiEncode('javascript','#session.siteID#_Site_Files')#"
			<cfelseif session.resourceType eq "root" and application.configBean.getValue(property='fmShowApplicationRoot',defaultValue=true)>
			finder.resourceType="#esapiEncode('javascript','Application_Root')#";
			<cfelse>
			finder.resourceType="#esapiEncode('javascript','#session.siteID#_User_Assets')#";
			</cfif>
			finder.create();
			</script>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

</cfoutput>
