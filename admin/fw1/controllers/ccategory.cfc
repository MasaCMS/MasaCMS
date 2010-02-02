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
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not ( variables.permUtility.getModulePerm('00000000000000000000000000000000010',rc.siteid) and variables.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid))>
		<cfset secure(rc)>
	</cfif>
	<cfparam name="rc.startrow" default="1"/>
	<cfparam name="rc.keywords" default=""/>
</cffunction>

<cffunction name="edit" output="false">
<cfargument name="rc">
<cfset rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(rc.siteid) />
<cfset rc.categoryBean=variables.categoryManager.read(rc.categoryID) />
</cffunction>

<cffunction name="update" output="false">
<cfargument name="rc">
	 <cfswitch expression="#rc.action#">
		  <cfcase value="update">
		  	<cfset rc.categoryBean=variables.categoryManager.update(rc) />
		  </cfcase>
	  
		 <cfcase value="delete">
		  	<cfset variables.categoryManager.delete(rc.categoryid) />
		  </cfcase>
	  
		  <cfcase value="add">
		  	<cfset rc.categoryBean=variables.categoryManager.create(rc) />
		  	<cfif structIsEmpty(rc.categoryBean.getErrors())>
		  		<cfset rc.categoryID=rc.categoryBean.getCategoryID()>
		  	</cfif>
		  </cfcase>
	 </cfswitch>
	 
	  <cfif not (rc.action neq 'delete' and not structIsEmpty(rc.categoryBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cCategory.list",append="siteid",path="")>
	  </cfif>
</cffunction>

</cfcomponent>