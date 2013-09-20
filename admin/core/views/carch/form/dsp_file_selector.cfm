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
			<p id="msg-file-locked" class="alert"<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a class="mura-file-unlock" href="##"<cfif not lockedByYou> style="display:none;"</cfif>><i class="icon-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
			</p>
		</cfif>

		<cf_fileselector name="newfile" property="fileid" bean="#rc.contentBean#" deleteKey="deleteFile" compactDisplay="#rc.compactDisplay#" locked="#len(stats.getLockID())#" >

		<cfif rc.type eq 'File'>										
			<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
		</cfif>
	<cfelse>
		<!--- Locked by someone else --->	
		<cfset lockedBy=$.getBean("user").loadBy(stats.getLockID())>
		<p id="msg-file-locked" class="alert" style="display:none;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a class="mura-file-unlock" href="##"<cfif not lockedByYou> style="display:none;"</cfif>><i class="icon-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
		</p>
		
		<cfif listFindNoCase(session.mura.memberships,"s2")>
			<p id="msg-file-locked-else" class="alert alert-error">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#.<br>
			<a href="mailto:#HTMLEditFormat(lockedBy.getEmail())#?subject=#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.fileunlockrequest'))#"><i class="icon-envelope"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.requestfilerelease')#</a> &nbsp; &nbsp;<a class="mura-file-unlock" href=""><i class="icon-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>

			</p>
		</cfif>
		<div class="mura-file-selector">
			<cf_filetools name="newfile" property="fileid" bean="#rc.contentBean#" deleteKey="deleteFile" compactDisplay="#rc.compactDisplay#" locked="#len(stats.getLockID())#" lockedby="#lockedBy#">
		</div>
		<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
	</cfif>
	<script>
		hasFileLock=<cfif stats.getLockID() eq session.mura.userID>true<cfelse>false</cfif>;
		unlockfileconfirm="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#";
	</script>
	<input type="hidden" id="unlockwithnew" name="unlockwithnew" value="false" />
	</div>
	</div>
</cfoutput>