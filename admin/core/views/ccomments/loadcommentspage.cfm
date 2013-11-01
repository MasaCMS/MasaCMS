<cfset request.layout=false>
<cfoutput>
	<!--- MOAR --->
	<cfif rc.it.getPageIndex() lt rc.it.pageCount()>
		<div id="moreCommentsContainer"><a id="moreComments" class="btn btn-default" href="##" data-pageno="#rc.it.getPageIndex()+1#">More Comments</a></div>
	</cfif>

	<cfloop from="#rc.p.startPage#" to="#rc.p.endPage#" index="rc.i">
		<cfset rc.it.setPage(rc.p.pageNo)>	
		<cfloop condition="#rc.it.hasNext()#">
			<cfset rc.comment = rc.it.next()>				
			<dl id="detail-#rc.comment.getCommentID()#">
				<dt>
					#htmleditformat(rc.comment.getName())#
				</dt>
				<cfif len(rc.comment.getUser().getPhotoFileID())>
					<dd class="gravatar"><img src="#rc.$.createHREFForImage(rc.comment.getUser().getSiteID(),rc.comment.getUser().getPhotoFileID(),'jpg', 'medium')#"></dd>
				<cfelse>
					<dd class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.comment.getEmail())))#" /></dd>
				</cfif>
				<cfif len(rc.comment.getParentID())>
					<dd class="inReplyTo">
						<em>In reply to: <a href="##" class="inReplyTo" data-parentid="#rc.comment.getParentID()#">#rc.comment.getParent().getName()#</a></em>
					</dd>
				</cfif>
				<dd class="comment">
					#rc.$.setParagraphs(htmleditformat(rc.comment.getComments()))#
				</dd>
				<dd class="dateTime">
					#LSDateFormat(rc.comment.getEntered(),"long")#, #LSTimeFormat(rc.comment.getEntered(),"short")#
				</dd>
			</dl>
		</cfloop>
		<cfset rc.p.pageNo++>
	</cfloop>

	<!--- MOAR --->
	<cfif rc.it.getPageIndex() lt rc.it.pageCount()>
		<div id="moreCommentsContainer"><a id="moreComments" class="btn btn-default" href="##" data-pageno="#rc.it.getPageIndex()+1#">More Comments</a></div>
	</cfif>

</cfoutput>