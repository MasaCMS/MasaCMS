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
<cfsilent>
	<cfset request.rsSubCommentsLevel = request['rsSubComments#variables.level#'] />
	<cfparam name="arguments.currentrow" default="1">
</cfsilent>
<cfoutput>
	<!--- comment-#request.rsSubCommentsLevel.commentid# cannot change; used by nested comments --->
	<dl class="#variables.class#" id="comment-#request.rsSubCommentsLevel.commentid[arguments.currentrow]#">
		<dt>
			<cfif request.rsSubCommentsLevel.url[arguments.currentrow] neq ''>
				<a href="#request.rsSubCommentsLevel.url[arguments.currentrow]#" target="_blank">#htmleditformat(request.rsSubCommentsLevel.name[arguments.currentrow])#</a>
			<cfelse>
				#htmleditformat(request.rsSubCommentsLevel.name[arguments.currentrow])#
			</cfif>
			<cfif request.isEditor and request.rsSubCommentsLevel.email[arguments.currentrow] neq ''>
				<a href="javascript:noSpam('#listFirst(htmlEditFormat(request.rsSubCommentsLevel.email[arguments.currentrow]),'@')#','#listlast(HTMLEditFormat(request.rsSubCommentsLevel.email[arguments.currentrow]),'@')#')" onfocus="this.blur();">#variables.$.rbKey('comments.email')#</a>
			</cfif>
			<cfif request.isEditor>
				<cfif yesnoformat(application.configBean.getValue("editablecomments"))>
					| <a class="editcomment" data-id="#request.rsSubCommentsLevel.commentID[arguments.currentrow]#">#variables.$.rbKey('comments.edit')#</a>
				</cfif>
				<cfif request.rsSubCommentsLevel.isApproved[arguments.currentrow] neq 1>
					| <a href="./?approvedcommentid=#request.rsSubCommentsLevel.commentid[arguments.currentrow]#&amp;nocache=1&amp;linkServID=#variables.$.content('contentID')#" onClick="return confirm('Approve Comment?');">#variables.$.rbKey('comments.approve')#</a>
				</cfif>
				| <a href="./?deletecommentid=#request.rsSubCommentsLevel.commentid[arguments.currentrow]#&amp;nocache=1&amp;linkServID=#variables.$.content('contentID')#" onClick="return confirm('Delete Comment?');">#variables.$.rbKey('comments.delete')#</a>		
			</cfif>
		</dt>
		<cfif len(variables.$.currentUser().getPhotoFileID())>
			<dd class="gravatar"><img src="#variables.$.createHREFForImage(variables.$.currentUser().getSiteID(),variables.$.currentUser().getPhotoFileID(),'jpg', 'medium')#"></dd>
		<cfelse>
			<dd class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(request.rsSubCommentsLevel.email[arguments.currentrow])))#" /></dd>
		</cfif>
		<dd class="comment">
			#setParagraphs(htmleditformat(request.rsSubCommentsLevel.comments[arguments.currentrow]))#
		</dd>
		<dd class="dateTime">
			#LSDateFormat(request.rsSubCommentsLevel.entered[arguments.currentrow],"long")#, #LSTimeFormat(request.rsSubCommentsLevel.entered[arguments.currentrow],"short")#
		</dd>
		<dd class="reply"><a  data-id="#request.rsSubCommentsLevel.commentid[arguments.currentrow]#" href="##postcomment">#variables.$.rbKey('comments.reply')#</a></dd>
		<dd id="postcomment-#request.rsSubCommentsLevel.commentid[arguments.currentrow]#"></dd>
	</dl>
</cfoutput>