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

<cfif attributes.bean.getType() neq 'File' and attributes.property eq 'fileid'>
	<cfset filetype='Image'>
<cfelse>
	<cfset filetype='File'>
</cfif>

<cfoutput>
	<div data-name="#attributes.name#" data-property="#attributes.property#" data-fileid="#attributes.bean.getValue(attributes.property)#" data-filetype="#filetype#" data-contentid="#attributes.bean.getcontentid()#" data-siteid="#attributes.bean.getSiteID()#" class="mura-file-selector #attributes.class#">
		<div class="btn-group" data-toggle="buttons-radio">
			<button type="button" style="display:none">HORRIBLE HACK</button>
			<button type="button" class="btn active" value="Upload"><i class="icon-upload-alt"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaupload')#</button>
			<button type="button" class="btn" value="URL"><i class="icon-download-alt"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.viaurl')#</button>
			<button type="button" class="btn" value="Existing"><i class="icon-picture"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selectexisting')#</button>
		</div>

		<div id="mura-file-upload-#attributes.name#" class="mura-file-option mura-file-upload fileTypeOption#attributes.name#">
			
			<div class="control-group control-group-nested">
				<!--- <label class="control-label"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selectfiletoupload')#</label> --->
				<div class="controls">
					<input name="#attributes.name#" type="file" class="mura-file-selector-#attributes.name#"
						data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validation="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
					<a style="display:none;" class="btn" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>

				</div>

			</div>
				
		</div>
		<div id="mura-file-url-#attributes.name#" class="mura-file-option mura-file-url fileTypeOption#attributes.name#">
				
			<div class="control-group control-group-nested">
				<!--- <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.fileselector.selecturl')#</label> --->
				<div class="controls">		
					<input type="text" name="#attributes.name#" class="mura-file-selector-#attributes.name# span6" type="url" placeholder="http://www.domain.com/yourfile.zip"	value=""
					data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
					<a style="display:none;" class="btn" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
						
					<!---<a href="" id="btn-razuna" title="Select a File from Razuna" rel="tooltip">Razuna</a>--->
				</div>
			</div>
		
		</div>

		<div id="mura-file-existing-#attributes.name#" class="mura-file-option mura-file-existing fileTypeOption#attributes.name#">

		</div>

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