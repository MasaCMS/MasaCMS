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
	<dd><input type="file" id="file" name="NewFile" class="text" <cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'>accept="image/jpeg,image/png" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newimagevalidate')#"</cfif>>
	<cfif attributes.type eq "file" and not request.contentBean.getIsNew()>
		<div style="display:none;" id="revisionType">
		<p>
		<dl>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.filerevisiontype')#</dt>
		<dd><input type="radio" name="versionType" value="major"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')# <input type="radio" name="versionType" value="minor" checked/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#</dd>
		</dl>
		</p>
		</div>
		<script>
			jQuery("##file").change(function(){
				jQuery("##revisionType").fadeIn();
			});	
		</script>
	</cfif>
	</dd>
	<cfif request.contentBean.getcontentType() eq 'image' or attributes.type neq 'File'>
		<dd>
			<cfif len(request.contentBean.getFileID())>
				<cfif attributes.type neq 'File'>
					<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#request.contentBean.getFileID()#" /><br /><input type="checkbox" name="deleteFile" value="1" id="deleteFileBox"/> <label for="deleteFileBox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#</label><br />
				<cfelse>
					<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#request.contentBean.getFileID()#" />
				</cfif>
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
			<p id="msg-file-locked" class="notice"<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a id="unlockFile" href="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a></p>
		
			<a class="mura-file #lcase(request.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#request.contentBean.getFileID()#&method=attachment">#HTMLEditFormat(request.contentBean.getFilename())#</a>
		
		 	<a id="lockFileForEditing" class="mura-file-offline-edit"<cfif len(stats.getLockID())> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a>	
		</dd>
			<script>
				jQuery("##unlockFile").click(
					function(event){
						event.preventDefault();
						confirmDialog(
							"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
							function(){
								jQuery("##msg-file-locked").fadeOut();
								jQuery("##lockFileForEditing").fadeIn();
								jQuery.post("./index.cfm",{fuseaction:"carch.unlockfile",contentid:"#request.contentBean.getContentID()#",siteid:"#request.contentBean.getSiteID()#"})
							}
						);	
						
					}
				);
				jQuery("##lockFileForEditing").click(
					function(event){
						event.preventDefault();
						var a=this;
						confirmDialog(
							"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineeditingconfirm'))#",
							function(){
								jQuery("##msg-file-locked").fadeIn();
								jQuery(a).fadeOut();
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
		<p id="msg-file-locked" class="notice">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#  <a href="mailto:#HTMLEditFormat(lockedBy.getEmail())#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.sendmessage')#</a> <cfif listFindNoCase(session.mura.memberships,"s2")><a id="unlockFileSomeoneElse" href="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a></cfif></p>
		<a class="mura-file #lcase(request.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#request.contentBean.getFileID()#&method=attachment">#HTMLEditFormat(request.contentBean.getFilename())#</a>
		<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
	</dd>
	<cfif listFindNoCase(session.mura.memberships,"s2")>
	<script>
		jQuery("##unlockFileSomeoneElse").click(
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
</cfoutput>