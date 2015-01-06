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
<cfcomponent extends="mura.cfobject">

	<cffunction name="get" access="remote" output="true">
		<cfargument name="commentID">
		<cfargument name="siteid" default="#application.contentServer.bindToDomain()#" />
		<cfset var $ = getBean("MuraScope").init(arguments.siteid)>
		<cfset var comment = $.getBean("contentManager").getCommentBean()>
		<cfset var data = comment.setCommentID(arguments.commentID).load().getAllValues()>
		<cfoutput>#createobject("component","mura.json").encode(data)#</cfoutput>
	</cffunction>

	<cffunction name="flag" access="remote" output="true">
		<cfargument name="commentID">
		<cfargument name="siteid" default="#application.contentServer.bindToDomain()#" />
		<cfset var $ = getBean("MuraScope").init(arguments.siteid)>
		<cfset var comment = $.getBean("contentManager").getCommentBean()>
		<cfset comment.setCommentID(arguments.commentID).load().flag()>
	</cffunction>

	<cffunction name="getContentStats" access="remote" output="true">
		<cfargument name="contentID">
		<cfargument name="siteid" default="#application.contentServer.bindToDomain()#" />
		<cfset var $ = getBean("MuraScope").init(arguments.siteid)>
		<cfset var contentStats = $.getBean('content').loadBy(contentID=arguments.contentID).getStats()>
		
		<cfcontent type="application/json" reset="true"><cfscript>writeOutput(new mura.json().jsonencode(contentStats.getAllValues()));</cfscript>
	</cffunction>

	<cffunction name="renderCommentsPage" access="remote" output="true">
		<cfargument name="contentID">
		<cfargument name="pageNo" data-required="true" default="1">
		<cfargument name="nextN" data-required="true" default="3">
		<cfargument name="sortDirection" data-required="true" default="desc">
		<cfargument name="commentID" data-required="true" default="">
		<cfargument name="siteid" default="#application.contentServer.bindToDomain()#" />
		<cfset var $ = getBean("MuraScope").init(arguments.siteid)>
		<cfset var renderer = $.getContentRenderer()>
		<cfset var content = $.getBean('content').loadBy(contentID=arguments.contentID)>
		<cfset var crumbArray = content.getCrumbArray()>
		<cfset var isEditor=isDefined('session.mura.memberships') and (listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite($.event('siteID')).getPrivateUserPoolID()#')
				and application.permUtility.getnodePerm(crumbArray) neq 'none')
				or listFind(session.mura.memberships,'S2')
				or application.permUtility.getModulePerm("00000000000000000000000000000000015", $.event('siteID'))>
		<cfset var sort = listFindNoCase('asc,desc', arguments.sortDirection) ? arguments.sortDirection : 'asc'>
		<cfset var commentArgs={contentID=content.getContentID(),
						siteID=$.event('siteID'),
						isspam=0,
						isdeleted=0,
						sortDirection=sort}>
		<cfif not isEditor>
			<cfset commentArgs.isApproved=1>
		</cfif>
		<cfset var it = $.getBean('contentCommentManager').getCommentsIterator(argumentCollection=commentArgs)>
		<cfset var q = it.getQuery()>
		<cfset var comment = "">
		<cfset var local = structNew()>
		<cfset var i = "">
		<cfset var commenter = "">
		<cfset var remoteID = "">
		<cfset var user = "">
		<cfset var avatar = "">
		<cfset var returnStruct = structNew()>
		<cfset returnStruct.count = q.recordcount>
		
		<cfscript>
			// Pagination Setup
			local.nextn = Val(arguments.nextn);
			local.pageno = Val(arguments.pageno);
			local.commentPos = 0;
			local.continue = true;
			local.x = 1;
			
			// set defaults
			if ( local.nextn < 1 ) { 
				local.nextn = 20; 
			}
			it.setNextN(local.nextn);
			
			if ( local.pageno < 1 || local.pageno > it.pageCount() ) {
				local.pageno = 1;
			}
			it.setPage(local.pageno);
			
			local.startPage = local.pageNo;
			local.endPage = local.pageNo;
						
			if ( len(arguments.commentID) ) {
				for(local.x = 1; x <= q.recordcount && local.continue; local.x++){
					if (q['commentID'][local.x] == arguments.commentID) {
						local.commentPos = local.x;
						local.continue = false;
					}
				}
				
				local.endPage = Ceiling(local.commentPos / local.nextN);
			}
		</cfscript>

		<cfsavecontent variable="returnStruct.htmloutput">
			<cfoutput>
				<cfloop from="#local.startPage#" to="#local.endPage#" index="i">
					<cfset it.setPage(local.pageNo)>	
					<cfloop condition="#it.hasNext()#">
						<cfset comment = it.next()>				
						<cfset commenter = comment.getCommenter()>
						<!--- set avatar from Mura's user bean --->
						<cfset avatar = "">
						<cfif isValid("UUID", commenter.getRemoteID())>
							<cfset user = $.getBean('user').loadBy(userID=commenter.getRemoteID())>
							<cfif not user.getIsNew() and len(user.getPhotoFileID())>
								<cfset avatar = $.createHREFForImage(user.getSiteID(), user.getPhotoFileID(), 'jpg', 'medium')>
							</cfif>
						</cfif>
						<dl id="mura-comment-#comment.getCommentID()#" <cfif comment.getIsApproved() neq 1>class="#renderer.alertDangerClass#"</cfif>>
							<dt>
								<cfset local.commenterName=comment.getName()>

								<cfif not len(local.commenterName) and len(commenter.getName())>
									<cfset local.commenterName=commenter.getName()>
								</cfif>

								<cfset local.commenterURL=comment.getURL()>

								<cfif not len(local.commenterURL) and len(commenter.getURL())>
									<cfset local.commenterURL=commenter.getURL()>
								</cfif>
								
								<cfset local.commenterEmail=comment.getEmail()>

								<cfif  not len(local.commenterEmail) and len(commenter.getEmail())>
									<cfset local.commenterEmail=commenter.getEmail()>
								</cfif>

								<cfif len(local.commenterURL)>
									<a href="#local.commenterURL#" target="_blank">#htmleditformat(local.commenterName)#</a>
								<cfelse>
									#htmleditformat(local.commenterName)#
								</cfif> 
								<cfif len(comment.getParentID())>
									<em>(in reply to: <a href="##" class="mura-in-reply-to" data-parentid="#comment.getParentID()#">#comment.getParent().getName()#</a>)</em>
								</cfif>
								<cfif isEditor>
								<div class="mura-comment-admin-button-wrapper #renderer.commentAdminButtonWrapperClass#">
									<cfif isEditor and len(local.commenterEmail)>
										<a class="mura-comment-user-email #renderer.commentUserEmailClass#" href="javascript:mura.noSpam('#listFirst(htmlEditFormat(local.commenterEmail),'@')#','#listlast(HTMLEditFormat(local.commenterEmail),'@')#')" onfocus="this.blur();">#$.rbKey('comments.email')#</a>
									</cfif>
									<cfif isEditor>
										<cfif yesnoformat(application.configBean.getValue("editablecomments"))>
											 <a class="mura-comment-edit-comment #renderer.commentEditButtonClass#" data-id="#comment.getCommentID()#" data-siteid="#comment.getsiteID()#">#$.rbKey('comments.edit')#</a>
										</cfif>
										<cfif comment.getIsApproved() neq 1>
											 <a class="mura-comment-approve-button #renderer.commentApproveButtonClass#" href="./?approvedcommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()###mura-comment-#comment.getCommentID()#" onClick="return confirm('Approve Comment?');">#$.rbKey('comments.approve')#</a>
										</cfif>
										 <a class="mura-comment-delete-button #renderer.commentDeleteButtonClass#" href="./?deletecommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()###mura-comments-page" onClick="return confirm('Delete Comment?');">#$.rbKey('comments.delete')#</a>
										<!--- <a class="btn btn-default" href="./?spamcommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()#" onClick="return confirm('Mark Comment As Spam?');">Spam</a>	--->	
									</cfif>
								</div>
								</cfif>
							</dt>
							<cfif len(avatar)>
								<dd class="mura-comment-thumb #renderer.commentThumbClass#"><img src="#avatar#"></dd>
							<cfelse>
								<cfset gravatarURL = $.getBean('utility').isHTTPS() ? 'https://secure.gravatar.com' : 'http://www.gravatar.com' />
								<dd class="mura-comment-thumb #renderer.commentThumbClass#"><img src="#gravatarURL#/avatar/#lcase(Hash(lcase(local.commenterEmail)))#" /></dd>
							</cfif>
							<dd class="mura-comment #renderer.commentClass#">
								#$.setParagraphs(htmleditformat(comment.getComments()))#
							</dd>
							<dd class="mura-comment-date-time #renderer.commentDateTimeClass#">
								#LSDateFormat(comment.getEntered(),"long")#, #LSTimeFormat(comment.getEntered(),"short")#
							</dd>
							<dd class="mura-comment-reply #renderer.commentReplyClass#"><a data-id="#comment.getCommentID()#" data-siteid="#comment.getsiteID()#" href="##mura-comment-post-comment">#$.rbKey('comments.reply')#</a></dd>
							<dd class="mura-comment-spam #renderer.commentSpamClass#"><a data-id="#comment.getCommentID()#" data-siteid="#comment.getsiteID()#" class="mura-comment-flag-as-spam #renderer.commentSpamLinkClass#" href="##">Flag as Spam</a></dd>
						</dl>
						<div id="mura-comment-post-comment-#comment.getCommentID()#" class="mura-comment-reply-wrapper #renderer.commentFormWrapperClass#" style="display: none;"></div>
					</cfloop>
					<cfset local.pageNo++>
				</cfloop>

				<!--- MOAR --->
				<cfif it.getPageIndex() lt it.pageCount()>
					<div class="mura-comment-more-comments-container #renderer.commentMoreCommentsContainer#"><a id="mura-more-comments" class="#renderer.commentMoreCommentsDownClass#" href="##" data-pageno="#it.getPageIndex()+1#" data-siteid="#HTMLEditFormat($.event('siteID'))#">More Comments</a></div>
				</cfif>
		
			</cfoutput>
		</cfsavecontent>

		<cfcontent type="application/json; charset=utf-8" reset="true"><cfscript>writeOutput(serializeJSON(returnStruct));</cfscript>
	</cffunction>

</cfcomponent>