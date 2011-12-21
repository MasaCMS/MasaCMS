<cfset stats=request.contentBean.getStats()>
<cfset lockedByYou=stats.getLockID() eq session.mura.userID>
<cfset lockedBySomeElse=len(stats.getLockID()) and stats.getLockID() neq session.mura.userID>
<cfoutput>
<cfif attributes.type neq 'File'>
<dt>
<cfelse>
<dt class="separate">	
</cfif>

<cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'>
	<a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage')#</span></a>
<cfelse>
	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
</cfif>	
</dt>

<cfif not lockedBySomeElse>
	<dd>
	<cfif  attributes.type eq 'File'
		and (attributes.type eq 'File' and not request.contentBean.getIsNew())>
		<p id="msg-file-locked" class="notice"<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')#</p>
	</cfif>
	<input type="file" id="file" name="NewFile" <cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'>accept="image/jpeg,image/png" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newimagevalidate')#"</cfif>>
	<cfif attributes.type eq "file" and not request.contentBean.getIsNew()>
		<p style="display:none;" id="mura-revision-type">
			<label>
				<input type="radio" name="versionType" value="major">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')#
			</label>
			<label>
				<input type="radio" name="versionType" value="minor" checked />#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#
			</label>
		</p>
		<script>
			jQuery("##file").change(function(){
				jQuery("##mura-revision-type").fadeIn();
			});	
		</script>
	</cfif>
	</dd>
	<cfif attributes.type neq 'File'>
		<dd>
			<cfif len(request.contentBean.getFileID())>
				<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#request.contentBean.getFileID()#" /><input type="checkbox" name="deleteFile" value="1" id="deleteFileBox"/> <label for="deleteFileBox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#</label>
			</cfif>
			<cfif attributes.type neq 'File'>
				<span id="selectAssocImage">
				<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getfileid())#" />		
				<a class="selectImage" href="javascript:##;" onclick="javascript: loadAssocImages('#htmlEditFormat(attributes.siteid)#','#htmlEditFormat(request.contentBean.getFileID())#','#htmlEditFormat(attributes.contentID)#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#]</a>
				</span>
				
				<span id="selectAssocImageReInit" style="display:none">
					<input type="hidden" name="fileidReInit" value="#htmlEditFormat(request.contentBean.getfileid())#" />
					<a href="javascript:##;" onclick="javascript: loadAssocImages('#htmlEditFormat(attributes.siteid)#','#htmlEditFormat(request.contentBean.getFileID())#','#htmlEditFormat(attributes.contentID)#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#]</a>
				</span>
			<cfelse>
				<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
			</cfif>
		</dd>
	<cfelse>
		<cfif attributes.type eq 'File' and not request.contentBean.getIsNew()>
		<dd>
			<a class="mura-file #lcase(request.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#request.contentBean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(request.contentBean.getFilename())#<cfif request.contentBean.getMajorVersion()> (v#request.contentBean.getMajorVersion()#.#request.contentBean.getMinorVersion()#)</cfif></a>
		
			<a id="mura-file-unlock" class="btn-alt"  href=""<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
		 	<a id="mura-file-offline-edit" class="btn-alt"<cfif len(stats.getLockID())> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a>	

		</dd>
		<cfif request.contentBean.getcontentType() eq 'image'>
		<dd>
			<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#request.contentBean.getFileID()#" />
		</dd>
		</cfif>
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
								hasFileLock=false;
								jQuery.post("./index.cfm",{fuseaction:"carch.unlockfile",contentid:"#request.contentBean.getContentID()#",siteid:"#request.contentBean.getSiteID()#"})
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
								hasFileLock=true;
								document.location="./index.cfm?fuseaction=carch.lockfile&contentID=#request.contentBean.getContentID()#&siteID=#request.contentBean.getSiteID()#";
							}
						);	
					}
				);
			</script>

		</cfif>
		<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
	</cfif>
<cfelse>
	<!--- Locked by someone else --->
	<dd>
		<cfset lockedBy=$.getBean("user").loadBy(stats.getLockID())>
		<p id="msg-file-locked" class="error">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#  <a href="mailto:#HTMLEditFormat(lockedBy.getEmail())#?subject=#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.fileunlockrequest'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.requestfilerelease')#</a></p>
		<a class="mura-file #lcase(request.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#request.contentBean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(request.contentBean.getFilename())#<cfif request.contentBean.getMajorVersion()> (v#request.contentBean.getMajorVersion()#.#request.contentBean.getMinorVersion()#)</cfif></a>
		 <cfif listFindNoCase(session.mura.memberships,"s2")><a id="mura-file-unlock" href="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a></cfif>
		<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
	</dd>
	<cfif request.contentBean.getcontentType() eq 'image'>
		<dd>
			<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#request.contentBean.getFileID()#" />
		</dd>
	</cfif>
	<cfif listFindNoCase(session.mura.memberships,"s2")>
	<script>
		jQuery("##mura-file-unlock").click(
					function(event){
						event.preventDefault();
						confirmDialog(
							"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
							function(){
								jQuery.post(
									"./index.cfm",{fuseaction:"carch.unlockfile",contentid:"#request.contentBean.getContentID()#",siteid:"#request.contentBean.getSiteID()#"},
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
</cfoutput>