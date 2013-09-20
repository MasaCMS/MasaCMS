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
<cfcomponent extends="mura.cfobject" output="false">

<cfproperty name="errors" type="struct" persistent="false" comparable="false" />
<cfproperty name="isNew" type="numeric" persistent="false" default="1"/>
<cfproperty name="fromMuraCache" type="boolean" default="false" persistent="false" comparable="false"/>
<cfproperty name="instanceID" type="string" persistent="false" comparable="false"/>

<cfset variables.properties={}>
<cfset variables.validations={}>
<cfset variables.entityName="">
<cfset variables.primaryKey="">

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.instance=structNew()>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.isNew=1/>
	<cfset variables.instance.errors=structNew()/>
	<cfset variables.instance.fromMuraCache = false />

	<cfif not structKeyExists(variables.instance,"instanceID")>
		<cfset variables.instance.instanceID=createUUID()>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
	<cfscript>
		var prefix=left(arguments.MissingMethodName,3);

		if(len(arguments.MissingMethodName)){

			if(variables.entityName != ''  && isdefined('application.objectMappings.#variables.entityName#.synthedFunctions.#arguments.MissingMethodName#')){
				try{

					if(not structKeyExists(arguments,'MissingMethodArguments')){
						arguments.MissingMethodArguments={};
					}

					if(structKeyExists(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName],'args')){
						
						if(structKeyExists(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args,'cfc')){
							var bean=getBean(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.cfc);
							//writeDump(var=bean.getProperties());
							if(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.functionType eq 'getEntity'){
								application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.loadKey=bean.getPrimaryKey();
							} else {
								application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.loadKey=application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.fkcolumn;
							}

							structAppend(arguments.MissingMethodArguments,synthArgs(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args),true);
						}
					}


					//writeDump(var=arguments.MissingMethodArguments);
					//writeDump(var=application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].exp,abort=true);
					return evaluate(application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].exp);

				} catch(any err){
					if(request.muratransaction){
						transactionRollback();
					}				
					writeDump(var=application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName]);
					writeDump(var=err,abort=true);
				}
			} 

			if(listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3){
				var prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3);	
				
				if(prefix eq "get"){
					return getValue(prop);
				} 

				if(not structIsEmpty(arguments.MissingMethodArguments)){
					return setValue(prop,arguments.MissingMethodArguments[1]);
				} else {
					throw(message="The method '#arguments.MissingMethodName#' requires a propery value");
				}
					
			} else {
				throw(message="The method '#arguments.MissingMethodName#' is not defined");
			}
		} else {
			return "";
		}	
	</cfscript>

</cffunction>

<cfscript>
	private function synthArgs(args){
		var returnArgs={
				"#translatePropKey(args.loadkey)#"=getValue(translatePropKey(arguments.args.fkcolumn)),
				returnFormat=arguments.args.returnFormat
			};

		if(isDefined('application.objectMappings.#getEntityName()#.properties.#arguments.args.prop#.orderby')){
			returnArgs.orderby=application.objectMappings[getEntityName()].properties[arguments.args.prop].orderby;
		} else if(isDefined('application.objectMappings.#arguments.args.cfc#.orderby')){
			returnArgs.orderby=application.objectMappings[arguments.args.cfc].orderby;
		}

		return returnArgs;
	}

	private function translatePropKey(property){
		if(arguments.property eq 'primaryKey'){
			return getPrimaryKey();
		}
		return arguments.property;
	}
</cfscript>


<cffunction name="parseDateArg" output="false" access="public">
    <cfargument name="arg" type="string" required="true">
	<cfif lsisDate(arguments.arg)>
		<cftry>
		<cfreturn lsparseDateTime(arguments.arg) />
		<cfcatch>
			<cfreturn arguments.arg />
		</cfcatch>
		</cftry>
	<cfelseif isDate(arguments.arg)>
		<cftry>
		<cfreturn parseDateTime(arguments.arg) />
		<cfcatch>
			<cfreturn arguments.arg />
		</cfcatch>
		</cftry>
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="setSiteID" output="false" access="public">
    <cfargument name="siteID" type="string" required="true">
    <cfset variables.instance.siteID=arguments.siteID>
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isQuery(arguments.data) and arguments.data.recordcount>
			<cfloop list="#arguments.data.columnlist#" index="prop">
				<cfset setValue(prop,arguments.data[prop][1]) />
			</cfloop>
			<cfset variables.instance.isNew=0>
		<cfelseif isStruct(arguments.data)>
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop]) />
			</cfloop>
				
		</cfif>
		
		<cfreturn this>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfif isSimpleValue(arguments.propertyValue)>
		<cfset arguments.propertyValue=trim(arguments.propertyValue)>
	</cfif>
	
	<cfif structKeyExists(this,"set#arguments.property#")>
		<cfset var tempFunc=this["set#arguments.property#"]>
		<cfset tempFunc(arguments.propertyValue)>
	<cfelse>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(this,"get#arguments.property#")>
		<cfset var tempFunc=this["get#arguments.property#"]>
		<cfreturn tempFunc()>
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset init()>
	<cfset structAppend(variables.instance,arguments.instance,true)/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="valueExists" access="public" output="false">
	<cfargument name="valueKey">
	<cfreturn structKeyExists(variables.instance,arguments.valueKey) />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfscript>
	variables.instance.errors=getBean('beanValidator').validate(this);

	return this;
	</cfscript>
</cffunction>

<cffunction name="setErrors" output="false" access="public">
  <cfargument name="errors"> 
	<cfif isStruct(arguments.errors)>
	 <cfset variables.instance.errors = arguments.errors />
	</cfif> 
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" output="false" access="public">
	<cfreturn variables.instance.errors>
</cffunction>

<cffunction name="hasErrors" output="false" access="public">
	<cfreturn not structIsEmpty(variables.instance.errors)>
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cfscript>

	function getProperties(){
		getEntityName();

		if(!isdefined('application.objectMappings.#variables.entityName#.properties')){
			var md={};
			var pname='';
			var i='';
			var prop={};
			var md=duplicate(getMetaData(this));

			param name="application.objectMappings.#variables.entityName#" default={};
			application.objectMappings[variables.entityName].properties={};
			
			//writeDump(var=md,abort=true);

			for (md; 
			    structKeyExists(md, "extends"); 
			    md = md.extends) 
			  { 

			    if (structKeyExists(md, "properties")) 
			    { 
			      for (i = 1; 
			           i <= arrayLen(md.properties); 
			           i++) 
			      { 
			        pName = md.properties[i].name;

			        if(!structkeyExists(application.objectMappings[variables.entityName].properties,pName)){
			       	 	application.objectMappings[variables.entityName].properties[pName]=md.properties[i];
			       	 	prop=application.objectMappings[variables.entityName].properties[pName];

			       	 	if(!structKeyExists(prop,'comparable')){
				       	 	prop.comparable=true;
				       	 } 

			       	 	if(!structKeyExists(prop,"dataType")){
			       	 		if(structKeyExists(prop,"ormtype")){
			       	 			prop.dataType=prop.ormtype;
			       	 		} else if(structKeyExists(prop,"type")){
			       	 			prop.dataType=prop.type;
			       	 		} else {
			       	 			prop.type="string";
			       	 			prop.dataType="varchar";
			       	 		}
			       	 	}	 	
			     	 }
			    	} 
				} 

			}

			if(hasProperty('contenthistid')){
				application.objectMappings[variables.entityName].versioned=true;
			} else {
				application.objectMappings[variables.entityName].versioned=false;
			}
			
			getValidations();	
		}
		//writeDump(var=variables.properties,abort=true);
		
		return application.objectMappings[variables.entityName].properties;
	}

	function getEntityName(){

		if(!len(variables.entityName)){
			var md=getMetaData(this);

			if(structKeyExists(md,'entityName')){
				variables.entityName=md.entityName;
			} else {
				variables.entityName=listLast(md.name,".");

				if(variables.entityName != 'bean' && right(variables.entityName,4) eq "bean"){
					variables.entityName=left(variables.entityName,len(variables.entityName)-4);
				}
			}
		}

		return variables.entityName;

	}

	function hasProperty(property){
		var props=getProperties();

		for(var prop in props){
			if(prop eq arguments.property or structKeyExists(props[prop],'column') and  props[prop].column eq arguments.property){
				return true;
			}
		}

		return false;
	}

	function isComparable(property){
		var props=getProperties();

		if(structKeyExists(props, property) && structKeyExists(props[property],'comparable')){
			return props[property].comparable;
		} else {
			return true;
		}
	}

	function getValidations(){
		getEntityName();

		if(structIsEmpty(variables.validations)){
			
			if(!isDefined('application.objectMappings.#variables.entityName#.validations')){
			
				param name="application.objectMappings" default={};
				param name="application.objectMappings.#variables.entityName#" default={};
				
				application.objectMappings[variables.entityName].validations={};
				application.objectMappings[variables.entityName].validations.properties={};

				var props=getProperties();
				var rules=[];
				var rule={};
				var ruleKey='';


				for(var prop in props){

					rules=[];

					if(structKeyExists(props[prop], "fkcolumn")){
						ruleKey=props[prop].fkcolumn;
					} else {
						ruleKey=prop;
					}

					if(structKeyExists(props[prop], "datatype") && props[prop].datatype != 'any'){
						if(structKeyExists(props[prop], "message")){
							rule={message=props[prop].message};
						} else {
							rule={};
						}
						structAppend(rule,{datatype=props[prop].datatype});
						arrayAppend(rules, rule);
					}

					if(structKeyExists(props[prop], "regex")){
						if(structKeyExists(props[prop], "message")){
							rule={message=props[prop].message};
						} else {
							rule={};
						}
						structAppend(rule,{regex=props[prop].regex});
						arrayAppend(rules, rule);
					}

					if(structKeyExists(props[prop], "required") && props[prop].required){
						if(structKeyExists(props[prop], "message")){
							rule={message=props[prop].message};
						} else {
							rule={};
						}
						structAppend(rule,{required=props[prop].required});
						arrayAppend(rules,rule);
					}
					
					if(arrayLen(rules)){
						application.objectMappings[variables.entityName].validations.properties[ruleKey]=rules;
					}
				}

			}

			return application.objectMappings[variables.entityName].validations;
		}
		return variables.validations;
	}

	function setValidations(validations){
		variables.validations=arguments.validations;
		return this;
	}

	function getSynthedFunctions(){
		bc=getEntityName();

		param name="application.objectMappings.#variables.entityName#" default={};
		param name="application.objectMappings.#variables.entityName#.synthedFunctions" default={};

		return application.objectMappings[variables.entityName].synthedFunctions;
	}


	function compare(bean, propertyList=''){
		
		var returnStruct={};
		var diffMatchPatch=getBean('diffMatchPatch');
		var diffObj={};
		var i='';
		var propertyArray=listToArray(arguments.propertyList);
		var property='';

		if(!arrayLen(propertyArray)){
			propertyArray=StructKeyArray(getAllValues());
		}

		if(!isObject(arguments.bean) && isStruct(arguments.bean)){
			arguments.bean=new mura.bean.bean().set(arguments.bean);
		}

		for(i=1; i lte arrayLen(propertyArray); i++){
			property=propertyArray[i];
			if(isComparable(property) 
				&& isSimpleValue(getValue(property)) 
				&& isSimpleValue(arguments.bean.getValue(property))
				&& getValue(property) != arguments.bean.getValue(property)
			){
			
				diffObj=diffMatchPatch.compute(javaCast('string',getValue(property)),javaCast('string',arguments.bean.getValue(property)));
				returnStruct[property]=diffObj;
			}
		}

		return returnStruct;
	}

</cfscript>

</cfcomponent>