<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	param name="attributes.params.objectbackgroundimageurl" default="";
	param name="attributes.params.objectbackgroundimageurl" default="";
	param name="attributes.params.objectbackgroundcolorsel" default="";
	param name="attributes.params.contentbackgroundimageurl" default="";
	param name="attributes.params.contentbackgroundimageurl" default="";
	param name="attributes.params.contentbackgroundcolorsel" default="";
	param name="attributes.params.metabackgroundimageurl" default="";
	param name="attributes.params.metabackgroundimageurl" default="";
	param name="attributes.params.metabackgroundcolorsel" default="";

	param name="attributes.params.textcolor" default="";
	param name="attributes.params.metatextcolor" default="";
	param name="attributes.params.contenttextcolor" default="";

	param name="attributes.params.metamarginuom" default="";
	param name="attributes.params.metapaddinguom" default="";
	param name="attributes.params.metabackgroundcolorsel" default="";
	param name="attributes.params.objectmarginuom" default="";
	param name="attributes.params.objectpaddinguom" default="";
	param name="attributes.params.objectminheightuom" default="";
	param name="attributes.params.metaminheightuom" default="";
	param name="attributes.params.contentminheightuom" default="";
	param name="attributes.params.contentmarginuom" default="";
	param name="attributes.params.contentpaddinguom" default="";
	param name="attributes.params.objectbackgroundpositionx" default="";
	param name="attributes.params.objectbackgroundpositiony" default="";
	param name="attributes.params.contentbackgroundpositionx" default="";
	param name="attributes.params.contentbackgroundpositiony" default="";
	param name="attributes.params.metabackgroundpositionx" default="";
	param name="attributes.params.metabackgroundpositiony" default="";

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
		,'float'
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

	<!--- object panel--->
	<cfinclude template="objectconfigpanelstyleobject.cfm">

	<cfinclude template="objectconfigpanelstylemeta.cfm">

	<cfoutput>
	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
	</cfoutput>

	<!--- content panel --->
	<cfinclude template="objectconfigpanelstylecontent.cfm">
