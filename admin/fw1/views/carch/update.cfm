<cfset request.layout=false>
<cfif arguments.rc.action eq 'multiFileUpload'>
<cfoutput>{success:true}</cfoutput>
<cfelse>
<cfoutput>#doFBInclude("/muraWRM/admin/view/vArchitecture/dsp_close_compact_display.cfm")#</cfoutput>
</cfif>