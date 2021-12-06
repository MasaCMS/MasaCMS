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
	<cfparam name="attributes.styleFileInput" default="true">
	<cfparam name="attributes.maxUploadFileSize" default="10485760">

	<cfif not val(attributes.maxUploadFileSize)>
		<cfset attributes.maxUploadFileSize = 10485760>
	</cfif>

	<cfset invalidimagefilesize=application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.invalidimagefilesize'),attributes.maxUploadFileSize/1024/1024)/>

	<cfset guid=createUUID()>

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
	<div id="mura-fileselector-#esapiEncode('html_attr',guid)#" data-name="#esapiEncode('html_attr',attributes.name)#" data-property="#esapiEncode('html_attr',attributes.property)#" data-fileid="#esapiEncode('html_attr',attributes.bean.getValue(attributes.property))#" data-filetype="#esapiEncode('html_attr',filetype)#" data-contentid="#attributes.bean.getcontentid()#" data-siteid="#attributes.bean.getSiteID()#" class="mura-file-selector<cfif len(attributes.class)> #attributes.class#</cfif>">
		<!--- Razuna --->
		<cfset razunaSettings = application.serviceFactory.getBean('settingsManager').getSite(attributes.bean.getSiteID()).getRazunaSettings()>
 		<div class="mura-input-set mura-file-selector-tabs" data-toggle="buttons-radio">
			<button type="button" style="display:none" class="input-set-placeholder">placeholder</button>
 			<button type="button" class="btn btn-default mura-file-type-selector active" value="Upload"><i class="mi-upload"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaupload')#</button>
 			<button type="button" class="btn btn-default mura-file-type-selector" value="Existing"><i class="mi-file-picture-o"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selectexisting')#</button>
			<button type="button" class="btn btn-default mura-file-type-selector" value="URL"><i class="mi-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaurl')#</button>
 			<cfif len(application.serviceFactory.getBean('settingsManager').getSite(attributes.bean.getSiteID()).getRazunaSettings().getHostname())>
 			<button type="button" class="btn btn-default mura-file-type-selector btn-razuna-icon" value="URL-Razuna"><i></i> Razuna</button>
 			</cfif>
 		</div>

		<!--- File upload --->
		<div id="mura-file-upload-#esapiEncode('html_attr',attributes.name)#" class="mura-file-option mura-file-upload fileTypeOption#esapiEncode('html_attr',attributes.name)#">

			<div class="mura-control-group">
				<cfif attributes.styleFileInput>
					<div class="mura-input-set assocUploadControls">
						<!--- placeholder text input shows filename --->
						<input type="file" data-filename="#esapiEncode('html_attr',attributes.name)#" readonly class="newfile-filename">
						<label class="btn btn-file btn-default">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selectfile'))#
							<!--- attribute 'hidden' keeps input functional but not shown --->
							<input hidden name="#esapiEncode('html_attr',attributes.name)#" id="mura-file-input-#esapiEncode('html_attr',attributes.name)#" type="file" class="mura-file-selector-#esapiEncode('html_attr',attributes.name)#" data-label="#esapiEncode('html_attr',attributes.required)#" data-validation="#esapiEncode('html_attr',attributes.validation)#" data-regex="#esapiEncode('html_attr',attributes.regex)#" data-message="#esapiEncode('html_attr',attributes.message)#">
						</label>
					</div>
					<script>
						// show preview on selecting file for upload or entering URL
						$(document).on('change', '##mura-fileselector-#esapiEncode('html_attr',guid)# .mura-file-selector-#esapiEncode('html_attr',attributes.name)#', function(){
							var inputEl = $(this);

							let contextID = "##"+inputEl.parents('.mura-file-selector').attr("id")+" ";

							var fn = inputEl.val().replace(/\\/g, '/').replace(/.*\//, '');
							var fnEl = $(contextID+'.newfile-filename[data-filename="' + $(inputEl).attr("name") + '"]');
							var file = $(contextID+'##mura-file-input-#esapiEncode('html_attr',attributes.name)#').prop("files")[0];
							var fileTools = $(contextID+'##assocFileTools-#esapiEncode('html_attr',attributes.property)#');
							var nextImage = $(contextID+'img##mura-associmg-ph-#esapiEncode('html_attr',attributes.name)#');
							var prevImage = $(contextID+'##assocImage');
							var imagePreview = $('##assocImagePreview');
							var imageUrl = '';

							// file upload
							if (typeof file !== 'undefined'){
								imageUrl = window.URL.createObjectURL(file);
								$(fnEl).val(fn);
								// $(fImg).hide();
								$(fileTools).hide();
								if(file.type.indexOf('image') == 0 && imageUrl.length){
									let maxUploadFileSize = #val(attributes.maxUploadFileSize)#;
									if (file.size > maxUploadFileSize){
										alert("#invalidimagefilesize#");
										$(contextID+"input[name=#esapiEncode('html_attr',attributes.name)#]").val('').change();
										$(contextID+'.mura-associmg-ph .spinner').spin(false).hide();
										return;
									} else {
										$(prevImage).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
										$(nextImage).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
										<cfif attributes.property eq 'fileid'>
											$(imagePreview).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
											$(imagePreview).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
										</cfif>
									}
								}
							// url input
							} else if ($(inputEl).hasClass('mura-url-input-#attributes.name#')){
								imageUrl = $(inputEl).val();
								$(fileTools).hide();
								
								if (!imageUrl && imageUrl.length <= 0){
									return;
								}

								let maxUploadFileSize = #val(attributes.maxUploadFileSize)#;
								inputEl.prop("disabled",true)
								
								var xhr = new XMLHttpRequest();
								xhr.open('HEAD', imageUrl, true);
								xhr.onreadystatechange = () => {
									if ( xhr.readyState == 4 ) {
										if ( xhr.status == 200 ) {
											let size = xhr.getResponseHeader('Content-Length');
											inputEl.prop("disabled",false);
											if (size > maxUploadFileSize){
												alert("#invalidimagefilesize#");
												inputEl.val('').change();
												return;
											} else {
												//load image 
												$(prevImage).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
												$(nextImage).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
												<cfif attributes.property eq 'fileid'>
													$(imagePreview).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
													$(imagePreview).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
												</cfif>
											}
										} 
									}
								};
								xhr.onerror = (error) => {
									//load image 
									inputEl.prop("disabled",false);
									
									$(prevImage).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
									$(nextImage).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
									<cfif attributes.property eq 'fileid'>
										$(imagePreview).handlers().preview(true).on('load error', function(){$(this).handlers().preview()});
										$(imagePreview).handlers().loading(true).attr('src',imageUrl).on('load', function(){$(this).handlers().loading(false)});
									</cfif>
								};
								xhr.send(null);
							}

						});
						// click placeholder image to launch file selector
						$(document).on('click', 'img##mura-file-ph-#esapiEncode('html_attr',attributes.name)#',function(){
						 	$(this).parents('.mura-input-set').find('.btn-file').trigger('click');
						 })
						 // clear placeholder image on switching input types
						 $(document).on('click', '.mura-file-selector-tabs .mura-file-type-selector', function(){
							 $('img##mura-file-ph-#esapiEncode('html_attr',attributes.name)#').hide().attr('src','');
						})
					</script>
				<cfelse>
					<input name="#esapiEncode('html_attr',attributes.name)#" type="file" class="mura-file-selector-#esapiEncode('html_attr',attributes.name)#" data-label="#esapiEncode('html_attr',attributes.label)#" data-label="#esapiEncode('html_attr',attributes.required)#" data-validation="#esapiEncode('html_attr',attributes.validation)#" data-regex="#esapiEncode('html_attr',attributes.regex)#" data-message="#esapiEncode('html_attr',attributes.message)#">
				</cfif>

				<a style="display:none;" class="btn btn-default" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#esapiEncode('javascript',attributes.property)#');"><i class="mi-info-circle"></i></a>
			</div>

		</div>

		<!--- URL --->
		<div id="mura-file-url-#esapiEncode('html_attr',attributes.name)#" class="mura-file-option mura-file-url fileTypeOption#attributes.name#">
			<div class="mura-control-group">
				<div class="mura-input-set assocUrlControls">
					<input type="text" name="#attributes.name#" class="mura-file-selector-#attributes.name# mura-url-input-#attributes.name#" type="url" placeholder="http://www.domain.com/myfile.#attributes.examplefileext#"	value=""
					data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
					<a style="display:none;" class="btn btn-default file-meta-open" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="mi-info-circle"></i></a>
				</div>
			</div>
		</div>

		<!--- Existing (file search) --->
		<div id="mura-file-existing-#esapiEncode('html_attr',attributes.name)#" class="mura-file-option mura-file-existing fileTypeOption#attributes.name#">
		</div>

		<!--- Razuna URL --->
		<cfif len(razunaSettings.getAPIKey())>
			<div id="mura-file-url-#attributes.name#" class="mura-file-option mura-file-url-razuna fileTypeOption#attributes.name#">
				<div class="mura-control-group">
						<div class="input-append">
							<input type="text" name="#esapiEncode('html_attr',attributes.name)#" class="mura-file-selector-#attributes.name# span6 razuna-url" type="url" placeholder="http://#razunaSettings.getHostName()#" data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
							<a style="display:none;" class="btn btn-default file-meta-open" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="mi-info-circle"></i></a>
							<button type="button" onclick="renderRazunaWindow('newfile');" class="btn btn-razuna"><i class="mi-external-link-sign"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.launchrazuna')#</button>
						</div>
				</div>
 			</div>
		</cfif>

		<cfif attributes.styleFileInput>
			<div class="mura-associmg-ph">
				<img style="display:none;" id="mura-associmg-ph-#esapiEncode('html_attr',attributes.name)#" src="" onerror="this.onerror=null;this.src='';this.style.display='none';">
			</div>			
 		</cfif>

		<!--- Revision type --->
		<cfif attributes.bean.getType() eq 'File' and attributes.property eq 'fileid' and len(attributes.bean.getFileID())>

			<div style="display:none;" class="mura-revision-type">
				<label class="radio inline">
					<input type="radio" name="versionType" value="major">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')#
				</label>
				<label class="radio inline">
					<input type="radio" name="versionType" value="minor" checked />#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#
				</label>
			</div>
			<script>
				jQuery(".mura-file-selector-newfile").change(function(){
					jQuery(".mura-revision-type").fadeIn();
					});
			</script>
		</cfif>

		<!--- File locking --->
		<cfif isObject(attributes.bean) and len(attributes.bean.get(attributes.property))>
			<cf_filetools bean="#attributes.bean#" property="#attributes.property#" deleteKey="#attributes.deleteKey#" compactDisplay="#attributes.compactDisplay#" size="#attributes.size#" filetype="#filetype#" locked="#attributes.locked#">
		</cfif>
	</div>
</cfoutput>