<cfparam name="rc.keywords" default="">
<cfparam name="session.resourceType" default="assets">
<cfparam name="rc.resourceType" default="">
<cfif len(rc.resourceType)>
  <cfset session.resourceType=rc.resourceType>
</cfif>
<cfoutput>
<cfif session.resourceType eq "assets">
<h1>#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</h1>
<cfelseif session.resourceType eq "files">
<h1>#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</h1>
<cfelseif session.resourceType eq "root">
<h1>#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</h1>
</cfif>
<div id="nav-module-specific" class="btn-group">
  <a class="btn<cfif session.resourceType eq 'assets'> active</cfif>" href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&&resourceType=assets"><i class="icon-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a>
  <cfif listFind(session.mura.memberships,'S2')>
	  <cfif application.configBean.getValue('fmShowSiteFiles') neq 0>
	 	 <a class="btn<cfif session.resourceType eq 'files'> active</cfif>" href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=files"><i class="icon-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a>
	  </cfif>
	  <cfif listFind(session.mura.memberships,'S2') and application.configBean.getValue('fmShowApplicationRoot') neq 0>
	  	<a class="btn<cfif session.resourceType eq 'root'> active</cfif>" href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=root"><i class="icon-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a>
	  </cfif>
  </cfif>
</div>
<script type="text/javascript">
var finder = new CKFinder();
finder.basePath = '#application.configBean.getContext()#/tasks/widgets/ckfinder/';
finder.language = '#lcase(session.rb)#';
finder.height="600";
<cfif session.resourceType eq "assets">
finder.resourceType="#JSStringFormat('#session.siteID#_User_Assets')#";
<cfelseif session.resourceType eq "files" and application.configBean.getValue('fmShowSiteFiles') neq 0>
finder.resourceType="#JSStringFormat('#session.siteID#_Site_Files')#"
<cfelseif session.resourceType eq "root" and application.configBean.getValue('fmShowApplicationRoot') neq 0>
finder.resourceType="#JSStringFormat('Application_Root')#";
<cfelse>
finder.resourceType="#JSStringFormat('#session.siteID#_User_Assets')#";
</cfif>
finder.create();
</script>
</cfoutput>