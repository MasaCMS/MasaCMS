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


<!--- Document Information -----------------------------------------------------

Title:      TransferMetadat.cfc

Author:     Sean Corfield, based on the Reactor ORM metadata object by Joe Rinehart
Email:      sean@corfield.org

Website:    http://corfield.org

Purpose:    Model-Glue metadata object for Transfer

Usage:

Modification Log:

Name			Date			Description
================================================================================
Sean Corfield	12/09/2006		Created

------------------------------------------------------------------------------->
<cfcomponent>
	<cfset this.hasOne = arrayNew(1) />
	<cfset this.hasMany = arrayNew(1) />
	<cfset variables.transferMetaData = "" />

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="transfer" type="any" required="true" />
		<cfargument name="table" type="string" required="true" />
		<cfargument name="adapter" type="any" required="true" />
	
		<cfset var skeleton = arguments.transfer.getTransferMetadata(arguments.table) />
		<cfset var props = skeleton.getPropertyIterator() />
		<cfset var prop = 0 />
		<cfset var pk = skeleton.getPrimaryKey() />
		<cfset var newField = 0 />
		
		<cfset var manyToOnes = skeleton.getManyToOneIterator() />
		<cfset var manyToOne = 0 />
		
		<cfset var oneToManys = skeleton.getOneToManyIterator() />
		<cfset var oneToMany = 0 />

		<cfset var manyToManys = skeleton.getManyToManyIterator() />
		<cfset var manyToMany = 0 />

		<cfset var parentOneToManys = skeleton.getParentOneToManyIterator() />
		<Cfset var parentOneToMany = 0 />
		
		<!--- represents a relation in an mimic of reactor's metadata --->
		<cfset var rel = 0 />
		
		<!--- a related object's metadata --->
		<cfset var relMeta = 0 />

		<cfset variables.transferMetadata = skeleton />
		<cfset variables.alias = arguments.table />
		<cfset variables.adapter = arguments.adapter />
		
		<cfset variables.fields = arrayNew(1) />

		<!--- figure out primary key --->
		<cfset newField = variables.adapter.createEmptyField(this) />
		<cfset newField.nullable = pk.getIsNullable() />
		<cfset newField.cfdatatype = pk.getType() />
		<cfset newField.primaryKey = true />
		<cfset newField.name = pk.getColumn() />
		<cfset newField.alias = pk.getName() />
		
		<cfset arrayAppend(variables.fields,newField) />

		<!--- figure out basic fields --->
		<cfloop condition="#props.hasNext()#">
			<cfset prop = props.next() />
			<cfset newField = variables.adapter.createEmptyField(this) />
			<cfset newField.nullable = prop.getIsNullable() />
			<cfset newField.cfdatatype = prop.getType() />
			<cfset newField.name = prop.getColumn() />
			<cfset newField.default = "" /> <!--- fake for now --->
			<cfset newField.length = 0 /> <!--- fake for now --->
			<cfset newField.alias = prop.getName() />
			<cfset arrayAppend(variables.fields,newField) />
		</cfloop>
		
		<!--- figure out manyToOne props --->
		<cfloop condition="#manyToOnes.hasNext()#">
			<cfset manyToOne = manyToOnes.next() />

			<cfset rel = structNew() />
			<cfset rel.alias = manyToOne.getName() />
			<cfset rel.name = manyToOne.getLink().getTo() />
			<cfset rel.relate = arrayNew(1) />
			<cfset rel.relate[1] = structNew() />
			<cfset rel.relate[1].from = manyToOne.getLink().getColumn() />
			
			<cfset relMeta = arguments.transfer.getTransferMetadata(manyToOne.getLink().getTo()) />
			<cfset rel.relate[1].to = relMeta.getPrimaryKey().getColumn() />
			
			<cfset arrayAppend(this.hasOne, rel) />

			<!---
			<cfdump var="#rel#" />
			<cfdump var="#manyToOne#" />
			<cfdump var="#manyToOne.getLink()#" />
			<cfabort />
			--->
		</cfloop>
		
		<!--- Add reflexive manyToOne properties based on parent oneToMany properties --->
		<cfloop condition="#parentOneToManys.hasNext()#">
			<cfset parentOneToMany = parentOneToManys.next() />

			<cfset rel = structNew() />
			<cfset rel.alias = listLast(parentOneToMany.getLink().getTo(), ".") />
			<cfset rel.name = parentOneToMany.getLink().getTo() />
			<cfset rel.relate = arrayNew(1) />
			<cfset rel.relate[1] = structNew() />
			<cfset rel.relate[1].from = parentOneToMany.getLink().getColumn() />

			<cfset relMeta = arguments.transfer.getTransferMetadata(parentOneToMany.getLink().getTo()) />
			<cfset rel.relate[1].to = relMeta.getPrimaryKey().getColumn() />

			<cfset arrayAppend(this.hasOne, rel) />
		</cfloop>
				
		<!--- figure out oneToMany props --->
		<cfloop condition="#oneToManys.hasNext()#">
			<cfset oneToMany = oneToManys.next() />

			<cfset rel = structNew() />
			<cfset rel.alias = oneToMany.getName() />
			<cfset rel.name = oneToMany.getLink().getTo() />
			<cfset rel.relate = arrayNew(1) />
			<cfset rel.relate[1] = structNew() />
			<cfset rel.relate[1].from = skeleton.getPrimaryKey().getColumn() />
			<cfset rel.relate[1].to = oneToMany.getLink().getColumn() />
			<cfset rel.manyToMany = false />
			<cfset arrayAppend(this.hasMany, rel) />

		</cfloop>

		<!--- figure out manyToMany props --->
		<cfloop condition="#manyToManys.hasNext()#">
			<cfset manyToMany = manyToManys.next() />

			<cfset rel = structNew() />
			<cfset rel.alias = manyToMany.getName() />
			<cfset rel.name = manyToMany.getLinkTo().getTo() />
			<cfset rel.relate = arrayNew(1) />
			<cfset rel.relate[1] = structNew() />
			<cfset rel.manyToMany = true />
			<!---
			<cfset rel.relate[1].from = skeleton.getPrimaryKey().getColumn() />
			<cfset rel.relate[1].to = manyToMany.getLink().getColumn() />
			
			<cfset relMeta = arguments.transfer.getTransferMetadata(manyToMany.getLink().getTo()) />
			--->
			
			<cfset arrayAppend(this.hasMany, rel) />

		</cfloop>
		
		<cfreturn this />
	</cffunction>

	<!--- alias for main object --->
	<cffunction name="getAlias" returntype="string" access="public" output="false">
		<cfreturn variables.alias />
	</cffunction>
	
	<!--- fields --->
	<cffunction name="getFields" access="public" hint="I return an array of structures describing this object's fields" output="false" returntype="array">
		<cfreturn variables.fields />
	</cffunction>
	
	<!--- metadata --->
  <cffunction name="getObjectMetadata" access="public" output="false" returntype="struct">
     <cfreturn this />
  </cffunction>

  <cffunction name="getTransferMetadata" access="public" output="false" returntype="struct">
     <cfreturn variables.transferMetadata />
  </cffunction>

</cfcomponent>