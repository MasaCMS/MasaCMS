<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfif not listFind("Portal,Gallery",$.content('type'))>
	<cfswitch expression="#$.getJsLib()#">
		<cfcase value="jquery">
			<cfset $.getContentRenderer().loadJSLib() />
		 	<cfset $.addToHTMLHeadQueue("comments/htmlhead/comments-jquery.cfm")>
		</cfcase>
		<cfdefaultcase>
			<!--- no such luck, signed Grant --->
		</cfdefaultcase>
	</cfswitch>
	<cfsilent>
		<cfparam name="request.subscribe" default="0">
		<cfparam name="request.remember" default="0">
		<cfparam name="cookie.name" default="">
		<cfparam name="cookie.email" default="">
		<cfparam name="cookie.url" default="">
		<cfparam name="cookie.remember" default="0">
		<cfparam name="cookie.subscribe" default="0">

		<cfset errorJSTxt = "">

		<cfif not structKeyExists(request,"name")>
			<cfif structKeyExists(cookie,"name")>
				<cfset request.name=cookie.name>
			<cfelseif $.currentUser().isLoggedIn()>
				<cfset request.name=$.currentUser().getUserName()>
			</cfif>
		</cfif>

		<cfif not structKeyExists(request,"url")>
			<cfset request.url=cookie.url>
		</cfif>

		<cfif not structKeyExists(request,"email")>
			<cfif structKeyExists(cookie,"email")>
				<cfset request.email=cookie.email>
			<cfelseif $.currentUser().isLoggedIn()>
				<cfset request.email=$.currentUser().getEmail()>
			</cfif>
		</cfif>

		<cfif not structKeyExists(request,"subscribe")>
			<cfset request.subscribe=cookie.subscribe>
		</cfif>

		<cfif not structKeyExists(request,"remember")>
			<cfset request.remember=cookie.remember>
		</cfif>

		
		<cfset theContentID=$.content('contentID')>
		<cfset request.isEditor=(listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite($.event('siteID')).getPrivateUserPoolID()#')
				and application.permUtility.getnodePerm(request.crumbdata) neq 'none')
				or listFind(session.mura.memberships,'S2')>
		<cfparam name="request.commentid" default="">
		<cfparam name="request.comments" default="">
		<cfparam name="request.commenteditmode" default="add">
		<cfparam name="request.securityCode" default="">
		<cfparam name="session.securityCode" default="">
		<cfparam name="request.deletecommentid" default="">
		<cfparam name="request.approvedcommentid" default="">
		<cfparam name="request.isApproved" default="1">
		<cfparam name="request.hkey" default="">
		<cfparam name="request.ukey" default="">

		<cfset errors=structNew()/>

		<cfif structKeyExists(request,"commentUnsubscribe")>
			<cfset application.contentManager.commentUnsubscribe($.content('contentID'),request.commentUnsubscribe,$.event('siteID'))>
			<cfset errors["unsubscribe"]=$.rbKey('comments.youhaveunsubscribed')>
		</cfif>

		<cfif request.commentid neq '' and request.comments neq '' and request.name neq ''>

			<cfset passedProtect = true>
			<cfscript>
				myRequest = structNew();
				StructAppend(myRequest, url, "no");
				StructAppend(myRequest, form, "no");
			</cfscript>

			<cfif structKeyExists(myRequest, "useProtect")>
				<cfset cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

				<cfif application.settingsManager.getSite($.event('siteID')).getContactEmail() neq "">
					<cfset cffp.updateConfig('emailServer', application.settingsManager.getSite($.event('siteID')).getMailServerIP())>
					<cfset cffp.updateConfig('emailUserName', application.settingsManager.getSite($.event('siteID')).getMailserverUsername(true))>
					<cfset cffp.updateConfig('emailPassword', application.settingsManager.getSite($.event('siteID')).getMailserverPassword())>
					<cfset cffp.updateConfig('emailFromAddress', application.settingsManager.getSite($.event('siteID')).getMailserverUsernameEmail())>
					<cfset cffp.updateConfig('emailToAddress', application.settingsManager.getSite($.event('siteID')).getContactEmail())>
					<cfset cffp.updateConfig('emailSubject', 'Spam form submission')>
				</cfif>

				<cfset passedProtect = cffp.testSubmission(myRequest)>
			</cfif>

			<cfif (request.hkey eq '' or request.hKey eq hash(lcase(request.ukey))) and passedProtect>

				<cfset submittedData=$.getBean('utility').filterArgs(request,application.badwords)/>
				<cfset submittedData.contentID=theContentID />
				<cfif $.currentUser().isLoggedIn()>
					<cfset request.userID=$.currentUser().getUserID()>
				</cfif>
		
				<cfset submittedData.isApproved=application.settingsManager.getSite($.event('siteID')).getCommentApprovalDefault() />
				
				
				
				<cfif request.commenteditmode eq "add">
					<cfset commentBean=application.contentManager.saveComment(submittedData,event.getContentRenderer()) />
				<cfelseif request.commenteditmode eq "edit" and request.isEditor>
					
					<cfset commentBean=application.contentManager.getCommentBean().setCommentID(request.commentID).load()>
					<cfset commentBean.setName(submittedData.name)>
					<cfset commentBean.setComments(submittedData.comments)>
					<cfset commentBean.setURL(submittedData.url)>
					<cfset commentBean.setEmail(submittedData.email)>
					<cfset commentBean.save()>
				</cfif>
				
				<cfset request.comments=""/>
				<cfif not (request.remember)>
					<cfset request.name=""/>
					<cfset request.email=""/>
					<cfset request.url=""/>
					<cfset request.subscribe=0/>
					<cfset request.remember=0/>
				</cfif>
				<cfif not application.settingsManager.getSite($.event('siteID')).getCommentApprovalDefault() eq 1>
					<cfset commentBean.sendNotification() />
				</cfif>
				<cfif isBoolean(request.remember) and request.remember>
					<cfcookie name="remember" value="1">
					<cfcookie name="subscribe" value="#request.subscribe#">
					<cfcookie name="name" value="#request.name#">
					<cfcookie name="url" value="#request.url#">
					<cfcookie name="email" value="#request.email#">
				<cfelse>
					<cfcookie name="remember" value="0">
					<cfcookie name="subscribe" value="0">
					<cfcookie name="name" value="">
					<cfcookie name="url" value="">
					<cfcookie name="email" value="">
				</cfif>
			<cfelse>
				<cfsavecontent variable="errorJSTxt">
					<script type="text/javascript">
						addLoadEvent(function(){
							window.location.hash="errors";
						});
					</script>
				</cfsavecontent>

				<cfif passedProtect>
					<cfset errors["SecurityCode"]=$.rbKey('captcha.error')>
				<cfelse>
					<cfset errors["Spam"] = $.rbKey("captcha.spam")>
				</cfif>

			</cfif>
		</cfif>

		<cfif request.isEditor and request.deletecommentid neq "" >
			<cfset application.contentManager.deleteComment(request.deletecommentid) />
		</cfif>

		<cfif request.approvedcommentid neq "" >
			<cfset application.contentManager.approveComment(request.approvedcommentid,event.getContentRenderer()) />
		</cfif>
		<cfset level=0>
		<cfset rsComments=application.contentManager.readComments(thecontentID,$.event('siteID'),request.isEditor,"asc","",false ) />
		<cfset rsSubComments=StructNew() />
	</cfsilent>

	<!--- <cfset TotalRecords=rsComments.RecordCount>
	<cfset RecordsPerPage=10>
	<cfset NumberOfPages=Ceiling(TotalRecords/RecordsPerPage)>
	<cfset CurrentPageNumber=Ceiling(request.StartRow/RecordsPerPage)> --->

	<div id="svComments">
		<cfoutput>
		<#$.getHeaderTag('subHead1')#>#$.rbKey('comments.comments')#</#$.getHeaderTag('subHead1')#>
		#$.dspObject_Include(thefile='comments/dsp_comments.cfm')#</cfoutput>
		<cfif not structIsEmpty(errors) >
			<cfoutput>
				#errorJSTxt#
				<a name="errors"></a>
				<div id="editProfileMsg" class="required">
					#$.getBean('utility').displayErrors(errors)#
				</div>
		</cfoutput>

		<cfelseif request.commentid neq '' and application.settingsManager.getSite($.event('siteID')).getCommentApprovalDefault() neq 1>
			<div id="editProfileMsg" class="required">
				<cfoutput>#$.rbKey('comments.postedsoon')#</cfoutput>
			</div>
		</cfif>
		<dd id="postcomment-form">
		<cfoutput><span id="postcomment-comment" style="display: none"><a href="##postcomment">#$.rbKey('comments.newcomment')#</a></span></cfoutput>
		<form id="postcomment" method="post" name="addComment" action="?nocache=1#postcomment" onsubmit="return validate(this);" novalidate="novalidate">
			<a name="postcomment"></a>
			<fieldset>
				<cfoutput><legend id="postacomment">#$.rbKey('comments.postacomment')#</legend>
				<legend id="editcomment" style="display:none">#$.rbKey('comments.editcomment')#</legend>
				<legend id="replytocomment" style="display:none">#$.rbKey('comments.replytocomment')#</legend>
				<ol>
					<li class="req control-group">
						<label class="control-label" for="txtName">#$.rbKey('comments.name')#<ins> (#$.rbKey('comments.required')#)</ins></label>
						<input id="txtName" name="name" type="text" class="text span5" maxlength="50" required="true" message="#htmlEditFormat($.rbKey('comments.namerequired'))#" value="#HTMLEditFormat(request.name)#" />
					</li>
					<li class="req control-group">
						<label class="control-label" for="txtEmail">#$.rbKey('comments.email')#</label>
						<input id="txtEmail" name="email" type="text" class="text span5" maxlength="50" required="true" message="#htmlEditFormat($.rbKey('comments.emailvalidate'))#" value="#HTMLEditFormat(request.email)#" />
					</li>
					<li class="control-group">
						<label for="txtUrl" class="control-label">#$.rbKey('comments.url')#</label>
						<input id="txtUrl" name="url" type="text" class="text span5" maxlength="50" value="#HTMLEditFormat(request.url)#" />
					</li>
					<li class="req "control-group">
						<label for="txtComment" class="control-label">#$.rbKey('comments.comment')#<ins> (#$.rbKey('comments.required')#)</ins></label>
						<textarea id="txtComment" class="span5" name="comments" message="#htmlEditFormat($.rbKey('comments.commentrequired'))#" cols="30" rows="20" required="true">#HTMLEditFormat(request.comments)#</textarea>
					</li>
					<li class="control-group">
						<label for="txtRemember" class="checkbox">#$.rbKey('comments.rememberinfo')#
						<input type="checkbox" id="txtRemember" name="remember" value="1"<cfif isBoolean(cookie.remember) and cookie.remember> checked="checked"</cfif> /></label>
					</li>
					<li class="control-group">
						<label for="txtSubscribe" class="checkbox">#$.rbKey('comments.subscribe')#
						<input type="checkbox" id="txtSubscribe" name="subscribe" value="1"<cfif isBoolean(cookie.subscribe) and cookie.subscribe> checked="checked"</cfif> /></label>
					</li></cfoutput>
					<li>
						<cfoutput>#$.dspObject_Include(thefile='dsp_form_protect.cfm')#</cfoutput>
					</li>
				</ol>
			</fieldset>
			<div class="buttons">
				<cfoutput>
					<p class="required">#$.rbKey('comments.requiredfield')#</p>
					<input type="hidden" name="returnURL" value="#HTMLEditFormat(getCurrentURL())#" />
					<input type="hidden" name="commentid" value="#createuuid()#" />
					<input type="hidden" name="parentid" value="" />
					<input type="hidden" name="commenteditmode" value="add" />
					<input type="hidden" name="linkServID" value="#$.content('contentID')#" />
					<input type="submit" class="submit btn" name="submit" value="#htmlEditFormat($.rbKey('comments.submit'))#" />
				</cfoutput>
			</div>
		</form>
		</dd>	
	</div>
</cfif>