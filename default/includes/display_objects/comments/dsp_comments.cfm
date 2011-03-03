<cfsilent>
<cfparam name="request.parentcommentid" default="" />
<cfquery name="request.rsSubComments#level#" dbtype="query">
	SELECT
		*
	FROM
		rsComments
	WHERE
	<cfif len(request.parentcommentid)>
		parentID = <cfqueryparam value="#request.parentcommentid#" cfsqltype="cf_sql_varchar" maxlength="35">
	<cfelse>
		parentID IS NULL
	</cfif>
</cfquery>
</cfsilent>

<cfif request['rsSubComments#level#'].recordcount>
	<cfoutput query="request.rsSubComments#level#"  startrow="#request.startrow#">
		<cfset request.parentcommentid = request['rsSubComments#level#'].commentid />
		<cfset class=iif(request['rsSubComments#level#'].currentrow eq 1,de('first'),de(iif(request['rsSubComments#level#'].currentrow eq request['rsSubComments#level#'].recordcount,de('last'),de('')))) />
		<cfif level>
			<cfset class = class & iif(level lt 10,de(" indent-#level#"),de(" indent-10")) />
		</cfif>
		#dspObject_Include(thefile='comments/dsp_comment.cfm')#
		<cfif request['rsSubComments#level#'].kids neq ''>
			<cfset level = level+1 />
			#dspObject_Include(thefile='comments/dsp_comments.cfm')#
			<cfset level = level-1 />
		</cfif>
	</cfoutput>
</cfif>
