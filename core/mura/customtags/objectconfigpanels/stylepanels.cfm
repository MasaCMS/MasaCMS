<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	if(!isStruct(attributes.params)){
		attributes.params={};
	}
	param name="attributes.params.stylesupport" default={};
	if(!isStruct(attributes.params.stylesupport)){
		attributes.params.stylesupport={};
	}
	param name="attributes.params.stylesupport.css" default="";
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
		param name="attributes.params.stylesupport.objectstyles.#p#" default="";
		if(p == 'textalign'){
			param name="attributes.params.stylesupport.metastyles.#p#" default="center";
		} else {
			param name="attributes.params.stylesupport.metastyles.#p#" default="";
		}
		param name="attributes.params.stylesupport.contentstyles.#p#" default="";
	}
</cfscript>

<!--- todo: rbkeys for box labels --->
<cfoutput>
	<div class="panel-gds-box active" id="panel-gds-object" data-gdsel="panel-style-object"><span>Module</span> .mura-object
		<cfif request.hasmetaoptions>
			<div class="panel-gds-box" id="panel-gds-meta" data-gdsel="panel-style-label"<cfif not len(attributes.params.label)> style="display:none"</cfif>><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</span>  .mura-object-meta</div>
		</cfif>
		<div class="panel-gds-box" id="panel-gds-content" data-gdsel="panel-style-content"><span>Content</span> .mura-object-content</div>
	</div>
</cfoutput>

<div class="mura-panel-group" id="style-panels" role="tablist" aria-multiselectable="true">

	<!--- object/module style panel--->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-object">
			<h4 class="mura-panel-title">
				<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="#configurator-panels" href="#panel-style-object" aria-expanded="false" aria-controls="panel-style-object">
					Module
				</a>
			</h4>
		</div>
		<div id="panel-style-object" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-object">
			<div class="mura-panel-body">
				<div class="container">
					<cfinclude template="objectconfigpanelstyleobject.cfm">
				</div> <!--- /end container --->
			</div> <!--- /end mura-panel-body --->
		</div> <!--- /end panel-collapse --->
	</div> <!--- /end object panel --->

<!--- meta/label style panel --->
<cfif request.hasmetaoptions and not (IsBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
	<!--- label --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-label">
			<h4 class="mura-panel-title">
				<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="#configurator-panels" href="#panel-style-label" aria-expanded="false" aria-controls="panel-style-label">
					Label
				</a>
			</h4>
		</div>
		<div id="panel-style-label" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-label">
			<div class="mura-panel-body">
				<div class="container" id="labelContainer">
					<cfinclude template="objectconfigpanelstylemeta.cfm">
				</div> <!--- /end container --->
			</div> <!--- /end mura-panel-body --->
		</div> <!--- /end panel-collapse --->
	</div> <!--- /end label panel --->
</cfif>

<!--- content style panel --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-content">
			<h4 class="mura-panel-title">
				<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="#configurator-panels" href="#panel-style-content" aria-expanded="false" aria-controls="panel-style-content">
					Content
				</a>
			</h4>
		</div>
		<div id="panel-style-content" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-content">
			<div class="mura-panel-body">
				<div class="container">
					<cfinclude template="objectconfigpanelstylecontent.cfm">
				</div> <!--- /end container --->
			</div> <!--- /end mura-panel-body --->
		</div> <!--- /end panel-collapse --->
	</div> <!--- /end content panel --->

	<cfoutput>
	<div>
		<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
		<input class="styleSupport" name="css" id="csscustom" type="hidden" value="#esapiEncode('html_attr',attributes.params.stylesupport.css)#"/>
	</div>
	</cfoutput>

</div> <!--- /end panel group --->
