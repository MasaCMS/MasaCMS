<cfcomponent extends="controller" output="false">

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfparam name="rc.Type" default="0" />
	<cfparam name="rc.ContactForm" default="0" />
	<cfparam name="rc.isPublic" default="0" />
	<cfparam name="rc.email" default="" />
	<cfparam name="rc.jobtitle" default="" />
	<cfparam name="rc.lastupdate" default="" />
	<cfparam name="rc.lastupdateby" default="" />
	<cfparam name="rc.lastupdatebyid" default="0" />
	<cfparam name="rsGrouplist.recordcount" default="0" />
	<cfparam name="rc.groupname" default="" />
	<cfparam name="rc.fname" default="" />
	<cfparam name="rc.lname" default="" />
	<cfparam name="rc.address" default="" />
	<cfparam name="rc.city" default="" />
	<cfparam name="rc.state" default="" />
	<cfparam name="rc.zip" default="" />
	<cfparam name="rc.phone1" default="" />
	<cfparam name="rc.phone2" default="" />
	<cfparam name="rc.fax" default="" />
	<cfparam name="rc.perm" default="0" />
	<cfparam name="rc.groupid" default="" />
	<cfparam name="rc.routeid" default="" />
	<cfparam name="rc.InActive" default="0" />
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.categoryID" default="" />
	<cfparam name="rc.routeID" default="" />
	<cfparam name="rc.error" default="#structnew()#" />
	
	<cfif not session.mura.isLoggedIn>
		<cfset secure(rc)>
	</cfif>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
	<cfif not isdefined('rc.userBean')>
		<cfset rc.userBean=variables.userManager.read(session.mura.userID)>
	</cfif>
</cffunction>

<cffunction name="update" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.update(rc,false)>
	
	<cfif structIsEmpty(rc.userBean.getErrors())>
		 <cfset variables.fw.redirect(action="home.redirect",path="")>
	</cfif>
</cffunction>

</cfcomponent>