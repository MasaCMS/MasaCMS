<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	if(!isStruct(attributes.params)){
		attributes.params={};
	}
	param name="attributes.params.stylesupport" default={};
	if(!isStruct(attributes.params.stylesupport)){
		attributes.params.stylesupport={};
	}
	param name="attributes.params.stylesupport.styles" default="";
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
	<input class="styleSupport" name="styles" id="csscustom" type="hidden" value="#esapiEncode('html_attr',attributes.params.stylesupport.styles)#"/>
	</cfoutput>
	<!--- content panel --->
	<cfinclude template="objectconfigpanelstylecontent.cfm">

	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-custom">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-custom" aria-expanded="false" aria-controls="panel-style-custom">
					Custom CSS
				</a>
			</h4>
		</div>
		<div id="panel-style-custom" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-custom">
			<div class="mura-panel-body">
				<div class="container">
		<style>
			#customstyletbl {
				width:265px;
			}
			#customstyletbl button{
				float:none!important;display:inline;
			}
			#customstyletbl td,#customstyletbl th  {
				background-color: #454545;
				color:white;
				border: 2px solid grey;
				padding: auto;
				text-align: center;
				height: 30px;
			}
			#customstyletbl td  {
				text-align: left;
				padding: 5px;
			}
			#customstyletbl .customcssstyle {
				width:80%;
			}
		</style>

		<div class="mura-control-group">
			<label>
				Custom CSS Styles
			</label>
			<button class="btn" id="applystyles">Apply</button>
			<table id="customstyletbl">
				<tr>
					<th class="customcssstyle">Styles</th>
					<th></th>
				</tr>
				<tbody id="customstyletblbody">

				</tbody>
			</table>
			<button class="btn" id="addstyle">+</button>

		</div>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end object panel --->
		<script>
			Mura(function(){

					function renderStyles(){
						var styles=Mura('#csscustom').val();

						if(!styles){
							styles=[];
						} else {
								styles=JSON.parse( styles );
						}

						if(!Array.isArray(styles)){
							styles=[];
						}

						var tbody=Mura('#customstyletblbody');
						tbody.html('');

						styles.forEach(function(style){
							appendStyle(style);
						});
					}

					function appendStyle(style){
						var tbody=Mura('#customstyletblbody');
						tbody.append('<tr><td class="customcssstyle" contenteditable placeholder="* { }">' + style +'</td><td><button class="btn removestyle">-</button></td></tr>')
					}

					renderStyles();

					Mura("#applystyles").on('click',function(){
						var styles=[];
						Mura("#customstyletblbody").children('tr').each(function(){
							var tr=Mura(this);
							styles.push(
								tr.find('.customcssstyle').html().replace(/&nbsp;/g, '').replace(/&gt;/g, '>').replace(/<br>/g, '\n')
							);
						});

						jQuery('#csscustom').val(JSON.stringify(styles)).trigger('change');
					});

					Mura('#addstyle').click(function(){
						appendStyle('','');
					});

					Mura('#customstyletblbody').on('click','.removestyle',function(){
						Mura(this).closest('tr').remove();
					});

			});
		</script>
