<cfset rc.ajax=doFBInclude("/muraWRM/admin/view/vFeed/ajax/dsp_javascript.cfm")>
<cfif rc.type eq 'Local'>
<cfset rc.layout=doFBInclude("/muraWRM/admin/view/vFeed/dsp_form_local.cfm")>
<cfelse>
<cfset rc.layout=doFBInclude("/muraWRM/admin/view/vFeed/dsp_form_remote.cfm")>
</cfif>