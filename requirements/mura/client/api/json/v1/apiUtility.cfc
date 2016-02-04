component extends="mura.cfobject" {
	/*
	FindOne: GET /_api/json/v1/:siteid/:entityName/:id => /_api/json/v1/?method=findOne&entityName=:entityname&siteid=:siteid&id=:id
	FindRelatedEntity: GET /_api/json/v1/:siteid/:entityName/:id/:relatedEntity/$ => /_api/json/v1/?method=findQuery&entityName=:relatedEntity&siteid=:siteid&:entityNameFK=:id
	FinNew: GET /_api/json/v1/:siteid/:entityName/new => /_api/json/v1/?method=findNew&entityName=:entityname&siteid=:siteid
	FindQuery: GET /_api/json/v1/:siteid/:entityName/$ => /_api/json/v1/?method=findQuery&entityName=:entityname&siteid=:siteid
	FindMany: GET /_api/json/v1/:siteid/:entityName/:ids/$ => /_api/json/v1/?method=findMany&entityName=:entityname&siteid=:siteid&ids=:ids
	Save: POST /_api/json/v1/:siteid/:entityName/ => /_api/json/v1/?method=save&entityName=:entityname&siteid=:siteid
	Delete: DELETE /_api/json/v1/:siteid/:entityName/:id => /_api/json/v1/?method=delete&entityName=:entityname&siteid=:siteid

	200 - OK - Everything went fine.
	400s - all caused by user interaction
	400 - Bad Request - The request was malformed or the data supplied by the end user was not valid. This is also used if the user has exceeded their API usage limit.
	401 - Unauthorized - The user is not authorized to access the requested resource. Additional information is typically supplied within the response to tell the end user (API consumer) how to authorize itself (ie. BASIC Authentication).
	403 - Forbidden - The user has exceeded their post limit (not bloody likely).
	404 - Not Found - The requested resource was not found.
	405 - Method Not Allowed - The user attempted to use a verb (ex. GET, POST) on a resource that had no support for the given verb.
	*/

	function init(siteid){

		variables.siteid=arguments.siteid;

		var configBean=getBean('configBean');
		var context=configBean.getContext();
		var site=getBean('settingsManager').getSite(variables.siteid);

		/*
		if( getBean('utility').isHTTPS() || YesNoFormat(site.getUseSSL()) ){
			var protocol="https://";
		} else {
			var protocol="http://";
		}

		*/

		//if(configBean.getIndexfileinurls()){
			variables.endpoint="#site.getResourcePath(complete=1)#/index.cfm/_api/json/v1/#variables.siteid#";
		/*
		} else {
			variables.endpoint="#site.getResourcePath(complete=1)#/_api/json/v1/#variables.siteid#";
		}
		*/

		variables.config={
			linkMethods=[],
			publicMethods="findOne,findMany,findAll,findNew,findQuery,save,delete,findCrumbArray,generateCSRFTokens,validateEmail,login,logout,submitForm,findCalendarItems,validate,processAsyncObject,findRelatedContent,getURLForImage",
			entities={
				'contentnav'={
					fields="parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew"
				}
			}
		};

		variables.serializer = new mura.jsonSerializer()
	      .asString('csrf_token_expires')
	      .asString('csrf_token')
	      .asString('id')
	      .asString('url')
	      .asDate('start')
	      .asDate('end')
	      .asInteger('startindex')
	      .asInteger('endindex')
	      .asInteger('itemsperpage')
	      .asInteger('endindex')
	      .asInteger('totalpages')
	      .asInteger('totalitems')
	      .asInteger('pageindex')
	      .asInteger('code')
	      .asString('title')
	      .asBoolean('saveErrors');

	    registerEntity('site',{
	    	public=true,
			fields="domain,siteid",
			allowfieldselect=false
		});

		registerEntity('content',{
			public=true,
			fields="parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew"
		});

		registerEntity('user',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('group',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('address',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('changeset',{public=true,moduleid='00000000000000000000000000000000014'});
		registerEntity('feed',{public=true,moduleid='00000000000000000000000000000000011'});
		registerEntity('category',{public=true,moduleid='00000000000000000000000000000000010'});
		registerEntity('contentCategoryAssign',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('file',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('fileMetaData',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('changesetCategoryAssignment',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('comment',{public=true,moduleid='00000000000000000000000000000000015'});
		registerEntity('stats',{public=true,moduleid='00000000000000000000000000000000000'});

		return this;
	}

	function getSerializer(){
		return variables.serializer;
	}

	function getConfig(){
		return variables.config;
	}

	function setConfig(conifg){
		variables.config=arguments.config;
		return this;
	}

	function getEntityConfig(entityName){
		if(!structKeyExists(variables.config.entities,arguments.entityName)){
			variables.config.entities[arguments.entityName]={public=false};
		}

		return variables.config.entities[arguments.entityName];
	}

	function registerMethod(methodName, method){
		if(!listFindNoCase(variables.config.publicMethods,arguments.methodName)){
			variables.config.publicMethods=listAppend(variables.config.publicMethods,arguments.methodName);
		}

		if(isDefined('arguments.method')){
			injectMethod(arguments.methodName,arguments.method);
		}

		return this;
	}

	function registerDisplayObject(displayObjectName, config){
		variables.config['#arguments.displayObjectName#']=arguments.config;

		return this;
	}


	function registerEntity(entityName, config={public=false}){

		if(!isDefined('arguments.config.public')){
			arguments.config.public=false;
		}

		variables.config.entities['#arguments.entityName#']=arguments.config;

		var properties=getBean(arguments.entityName).getProperties();
		var serializer=getSerializer();

		for(var p in properties){
			try{
				if(listFindNoCase('int,tinyint,integer',properties[p].datatype)){
					serializer.asInteger(properties[p].name);
				} else if(listFindNoCase('float,numeric,double',properties[p].datatype)){
					serializer.asFloat(properties[p].name);
				} else if(listFindNoCase('date,datetime,timestamp',properties[p].datatype)){
					serializer.asDate(properties[p].name);
				}
			} catch(Any e){}
		}
	}

	function registerLinkMethod(method){
		var name="getLinks#arrayLen(variables.config.linkMethods)#";
		arrayAppend(variables.config.linkMethods,name);
		injectMethod(name,arguments.method);

		return this;
	}

	function formatArray(_array){
		return {'items'=arguments._array};
	}

	function formatIteratorResult(iterator,returnArray,method){
		var result={};

		if(arguments.iterator.getRecordCount()){
			result={'totalItems'=arguments.iterator.getRecordCount(),
			'totalPages'=arguments.iterator.pageCount(),
			'pageIndex'=arguments.iterator.getPageIndex(),
			'items'=arguments.returnArray,
			'startindex'=arguments.iterator.getFirstRecordOnPageIndex(),
			'endindex'=arguments.iterator.getLastRecordOnPageIndex(),
			'itemsperpage'=arguments.iterator.getNextN()
		};
		} else {
			result={'totalItems'=0,
			'totalPages'=0,
			'pageIndex'=0,
			'items'=[],
			'startindex'=0,
			'endindex'=0,
			'itemsperpage'=arguments.iterator.getNextN()
		};
		}


		var baseURL=getEndPoint() & "/?";
		var params={};
		structAppend(params,url,true);
		structAppend(params,form,true);
		param name="params.method" default=arguments.method;

		if(params.method=='undefined'){
			params.method=arguments.method;
		}

		for(var u in params){
			if(u!='pageIndex'){
				baseURL= baseurl & "&#lcase(u)#=#params[u]#";
			}
		}

		var nextIndex = (result.pageIndex < result.totalPages) ? result.pageIndex+1 : 1;
		var prevIndex =(result.pageIndex > 1) ? result.pageIndex-1 : result.totalPages;

		result.links={
			'self'=baseurl & "&pageIndex=" & result.pageIndex,
			'entities'=getEndpoint()
		};

		if(result.pageIndex > 1){
			result.links['first']='first'=baseurl & "&pageIndex=" & 1;
			result.links['previous']=baseurl & "&pageIndex=" & prevIndex;
		}

		if(result.totalPages > 1){
			result.links['last']=baseurl & "&pageIndex=" & result.totalPages;
		}

		if(result.pageIndex < result.totalPages ){
			result.links['next']=baseurl & "&pageIndex=" & nextIndex;
		}

		return result;
	}

	function processRequest(path=cgi.path_info){

		try {
			var responseObject=getpagecontext().getResponse();
			var params={};
			var result="";

			getBean('utility').suppressDebugging();

			var headers = getHttpRequestData().headers;

			if( structKeyExists( headers, 'Origin' )){

			  	var origin =  headers['Origin'];;

			  	// If the Origin is okay, then echo it back, otherwise leave out the header key
			  	if(listFindNoCase(application.settingsManager.getAccessControlOriginList(), origin )) {
			   		responseObject.setHeader( 'Access-Control-Allow-Origin', origin );
			   		responseObject.setHeader( 'Access-Control-Allow-Credentials', 'true' );
			  	}
		  	}

			var paramsArray=[];
			var pathInfo=listToArray(arguments.path,'/');
			var httpRequestData=getHTTPRequestData();
			var method='GET';

			structAppend(params,url);
			structAppend(params,form);

			if(structKeyExists(headers,'Content-Type')
				&& headers['Content-Type'] == 'application/json'
				&& isJSON(httpRequestData.content)){
				structAppend(params,deserializeJSON(httpRequestData.content));
			}

			if( structKeyExists( headers, 'X-csrf_token' )){
				params['csrf_token']=headers['X-csrf_token'];
			}

			if( structKeyExists( headers, 'X-csrf_token_expires' )){
				params['csrf_token_expires']=headers['X-csrf_token_expires'];
			}

			structAppend(form,params);

			param name="session.siteid" default=variables.siteid;

			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);

			request.returnFormat='JSON';

			if (!isDefined('params.method') && arrayLen(pathInfo) && isDefined('#pathInfo[1]#')){
				params.method=pathInfo[1];
			}

			if (isDefined('params.method') && isDefined('#params.method#')){

				if(!listFindNoCase(variables.config.publicMethods, params.method) ){
					throw(type="invalidMethodCall");
				}

				if(!(listFindNoCase('validate,processAsyncObject,generateCSRFTokens',params.method) || getBean('settingsManager').getSite(variables.siteid).getJSONApi())){
					throw(type='authorization');
				}

				if(arrayLen(pathInfo) > 1){
					parseParamsFromPath(pathInfo,params,2);
				}

				if(isDefined('#params.method#')){

					result=evaluate('#params.method#(argumentCollection=params)');

					if(!isJson(result)){
						result=getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
					}

					responseObject.setContentType('application/json; charset=utf-8');
					responseObject.setStatus(200);
					return result;
				}
			}

			if(!isDefined('params.method')){
				params.method="undefined";
			}

			if(!getBean('settingsManager').getSite(variables.siteid).getJSONApi()){
				throw(type='disabled');
			}

			if(arrayLen(pathInfo)){
				params.siteid=pathInfo[1];
			}

			if(arrayLen(pathInfo) > 1){
				if(isDefined(pathInfo[2]) && pathInfo[2] != 'file'){
					params.method=pathInfo[2];

					if(!listFindNoCase(variables.config.publicMethods, params.method) ){
						throw(type="invalidMethodCall");
					}

					if(!(listFindNoCase('validate,processAsyncObject',params.method) || getBean('settingsManager').getSite(variables.siteid).getJSONApi())){
						throw(type='authorization');
					}

					if(arrayLen(pathInfo) > 2){
						parseParamsFromPath(pathInfo,params,3);
					}

					result=evaluate('#params.method#(argumentCollection=params)');

					if(!isJson(result)){
						result=getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
					}

					responseObject.setContentType('application/json; charset=utf-8');
					responseObject.setStatus(200);
					return result;

				} else {
					params.entityName=pathInfo[2];
				}
			}

			if(isDefined('params.entityName') && listFIndNoCase('contentnavs,contentnav',params.entityName)){
				params.entityName="content";
				params.entityConfigName="contentnav";
			}

			if(isDefined("params.siteid") && !isDefined('params.entityName')){
				params.entityName='entityname';
				params.method='findall';
			} else if(!isDefined("params.siteid") || !(isDefined("params.entityName") && len(params.entityName) && getServiceFactory().containsBean(params.entityName)) ){
				if(isDefined('params.entityName') && right(params.entityName,1) == 's'){
					params.entityName=left(params.entityName,len(params.entityName)-1);


					if( !getServiceFactory().containsBean(params.entityName)){
						throw(type="invalidParameters");
					}
				} else {
					throw(type="invalidParameters");
				}
			}

			if(!isDefined('params.entityName')){
				throw(type="invalidParameters");
			}

			if (params.entityName == 'site'){
				params.id=params.siteid;

				if(arrayLen(pathInfo) == 3){
					params.relatedEntity=pathInfo[3];
				} else {
					if(structKeyExists(headers,'X-HTTP-Method-Override')){
						method=headers['X-HTTP-Method-Override'];
					} else {
						method=httpRequestData.method;
					}
				}

			} else {

				if(arrayLen(pathInfo) > 2){
					if(len(pathInfo[3])==35){
						params.id=pathInfo[3];

						if(arrayLen(pathInfo) == 4){

							if(getServiceFactory().containsBean(pathInfo[4])){
								params.relatedEntity=pathInfo[4];
							}
						} else {
							if(structKeyExists(headers,'X-HTTP-Method-Override')){
								method=headers['X-HTTP-Method-Override'];
							} else {
								method=httpRequestData.method;
							}
						}
					} else if (params.entityName=='content') {
						params.id=pathInfo[3];
						var filenamestart=3;

						if(pathInfo[3]=='_path'){
							params.render=true;
							params.variation=false;
							params.id='';
							filenamestart=4;
						} else if(pathInfo[3]=='_variation'){
							params.render=true;
							params.variation=true;
							params.id='';
							filenamestart=4;
						}

						if(arrayLen(pathInfo) >= filenamestart){
							for(var i=filenamestart;i<=arrayLen(pathInfo);i++){
								params.id=listAppend(params.id,pathInfo[i],'/');
							}
						}
					}else if(pathInfo[3]=='new'){
						params.id=pathInfo[3];
					} else{
						parseparamsFromPath(pathInfo,params,3);
					}

				} else {
					if(structKeyExists(headers,'X-HTTP-Method-Override')){
						method=headers['X-HTTP-Method-Override'];
					} else {
						method=httpRequestData.method;
					}
				}

			}

			if(params.entityName=='content'){
				var primaryKey='contentid';
			} else if(params.entityName=="group"){
				params.type=1;
				var primaryKey='userid';
			} else if(params.entityName=="user"){
				params.type=2;
				var primaryKey='userid';
			} else if(params.entityName=="feed"){
				var primaryKey='feedid';
			} else if(params.entityName=="entityname"){
				var primaryKey='notvalid';
			} else {
				var primaryKey=application.objectMappings['#params.entityName#'].primaryKey;
			}

			if(httpRequestData.method=='GET' && isDefined('params.#primaryKey#') && len(params['#primaryKey#'])){
				params.id=params['#primaryKey#'];
			}

			structAppend(form,params);

			switch(method){
				case "GET":

					if((isDefined('params.id') || (params.entityName=='content') && isDefined('params.contenthistid'))){

						if(isDefined('params.relatedEntity')){

							if(params.entityName=='content'){
								if(params.relatedEntity!='crumbs'){
									params.contenthistid=params.id;
									structDelete(params,'id');
								}
							} else {
								params['#application.objectMappings['#params.entityName#'].primaryKey#']=params.id;
								structDelete(params,'id');
							}

							if(listFindNoCase('content,category',params.entityName) && params.relatedEntity=='crumbs'){
								responseObject.setContentType('application/json; charset=utf-8');
								result=findCrumbArray(argumentCollection=params);
							} else {
								if(!isDefined('params.relationship.cfc')){
									throw(type='invalidParameters');
								}

								params.entityName=params.relationship.cfc;

								structDelete(params,'relateEntity');
								structAppend(url,params);

								if(params.relationship.fieldtype=='one-to-many'){
									params.method='findQuery';
									result=findQuery(argumentCollection=params);
								} else {
									if(listLen(params.id)){
										params.ids=params.id;
										params.method='findMany';
										result=findMany(argumentCollection=params);
									} else if(params.id=='new') {
										params.method='findNew';
										result=findNew(argumentCollection=params);
									} else {
										params.method='findOne';
										result=findOne(argumentCollection=params);
									}
								}

							}
						} else {
							if(params.id=='new') {
								params.method='findNew';
								result=findNew(argumentCollection=params);
							} else if(listLen(params.id) > 1){
								params.ids=params.id;
								params.method='findMany';
								result=findMany(argumentCollection=params);
							} else {
								params.method='findOne';
								result=findOne(argumentCollection=params);
							}
						}

					} else {

						if(structCount(url)){
							params.method='findQuery';
							result=findQuery(argumentCollection=params);
						} else {
							params.method='findAll';
							result=findAll(argumentCollection=params);
						}
					}

				break;

				case "PUT":
				case "POST":
					params.method='save';
					result=save(argumentCollection=params);

				break;

				case "DELETE":
					params.method='delete';
					result=delete(argumentCollection=params);
			}

			try{
				if(responseObject.getStatus() != 404){
					responseObject.setStatus(200);
				}
			} catch (Any e){}

			responseObject.setContentType('application/json; charset=utf-8');
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
		}

		catch (authorization e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(401);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=401,'message'='Insufficient Account Permissions'}});
		}

		catch (disabled e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=400,'message'='The JSON API is currently disabled'}});
		}

		catch (invalidParameters e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=400,'message'='Insufficient parameters'}});
		}

		catch (invalidMethodCall e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=400,'message'="Invalid method call"}});
		}

		catch (badRequest e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=400,'message'="Bad Request"}});
		}

		catch (invalidTokens e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=400,'message'="Invalid CSRF tokens"}});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(500);
			return getSerializer().serialize({'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code=500,'message'="Unhandeld Exception",'stacktrace'=e}});
		}

	}

	function getApiVersion(){
		return 'v1';
	}

	function getParamsWithOutMethod(params){
		var temp={};
		structAppend(temp,arguments.params);
		structDelete(temp,'method');
		return temp;
	}

	function parseParamsFromPath(pathInfo,params,start){
		var paramsArray=[];

		for(var i=arguments.start;i<=arrayLen(arguments.pathInfo);i++){
			arrayAppend(paramsArray,arguments.pathInfo[i]);
		}

		for(var i=1;i<=arrayLen(paramsArray);i++){
			if(i mod 2){
				params['#paramsArray[i]#']='';
			} else {
				var previous=i-1;
				params['#paramsArray[previous]#']=paramsArray[i];
			}
		}
	}

	function getRelationship(from,to){
		if(isDefined("application.objectMappings.#arguments.from#")){

			for(var p in application.objectMappings['#arguments.from#'].hasOne){
				if(p.name==arguments.to || p.cfc==arguments.to){
					return p;
				}
			}

			for(var p in application.objectMappings['#arguments.from#'].hasMany){
				if(p.name==arguments.to || p.cfc==arguments.to){
					return p;
				}
			}
		}

		return {};
	}


	function isValidRequest(){
		return (isDefined('session.siteid') && isDefined('session.mura.requestcount') && session.mura.requestcount > 1);
	}

	function AllowAccess(bean,$,throwError=true){

		if(isObject(arguments.bean)){
			if(!isDefined('arguments.bean.getEntityName')){
				throw(type='invalidParameters');
			}
			var entityName=arguments.bean.getEntityName();
		} else {
			if(!getServiceFactory().containsBean(arguments.bean)){
				if(arguments.throwError){
					throw(type='invalidParameters');
				}
				return false;
			}
			var entityName=arguments.bean;
		}

		if(!structKeyExists(variables.config.entities,entityName)){
			return false;
		} else if (
				listFind('address,user',entityName)
				&& !(
					$.currentUser().isAdminUser()
					|| $.currentUser().isSuperUser()
					|| $.event('id') == $.currentUser().getUserID()
				)
			){
			return false;
		}

		var config=variables.config.entities[entityName];

		if(config.public){
			return true;
		} else if (structKeyExists(config,'moduleid')) {
			return getBean('permUtility').getModulePerm(config.moduleid,variables.siteid);
		} else {
			return getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid);
		}

	}

	function AllowAction(bean,$){

		if(!isDefined('arguments.bean.getEntityName')){
			throw(type='invalidParameters');
		}

		if(arguments.bean.getEntityName() == 'content' && listFindNoCase('Form,Component,Variation',arguments.$.event('type'))){
			arguments.bean.setType($.event('type'));
		}

		switch(arguments.bean.getEntityName()){
			case 'content':
				switch(arguments.bean.getType()){
					case 'Form':
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000004',variables.siteid)){
							return false;
						}
					break;
					case 'Component':
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000003',variables.siteid)){
							return false;
						}
					break;
					case 'Variation':
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000099',variables.siteid)){
							return false;
						}
					break;
					default:
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid)){
							return false;
						}
					break;
				}

				local.currentBean=getBean("content").loadBy(contentID=arguments.bean.getContentID(), siteID= arguments.bean.getSiteID());
				local.perm='none';

				if(!local.currentBean.getIsNew()){
					local.crumbData=arguments.bean.getCrumbArray();
					local.perm=getBean('permUtility').getNodePerm(local.crumbData);
				}

				if(local.currentBean.getIsNew() && len(arguments.bean.getParentID())){
					local.crumbData=getBean('contentGateway').getCrumblist(arguments.bean.getParentID(), arguments.bean.getSiteID());
					local.perm=getBean('permUtility').getNodePerm(local.crumbData);
				}

				if(!listFindNoCase('author,editor',local.perm)){
					return false;
				}

				if(local.perm=='author'){
					arguments.bean.setApproved(0);
				}

			break;
			case 'user':
			case 'group':
			case 'address':
				if(!getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid)){
					if(!(arguments.$.currentUser().isAdminUser() || arguments.$.currentUser().isSuperUser())){
						if(arguments.bean.getValue('userid')!=$.currentUser('userid')){
							return false;
						}
					}
				}
				break;
			default:
				if (isDefined('variables.config.entities.#arguments.bean.getEntityName()#.moduleid')) {
					if(!getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid)){
						return false;
					}
				} else {
					if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid)){
						return false;
					}
				}
		}

		return true;

	}

	function validateEmail() {

		if(!isValidRequest()){
			throw(type="badRequest");
		}

		var $=getBean('$').init(variables.siteid);
		var result='invalid';


		var httpService = new http();
		httpService.setMethod("get");
		httpService.setCharset("utf-8");
		httpService.setUrl("https://bpi.briteverify.com/emails.json?address=#arguments.email#&apikey=#$.siteConfig('mmpBrightVerifyAPIKey')#");
		var result=httpService.send().getPrefix();

		try{
			var response=getSerializer().serialize(result.filecontent);
		} catch(any e){
			var response={status='invalid'};
		}

		return response;
	}

	function login(username,password,siteid,lockdownCheck=false,lockdownExpires=''){

		var result=getBean('userUtility').login(argumentCollection=arguments);

		if(result){
			return {'status'='success'};
		} else {
			return {'status'='failed'};
		}
	}

	function logout(){
		application.loginManager.logout();
		return {'status'='success'};
	}

	function findCalendarItems(calendarid, siteid, start, end, categoryid, tag,format='') {

		// validate required args
		var reqArgs = ['calendarid','siteid'];
		for ( arg in reqArgs ) {
			if ( !StructKeyExists(arguments, arg) || !Len(arguments[arg]) ) {
				return 'Please provide a <strong>#arg#</strong>.';
			}
		}

		checkForChangesetRequest('content',arguments.siteid);

		var $ = application.serviceFactory.getBean('$').init(arguments.siteid);
		var calendarUtility = $.getCalendarUtility();
		var items=$.getCalendarUtility().getCalendarItems(argumentCollection=arguments);

		if(arguments.format=='fullcalendar'){
		 	var qoq = new Query();
		    qoq.setDBType('query');
		    qoq.setAttributes(rs=items);
		    qoq.setSQL('
		      SELECT
		        url as [url]
		        , contentid as [id]
		        , menutitle as [title]
		        , displaystart as [start]
		        , displaystop as [end]
		      FROM rs
		    ');

		    local.rsQoQ = qoq.execute().getResult();

		    return local.rsQoQ;
		} else {
			return items;
		}
	}

	// MURA ORM ADAPTER

	function save(siteid,entityname,id='new'){

		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName).set($.event().getAllValues());
		var saveErrors=false;
		var errors={};

		var pk=entity.getPrimaryKey();

		if(arguments.id=='new'){
			$.event('id',createUUID());
			arguments.id=$.event('id');
			$.event(pk,arguments.id);
		}

		if(arguments.entityName=='content' && len($.event('contenthistid'))){
			var loadByparams={contenthistid=$.event('contenthistid')};
			if($.event('type')=='Variation'){
				$.event('body',urlDecode($.event('body')));
			}
		} else {
			var loadByparams={'#pk#'=arguments.id};
		}

		if($.validateCSRFTokens(context=arguments.id)){
			if(arguments.entityName=='content' && $.event('type')=='Variation'){
				entity.loadBy(argumentCollection=loadByparams).set(
						$.event().getAllValues()
					);

				if(!(entity.allowSave($) || allowAction(entity,$)) ){
					throw(type="authorization");
				}

				if(entity.getIsNew() && len(entity.getChangesetID())){
					//create default that is not in changeset
					entity.setBody("[]").setChangesetID('').setApproved(1).save();
					entity.setBody($.event('body')).setChangesetID($.event('changesetid')).setApproved(0).save();
				} else {
					entity.save();
				}
			} else {
				entity.loadBy(argumentCollection=loadByparams)
					.set(
						$.event().getAllValues()
					);

				if(!(entity.allowSave($) || allowAction(entity,$)) ){
					throw(type="authorization");
				}

				entity.save();
			}
		} else {
			throw(type="invalidTokens");
		}

		//getpagecontext().getresponse().setHeader("Location","#getEndPoint()##entity.getEntityName()#/#arguments.id#");

		if(arguments.entityName=='content'){
			loadByparams={contenthistid=entity.getContentHistID()};
		} else {
			loadByparams={'#pk#'=entity.getValue(pk)};
		}


		saveErrors=entity.getValue('saveErrors');
		errors=entity.getValue('errors');

		entity=$.getBean(entityName).loadBy(argumentCollection=loadByparams);

		var returnStruct=getFilteredValues(entity,$,true,entity.getEntityName());

		returnStruct.saveErrors=saveErrors;
		returnStruct.errors=errors;
		returnStruct.links=getLinks(entity);
		returnStruct.id=returnStruct[pk];

		if(listFindNoCase('content,contentnav',arguments.entityName)){
			returnstruct.images=setImageURLS(entity,$);
			returnstruct.url=entity.getURL();
		}

		//var tokens=$.generateCSRFTokens(context=returnStruct.id);
		//structAppend(returnStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

		return returnStruct;
	}

	function getFilteredValues(entity,$,expand=true,entityConfigName){
		var fields='';
		var vals={};

		if(!(isDefined('variables.config.entities.#arguments.entityConfigName#.allowfieldselect') && !variables.config.entities[entityConfigName].allowfieldselect) && len($.event('fields'))){
			fields=$.event('fields');

			if(arguments.entity.getEntityName()=='content' && !listFindNoCase(fields,'contentid')){
				fields=listAppend(fields,'contentid');
			} else if (arguments.entity.getEntityName()!='content' && !listFindNoCase(fields,arguments.entity.getPrimaryKey())){
				fields=listAppend(fields,arguments.entity.getPrimaryKey());
			}

			if(!listFindNoCase(fields,'siteid')){
				fields=listAppend(fields,'siteid');
			}
		} else if(isDefined('variables.config.entities.#arguments.entityConfigName#.fields')){
			fields=variables.config.entities[arguments.entityConfigName].fields;
		}

		fields=listToArray(fields);

		if(arrayLen(fields)){
			var temp={};

			for(var f in fields){
				var prop=arguments.entity.getValue(f);
				//if(len(prop)){
					temp['#f#']=prop;
				//}
			}

			vals=temp;
		} else {
			vals=structCopy(arguments.entity.getAllValues(expand=arguments.expand));
			structDelete(vals,'addObjects');
			structDelete(vals,'removeObjects');
			structDelete(vals,'sourceiterator');
			structDelete(vals,'frommuracache');
			structDelete(vals,'errors');
			structDelete(vals,'instanceid');
			structDelete(vals,'primaryKey');
			structDelete(vals,'extenddatatable');
			structDelete(vals,'extenddata');
			structDelete(vals,'extendAutoComplete');
			structDelete(vals,'saveErrors');
			if(listFindNoCase("user,group",arguments.entityConfigName)){
				structDelete(vals,'sourceiterator');
				structDelete(vals,'ukey');
				structDelete(vals,'hkey');
				structDelete(vals,'passedprotect');
				structDelete(vals,'extendsetid');
				structDelete(vals,'extenddata');
				structDelete(vals,'addresses');
			}
		}

		vals['entityname']=arguments.entityConfigName;

		return vals;
	}

	function findOne(entityName,id,siteid,render=false,variation=false,expand=''){
		var $=getBean('$').init(arguments.siteid);

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		if(arguments.entityName=='content'){
			var pk = 'contentid';

			if(arguments.render){
				if(arguments.variation){
					var content=$.getBean('content').loadBy(remoteid=id);

					url.linkservid=content.getContentID();

					if(!content.exists()){
						content.setType('Variation');
						content.setIsNew(1);
						content.setRemoteID(id);
						content.setSiteID(arguments.siteid);
						request.contentBean=content;
					}

					getBean('contentServer').renderFilename(filename='',siteid=arguments.siteid,validateDomain=false);
				} else {
					if(arguments.id=='null'){
						arguments.id='';
					}
					getBean('contentServer').renderFilename(filename=arguments.id,siteid=arguments.siteid,validateDomain=false);
				}

			} else {
				if(len($.event('contenthistid'))){
					var entity=$.getBean('content').loadBy(contenthistid=$.event('contenthistid'));
				} else {
					var entity=$.getBean('content').loadBy(contentid=arguments.id);
				}
			}
		} else if(arguments.entityName=='stats'){
			entity=getBean("stats");
			entity.setSiteID(arguments.siteid);
			entity.setContentID(arguments.id);
			entity.load();
			pk='contentid';

		} else {
			var entity=$.getBean(arguments.entityName);

			if($.event('entityName')=='feed'){
				var pk="feedid";
			} else {
				var pk=entity.getPrimaryKey();
			}

			if(arguments.entityName == 'site'){
				arguments.id=arguments.siteid;
			}

			var loadparams={'#pk#'=arguments.id};
			entity.loadBy(argumentCollection=loadparams);
		}

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		if(!entity.allowRead()){
			throw(type="authorization");
		}

		var returnStruct=getFilteredValues(entity,$,true,arguments.entityName);
		returnStruct.links=getLinks(entity);
		returnStruct.id=returnStruct[pk];

		if(listFindNoCase('content,contentnav',arguments.entityName)){
			returnstruct.images=setImageURLS(entity,$);
			returnstruct.url=entity.getURL();
		}

		if(len(arguments.expand)){
			var p='';
			var expandParams={};

			if(arrayLen(entity.getHasManyPropArray())){
				for(p in entity.getHasManyPropArray()){
					if(arguments.expand=='all' || listFindNoCase(arguments.expand,p.name)){
						expandParams={maxitems=0,itemsperpage=0};
						expandParams['#entity.translatePropKey(p.loadkey)#']=entity.getValue(entity.translatePropKey(p.column));
						try{
							returnstruct[p.name]=findQuery(entityName=p.cfc,siteid=arguments.siteid,params=expandParams);
						} catch(any e){WriteDump(p); abort;}
					}
				}
			}

			if(arrayLen(entity.getHasOnePropArray())){
				for(p in entity.getHasOnePropArray()){
					if(arguments.expand=='all' || listFindNoCase(arguments.expand,p.name)){
						try{
							if(p.name=='site'){
								returnstruct[p.name]=findOne(entityName='site',id=entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand='');
							} else {
								returnstruct[p.name]=findOne(entityName=p.cfc,id=entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand='');
							}
						} catch(any e){WriteDump(p); abort;}
					}
				}
			}

			if(arguments.expand=='all' || listFindNoCase(arguments.expand,'crumbs')){
				if(isDefined('returnstruct.links.crumbs') && isDefined('returnstruct.path')){
					returnstruct.crumbs=findCrumbArray(returnstruct.entityName,returnstruct.id,arguments.siteid,entity.getCrumbIterator());
				}
			}
		}

		//var tokens=$.generateCSRFTokens(context=returnStruct.id);
		//structAppend(returnStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

		return returnStruct;
	}

	function findNew(entityName,siteid){

		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean(arguments.entityName);

		if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		var loadparams={'#pk#'=''};
		entity.loadBy(argumentCollection=loadparams);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		var returnStruct=getFilteredValues(entity,$,true,entity.getEntityName());
		returnStruct.links=getLinks(entity);
		returnStruct.id=returnStruct[pk];

		if(listFindNoCase('content,contentnav',arguments.entityName)){
			returnstruct.images=setImageURLS(entity,$);
			returnstruct.url=entity.getURL();
		}

		//var tokens=$.generateCSRFTokens(context=returnStruct.id);
		//structAppend(returnStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

		return returnStruct;
	}

	function findAll(siteid,entityName,params){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityName=='entityname'){
			var returnArray=[];
			for(var i in variables.config.entities){
				if(allowAccess(i,$,false)){
					arrayAppend(returnArray,{entityname=i,links={endpoint=getEndPoint() & "/" & i}});
				}
			}
			return {items=returnArray,links={self=getEndPoint()},entityname='entityname'};
		}

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		if(!entity.allowQueryParams(arguments.params,$)){
			throw(type="authorization");
		}

		var feed=entity.getFeed();

		if(arguments.entityName=='group'){
			feed.setType(1);
		}

		setFeedProps(feed,arguments.params);

		if(isDefined('arguments.params.countOnly') && isBoolean(arguments.params.countOnly) && arguments.params.countOnly){
			return {count=feed.getAvailableCount()};
		} else {
			var iterator=feed.getIterator();
			setIteratorProps(iterator,arguments.params);
		}

		if(arguments.entityName=='content'){
			var pk="contentid";
		} else if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false,entityConfigName);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}
			itemStruct.links=getLinks(item);

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			//var tokens=$.generateCSRFTokens(context=itemStruct.id);
			//structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

			arrayAppend(returnArray, itemStruct);
		}

		return formatIteratorResult(iterator,returnArray,'findall');
	}

	function findMany(entityName,ids,siteid,params){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess(arguments.entityName,$)){
			throw(type="authorization");
		}

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		if(arguments.entityName=='content' && len($.event('feedid'))){
			var feed=$.getBean('feed').loadBy(feedid=$.event('feedid'));
			var entity=$.getBean(arguments.entityName);
		} else {
			var entity=$.getBean(arguments.entityName);
			var feed=entity.getFeed();

			if(arguments.entityName=='group'){
				feed.setType(1);
			}
		}

		if(arguments.entityName=='content'){
			var pk="contentid";
		} else if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		feed.addParam(column=pk,criteria=arguments.ids,condition='in');

		setFeedProps(feed,arguments.params);
		var iterator=feed.getIterator();
		setIteratorProps(iterator,arguments.params);


		var returnArray=[];
		var finalArray=[];
		var itemStruct={};
		var item='';
		var i1='';
		var i2='';

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(iterator.hasNext()){
			item=iterator.next();

			if(isDefined('item.allowRead') && !entity.allowRead()){
				throw(type="authorization");
			}

			itemStruct=getFilteredValues(item,$,false,entityConfigName);

			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}
			itemStruct.links=getLinks(item);

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			//var tokens=$.generateCSRFTokens(context=itemStruct.id);
			//structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

			arrayAppend(returnArray, itemStruct );

		}

		if(isDefined('arguments.params.sort') && len(arguments.params.sort)
			&& !(isDefined('arguments.params.sort') && len(arguments.params.sort))){
			for(i1 in listToArray(arguments.ids)){
				for(i2 in returnArray){
					if(i2.id==i1){
						arrayAppend(finalArray,i2);
						break;
					}
				}
			}
		} else {
			finalArray=returnArray;
		}

		return formatIteratorResult(iterator,finalArray,'findmany');
	}

	function findQuery(entityName,siteid,params){

		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess(arguments.entityName,$)){
			throw(type="authorization");
		}

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		if(arguments.entityName=='content' && len($.event('feedid'))){
			var feed=$.getBean('feed').loadBy(feedid=$.event('feedid'));
			var entity=$.getBean(arguments.entityName);
		} else if(arguments.entityName=='content' && len($.event('feedname'))){
			var feed=$.getBean('feed').loadBy(name=$.event('feedname'));
			var entity=$.getBean(arguments.entityName);
		} else {
			var entity=$.getBean(arguments.entityName);
			var feed=entity.getFeed();

			if(arguments.entityName=='group'){
				feed.setType(1);
			}
		}

		if(arguments.entityName=='content'){
			var pk="contentid";
		} else if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		if(!entity.allowQueryParams(arguments.params,$)){
			throw(type="authorization");
		}

		if(entity.getEntityName()=='user'){
			if(isDefined('arguments.params.isPublic') && isNumeric($.event('isPublic'))){
				feed.setIsPublic($.event('isPublic'));
			} else {
				feed.setIsPublic('all');
			}
		}

		for(var p in arguments.params){
			if(!(entity.getEntityName()=='user' && p=='isPublic')){
				if(entity.getEnityName()=='user' && p=='groupid'){
					feed.setGroupID(arguments.params[p]);
				} else if(entity.valueExists(p)){
					var condition="=";

					if(find('*',arguments.params[p])){
						condition="like";
					}

					feed.addParam(column=p,criteria=replace(arguments.params[p],'*','%','all'),condition=condition);
				}
			}
		}

		setFeedProps(feed,arguments.params);

		if(isdefined('arguments.params.countOnly') && isBoolean(arguments.params.countOnly) && arguments.params.countOnly){
			return {count=feed.getAvailableCount()};
		} else {
			var iterator=feed.getIterator();
			setIteratorProps(iterator,arguments.params);
		}

		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false,entityConfigName);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}
			itemStruct.links=getLinks(item);

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			//var tokens=$.generateCSRFTokens(context=itemStruct.id);
			//structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

			arrayAppend(returnArray, itemStruct );
		}

		//writeDump(var=$.event('pageIndex'),abort=1);

		return formatIteratorResult(iterator,returnArray,'findquery');
	}

	function setFeedProps(feed,params){

		param name="arguments.params" default=url;

		var sort='';

		if(isDefined('arguments.params.orderby') && len(arguments.params.orderby)){
			sort=arguments.params.orderby;
		}

		if(isDefined('arguments.params.sort') && len(arguments.params.sort)){
			sort=arguments.params.sort;
		}

		if(len(sort)){

			var prefix='';
			var prop='';
			var useOrderby=true;

			sort=listToArray(sort);
			var orderby=[];
			for(var s in sort){
				if(len(s) > 1){
					var prefix=left(s,1);
					var prop=right(s,len(s)-1);

					if(listFindNoCase(prop,'comments,random,rating')){
						arguments.feed.setSortBy(prop);
						if(prefix=='-'){
							feed.setSortDirection('desc');
						}
						break;
						useOrderby=false;
					}

					if(prefix=='+'){
						arrayAppend(orderby,prop & " asc");
					} else if(prefix=="-"){
						arrayAppend(orderby,prop & " desc");
					} else {
						arrayAppend(orderby,s);
					}
				} else {

					if(listFindNoCase(prop,'comments,random,rating')){
						arguments.feed.setSortBy(s);
						useOrderby=false;
						break;
					}

					arrayAppend(orderby,s);
				}

  			}

  			if(useOrderby){
  				orderby=arrayToList(orderby);
  				arguments.feed.setOrderBy(orderby);
  			}

  		}

		if(isDefined('arguments.params.sortby') && len(arguments.params.sortby)){
			arguments.feed.setSortBy(arguments.params.sortby);
		}

		if(isDefined('arguments.params.sortdirection') && len(arguments.params.sortdirection)){
			arguments.feed.setSortDirection(arguments.params.sortdirection);
		}

		if(isDefined('arguments.params.maxitems') && isNumeric(arguments.params.maxitems)){
			arguments.feed.setMaxItems(arguments.params.maxitems);
		}

		if(isDefined('arguments.params.size') && isNumeric(arguments.params.size)){
			arguments.feed.setMaxItems(arguments.params.size);
		}

		if(isDefined('arguments.params.limit') && isNumeric(arguments.params.limit)){
			arguments.feed.setMaxItems(arguments.params.limit);
		}

		if(isDefined('arguments.params.type') && len(arguments.params.type)){
			arguments.feed.setType(arguments.params.type);
		}

		if(isDefined('arguments.params.cachedWithin') && isNumeric(arguments.params.cachedWithin)){
			feed.setCachedWithin(createTimeSpan(0,0,0,arguments.params.cachedWithin));
		}

	}

	function setIteratorProps(iterator,params){
		param name="arguments.params" default=url;

		if(isDefined('arguments.params.itemsPerPage') && isNumeric(arguments.params.itemsPerPage)){
			iterator.setNextN(arguments.params.itemsPerPage);
		}

		if(isDefined('arguments.params.pageIndex') && isNumeric(arguments.params.pageIndex)){
			iterator.setPage(arguments.params.pageIndex);
		}

		if(isDefined('arguments.params.startIndex') && isNumeric(arguments.params.startIndex)){
			iterator.setStartRow(arguments.params.startIndex);
		}

		if(isDefined('arguments.params.offset') && isNumeric(arguments.params.offset)){
			feed.setMaxItems(arguments.params.offset);
		}

	}

	function findCrumbArray(entityName,id,siteid,iterator){

		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean(arguments.entityName);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		if(arguments.entityName=='content'){
			var pk="contentid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		if(!isDefined('arguments.iterator')){
			var params={'#pk#'=arguments.id};
			arguments.iterator=entity.loadBy(argumentCollection=params).getCrumbIterator();
		}

		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(arguments.iterator.hasNext()){
			item=arguments.iterator.next();
			itemStruct=getFilteredValues(item,$,false,entityConfigName);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}
			itemStruct.links=getLinks(item);

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			//var tokens=$.generateCSRFTokens(context=itemStruct.id);
			//structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});


			arrayAppend(returnArray, itemStruct );
		}

		return formatIteratorResult(arguments.iterator,returnArray,'findCrumbArray');
	}

	function delete(entityName,id,siteid){

		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if($.event('entityName')=='content'){
			if(len($.event('contenthistid'))){
				var loadparams={contenthistid=$.event('contenthistid')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete() || allowAction(entity,$))){
						throw(type="authorization");
					}

					if($.validateCSRFTokens(context=arguments.id)){
						entity.deleteVersion();
					}
				}
			} else {
				var loadparams={contentid=$.event('id')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete() || allowAction(entity,$))){
						throw(type="authorization");
					}

					if($.validateCSRFTokens(context=arguments.id)){
						entity.delete();
					} else {
						throw(type="invalidTokens");
					}
				}
			}
			var pk="contentid";
		} else {

			if($.event('entityName')=='feed'){
				var pk="feedid";
			} else {
				var pk=entity.getPrimaryKey();
			}

			var loadparams={'#pk#'=$.event('id')};
			entity.loadBy(argumentCollection=loadparams);

			if(entity.exists()){
				if(!(entity.allowDelete() || allowAction(entity,$))){
						throw(type="authorization");
					}

				if($.validateCSRFTokens(context=arguments.id)){
					entity.delete();
				} else {
					throw(type="invalidTokens");
				}
			}
		}

		return '';
	}

	function getEndPoint(){
		if(request.muraApiRequest){
			var configBean=getBean('configBean');
			if(!isDefined('request.apiEndpoint')){

				if(getBean('configBean').getAdminSSL()){
					var protocol='http';
				} else {
					var protocol=getBean('utility').getRequestProtocol();
				}

				var domain=cgi.server_name;

				request.apiEndpoint="#protocol#://#domain##configBean.getServerPort()##configBean.getContext()#/index.cfm/_api/json/v1/#variables.siteid#";
			}
			return request.apiEndpoint;
		}

		return variables.endpoint;

	}

	function getLinks(entity){
		var links={};
		var p='';
		var baseURL=getEndPoint();

		links.entities=baseURL;

		links['self']="#baseurl#?method=findOne&entityName=#entity.getEntityName()#&siteid=#entity.getSiteID()#&id=#entity.getvalue(entity.getPrimaryKey())#";

		if(arrayLen(entity.getHasManyPropArray())){
			try{
			for(p in entity.getHasManyPropArray()){
				links[p.name]="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=#p.cfc#&#entity.translatePropKey(p.loadkey)#=#entity.getValue(entity.translatePropKey(p.column))#";
			}
			} catch(any e){writeDump(var=p,abort=true);}
		}

		if(arrayLen(entity.getHasOnePropArray())){
			for(p in entity.getHasOnePropArray()){
				if(p.name=='site'){
					links[p.name]="#baseurl#?method=findOne&entityName=site&siteid=#entity.getSiteID()#";
				} else {
					links[p.name]="#baseurl#?method=findOne&siteid=#entity.getSiteID()#&entityName=#p.cfc#&id=#entity.getValue(entity.translatePropKey(p.column))#";
				}
			}
		}

		if(listFindNoCase('feed,contentFeed',entity.getEntityName())){
			links['feed']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=content&feedid=#entity.getFeedID()#";
		}

		/*
		if(listFindNoCase('user',entity.getEntityName())){
			links['members']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
			//links['memberships']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
		}
		*/

		if(entity.getEntityName()=='content'){
			links['self']="#baseurl#/content/#entity.getContentID()#";
			links['renderered']="#baseurl#/content/_path/#entity.getFilename()#";
			if(entity.getType()=='Variation'){
				links['self']=links['renderered'];
			} else {
				links['crumbs']="#baseurl#?method=findCrumbArray&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('contentid')#";
			}
			links['relatedcontent']="#baseurl#?method=findRelatedContent&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('contentid')#";
		} else if(entity.getEntityName()=='category'){
			links['crumbs']="#baseurl#?method=findCrumbArray&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('categoryid')#";
		}

		if(arrayLen(variables.config.linkMethods)){
			for(var i in variables.config.linkMethods){
				evaluate('#i#(entity=arguments.entity,links=links)');
			}
		}

		return links;
	}

	function findRelatedContent(id,siteid,params){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess('content',$)){
			throw(type="authorization");
		}

		checkForChangesetRequest('content',arguments.siteid);

		var entity=$.getBean('content').loadBy(contentid=arguments.id);

		var args={};

		if(isDefined('arguments.params.sortby') && len(arguments.params.sortby)){
			args.sortBy=arguments.params.sortby;
		}

		if(isDefined('arguments.params.sortdirection') && len(arguments.params.sortdirection)){
			args.sortdirection=arguments.params.sortdirection;
		}

		if(isDefined('arguments.params.name') && len(arguments.params.name)){
			args.name=arguments.params.name;
		}

		if(isDefined('arguments.params.reverse') && len(arguments.params.reverse)){
			args.reverse=arguments.params.reverse;
		}

		if(isDefined('arguments.params.relatedContentSetID') && len(arguments.params.relatedContentSetID)){
			args.relatedContentSetID=arguments.params.relatedContentSetID;
		}

		var iterator=entity.getRelatedContentIterator(argumentCollection=args);

		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';
		var pk=entity.getPrimaryKey();

		setIteratorProps(iterator,arguments.params);

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false,entityConfigName);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}
			itemStruct.links=getLinks(item);

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			//var tokens=$.generateCSRFTokens(context=itemStruct.id);
			//structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});

			arrayAppend(returnArray, itemStruct );
		}

		return formatIteratorResult(iterator,returnArray,'findRelatedContent');
	}

	function applyRemoteFormat(str){

		//arguments.str=replaceNoCase(str,"/index.cfm","",'all');
		//arguments.str=replaceNoCase(str,'href="/','href="##/','all');
		//arguments.str=replaceNoCase(str,"href='/","href=''##/",'all');

		return trim(arguments.str);
	}

	function setImageURLs(entity,$){

		if(arguments.entity.hasImage()){
			if(!isDefined('variables.images')){
				variables.images=arguments.$.siteConfig().getCustomImageSizeIterator();
			}

			var returnStruct={
				small=entity.getImageURL(size='small'),
				medium=entity.getImageURL(size='medium'),
				large=entity.getImageURL(size='large')
			};

			var image='';

			while(variables.images.hasNext()){
				image=variables.images.next();
				returnStruct['#image.getName()#']=entity.getImageURL(size=image.getName());
			}
			variables.images.reset();
		} else {
			var returnStruct={};
		}

		return returnStruct;

	}

	function validate(data='{}',validations='{}') {

		data=deserializeJSON(urlDecode(arguments.data));
		validations=deserializeJSON(urlDecode(arguments.validations));

		if(structIsEmpty(validations) && isDefined('data.entityname') && isDefined('data.siteid')){
			var bean=getBean(data.entityname);
			var args={'#bean.getPrimaryKey()#'=data[bean.getPrimaryKey()]
			};
			return bean.loadBy(argumentCollection=args).validate().getErrors();

		}

		errors={};

		if(!structIsEmpty(validations)){

			structAppend(errors,new mura.bean.bean()
				.set(data)
				.setValidations(validations)
				.validate()
				.getErrors()
			);
		}

		if(isDefined('arguments.data.bean') && isDefined('arguments.data.loadby')){
			structAppend(errors,
				getBean(data.bean)
				.loadBy(data.loadby=arguments.data[arguments.data.loadby],siteid=arguments.data.siteid)
				.set(arguments.data)
				.validate()
				.getErrors()
			);
		}

		return errors;

	}

	function processAsyncObject(siteid){

		if(!isDefined('arguments.siteid')){
			if(isDefined('session.siteid')){
				arguments.siteid=session.siteid;
			} else {
				throw(type="invalidParameters");
			}

		}

		request.siteid=arguments.siteid;
		request.servletEvent=new mura.servletEvent();

		if(isDefined('form.alttheme')){
			request.alttheme=form.alttheme;
		} else if (isDefined('url.alttheme')){
			request.alttheme=url.alttheme;
		}

		var $=request.servletEvent.getValue("MuraScope");

		checkForChangesetRequest('content',arguments.siteid);

		if(len($.event('filename'))){
			$.event('currentFilename',$.event('filename'));
			getBean('contentServer').parseCustomURLVars($.event());
			$.event('contentBean',$.getBean('content').loadBy(filename=$.event('currentFilenameAdjusted')));
		} else if(len($.event('contenthistid'))){
			$.event('contentBean',$.getBean('content').loadBy(contenthistid=$.event('contenthistid')));
			$.event('currentFilename',$.content('filename'));
			$.event('currentFilenameAdjusted',$.content('filename'));
		} else {
			$.event('contentBean',$.getBean('content').loadBy(contentid=$.event('contentid')));
			$.event('currentFilename',$.content('filename'));
			$.event('currentFilenameAdjusted',$.content('filename'));
		}

		if(!$.content().exists()){
			$.content().setType('Variation');
			$.content().setIsNew(1);
			$.content().setRemoteID(0);
			$.content().setSiteID(arguments.siteid);
			request.contentBean=$.content();
		}

		$.event('localHandler',application.settingsManager.getSite(getValue('siteID')).getLocalHandler());
		$.announceEvent('siteAsyncRequestStart');
		$.event('crumbdata',$.content().getCrumbArray(setInheritance=true));
		$.event().getHandler('standardSetContentRenderer').handle($.event());
		$.getContentRenderer().injectMethod('crumbdata',$.event("crumbdata"));
		$.event().getHandler('standardSetPermissions').handle($.event());
		$.event().getHandler('standardSetLocale').handle($.event());

		$.announceEvent('asyncRenderStart');

		if($.event('object')=='comments'){
			$.event().getHandler('standardSetCommentPermissions').handle($.event());
		}


		if($.content().getType() != 'Variation' && $.event('r').restrict){
			$.event('nocache',1);
		}

		//Turn off cfformprotext js
		request.cffpJS=true;
		var result='';

		switch($.event('object')){
			case 'login':
				if(getHTTPRequestData().method == 'POST'){
					var loginManager=getBean('loginManager');

					if(isBoolean($.event('attemptChallenge')) && $.event('attemptChallenge')){
						if(loginManager.handleChallengeAttempt($)){
							loginManager.completedChallenge($);
							result={redirect=request.muraJSONRedirectURL};
						} else {
							$.event('status','challenge');
						}
					} else if(len($.event('username')) && len($.event('password'))){
						if(loginManager.remoteLogin($.event().getAllValues(),'')){
							if(len($.event('returnurl'))){
								result={redirect=getBean('utility').sanitizeHREF($.event('returnurl'))};
							} else {
								result={redirect="./##"};
							}
						} else {
							if(isDefined('session.mfa')){
								$.event('status','challenge');
							} else {
								$.event('status','failed');
							}
						}
					}
				}

				if(!isStruct(result)){
					result={
						html=applyRemoteFormat($.dspObject_Include(theFile='dsp_login.cfm'))
					};
				}

				break;

			case 'search':
				result={
					html=applyRemoteFormat($.dspObject_Include(thefile="dsp_search_results.cfm"))
				};

				break;

			case 'displayregion':
				result={
					html=applyRemoteFormat($.dspObjects(argumentCollection=$.event().getAllValues()))
				};

				break;

			case 'editprofile':
				switch($.event('doaction')){
					case 'updateprofile':
						if(session.mura.isLoggedIn){
							var eventStruct=$.event().getAllValues();

							structDelete(eventStruct,'isPublic');
							structDelete(eventStruct,'s2');
							structDelete(eventStruct,'type');
							structDelete(eventStruct,'groupID');
							eventStruct.userid=session.mura.userID;

							$.setValue('passedProtect', $.getBean('utility').isHuman($.event()));

							$.event().setValue("userID",session.mura.userID);

							if(isDefined('request.addressAction')){
								if($.event().getValue('addressAction') == "create"){
									$.getBean('userManager').createAddress(eventStruct);
								} else if($.event().getValue('addressAction') == "update"){
									$.getBean('userManager').updateAddress(eventStruct);
								} else if($.event().getValue('addressAction') == "delete"){
									$.getBean('userManager').deleteAddress($.event().getValue('addressID'));
								}
								//reset the form
								$.event().setValue('addressID','');
								$.event().setValue('addressAction','');
							} else {
								$.event().setValue('userBean',$.getBean('userManager').update( getBean("user").loadBy(userID=$.event().getValue("userID")).set(eventStruct).getAllValues() , iif($.event().valueExists('groupID'),de('true'),de('false')),true,$.event().getValue('siteID')));
								if(structIsEmpty($.event().getValue('userBean').getErrors())){
									$.getBean('userUtility').loginByUserID(userid=$.event('userBean').getUserID(),siteid=$.event('userBean').getSiteID());

									if(len($.event('returnurl'))){
										result={redirect=getBean('utility').sanitizeHREF($.event('returnurl'))};
									} else {
										result={redirect="./"};
									}
								}
							}
						}

					break;


					case 'createprofile':

						if(getBean('settingsManager').getSite($.event().getValue('siteid')).getextranetpublicreg() == 1){
							var eventStruct=$.event().getAllValues();
							structDelete(eventStruct,'isPublic');
							structDelete(eventStruct,'s2');
							structDelete(eventStruct,'type');
							structDelete(eventStruct,'groupID');
							eventStruct.userid='';

							$.event().setValue('passedProtect', getBean('utility').isHuman($.event()));

							$.event().setValue('userBean',  getBean("user").loadBy(userID=$.event().getValue("userID")).set(eventStruct).save() );

							if(structIsEmpty($.event().getValue('userBean').getErrors()) && !$.event().valueExists('passwordNoCache')){
								$.getBean('userManager').sendLoginByUser($.event().getValue('userBean'),$.event().getValue('siteid'),$.event().getValue('contentRenderer').getCurrentURL(),true);
								result={redirect=$.event('returnurl')};

							} else if (structIsEmpty($.event().getValue('userBean').getErrors()) && $.event().valueExists('passwordNoCache') && $.event().getValue('userBean').getInactive() eq 0){
								$.event().setValue('userID',$.event().getValue('userBean').getUserID());
								$.getBean('userUtility').loginByUserID(userid=$.event('userid'),siteid=$.event('siteid'));

								if(len($.event('returnurl'))){
									result={redirect=getBean('utility').sanitizeHREF($.event('returnurl'))};
								} else {
									result={redirect="./"};
								}
							}
						}

					break;
				}

				if(!isStruct(result)){
					result={
							html=applyRemoteFormat($.dspObject_Include(theFile='dsp_edit_profile.cfm'))
						};
				}

				break;

			default:
				if(listFindNoCase('folder,gallery',$.event('object'))){
					if($.getContentRenderer().useLayoutManager()){
						$.event('object','collection');
						$.event('objectid',$.content('contentid'));
						url.object='collection';
						url.sourcetype='children';
						url.source=$.content('contentid');

					} else {
						result={
							html=$.getContentRenderer().dspContentTypeBody()
						};
						break;
					}
				}

				if(len($.event('objectparams2'))){
					$.event('objectparams',$.event('objectparams2'));
				}

				//var logdata={object=$.event('object'),objectid=$.event('objectid'),siteid=arguments.siteid};
				//writeLog(text=serializeJSON(logdata));
				//return $.event('objectparams');

				var args={
						object=$.event('object'),
						objectid=$.event('objectid'),
						siteid=arguments.siteid,
						assignmentPerm=$.event('perm'),
						cacheKey=CGI.QUERY_STRING
					};

				if(len($.event('objectparams')) && !isJson($.event('objectparams'))){
					args.params=urlDecode($.event('objectparams'));
				} else {
					args.params={};

					if(isDefined('url') && isStruct(url)){
						for(var u in url){
							if(!listFindNoCase('perm,contentid,contenthistid,object,objectid,siteid,nocache,instanceid',u)){
								args.params['#u#']=url['#u#'];
							}
						}
					}

				}

				if(listFindNoCase('calendar,page',$.event('object'))){
					result={
						html=$.getContentRenderer().dspContentTypeBody(args.params)
					};
					break;
				}

				result=$.dspObject(argumentCollection=args);

				if(isdefined('request.muraJSONRedirectURL')){
					result={redirect=request.muraJSONRedirectURL};
				} else if(isSimpleValue(result)){
					if($.useLayoutManager()){
						args.params.content=result;
						result={html=trim('#$.dspObject_include(theFile='object/meta.cfm',params=args.params)##$.dspObject_include(theFile='object/content.cfm',params=args.params)#')};
					} else {
						result={html=result};
					}

				}
		}

		return result;

	}

	function checkForChangesetRequest(entityName,siteid){
		if(arguments.entityName=='content'){
			var previewData=application.serviceFactory.getBean('$').getCurrentUser().getValue("ChangesetPreviewData");
			request.muraChangesetPreview=isStruct(previewData) and previewData.siteID eq arguments.siteid;
		}
	}

	function generateCSRFTokens(siteid,context){
		var tokens=getBean('$').init(arguments.siteid).generateCSRFTokens(context=arguments.context);

		return {csrf_token=tokens.token,csrf_token_expires=tokens.expires};
	}

	function getURLForImage(fileid,size='small',height='auto',width='auto',siteid,complete=true,secure=false,useProtocol=false){
		var $=getBean('$').init(arguments.siteid);
		return {url=$.getURLForImage(argumentCollection=arguments)};
	}

}
