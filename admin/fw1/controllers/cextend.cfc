<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not listFind(session.mura.memberships,'S2')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfset application.classExtensionManager=variables.configBean.getClassExtensionManager()>
	
	<cfparam name="arguments.rc.subTypeID" default="" />
	<cfparam name="arguments.rc.extendSetID" default="" />
	<cfparam name="arguments.rc.attibuteID" default="" />
	<cfparam name="arguments.rc.siteID" default="" />
</cffunction>

<cffunction name="updateSubType" output="false">
	<cfargument name="rc">
	
	 <cfset arguments.rc.subtypeBean=application.classExtensionManager.getSubTypeByID(arguments.rc.subTypeID) />
	  <cfset arguments.rc.subtypeBean.set(arguments.rc) />
	  
	  <cfif arguments.rc.action eq 'Update'>
	  		<cfset arguments.rc.subtypeBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  		<cfset arguments.rc.subtypeBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  		<cfset arguments.rc.subtypeBean.save() />
	  </cfif> 
	
	  <cfif arguments.rc.action neq 'delete'>
		  <cfset arguments.rc.subTypeID=rc.subtypeBean.getSubTypeID()>
		  <cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeID,siteid",path="")>
	  <cfelse>
	  	  <cfset variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="")>
	  </cfif>
	  
</cffunction>

<cffunction name="updateSet" output="false">
	<cfargument name="rc">
	 <cfset arguments.rc.extendSetBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean() />
	 <cfset arguments.rc.extendSetBean.set(arguments.rc) />
	  
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset arguments.rc.extendSetBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.extendSetBean.save() />
	  </cfif> 
	
	  <cfif arguments.rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="")>
	  </cfif>
</cffunction>	  	

<cffunction name="updateAttribute" output="false">
	<cfargument name="rc">
	  <cfset arguments.rc.attributeBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean().getattributeBean() />
	  <cfset arguments.rc.attributeBean.set(arguments.rc) />

	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.attributeBean.save() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset arguments.rc.attributeBean.delete() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.attributeBean.save() />
	  </cfif> 
	  
	 <cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
</cffunction>

<cffunction name="saveAttributeSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveAttributeSort(arguments.rc.attributeID) />
	<cfabort>
</cffunction>

<cffunction name="saveExtendSetSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveExtendSetSort(arguments.rc.extendSetID) />
	<cfabort>
</cffunction>
</cfcomponent>