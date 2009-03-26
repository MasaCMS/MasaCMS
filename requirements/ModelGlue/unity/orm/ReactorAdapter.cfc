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


<cfcomponent displayname="ReactorAdapter" hint="I am a conrete implementation of a Model-Glue ORM adapter." extends="ModelGlue.unity.orm.AbstractORMAdapter">

<cffunction name="init" returntype="ModelGlue.unity.orm.ReactorAdapter" output="true" access="public">
	<cfargument name="framework" type="any" required="true" />

	<cfset var tmp = "" />

	<!--- Does a reactor configuration exist? --->
	<cftry>
		<cfset tmp = arguments.framework.getNativeBean("reactorConfiguration") />
		<cfcatch>
			<cfset arguments.framework.setUseORMAdapter("false", "Reactor failed to load: #cfcatch.type# : #cfcatch.message# : #cfcatch.detail#") />
		</cfcatch>
	</cftry>
		
	<!--- If we're ok to load, and we can find reactor, try loading it --->
	<cfif isObject(tmp) and fileExists(expandPath("/reactor") & "/reactorFactory.cfc")>	
		<cftry>
			<cfset variables._reactor = arguments.framework.getNativeBean("ormService") />
			<cfset arguments.framework.setUseORMAdapter(true, "Loaded ReactorAdapter") />
			<cfset arguments.framework.setORMAdapterName("ModelGlue.unity.orm.ReactorAdapter") />
			<cfcatch type="reactor.config.InvalidPathToConfig">
				<cfset arguments.framework.setUseORMAdapter("false", "No Reactor.xml file found.") />
			</cfcatch>
			<cfcatch>
				<cfif cfcatch.detail contains "Invalid Path To Config">
					<cfset arguments.framework.setUseORMAdapter("false", "The Reactor.xml file specified in ColdSpring.xml cannot be found.") />
				<cfelse>
					<cfrethrow />
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfset variables._ormStatus = arguments.framework.getUseORMAdapter() />
	<cfset variables._mdCache = structNew() />
	<cfset variables._cpCache = structNew() />
	
	<cfreturn this />
</cffunction>

<cffunction name="getReactor" returntype="reactor.reactorFactory" output="false" access="private">
	
	<cfif not structKeyExists(variables, "_reactor")>
		<cfthrow type="ReactorAdapter.ReactorNotLoaded" message="You're trying to use Reactor to do scaffolds or generic databases, but Reactor isn't available for the following reason: ""#variables._ormStatus.detail#""" />
	</cfif>

	<cfreturn variables._reactor />
</cffunction>

<cffunction name="getObjectFields" access="private" output="false" returntype="string" >
	<cfargument name="table" type="string" required="true" />
	<cfset var fields = getReactor().createMetadata(arguments.table).getFieldQuery() />
	<cfreturn valueList(fields.alias) />
</cffunction>

<cffunction name="getObjectMetadata" returntype="struct" output="true" access="public">
	<cfargument name="table" type="string" required="true" />

	<cfset var result = structNew() />
	<cfset var md = structNew() />
	<cfset var rmd = getReactor().createMetadata(arguments.table) />
	<cfset var dict = getReactor().createDictionary(arguments.table) />
	<cfset var properties = arrayNew(1) />
	<cfset var fields = rmd.getFields() />
	<cfset var field = "" />
	<cfset var hasOne = rmd.getObjectMetadata().hasOne />
	<cfset var hasMany = rmd.getObjectMetadata().hasMany />
	<cfset var includeThisHasMany = false />
	<cfset var label = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	
	<cfif structKeyExists(variables._mdCache, arguments.table)>
		<cfreturn variables._mdCache[arguments.table] />
	</cfif>

	<cfset result.primaryKeys = arrayNew(1) />
	<cfset result.labelField = "" />
	
	<!--- Determine the "label" field --->
	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfif fields[i].cfdatatype eq "string">
			<cfset result.labelField = fields[i].alias>
			<cfbreak />
		</cfif>
	</cfloop>
	<cfif not len(result.labelField)>
		<cfset result.labelField = fields[1].alias />
	</cfif>
	
	<!--- Add simple fields --->
	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfset md[fields[i].alias] = duplicate(fields[i]) />
		<cfset md[fields[i].alias].sourceObject = "" />
		<cfset md[fields[i].alias].sourceColumn = "" />
		<cfset md[fields[i].alias].sourceKey = "" />
		<cfset md[fields[i].alias].relationship = false />
		<cfset md[fields[i].alias].linkingRelationship = false />
		<cfset md[fields[i].alias].pluralRelationship = false />
		
		<cfif dict.getValue("#arguments.table#.#fields[i].alias#.label") neq "#arguments.table#.#fields[i].alias#.label">
			<cfset md[fields[i].alias].label = dict.getValue("#arguments.table#.#fields[i].alias#.label") />
		<cfelse>
			<cfset md[fields[i].alias].label = determineLabel(fields[i].alias) />		
		</cfif>
		
		<cfif md[fields[i].alias].label eq fields[i].alias>
			<cfset md[fields[i].alias].label = determineLabel(md[fields[i].alias].label) />
		</cfif>
		
		<cfset md[fields[i].alias].comment = dict.getValue("#arguments.table#.#fields[i].alias#.comment") />
	
		<cfif fields[i].primaryKey>
			<cfset arrayAppend(result.primaryKeys, fields[i].name) />
		</cfif>
			
			
		<cfset arrayAppend(properties, md[fields[i].alias]) />
		
	</cfloop>
	
	<!--- Add hasOne --->
	<cfloop from="1" to="#arrayLen(hasOne)#" index="i">
		<!--- If this table contains the primary key, add a "virtual" property" --->
		<cfif md[hasOne[i].relate[1].from].primaryKey>
			<cfset field = createEmptyField(rmd) />
			
			<cfset field.alias = hasOne[i].alias />
			<cfset field.relationship = true />
			<cfset field.linkingRelationship = false />
			<cfset field.pluralRelationship = false />
			<cfset determineSource(field, hasOne[i]) />
			
			<cfset md[field.alias] = field />
			<cfset arrayAppend(properties, field) />
		<!--- Else, replace the physical field with the relationship --->
		<cfelse>
			<!--- Overwrite the physical field this relationship replaces --->
			<cfset field = md[hasOne[i].relate[1].from] />
			<cfset md[hasOne[i].alias] = md[hasOne[i].relate[1].from] />
			
			<cfif hasOne[i].alias neq hasOne[i].relate[1].from>
				<cfset structDelete(md, hasOne[i].relate[1].from) />
			</cfif>
			
			<!--- Change its alias to the relationship's alias --->
			<cfset md[hasOne[i].alias].alias = hasOne[i].alias />

			<!--- Determine the source --->
			<cfset determineSource(md[hasOne[i].alias], hasOne[i]) />
			<cfset md[hasOne[i].alias].relationship = true />

		</cfif>
	</cfloop>
	
	<!--- Add direct (no link) hasMany --->
	<cfloop from="1" to="#arrayLen(hasMany)#" index="i">
		<!--- 
			Some hasMany's are created as a result of linked
			hasMany's - if so, their NAME is the same
			as one of the LINK attribs
		--->
		<cfset includeThisHasMany = true />
		
		<cfloop from="1" to="#arrayLen(hasMany)#" index="j">
			<cfif structKeyExists(hasMany[j], "link")
						and hasMany[j].link[1] eq hasMany[i].name>
				<cfset includeThisHasMany = false />
			</cfif>
		</cfloop>
		
		<cfif includeThisHasMany
					and structKeyExists(hasMany[i], "relate")
					and not structKeyExists(hasMany[i], "link")>
			<cfset field = createEmptyField(rmd) />
			
			<cfset field.alias = hasMany[i].alias />
			<cfset field.relationship = true />
			<cfset field.linkingRelationship = false />
			<cfset field.pluralRelationship = true />
			
			<cfset determineSource(field, hasMany[i]) />

			<!--- 
				Non-linked hasManys are a special case where we need to know
				the foreign key in the source table to set to NULL when 
				relationships are deleted
			--->
			<cfset field.sourceTableForeignKey = hasMany[i].relate[1].to />
			
			<cfset md[field.alias] = field />
			<cfset arrayAppend(properties, field) />
		</cfif>
	</cfloop>

	<!--- Add linked hasMany --->
	<cfloop from="1" to="#arrayLen(hasMany)#" index="i">
		<cfif structKeyExists(hasMany[i], "link")
					and not structKeyExists(hasMany[i], "relate")>
			<cfset field = createEmptyField(rmd) />
			
			<cfset field.alias = hasMany[i].alias />
			<cfset field.relationship = true />
			<cfset field.linkingRelationship = true />
			<cfset field.pluralRelationship = true />
			<cfset field.name = hasMany[i].link[1] />
			<cfset determineSource(field, hasMany[i]) />

			<cfset md[field.alias] = field />
			<cfset arrayAppend(properties, field) />
		</cfif>
	</cfloop>

	<cfset label = dict.getValue("#arguments.table#.label") />
	
	<cfif label eq "#arguments.table#.label">
		<cfset label = determineLabel(arguments.table) />
	</cfif>
	
	<cfset result.label = label />
	<cfset result.alias = rmd.getAlias() />
	
	<cfxml variable="result.xml">
		<object>
			<alias>#rmd.getAlias()#</alias>
			<label>#label#</label>
			<labelfield>#result.labelfield#</labelfield>
			<properties>
			<cfloop from="1" to="#arrayLen(properties)#" index="i">
				<property>
					<cfloop list="nullable,cfdatatype,primarykey,sourcecolumn,pluralrelationship,relationship,sourceobject,name,default,sourcekey,length,alias,label,comment" index="j">
						<#j#><![CDATA[#properties[i][j]#]]></#j#>
					</cfloop>
				</property>							
			</cfloop>
			</properties>
		</object>
	</cfxml>
	
	<cfset result.properties = md />
	
	<cfset variables._mdCache[arguments.table] = result />

	<cfreturn result />
</cffunction>

<cffunction name="getCriteriaProperties" returntype="string" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	
	<cfset var result = "" />
	<cfset var md = "" />
	<cfset var i = "" />
	
	<cfif not structKeyExists(variables._cpCache, arguments.table)>
		<cfset md = getObjectFields(arguments.table) />
		
		<cfset variables._cpCache[arguments.table] = result />		
	<cfelse>
		<cfset result = variables._cpCache[arguments.table] />
	</cfif>
	
	<cfreturn getObjectFields(arguments.table) />
</cffunction>

<cffunction name="determineSource" returntype="void" output="false" access="private">
	<cfargument name="field" type="struct" required="true" />
	<cfargument name="relationship" type="struct" required="true" />
	
	<cfset var rmd = getReactor().createMetadata(arguments.relationship.name) />
	<cfset var dict = getReactor().createDictionary(arguments.relationship.name) />
	<cfset var fields = rmd.getfields() />
	<cfset var i = "" />

	<cfif not arrayLen(fields)>
		<cfthrow type="reactorAdapter.determineSource.noFields" message="The source table (#arguments.relationship.name#) has no columns." />
	</cfif>
	
	<cfset arguments.field.sourceObject = arguments.relationship.name />
	<cfset arguments.field.sourceColumn = fields[1].name />
	
	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfif fields[i].primaryKey>
			<cfset arguments.field.sourceKey = fields[i].name />
		</cfif>
	</cfloop>

	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfif fields[i].cfDataType eq "string"
					and right(fields[i].name, 2) neq "id"
					and fields[i].length lt 65535>
			<cfset arguments.field.sourceColumn = fields[i].name />
			<cfbreak />
		</cfif>
	</cfloop>

	<cfset arguments.field.label = determineLabel(arguments.field.alias) />
		
	<cfset arguments.field.comment = dict.getValue("#arguments.relationship.name#.#arguments.field.sourceColumn#.comment") />
</cffunction>

<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
</cffunction>

<cffunction name="createEmptyField" returntype="struct" output="false" access="private">
	<cfargument name="metadata" required="true" />

	<cfset var field = structNew() />
	<cfset field.relationship = false />
	<cfset field.linkingRelationship  = false />
	<cfset field.pluralRelationship  = false />
	<cfset field.sourceTableForeignKey = "" />
	<cfset field.sourceKey = "" />
	<cfset field.sourceColumn = "" />
	<cfset field.sourceObject = "" />
	<cfset field.alias = "" />
	<cfset field.cfDataType = "" />
	<cfset field.cfSqlType = "" />
	<cfset field.dbDataType = "" />
	<cfset field.default = "" />
	<cfset field.identity = false />
	<cfset field.length = 0 />
	<cfset field.name = "" />
	<cfset field.nullable = false />
	<cfset field.object = arguments.metadata.getAlias() />
	<cfset field.primaryKey = false />
	<cfset field.sequence = "" />
	<cfset field.label = "" />
	<cfset field.comment = "" />
	<cfset field.link = false />
	
	<cfreturn field />
</cffunction>

<cffunction name="list" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="criteria" type="struct" required="false" />
	<cfargument name="orderColumn" type="string" required="false" />
	<cfargument name="orderAscending" type="boolean" required="false" default="true" />
	<cfargument name="gatewayMethod" type="string" required="false" />
	<cfargument name="gatewayBean" type="string" required="false" />

	<cfset var gw = getReactor().createGateway(arguments.table) />
	<cfset var field = "" />
	<cfset var result = "" />
	<cfset var query = gw.createQuery() />
	<cfset var where = query.getWhere() />
	<cfset var order = query.getOrder() />
	
	<cfif not structKeyExists(arguments, "gatewayMethod")>
		<cfloop collection="#arguments.criteria#" item="field">
				<cfset where.isEqual(arguments.table, field, arguments.criteria[field]) />
		</cfloop>
		
		<cfif structKeyExists(arguments, "orderColumn")>
			<cfif arguments.orderAscending>
				<cfset order.setAsc(arguments.table, arguments.orderColumn) />
			<cfelse>
				<cfset order.setDesc(arguments.table, arguments.orderColumn) />
			</cfif>
		</cfif>
		
		<cfset result = gw.getByQuery(query) />
	<cfelse>
		<cfinvoke component="#gw#" method="#arguments.gatewaymethod#" argumentcollection="#criteria#" returnvariable="result" />
	</cfif>
	
	<cfreturn result />
</cffunction>

<cffunction name="new" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfreturn getReactor().createRecord(arguments.table) />
</cffunction>

<cffunction name="read" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
	
	<cfset var i = "" />
	<cfset var record = new(arguments.table) />	

	<!--- <cfloop collection="#primaryKeys#" item="i">
		<cfinvoke component="#record#" method="set#i#">
			<cfinvokeargument name="#i#" value="#primaryKeys[i]#" />
		</cfinvoke>
	</cfloop> --->

	<cfset record.load(argumentCollection=primaryKeys) />
	
	<cfreturn record />
</cffunction>

<cffunction name="validate" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="any" required="true" />
	
	<cfset var errors = "" />
	<cfset var dict = "" />
	<cfset var errorCollection = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
	
	<cfset arguments.record.validate() />
	
	<cfif arguments.record.hasErrors()>	
		<cfset errors = arguments.record._getErrorCollection().getErrors() />
		<cfset dict = arguments.record._getDictionary() />
		
		<cfloop from="1" to="#arrayLen(errors)#" index="i">
			<cfset errorCollection.addError(listGetAt(errors[i], 2, "."), dict.getValue(errors[i])) />
		</cfloop>
	</cfif>
		
	<cfreturn errorCollection />
</cffunction>

<cffunction name="assemble" returntype="void" output="false" access="public">
	<cfargument name="event" type="ModelGlue.unity.eventrequest.EventContext" required="true" />
	<cfargument name="target" type="any" required="true" />

	<cfset var record = arguments.target />
	<cfset var table = arguments.event.getArgument("object") />
	<cfset var objectName = listLast(table, ".") />
	<cfset var metadata = getObjectMetadata(table) />
	<cfset var property = "" />
	<cfset var targetObject = "" />
	<cfset var criteria = "" />
	<cfset var newValue = "" />
	<cfset var sourceObject = "" />
	<cfset var currentChildren = "" />
	<cfset var selectedChildId = "" />
	<cfset var selectedChildIds = "" />
	<cfset var currentChild = "" />
	<cfset var currentChildId = "" />
	<cfset var currentChildIds = "" />
	<cfset var testedChildId = "" />
	<cfset var childRecord = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var tmp = "" />
	<cfset var deletionQueue = arrayNew(1) />
	
	<!--- Update all direct properties --->	
	<cfif arguments.event.argumentExists("properties")>
		<cfset arguments.event.makeEventBean(record, arguments.event.getArgument("properties", "")) />
	<cfelse>
		<cfset arguments.event.makeEventBean(record) />
	</cfif>
		
	<!--- Manage plural relationship properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<cfset deletionQueue = arrayNew(1) />
		<!--- Only do this if the property is a plural relationship and the form contains the needed value --->
		<cfif metadata.properties[i].relationship eq true 
					and metadata.properties[i].pluralrelationship
					and arguments.event.valueExists("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#")>
			
			<!--- Get an iterator of current child records --->
			<cfinvoke component="#record#" method="get#metadata.properties[i].alias#Iterator" returnvariable="currentChildren" />

			<!--- What are the current childIds? --->
			<cfset currentChildIds = currentChildren.getValueList(metadata.properties[i].sourceKey) />
			
			<!--- What children are selected in the form? --->
			<cfset selectedChildIds = arguments.event.getValue("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#") />
			
			<!--- Loop over the currentChildren deleting any unselected children --->
			<cfloop condition="currentChildren.hasMore()">
				<cfset childRecord = currentChildren.getNext() />
				<cfinvoke component="#childRecord#" method="get#metadata.properties[i].sourceKey#" returnvariable="currentChildId">
				
				<cfif not listFindNoCase(selectedChildIds, currentChildId)>
					
					<!--- If it's a linking relationship, we want to remove the link:  queue criteria --->
					<cfif metadata.properties[i].linkingRelationship>
						<cfset criteria = structNew() />
						<cfset criteria[metadata.properties[i].sourceKey] = currentChildId />
						<cfset arrayAppend(deletionQueue, criteria) />
					<!--- Otherwise, we null the foreign key field in the target object --->
					<cfelse>
						<cfinvoke component="#childRecord#" method="set#metadata.properties[i].sourceTableForeignKey#">
							<cfinvokeargument name="#metadata.properties[i].sourceTableForeignKey#" value="" />
						</cfinvoke>
						<cfset commit(table, record, false) />
					</cfif>
				</cfif>
			</cfloop>

			<cfloop from="1" to="#arrayLen(deletionQueue)#" index="j">
				<cfset currentChildren.delete(argumentCollection=deletionQueue[j], useTransaction=false) />
			</cfloop>
				
			<!--- Add any selected children to the currentChildren, adding any new children --->
			<cfloop list="#selectedChildIds#" index="selectedChildId">
				<cfif not listFindNoCase(currentChildIds, selectedChildId)>
					<cfset criteria = structNew() />
					<cfset criteria[metadata.properties[i].sourceKey] = selectedChildId />
					<cfset childRecord = currentChildren.add(argumentCollection=criteria) />
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>	

</cffunction>

<cffunction name="commit" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="any" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
	
	<cfset record.save(arguments.useTransaction) />
</cffunction>

<cffunction name="delete" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
	<cfset var record = read(arguments.table, arguments.primaryKeys) />
	<cfset record.delete(arguments.useTransaction) />
</cffunction>

</cfcomponent>