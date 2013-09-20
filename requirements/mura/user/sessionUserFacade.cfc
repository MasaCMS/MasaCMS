<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.userBean="">

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var theValue="">
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>

	<!--- forward normal getters to the default getValue method --->
	<cfif listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>	
		<cfif prefix eq "get">
			<cfreturn getValue(prop)>
		<cfelseif prefix eq "set" and not structIsEmpty(MissingMethodArguments)>
			<cfset setValue(prop,MissingMethodArguments[1])>	
			<cfreturn this>
		</cfif>
	</cfif>
	
	<!--- otherwise get the bean and if the method exsists forward request --->
	<cfset bean=getUserBean()>
	
	<cfif not structIsEmpty(MissingMethodArguments)>
		<cfinvoke component="#bean#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="theValue">
	<cfelse>
		<cfinvoke component="#bean#" method="#MissingMethodName#" returnvariable="theValue">
	</cfif>
		
	<cfif isDefined("theValue")>
		<cfreturn theValue>
	<cfelse>
		<cfreturn "">
	</cfif>

<cfelse>
	<cfreturn "">
</cfif>

</cffunction>
		
<cffunction name="init" access="public" returntype="any" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="property">	
	<cfset var theValue="">
	<cfif isDefined('get#arguments.property#')>
		<cfset var tempFunc=this["get#arguments.property#"]>
        <cfreturn tempFunc()>
	<cfelseif not structKeyExists(session.mura,arguments.property)>
		<cfset theValue=getUserBean().getValue(arguments.property)>
		<cfif isSimpleValue(theValue)>
			<cfset session.mura[arguments.property]=theValue>
		</cfif>
		<cfreturn theValue>
	<cfelse>
		<cfreturn session.mura[arguments.property]>
	</cfif>	
</cffunction>

<cffunction name="setValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfargument name="propertyValue">	
	<cfset session.mura[arguments.property]=arguments.propertyValue>
	<cfset getUserBean().setValue(arguments.property, arguments.propertyValue)>
	<cfreturn this>
</cffunction>

<cffunction name="getUserBean" access="public" returntype="any" output="false">
	<cfif isObject(variables.userBean) >
		<cfreturn variables.userBean>
	<cfelse>
		<cfset variables.userBean=application.userManager.read(session.mura.userID)>
		<cfif variables.userBean.getIsNew()>
			<cfset variables.userBean.setSiteID(getValue('siteID'))>
		</cfif>
	</cfif>
	<cfreturn variables.userBean>
</cffunction>

<cffunction name="getFullName" access="public" returntype="any" output="false">
	<cfif hasSession()>
		<cfreturn trim("#session.mura.fname# #session.mura.lname#")>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="isInGroup" access="public" returntype="boolean" output="false">
	<cfargument name="group">
	<cfargument name="isPublic" hint="optional">
	<cfset var siteid=session.mura.siteID>
	<cfset var publicPool="">
	<cfset var privatePool="">
	
	<cfif hasSession()>
		<cfset siteid=session.mura.siteID>
		<cfif structKeyExists(request,"siteid")>
			<cfset siteID=request.siteID>
		</cfif>
		
		<cfset publicPool=application.settingsManager.getSite(siteid).getPublicUserPoolID()>
		<cfset privatePool=application.settingsManager.getSite(siteid).getPrivateUserPoolID()>
		
		<cfif session.mura.isLoggedIn and len(siteID)>
			<cfif structKeyExists(arguments,"isPublic")>
				<cfif arguments.isPublic>
					<cfreturn application.permUtility.isUserInGroup(arguments.group,publicPool,1)>
				<cfelse>
					<cfreturn application.permUtility.isUserInGroup(arguments.group,privatePool,0)>
				</cfif>
			<cfelse>
				<cfreturn application.permUtility.isUserInGroup(arguments.group,publicPool,1) or application.permUtility.isUserInGroup(arguments.group,privatePool,0)>
			</cfif>
		<cfelse>
			<cfreturn false>
		</cfif>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isPrivateUser" access="public" returntype="boolean" output="false">
	<cfset var siteid=session.mura.siteID>
	
	<cfif hasSession()>
		<cfset siteid=session.mura.siteID>
		
		<cfif structKeyExists(request,"siteid")>
			<cfset siteID=request.siteID>
		</cfif>
	
		<cfreturn application.permUtility.isS2() or application.permUtility.isPrivateUser(siteid)>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isSuperUser" access="public" returntype="boolean" output="false">
	<cfif hasSession()>
		<cfreturn application.permUtility.isS2() />
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isAdminUser" access="public" returntype="boolean" output="false">
	<cfif hasSession()>
		<cfreturn isInGroup('Admin',0) />
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">	
	<cfif hasSession()>
		<cfreturn session.mura.isLoggedIn>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isPassedLockdown" access="public" returntype="boolean" output="false">	
	<cfif not structKeyExists(cookie, "passedLockdown")>
		<cfcookie name="passedLockdown" value="false" expires="never">
	</cfif>
	<cfreturn cookie.passedLockdown>
</cffunction>

<cffunction name="hasSession" output="false" returntype="boolean">
	<cfreturn isDefined("session.mura")>
</cffunction>

<cffunction name="logout" access="public" returntype="any" output="false">
	
	<cfset getBean('loginManager').logout()>
	<cfreturn this>
</cffunction>
</cfcomponent>