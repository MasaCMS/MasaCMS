<script>
	/*jQuery(document).ready(function(){
		jQuery.ajax({
			url: '/tasks/bundle/feedback.cfm?siteID=<cfoutput>#rc.siteID#</cfoutput>',
			success: function(data) {
				jQuery('#feedbackLoop').html(data);
			}
		});
	});*/
</script>

<h2>Deploy Bundle</h2>
<iframe frameborder="0" src="/tasks/bundle/feedback.cfm?siteID=<cfoutput>#rc.siteID#</cfoutput>"></iframe>

<!---<cfoutput>#application.pluginManager.announceEvent("onAfterSiteDeployRender",event)#</cfoutput>--->