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

	<!--- object panel--->
	<cfinclude template="objectconfigpanelstyleobject.cfm">

	<cfinclude template="objectconfigpanelstylemeta.cfm">

	<cfoutput>
	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
	<input class="styleSupport" name="css" id="csscustom" type="hidden" value="#esapiEncode('html_attr',attributes.params.stylesupport.css)#"/>
	</cfoutput>
	<!--- content panel --->
	<cfinclude template="objectconfigpanelstylecontent.cfm">

	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-custom">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="#configurator-panels" href="#panel-style-custom" aria-expanded="false" aria-controls="panel-style-custom">
					Custom CSS
				</a>
			</h4>
		</div>
		<div id="panel-style-custom" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-custom">
			<div class="mura-panel-body">
				<div class="container">

						<div class="mura-control-group">
							<label>
								Custom CSS Styles
							</label>
							<cfoutput>
							<textarea id="customstylesedit" style="min-height: 250px">#esapiEncode('html',attributes.params.stylesupport.css)#</textarea>
							</cfoutput>
							<button class="btn" id="applystyles">Apply</button>
							<script>
								Mura('#applystyles').click(function(){
									jQuery('#csscustom').val(Mura('#customstylesedit').val()).trigger('change');
								})
							</script>
						</div>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end object panel --->
