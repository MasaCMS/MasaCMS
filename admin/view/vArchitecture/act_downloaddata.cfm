<cfsilent>

<cfparam name="attributes.columns" default="">

<cfset attributes.fieldnames=application.dataCollectionManager.getCurrentFieldList(attributes.contentid)/>
<cfset rsdata=application.dataCollectionManager.getData(attributes)/>
<cfset DelimChar=",">
<cfset NewLine=chr(13)&chr(10)>

<cffunction name="fixDelim" output="false" returntype="string">
	<cfargument default="" type="String" name="arg">
	<cfreturn '"' & replace(replace(arguments.arg,'"','""',"All"),NewLine," ","All") & '"'>
</cffunction>

</cfsilent>
<cfheader name="Content-Disposition" value="attachment;filename=#rereplace(request.currentBean.gettitle(),' ','-','ALL')#_#LSDateFormat(now(),'mmddyy')#.csv">
<cfheader name="Expires" value="0">
<cfcontent type="application/msexcel" reset="yes"><cfoutput>DATE/TIME ENTERED#DelimChar#<cfloop list="#attributes.fieldnames#" index="c">#c##DelimChar#</cfloop>#NewLine#</cfoutput><cfoutput query="rsData"><cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>#rsdata.entered##DelimChar#<cfloop list="#iif(attributes.columns eq 'fixed',de('#attributes.fieldnames#'),de('#rsdata.fieldList#'))#" index="f"><cftry><cfif findNoCase('attachment',f) and isValid("UUID",info['#f#'])>http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#info['#f#']#<cfelse>#fixDelim(info['#f#'])#</cfif><cfcatch></cfcatch></cftry>#DelimChar#</cfloop>#NewLine#</cfoutput>