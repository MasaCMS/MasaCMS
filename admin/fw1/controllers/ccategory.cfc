<cfcomponent extends="controller" output="false">

<cffunction name="setCategoryManager" output="false">
	<cfargument name="CategoryManager">
	<cfset variables.categoryManager=arguments.categoryManager>
</cffunction>

<cffunction name="setContentUtility" output="false">
	<cfargument name="contentUtility">
	<cfset variables.contentUtility=arguments.contentUtility>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000010',arguments.rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))>
		<cfset secure(arguments.rc)>
	</cfif>
	<cfparam name="arguments.rc.startrow" default="1"/>
	<cfparam name="arguments.rc.keywords" default=""/>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
<cfset arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid) />
<cfset arguments.rc.categoryBean=variables.categoryManager.read(arguments.rc.categoryID) />
</cffunction>

<cffunction name="update" output="false">
<cfargument name="rc">
	 <cfswitch expression="#rc.action#">
		  <cfcase value="update">
		  	<cfset arguments.rc.categoryBean=variables.categoryManager.update(arguments.rc) />
		  </cfcase>
	  
		 <cfcase value="delete">
		  	<cfset variables.categoryManager.delete(arguments.rc.categoryid) />
		  </cfcase>
	  
		  <cfcase value="add">
		  	<cfset arguments.rc.categoryBean=variables.categoryManager.create(arguments.rc) />
		  	<cfif structIsEmpty(arguments.rc.categoryBean.getErrors())>
		  		<cfset arguments.rc.categoryID=rc.categoryBean.getCategoryID()>
		  	</cfif>
		  </cfcase>
	 </cfswitch>
	 
	  <cfif not (arguments.rc.action neq 'delete' and not structIsEmpty(arguments.rc.categoryBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cCategory.list",append="siteid",path="")>
	  </cfif>
</cffunction>

</cfcomponent>