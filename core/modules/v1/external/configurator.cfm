<cfscript>
	objectparams.render='client';
	objectparams.async=false;
	configuratorMarkup='';

	if(isValid("url", objectConfig.configurator)){
		configuratorMarkup=application.configBean.getHTTPService(url=objectConfig.configurator, method="get", charset="utf-8");
	} else if(len(objectConfig.configurator)){
		configuratorMarkup=objectConfig.configurator;
	}
</cfscript>
<cfif len(configuratorMarkup)>
		<cf_objectconfigurator params="#objectparams#">
			<cfoutput>#configuratorMarkup#</cfoutput>
			<script>
			Mura(function(){
				siteManager.requestDisplayObjectParams(function(params){},'sidebar');
			});
			</script>
		</cf_objectconfigurator>
<cfelse>
	<cf_objectconfigurator basictab=false>
	</cf_objectconfigurator>
</cfif>
