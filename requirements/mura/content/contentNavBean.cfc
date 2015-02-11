<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject">

<cfset variables.instance=structNew()>
<cfset variables.instance.content="">
<cfset variables.instance.struct=structNew()>
<cfset variables.iterator="">

<cffunction name="setContentManager">
	<cfargument name="contentManager">
	<cfset variables.contentManager=arguments.contentManager>
	<cfreturn this>
</cffunction>

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
	<cfset bean=getContentBean()>
	
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
		
<cffunction name="set" access="public" returntype="any" output="false">
	<cfargument name="contentStruct">
	<cfargument name="sourceIterator">
	
	<cfset variables.instance.struct=arguments.contentStruct>
	<cfset variables.sourceiterator=arguments.sourceIterator>
	
	<cfif isObject(variables.instance.content)>
		<cfset variables.instance.content.setIsNew(1)>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfif len(arguments.property)>
		<cfif isDefined("this.get#arguments.property#")>
			<cfset var tempFunc=this["get#arguments.property#"]>
			<cfreturn tempFunc()>	
		<cfelseif structKeyExists(variables.instance.struct,"#arguments.property#")>
			<cfreturn variables.instance.struct["#arguments.property#"]>
		<cfelse>
			<cfreturn getContentBean().getValue(arguments.property)>
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="setValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfargument name="propertyValue">	
	<cfif isDefined("this.set#arguments.property#")>
		<cfset var tempFunc=this["set#arguments.property#"]>
		<cfset tempFunc(arguments.propertyValue)>
	<cfelse>
		<cfset variables.instance.struct[arguments.property]=arguments.propertyValue>
		<cfset getContentBean().setValue(arguments.property, arguments.propertyValue)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getContentBean" access="public" returntype="any" output="false">
	<cfif NOT isObject(variables.instance.content)>
		<cfset variables.instance.content=getBean("content")>
		<cfset variables.instance.content.setIsNew(1)>
		<cfset variables.instance.contentStructTemplate=structCopy(variables.instance.content.getAllValues(autocomplete=false))>
	</cfif>
	
	<cfif NOT variables.instance.content.getIsNew() >
		<cfreturn variables.instance.content>
	<cfelse>
		<cfset variables.instance.content.setAllValues( structCopy(variables.instance.contentStructTemplate) )>
		<cfif structKeyExists(variables.instance.struct,"contentHistID")>
			<cfset variables.instance.content=variables.contentManager.getContentVersion(contentHistID=variables.instance.struct.contentHistID, siteID=variables.instance.struct.siteID, contentBean=variables.instance.content, sourceIterator=variables.sourceIterator)>
		<cfelseif structKeyExists(variables.instance.struct,"contentID")>
			<cfset variables.instance.content=variables.contentManager.getActiveContent(contentID=variables.instance.struct.contentID,siteID=variables.instance.struct.siteID, contentBean=variables.instance.content, sourceIterator=variables.sourceIterator)>
		<cfelse>
			<cfthrow message="The query you are iterating over does not contain either contentID or contentHistID">
		</cfif>
		<cfset variables.instance.content.setValue('sourceIterator',variables.sourceiterator)>

		<cfreturn variables.instance.content>
	</cfif>
</cffunction>

<cffunction name="getAllValues" output="false">
	<cfargument name="expand" default="true">
	<cfif arguments.expand>
		<cfreturn getContentBean().getAllValues(argumentCollection=arguments)>
	<cfelse>
		<cfreturn variables.instance.struct>
	</cfif>
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfset var i="">
	<cfset var cl=0>
	
	<cfif structKeyExists(request,"crumbdata")>
		<cfset cl=arrayLen(request.crumbdata)-1>
		<cfif cl>
			<cfloop from="1" to="#cl#" index="i">
				<cfif request.crumbdata[i].contentID eq getValue("contentID") >
					<cfreturn getBean("contentNavBean").set(request.crumbData[i+1],"active") />
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfreturn getContentBean().getParent()>
	
</cffunction>

<cffunction name="getKidsQuery" returnType="query" output="false" access="public">
	<cfargument name="aggregation" required="true" default="false">
	
	<cfif structKeyExists(variables.instance.struct,"kids") and isNumeric(variables.instance.struct.kids) and not variables.instance.struct.kids>
		<!--- There are no kids so no need to query --->
		<cfreturn queryNew("contentid,contenthistid,siteid,type,filename,title,menutitle,summary,kids")>
	<cfelse>
		<cfreturn variables.contentManager.getKidsQuery(siteID:getValue("siteID"), parentID:getValue("contentID"), sortBy:getValue("sortBy"), sortDirection:getValue("sortDirection"), aggregation=arguments.aggregation) />
	</cfif>
</cffunction>

<cffunction name="getKidsIterator" returnType="any" output="false" access="public">
	<cfargument name="liveOnly" required="true" default="true">
	<cfargument name="aggregation" required="true" default="false">
	<cfset var q=getKidsQuery(arguments.aggregation) />
	<cfset var it=getBean("contentIterator")>
	
	<cfif arguments.liveOnly>
		<cfset q=getKidsQuery(arguments.aggregation) />
	<cfelse>
		<cfset q=variables.contentManager.getNest( parentID:getValue("contentID"), siteID:getValue("siteID"), sortBy:getValue("sortBy"), sortDirection:getValue("sortDirection")) />
	</cfif>
	<cfset it.setQuery(q,getValue("nextn"))>
	
	<cfreturn it>
</cffunction>

<cffunction name="getCrumbArray" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfreturn variables.contentManager.getCrumbList(contentID=getValue("contentID"), siteID=getValue("siteID"), setInheritance=arguments.setInheritance, path=getValue("path"), sort=arguments.sort)>
</cffunction>

<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfset var a=getCrumbArray(setInheritance=arguments.setInheritance,sort=arguments.sort)>
	<cfset var it=getBean("contentIterator")>
	<cfset it.setArray(a)>
	<cfreturn it>
</cffunction>

<cffunction name="getURL" output="false">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="secure" default="false">
	<cfreturn variables.contentManager.getURL(this, arguments.queryString, arguments.complete, arguments.showMeta, arguments.secure)>
</cffunction>			

<cffunction name="getImageURL" output="false">
	<cfargument name="size" required="true" default="undefined">
	<cfargument name="direct" default="true"/>
	<cfargument name="complete" default="false"/>
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfargument name="default" default=""/>
	<cfargument name="secure" default="false">
	<cfset arguments.bean=this>
	<cfreturn variables.contentManager.getImageURL(argumentCollection=arguments)>
</cffunction>

<cffunction name="getFileMetaData" output="false">
	<cfargument name="property" default="fileid">
	<cfreturn getBean('fileMetaData').loadBy(contentid=getValue('contentid'),contentHistID=getValue('contentHistID'),siteID=getValue('siteid'),fileid=getValue(arguments.property))>	
</cffunction>

<cffunction name="getRelatedContentQuery" returnType="query" output="false" access="public">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="orderno">
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="relatedContentSetID" type="string" default="">
	<cfargument name="name" type="string" default="">
	<cfargument name="reverse" type="boolean" default="false">
	
	<cfreturn variables.contentManager.getRelatedContent(getValue('siteID'), getValue('contentHistID'), arguments.liveOnly, arguments.today, arguments.sortBy, arguments.sortDirection, arguments.relatedContentSetID, arguments.name, arguments.reverse, getValue('contentID')) />
</cffunction>

<cffunction name="getRelatedContentIterator" returnType="any" output="false" access="public">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="orderno" >
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="relatedContentSetID" type="string" default="">
	<cfargument name="name" type="string" default="">
	<cfargument name="reverse" type="boolean" default="false">
	
	<cfset var q=getRelatedContentQuery(argumentCollection=arguments) />
	<cfset var it=getBean("contentIterator")>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="hasImage">
	<cfreturn len(getValue('fileID')) and listFindNoCase('jpg,jpeg,png,gif',getValue('fileEXT'))>
</cffunction>

<cffunction name="getExtendedAttributes" returntype="struct" output="false" access="public">
	<cfargument name="name" default="" hint="Extend Set Name" />
	<cfreturn getContentBean().getExtendedAttributes(name=arguments.name) />
</cffunction>

 <cffunction name="getExtendedAttributesList" returnType="string" output="false" access="public">
 	<cfargument name="name" default="" hint="Extend Set Name" />
 	<cfreturn StructKeyList(getExtendedAttributes(name=arguments.name)) />
 </cffunction>

 <cffunction name="getExtendedAttributesQuery" returntype="query" output="false" access="public">
	<cfargument name="name" default="" hint="Extend Set Name" />
	<cfreturn getContentBean().getExtendedAttributesQuery(name=arguments.name) />
</cffunction>

</cfcomponent>