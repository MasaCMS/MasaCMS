<cfcomponent extends="mura.cfobject">

<cffunction name="get" access="remote" output="true">
	<cfargument name="commentID">
	
	<cfset var $=getBean("MuraScope").init(session.siteid)>
	<cfset var comment=$.getBean("contentManager").getCommentBean()>
	<cfset var data=comment.setCommentID(arguments.commentID).load().getAllValues()>
	
	
	<cfoutput>#createobject("component","mura.json").encode(data)#</cfoutput>
	<cfabort>
</cffunction>

</cfcomponent>