<cfscript>
	objectparams.render='client';
	objectparams.async=true;
	configuratorMarkup='';

	if(isValid("url", objectConfig.configurator)){
		httpService=application.configBean.getHTTPService();
		lhttpService.setMethod("get");
		httpService.setCharset("utf-8");
		httpService.setURL(objectConfig.configurator);
		configuratorMarkup=httpService.send().getPrefix();
	} else if(len(objectConfig.configurator)){
		configuratorMarkup=objectConfig.configurator;
	}
</cfscript>
<cfif len(configuratorMarkup)>
		<cf_objectconfigurator params="#objectparams#">
			<cfoutput>#configuratorMarkup#</cfoutput>
			<script>
			Mura(function(){
				siteManager.requestDisplayObjectParams(function(params){});
			});
			</script>
		</cf_objectconfigurator>
<cfelse>
	<cf_objectconfigurator basictab=false>
	</cf_objectconfigurator>
</cfif>
