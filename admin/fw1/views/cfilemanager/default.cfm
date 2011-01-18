<cfsavecontent variable="rc.layout">
<cfparam name="rc.keywords" default="">
<cfparam name="session.resourceType" default="assets">
<cfparam name="rc.resourceType" default="">
<cfif len(rc.resourceType)>
	<cfset session.resourceType=rc.resourceType>
</cfif>
<cfoutput>
<cfif session.resourceType eq "assets">
<h2>#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</h2>
<cfelseif session.resourceType eq "files">
<h2>#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</h2>
<cfelseif session.resourceType eq "root">
<h2>#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</h2>
</cfif>
<ul class="navTask">
	<li<cfif session.resourceType eq 'assets'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&&resourceType=assets">#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a></li>
	<li<cfif session.resourceType eq 'files'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&&resourceType=files">#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a></li>
	<cfif listFind(session.mura.memberships,'S2')>
	<li<cfif session.resourceType eq 'root'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&&resourceType=root">#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a></li>
	</cfif>
</li>
</ul>
<script type="text/javascript">
var finder = new CKFinder();
finder.basePath = '#application.configBean.getContext()#/tasks/widgets/ckfinder/' ;
finder.language = '#lcase(session.rb)#';
finder.height="600";
<cfif session.resourceType eq "assets">
finder.resourceType="#JSStringFormat('#session.siteID#: User Assets')#"
<cfelseif session.resourceType eq "files">
finder.resourceType="#JSStringFormat('#session.siteID#: Site Files')#"
<cfelseif session.resourceType eq "root">
finder.resourceType="#JSStringFormat('Application Root')#"
</cfif>
finder.create() ;
</script>
</cfoutput>
</cfsavecontent>