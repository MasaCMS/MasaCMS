<cfif rc.action neq  'delete' and not structIsEmpty(rc.feedBean.getErrors())>
<cfinclude template="edit.cfm">
<cfelse>
<cfset request.layout=false>
<cfoutput>#doFBInclude("/muraWRM/admin/view/vFeed/dsp_close_compact_display.cfm")#</cfoutput>
</cfif>