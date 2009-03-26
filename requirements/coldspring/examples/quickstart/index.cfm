<cfparam name="url.page" default="home" />
<cfinclude template="udfs.cfm" />

<cfswitch expression="#url.page#">
	<cfcase value="home">
		<cfinclude template="pages/home.cfm" />
	</cfcase>
	<cfcase value="intro">
		<cfinclude template="pages/intro.cfm" />
	</cfcase>
	<cfcase value="resources">
		<cfinclude template="pages/resources.cfm" />
	</cfcase>
	<cfcase value="advanced">
		<cfinclude template="pages/advanced.cfm" />
	</cfcase>
	<cfcase value="constructor">
		<cfinclude template="pages/constructor.cfm" />
	</cfcase>
	<cfcase value="beanproperties">
		<cfinclude template="pages/beanproperties.cfm" />
	</cfcase>
	<cfcase value="dynamicproperties">
		<cfinclude template="pages/dynamicproperties.cfm" />
	</cfcase>
	<cfcase value="parentbeans">
		<cfinclude template="pages/parentbeans.cfm" />
	</cfcase>
	<cfcase value="singletons">
		<cfinclude template="pages/singletons.cfm" />
	</cfcase>
	<cfcase value="factory">
		<cfinclude template="pages/factory.cfm" />
	</cfcase>
	<cfcase value="aop">
		<cfinclude template="pages/aop.cfm" />
	</cfcase>
	<cfcase value="remote">
		<cfinclude template="pages/remote.cfm" />
	</cfcase>
	<cfcase value="extensions">
		<cfinclude template="pages/extensions.cfm" />
	</cfcase>
</cfswitch>