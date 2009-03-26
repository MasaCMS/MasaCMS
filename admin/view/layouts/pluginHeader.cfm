<cfoutput>
<!-- Begin Mura Toolbar. Optional. -->
<cfif not arguments.jsLibLoaded>
<cfif arguments.jsLib eq "jquery">
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/jquery/jquery.js" type="text/javascript"></script>
<cfelse>
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/prototype.js" type="text/javascript" language="Javascript"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(session.siteid).getDisplayPoolID()#/js/scriptaculous/src/scriptaculous.js?load=effects"></script>
</cfif>
</cfif>
<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/admin.js"></script>
<script type="text/javascript">
function toggleAdminToolbar(){
<cfif arguments.jslib eq "jquery">$("##frontEndTools").animate({opacity: "toggle"});<cfelse>Effect.toggle("frontEndTools", "appear");</cfif>
}
</script>
<link href="#application.configBean.getContext()#/admin/css/dialog.css" rel="stylesheet" type="text/css" />

<!--- <style>
body { padding-top: 55px; }
</style>
 --->
<img src="#application.configBean.getContext()#/admin/images/logo_small_fetools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />

		<div id="frontEndTools">
			<ul>
				<li id="adminPlugIns"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPlugins.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</a></li>
				<li id="adminSiteManager"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a></li>
				<li id="adminDashboard"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#">#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</a></li>
				<li id="adminLogOut"><a href="#application.configBean.getContext()#/admin/index.cfm?doaction=logout">Log Out</a></li>
				<li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat(listgetat(getauthuser(),2,"^"))#.</li>
			</ul>
		</div>

<!-- End Mura Toolbar -->
</cfoutput>