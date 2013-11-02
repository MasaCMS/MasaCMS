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
<cfsilent>
	<cfset request.rsSubCommentsLevel = request['rsSubComments#variables.level#'] />
	<cfparam name="arguments.currentrow" default="1">
	<cfset variables.avatar = "">
	<cfset variables.comment = variables.$.getBean('comment').set(variables.$.getBean('utility').queryRowToStruct(request.rsSubCommentsLevel, arguments.currentrow))>
	<cfset variables.commenter = variables.comment.getCommenter()> 
	<cfif isValid("UUID", variables.commenter.getRemoteID())>
		<cfset variables.user = variables.$.getBean('user').loadBy(userID=variables.commenter.getRemoteID())>
		<cfif not variables.user.getIsNew() and len(variables.user.getPhotoFileID())>
			<cfset variables.avatar = variables.$.createHREFForImage(variables.user.getSiteID(), variables.user.getPhotoFileID(),'jpg', 'medium')>
		</cfif>
	</cfif>
</cfsilent>
<cfoutput>
	<dl class="#variables.class#" id="comment-#variables.comment.getCommentID()#">
		<dt>
			<cfif variables.commenter.getURL() neq ''>
				<a href="#variables.commenter.getURL()#" target="_blank">#htmleditformat(variables.commenter.getName())#</a>
			<cfelse>
				#htmleditformat(variables.commenter.getName())#
			</cfif>
			<cfif request.isEditor and variables.commenter.getEmail() neq ''>
				<a class="btn btn-default" href="javascript:noSpam('#listFirst(htmlEditFormat(variables.commenter.getEmail()),'@')#','#listlast(HTMLEditFormat(variables.commenter.getEmail()),'@')#')" onfocus="this.blur();">#variables.$.rbKey('comments.email')#</a>
			</cfif>
			<cfif request.isEditor>
				<cfif yesnoformat(application.configBean.getValue("editablecomments"))>
					 <a class="editcomment btn btn-default" data-id="#variables.comment.getCommentID()#">#variables.$.rbKey('comments.edit')#</a>
				</cfif>
				<cfif variables.comment.getIsApproved() neq 1>
					 <a class="btn btn-default" href="./?approvedcommentid=#variables.comment.getCommentID()#&amp;nocache=1&amp;linkServID=#variables.$.content('contentID')#" onClick="return confirm('Approve Comment?');">#variables.$.rbKey('comments.approve')#</a>
				</cfif>
				 <a class="btn btn-default" href="./?deletecommentid=#variables.comment.getCommentID()#&amp;nocache=1&amp;linkServID=#variables.$.content('contentID')#" onClick="return confirm('Delete Comment?');">#variables.$.rbKey('comments.delete')#</a>		
			</cfif>
		</dt>
		
		
		<cfif len(variables.avatar)>
			<dd class="gravatar"><img src="#variables.avatar#"></dd>
		<cfelse>
			<dd class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(variables.commenter.getEmail())))#" /></dd>
		</cfif>
		<dd class="comment">
			#setParagraphs(htmleditformat(variables.comment.getComments()))#
		</dd>
		<dd class="dateTime">
			#LSDateFormat(variables.comment.getEntered(),"long")#, #LSTimeFormat(variables.comment.getEntered(),"short")#
		</dd>
		<dd class="reply"><a data-id="#variables.comment.getCommentID()#" href="##postcomment">#variables.$.rbKey('comments.reply')#</a></dd>
		<dd id="postcomment-#variables.comment.getCommentID()#"></dd>
	</dl>
</cfoutput>