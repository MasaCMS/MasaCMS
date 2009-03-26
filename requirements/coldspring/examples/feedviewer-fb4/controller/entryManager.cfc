<!---
	$Id: entryManager.cfc,v 1.1 2005/09/24 22:12:44 rossd Exp $
	$Source: D:/CVSREPO/coldspring/coldspring/examples/feedviewer-fb4/controller/entryManager.cfc,v $
	$State: Exp $
	$Log: entryManager.cfc,v $
	Revision 1.1  2005/09/24 22:12:44  rossd
	first commit of sample app and m2 plugin
	
	Revision 1.4  2005/02/14 16:57:30  rossd
	removed mach-ii listener extends
	
	Revision 1.3  2005/02/11 17:56:55  rossd
	eliminated rdbms vendor-specific services, replaced with generic sql services
	added datasourceSettings bean containing vendor information
	
	Revision 1.2  2005/02/10 16:40:18  rossd
	*** empty log message ***
	
	Revision 1.1  2005/02/10 13:07:22  rossd
	*** empty log message ***
	
    Copyright (c) 2005 David Ross
--->

<cfcomponent name="entryListener.cfc" output="false">
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer-fb4.controller.entryManager"  output="false">
		<cfargument name="serviceFactory" type="coldspring.beans.BeanFactory" required="yes"/>
		<cfset variables.m_entryService = arguments.serviceFactory.getBean('entryService')/>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getAllEntries" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>	
		<cfreturn variables.m_entryService.getAll(arguments.event.getArg('start','0'))/>
	</cffunction>
	
	<cffunction name="getEntriesByChannelId" returntype="query" access="public" output="false" hint="I retrieve a entry">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>
		<cfreturn variables.m_entryService.getByChannelId(arguments.event.getArg('channel').getId(),arguments.event.getArg('max','50'))/>		
	</cffunction>	
	
	<cffunction name="getentrysByCategoryId" access="public" returntype="query" output="false" hint="I retrieve a category">
		<cfargument name="event" type="coldspring.examples.feedviewer-fb4.plugins.event" required="yes" displayname="Event"/>
	
		<cfreturn variables.m_entryService.getAllByCategory(listToArray(arguments.event.getArg('categoryId')))/>
	
	</cffunction>

</cfcomponent>
			

