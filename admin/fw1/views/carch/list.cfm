<cfset rc.ajax=doFBInclude("/muraWRM/admin/view/vArchitecture/ajax/dsp_javascript.cfm")>
<cfswitch expression="#rc.moduleID#">
	<cfcase value="00000000000000000000000000000000003,00000000000000000000000000000000004">
		<cfset rc.layout=doFBInclude("/muraWRM/admin/view/vArchitecture/dsp_flatlist.cfm")>
	</cfcase>
	<cfcase value="00000000000000000000000000000000000">
		<cfset rc.layout=doFBInclude("/muraWRM/admin/view/vArchitecture/dsp_list.cfm")>
	</cfcase>
</cfswitch>

