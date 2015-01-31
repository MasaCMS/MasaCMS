<cfsilent>
<cfparam name="attributes.bean" default="">
<cfparam name="attributes.property" default="fileid">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.deleteKey" default="deleteFile">
<cfparam name="attributes.locked" default="false">

<cfset fileMetaData=attributes.bean.getFileMetaData(attributes.property)>

<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
</cfsilent>
<cfif not fileMetaData.getIsNew()>
<div class="controls rule-dotted-top">
<cfoutput>
	<cfif 
		(
			(attributes.bean.getType() eq 'File' and attributes.property eq 'fileid') 
			or
			 (not fileMetaData.hasImageFileExt() and attributes.property neq 'fileid')
		)>
	     <div class="mura-file #lcase(attributes.bean.getFileExt())#">
	     	<!--- <p class="current-file">Current File</p><br> --->
		 	<i class="<cfif fileMetaData.hasImageFileExt()>icon-picture<cfelse>icon-file-text-alt</cfif> icon-2x"></i> #HTMLEditFormat(fileMetaData.getFilename())#<cfif attributes.property eq 'fileid' and attributes.bean.getMajorVersion()> (v#attributes.bean.getMajorVersion()#.#attributes.bean.getMinorVersion()#)</cfif>
	     </div>
	     
	</cfif>

	<cfif fileMetaData.hasImageFileExt()>
		<div class="btn-group imageToolsButtonGroup">
			<a class="btn" href="./?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#"><i class="icon-crop"></i></a>
			<a class="btn" href="" onclick="return openFileMetaData('#fileMetaData.getContentHistID()#','#fileMetaData.getFileID()#','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
	</cfif>
	<cfif attributes.property neq "fileid" or (attributes.property eq "fileid"  and attributes.bean.getType() neq 'File') >
		<a class="btn download-file" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment&size=source';});"><i class="icon-download"></i></a>		 	
	<cfelse>
		<a id="mura-download-locked" <cfif not attributes.locked> style="display:none"</cfif> class="btn download-file" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment&size=source';});"><i class="icon-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.download')#</a>
		<div id="mura-download-unlocked" class="btn-group"<cfif attributes.locked> style="display:none"</cfif>>
			<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
				<i class="icon-download"></i> <span class="caret"></span>
			 </a>
			<ul class="dropdown-menu">
				<!-- dropdown menu links -->
				<li><a href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment&size=source';});"><i class="icon-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.download')#</a></li>
				<li><a id="mura-file-offline-edit" href="##"><i class="icon-lock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a></li>
			</ul>
		</div>
	</cfif>
	<cfif fileMetaData.hasImageFileExt()>
		</div>
		<img id="assocImage" src="#request.context.$.getURLForImage(fileid=attributes.bean.getvalue(attributes.property),size=attributes.size)#?cacheID=#createUUID()#" />
	</cfif>	

	<cfif not (attributes.bean.getType() eq 'File' and attributes.property eq 'fileid')>
	<div>
		<label class="checkbox inline" for="deleteFileBox">
			<input type="checkbox" name="#attributes.deleteKey#" value="1" class="deleteFileBox"/><a href="##" rel="tooltip" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfiletooltip')#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')# <i class="icon-question-sign"></i></a>
		</label>
	</div>
	</cfif>

	<cfif attributes.property eq 'fileid' and attributes.bean.getType() eq 'File'>
		
		<script>
			<cfset csrf=fileMetaData.getCurrentUser().generateCSRFTokens(context=attributes.bean.getContentID() & 'unlockfile')>
			jQuery(".mura-file-unlock").click(
				function(event){
					event.preventDefault();
					confirmDialog(
						"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
						function(){
							jQuery("##msg-file-locked").fadeOut();
							jQuery(".mura-file-unlock").hide();
							jQuery("##mura-file-offline-edit").fadeIn();
							jQuery("##mura-download-unlocked").show();
							jQuery("##mura-download-locked").hide();
							jQuery("##msg-file-locked-else").fadeOut();
							siteManager.hasFileLock=false;
							jQuery.post("./",{
								muraAction:"carch.unlockfile",
								contentid:"#attributes.bean.getContentID()#",
								siteid:"#attributes.bean.getSiteID()#",
								csrf_token:'#csrf.token#',
								csrf_token_expires: '#csrf.expires#'
							})
						}
					);	
								
				}
			);

			jQuery("##mura-file-offline-edit").click(
				function(event){
					event.preventDefault();
					var a=this;
					confirmDialog(
						"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineeditingconfirm'))#",
						function(){
							jQuery("##msg-file-locked").fadeIn();
							jQuery(".mura-file-unlock").fadeIn();
							jQuery("##mura-download-unlocked").hide();
							jQuery("##mura-download-locked").show();
							jQuery("##msg-file-locked-else").hide();
							jQuery(a).fadeOut();
							siteManager.hasFileLock=true;
							document.location="./?muraAction=carch.lockfile&contentID=#attributes.bean.getContentID()#&siteID=#attributes.bean.getSiteID()##fileMetaData.getCurrentUser().renderCSRFTokens(context=attributes.bean.getContentID() & 'lockfile',format='url')#";
						}
					);	
				}
			);
		</script>

			
	</cfif>
</cfoutput>
</div>
</cfif>