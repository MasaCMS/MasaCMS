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


<cfcomponent extends="ModelGlue.unity.orm.AbstractORMAdapter" hint="I am a concrete implementation of a Model-Glue ORM adapter.">

<cffunction name="init" returntype="TransferAdapter" output="true" access="public" 
			hint="I am the constructor.">
	<cfargument name="framework" type="any" required="true" 
				hint="I am the (Model-Glue) framework object." />
<!---
	Once Mark creates the transfer configuration object, this code can be cleaned up:
	<cfset var tmp = "" />
 --->
	<!--- Does a transfer configuration exist? --->
<!---
	<cftry>
		<cfset tmp = arguments.framework.getNativeBean("transferConfiguration") />
		<cfcatch>
			<cfset arguments.framework.setUseORMAdapter("false", "No transferConfiguration bean is present.") />
		</cfcatch>
	</cftry>
 --->		
	<!--- If we're ok to load, and we can find transfer, try loading it --->
<!---
	<cfif isObject(tmp) and fileExists(expandPath("/transfer") & "/TransferFactory.cfc")>	
 --->
	<cfif fileExists(expandPath("/transfer") & "/TransferFactory.cfc")>	
		<cftry>
			<cfset variables._transfer = arguments.framework.getNativeBean("ormService") />
			<cfset arguments.framework.setUseORMAdapter(true, "Loaded TransferAdapter") />
			<cfset arguments.framework.setORMAdapterName("com.adobe.hs.common.orm.TransferAdapter") />
			<cfcatch type="any">
				<cfset arguments.framework.setUseORMAdapter("false", "Transfer failed to load: #cfcatch.type# : #cfcatch.message# : #cfcatch.detail#") />
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfset variables._mg = arguments.framework />
	<cfset variables._ormStatus = arguments.framework.getUseORMAdapter() />
	<cfset variables._mdCache = structNew() />
	<cfset variables._cpCache = structNew() />
	<cfset variables._tmdCache = structNew() />
	<cfset variables._dictCache = structNew() />

	<cfreturn this />
</cffunction>

<cffunction name="getTransfer" returntype="transfer.com.Transfer" output="false" access="private" 
			hint="I return the Transfer ORM library (not the Transfer factory object!).">

	<cfif not structKeyExists(variables, "_transfer")>
		<cfthrow type="TransferAdapter.TransferNotLoaded" message="You're trying to use Transfer to do scaffolds or generic databases, but Transfer isn't available for the following reason: ""#variables._ormStatus.detail#""" />
	</cfif>

	<cfreturn variables._transfer.getTransfer() />
	
</cffunction>

<cffunction name="getTransferMetadata" returntype="ModelGlue.unity.orm.transfer.TransferMetadata" output="false"
						hint="I return the TransferMetadata interpretation of a given Transfer object.">
	<cfargument name="objectName" type="string" required="true" />

	<cfset var md = "" />
	
	<cfif not structKeyExists(variables._tmdCache, arguments.objectName)>
		<cfset md = createObject("component","ModelGlue.unity.orm.transfer.TransferMetadata").init(getTransfer(),arguments.objectName, this) />
		<cfset variables._tmdCache[arguments.objectName] = md />
	<cfelse>
		<cfset md = variables._tmdCache[arguments.objectName] />
	</cfif>
	
	<cfreturn md />
</cffunction>

<cffunction name="getTransferDictionary" returntype="ModelGlue.unity.orm.transfer.TransferDictionary" output="false"
						hint="I return the TransferDictionary proxy for a given Transfer object.">
	<cfargument name="objectName" type="string" required="true" />

	<cfset var dict = "" />
	
	<cfif not structKeyExists(variables._dictCache, arguments.objectName)>
		<cfset dict = createObject("component","ModelGlue.unity.orm.transfer.TransferDictionary").init(getTransfer(),arguments.objectName) />
		<cfset variables._dictCache[arguments.objectName] = dict />
	<cfelse>
		<cfset dict = variables._dictCache[arguments.objectName] />
	</cfif>
	
	<cfreturn dict />
</cffunction>

<cffunction name="getObjectMetadata" returntype="struct" output="true" access="public"
			hint="I return the Model-Glue metadata object required for scaffolding.">
	<cfargument name="table" type="string" required="true" 
				hint="I am the Transfer object name (not really a table name)." />

	<cfset var result = structNew() />
	<cfset var md = structNew() />
	<cfset var rmd = getTransferMetadata(arguments.table) />
	<cfset var dict = getTransferDictionary(arguments.table) />
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
		<cfset md[fields[i].alias].pluralRelationship = false />
		<cfset md[fields[i].alias].label = dict.getValue("#arguments.table#.#fields[i].alias#.label") />
						
		<cfif md[fields[i].alias].label eq fields[i].alias>
			<cfset md[fields[i].alias].label = determineLabel(md[fields[i].alias].label) />
		</cfif>
		
		<cfset md[fields[i].alias].comment = dict.getValue("#arguments.table#.#fields[i].alias#.comment") />
	
		<cfif fields[i].primaryKey>
			<cfset arrayAppend(result.primaryKeys, fields[i].alias) />
		</cfif>
			
		<cfset arrayAppend(properties, md[fields[i].alias]) />
	</cfloop>
	
	<!--- Add hasOne --->
	<cfloop from="1" to="#arrayLen(hasOne)#" index="i">
			<!--- Change its alias to the relationship's alias --->
			<cfset md[hasOne[i].alias] = createEmptyField(rmd) />
			<cfset md[hasOne[i].alias].alias = hasOne[i].alias />
			<cfset md[hasOne[i].alias].name = hasOne[i].alias />
			
			<!--- Determine the source --->
			<cfset determineSource(md[hasOne[i].alias], hasOne[i]) />
			<cfset md[hasOne[i].alias].relationship = true />
			<cfset arrayAppend(properties, md[hasOne[i].alias]) />
	</cfloop>
	
	<!--- Add direct (no link) hasMany --->
	<cfloop from="1" to="#arrayLen(hasMany)#" index="i">
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
			<cfset field.pluralRelationship = true />
			<cfset field.linkingRelationship = hasMany[i].manyToMany />
			<cfset determineSource(field, hasMany[i]) />

			<cfset md[field.alias] = field />
			<cfset arrayAppend(properties, field) />
		</cfif>
	</cfloop>

	<cfset label = dict.getValue("#arguments.table#.label") />
	
	<cfif label eq "#arguments.table#.label">
		<cfset label = determineLabel(listLast(arguments.table, ".")) />
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
		<cfset md = getObjectMetadata(arguments.table) />
		
		<cfloop collection="#md.properties#" item="i">
			<cfif not md.properties[i].relationship>
					<cfset result = listAppend(result, i) />
			</cfif>
		</cfloop>

		<cfset variables._cpCache[arguments.table] = result />		
	<cfelse>
		<cfset result = variables._cpCache[arguments.table] />
	</cfif>
	
	<cfreturn result />
</cffunction>

<cffunction name="determineSource" returntype="void" output="false" access="private">
	<cfargument name="field" type="struct" required="true" />
	<cfargument name="relationship" type="struct" required="true" />
	
	<cfset var rmd = getTransferMetadata(arguments.relationship.name) />
	<cfset var dict = getTransferDictionary(arguments.relationship.name) />
	<cfset var fields = rmd.getfields() />
	<cfset var i = "" />

	<cfif not arrayLen(fields)>
		<cfthrow type="TransferAdapter.determineSource.noFields" message="The source table (#arguments.relationship.name#) has no columns." />
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

	<cfset arguments.field.label = dict.getValue("#arguments.relationship.name#.#arguments.field.sourceColumn#.label") />
	<cfset arguments.field.comment = dict.getValue("#arguments.relationship.name#.#arguments.field.sourceColumn#.comment") />
	<cfset arguments.field.label = determineLabel(arguments.field.alias) />
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

<cffunction name="createEmptyField" returntype="struct" output="false" access="public">
	<cfargument name="metadata" required="true" />

	<cfset var field = structNew() />
	<cfset field.relationship = false />
	<cfset field.pluralRelationship  = false />
	<cfset field.linkingRelationship = false />
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
	<cfset field.nullable = true />
	<cfset field.object = arguments.metadata.getAlias() />
	<cfset field.primaryKey = false />
	<cfset field.sequence = "" />
	<cfset field.label = "" />
	<cfset field.comment = "" />
	
	<cfreturn field />
</cffunction>

<cffunction name="list" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="criteria" type="struct" required="false" />
	<cfargument name="orderColumn" type="string" required="false" />
	<cfargument name="orderAscending" type="boolean" required="false" default="true" />
	<cfargument name="gatewayMethod" type="string" required="false" />
	<cfargument name="gatewayBean" type="string" required="false" />

	<cfset var gw = "" />
	<cfset var result = "" />
	
	<cfif structKeyExists(arguments,"gatewayMethod")>
		<cfif not structKeyExists(arguments, "gatewayBean")>		
			<cfset gw = new(arguments.table) />
			<cfif not structKeyExists(gw, arguments.gatewayMethod)>
				<cfthrow type="ModelGlue.unity.orm.transferAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the TransferObject ""#arguments.table#""." />
			</cfif>
		<cfelse>
			<cfset gw = variables._mg.getBean(arguments.gatewayBean) />
			<cfif not structKeyExists(gw, arguments.gatewayMethod)>
				<cfthrow type="ModelGlue.unity.orm.transferAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the GatewayBean ""#arguments.gatewayBean#""." />
			</cfif>
		</cfif>
			
		<cfinvoke component="#gw#" method="#arguments.gatewaymethod#" argumentcollection="#criteria#" returnvariable="result" />
				
		<cfreturn result />
	<cfelseif structKeyExists(arguments,"criteria") and structCount(arguments.criteria) gt 0>
		<cfif structKeyExists(arguments,"orderColumn")>
			<cfreturn getTransfer().listByPropertyMap(arguments.table,arguments.criteria,arguments.orderColumn,arguments.orderAscending) />
		<cfelse>
			<cfreturn getTransfer().listByPropertyMap(arguments.table,arguments.criteria) />
		</cfif>	
	<cfelse>
		<cfif structKeyExists(arguments,"orderColumn")>
			<cfreturn getTransfer().list(arguments.table,arguments.orderColumn,arguments.orderAscending) />
		<cfelse>
			<cfreturn getTransfer().list(arguments.table) />
		</cfif>	
	</cfif>

</cffunction>

<cffunction name="new" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />

	<cfreturn getTransfer().new(arguments.table) />

</cffunction>

<cffunction name="read" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />

	<cfreturn getTransfer().readByPropertyMap(arguments.table,arguments.primaryKeys) />

</cffunction>

<cffunction name="validate" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="any" required="true" />
	
	<cfset var errors = "" />
	<cfset var dict = createObject("component","ModelGlue.unity.orm.transfer.TransferDictionary").init(getTransfer(),arguments.table) />
	<cfset var md = getObjectMetadata(arguments.table) />
	<cfset var errorCollection = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
	<cfset var i = "" />
	<cfset var propValue = "" />
		
	<cfloop collection="#md.properties#" item="i">
		<cfif not md.properties[i].relationship>
			<cfinvoke component="#arguments.record#" method="get#i#" returnvariable="propValue" />
			
			<cfif not md.properties[i].nullable and not len(trim(propValue))>
				<cfset errorCollection.addError(i, dict.getValue(arguments.table & "." & i & ".required")) />
			</cfif>
			
			<!--- Type checking is actually silly, because bad typed props won't set at all
			<cfswitch expression="#md.properties[i].cfDataType#">
				<cfcase value="numeric">
					<cfif not isNumeric(propValue)>
						<cfset errorCollection.addError(i, dict.getValue(arguments.table & "." & i & ".type")) />
					</cfif>
				</cfcase>
				<cfcase value="boolean">
					<cfif not isBoolean(propValue)>
						<cfset errorCollection.addError(i, dict.getValue(arguments.table & "." & i & ".type")) />
					</cfif>
				</cfcase>
				<cfcase value="date">
					<cfif not isDate(propValue)>
						<cfset errorCollection.addError(i, dict.getValue(arguments.table & "." & i & ".type")) />
					</cfif>
				</cfcase>
				<cfdefaultcase>
					<cfif not isSimpleValue(propValue)>
						<cfset errorCollection.addError(i, dict.getValue(arguments.table & "." & i & ".type")) />
					</cfif>
				</cfdefaultcase>
			</cfswitch>
			--->
		</cfif>
	</cfloop>	
	
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
	
	<!--- This _will_ blindly call setters that take complex values, so we silently fail --->
	<cftry>
		<cfif arguments.event.argumentExists("properties")>
			<cfset arguments.event.makeEventBean(record, arguments.event.getArgument("properties", "")) />
		<cfelse>
			<cfset arguments.event.makeEventBean(record) />
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
		
	<!--- Update manyToOne properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<cfset property = metadata.properties[i] />

		<cfif property.relationship and not property.pluralRelationship>
			<cfset criteria = structNew() />
			<cfset sourceObject = listLast(property.sourceObject, ".") />

			<cfset newValue = arguments.event.getValue(sourceObject) />
			
			<cfif len(newValue)>
				<cfset criteria[property.sourceKey] = arguments.event.getValue(sourceObject) />
				
				<cfset targetObject = read(property.sourceObject, criteria) />
				
				<!--- If it's a natural relationship --->
				<cfif structKeyExists(record, "set#sourceObject#")>
					<cfinvoke component="#record#" method="set#sourceObject#">
						<cfinvokeargument name="transfer" value="#targetObject#" />
					</cfinvoke>
				<!--- If it's the artificially added reflexive relationship --->
				<cfelseif structKeyExists(record, "setParent#sourceObject#")>
					<cfinvoke component="#record#" method="setParent#sourceObject#">
						<cfinvokeargument name="transfer" value="#targetObject#" />
					</cfinvoke>
				<cfelse>
					<cfthrow type="modelglue.unity.orm.TransferAdapter.NoManyToOneSetter" message="TransferAdapter can't find a valid method to set the #sourceObject# property on #table#!" />
				</cfif>
			<cfelse>
				<cfinvoke component="#record#" method="remove#sourceObject#" />
			</cfif>
		</cfif>
	</cfloop>

	<!--- Manage plural relationship properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<!--- Only do this if the property is a plural relationship and the form contains the needed value --->
		<cfif metadata.properties[i].relationship eq true 
					and metadata.properties[i].pluralrelationship
					and arguments.event.valueExists("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#")>

			<cfset property = metadata.properties[i] />
			<cfset sourceObject = listLast(property.sourceObject, ".") />
			
			<!--- Get a collection of current child records --->
			<cfif structKeyExists(record, "get#metadata.properties[i].alias#Struct")>
				<cfinvoke component="#record#" method="get#metadata.properties[i].alias#Struct" returnvariable="currentChildren" />
				<cfset currentChildIds = structKeyList(currentChildren) />
			<cfelseif structKeyExists(record, "get#metadata.properties[i].alias#Array")>
				<cfinvoke component="#record#" method="get#metadata.properties[i].alias#Array" returnvariable="currentChildren" />
				<cfloop from="1" to="#arrayLen(currentChildren)#" index="j">
					<cfinvoke component="#currentChildren[j]#" method="get#metadata.properties[i].sourceKey#" returnvariable="currentChildId" />
					<cfset currentChildIds = listAppend(currentChildIds, currentChildId) />
				</cfloop>
			<cfelse>
				<cfthrow type="ModelGlue.unity.orm.TransferAdapter.UnknownCollectionType" message="The Transfer Adapter can't find a collection method (get#metadata.properties[i].alias#Struct or get#metadata.properties[i].alias#Array) for the get#metadata.properties[i].alias# property of #table#." />
			</cfif>
			
			<!--- What children are selected in the form? --->
			<cfset selectedChildIds = arguments.event.getValue("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#") />
			
			<!--- Loop over the currentChildren deleting any unselected children --->
			<cfloop list="#currentChildIds#" index="currentChildId">
				<cfif not listFindNoCase(selectedChildIds, currentChildId)>
					<cfif isStruct(currentChildren)>
						<cfif not property.linkingRelationship>
							<cfinvoke component="#currentChildren[currentChildId]#" method="removeParent#objectName#" />
							<cfset getTransfer().save(currentChildren[currentChildId], false) />
						<cfelse>
							<cfinvoke component="#record#" method="remove#listLast(property.sourceObject, ".")#">
								<cfinvokeargument name="object" value="#currentChildren[currentChildId]#" />
							</cfinvoke>
						</cfif>
					<cfelseif isArray(currentChildren)>
						<cfloop from="1" to="#arrayLen(currentChildren)#" index="j">
							<cfinvoke component="#currentChildren[j]#" method="get#metadata.properties[i].sourceKey#" returnvariable="testedChildId" />
							<cfif testedChildId eq currentChildId>
								<cfif not property.linkingRelationship>
									<cfinvoke component="#currentChildren[j]#" method="removeParent#objectName#" />
									<cfset getTransfer().save(currentChildren[j], false) />
								<cfelse>
									<cfinvoke component="#record#" method="remove#listLast(property.sourceObject, ".")#">
										<cfinvokeargument name="object" value="#currentChildren[j]#" />
									</cfinvoke>
								</cfif>
								<cfbreak />
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>

			<!--- Add any selected children to the currentChildren, adding any new children --->
			<cfloop list="#selectedChildIds#" index="selectedChildId">
				<cfif not listFindNoCase(currentChildIds, selectedChildId)>
					<cfset currentChild = getTransfer().readByProperty(property.sourceObject, metadata.properties[i].sourceKey, selectedChildId) />

					<cfif not property.linkingRelationship>
						<cfinvoke component="#currentChild#" method="setParent#objectName#">
							<cfinvokeargument name="transfer" value="#record#" />
						</cfinvoke>
						<cfset getTransfer().save(currentChild, false) />
					<cfelse>
						<cfinvoke component="#record#" method="add#listLast(property.sourceObject, ".")#">
							<cfinvokeargument name="object" value="#currentChild#" />
						</cfinvoke>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>	


</cffunction>

<cffunction name="commit" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="any" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
	
	<cfset getTransfer().save(arguments.record,  arguments.useTransaction) />
</cffunction>

<cffunction name="delete" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
	
	<cfset var record = read(arguments.table, arguments.primaryKeys) />
	<cfset getTransfer().delete(record, arguments.useTransaction) />

</cffunction>

</cfcomponent>