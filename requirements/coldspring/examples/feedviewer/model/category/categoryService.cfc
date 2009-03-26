<!---
	$Id: categoryService.cfc,v 1.1 2005/09/24 22:12:50 rossd Exp $
	$Source: D:/CVSREPO/coldspring/coldspring/examples/feedviewer/model/category/categoryService.cfc,v $
	$State: Exp $
	$Log: categoryService.cfc,v $
	Revision 1.1  2005/09/24 22:12:50  rossd
	first commit of sample app and m2 plugin
	
	Revision 1.3  2005/02/09 14:39:54  rossd
	*** empty log message ***
	
	Revision 1.2  2005/02/08 21:31:17  rossd
	*** empty log message ***
	
	Revision 1.1  2005/02/07 21:57:38  rossd
	initial checkin of feedviewer sample app
	

    Copyright (c) 2005 David Ross
--->

<cfcomponent name="Category Service" output="false">

	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.category.categoryService" output="false">
	
		<cfreturn this/>
	
	</cffunction>

	<cffunction name="setCategoryDAO" returntype="void" access="public"	output="false" hint="dependency: categoryDAO">
		<cfargument name="categoryDAO" type="coldspring.examples.feedviewer.model.category.categoryDAO"	required="true"/>
		
		<cfset variables.m_CategoryDAO = arguments.categoryDAO/>
			
	</cffunction>	

	<cffunction name="setCategoryGateway" returntype="void" access="public" output="false" hint="dependency: categoryGateway">
		<cfargument name="categoryGateway" type="coldspring.examples.feedviewer.model.category.categoryGateway" required="true"/>
		
		<cfset variables.m_CategoryGateway = arguments.categoryGateway/>
			
	</cffunction>
	
	<cffunction name="getAllCategories" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfreturn variables.m_CategoryGateway.getAll()/>
	</cffunction>
	
	<cffunction name="getById" returntype="coldspring.examples.feedviewer.model.category.category" access="public" output="false" hint="I retrieve a category">
		<cfargument name="categoryId" type="numeric" required="true"/>
		<cfreturn variables.m_CategoryDAO.fetch(arguments.categoryId)/>
	</cffunction>
	
	<cffunction name="save" returntype="void" access="public" output="false" hint="I save a category">
		<cfargument name="category" type="coldspring.examples.feedviewer.model.category.category" required="true"/>
		<cfreturn variables.m_CategoryDAO.save(arguments.category)/>
	</cffunction>	

	<cffunction name="remove" returntype="void" access="public" output="false" hint="I remove a category">
		<cfargument name="category" type="coldspring.examples.feedviewer.model.category.category" required="true"/>
		<cfreturn variables.m_CategoryDAO.remove(arguments.category)/>
	</cffunction>	
</cfcomponent>