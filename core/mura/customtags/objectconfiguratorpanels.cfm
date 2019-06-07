<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	if(!isStruct(attributes.params)){
		attributes.params={};
	}
	param name="attributes.params.stylesupport" default={};
	if(!isStruct(attributes.params.stylesupport)){
		attributes.params.stylesupport={};
	}
	param name="attributes.params.stylesupport.objectbackgroundimageurl" default="";
	param name="attributes.params.stylesupport.objectbackgroundcolorsel" default="";
	param name="attributes.params.stylesupport.contentbackgroundimageurl" default="";
	param name="attributes.params.stylesupport.contentbackgroundimageurl" default="";
	param name="attributes.params.stylesupport.contentbackgroundcolorsel" default="";
	param name="attributes.params.stylesupport.metabackgroundimageurl" default="";
	param name="attributes.params.stylesupport.metabackgroundimageurl" default="";
	param name="attributes.params.stylesupport.metabackgroundcolorsel" default="";
	param name="attributes.params.stylesupport.metamarginuom" default="";
	param name="attributes.params.stylesupport.metapaddinguom" default="";
	param name="attributes.params.stylesupport.metabackgroundcolorsel" default="";
	param name="attributes.params.stylesupport.objectmarginuom" default="";
	param name="attributes.params.stylesupport.objectpaddinguom" default="";
	param name="attributes.params.stylesupport.objectminheightuom" default="";
	param name="attributes.params.stylesupport.metaminheightuom" default="";
	param name="attributes.params.stylesupport.contentminheightuom" default="";
	param name="attributes.params.stylesupport.contentmarginuom" default="";
	param name="attributes.params.stylesupport.contentpaddinguom" default="";
	param name="attributes.params.stylesupport.objectbackgroundpositionx" default="";
	param name="attributes.params.stylesupport.objectbackgroundpositiony" default="";
	param name="attributes.params.stylesupport.contentbackgroundpositionx" default="";
	param name="attributes.params.stylesupport.contentbackgroundpositiony" default="";
	param name="attributes.params.stylesupport.metabackgroundpositionx" default="";
	param name="attributes.params.stylesupport.metabackgroundpositiony" default="";

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
		,'color'
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
		,'textalign'
		,'minheight'
		,'zindex'];

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
