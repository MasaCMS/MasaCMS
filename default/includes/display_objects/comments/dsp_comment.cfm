<cfoutput>
	<dl class="#class#" id="comment-#request['rsSubComments#level#'].commentid#">
		<dt>
			<cfif request['rsSubComments#level#'].url neq ''>
				<a href="#request['rsSubComments#level#'].url#" target="_blank">#htmleditformat(request['rsSubComments#level#'].name)#</a>
			<cfelse>
				#htmleditformat(request['rsSubComments#level#'].name)#
			</cfif>
			<cfif request.isEditor and request['rsSubComments#level#'].email neq ''>
				<a href="javascript:noSpam('#listFirst(htmlEditFormat(request['rsSubComments#level#'].email),'@')#','#listlast(HTMLEditFormat(request['rsSubComments#level#'].email),'@')#')" onfocus="this.blur();">#rbFactory.getKey('comments.email')#</a>
			</cfif>
			<cfif request.isEditor>
				<cfif yesnoformat(application.configBean.getValue("editablecomments"))>
					| <a class="editcomment" data-id="#request['rsSubComments#level#'].commentID#">#rbFactory.getKey('comments.edit')#</a>
				</cfif>
				<cfif request['rsSubComments#level#'].isApproved neq 1>
					| <a href="./?approvedcommentid=#request['rsSubComments#level#'].commentid#&nocache=1&linkServID=#request.contentBean.getContentID()#" onClick="return confirm('Approve Comment?');">#rbFactory.getKey('comments.approve')#</a>
				</cfif>
				| <a href="./?deletecommentid=#request['rsSubComments#level#'].commentid#&nocache=1&linkServID=#request.contentBean.getContentID()#" onClick="return confirm('Delete Comment?');">#rbFactory.getKey('comments.delete')#</a>		
			</cfif>
		</dt>
		<cfif len($.currentUser().getPhotoFileID())>
			<dd class="gravatar"><img src="#$.createHREFForImage($.currentUser().getSiteID(),$.currentUser().getPhotoFileID(),'jpg', 'medium')#"></dd>
		<cfelse>
			<dd class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(request['rsSubComments#level#'].email)))#" /></dd>
		</cfif>
		<dd class="comment">
			#setParagraphs(htmleditformat(request['rsSubComments#level#'].comments))#
		</dd>
		<dd class="dateTime">
			#LSDateFormat(request['rsSubComments#level#'].entered,"long")#, #LSTimeFormat(request['rsSubComments#level#'].entered,"short")#
		</dd>
		<dd class="reply"><a  data-id="#request['rsSubComments#level#'].commentid#" href="##postcomment">#rbFactory.getKey('comments.reply')#</a></dd>
		<dd id="postcomment-#request['rsSubComments#level#'].commentid#"></dd>
	</dl>
</cfoutput>