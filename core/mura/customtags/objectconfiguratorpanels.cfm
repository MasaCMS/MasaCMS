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

		<style>
			#customstyletbl {
				width:270px;
				border: 1px solid grey;
			}
			#customstyletbl td,#customstyletbl th  {
				background-color: black;
				color:white;
				padding: 10px
				border: 2px solid white;
			}
			#customstyletblbody td .cssselector, #customstyletblbody td .cssrules {
				width:40%;
			}
		</style>

		<div class="mura-control-group">
			<label>
				Custom CSS Styles
			</label>
			<table id="customstyletbl">
				<tr>
					<th>Selector</th>
					<th>Style</th>
					<th><button class="btn" id="applystyles">Apply</button></th>
				</tr>
				<tbody id="customstyletblbody">

				</tbody>
			</table>
			<button class="btn" id="addstyle">+</button>

		</div>
		<script>
			Mura(function(){

					function renderStyles(){
						var styles=Mura('#csscustom').val();
						console.log(styles);
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
							appendStyle(style.selector,style.rules);
						});
					}

					function appendStyle(selector,rules){
						var tbody=Mura('#customstyletblbody');
						tbody.append('<tr><td class="cssselector" contenteditable placeholder="*">' + selector +'</td><td class="cssrules" contenteditable placeholder="property:value;">'+ rules +' </td><td><button class="btn removestyle">-</button></td></tr>')
					}

					renderStyles();

					Mura("#applystyles").on('click',function(){
						var styles=[];
						Mura("#customstyletblbody").children('tr').each(function(){
							var tr=Mura(this);
							styles.push(
								{
									selector: tr.find('.cssselector').html(),
									rules:tr.find('.cssrules').html()
								}
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
