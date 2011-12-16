<cfoutput>
<cfif attributes.type neq 'File'>
<dt>
<cfelse>
<dt class="separate">	
</cfif>	
<cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage')#</span></a><cfelse>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
</cfif>	
</dt>
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
</cfif></dd>
<cfif request.contentBean.getcontentType() eq 'image' or attributes.type neq 'File'><dd>
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
 		<a class="mura-file #lcase(request.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#request.contentBean.getFileID()#">#HTMLEditFormat(request.contentBean.getFilename())#</a>
 		
 		<!--- Start Lock/download stuff --->
 		
 			<!--- Unlocked --->
 			<a class="mura-file-offline-edit">Download for Offline Editing</a>
 			
 			
 		
 		<!--- End Lock Download stuff --->
 		
	</cfif>
	<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
</cfif>
</cfoutput>