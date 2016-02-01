<cfset request.layout=false>
<cfoutput>
	<div id="commentsPage">
		<!--- MOAR --->
		<cfif rc.p.startRow gt 1 and (len(rc.commentID) or len(rc.upperID))>
			<div id="moreCommentsUpContainer"><a id="moreCommentsUp" class="btn btn-small" href="##" data-upperid="#rc.q.commentID[rc.p.startRow-1]#"><i class="icon-arrow-up"></i> More Comments</a></div>
		</cfif>

		<cfloop query="rc.q" startrow="#rc.p.startRow#" endrow="#rc.p.endRow#">
			<cfset rc.comment = rc.$.getBean('comment').set(rc.$.getBean('utility').queryRowToStruct(rc.q, rc.q.currentrow))>
			<cfset rc.commenter = rc.comment.getCommenter()>
			<!--- set avatar from Mura's user bean --->
			<cfset rc.avatar = "">
			<cfif isValid("UUID", rc.commenter.getRemoteID())>
				<cfset rc.user = $.getBean('user').loadBy(userID=rc.commenter.getRemoteID())>
				<cfif not rc.user.getIsNew() and len(rc.user.getPhotoFileID())>
					<cfset rc.avatar = $.createHREFForImage(rc.user.getSiteID(), rc.user.getPhotoFileID(), 'jpg', 'medium')>
				</cfif>
			</cfif>
			<dl id="detail-#rc.comment.getCommentID()#">
				<cfif len(rc.avatar)>
					<dd class="gravatar"><img src="#rc.avatar#"></dd>
				<cfelse>
					<dd class="gravatar"><img src="#application.settingsManager.getSite(rc.siteid).getScheme()#://www.gravatar.com/avatar/#lcase(Hash(lcase(esapiEncode('html_attr',rc.comment.getEmail()))))#" /></dd>
				</cfif>
				<dt>
					#esapiEncode('html',rc.comment.getName())#
					<cfif len(rc.comment.getParentID())>
						<em>(in reply to: <a href="##" class="inReplyTo" data-parentid="#rc.comment.getParentID()#" data-contentid="#rc.comment.getContentID()#">#esapiEncode('html',rc.comment.getParent().getName())#</a>)</em>
					</cfif>
				</dt>
				<dd class="comment">
					#rc.$.setParagraphs(esapiEncode('html',rc.comment.getComments()))#
				</dd>
				<dd class="date-time">
					#LSDateFormat(rc.comment.getEntered(),"long")#, #LSTimeFormat(rc.comment.getEntered(),"short")#
				</dd>
			</dl>
		</cfloop>

		<!--- MOAR --->
		<cfif rc.p.endRow lt rc.q.recordCount and (len(rc.commentID) or len(rc.lowerID))>
			<div id="moreCommentsDownContainer"><a id="moreCommentsDown" class="btn btn-small" href="##" data-lowerid="#rc.q.commentID[rc.p.endRow+1]#"><i class="icon-arrow-down"></i> More Comments</a></div>
		</cfif>
	</div>
</cfoutput>