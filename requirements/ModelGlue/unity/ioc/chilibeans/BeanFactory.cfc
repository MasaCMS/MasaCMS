<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayName="BeanFactory" hint="I am a Spring/IoC-style bean factory.  If you give my createBean method a file that represents a bean, you'll get back a bean with the properties defined in that file.">
  <cffunction name="Init" access="public" returnType="BeanFactory" output="false" hint="I build a new beanfactory.">
    <cfargument name="beanStore" type="string" required="true" hint="Comma-delimited list of mappings holding bean xml files.  I search through the mappings in the order given.">
    <cfset variables.beanStore = listToArray(arguments.beanStore) />
    <cfset variables.singletons = structNew() />
    <cfreturn this />
  </cffunction>

  <cffunction name="setBeanStore" access="public" returnType="void" output="false">
    <cfargument name="beanStore" type="string" required="true" hint="Comma-delimited list of mappings holding bean xml files.  I search through the mappings in the order given.">
    <cfset variables.beanStore = listToArray(arguments.beanStore) />
  </cffunction>
  
  <cffunction name="CreateBean" access="public" returnType="any" output="false" hint="I create a bean from an XML file.">
    <cfargument name="beanFile" type="string" required="true" hint="I am the filename representing the bean to instantiate." />
    
    <cfset var xBean = "" />
    <cfset var oInstance = "" />
    <cfset var i = "" />
    <cfset var value = "" />
    <cfset var fsDelim = "/" />
    <cfset var path = "" />

    <cfloop from="1" to="#arrayLen(variables.beanStore)#" index="i">
      <cfif fileExists(expandPath(variables.beanStore[i]) & fsDelim & "#arguments.beanFile#")>
        <cfset path = expandPath(variables.beanStore[i]) & fsDelim & "#arguments.beanFile#" />
        <cfbreak />
      </cfif>
    </cfloop>
    
    <cfif not len(path) or not fileExists(path)>
      <cfthrow type="BeanFactory.FileNotFound" message="BeanFactory:  Can't find bean XML for file ""#arguments.beanFile#"".">
    </cfif>
    
    <cfif not structKeyExists(variables.singletons, arguments.beanFile)>
 	    <cffile action="read" file="#path#" variable="xBean" />
	    <cfset xBean = xmlParse(xBean) />
	      
	    <cfset oInstance = createObject("component", xBean.xmlRoot.xmlAttributes.class) />
          <cfif structKeyExists(oInstance,"init")>
            <cfset oInstance.init() />
          </cfif>
	    <cfloop from="1" to="#arrayLen(xBean.xmlRoot.xmlChildren)#" index="i">
	      <cfif xBean.xmlRoot.xmlChildren[i].xmlName eq "property">
	        <cfset value = createProperty(xBean.xmlRoot.xmlChildren[i].xmlChildren[1]) />
	        <cfset evaluate("oInstance.set#xBean.xmlRoot.xmlChildren[i].xmlAttributes.name#(value)") />
	      </cfif>
	    </cfloop>
	
	    <cfif xBean.xmlRoot.xmlAttributes.singleton>
	      <cfset variables.singletons[arguments.beanFile] = oInstance />
	    </cfif>
    <cfelse>
      <cfset oInstance = variables.singletons[arguments.beanFile] />
    </cfif>
    
    <cfreturn oInstance />
  </cffunction>
  
  <cffunction name="CreateProperty" access="private" returnType="any" output="false" hint="I create a property.  Warning: recursive.">
    <cfargument name="xProp" type="any" required="true" hint="XML of the property to create.">
    <cfset var result = "" />
    <cfset var i = "" />
    
    <cfswitch expression="#arguments.xProp.xmlName#">
      <cfcase value="value">
        <cfset result = arguments.xProp.xmlText />
      </cfcase>
      <cfcase value="array">
        <cfset result = arrayNew(1) />
        <cfloop from="1" to="#arrayLen(arguments.xProp.xmlChildren)#" index="i">
          <cfset result[i] = createProperty(arguments.xProp.xmlChildren[i]) />
        </cfloop>
      </cfcase>
      <cfcase value="struct">
        <cfset result = structNew() />
        <cfloop from="1" to="#arrayLen(arguments.xProp.xmlChildren)#" index="i">
          <cfset result[arguments.xProp.xmlChildren[i].xmlAttributes.key] = createProperty(arguments.xProp.xmlChildren[i].xmlChildren[1]) />
        </cfloop>
      </cfcase>
      <cfcase value="ref">
        <cfset result = createBean(arguments.xProp.xmlAttributes.bean) />
      </cfcase>
      <cfcase value="query">
          <cfset result = createQuery(arguments.xProp.xmlChildren) />
      </cfcase>
    </cfswitch>
    
    <cfreturn result />
  </cffunction>
  
  <cffunction name="createQuery" access="private" returnType="query" output="false">
  	<!---
		Added to original 8/15/2005 - Jared Rypka-Hauer
		Updated to use "column" attributes in XML rather than ordinal
			placement of value tags 8/18/2005 - Jared Rypka-Hauer
	 --->
  	<cfargument name="qryXml" type="any" required="true" />

  	<cfset var columns = qryXml[1].xmlChildren>
		<cfset var rows = qryXml[2].xmlChildren>
		<cfset var c = 0>
		<cfset var r = 0>
		<cfset var v = 0>
		<cfset var myQuery = "">
		<cfset var colsList = "">
		<cfset var colsArray = "">
	
		<cftry>
			<cfloop from="1" to="#arrayLen(columns)#" index="c">
				<cfset colsList = colsList & columns[c].xmlText & ",">
			</cfloop>
	
			<cfset myQuery = queryNew(colsList)>
		
			<cfloop from="1" to="#arrayLen(rows)#" index="r">
				<cfset queryAddRow(myQuery)>
				<cfloop from="1" to="#arrayLen(rows[r].xmlChildren)#" index="v">
					<cfset querySetCell(myQuery,rows[r].xmlChildren[v].xmlAttributes.column,rows[r].xmlChildren[v].xmlText,r)>
				</cfloop>
			</cfloop>
			<cfcatch>
				<cfrethrow />
			</cfcatch>
		</cftry>
		<cfreturn myQuery />
  </cffunction>
</cfcomponent>
