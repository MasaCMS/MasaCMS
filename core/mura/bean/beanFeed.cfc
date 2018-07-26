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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" output="false" hint="This is provides base feed functionality for all entities">

<cfproperty name="entityName" type="string" default="">
<cfproperty name="table" type="string" default="">
<cfproperty name="keyField" type="string" default="">
<cfproperty name="nextN" type="numeric" default="0" required="true">
<cfproperty name="maxItems" type="numeric" default="1000" required="true">
<cfproperty name="siteID" type="string" default="">
<cfproperty name="contentpoolid" type="string" default="">
<cfproperty name="sortBy" type="string" default="">
<cfproperty name="sortDirection" type="string" default="asc" required="true">
<cfproperty name="orderby" type="string" default="">
<cfproperty name="additionalColumns" type="string" default="">
<cfproperty name="sortTable" type="string" default="">
<cfproperty name="pageIndex" type="numeric" default="1">

<cfscript>
function init() output=false {
	variables.instance={};
	variables.instance.isNew=1;
	variables.instance.errors={};
	variables.instance.fromMuraCache = false;
	if ( !structKeyExists(variables.instance,"instanceID") ) {
		variables.instance.instanceID=createUUID();
	}
	variables.instance.addObjects=[];
	variables.instance.removeObjects=[];
	variables.instance.siteID="";
	variables.instance.contentPoolID="";
	variables.instance.entityName="";
	variables.instance.fields="";
	variables.instance.distinct=false;
	variables.instance.table="";
	variables.instance.keyField="";
	variables.instance.sortBy="";
	variables.instance.sortDirection="asc";
	variables.instance.orderby="";
	variables.instance.tableFieldLookUp=structNew();
	variables.instance.tableFieldlist="";
	variables.instance.nextN=1000;
	variables.instance.maxItems=0;
	variables.instance.pageIndex=1;
	variables.instance.additionalColumns="";
	variables.instance.sortTable="";
	variables.instance.fieldAliases={};
	variables.instance.cachedWithin=createTimeSpan(0,0,0,0);
	variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" );
	variables.instance.joins=arrayNew(1);
	variables.instance.pendingParam={};
	variables.instance.sumValArray=[];
	variables.instance.countValArray=[];
	variables.instance.avgValArray=[];
	variables.instance.minValArray=[];
	variables.instance.maxValArray=[];
	variables.instance.groupByArray=[];

	return this;
}

function getEntityName() output=false {
	return variables.instance.entityName;
}

function setEntityName(entityName) output=false {
	variables.instance.entityName=arguments.entityName;
	return this;
}

function getOrderBy() output=false {
	return variables.instance.orderby;
}

function setOrderBy(orderby) output=false {
	variables.instance.orderby=arguments.orderby;
	return this;
}

function getContentPoolID() output=false {
	if ( !len(variables.instance.contentpoolid) ) {
		variables.instance.contentpoolid=variables.instance.siteid;
	} else if ( variables.instance.contentpoolid == '*' ) {
		variables.instance.contentpoolid=getBean('settingsManager').getSite(variables.instance.siteid).getContentPoolID();
	}
	return variables.instance.contentpoolid;
}

function getSort() output=false {
	return variables.instance.orderby;
}

function setSort(sort) output=false {
	setOrderBy(orderby=arguments.sort);
	return this;
}

function setSortDirection(any sortDirection) output=false {
	if ( listFindNoCase('desc,asc',arguments.sortDirection) ) {
		variables.instance.sortDirection = arguments.sortDirection;
	}
	return this;
}

function setItemsPerPage(itemsPerPage) output=false {
	setNextN(nextN=arguments.itemsPerPage);
	return this;
}

function getItemsPerPage() output=false {
	return variables.instance.NextN;
}

function setNextN(any NextN) output=false {
	if ( isNumeric(arguments.nextN) ) {
		variables.instance.NextN = arguments.NextN;
	}
	return this;
}

function setMaxItems(any maxItems) output=false {
	if ( isNumeric(arguments.maxItems) ) {
		variables.instance.maxItems = arguments.maxItems;
	}
	return this;
}

function setFields(fields) output=false {
	loadTableMetaData();

	if(len(arguments.fields)){
		var tempArray=[];
		for(var p in listToArray(arguments.fields)){
			if(structKeyExists(application.objectMappings[getEntityName()].columns,trim(p))){
				arrayAppend(tempArray,transformFieldName(p));
			}
		}
	}
	variables.instance.fields=arrayToList(tempArray);
	return this;
}

function setDistinct(distinct=true) output=false {
	variables.instance.distinct=arguments.distinct;
	return this;
}

function getFields() output=false {
	return variables.instance.fields;
}

function getDistinct() output=false {
	return variables.instance.distinct;
}

function loadTableMetaData() output=false {
	var rs="";
	var temp="";
	var i="";
	if ( !structKeyExists(application.objectMappings, variables.instance.entityName) ) {
		application.objectMappings[variables.instance.entityName] = structNew();
	}
	if ( !structKeyExists(application.objectMappings[variables.instance.entityName], "columns") ) {
		application.objectMappings[variables.instance.entityName].columns = getBean('dbUtility').columns(table=variables.instance.table);
	}
	if ( !structKeyExists(application.objectMappings[variables.instance.entityName], "columnlist") ) {
		application.objectMappings[variables.instance.entityName].columnlist = structKeyList(application.objectMappings[variables.instance.entityName].columns);
	}
}

function getTableFieldList() output=false {
	loadTableMetaData();
	return application.objectMappings[variables.instance.entityName].columnlist;
}

function formatField(field) output=false {
	loadTableMetaData();
	if ( structKeyExists(application.objectMappings[variables.instance.entityName].columns,arguments.field) ) {
		arguments.field="#variables.instance.table#.#arguments.field#";
	}
	return arguments.field;
}

function setConfigBean(configBean) output=false {
	variables.configBean=arguments.configBean;
	return this;
}

function setAdvancedParams(required any params) output=false {
	return setParams(argumentCollection=arguments);
}

function setParams(required any params) output=false {
	var rows=0;
	var I = 0;
	if ( isquery(arguments.params) ) {
		variables.instance.params=arguments.params;
	} else if ( isdefined('arguments.params.param') ) {
		clearparams();
		for ( i=1 ; i<=listLen(arguments.params.param) ; i++ ) {
			addParam(
						listFirst(arguments.params['paramField#i#'],'^'),
						arguments.params['paramRelationship#i#'],
						arguments.params['paramCriteria#i#'],
						arguments.params['paramCondition#i#'],
						listLast(arguments.params['params.paramField#i#'],'^')
						);
		}
	} else if ( isdefined('arguments.params.paramarray') && isArray(arguments.params.paramarray) ) {
		clearparams();
		for ( i=1 ; i<=arrayLen(arguments.params.paramarray) ; i++ ) {
			addParam(
						listFirst(arguments.params.paramarray[i].field,'^'),
						arguments.params.paramarray[i].relationship,
						arguments.params.paramarray[i].criteria,
						arguments.params.paramarray[i].condition,
						listLast(arguments.params.paramarray[i].field,'^')
						);
		}
	}
	if ( isStruct(arguments.params) ) {
		if ( structKeyExists(arguments.params,"siteid") ) {
			setSiteID(arguments.params.siteid);
		}
	}
	return this;
}

function addParam(required string field="", required string relationship="and", required string criteria="", required string condition="EQUALS", required string datatype="") output=false {
	var rows=1;

	if ( structKeyExists(arguments,'column') ) {
		arguments.field=arguments.column;
	}
	if ( structKeyExists(arguments,'name') ) {
		arguments.field=arguments.name;
	}
	if ( structKeyExists(arguments,'value') ) {
		arguments.criteria=arguments.value;
	}

	if(isValid('variablename',arguments.field) && isdefined('set#arguments.field#')){
			setValue(arguments.field,arguments.criteria);
			return this;
	}

	if ( structKeyExists(variables.instance.fieldAliases,arguments.field) ) {
		arguments.datatype=variables.instance.fieldAliases[arguments.field].datatype;
		arguments.field=variables.instance.fieldAliases[arguments.field].field;
	}
	if ( !len(arguments.dataType) ) {
		loadTableMetaData();
		if ( !structKeyExists(variables, "dbUtility") ) {
			variables.dbUtility = getBean('dbUtility');
		}
		var tempField=listLast(arguments.field,'.');
		if ( structKeyExists(application.objectMappings[variables.instance.entityName].columns,tempField) ) {
			arguments.dataType=variables.dbUtility.transformParamType(application.objectMappings[variables.instance.entityName].columns[tempField].dataType);
		} else {
			arguments.dataType="varchar";
		}
	}
	queryAddRow(variables.instance.params,1);
	rows = variables.instance.params.recordcount;
	querysetcell(variables.instance.params,"param",rows,rows);
	querysetcell(variables.instance.params,"field",formatField(arguments.field),rows);
	querysetcell(variables.instance.params,"relationship",arguments.relationship,rows);
	querysetcell(variables.instance.params,"criteria",arguments.criteria,rows);
	querysetcell(variables.instance.params,"condition",arguments.condition,rows);
	querysetcell(variables.instance.params,"dataType",arguments.datatype,rows);
	return this;
}

function addAdvancedParam(required string field="", required string relationship="and", required string criteria="", required string condition="EQUALS", required string datatype="") output=false {
	return addParam(argumentCollection=arguments);
}

function getAdvancedParams() {
	return getParams();
}

function getParams() {
	return variables.instance.params;
}

function clearAdvancedParams() {
	variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" );
	return this;
}

function clearParams() {
	return clearAdvancedParams();
}

function addJoin(required string joinType="inner", required string table="", required string clause="") output=false {
	if ( !hasJoin(arguments.table) ) {
		arrayAppend(variables.instance.joins, arguments);
	}
	return this;
}

function getJoins() {
	return variables.instance.joins;
}

function clearJoins() {
	variables.instance.joins=arrayNew(1);
	return this;
}

function hasJoin(table) {
	var join = "";
	for ( join in getJoins() ) {
		if ( arguments.table == join.table ) {
			return true;
		}
	}
	return false;
}

function getDbType() output=false {
	if ( structKeyExists(application.objectMappings,variables.instance.entityName) && structKeyExists(application.objectMappings[variables.instance.entityName],'dbtype') ) {
		return application.objectMappings[variables.instance.entityName].dbtype;
	} else {
		return variables.configBean.getDbType();
	}
}

function hasColumn(column) output=false {
	return isDefined("application.objectMappings.#getValue('entityName')#.columns.#arguments.column#");
}

function hasDiscriminatorColumn() output=false {
	return isDefined("application.objectMappings.#getValue('entityName')#.discriminatorColumn") && len(application.objectMappings[getValue('entityName')].discriminatorColumn);
}

function getIsHistorical() output=false {
	return isDefined("application.objectMappings.#getValue('entityName')#.historical") && IsBoolean(application.objectMappings[getValue('entityName')].historical) && application.objectMappings[getValue('entityName')].historical;
}

function getDiscriminatorColumn() output=false {
	return application.objectMappings[getValue('entityName')].discriminatorColumn;
}

function getDiscriminatorValue() output=false {
	return application.objectMappings[getValue('entityName')].discriminatorValue;
}

function hasCustomDatasource() output=false {
	return structKeyExists(application.objectMappings,variables.instance.entityName) && structKeyExists(application.objectMappings[variables.instance.entityName],'datasource');
}

function getCustomDatasource() output=false {
	return application.objectMappings[variables.instance.entityName].datasource;
}

function getQueryAttrs(cachedWithin="#variables.instance.cachedWithin#") output=false {
	arguments.readOnly=true;
	return super.getQueryAttrs(argumentCollection=arguments);
}

function getQueryService(cachedWithin="#variables.instance.cachedWithin#") output=false {
	arguments.readOnly=true;
	return super.getQueryService(argumentCollection=arguments);
}

function getIterator(cachedWithin="#variables.instance.cachedWithin#") output=false {
	var rs=getQuery(argumentCollection=arguments);
	var it='';

	//When selecting distinct generic iterators and beans are used
	if(!getDistinct() && !isAggregateQuery()){
		if ( getServiceFactory().containsBean("#variables.instance.entityName#Iterator") ) {
			it=getBean("#variables.instance.entityName#Iterator");
		} else {
			it=getBean("beanIterator");
		}
		it.setEntityName(getValue('entityName'));
	} else {
		it=getBean("beanIterator");
	}

	it.setQuery(rs);
	it.setFeed('feed',this);
	it.setPageIndex(getValue('pageIndex'));
	it.setItemsPerPage(getItemsPerPage());
	return it;
}

function getAvailableCount() output=false {
	return getQuery(countOnly=true).count;
}

function clone() output=false {
	return getBean("beanFeed").setAllValues(structCopy(getAllValues()));
}

function where(property) output=false {
	if ( isDefined('arguments.propery') ) {
		andProp(argumentCollection=arguments);
	}
	return this;
}

function prop(property) output=false {
	andProp(argumentCollection=arguments);
	return this;
}

function andProp(property) output=false {
	variables.instance.pendingParam.relationship='and';
	variables.instance.pendingParam.column=transformFieldName(arguments.property);
	return this;
}

function orProp(property) output=false {
	variables.instance.pendingParam.relationship='or';
	variables.instance.pendingParam.column=transformFieldName(arguments.property);
	return this;
}

function isEQ(criteria) output=false {
	variables.instance.pendingParam.condition='eq';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isNEQ(criteria) output=false {
	variables.instance.pendingParam.condition='neq';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isGT(criteria) output=false {
	variables.instance.pendingParam.condition='gt';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isGTE(criteria) output=false {
	variables.instance.pendingParam.condition='gte';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isLT(criteria) output=false {
	variables.instance.pendingParam.condition='lt';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isLTE(criteria) output=false {
	variables.instance.pendingParam.condition='lte';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isIn(criteria) output=false {
	variables.instance.pendingParam.condition='in';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function isNotIn(criteria) output=false {
	variables.instance.pendingParam.condition='notin';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function containsValue(criteria) output=false {
	variables.instance.pendingParam.condition='contains';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function beginsWith(criteria) output=false {
	variables.instance.pendingParam.condition='begins';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function endsWith(criteria) output=false {
	variables.instance.pendingParam.condition='ends';
	variables.instance.pendingParam.criteria=arguments.criteria;
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function null() output=false {
	variables.instance.pendingParam.condition='=';
	variables.instance.pendingParam.criteria='null';
	addParam(argumentCollection=variables.instance.pendingParam);
	variables.instance.pendingParam={};
	return this;
}

function openGrouping() output=false {
	addParam(relationship='andOpenGrouping');
	variables.instance.pendingParam={};
	return this;
}

function andOpenGrouping() output=false {
	return openGrouping();
}

function orOpenGrouping() output=false {
	addParam(relationship='orOpenGrouping');
	variables.instance.pendingParam={};
	return this;
}

function closeGrouping() output=false {
	addParam(relationship='closeGrouping');
	variables.instance.pendingParam={};
	return this;
}

function sort(property, direction) output=false {
	//  default sort direction ASC for everything *except* mxpRelevance, which should be DESC so the highest point values are first.
	if ( !StructKeyExists( arguments, "direction" ) ) {
		if ( arguments.property == "mxpRelevance" ) {
			arguments.direction = "desc";
		} else {
			arguments.direction = "asc";
		}
	}
	variables.instance.orderby=listAppend(variables.instance.orderby, transformFieldName(arguments.property) & ' ' & arguments.direction);
	return this;
}

function itemsPerPage(itemsPerPage) output=false {
	setNextN(arguments.itemsPerPage);
	return this;
}

function maxItems(maxItems) output=false {
	setMaxItems(arguments.maxItems);
	return this;
}

function fields(fields) output=false {
	return setFields(arguments.fields);
}

function distinct(distinct=true) output=false {
	return setDistinct(arguments.distinct);
}

function getEntity() output=false {
	if ( !isdefined('variables.sampleEntity') ) {
		variables.sampleEntity=getBean(getEntityName());
	}
	return variables.sampleEntity;
}

function innerJoin(relatedEntity) output=false {
	var entity=getEntity();
	var p="";
	for ( p in entity.getHasManyPropArray() ) {
		if ( p.cfc == arguments.relatedEntity ) {
			addJoin('inner',application.objectMappings[arguments.relatedEntity].table,'#entity.getTable()#.#entity.translatePropKey(p.column)#=#application.objectMappings[arguments.relatedEntity].table#.#entity.translatePropKey(p.loadkey)#');
			return this;
		}
	}
	for ( p in entity.getHasOnePropArray() ) {
		if ( p.cfc == arguments.relatedEntity ) {
			addJoin('inner',application.objectMappings[arguments.relatedEntity].table,'#entity.getTable()#.#entity.translatePropKey(p.column)#=#application.objectMappings[arguments.relatedEntity].table#.#entity.translatePropKey(p.loadkey)#');
			return this;
		}
	}
	return this;
}

function leftJoin(entityName) output=false {
	var entity=getEntity();
	var p="";
	for ( p in entity.getHasManyPropArray() ) {
		if ( p.cfc == arguments.relatedEntity ) {
			addJoin('left',application.objectMappings[arguments.relatedEntity].table,'#entity.getTable()#.#entity.getValue(entity.translatePropKey(p.column))#=#application.objectMappings[arguments.relatedEntity].table#.#entity.translatePropKey(p.loadkey)#');
			return this;
		}
	}
	for ( p in entity.getHasOnePropArray() ) {
		if ( p.cfc == arguments.relatedEntity ) {
			addJoin('left',application.objectMappings[arguments.relatedEntity].table,'#entity.getTable()#.#entity.getValue(entity.translatePropKey(p.column))#=#application.objectMappings[arguments.relatedEntity].table#.#entity.translatePropKey(p.loadkey)#');
			return this;
		}
	}
	return this;
}

function groupBy(property) output=false {
	if(len(trim(arguments.property))){
		for(var p in listToArray(arguments.property)){
			arrayAppend(variables.instance.groupByArray,transformFieldName(p));
		}
	}
	return this;
}

function aggregate(type,property) output=false {
	if(len(trim(arguments.property))){
		switch(arguments.type){
			case 'sum':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.sumValArray,transformFieldName(p));
			}
			break;
			case 'count':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.countValArray,transformFieldName(p));
			}
			break;
			case 'avg':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.avgValArray,transformFieldName(p));
			}
			break;
			case 'min':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.minValArray,transformFieldName(p));
			}
			break;
			case 'max':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.maxValArray,transformFieldName(p));
			}
			break;
			case 'groupby':
			for(var p in listToArray(arguments.property)){
				arrayAppend(variables.instance.groupByArray,transformFieldName(p));
			}
			break;
		}
	}
	return this;
}

function transformFields(fields){
	return arguments.fields;
}

function transformFieldName(fieldname){
	arguments.fieldname=trim(arguments.fieldname);

	if(arguments.fieldname==application.objectMappings[getEntityName()].table & ".*"){
		return arguments.fieldname;
	}

	if ( listLen(arguments.fieldname,'.') == 2 ) {
		var fieldArray=listToArray(arguments.fieldname,'.');
		if(structKeyExists(application.objectMappings,fieldArray[1])){
			arguments.fieldname=application.objectMappings[fieldArray[1]].table & '.' & fieldArray[2];
		}
	} else if(structKeyExists(application.objectMappings[getEntityName()],arguments.fieldname)){
		arguments.fieldname=application.objectMappings[getEntityName()].table & '.' & arguments.fieldname;
	}

	return arguments.fieldname;
}

function isAggregateQuery(){
	if(isDefined('url.fields') && len(url.fields)){
		return false;
	}
	for(var i in ['minValArray','maxValArray','avgValArray','sumValArray','countValArray','groupByArray']){
		if(arrayLen(variables.instance[i])){
			return true;
		}
	}

	return false;
}

private function caseInsensitiveOrderBy(required orderBy) output=false {
	var orderByList = "";
	var orderByValue = "";
	var table = "";
	var column = "";

	for(orderByValue in listToArray(arguments.orderby)){
		table = getEntity().getTable();
		column = listfirst(orderByValue, " ");
		if ( listlen(column, ".") == 2 ) {
			table = listfirst(column, ".");
			column = listrest(column, ".");
		}
		if ( len(column) && structkeyexists(application.objectMappings, table) && structkeyexists(application.objectMappings[table]["columns"], column) && listfindnocase("char,varchar", application.objectMappings[table]["columns"][column]["dataType"]) ) {
			orderByList = listappend(orderByList, "lower(" & column & ") " & listrest(orderByValue, " "));
		} else {
			orderByList = listappend(orderByList, orderByValue);
		}
	}

	return orderByList;
}

function sanitizedValue(value) output=false {
	return REReplace(value,"[^0-9A-Za-z\._,\- ]\*","","all");
}

function getOffset() output=false {
	return (getValue('pageIndex')-1) * getValue('nextN');
}

function getFetch() output=false {
	return getValue('nextN');
}

function getStartRow() output=false {
	return getOffset() +1;
}

function getEndRow() output=false {
	var endrow=getOffset()+getValue('nextN');
	if ( endrow > getValue('maxItems') ) {
		endrow=getValue('maxItems');
	}
	return endrow;
}
</cfscript>

<cffunction name="getQuery" output="false">
	<cfargument name="countOnly" default="false">
	<cfargument name="cachedWithin" default="#variables.instance.cachedWithin#">

	<cfset var rs="">
	<cfset var isListParam=false>
	<cfset var param="">
	<cfset var started=false>
	<cfset var openGrouping=false>
	<cfset var jointable="">
	<cfset var jointableS="">
	<cfset var dbType=getDbType()>
	<cfset var tableModifier="">
	<cfset var transformCriteria="">

	<cfif getDbType() eq "MSSQL">
		<cfset tableModifier="with (nolock)">
	</cfif>

	<cfif hasDiscriminatorColumn()>
		<cfset addParam(column=hasDiscriminatorColumn(),criteria=hasDiscriminatorValue())>
	</cfif>

	<cfloop query="variables.instance.params">
		<cfif listLen(variables.instance.params.field,".") eq 2>
			<cfset jointable=REReplace(listFirst(variables.instance.params.field,"."),"[^0-9A-Za-z\._,\- ]","","all") >
			<cfif jointable neq variables.instance.table and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery attributeCollection="#getQueryAttrs(name='rs',cachedWithin=arguments.cachedWithin)#">
		<cfif not arguments.countOnly and dbType eq "oracle" and variables.instance.maxItems>select * from (</cfif>
		select
		<cfif getDistinct()>distinct</cfif>
		<cfif not arguments.countOnly and dbtype eq "mssql" and variables.instance.maxItems>top #val(variables.instance.maxItems)#</cfif>

		<cfif not arguments.countOnly>
			<cfif len(getFields())>
				#sanitizedValue(transformFields(getFields()),"[^0-9A-Za-z\._,\- ]","","all")#
				from #variables.instance.table#
			<cfelseif isAggregateQuery()>
				<cfset started=false>
				<cfif arrayLen(variables.instance.groupByArray)>
					<cfloop array="#variables.instance.groupByArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						#sanitizedValue(local.i)#
					</cfloop>
				</cfif>
				<cfif arrayLen(variables.instance.sumValArray)>
					<cfloop array="#variables.instance.sumValArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						sum(#sanitizedValue(local.i)#) as sum_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfif arrayLen(variables.instance.countValArray)>
					<cfloop array="#variables.instance.countValArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						 <cfif listLast(local.i,'.') eq '*'>count(*) as count<cfelse>count(#sanitizedValue(local.i)#) as count_#sanitizedValue(listLast(local.i,'.'))#</cfif>
					</cfloop>
				</cfif>
				<cfif arrayLen(variables.instance.avgValArray)>
					<cfloop array="#variables.instance.avgValArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						avg(#sanitizedValue(local.i)#) as avg_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfif arrayLen(variables.instance.minValArray)>
					<cfloop array="#variables.instance.minValArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						min(#sanitizedValue(local.i)#) as min_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfif arrayLen(variables.instance.maxValArray)>
					<cfloop array="#variables.instance.maxValArray#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						max(#sanitizedValue(local.i)#) as max_#sanitizedValue(listLast(local.i,'.'))#
					</cfloop>
				</cfif>
				<cfset started=false>
				from #variables.instance.table#
			<cfelseif len(getEntity().getLoadSQLColumnsAndTables())>
				<cfset loadTableMetaData()>
				#getEntity().getLoadSQLColumnsAndTables()#
			<cfelse>
				#getTableFieldList()#
				from #variables.instance.table#
			</cfif>

		<cfelse>
			count(*) as count from #variables.instance.table#
		</cfif>

		<cfif getIsHistorical()>
			<cfset var primaryKey=getEntity().getPrimaryKey()>

			inner join (
				select #primaryKey# primarykey, max(lastupdate) lastupdatemax from #variables.instance.table#
				where
			  	lastupdate <= <cfif isDate(request.muraPointInTime)>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#request.muraPointInTime#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							</cfif>
				group by #primaryKey#

			) activeTable
			 on (
			 	#variables.instance.table#.#primaryKey#=activeTable.primarykey
				and #variables.instance.table#.lastupdate=activeTable.lastupdatemax
			 )
		</cfif>

		<!--- Join to implied tables based on field prefix --->
		<cfloop list="#jointables#" index="jointable">
			<cfif not hasJoin(jointable)>
				inner join #jointable# on (#variables.instance.table#.#variables.instance.keyField#=#jointable#.#variables.instance.keyField#)
			</cfif>
		</cfloop>

		<!--- Join to explicit tables based on join clauses --->
		<cfloop from="1" to="#arrayLen(variables.instance.joins)#" index="local.i">
			<cfif len(variables.instance.joins[local.i].clause)>
				#variables.instance.joins[local.i].jointype# join #variables.instance.joins[local.i].table# #tableModifier# on (#variables.instance.joins[local.i].clause#)
			</cfif>
		</cfloop>

		where

		<cfif
			(not isDefined('application.objectMappings.#getValue('entityName')#.columns') and len(variables.instance.siteID))
			or
			 (hasColumn('siteid') and len(variables.instance.siteID))>
			#variables.instance.table#.siteID in (<cfqueryparam cfsqltype="cf_sql_varchar" list=true value="#getContentPoolID()#"/>)
		<cfelse>
			1=1
		</cfif>

		<cfif variables.instance.params.recordcount>
		<cfset started = false>
		<cfloop query="variables.instance.params">
			<cfset param=createObject("component","mura.queryParam").init(variables.instance.params.relationship,
					variables.instance.params.field,
					variables.instance.params.dataType,
					variables.instance.params.condition,
					variables.instance.params.criteria
				) />

			<cfif param.getIsValid()>
				<cfif not started >
					<cfset openGrouping=true />
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					<cfif not openGrouping>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
					<cfif not openGrouping>or</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
					<cfif not openGrouping>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("and not (",param.getRelationship())>
					<cfif not openGrouping>and</cfif> not (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("or not (",param.getRelationship())>
				 	<cfif not openGrouping>or</cfif> not (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
					)
					<cfset openGrouping=false>
				<cfelseif not openGrouping>
					#param.getRelationship()#
				</cfif>

				<cfset started = true />
				<cfset isListParam=listFindNoCase("IN,NOT IN,NOTIN",param.getCondition())>

				<cfif len(param.getField())>
					#param.getFieldStatement()#
					<cfif param.getCriteria() eq 'null'>
						#param.getCondition()# NULL
					<cfelse>
						#param.getCondition()#

						<!---
							Support to recognize if the param criteria is prefix with a table or entityname
							Vague CF10 support
						--->
						<cfif listLen(param.getCriteria(),'.') eq 2>
							<cfset transformCriteria=listToArray(param.getCriteria(),'.')>
							<!--- Check if it's an entity make sure schema data is loaded --->
							<cfif getServiceFactory().containsBean('#transformCriteria[1]#')>
								<cfset local.related=getBean('#transformCriteria[1]#')>
								<cfif isDefined('local.related.getFeed')>
									<cfset local.related.getFeed().loadTableMetaData()>
								</cfif>
							</cfif>
							<!--- Is it the name of an entity --->
							<cfif structKeyExists(application.objectMappings,'#transformCriteria[1]#') and structKeyExists(application.objectMappings['#transformCriteria[1]#'].columns,'#transformCriteria[2]#')>
								#application.objectMappings['#transformCriteria[1]#'].table#.#sanitizedValue(transformCriteria[2])#
							<cfelse>
								<!--- Is it the name of table that has been joined --->
								<cfif application.objectMappings[ getEntityName()].table eq transformCriteria[1] or hasJoin(transformCriteria[1])>
									#transformCriteria[1]#.#sanitizedValue(transformCriteria[2])#
								<cfelse>
									<cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>
								</cfif>
							</cfif>
						<cfelse>
							<cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>
						</cfif>
					</cfif>
					<cfset openGrouping=false>
				</cfif>
			</cfif>
		</cfloop>
		<cfif started>)</cfif>
	</cfif>

	<cfif getIsHistorical()>
		and #variables.instance.table#.deleted=0
	</cfif>

	<cfset started=false>
	<cfif arrayLen(variables.instance.groupByArray)>
		group by
		<cfloop array="#variables.instance.groupByArray#" index="local.i">
			<cfif started>, <cfelse><cfset started=true></cfif>
			#sanitizedValue(local.i)#
		</cfloop>
	</cfif>
	<cfset started=false>

	<cfif not arguments.countOnly>
		<cfif len(variables.instance.orderby)>
			order by #caseInsensitiveOrderBy(REReplace(variables.instance.orderby,"[^0-9A-Za-z\._,\-%//""'' ]","","all"))#
			<cfif listFindNoCase("oracle,postgresql", dbType)>
				<cfif lcase(listLast(variables.instance.orderby, " ")) eq "asc">
					NULLS FIRST
				<cfelse>
					NULLS LAST
				</cfif>
			</cfif>
		<cfelseif len(variables.instance.sortBy)>
			order by #caseInsensitiveOrderBy(REReplace("#variables.instance.table#.#variables.instance.sortby# #variables.instance.sortDirection#","[^0-9A-Za-z\._,\- ]","","all"))#
			<cfif listFindNoCase("oracle,postgresql", dbType)>
				<cfif variables.instance.sortDirection eq "asc">
					NULLS FIRST
				<cfelse>
					NULLS LAST
				</cfif>
			</cfif>
		</cfif>

		<cfif listFindNoCase("mysql,postgresql", dbType) and variables.instance.maxItems>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>
		<cfif dbType eq "nuodb" and variables.instance.maxItems>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /></cfif>
		<cfif dbType eq "oracle" and variables.instance.maxItems>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>
	</cfif>

	</cfquery>

	<cfreturn rs>
</cffunction>

</cfcomponent>
