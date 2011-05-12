<cfset request.layout=false>
<cfif isDefined("url.qqfile")>
<cfoutput>{success:true}</cfoutput>
<cfabort>
<cfelseif rc.action eq 'multiFileUpload'>
<cfoutput>success</cfoutput>
<cfabort>
<cfelse>
<cfoutput>#doFBInclude("/muraWRM/admin/view/vArchitecture/dsp_close_compact_display.cfm")#</cfoutput>
</cfif>
