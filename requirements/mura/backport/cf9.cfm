<cffunction name="arrayContains" returnType="boolean" output="false" access="public" hint="uses the underlying java.util.vector's contains method ">
	<cfargument name="array" type="array" required="true" />
	<cfargument name="object" type="any" required="true"/>
	<cfreturn ARGUMENTS.array.contains(ARGUMENTS.object)/>
</cffunction>

<cffunction name="DirectoryList" returnType="any" output="true" access="public">
	<cfargument name="path" type="string" required="true"/>
	<cfargument name="recurse" type="boolean" required="false" default="false"/>
	<cfargument name="listInfo" type="string" required="false" default="query"/>
	<cfargument name="filter" type="string" required="false"/>
	<cfargument name="sort" type="string" required="false" default="ASC"/>
	
	<cfscript>
		var retVar = '';
		var attStr = structNew();
			attStr['action'] 	= 'list';
			attStr['name'] 		= 'retVar';
			attStr['directory'] = ARGUMENTS.path;
			attStr['recurse'] 	= ARGUMENTS.recurse;
			attStr['listInfo'] 	= ARGUMENTS.listInfo;
			if(StructKeyExists(ARGUMENTS, 'filter')){
				attStr['filter'] 	= ARGUMENTS.filter;
			}
			attStr['sort'] 	= ARGUMENTS.sort;
	</cfscript>
	
	<cfdirectory attributeCollection="#attStr#" />
	
	<cfscript>
		switch(lcase(ARGUMENTS.listInfo)){
			case 'name':
				return ListToArray( 
						ValueList( retVar.name, '|^^|')
						, '|^^|'
					);
			break;
			case 'path':
				return ListToArray( 
						ValueList( retVar.directory, '|^^|')
						, '|^^|'
					);
			break;
			default:
				return retVar;
		}
	</cfscript>
	
</cffunction>

<cffunction name="DirectoryRename" returnType="void" output="true" access="public">
	<cfargument name="currentName" type="string" required="true"/>
	<cfargument name="newName" type="string" required="true"/>
	
	<cfscript>
		if( lcase(ARGUMENTS.currentName).startsWith("ram:///") ){
			throw('CF 8 does not support Memory-based virtual file system');
		}
	</cfscript>
	<cfdirectory action="rename" directory="#ARGUMENTS.currentName#" newDirectory="#ARGUMENTS.newName#"/>	
</cffunction>

<cffunction name="location" returnType="void" output="false" access="public">
	<cfargument name="url" type="string" required="true" />
	<cfargument name="addToken" type="boolean" required="false" default="true"/>
	<cfargument name="statusCode" type="string" required="true" />
		<cflocation attributeCollection="#ARGUMENTS#"/>
</cffunction>

<!---
Based upon http://cflib.org/udf/Throw, modified to match CF9 throw() argument order
--->
<cffunction name="throw" returnType="void" output="false" hint="CFML Throw wrapper">
	<cfargument name="message" type="string" default="" hint="Message for Exception">
	<cfargument name="type" type="string" default="Application" hint="Type for Exception">
	<cfargument name="detail" type="string" default="" hint="Detail for Exception">
	<cfargument name="errorCode" type="string" default="" hint="Error Code for Exception">
	<cfargument name="extendedInfo" type="string" default="" hint="Extended Info for Exception">
	<cfargument name="object" type="any" hint="Object for Exception">
    
	<cfif NOT IsDefined("arguments.object")>
		<cfthrow message="#arguments.message#" type="#arguments.type#" detail="#arguments.detail#" errorCode="#arguments.errorCode#" extendedInfo="#arguments.extendedInfo#">
	<cfelse>
		<cfthrow object="#arguments.object#">
	</cfif>
    
</cffunction>

<cffunction name="writeDump" returnType="void" output="true" access="public">
	<cfargument name="var" type="any" required="true" />
	<cfargument name="output" type="string" required="false" default="browser"/>
	<cfargument name="format" type="string" required="false" default="html"/>
	<cfargument name="abort" type="boolean" required="false" />
	<cfargument name="label" type="string" required="false" default=""/>
	<cfargument name="metainfo" type="boolean" required="false" default="yes"/>
	<cfargument name="top" type="numeric" required="false" default="9999"/>
	<cfargument name="show" type="string" required="false" default="all"/>
	<cfargument name="hide" type="string" required="false" default="all"/>
	<cfargument name="keys" type="numeric" required="false" default="9999"/>
	<cfargument name="expand" type="boolean" required="false" default="yes"/>
	<cfargument name="showUDFs" type="boolean" required="false" default="yes"/>
	
	<cfdump attributeCollection="#ARGUMENTS#"/>
	<cfif structKeyExists(ARGUMENTS, 'abort')>
		<cfabort/>
	</cfif>
</cffunction>
