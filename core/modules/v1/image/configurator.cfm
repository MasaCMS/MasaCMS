 <!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.src" default="">
	<cfparam name="objectParams.fit" default="">
	<cfparam name="objectParams.imagelink" default="">
	<cfparam name="objectParams.alt" default="">
</cfsilent>
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label class="mura-control-label">Image Src</label>
				<input type="text" placeholder="Image URL" id="src" name="src" class="objectParam" value="#esapiEncode('html_attr',objectparams.src)#"/>
				<button type="button" class="btn mura-finder" data-target="src" data-completepath="false"><i class="mi-image"></i>Select Image</button>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Image Fit</label>
				<select class="objectParam" name="fit" data-param="fit">
					<cfloop list="-,Contain,Cover,Fill,Scale-Down" index="flist">
						<option <cfif objectParams.fit eq flist>selected</cfif>value="#setval(flist)#">#flist#</option>
					</cfloop>
				</select>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Image Link</label>
				<input type="text" placeholder="Image Link" id="imagelink" name="imagelink" class="objectParam" value="#esapiEncode('html_attr',objectparams.imagelink)#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Alt Text</label>
				<input type="text" name="alt" class="objectParam" value="#esapiEncode('html_attr',objectparams.alt)#"/>
			</div>
		</div>
		<input type="hidden" class="objectParam" name="async" value="false">
	</div>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">

</cfoutput>
</cf_objectconfigurator>
<cfscript>
function setval(val) {
	if(val == '-') {
		return "";
	}
	return val;
}
</cfscript>
