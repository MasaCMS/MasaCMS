<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfif not listFind("Portal,Gallery",request.contentBean.getType())>
<cfsilent>
	<cfset rbFactory=getSite().getRBFactory() />
	<cfset theContentID=request.contentBean.getcontentID()>
	<cfset request.isEditor=(isUserInRole('S2IsPrivate;#application.settingsManager.getSite(request.siteid).getPrivateUserPoolID()#') 
			and application.permUtility.getnodePerm(request.crumbdata) neq 'none') 
			or isUserInRole("S2")>
	<cfparam name="request.commentid" default="">
	<cfparam name="request.comments" default="">
	<cfparam name="request.name" default="">
	<cfparam name="request.email" default="">
	<cfparam name="request.url" default="">
	<cfparam name="request.securityCode" default="">
	<cfparam name="session.securityCode" default="">
	<cfparam name="request.deletecommentid" default="">
	<cfparam name="request.approvedcommentid" default="">
	<cfparam name="request.isApproved" default="1">
	<cfset errors=structNew()/>
	
	<cfif request.commentid neq '' and request.comments neq '' and request.name neq ''>
	
		<cfif request.hKey eq hash(lcase(request.ukey))>
	
			<cfset submittedData=application.utility.filterArgs(request,application.badwords)/>
			<cfset submittedData.contentID=theContentID />
			<cfset submittedData.isApproved=application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() />
			<cfset commentBean=application.contentManager.saveComment(submittedData) />			
			<cfset request.comments=""/>
			<cfset request.name=""/>
			<cfset request.email=""/>
			<cfset request.url=""/>		
			<cfif not application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() eq 1>
				<cfset commentBean.sendNotification() />
			</cfif>
		<cfelse>
			<cfset errors["SecurityCode"]=rbFactory.getKey('comments.captcherror')>
		</cfif>

	</cfif>

	<cfif request.isEditor and request.deletecommentid neq "" >
		<cfset application.contentManager.deleteComment(request.deletecommentid) />
	</cfif>

	<cfif request.isEditor and request.approvedcommentid neq "" >
		<cfset application.contentManager.approveComment(request.approvedcommentid) />
	</cfif>

	<cfset rsComments=application.contentManager.readComments(thecontentID,request.siteid,request.isEditor) />

	</cfsilent>
	<!--- <cfset TotalRecords=rsComments.RecordCount>
	<cfset RecordsPerPage=10> 
	<cfset NumberOfPages=Ceiling(TotalRecords/RecordsPerPage)>
	<cfset CurrentPageNumber=Ceiling(request.StartRow/RecordsPerPage)> --->	
	<a name="comments"></a>
	<div id="svComments">
	<cfif rsComments.recordcount>
		<cfoutput><h3>#rbFactory.getKey('comments.comments')#</h3></cfoutput>
			<!--- This was for the "Guestbook" style comments with pagination 
			<cfif numberofpages gt 1><p class="moreResults"><h4>More Results:</h4> 
				<cfloop from="1"  to="#numberofpages#" index="i">
				<cfoutput><ul>
				<cfif currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="index.cfm?startrow=#evaluate('(#i#*#recordsperpage#)-#recordsperpage#+1')#">#i#</a></li></cfif>
				<cfif currentpagenumber lt numberofpages and not i mod 15></cfif></ul></cfoutput></cfloop></p>
			</cfif> --->	
		<cfoutput query="rsComments"  startrow="#request.startrow#">
		<cfset class=iif(rsComments.currentrow eq 1,de('first'),de(iif(rsComments.currentrow eq rsComments.recordcount,de('last'),de(''))))>
		<dl class="#class#">
			<dt><cfif rsComments.url neq ''><a href="#rsComments.url#" target="_blank">#htmleditformat(rsComments.name)#</a><cfelse>#htmleditformat(rsComments.name)# </cfif> <cfif request.isEditor and rsComments.email neq ''><a href="javascript:noSpam('#listFirst(rsComments.email,'@')#','#listlast(rsComments.email,'@')#')" onfocus="this.blur();">#rbFactory.getKey('comments.email')#</a></cfif></dt>
			<dd class="comment">#setParagraphs(htmleditformat(rsComments.comments))#</dd>
			<dd class="dateTime">#LSDateFormat(rsComments.entered,"long")#, #LSTimeFormat(rsComments.entered,"short")# <cfif request.isEditor> | <a href="index.cfm?deletecommentid=#rscomments.commentid#&nocache=1" onClick="return confirm('Delete Comment?');">#rbFactory.getKey('comments.delete')#</a> <cfif rsComments.isApproved neq 1> | <a href="index.cfm?approvedcommentid=#rscomments.commentid#&nocache=1" onClick="return confirm('Approve Comment?');">#rbFactory.getKey('comments.approve')#</a></cfif></cfif></dd>
		</dl>
		</cfoutput>
		<!--- This was for the "Guestbook" style comments with pagination
		<cfif numberofpages gt 1><div class="moreResults"><h4>More Results:</h4> 
			<cfloop from="1"  to="#numberofpages#" index="i">
			<cfoutput><ul>
			<cfif currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="index.cfm?startrow=#evaluate('(#i#*#recordsperpage#)-#recordsperpage#+1')#">#i#</a></li></cfif>
			<cfif currentpagenumber lt numberofpages and not i mod 15></cfif></ul></cfoutput></cfloop></div>
		</cfif>	--->
	</cfif>

<cfif not structIsEmpty(errors) >
	<cfoutput>
	<div id="editProfileMsg" class="Required">
		#application.utility.displayErrors(errors)#
	</div>
</cfoutput>
<cfelseif request.commentid neq '' and application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() neq 1>
	<div id="editProfileMsg" class="required"><cfoutput>#rbFactory.getKey('comments.postedsoon')#</cfoutput></div>
</cfif>

	<form method="post" name="addComment" action="?nocache=1" onsubmit="return validate(this);" >
		<fieldset>
			<cfoutput><legend>#rbFactory.getKey('comments.postacomment')#</legend>
			<ol>
				<li class="req">
					<label for="txtName">#rbFactory.getKey('comments.name')#<ins> (#rbFactory.getKey('comments.required')#)</ins></label>
					<input id="txtName" name="name" type="text" size="38" class="text" required="true" message="#htmlEditFormat(rbFactory.getKey('comments.namerequired'))#" value="#HTMLEditFormat(request.name)#"/>
				</li>
				<li class="req">
					<label for="txtEmail">#rbFactory.getKey('comments.email')#</label>
					<input id="txtEmail" name="email" type="text" size="38" class="text" required="true" message="#htmlEditFormat(rbFactory.getKey('comments.emailvalidate'))#"value="#HTMLEditFormat(request.email)#"/>
				</li>
				<li>
					<label for="txtUrl">#rbFactory.getKey('comments.url')#</label>
					<input id="txtUrl" name="url" type="text" size="38" class="text" value="#HTMLEditFormat(request.url)#"/>
				</li>
				<li class="req">
					<label for="txtComment">#rbFactory.getKey('comments.comment')#<ins> (#rbFactory.getKey('comments.required')#)</ins></label>
					<textarea id="txtComment" name="comments" message="#htmlEditFormat(rbFactory.getKey('comments.commentrquired'))#" required="true">#HTMLEditFormat(request.comments)#</textarea>
				</li></cfoutput>
				<cfinclude template="dsp_captcha.cfm" ><!--- <li>'s are in captcha --->
			</ol>
		</fieldset>
		<div class="buttons">
			<cfoutput><p class="required">#rbFactory.getKey('comments.requiredfield')#</p>
			<input type="hidden" name="returnURL" value="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.contentRenderer.getCurrentURL()#">
			<input type="hidden" name="commentid" value="#createuuid()#" />
			<input type="submit" class="submit" name="submit" value="#htmlEditFormat(rbFactory.getKey('comments.submit'))#" /></cfoutput>
		</div>
	</form>
</div>
</cfif>