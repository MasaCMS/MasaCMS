<cfoutput>
<cfparam name="Cookie.fetDisplay" default="">
<cfset variables.isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
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
<link href="#application.configBean.getContext()#/admin/css/dialog.css" rel="stylesheet" type="text/css" />
<cfif variables.isIeSix>	
<!--------------------------------------------------------------------------------------------------------------->
<!--- IE6 COMPATIBILITY FOR FRONT END TOOLS, ADDED BY CHRIS HAYES JUN 30 2009  CHRIS AT HAYESDATA.COM ----------->
<!--------------------------------------------------------------------------------------------------------------->
<link href="#application.configBean.getContext()#/admin/css/dialogIE6.css" rel="stylesheet" type="text/css" />
<script>
	function toggleAdminToolbarIE6(){
	<cfif arguments.jsLib eq "jquery">
		$("##frontEndToolsIE6").animate({opacity: "toggle"});
	<cfelse>
		Effect.toggle("frontEndToolsIE6", "appear");
	</cfif>
	};
</script>
<cfelse>
<script type="text/javascript">
function toggleAdminToolbar(){
	<cfif arguments.jslib eq "jquery">
		$("##frontEndTools").animate({opacity: "toggle"});
		<cfelse>Effect.toggle("frontEndTools", "appear");
	</cfif>
	}
</script>		
</cfif>

<cfif variables.isIeSix>
	<!--- NAMED DIFFERENTLY TO USE THE IE6 COMPATIBLE dialogIE6.css --->
	<img src="#application.configBean.getContext()#/admin/images/icons/ie6/logo_small_fetools.gif" id="frontEndToolsHandleIE6" onclick="if (document.getElementById('frontEndToolsIE6').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbarIE6();" />
	<div id="frontEndToolsIE6" style="display: #Cookie.fetDisplay#">						
<cfelse>
	<!--- USES STANDARD dialog.css --->
	<img src="#application.configBean.getContext()#/admin/images/logo_small_fetools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
	<div id="frontEndTools" style="display: #Cookie.fetDisplay#">
</cfif>
			<ul>
				<li id="adminPlugIns"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPlugins.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</a></li>
				<li id="adminSiteManager"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a></li>
				<li id="adminDashboard"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#">#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</a></li>
				<li id="adminLogOut"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
				<li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</li>
			</ul>
		</div>

<!-- End Mura Toolbar -->
</cfoutput>