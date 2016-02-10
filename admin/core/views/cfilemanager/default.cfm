<!--- TODO GoWest : mura comment here : 2016-01-23T09:18:21-07:00 --->
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
	<div class="mura-item-metadata">
		<div class="label-group">			
			<div id="nav-module-specific" class="btn-group">
			  <a class="btn<cfif session.resourceType eq 'assets'> active</cfif>" href="#application.configBean.getContext()#/admin/?muraAction=cFilemanager.default&siteid=#session.siteid#&&resourceType=assets"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a>
  <cfif listFind(session.mura.memberships,'S2')>
	  <cfif application.configBean.getValue('fmShowSiteFiles') neq 0>
				 	 <a class="btn<cfif session.resourceType eq 'files'> active</cfif>" href="#application.configBean.getContext()#/admin/?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=files"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a>
	  </cfif>
	  <cfif listFind(session.mura.memberships,'S2') and application.configBean.getValue('fmShowApplicationRoot') neq 0>
				  	<a class="btn<cfif session.resourceType eq 'root'> active</cfif>" href="#application.configBean.getContext()#/admin/?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=root"><i class="mi-folder-open"></i> #application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a>
	  </cfif>
  </cfif>
			</div>
		</div><!-- /.label-group -->
	</div><!-- /.mura-item-metadata -->
</div> <!-- /.items-push.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">
			<script type="text/javascript">
			var finder = new CKFinder();
			finder.basePath = '#application.configBean.getContext()#/requirements/ckfinder/';
			finder.language = '#lcase(session.rb)#';
			finder.height="600";
			<cfif session.resourceType eq "assets">
			finder.resourceType="#esapiEncode('javascript','#session.siteID#_User_Assets')#";
			<cfelseif session.resourceType eq "files" and application.configBean.getValue('fmShowSiteFiles') neq 0>
			finder.resourceType="#esapiEncode('javascript','#session.siteID#_Site_Files')#"
			<cfelseif session.resourceType eq "root" and application.configBean.getValue('fmShowApplicationRoot') neq 0>
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