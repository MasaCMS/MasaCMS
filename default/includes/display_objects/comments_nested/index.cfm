<!---
	This file is part of Mura CMS.

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
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<!---
	NOTE: The comment form does not appear on Folders or Galleries
--->
<cfif not listFindNoCase("Folder,Gallery",variables.$.content('type'))>
	<cfoutput>
		<cfsilent>
			<cfparam name="request.subscribe" default="0">
			<cfparam name="request.remember" default="0">
			
			<cfif not isDefined('cookie.remember')>
				<cfcookie name="remember" value="0" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
			</cfif>
			<cfif not isDefined('cookie.subscribe')>
				<cfcookie name="subscribe" value="0" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
			</cfif>
			<cfif not isDefined('cookie.name')>
				<cfcookie name="name" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
			</cfif>
			<cfif not isDefined('cookie.url')>
				<cfcookie name="url" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
			</cfif>
			<cfif not isDefined('cookie.email')>
				<cfcookie name="email" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
			</cfif>

			<cfset errorJSTxt = "">

			<cfif not structKeyExists(request,"name")>
				<cfif structKeyExists(cookie,"name")>
					<cfset request.name=cookie.name>
				<cfelseif variables.$.currentUser().isLoggedIn()>
					<cfset request.name=variables.$.currentUser().getUserName()>
				</cfif>
			</cfif>

			<cfif not structKeyExists(request,"url")>
				<cfset request.url=cookie.url>
			</cfif>

			<cfif not structKeyExists(request,"email")>
				<cfif structKeyExists(cookie,"email")>
					<cfset request.email=cookie.email>
				<cfelseif variables.$.currentUser().isLoggedIn()>
					<cfset request.email=variables.$.currentUser().getEmail()>
				</cfif>
			</cfif>

			<cfif not structKeyExists(request,"subscribe")>
				<cfset request.subscribe=cookie.subscribe>
			</cfif>

			<cfif not structKeyExists(request,"remember")>
				<cfset request.remember=cookie.remember>
			</cfif>

			
			<cfset variables.theContentID=variables.$.content('contentID')>
			<cfset request.isEditor=application.permUtility.getModulePerm("00000000000000000000000000000000015",session.siteid) or application.permUtility.getnodePerm(request.crumbdata) neq 'none'>
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
				<cfset application.contentManager.commentUnsubscribe(variables.$.content('contentID'),request.commentUnsubscribe,variables.$.event('siteID'))>
				<cfset errors["unsubscribe"]=variables.$.rbKey('comments.youhaveunsubscribed')>
			</cfif>

			<cfif request.commentid neq '' and request.comments neq '' and request.name neq ''>


				<cfscript>
					variables.myRequest = structNew();
					StructAppend(variables.myRequest, url, "no");
					StructAppend(variables.myRequest, form, "no");
					// form protection
					variables.passedProtect = variables.$.getBean('utility').isHuman(variables.$.event());
				</cfscript>

				<cfif variables.passedProtect>

					<cfset variables.submittedData=variables.$.getBean('utility').filterArgs(request,application.badwords)/>
					<cfset variables.submittedData.contentID=variables.theContentID />
					<cfif variables.$.currentUser().isLoggedIn()>
						<cfset request.userID=variables.$.currentUser().getUserID()>
					</cfif>
			
					<cfset variables.submittedData.isApproved=application.settingsManager.getSite(variables.$.event('siteID')).getCommentApprovalDefault() />
					
					<cfif request.commenteditmode eq "add">
						<cfset commentBean=application.contentManager.saveComment(submittedData,event.getContentRenderer()) />
					<cfelseif request.commenteditmode eq "edit" and request.isEditor>
						
						<cfset variables.commentBean=application.contentManager.getCommentBean().setCommentID(request.commentID).load()>
						<cfset variables.commentBean.setName(submittedData.name)>
						<cfset variables.commentBean.setComments(submittedData.comments)>
						<cfset variables.commentBean.setURL(submittedData.url)>
						<cfset variables.commentBean.setEmail(submittedData.email)>
						<cfset variables.commentBean.save()>
					</cfif>
					
					<cfset request.comments=""/>
					<cfif not (request.remember)>
						<cfset request.name=""/>
						<cfset request.email=""/>
						<cfset request.url=""/>
						<cfset request.subscribe=0/>
						<cfset request.remember=0/>
					</cfif>
					<cfif not application.settingsManager.getSite(variables.$.event('siteID')).getCommentApprovalDefault() eq 1>
						<cfset commentBean.sendNotification() />
					</cfif>
					<cfif isBoolean(request.remember) and request.remember>
						<cfcookie name="remember" value="1" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="subscribe" value="#request.subscribe#" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="name" value="#request.name#" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="url" value="#request.url#" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="email" value="#request.email#" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
					<cfelse>
						<cfcookie name="remember" value="0" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="subscribe" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="name" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="url" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
						<cfcookie name="email" value="" httponly="true" secure="#variables.$.globalConfig('SecureCookies')#">
					</cfif> 
				<cfelse>
					<cfsavecontent variable="errorJSTxt">
						<script type="text/javascript">
							$(document).ready(function(){
								window.location.hash="errors";
							});
						</script>
					</cfsavecontent>
					<cfset variables.errors["Spam"] = variables.$.rbKey("captcha.spam")>
				</cfif>
			</cfif>

			<cfif request.isEditor and request.deletecommentid neq "" >
				<cfset application.contentManager.deleteComment(request.deletecommentid) />
			</cfif>

			<cfif request.approvedcommentid neq "" >
				<cfset application.contentManager.approveComment(request.approvedcommentid,variables.$.getContentRenderer()) />
			</cfif>
			<cfset variables.level=0>
			<cfset rsComments=application.contentManager.readComments(variables.thecontentID,variables.$.event('siteID'),request.isEditor,"asc","",false ) />
			<cfset variables.rsSubComments=StructNew() />
		</cfsilent>

		<!--- <cfset TotalRecords=rsComments.RecordCount>
		<cfset RecordsPerPage=10>
		<cfset NumberOfPages=Ceiling(TotalRecords/RecordsPerPage)>
		<cfset CurrentPageNumber=Ceiling(request.StartRow/RecordsPerPage)> --->

		<!--- COMMENTS --->
		<script>
			$(function(){
				mura.loader().loadjs("#variables.$.siteConfig('AssetPath')#/includes/display_objects/comments/js/comments-jquery.min.js");
			})
		</script>
		<div id="svComments" class="mura-comments">
			<a name="comments"></a>
			
			<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('comments.comments')#</#variables.$.getHeaderTag('subHead1')#>
			#variables.$.dspObject_Include(thefile='comments_nested/dsp_comments.cfm')#
			<cfif not structIsEmpty(variables.errors) >
				
					#errorJSTxt#
					<a name="errors"></a>
					<div class="#this.alertDangerClass#">
						#variables.$.getBean('utility').displayErrors(variables.errors)#
					</div>

			<cfelseif request.commentid neq '' and application.settingsManager.getSite(variables.$.event('siteID')).getCommentApprovalDefault() neq 1>
				<div class="#this.alertDangerClass#">
					#variables.$.rbKey('comments.postedsoon')#
				</div>
			</cfif>

			<!--- COMMENT FORM --->
			<div id="postcomment-form" class="#this.commentFormWrapperClass#">
				
				<span id="postcomment-comment" style="display: none"><a class="btn btn-default" href="##postcomment">#variables.$.rbKey('comments.newcomment')#</a></span>

				<!--- THE FORM --->
				<form role="form" id="postcomment" class="#this.commentFormClass#" method="post" name="addComment" action="?nocache=1##postcomment" onsubmit="return mura.validateForm(this);" novalidate="novalidate">
					<a name="postcomment"></a>
					<fieldset>

						<legend id="postacomment">#variables.$.rbKey('comments.postacomment')#</legend>
						<legend id="editcomment" style="display:none">#variables.$.rbKey('comments.editcomment')#</legend>
						<legend id="replytocomment" style="display:none">#variables.$.rbKey('comments.replytocomment')#</legend>

						<!--- Name --->
							<div class="req #this.commentFieldWrapperClass#">
								<label class="#this.commentFieldLabelClass#" for="txtName">#variables.$.rbKey('comments.name')#<ins> (#variables.$.rbKey('comments.required')#)</ins></label>
								<div class="#this.commentInputWrapperClass#">
									<input id="txtName" name="name" type="text" class="#this.commentInputClass#" maxlength="50" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('comments.namerequired'))#" value="#HTMLEditFormat(request.name)#">
								</div>
							</div>

						<!--- Email --->
							<div class="req #this.commentFieldWrapperClass#">
								<label class="#this.commentFieldLabelClass#" for="txtEmail">#variables.$.rbKey('comments.email')#<ins> (#variables.$.rbKey('comments.required')#)</ins></label>
								<div class="#this.commentInputWrapperClass#">
									<input id="txtEmail" name="email" type="text" class="#this.commentInputClass#" maxlength="50" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('comments.emailvalidate'))#" value="#HTMLEditFormat(request.email)#">
								</div>
							</div>

							<!--- URL --->
							<div class="#this.commentFieldWrapperClass#">
								<label for="txtUrl" class="#this.commentFieldLabelClass#">#variables.$.rbKey('comments.url')#</label>
								<div class="#this.commentInputWrapperClass#">
									<input id="txtUrl" name="url" type="text" class="#this.commentInputClass#" maxlength="50" value="#HTMLEditFormat(request.url)#">
								</div>
							</div>

							<!--- Comment --->
							<div class="req #this.commentFieldWrapperClass#">
								<label for="txtComment" class="#this.commentFieldLabelClass#">#variables.$.rbKey('comments.comment')#<ins> (#variables.$.rbKey('comments.required')#)</ins></label>
								<div class="#this.commentInputWrapperClass#">
									<textarea rows="5" id="txtComment" class="#this.commentInputClass#" name="comments" data-message="#htmlEditFormat(variables.$.rbKey('comments.commentrequired'))#" data-required="true">#HTMLEditFormat(request.comments)#</textarea>
								</div>
							</div>

							<!--- Remember --->
							<div class="#this.commentFieldWrapperClass#">
								<div class="#this.commentPrefsInputWrapperClass#">
									<div class="#this.commentCheckboxClass#">
										<label for="txtRemember">
											<input type="checkbox" id="txtRemember" name="remember" value="1"<cfif isBoolean(cookie.remember) and cookie.remember> checked="checked"</cfif>> #variables.$.rbKey('comments.rememberinfo')#
										</label>
									</div>
								</div>
							</div>

							<!--- Subscribe --->
							<div class="#this.commentFieldWrapperClass#">
								<div class="#this.commentPrefsInputWrapperClass#">
									<div class="#this.commentCheckboxClass#">
										<label for="txtSubscribe">
											<input type="checkbox" id="txtSubscribe" name="subscribe" value="1"<cfif isBoolean(cookie.subscribe) and cookie.subscribe> checked="checked"</cfif>> #variables.$.rbKey('comments.subscribe')#
										</label>
									</div>
								</div>
							</div>

					</fieldset>

					<div class="#this.commentRequiredWrapperClass#">
						<p class="required">#variables.$.rbKey('comments.requiredfield')#</p>	
					</div>

					<!--- Form Protect --->
					<div class="#this.commentFieldWrapperClass#">
						#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#
					</div>
					
					<!--- SUBMIT BUTTON --->
					<div class="#this.commentFieldWrapperClass#">
						<div class="#this.commentSubmitButtonWrapperClass#">
							<input type="hidden" name="returnURL" value="#HTMLEditFormat(variables.$.getCurrentURL())#">
							<input type="hidden" name="commentid" value="#createuuid()#">
							<input type="hidden" name="parentid" value="">
							<input type="hidden" name="commenteditmode" value="add">
							<input type="hidden" name="linkServID" value="#variables.$.content('contentID')#">
							<button type="submit" class="btn btn-default">#htmlEditFormat(variables.$.rbKey('comments.submit'))#</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</cfoutput>
</cfif>