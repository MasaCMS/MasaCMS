<circuit access="public">

<prefuseaction>

<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.keywords" value="" overwrite="false" />
<set name="attributes.limit" value="10" overwrite="false" />
<set name="attributes.threshold" value="1" overwrite="false" />
<set name="attributes.siteID" value="" overwrite="false" />
<set name="session.startDate" value="#now()#" overwrite="false" />
<set name="session.stopDate" value="#now()#" overwrite="false" />
<set name="attributes.membersOnly" value="false" overwrite="false" />
<set name="attributes.visitorStatus" value="All" overwrite="false" />
<set name="attributes.contentID" value="" overwrite="false" />
<set name="attributes.direction" value="" overwrite="false" />
<set name="attributes.orderby" value="" overwrite="false" />
<set name="attributes.page" value="1" overwrite="false" />
<set name="attributes.span" value="#session.dashboardSpan#" overwrite="false" />
<set name="attributes.spanType" value="d" overwrite="false" />
<set name="attributes.startDate" value="#dateAdd('#attributes.spanType#',-attributes.span,now())#" overwrite="false" />
<set name="attributes.stopDate" value="#now()#" overwrite="false" />
<set name="attributes.newSearch" value="false" overwrite="false" />
<set name="attributes.startSearch" value="false" overwrite="false" />
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#')">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>

<if condition="not LSisDate(attributes.startDate) and not LSisDate(session.startDate)">
	<true>
		<set name="session.startDate" value="#now()#" overwrite="true" />
	</true>
</if>
<if condition="not LSisDate(attributes.stopDate) and not LSisDate(session.stopDate)">
	<true>
		<set name="session.stopDate" value="#now()#" overwrite="true" />
	</true>
</if>
<if condition="attributes.startSearch and LSisDate(attributes.startDate)">
	<true>
		<set name="session.startDate" value="#attributes.startDate#" overwrite="true" />
	</true>
</if>
<if condition="attributes.startSearch and LSisDate(attributes.stopDate)">
	<true>
		<set name="session.stopDate" value="#attributes.stopDate#" overwrite="true" />
	</true>
</if>
<if condition="attributes.newSearch">
	<true>
		<set name="session.startDate" value="#now()#" overwrite="true" />
		<set name="session.stopDate" value="#now()#" overwrite="true" />
	</true>
</if>

</prefuseaction>

<fuseaction name="main">
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.main" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="topReferers">
<do action="vDashboard.topReferers" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="topRated">
<do action="vDashboard.topRated" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="topSearches">
<do action="vDashboard.topSearches" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="topContent">
<do action="vDashboard.topContent" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="listSessions">
<invoke object="application.dashboardManager" methodcall="getSiteSessions(attributes.siteid,attributes.contentid,attributes.membersOnly,attributes.visitorStatus,attributes.span,attributes.spanType)" returnVariable="request.rsList" />
<do action="vDashboard.listSessions" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="viewSession">
<invoke object="application.dashboardManager" methodcall="getSessionHistory(attributes.urlToken,attributes.siteID)" returnVariable="request.rslist" />
<do action="vDashboard.viewSession" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="sessionSearch">
<invoke object="application.userManager" methodcall="getPublicGroups('#attributes.siteid#',1)" returnVariable="request.rsGroups" />
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.sessionSearch" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="loadPopularContent">
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.loadPopularContent" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadUserActivity">
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.loadUserActivity" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadFormActivity">
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.loadFormActivity" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadEmailActivity">
<do action="vDashboard.ajax" contentvariable="fusebox.ajax"/>
<do action="vDashboard.loadEmailActivity" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

</circuit>