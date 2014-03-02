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
*/
component extends="mura.bean.bean" versioned=false {

	function init(){
		super.init();
		variables.dbUtility="";
		variables.entityName="";

		var props=getProperties();

		for(var prop in props){
			if(!structKeyExists(variables.instance,prop)){
				prop=props[prop];

				if(structKeyExists(prop,"type") and listFindNoCase("struct,array",prop.type)){
					if(prop.type eq "struct"){
						variables.instance[prop.name]={};
					} else if(prop.type eq "array"){
						variables.instance[prop.name]=[];
					}
				} else if(prop.persistent){

					if(structKeyExists(prop,"fieldType") and prop.fieldType eq "id"){
						variables.instance[prop.column]=createUUID();
					}else if (listFindNoCase("date,datetime,timestamp",prop.datatype)){
						variables.instance[prop.column]=now();
					} else if(structKeyExists(prop,"default")){
						if(prop.default neq 'null'){
							variables.instance[prop.column]=prop.default;
						} else {
							variables.instance[prop.column]='';
						}
					} 

					if (prop.name eq 'lastupdateby'){
						if(isDefined("session.mura") and session.mura.isLoggedIn){
							variables.instance.LastUpdateBy = left(session.mura.fname & " " & session.mura.lname,50);
						} else {
							variables.instance.LastUpdateBy='';
						}
					} else if (prop.name eq 'lastupdatebyid'){
						if(isDefined("session.mura") and session.mura.isLoggedIn){
							variables.instance.LastUpdateById = session.mura.userID;
						} else {
							variables.instance.LastUpdateById='';
						}
					}

				} 
				else {
					if(listFindNoCase("date,datetime,timestamp",prop.datatype)){
						variables.instance[prop.column]=now();
					} else if(structKeyExists(prop,"default")){
						if(prop.default neq 'null'){
							variables.instance[prop.column]=prop.default;
						} else {
							variables.instance[prop.column]='';
						}
					} 
				}
			}
		}

		//writeDump(var=variables.properties,abort=true);

		return this;
	}

	function set(data){
	
		preLoad();

		super.set(argumentCollection=arguments);

		if(len(getDiscriminatorColumn())){
			setValue(getDiscriminatorColumn(),getDiscriminatorValue());
		}

		postLoad();

		return this;
	}


	function getDbUtility(){
		if(not isObject(variables.dbUtility)){
			variables.dbUtility=getBean('dbUtility');
			variables.dbUtility.setTable(getTable());
			if(hasCustomDatasource() ){
				variables.dbUtility.setValue('datasource',getsCustomDatasource());
				variables.dbUtility.setValue('DbUsername','');
				variables.dbUtility.setValue('DbPassword','');

				if(structKeyExists(application.objectMappings[variables.entityName],'dbtype') ){
					variables.dbUtility.setDbType(application.objectMappings[variables.entityName].dbtype);
				}
			}	
		}
		return variables.dbUtility;
	}

	function getDbType(){
		return getDbUtility().getDbType();
	}

	function setDbUtility(dbUtility){
		variables.dbUtility=arguments.dbUtility;
	}

	function getTable(){
		return application.objectMappings[variables.entityName].table;
	}

	function hasTable(){
		return structKeyExists(application.objectMappings[variables.entityName],'table');
	}

	function getBundleable(){
		return application.objectMappings[variables.entityName].bundleable;
	}

	function getDiscriminatorColumn(){
		return application.objectMappings[variables.entityName].discriminatorColumn;
	}

	function getDiscriminatorValue(){
		return application.objectMappings[variables.entityName].discriminatorValue;
	}

	function getReadOnly(){
		return application.objectMappings[variables.entityName].readonly;
	}

	function getManageSchema(){
		return application.objectMappings[variables.entityName].manageschema;
	}

	function getPrimaryKey(){
		return application.objectMappings[variables.entityName].primaryKey;
	}

	function getUseTrash(){
		return application.objectMappings[variables.entityName].usetrash;
	}

	function getColumns(){
		if(hasTable()){
			if(!structKeyExists(application.objectMappings[variables.entityName],'columns')){
				if(!getDbUtility().tableExists()){
					checkSchema();
				}
				application.objectMappings[variables.entityName].columns=getDbUtility().columns();
			}

			return application.objectMappings[variables.entityName].columns;
		} else {
			return {};
		}
	}

	function getSite(){
		return getBean('settingsManager').getSite(getValue('siteID'));
	}

	function checkSchema(){
		var props=getProperties();
		getEntityName();

		if(!getManageSchema()){
			throw(type="MuraORMError",message="The Mura ORM entity '#getEntityName()#' is not allowed to manage schema.");
		}

		if(hasTable()){
			for(var prop in props){
				if(props[prop].persistent){
					getDbUtility().addColumn(argumentCollection=props[prop]);

					if(structKeyExists(props[prop],"fieldtype")){
						if(props[prop].fieldtype eq "id"){
							getDbUtility().addPrimaryKey(argumentCollection=props[prop]);
						} else if ( listFindNoCase('one-to-many,many-to-one,index',props[prop].fieldtype) ){
							getDbUtility().addIndex(argumentCollection=props[prop]);
						}
					}
				}
			}
		}
		
		param name="application.objectMappings.#variables.entityName#" default={};
		application.objectMappings[variables.entityName].columns=getColumns();

		return this;
	}

	function hasCustomDatasource(){
		return structKeyExists(application.objectMappings[variables.entityName],'datasource');
	}

	function getsCustomDatasource(){
		return application.objectMappings[variables.entityName].datasource;
	}

	function getQueryAttrs(){
		if( hasCustomDatasource() ){
			structAppend(arguments,
				{datasource=getsCustomDatasource(),
				username='',
				password=''},
				false);
			return arguments;
		} else {
			return getBean('configBean').getReadOnlyQRYAttrs(argumentCollection=arguments);
		}
	}

	function getQueryService(){
		return new Query(argumentCollection=getQueryAttrs(argumentCollection=arguments));
	}

	function getProperties(){
		
		getEntityName();

		if(!isdefined('application.objectMappings.#variables.entityName#.properties')){
			lock type="exclusive" name="muraORM#variables.entityName##application.instanceID#" timeout="5" {
				if(!isdefined('application.objectMappings.#variables.entityName#.properties')){
					var pname='';
					var i='';
					var prop={};
					var md=duplicate(getMetaData(this));
					var loadKey="";
					var dottedPath=md.fullname;
					var synthArgs={};
					var defaultMetaData={column="",table="",datatype="varchar","default"="null",nullable=true};
					
					param name="application.objectMappings.#variables.entityName#" default={};
					application.objectMappings[variables.entityName].properties={};
					application.objectMappings[variables.entityName].synthedFunctions={};
					application.objectMappings[variables.entityName].primarykey="";
					
					if(structKeyExists(md,'versioned') && md.versioned){
						application.objectMappings[variables.entityName].versioned=true;

						if(not listFindNoCase(application.objectMappings.versionedBeans, variables.entityName)){
							application.objectMappings.versionedBeans=listAppend(application.objectMappings.versionedBeans, variables.entityName);
						}
					} else {
						application.objectMappings[variables.entityName].versioned=false;
					}

					if(structKeyExists(md,'bundleable') && md.bundleable){
						application.objectMappings[variables.entityName].bundleable=md.bundleable;

						if(not listFindNoCase(application.objectMappings.bundleableBeans, variables.entityName)){
							application.objectMappings.bundleableBeans=listAppend(application.objectMappings.bundleableBeans, variables.entityName);
						}
					} else {
						application.objectMappings[variables.entityName].bundleable=false;
					}

					if(structKeyExists(md,'orderby')){
						application.objectMappings[variables.entityName].orderby=md.orderby;
					}

					if(structKeyExists(md,'datasource') && md.datasource != application.configBean.getDatasource()){
						application.objectMappings[variables.entityName].datasource=md.datasource;

						if(structKeyExists(md,'dbtype')){
							application.objectMappings[variables.entityName].dbtype=md.dbtype;
						}
					}

					if(structKeyExists(md,'table')){
						application.objectMappings[variables.entityName].table=md.table;
					}

					if(structKeyExists(md,'discriminatorColumn')){
						application.objectMappings[variables.entityName].discriminatorColumn=md.discriminatorColumn;
					} else {
						application.objectMappings[variables.entityName].discriminatorColumn='';
					}

					if(structKeyExists(md,'discriminatorValue')){
						application.objectMappings[variables.entityName].discriminatorValue=md.discriminatorValue;
					} else {
						application.objectMappings[variables.entityName].discriminatorValue='';
					}

					if(structKeyExists(md,'cachename')){
						application.objectMappings[variables.entityName].cachename=md.cachename;
					} else {
						application.objectMappings[variables.entityName].cachename='data';
					}

					if(structKeyExists(md,'readonly')){
						application.objectMappings[variables.entityName].readonly=md.readonly;
					} else {
						application.objectMappings[variables.entityName].readonly=false;
					}

					if(structKeyExists(md,'manageschema')){
						application.objectMappings[variables.entityName].manageschema=md.manageschema;
					} else {
						application.objectMappings[variables.entityName].manageschema=true;
					}

					if(structKeyExists(md,'usetrash')){
						application.objectMappings[variables.entityName].usetrash=md.usetrash;
					} else {
						application.objectMappings[variables.entityName].usetrash=false;
					}

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

					        //writeDump(var=pname,abort=true);

					        if(!structkeyExists(application.objectMappings[variables.entityName].properties,pName)){
					       	 	application.objectMappings[variables.entityName].properties[pName]=md.properties[i];
					       	 	prop=application.objectMappings[variables.entityName].properties[pName];
					       	 	prop.table=application.objectMappings[variables.entityName].table;

					       	 	param name="prop.comparable" default=true;
					       	 	param name="prop.required" default=false;
					       	 	param name="prop.nullable" default=true;
					       	 	param name="prop.fieldtype" default="";

					       	 	if(prop.required){
					       	 		prop.nullable=false;
					       	 	}

					       	 	if(prop.nullable){
					       	 		prop.required=false;
					       	 	}

					       	 	if(prop.fieldtype eq 'id'){
					       	 		application.objectMappings[variables.entityName].primaryKey=prop.name;
					       	 		setPropAsIDColumn(prop);
					       	 		//writeDump(var=prop,abort=true);
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

					       	 	if(structKeyExists(prop,'cfc')){
					       	 		prop.persistent=true;

					       	 		if(prop.fieldtype eq 'one-to-many'){
					       	 			prop.persistent=false;
					       	 		} else {
					       	 			prop.persistent=true;
					       	 			setPropAsIDColumn(prop,false);
					       	 			//writeDump(var=prop,abort=true);
					       	 		}

					       	 		param name="prop.fkcolumn" default="primaryKey";

					       	 		prop.column=prop.fkcolumn;

					       	 		if(prop.fieldtype eq 'one-to-many' or prop.fieldtype eq 'many-to-many'){
					       	 			//getBean("#prop.cfc#").loadBy(argumentCollection=structAppend(arguments.MissingMethodArguments,synthArgs(application.objectMappings[variables.entityName].synthedFunctions["has#prop.name#"].args),false)).recordcount
						       	 		application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#Iterator']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="iterator",functionType='getEntityIterator'}};
						       	 		application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#Query']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="query",functionType='getEntityQuery'}};
						       	 		application.objectMappings[variables.entityName].synthedFunctions['has#prop.name#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments).recordcount',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="query",functionType='hasEntity'}};
						       	 		application.objectMappings[variables.entityName].synthedFunctions['add#prop.name#']={exp='addObject(arguments.MissingMethodArguments[1])',args={prop=prop.name,functionType='addEntity'}};
						       	 		application.objectMappings[variables.entityName].synthedFunctions['remove#prop.name#']={exp='removeObject(arguments.MissingMethodArguments[1])',args={prop=prop.name,functionType='removeEntity'}};

						       	 		if(listFindNoCase('content,user,feed,category,address,site,comment',prop.cfc)){
						       	 			param name="application.objectMappings.#prop.cfc#" default={};
						       	 			param name="application.objectMappings.#prop.cfc#.synthedFunctions" default={};

						       	 			if(prop.fieldtype eq 'many-to-many'){

						       	 				application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#Iterator']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,siteid=true,cfc="#variables.entityName#",returnFormat="iterator",functionType='getEntityIterator'}};
						       	 				application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#Query']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,siteid=true,cfc="#variables.entityName#",returnFormat="query",functionType='getEntityQuery'}};
							       	 			//application.objectMappings[prop.cfc].synthedFunctions['has#variables.entityName#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments).recordcount',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,cfc="#variables.entityName#",returnFormat="query",functionType='hasEntity'}};
							       	 			application.objectMappings[prop.cfc].synthedFunctions['add#variables.entityName#']={exp='addObject(arguments.MissingMethodArguments[1])',args={prop=variables.entityName,functionType='addEntity'}};
							       	 			application.objectMappings[prop.cfc].synthedFunctions['remove#variables.entityName#']={exp='removeObject(arguments.MissingMethodArguments[1])',args={prop=variables.entityName,functionType='removeEntity'}};

						       	 			} else {
						       	 				application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn="#prop.fkcolumn#",siteid=true,cfc="#variables.entityName#",returnFormat="this",functionType='getEntity'}};
						       	 				//application.objectMappings[prop.cfc].synthedFunctions['set#variables.entityName#']={exp='setValue("#prop.fkcolumn#",arguments.MissingMethodArguments[1].getValue(arguments.MissingMethodArguments[1].getValue("#prop.fkcolumn#"))',args={prop=variables.entityName,functionType='setEntity'}};
						       	 			}

						       	 		}		

							       	 	if(structKeyExists(prop,"singularname")){
							       	 		application.objectMappings[variables.entityName].synthedFunctions['get#prop.singularname#Iterator']=application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#Iterator'];
							       	 		application.objectMappings[variables.entityName].synthedFunctions['get#prop.singularname#Query']=application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#Query'];
							       	 		application.objectMappings[variables.entityName].synthedFunctions['add#prop.singularname#']=application.objectMappings[variables.entityName].synthedFunctions['add#prop.name#'];
							       	 		application.objectMappings[variables.entityName].synthedFunctions['has#prop.singularname#']=application.objectMappings[variables.entityName].synthedFunctions['has#prop.name#'];
							       	 		application.objectMappings[variables.entityName].synthedFunctions['remove#prop.singularname#']=application.objectMappings[variables.entityName].synthedFunctions['remove#prop.name#'];
							       	 	}

					       	 		} else if (prop.fieldtype eq 'many-to-one' or prop.fieldtype eq 'one-to-one'){
					 
		   	 							
					       	 			if(listFindNoCase('content,user,feed,category,address,site,comment',prop.cfc)){
					       	 				
					       	 				if(prop.fkcolumn eq 'siteid'){
						       	 				application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#']={exp='getBean("settingsManager").getSite(getValue("siteID"))',args={prop=prop.name,functionType='getEntity'}};
						       	 				application.objectMappings[variables.entityName].synthedFunctions['set#prop.name#']={exp='setValue("siteID",arguments.MissingMethodArguments[1].getSiteID()))',args={prop=prop.name,functionType='setEntity'}};
						       	 			} else {
						       	 				application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="#prop.fkcolumn#",siteid=true,cfc="#prop.cfc#",returnFormat="this",functionType='getEntity'}};
						       	 				application.objectMappings[variables.entityName].synthedFunctions['set#prop.name#']={exp='setValue("#prop.fkcolumn#",arguments.MissingMethodArguments[1].getValue(arguments.MissingMethodArguments[1].getPrimaryKey())',args={prop=prop.name,functionType='setEntity'}};
						       	 			}

					       	 				param name="application.objectMappings.#prop.cfc#" default={};
							       	 		param name="application.objectMappings.#prop.cfc#.synthedFunctions" default={};

					       	 				if(prop.fieldtype eq 'many-to-one'){

					       	 					application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#Iterator']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,siteid=true,cfc="#variables.entityName#",returnFormat="iterator",functionType='getEntityIterator'}};
						       	 				application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#Query']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,siteid=true,cfc="#variables.entityName#",returnFormat="query",functionType='getEntityQuery'}};
						       	 				//application.objectMappings[prop.cfc].synthedFunctions['has#variables.entityName#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments).recordcount',args={prop=variables.entityName,fkcolumn=prop.fkcolumn,cfc="#variables.entityName#",returnFormat="query",functionType='hasEntity'}};
						       	 				application.objectMappings[prop.cfc].synthedFunctions['add#variables.entityName#']={exp='addObject(arguments.MissingMethodArguments[1])',args={prop=variables.entityName,functionType='addEntity'}};
						       	 				application.objectMappings[prop.cfc].synthedFunctions['remove#variables.entityName#']={exp='removeObject(arguments.MissingMethodArguments[1])',args={prop=variables.entityName,functionType='removeEntity'}};

					       	 				} else {
							       	 			
							       	 			application.objectMappings[prop.cfc].synthedFunctions['get#variables.entityName#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=variables.entityName,fkcolumn="#prop.fkcolumn#",siteid=true,cfc="#variables.entityName#",returnFormat="this",functionType='getEntity'}};
							       	 			//application.objectMappings[prop.cfc].synthedFunctions['set#variables.entityName#']={exp='setValue("#prop.fkcolumn#",arguments.MissingMethodArguments[1].getValue(arguments.MissingMethodArguments[1].getValue("#prop.fkcolumn#"))',args={prop=variables.entityName,functionType='setEntity'}};
						       	 			}
					       	 			} else {
					       	 				if(prop.fkcolumn eq 'siteid'){
						       	 				application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#']={exp='getBean("settingsManager").getSite(getValue("siteID"))',args={prop=prop.name,functionType='getEntity'}};
						       	 				application.objectMappings[variables.entityName].synthedFunctions['set#prop.name#']={exp='setValue("siteID",arguments.MissingMethodArguments[1].getSiteID()))',args={prop=prop.name,functionType='setEntity'}};
						       	 			} else {
						       	 				application.objectMappings[variables.entityName].synthedFunctions['get#prop.name#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="#prop.fkcolumn#",cfc="#prop.cfc#",returnFormat="this",functionType='getEntity'}};
						       	 				application.objectMappings[variables.entityName].synthedFunctions['set#prop.name#']={exp='setValue("#prop.fkcolumn#",arguments.MissingMethodArguments[1].getValue(arguments.MissingMethodArguments[1].getPrimaryKey())',args={prop=prop.name,functionType='setEntity'}};
						       	 			}
					       	 			}
					       	 			
					       	 		}

					       	 		param name="prop.cascade" default="none";

					       	 	} else if(!structKeyExists(prop,"persistent") ){
					       	 		prop.persistent=true;
					       	 	} 

					       	 	param name="prop.column" default=prop.name;

					       	 	
					       	 	structAppend(prop,
					       	 		defaultMetaData,
									false
								);

					      	} 
					      }
					    }
				    } 
				}
			} 

			getValidations();

			//getServiceFactory().declareBean(beanName=variables.entityName,dottedPath=dottedPath,isSingleton=false);
		}

		//abort;
		
		//writeDump(var=application.objectMappings[variables.entityName].properties,abort=true);
		
		return application.objectMappings[variables.entityName].properties;
	}

	private function setPropAsIDColumn(prop,isPrimaryKey=true){
		arguments.prop.type="string";
	
		if(arguments.isPrimaryKey){
			arguments.prop.required=true;
			arguments.prop.nullable=false;
		}

		arguments.prop.default="";

		if(arguments.prop.name eq 'site'){
			arguments.prop.ormtype="varchar";
			arguments.prop.datatype="varchar";
			arguments.prop.length=25;
		} else {
			arguments.prop.ormtype="char";
			arguments.prop.datatype="char";
			arguments.prop.length=35;
		}
	}

	private function addQueryParam(qs,prop,value){
		var paramArgs={};
		var columns=getColumns();

		if(arguments.prop.persistent){
			
			paramArgs={name=arguments.prop.column,cfsqltype="cf_sql_" & columns[arguments.prop.column].datatype};
						
			if(structKeyExists(arguments,'value')){
				paramArgs.null=arguments.prop.nullable and (not len(arguments.value) or arguments.value eq "null");
			}	else {
				arguments.value='null';
				paramArgs.null=arguments.prop.nullable and (not len(variables.instance[arguments.prop.column]) or variables.instance[arguments.prop.column] eq "null");			
			} 

			if(arguments.prop.column == getDiscriminatorColumn()){
				paramArgs.value=getDiscriminatorValue();
			} else {
				paramArgs.value=arguments.value;
			}

			if(columns[arguments.prop.column].datatype eq 'datetime'){
				paramArgs.cfsqltype='cf_sql_timestamp';
			}

			if(listFindNoCase('text,longtext',columns[arguments.prop.column].datatype)){
				paramArgs.cfsqltype='cf_sql_longvarchar';
			}

			arguments.qs.addParam(argumentCollection=paramArgs);

			return true;
		} else {
			return false;
		}

	}

	function validate(){
		super.validate();
		var props=getProperties();

		if(!len(getPrimaryKey()) || !props[getPrimaryKey()].persistent || !len(variables.instance[getPrimaryKey()]) || getPrimaryKey() == 'primarykey'){
			variables.instance.errors.primarykey="The primary key '#getPrimaryKey()#' is required.";
		}

		return this;
	}

	function save(){
		var pluginManager=getBean('pluginManager');
		var event=new mura.event({siteID=getValue('siteid'),bean=this});

		validate();

		if(getReadOnly()){
			throw(type="MuraORMError",message="The Mura ORM entity '#getEntityName()#' is read only.");
		}

		pluginManager.announceEvent('onBefore#variables.entityName#Save',event);

		if(!hasErrors()){
			var props=getProperties();
			var columns=getColumns();
			var prop={};
			var started=false;
			var sql='';
			var qs=getQueryService();

			for (prop in props){
				if(props[prop].persistent){
					addQueryParam(qs,props[prop],variables.instance[props[prop].column]);
				}
			}

			qs.addParam(name='primarykey',value=variables.instance[getPrimaryKey()],cfsqltype='cf_sql_varchar');

			if(qs.execute(sql='select #getPrimaryKey()# from #getTable()# where #getPrimaryKey()# = :primarykey').getResult().recordcount){
				
				preUpdate();
			
				pluginManager.announceEvent('onBefore#variables.entityName#Update',event);

				if(!hasErrors()){

					savecontent variable="sql" {
						writeOutput('update #getTable()# set ');
						for(prop in props){
							if(props[prop].column neq getPrimaryKey() and structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput("#props[prop].column#= :#props[prop].column#");
								started=true;
							}
						}

						writeOutput(" where #getPrimaryKey()# = :primarykey");
						
					}


					var obj='';

					if(arrayLen(variables.instance.removeObjects)){
						for(obj in variables.instance.removeObjects){	
							obj.delete();
						}
					}

					if(arrayLen(variables.instance.addObjects)){
						for(obj in variables.instance.addObjects){	
							obj.save();
						}
					}
						
					qs.execute(sql=sql);
					purgeCache();
					postUpdate();

					pluginManager.announceEvent('onAfter#variables.entityName#Update',event);

					variables.instance.isnew=0;
					variables.instance.addObjects=[];
					variables.instance.removeObjects=[];
				}
				
			} else{

				preCreate();
				preInsert();
				

				pluginManager.announceEvent('onBefore#variables.entityName#Create',event);

				if(!hasErrors()){

					savecontent variable="sql" {
						writeOutput('insert into #getTable()# (');
						for(prop in props){
							if(structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput("#props[prop].column#");
								started=true;
							}
						}

						writeOutput(") values (");

						started=false;
						for(prop in props){
							if(structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput(" :#props[prop].column#");
								started=true;
							}
						}

						writeOutput(")");
						
					}
				
					if(arrayLen(variables.instance.addObjects)){
						for(var obj in variables.instance.addObjects){	
							obj.save();
						}
					}

					qs.execute(sql=sql);
					purgeCache();

					variables.instance.isnew=0;
					variables.instance.addObjects=[];
					variables.instance.removeObjects=[];

					postCreate();
					postInsert();

					pluginManager.announceEvent('onAfter#variables.entityName#Create',event);

				}
			}

			pluginManager.announceEvent('onAfter#variables.entityName#Save',event);
			pluginManager.announceEvent('on#variables.entityName#Save',event);
		
		/*
		} else {
			request.muratransaction=request.muratransaction-1;
		*/
		}

		if(getUseTrash()){
			getBean('trashManager').takeOut(this);
		}

		return this;
	}

	function updateMappingsByIDLists(){
		var props=getProperties();
		var loadArgs={};
		var i=0;
		var subitem='';
		var subPrimaryKey='';
		var deleteID="";
		var saveID='';
		var subEntity='';
		var subItems='';
		var primaryLoadArgs={};
		var isMappingEntity=false;

		for(var prop in props){
			if(structKeyExists(props[prop],'cfc') 
				&& props[prop].fieldtype eq 'one-to-many' 
				&& structKeyExists(props[prop],'keycolumn') ){

				if( valueExist(props[prop].keycolumn) ){
					if(props[prop].fkcolumn eq 'primaryKey'){
						primaryLoadArgs={'#getPrimaryKey()#'=getValue(translatePropKey(props[prop].fkcolumn))};
					} else {
						primaryLoadArgs={'#props[prop].fkcolumn#'=getValue(translatePropKey(props[prop].fkcolumn))};
					}

					subItems=evaluate('getBean(variables.entityName).loadBy(argumentCollection=primaryLoadArgs).get#prop#Iterator()');
					saveID=getValue(props[prop].keycolumn);
					deleteID="";

					while(subItems.hasNext()){
						subitem=subitems.next();
						if(not listFindNoCase(saveID,subItem.getValue(props[prop].keycolumn)) ){
		                    deleteID=listAppend(deleteID,subItem.getValue(props[prop].keycolumn));
		                }
					}

	            	if(len(deleteID)){
		                for(i=1; i lte listLen(deleteID); i=i+1){
		                	loadArgs=structAppend({'#props[prop].keycolumn#'=listGetAt(deleteID,i)},primaryLoadArgs);
		                	subItem=getBean(props[prop].cfc).loadBy(argumentCollection=loadArgs);

		                	if(!subItem.getIsNew()){
			                	if( props[prop].cascade eq 'delete'){
			                    	subItem.delete();
			                    } else {
			                    	if(props[prop].fkcolumn eq 'primaryKey'){
										 subItem.setValue(getPrimaryKey(),'');
									} else {
										 subItem.setValue(props[prop].fkcolumn,'');
									}
			                    }
		                	}
		                }
            		}

					for( i=1; i lte listLen(saveID); i=i+1){
							loadArgs=structAppend({'#props[prop].keycolumn#'=listGetAt(saveID,i)},primaryLoadArgs);

		               		getBean(props[prop].cfc)
		                    .loadBy(argumentCollection=loadArgs)
		                    .setOrderNo(i)
		                    .save();
	            	}
            	}
			}
		}
	}

	/*
	function save(){
		if(request.muraORMtransaction){
			_save();
		} else {
			request.muraORMtransaction=true;
			transaction {
				try{
					_save();
					if(request.muraORMtransaction){
						transactionCommit();
					} else {
						transactionRollback();
					}
				} catch(any err){
					transactionRollback();
				}
			}
			request.muraORMtransaction=false;
		}
	}
		
	function delete(){
		if(request.muraORMtransaction){
			_delete();
		} else {
			request.muraORMtransaction=true;
			transaction {
				try{
					_delete();
					if(request.muraORMtransaction){
						transactionCommit();
					} else {
						transactionRollback();
					}
				} 
				catch(any err){
					transactionRollback();
				}
			}
			request.muraORMtransaction=false;
		}
	}*/
	
	function delete(){
		var props=getProperties();
		var pluginManager=getBean('pluginManager');
		var event=new mura.event({siteID=getValue('siteid'),bean=this});
		var subitem="";
		
		preDelete();

		pluginManager.announceEvent('onBefore#variables.entityName#Delete',event);

		for(var prop in props){
			if(structKeyExists(props[prop],'cfc') and props[prop].fieldtype eq 'one-to-many' and  props[prop].cascade eq 'delete'){
				if(props[prop].fkcolumn eq 'primaryKey'){
					var loadArgs[getPrimaryKey()]=getValue(translatePropKey(props[prop].fkcolumn));
				} else {
					var loadArgs[props[prop].fkcolumn]=getValue(translatePropKey(props[prop].fkcolumn));
				}
				var subItems=evaluate('getBean(variables.entityName).loadBy(argumentCollection=loadArgs).get#prop#Iterator()');
				while(subItems.hasNext()){
					subitem=subitems.next();
					if(!subitem.getIsNew()){
						subItem.setDeletedParentID(getValue(getPrimaryKey()));
						subitem.delete();
					}
				}
			}
		}

		var qs=getQueryService();
		qs.addParam(name='primarykey',value=variables.instance[getPrimaryKey()],cfsqltype='cf_sql_varchar');
		qs.execute(sql='delete from #getTable()# where #getPrimaryKey()# = :primarykey');
		purgeCache();

		postDelete();

		pluginManager.announceEvent('onAfter#variables.entityName#Delete',event);

		if(getUseTrash()){
			getBean('trashManager').throwIn(this);
		}

		return this;
	}

	function loadBy(returnFormat="self"){
		var qs=getQueryService();
		var sql="";
		var props=getProperties();
		var prop="";
		var columns=getColumns();
		var started=false;
		var rs="";
		var hasArg=false;
		var hasdiscriminator=len(getDiscriminatorColumn());
		var discriminatorColumn=getDiscriminatorColumn();
		var foundDiscriminator=false;
		var primaryOnly=true;
		var primaryFound=false;
		var primarykeyargvalue='';

		savecontent variable="sql"{
			writeOutput(getLoadSQL());
			for(var arg in arguments){
				hasArg=false;
				prop=arg;

				if(structKeyExists(props,arg) or arg eq 'primarykey'){
					hasArg=true;
				} else if (structKeyExists(columns,arg)) {
					for(prop in props){
						if(props[prop].column eq arg){
							hasArg=true;
							break;
						}
					}
				}

				if(hasArg){
					if(arg eq 'primarykey'){
						arg=getPrimaryKey();
						prop=arg;
					}

					if(
						arg != getPrimaryKey() 
						&& arg != 'siteid'
						&& !(hasDiscriminator && arg==discriminatorColumn)
					){
						primaryOnly=false;
					} else if(arg == getPrimaryKey() && len(arguments[arg])){
						primaryFound=true;
						primarykeyargvalue=arguments[arg];
					}

					if(hasdiscriminator && !foundDiscriminator && arg==discriminatorColumn){
						foundDiscriminator=true;
					}

					addQueryParam(qs,props[prop],arguments[arg]);

					if(not started){
						writeOutput("where ");
						started=true;
					} else {
						writeOutput("and ");
					}

					writeOutput(" #getTable()#.#arg#= :#arg# ");
				}

				if(hasDiscriminator && !foundDiscriminator){
					if(not started){
						writeOutput("where ");
						started=true;
					} else {
						writeOutput("and ");
					}

					writeOutput(" #getTable()#.#discriminatorColumn#= :#getDiscriminatorValue()# ");
				}	
			}

			if(structKeyExists(arguments,'orderby')){
				writeOutput("order by #arguments.orderby# ");	
			}
		}
		
		if(primaryFound && primaryOnly && getUseCache()){
			var cache=getCache();
			var cacheKey=getCacheKey(primarykeyargvalue);
			
			if(cache.has(cacheKey)){
				try{
					rs=cache.get(cacheKey);
					setValue("frommuracache",true);
					commitTracePoint(initTracePoint(detail="DATA CACHE HIT: {class: #getEntityName()#, key: #cacheKey#}"));
				} catch(any e){
					rs=qs.execute(sql=sql).getResult();
					if(rs.recordcount){
						cache.get(cacheKey,rs);
					}
					commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: #getEntityName()#, key: #cacheKey#}"));
				}
			} else {
				rs=qs.execute(sql=sql).getResult();
				if(rs.recordcount){
					cache.get(cacheKey,rs);
				}
				commitTracePoint(initTracePoint(detail="DATA CACHE MISS: {class: #getEntityName()#, key: #cacheKey#}"));
			}
		} else {
			rs=qs.execute(sql=sql).getResult();
		}

		if(rs.recordcount){
			set(rs);
		} else {
			set(arguments);
		}

		if(arguments.returnFormat eq 'query'){
			return rs;
		} else if( arguments.returnFormat eq 'iterator'){	
			return getBean('beanIterator').setEntityName(variables.entityName).setQuery(rs);
		} else {
			return this;
		}
	}

	private function getLoadSQL(){
		return "select * from #getTable()# ";
	}

	function clone(){
		return getBean(variables.entityName).setAllValues(structCopy(getAllValues()));
	}

	function getFeed(){		
		var feed=getBean('beanFeed').setEntityName(variables.entityName).setTable(getTable());
	
		if(hasProperty('siteid')){
			feed.setSiteID(getValue('siteID'));
		}

		return feed;	
	}

	//BUNDLE METHODS
	
	function getIterator(){		
		return getBean('beanIterator').setEntityName(variables.entityName);
	}

	function toBundle(bundle,siteid){
		var qs=getQueryService();
		
		if(hasColumn('siteid') && structKeyExists(arguments,'siteid')){
			qs.setSQL("select * from #getTable()# where siteid = :siteid");
			qs.addParam(name="siteid",cfsqltype="cf_sql_varchar",value=arguments.siteid);
			arguments.bundle.setValue("rs" & getTable(),qs.execute().getResult());
		} else {
			arguments.bundle.setValue("rs" & getTable(),qs.execute(sql="select * from #getTable()#").getResult());
		}
		return this;
	}

	function fromBundle(bundle,keyFactory,siteid){
		var rs=arguments.bundle.getValue('rs' & getTable());
		var item='';
		var prop='';

		if(isQuery(rs) && rs.recordcount){
			var it=getIterator().setQuery(rs);

			while (it.hasNext()){
				item=it.next();

				if(structKeyExists(arguments, "siteid") && len(arguments.siteid) && item.hasProperty('siteid')){
					item.setValue('siteid',arguments.siteid);
				}

				for(prop in getProperties()){
					if(isValid('uuid',item.getValue(prop))){
						item.setValue(prop,arguments.keyFactory.get(item.getValue(prop)));
					}

				}

				item.save();
			
			}


		}
	}

	//CACHING METHODS

	function getCacheName(){
		return application.objectMappings[variables.entityName].cachename;
	}

	function getCache(){
		return getBean('settingsManager').getSite(getCacheSiteID()).getCacheFactory(name=getCacheName());
	}

	function getUseCache(){
		return getBean('settingsManager').getSite(getCacheSiteID()).getCache();
	}

	function purgeCache(){
		var cacheKey=getCacheKey();
		getCache().purge(key=cacheKey);
		getBean('clusterManager').purgeCacheKey(cacheName=getCacheName(),cacheKey=cacheKey,siteid=getCacheSiteID());
	}

	function getCacheKey(primarykey){
		if(structKeyExists(arguments,'primarykey')){
			return getEntityName() & arguments.primarykey;
		} else {
			return getEntityName() & getValue(getPrimaryKey());
		}
	}

	function getCacheSiteID(){
		if(len(getValue('siteid'))){
			return getValue('siteid');
		} else {
			param name="session.siteid" default="default";
			return session.siteid;
		}
	}

	function hasColumn(column){
		return isDefined("application.objectMappings.#getValue('entityName')#.columns.#arguments.column#");
	}

	//ORM EVENTHANDLING

	private function preLoad(){};
	private function postLoad(){};
	private function preUpdate(){};
	private function postUpdate(){};
	private function preCreate(){};
	private function preInsert(){};
	private function postCreate(){};
	private function postInsert(){};
	private function preDelete(){};
	private function postDelete(){};

}