<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	param name="attributes.params.outerbackgroundimageurl" default="";
	param name="attributes.params.outerbackgroundimageurl" default="";
	param name="attributes.params.outerbackgroundcolorsel" default="";
	param name="attributes.params.innerbackgroundimageurl" default="";
	param name="attributes.params.innerbackgroundimageurl" default="";
	param name="attributes.params.innerbackgroundcolorsel" default="";

	param name="attributes.params.metamarginuom" default="";
	param name="attributes.params.metapaddinguom" default="";
	param name="attributes.params.metabackgroundcolorsel" default="";
	param name="attributes.params.outermarginuom" default="";
	param name="attributes.params.outerpaddinguom" default="";
	param name="attributes.params.outerminheightuom" default="";
	param name="attributes.params.innermarginuom" default="";
	param name="attributes.params.innerpaddinguom" default="";
	param name="attributes.params.outerbackgroundpositionx" default="";
	param name="attributes.params.outerbackgroundpositiony" default="";
	param name="attributes.params.innerbackgroundpositionx" default="";
	param name="attributes.params.innerbackgroundpositiony" default="";

	attributes.globalparams = [
		'backgroundcolor'
		,'backgroundimage'
		,'backgroundoverlay'
		,'backgroundattachment'
		,'backgroundposition'
		,'backgroundpositionx'
		,'backgroundpositiony'
		,'backgroundrepeat'
		,'backgroundsize'
		,'backgroundvideo'
		,'margin'
		,'margintop'
		,'marginright'
		,'marginbottom'
		,'marginleft'
		,'marginall'
		,'marginuom'
		,'opacity'
		,'padding'
		,'paddingtop'
		,'paddingright'
		,'paddingbottom'
		,'paddingleft'
		,'paddingall'
		,'paddinguom'
		,'textalign',
		 'minheight'];

	for (p in attributes.globalparams){
		param name="attributes.params.cssstyles.#p#" default="";
		if(p == 'textalign'){
			param name="attributes.params.metacssstyles.#p#" default="center";
		} else {
			param name="attributes.params.metacssstyles.#p#" default="";
		}
		param name="attributes.params.contentcssstyles.#p#" default="";
	}
</cfscript>

	<!--- outer panel--->
	<cfinclude template="objectconfigpanelstyleouter.cfm">


	<cfinclude template="objectconfigpanelstylemeta.cfm">

	<cfoutput>
	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
	</cfoutput>

	<!--- inner panel --->
	<cfinclude template="objectconfigpanelstyleinner.cfm">
