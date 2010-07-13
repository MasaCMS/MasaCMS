<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfparam name="arguments.rc.Type" default="0" />
	<cfparam name="arguments.rc.ContactForm" default="0" />
	<cfparam name="arguments.rc.isPublic" default="0" />
	<cfparam name="arguments.rc.email" default="" />
	<cfparam name="arguments.rc.jobtitle" default="" />
	<cfparam name="arguments.rc.lastupdate" default="" />
	<cfparam name="arguments.rc.lastupdateby" default="" />
	<cfparam name="arguments.rc.lastupdatebyid" default="0" />
	<cfparam name="arguments.rc.rsGrouplist.recordcount" default="0" />
	<cfparam name="arguments.rc.groupname" default="" />
	<cfparam name="arguments.rc.fname" default="" />
	<cfparam name="arguments.rc.lname" default="" />
	<cfparam name="arguments.rc.address" default="" />
	<cfparam name="arguments.rc.city" default="" />
	<cfparam name="arguments.rc.state" default="" />
	<cfparam name="arguments.rc.zip" default="" />
	<cfparam name="arguments.rc.phone1" default="" />
	<cfparam name="arguments.rc.phone2" default="" />
	<cfparam name="arguments.rc.fax" default="" />
	<cfparam name="arguments.rc.perm" default="0" />
	<cfparam name="arguments.rc.groupid" default="" />
	<cfparam name="arguments.rc.routeid" default="" />
	<cfparam name="arguments.rc.InActive" default="0" />
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.categoryID" default="" />
	<cfparam name="arguments.rc.routeID" default="" />
	<cfparam name="arguments.rc.error" default="#structnew()#" />
	
	<cfif not session.mura.isLoggedIn>
		<cfset secure(arguments.rc)>
	</cfif>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset arguments.rc.userBean=variables.userManager.read(session.mura.userID)>
	</cfif>
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.update(arguments.rc,false)>
	
	<cfif structIsEmpty(arguments.rc.userBean.getErrors())>
		 <cfset variables.fw.redirect(action="home.redirect",path="")>
	</cfif>
</cffunction>

</cfcomponent>