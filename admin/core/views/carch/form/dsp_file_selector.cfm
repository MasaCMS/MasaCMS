<cfset fileLockedByYou=stats.getLockType() neq 'node' and stats.getLockID() eq session.mura.userID>
<cfset fileLockedBySomeElse=len(stats.getLockID()) and stats.getLockType() neq 'node' and  stats.getLockID() neq session.mura.userID>
<cfset examplefileext="zip">
<cfoutput>
<div id="assocFileContainer" class="mura-control-group" style="display:none">
   <label>
	<cfif rc.ptype eq 'Gallery' or rc.type neq 'File'>
		<cfset examplefileext="png">
		<span data-toggle="popover" title="" data-placement="right"
  	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.selectimage"))#"
  	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.selectimage"))#">
  		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')# <i class="mi-question-circle"></i></span>
	<cfelse>
		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
	</cfif>
	</label>
	<cfif not fileLockedBySomeElse>
		<cfif  rc.type eq 'File'
			and (rc.type eq 'File' and not rc.contentBean.getIsNew())>
			<p id="msg-file-locked" class="help-block"<cfif not fileLockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a class="mura-file-unlock" href="##"<cfif not fileLockedByYou> style="display:none;"</cfif>><i class="mi-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
			</p>
		</cfif>

		<cfset imageOnly=rc.ptype eq 'Gallery' or rc.type neq 'File'>
		<cf_fileselector name="newfile" property="fileid" bean="#rc.contentBean#" deleteKey="deleteFile" compactDisplay="#rc.compactDisplay#" locked="#len(stats.getLockID())#" examplefileext="#examplefileext#" >

        <!--- 
		<cfif rc.type eq 'File'>
			<input type="hidden" name="fileid" value="#esapiEncode('html_attr',rc.contentBean.getFileID())#" />
		</cfif>
        --->
	<cfelse>
		<!--- Locked by someone else --->
		<cfset lockedBy=$.getBean("user").loadBy(stats.getLockID())>
		<p id="msg-file-locked" class="help-block" style="display:none;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a class="mura-file-unlock" href="##"<cfif not fileLockedByYou> style="display:none;"</cfif>><i class="mi-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
		</p>


		<p id="msg-file-locked-else" class="help-block">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#.<br>
		<a href="mailto:#esapiEncode('html',lockedBy.getEmail())#?subject=#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.fileunlockrequest'))#"><i class="mi-envelope"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.requestfilerelease')#</a>
		<cfif $.currentUser().isSuperUser() or $.currentUser().isAdminUser()>
		 &nbsp; &nbsp;<a class="mura-file-unlock" href="##"><i class="mi-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
		</cfif>
		</p>

		<div class="mura-file-selector">
			<cf_filetools name="newfile" property="fileid" bean="#rc.contentBean#" deleteKey="deleteFile" compactDisplay="#rc.compactDisplay#" locked="#len(stats.getLockID())#" lockedby="#lockedBy#">
		</div>
        <!---
        <input type="hidden" name="fileid" value="#esapiEncode('html_attr',rc.contentBean.getFileID())#" />
        --->
	</cfif>
	<script>
		siteManager.hasFileLock=<cfif stats.getLockType() neq 'node' and stats.getLockID() eq session.mura.userID>true<cfelse>false</cfif>;
		siteManager.unlockfileconfirm="#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#";
	</script>
	<input type="hidden" id="unlockfilewithnew" name="unlockfilewithnew" value="false" />
</div>
</cfoutput>
