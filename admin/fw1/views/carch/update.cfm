<cfset request.layout=false>
<cfif isDefined("url.qqfile")>
<cfoutput>{success:true}</cfoutput>
<cfabort>
<cfelse>
<cfoutput>#doFBInclude("/muraWRM/admin/view/vArchitecture/dsp_close_compact_display.cfm")#</cfoutput>
</cfif>
