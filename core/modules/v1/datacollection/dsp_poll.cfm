<cfquery name="variables.rsTotal" datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#">
select count(pollValue) as qty from tformresponsequestions where FormID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.event('formBean').getValue('contentID')#"/> and pollValue is not null
</cfquery>

<div id="dsp_response" class="dataCollection">
<ul class="pollResults">
<cfloop list="#request.polllist#" index="variables.i">
<cfsilent>
	<cfquery name="variables.rsSubTotal" datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#">
		SELECT tformresponsequestions.pollValue, Count(tformresponsequestions.pollValue) AS qty
		FROM tformresponsequestions
		GROUP BY tformresponsequestions.pollValue, tformresponsequestions.formID
		HAVING tformresponsequestions.formID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.event('formBean').getValue('contentID')#"/>
		and tformresponsequestions.pollValue=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.I#"/>
		ORDER BY Count(tformresponsequestions.pollValue)
	</cfquery>

	<cfif variables.rsSubTotal.qty eq ''>
		<cfset variables.lineQty=0>
	<cfelse>
		<cfset variables.lineQty=rsSubtotal.qty>
	</cfif>

	<cfif isNumeric(variables.rstotal.qty) and variables.rstotal.qty>
		<cfset variables.percent=round((variables.lineQty/variables.rstotal.qty)*100)>
	<cfelse>
		<cfset variables.percent=0>
	</cfif>
</cfsilent>
<cfoutput><li><span class="pollValue">#i#:</span> <span class="pollQty">#variables.lineQty#</span> <span class="pollPercent">(#variables.percent#%)</span><div style="margin: 2px 0 0 0; height: 10px; width: #variables.percent#%; background: ##8C9EB4; font-size: 9px;">&nbsp;</div></li></cfoutput>
</cfloop>
</ul>
</div>
