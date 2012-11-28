<cfset stats=rc.contentBean.getStats()>
<cfset lockedByYou=stats.getLockID() eq session.mura.userID>
<cfset lockedBySomeElse=len(stats.getLockID()) and stats.getLockID() neq session.mura.userID>
<cfoutput>
<div class="control-group">
   <label class="control-label">
	<cfif rc.ptype eq 'Gallery' or rc.type neq 'File'>
		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')# <i class="icon-question-sign"></i></a>
	<cfelse>
		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
	</cfif>	
	</label>
     <div class="controls">
		<cfif not lockedBySomeElse>
			<cfif  rc.type eq 'File'
				and (rc.type eq 'File' and not rc.contentBean.getIsNew())>
				<p id="msg-file-locked" class="alert"<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')#</p>
			</cfif>
			<input type="file" id="file" name="NewFile" <cfif rc.ptype eq 'Gallery' or rc.type neq 'File'>accept="image/jpeg,image/png" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newimagevalidate')#"</cfif>>
			<cfif rc.type eq "file" and not rc.contentBean.getIsNew()>
				<p style="display:none;" id="mura-revision-type">
					<label class="radio inline">
						<input type="radio" name="versionType" value="major">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')#
					</label>
					<label class="radio inline">
						<input type="radio" name="versionType" value="minor" checked />#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#
					</label>
				</p>
				<script>
					jQuery("##file").change(function(){
						jQuery("##mura-revision-type").fadeIn();
					});	
				</script>
			</cfif>
			<cfif rc.type neq 'File'>			
				<cfif len(rc.contentBean.getFileID())>
					<a href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#rc.contentBean.getContentHistID()#&siteid=#rc.contentBean.getSiteID()#&fileid=#rc.contentBean.getFileID()#&compactDisplay=#urlEncodedFormat(rc.compactDisplay)#"><img id="assocImage" src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rc.contentBean.getFileID()#&cacheID=#createUUID()#" /></a>
					<label class="checkbox inline" for="deleteFileBox"><input type="checkbox" name="deleteFile" value="1" id="deleteFileBox"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#</label>
				</cfif>
				<cfif rc.type neq 'File'>
					<span id="selectAssocImage">
					<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getfileid())#" />		
					<a class="selectImage btn btn-small" href="javascript:##;" onclick="javascript: siteManager.loadAssocImages('#htmlEditFormat(rc.siteid)#','#htmlEditFormat(rc.contentBean.getFileID())#','#htmlEditFormat(rc.contentID)#','',1);return false;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#</a>
					</span>
					
					<span id="selectAssocImageReInit" style="display:none">
						<input type="hidden" name="fileidReInit" value="#htmlEditFormat(rc.contentBean.getfileid())#" />
						<a class="btn btn-small" href="javascript:##;" onclick="javascript: siteManager.loadAssocImages('#htmlEditFormat(rc.siteid)#','#htmlEditFormat(rc.contentBean.getFileID())#','#htmlEditFormat(rc.contentID)#','',1);return false;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#</a>
					</span>
				<cfelse>
					<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
				</cfif>				
			<cfelse>
				<cfif rc.type eq 'File' and not rc.contentBean.getIsNew()>
					
					<a class="mura-file #lcase(rc.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#rc.contentBean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(rc.contentBean.getAssocFilename())#<cfif rc.contentBean.getMajorVersion()> (v#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#)</cfif></a>
									
					<cfif rc.contentBean.getcontentType() eq 'image'>				
						<a href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#rc.contentBean.getContentHistID()#&siteid=#rc.contentBean.getSiteID()#&fileid=#rc.contentBean.getFileID()#&compactDisplay=#urlEncodedFormat(rc.compactDisplay)#"><img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rc.contentBean.getFileID()#&cacheID=#createUUID()#" /></a>
					</cfif>
					
					<a id="mura-file-unlock" class="btn"  href=""<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
				 	<a id="mura-file-offline-edit" class="btn"<cfif len(stats.getLockID())> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a>
					
					<script>
						jQuery("##mura-file-unlock").click(
							function(event){
								event.preventDefault();
								confirmDialog(
									"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
									function(){
										jQuery("##msg-file-locked").fadeOut();
										jQuery("##mura-file-unlock").hide();
										jQuery("##mura-file-offline-edit").fadeIn();
										siteManager.hasFileLock=false;
										jQuery.post("./index.cfm",{muraAction:"carch.unlockfile",contentid:"#rc.contentBean.getContentID()#",siteid:"#rc.contentBean.getSiteID()#"})
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
										jQuery("##mura-file-unlock").fadeIn();
										jQuery(a).fadeOut();
										siteManager.hasFileLock=true;
										document.location="./index.cfm?muraAction=carch.lockfile&contentID=#rc.contentBean.getContentID()#&siteID=#rc.contentBean.getSiteID()#";
									}
								);	
							}
						);
					</script>

				</cfif>
			<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
		</cfif>
	<cfelse>
		<!--- Locked by someone else --->
		
			<cfset lockedBy=$.getBean("user").loadBy(stats.getLockID())>
			<p id="msg-file-locked" class="alert alert-error help-block">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#  <a href="mailto:#HTMLEditFormat(lockedBy.getEmail())#?subject=#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.fileunlockrequest'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.requestfilerelease')#</a></p>
			<a class="mura-file #lcase(rc.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#rc.contentBean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(rc.contentBean.getAssocFilename())#<cfif rc.contentBean.getMajorVersion()> (v#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#)</cfif></a>
			<cfif rc.contentBean.getcontentType() eq 'image'>
				<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rc.contentBean.getFileID()#" />
				</cfif>
			 <cfif listFindNoCase(session.mura.memberships,"s2")><a id="mura-file-unlock" href="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a></cfif>
			<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
		
		
		<cfif listFindNoCase(session.mura.memberships,"s2")>
		<script>
			jQuery("##mura-file-unlock").click(
						function(event){
							event.preventDefault();
							confirmDialog(
								"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
								function(){
									jQuery.post(
										"./index.cfm",{muraAction:"carch.unlockfile",contentid:"#rc.contentBean.getContentID()#",siteid:"#rc.contentBean.getSiteID()#"},
										function(){location.reload();}
									);
								}
							);	
							
						}
					);
		</script>
		</cfif>
	</cfif>
	<script>
		hasFileLock=<cfif stats.getLockID() eq session.mura.userID>true<cfelse>false</cfif>;
		unlockfileconfirm="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#";
	</script>
	<input type="hidden" id="unlockwithnew" name="unlockwithnew" value="false" />
	</div>
	</div>
</cfoutput>