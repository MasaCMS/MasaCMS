/*
This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses;.

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
*/
component extends="mura.cfobject" output="false" {

	property name="errors" type="struct" persistent="false" comparable="false";
	property name="isNew" type="numeric" persistent="false" default="1";
	property name="fromMuraCache" type="boolean" default="false" persistent="false" comparable="false";
	property name="instanceID" type="string" persistent="false" comparable="false";

	variables.properties={};
	variables.validations={};
	variables.entityName="";
	variables.primaryKey="";

	function init(){
		super.init(argumentCollection=arguments);
		variables.instance=structNew();
		variables.instance.isNew=1;
		variables.instance.errors=structNew();
		variables.instance.fromMuraCache = false ;
		if(not structKeyExists(variables.instance,"instanceID")){
			variables.instance.instanceID=createUUID();
		}
		variables.instance.addObjects=[];
		variables.instance.removeObjects=[];

		return this;
	}

	function OnMissingMethod(string MissingMethodName,Struct MissingMethodArguments){
		var prefix=left(arguments.MissingMethodName,3);
		var synthedFunctions = getSynthedFunctions();

		if(len(arguments.MissingMethodName)){

			if(variables.entityName != '' && structKeyExists(synthedFunctions, arguments.MissingMethodName)){
				try{

					if(not structKeyExists(arguments,'MissingMethodArguments')){
						arguments.MissingMethodArguments={};
					}

					if(structKeyExists(synthedFunctions[arguments.MissingMethodName],'args')){
						
						if(structKeyExists(synthedFunctions[arguments.MissingMethodName].args,'cfc')){
							var bean=getBean(synthedFunctions[arguments.MissingMethodName].args.cfc);
							//writeDump(var=bean.getProperties());
							if(synthedFunctions[arguments.MissingMethodName].args.functionType eq 'getEntity'){
								synthedFunctions[arguments.MissingMethodName].args.loadKey=bean.getPrimaryKey();
							} else {
								synthedFunctions[arguments.MissingMethodName].args.loadKey=application.objectMappings[variables.entityName].synthedFunctions[arguments.MissingMethodName].args.fkcolumn;
							}

							structAppend(arguments.MissingMethodArguments,synthArgs(synthedFunctions[arguments.MissingMethodName].args),true);
						}
					}

					//writeDump(var=arguments.MissingMethodArguments);
					//writeDump(var=synthedFunctions[arguments.MissingMethodName].exp,abort=true);
					return evaluate(synthedFunctions[arguments.MissingMethodName].exp);

				} catch(any err){
					if(request.muratransaction){
						transactionRollback();
					}				
					writeDump(var=synthedFunctions[arguments.MissingMethodName]);
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
	
	}

	function getInstanceName(){
		if(structKeyExists(variables,'instanceName')){
			return getValue(variables.instanceName);
		} else if(valueExists('name')){
			return getValue('name');
		} else {
			return getValue(getPrimaryKey());
		}
	}

	function setAddedObjectValues(properties){
		set(arguments.properties);
		for(var obj in variables.instance.addObjects){
			obj.set(arguments.properties);
			obj.setAddedObjectValues(arguments.properties);
		}
		return this;
	}

	private function addObject(obj){
		evaluate('arguments.obj.set#getPrimaryKey()#(getValue("#getPrimaryKey()#"))');
		arrayAppend(variables.instance.addObjects,arguments.obj);
		return this;
	}

	private function removeObject(obj){
		if(getValue(getPrimaryKey()) == obj.getValue(getPrimaryKey())){
			arrayAppend(variables.instance.removeObjects,arguments.obj);
		}
		return this;
	}

	private function synthArgs(args){
		var returnArgs={
				"#translatePropKey(args.loadkey)#"=getValue(translatePropKey(arguments.args.fkcolumn)),
				returnFormat=arguments.args.returnFormat
			};
		if(structKeyExists(arguments.args,'siteid')){
			returnArgs.siteid=getValue('siteid');
		}
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

 	function parseDateArg(String arg){
		if(lsisDate(arguments.arg)){
			try{
				return lsparseDateTime(arguments.arg);
			} catch(any e){
				return arguments.arg;
			}
			
		} else if(isDate(arguments.arg)){
			try{
				return parseDateTime(arguments.arg);
			} catch(any e){
				return arguments.arg;
			}
		} else {
			return "";
		}
	}

	function set(data){	
		var prop='';
		if(isQuery(arguments.data) and arguments.data.recordcount){
			for(var i=1;i<=listLen(arguments.data.columnlist);i++){
				prop=listgetAt(arguments.data.columnlist,i);
				setValue(prop,arguments.data[prop][1]);
			}
			variables.instance.isNew=0;
		} else if(isStruct(arguments.data)){
			for(prop in arguments.data){
				setValue(prop,arguments.data['#prop#']) ;
			}		
		}
		
		return this;
	}

	function setValue(String property,Any propertyValue=''){

		if(isSimpleValue(arguments.propertyValue)){
			arguments.propertyValue=trim(arguments.propertyValue);
		}
	
		if(isValid('variableName',arguments.property) && isDefined("this.set#arguments.property#")){
			var tempFunc=this["set#arguments.property#"];
			tempFunc(arguments.propertyValue);
		} else {
			variables.instance["#arguments.property#"]=arguments.propertyValue;
		}
	
		return this;
	}

	function getValue(String property,defaultValue){

		if(isValid('variableName',arguments.property) and isDefined("this.get#arguments.property#")){
			var tempFunc=this["get#arguments.property#"];
			return tempFunc();
		} else if(structKeyExists(variables.instance,"#arguments.property#")){
			return variables.instance["#arguments.property#"];
		} else if(structKeyExists(arguments,"defaultValue")){
			variables.instance["#arguments.property#"]=arguments.defaultValue;
			return variables.instance["#arguments.property#"];
		} else{
			return "" ;
		}

	}

	function setAllValues(instance){
		init();
		structAppend(variables.instance,arguments.instance,true);
		return this;
	}

	function getAllValues(){
		return variables.instance;
	}

	function valueExists(valueKey){
		return structKeyExists(variables.instance,arguments.valueKey);
	}

	function validate(){
		var errorCheck={};
		var checknum=1;
		var checkfound=false;

		variables.instance.errors=getBean('beanValidator').validate(this);

		if(arrayLen(variables.instance.addObjects)){
			for(var obj in variables.instance.addObjects){	
				errorCheck=obj.validate().getErrors();
				if(!structIsEmpty(errorCheck)){
					do{
						if( !structKeyExists(variables.instance.errors,obj.getEntityName() & checknum) ){
							variables.instance.errors[obj.getEntityName()  & checknum ]=errorCheck;
							checkfound=true;
						}
					} while (!checkfound);
				}
				
			}
		}

		return this;
	}

	function setErrors(errors){
		if(isStruct(arguments.errors)){
			 variables.instance.errors = arguments.errors ;
		} 
		return this;
	}

	function getErrors(){
		return variables.instance.errors;
	}

	function hasErrors(){
		return not structIsEmpty(variables.instance.errors);
	}

	function setlastUpdateBy(lastUpdateBy){
		variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) ;
		return this;
	}

	function getPrimaryKey(){
		return variables.primarykey;
	}

	function getProperties(){
		getEntityName();

		if(!isdefined('application.objectMappings.#variables.entityName#.properties')){
			lock type="exclusive" name="muraORM#variables.entityName##application.instanceID#" timeout="5" {
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

				}
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
				variables.entityName=listLast(md.entityName,".");
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
				lock type="exclusive" name="muraORM#variables.entityName##application.instanceID#" timeout="5" {
					if(!isDefined('application.objectMappings.#variables.entityName#.validations')){
						param name="application.objectMappings" default={};
						param name="application.objectMappings.#variables.entityName#" default={};
						
						application.objectMappings[variables.entityName].validations={};
						application.objectMappings[variables.entityName].validations.properties={};

						var props=getProperties();
						var rules=[];
						var rule={};
						var ruleKey='';
						var tempRule='';
						var basicRules = ['minValue','maxValue','minLength','maxLength','minCollection','maxCollection','minList','maxList','inlist','method','lte','lt','gte','gt','eq','neq'];


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

							if(structKeyExists(props[prop], "required") && props[prop].required){
								if(structKeyExists(props[prop], "message")){
									rule={message=props[prop].message};
								} else {
									rule={};
								}
								structAppend(rule,{required=props[prop].required});
								arrayAppend(rules,rule);
							}

							if(structKeyExists(props[prop], "format")){
								if(structKeyExists(props[prop], "message")){
									rule={format=props[prop].message};
								} else {
									rule={};
								}
								structAppend(rule,{required=props[prop].required});
								arrayAppend(rules,rule);
							}

							if(structKeyExists(props[prop], "length") && isNumeric(props[prop].length)){
								if(structKeyExists(props[prop], "message")){
									rule={message=props[prop].message};
								} else {
									rule={};
								}
								structAppend(rule,{maxLength=props[prop].length});
								arrayAppend(rules,rule);
							}

							for(var r=1;r <= arrayLen(basicRules);r++){
								if(structKeyExists(props[prop], basicRules[r])){
									if(structKeyExists(props[prop], "message")){
										rule={message=props[prop].message};
									} else {
										rule={};
									}
									tempRule=props[prop];
									structAppend(rule, {'#basicRules[r]#'=tempRule[basicRules[r]]});
									arrayAppend(rules, rule);
								}

							}	
							
							if(arrayLen(rules)){
								application.objectMappings[variables.entityName].validations.properties[ruleKey]=rules;
							}
						}
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
		getEntityName();

		if(len(variables.entityName)){
			param name="application.objectMappings.#variables.entityName#" default={};
			param name="application.objectMappings.#variables.entityName#.synthedFunctions" default={};

			return application.objectMappings[variables.entityName].synthedFunctions;
		} else {
			return {};
		}
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

}