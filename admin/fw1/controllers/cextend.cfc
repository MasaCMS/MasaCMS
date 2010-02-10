<cfcomponent extends="controller" output="false">

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not listFind(session.mura.memberships,'S2')>
		<cfset secure(rc)>
	</cfif>
	
	<cfset application.classExtensionManager=variables.configBean.getClassExtensionManager()>
	
	<cfparam name="rc.subTypeID" default="" />
	<cfparam name="rc.extendSetID" default="" />
	<cfparam name="rc.attibuteID" default="" />
	<cfparam name="rc.siteID" default="" />
</cffunction>

<cffunction name="updateSubType" output="false">
	<cfargument name="rc">
	
	 <cfset rc.subtypeBean=application.classExtensionManager.getSubTypeByID(rc.subTypeID) />
	  <cfset rc.subtypeBean.set(rc) />
	  
	  <cfif rc.action eq 'Update'>
	  		<cfset rc.subtypeBean.save() />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  		<cfset rc.subtypeBean.delete() />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  		<cfset rc.subtypeBean.save() />
	  </cfif> 
	
	  <cfif rc.action neq 'delete'>
		  <cfset rc.subTypeID=rc.subtypeBean.getSubTypeID()>
		  <cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeID,siteid",path="")>
	  <cfelse>
	  	  <cfset variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="")>
	  </cfif>
	  
</cffunction>

<cffunction name="updateSet" output="false">
	<cfargument name="rc">
	 <cfset rc.extendSetBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean() />
	 <cfset rc.extendSetBean.set(rc) />
	  
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.extendSetBean.save() />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset rc.extendSetBean.delete() />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.extendSetBean.save() />
	  </cfif> 
	
	  <cfif rc.action neq 'delete'>
		<cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="")>
	  </cfif>
</cffunction>	  	

<cffunction name="updateAttribute" output="false">
	<cfargument name="rc">
	  <cfset rc.attributeBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean().getattributeBean() />
	  <cfset rc.attributeBean.set(rc) />

	  <cfif rc.action eq 'Update'>
	  	<cfset rc.attributeBean.save() />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset rc.attributeBean.delete() />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.attributeBean.save() />
	  </cfif> 
	  
	 <cfset variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="")>
</cffunction>

<cffunction name="saveAttributeSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveAttributeSort(rc.attributeID) />
	<cfabort>
</cffunction>

<cffunction name="saveExtendSetSort" output="false">
	<cfargument name="rc">
	<cfset application.classExtensionManager.saveExtendSetSort(rc.extendSetID) />
	<cfabort>
</cffunction>
</cfcomponent>