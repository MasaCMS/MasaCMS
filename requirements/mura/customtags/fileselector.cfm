<cfsilent>
<cfparam name="attributes.name" default="newfile">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.label" default="">
<cfparam name="attributes.required" default="#attributes.name#">
<cfparam name="attributes.validation" default="">
<cfparam name="attributes.regex" default="">
<cfparam name="attributes.message" default="">
<cfparam name="attributes.deleteKey" default="">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.property" default="#attributes.name#">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.locked" default="false">
<cfparam name="attributes.examplefileext" default="zip">

<cfif attributes.bean.getType() neq 'File' and attributes.property eq 'fileid'>
	<cfset filetype='Image'>
<cfelse>
	<cfset filetype='File'>
</cfif>

<cfscript>
	if(server.coldfusion.productname != 'Coldfusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
</cfsilent>
<cfoutput>
	<div data-name="#esapiEncode('html_attr',attributes.name)#" data-property="#esapiEncode('html_attr',attributes.property)#" data-fileid="#esapiEncode('html_attr',attributes.bean.getValue(attributes.property))#" data-filetype="#esapiEncode('html_attr',filetype)#" data-contentid="#attributes.bean.getcontentid()#" data-siteid="#attributes.bean.getSiteID()#" class="mura-file-selector #attributes.class#">			
		<div class="mura-input-set mura-file-selector-tabs" data-toggle="buttons-radio">
			<button type="button" style="display:none">placeholder</button>
			<button type="button" class="btn btn-default mura-file-type-selector active" value="Upload"><i class="mi-upload"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaupload')#</button>
			<button type="button" class="btn btn-default mura-file-type-selector" value="URL"><i class="mi-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaurl')#</button>
			<button type="button" class="btn btn-default mura-file-type-selector" value="Existing"><i class="mi-file-picture-o"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selectexisting')#</button>
			<cfif len(application.serviceFactory.getBean('settingsManager').getSite(attributes.bean.getSiteID()).getRazunaSettings().getHostname())>
			<button type="button" class="btn btn-default mura-file-type-selector btn-razuna-icon" value="URL-Razuna"><i></i> Razuna</button>
			</cfif>
		</div>

		<div id="mura-file-upload-#esapiEncode('html_attr',attributes.name)#" class="mura-file-option mura-file-upload fileTypeOption#esapiEncode('html_attr',attributes.name)#">

			<div class="mura-control-group">
					<input name="#esapiEncode('html_attr',attributes.name)#" type="file" class="mura-file-selector-#esapiEncode('html_attr',attributes.name)#"
						data-label="#esapiEncode('html_attr',attributes.label)#" data-label="#esapiEncode('html_attr',attributes.required)#" data-validation="#esapiEncode('html_attr',attributes.validation)#" data-regex="#esapiEncode('html_attr',attributes.regex)#" data-message="#esapiEncode('html_attr',attributes.message)#">
					<a style="display:none;" class="btn btn-default" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#esapiEncode('javascript',attributes.property)#');"><i class="mi-info-circle"></i></a>
			</div>

		</div>
		<div id="mura-file-url-#attributes.name#" class="mura-file-option mura-file-url fileTypeOption#attributes.name#">

			<div class="mura-control-group">
					<input type="text" name="#attributes.name#" class="mura-file-selector-#attributes.name# span6" type="url" placeholder="http://www.domain.com/yourfile.#attributes.examplefileext#"	value=""
					data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
					<a style="display:none;" class="btn btn-default file-meta-open" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="mi-info-circle"></i></a>
			</div>

		</div>

		<div id="mura-file-existing-#attributes.name#" class="mura-file-option mura-file-existing fileTypeOption#attributes.name#">

		</div>
		<cfset razunaSettings = application.serviceFactory.getBean('settingsManager').getSite(attributes.bean.getSiteID()).getRazunaSettings()>
		<cfif len(razunaSettings.getAPIKey())>
		<div id="mura-file-url-#attributes.name#" class="mura-file-option mura-file-url-razuna fileTypeOption#attributes.name#">

			<div class="mura-control-group">
					<div class="input-append">
						<input type="text" name="#attributes.name#" class="mura-file-selector-#attributes.name# span6 razuna-url" type="url" placeholder="http://#razunaSettings.getHostName()#" data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
						<a style="display:none;" class="btn btn-default file-meta-open" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="mi-info-circle"></i></a>
						<button type="button" onclick="renderRazunaWindow('newfile');" class="btn btn-razuna"><i class="mi-external-link-sign"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.launchrazuna')#</button>
					</div>
			</div>

		</div>
		</cfif>

		<cfif attributes.bean.getType() eq 'File' and attributes.property eq 'fileid' and len(attributes.bean.getFileID())>

			<div style="display:none;" id="mura-revision-type">
				<label class="radio inline">
					<input type="radio" name="versionType" value="major">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')#
				</label>
				<label class="radio inline">
					<input type="radio" name="versionType" value="minor" checked />#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#
				</label>
			</div>
			<script>
				jQuery(".mura-file-selector-newfile").change(function(){
					jQuery("##mura-revision-type").fadeIn();
					});
			</script>
		</cfif>

		<cfif isObject(attributes.bean)>
			<cf_filetools bean="#attributes.bean#" property="#attributes.property#" deleteKey="#attributes.deleteKey#" compactDisplay="#attributes.compactDisplay#" size="#attributes.size#" filetype="#filetype#" locked="#attributes.locked#">
		</cfif>
	</div>


</cfoutput>