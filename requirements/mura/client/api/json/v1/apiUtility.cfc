component extends="mura.cfobject" hint="This provides JSON/REST API functionality" {

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
			publicMethods="findOne,findMany,findAll,findProperties,findNew,findQuery,save,delete,findCrumbArray,generateCSRFTokens,validateEmail,login,logout,submitForm,findCalendarItems,validate,processAsyncObject,findRelatedContent,getURLForImage,findVersionHistory,findCurrentUser,swagger",
			entities={
				'contentnav'={
					fields="links,images,parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew,remoteurl,remoteid"
				}
			}
		};

		variables.userUtility=getBean('userUtility');

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
		  .asInteger('isnew')
	      .asBoolean('saveErrors');

	    registerEntity('site',{
	    	public=true,
			fields="links,domain,siteid",
			allowfieldselect=false
		});

		registerEntity('content',{
			public=true,
			fields="links,images,parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew,remoteid,remoteurl"
		});

		registerEntity('user',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('group',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('address',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('changeset',{public=false,moduleid='00000000000000000000000000000000014'});
		registerEntity('feed',{public=false,moduleid='00000000000000000000000000000000011'});
		registerEntity('category',{public=true,moduleid='00000000000000000000000000000000010'});
		registerEntity('contentCategoryAssign',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('file',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('fileMetaData',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('changesetCategoryAssignment',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('comment',{public=true,moduleid='00000000000000000000000000000000015'});
		registerEntity('stats',{public=false,moduleid='00000000000000000000000000000000000'});

		if(getBean('configBean').getValue(property='variations',defaultValue=false)){
			registerEntity('variationTargeting',{public=false,moduleid='00000000000000000000000000000000000'});
		}
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


	function registerEntity(entityName, config={public=false,fields=''}){

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

	function packageIteratorArray(iterator,itArray,method,expanded=false){
		var result={};

		if(arguments.iterator.getRecordCount()){
			result={'totalItems'=arguments.iterator.getRecordCount(),
			'totalPages'=arguments.iterator.pageCount(),
			'pageIndex'=arguments.iterator.getPageIndex(),
			'items'=arguments.itArray,
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


		if(!arguments.expanded &&
			!(isDefined('arguments.baseURL')) || !len(arguments.baseURL)){
			arguments.baseURL=getEndPoint() & "/?";

			var params={};
			structAppend(params,url,true);
			structAppend(params,form,true);

			param name="params.method" default=arguments.method;

			if(params.method=='undefined'){
				params.method=arguments.method;
			}

			for(var u in params){
				if(u!='pageIndex'){
					arguments.baseURL= arguments.baseURL & "&#lcase(u)#=#params[u]#";
				}
			}
		}

		var nextIndex = (result.pageIndex < result.totalPages) ? result.pageIndex+1 : 1;
		var prevIndex =(result.pageIndex > 1) ? result.pageIndex-1 : result.totalPages;

		result.links={
			'self'=arguments.baseURL & "&pageIndex=" & result.pageIndex,
			'entities'=getEndpoint()
		};

		if(result.pageIndex > 1){
			result.links['first']=arguments.baseURL & "&pageIndex=" & 1;
			result.links['previous']=arguments.baseURL & "&pageIndex=" & prevIndex;
		}

		if(result.totalPages > 1){
			result.links['last']=arguments.baseURL & "&pageIndex=" & result.totalPages;
		}

		if(result.pageIndex < result.totalPages ){
			result.links['next']=arguments.baseURL & "&pageIndex=" & nextIndex;
		}
		return result;
	}

	function processRequest(path=cgi.path_info){

		try {
			var responseObject=getpagecontext().getResponse();
			var params={};
			var result="";

			param name="request.muraAPIRequestMode" default="json";
			param name="request.muraSessionManagement" default=true;

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
			var apiEnabled=true;
			var sessionData=getSession();

			structDelete(url,application.appreloadkey);

			structAppend(params,url);
			structAppend(params,form);

			if(structKeyExists(headers,'Content-Type')
				&& headers['Content-Type'] == 'application/json'
				&& isJSON(httpRequestData.content)){
				structAppend(params,deserializeJSON(httpRequestData.content));
			}

			if(!request.muraSessionManagement){
				if( structKeyExists( headers, 'X-client_id' )){
					params['client_id']=headers['X-client_id'];
				}

				if( structKeyExists( headers, 'X-client_secret' )){
					params['client_secret']=headers['X-client_secret'];
				}

				if( structKeyExists( headers, 'X-access_token' )){
					params['access_token']=headers['X-access_token'];
				}

				if(isDefined('params.access_token')){
					var token=getBean('oauthToken').loadBy(token=params.access_token);
					structDelete(params,'access_token');
					structDelete(url,'access_token');
					if(!token.exists() || token.getGrantType() != 'client_credentials'){
						params.method='Not Available';
						throw(type='invalidAccessToken');
					} else if (token.isExpired()){
						params.method='Not Available';
						throw(type='accessTokenExpired');
					} else {
						if(isJSON(token.getData())){
							structAppend(getSession(), deserializeJSON(token.getData()), true);
						} else {
							var oauthclient=token.getClient();

							if(!oauthclient.exists()){
								params.method='undefined';
								throw(type='invalidAccessToken');
							} else {
								var clientAccount=oauthclient.getUser();

								if(!clientAccount.exists()){
									params.method='undefined';
									throw(type='invalidAccessToken');
								} else {
									clientAccount.login();
									token.setData(serializeJSON(getSession())).save();
								}
							}
						}
					}
				} else if(!(isDefined('params.client_id') && isdefined('params.client_secret'))){
					params.method='Not Available';
					structDelete(params,'client_id');
					structDelete(params,'client_secret');
					throw(type='authorization');
				} else {
					var oauthclient=getBean('oauthClient').loadBy(clientid=params.client_id);

					//WriteDump(credentials.getAllValues());abort;
					if(!oauthclient.exists() || oauthclient.getClientSecret() != params.client_secret){
						params.method='Not Available';
						structDelete(params,'client_id');
						structDelete(params,'client_secret');
						structDelete(url,'client_id');
						structDelete(url,'client_secret');
						throw(type='authorization');
					} else {
						var clientAccount=oauthclient.getUser();
						structDelete(url,'client_id');
						structDelete(url,'client_secret');
						if(!clientAccount.exists()){
							params.method='undefined';
							structDelete(params,'client_id');
							structDelete(params,'client_secret');
							throw(type='authorization');
						} else {
							if(((arrayLen(pathInfo) == 6
								&& pathInfo[5]=='oauth'
								&& pathInfo[6]=='token')
								|| (
									arrayLen(pathInfo) == 5
									&& pathInfo[4]=='oauth'
									&& pathInfo[5]=='token'
								))
								&& isdefined('params.grant_type')
								&& params.grant_type == 'client_credentials'){
								var token=oauthclient.generateToken(granttype='client_credentials');
								params.method='getOAuthToken';
								result=serializeResponse(
									statusCode=200,
									response={'apiversion'=getApiVersion(),
									'method'=params.method,
									'params'=getParamsWithOutMethod(params),
									'data'={
										'access_token'=token.getToken(),
										'expires_in'=token.getExpiresIn(),
										'expires_at'=token.getExpiresAt()
									 }});
								return result;
							} else {
								structDelete(params,'client_id');
								structDelete(params,'client_secret');
								clientAccount.login();
							}

						}
					}
				}
			} else {
				if( structKeyExists( headers, 'X-csrf_token' )){
				   params['csrf_token']=headers['X-csrf_token'];
			 	}

			   if( structKeyExists( headers, 'X-csrf_token_expires' )){
				   params['csrf_token_expires']=headers['X-csrf_token_expires'];
			   }
			}

			structAppend(form,params);

			param name="sessionData.siteid" default=variables.siteid;

			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);

			request.returnFormat='JSON';

			if (!isDefined('params.method') && arrayLen(pathInfo)){
				if(isValid('variableName',pathInfo[1])){
					if(pathInfo[1]==variables.siteid){
						if(arraylen(pathInfo) > 1 && isValid('variableName',pathInfo[2]) && isDefined('#pathInfo[2]#')){
							params.method=pathInfo[2];
							arrayDeleteAt(pathInfo,2);
						}
					} else if (isDefined('#pathInfo[1]#')){
						params.method=pathInfo[1];
					}
				}
			}

			if (isDefined('params.method') && isDefined('#params.method#')){
				if(!listFindNoCase(variables.config.publicMethods, params.method) ){
					throw(type="invalidMethodCall");
				}

				if(!(listFindNoCase('validate,processAsyncObject,generateCSRFTokens',params.method) || apiEnabled)){
					throw(type='disabled');
				}

				if(arrayLen(pathInfo) > 1){
					parseParamsFromPath(pathInfo,params,2);
				}

				param name="params.siteid" default=variables.siteid;

				if(isDefined('#params.method#')){

					result=evaluate('#params.method#(argumentCollection=params)');

					if(!isJson(result)){
						result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
					} else {
						getpagecontext().getResponse().setContentType('application/json; charset=utf-8');
					}

					return result;
				}
			}

			if(!isDefined('params.method')){
				params.method="undefined";
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

					if(!(listFindNoCase('validate,processAsyncObject',params.method) || apiEnabled)){
						throw(type='disabled');
					}

					if(arrayLen(pathInfo) > 2){
						parseParamsFromPath(pathInfo,params,3);
					}

					result=evaluate('#params.method#(argumentCollection=params)');

					if(!isJson(result)){
						result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
					} else {
						getpagecontext().getResponse().setContentType('application/json; charset=utf-8');
					}

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
						if(arrayLen(pathInfo) >= 4 && params.entityName=='content' && pathInfo[4]=='relatedcontent'){
							var $=getBean('$').init(params.siteid);
							params.method='findRelatedContent';
							url.id=params.id;
							url.siteid=variables.siteid;
							params.siteid=variables.siteid;
							url.entityname=params.entityName;

							if(arrayLen(pathInfo) == 5){
								params.relatedcontentsetid=pathInfo[5];
							} else {
								param name='params.relatedcontentsetid' default='default';
							}

							if(!allowAccess(params.entityName,$)){
								throw(type="authorization");
							}

							result=findRelatedContent(argumentCollection=params);
							result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'='findRelatedContent','params'=getParamsWithOutMethod(params),'data'=result});
							return result;
						}

						if(arrayLen(pathInfo) == 4){
 							if (params.entityName=='content' && pathInfo[4]=='history'){
								var $=getBean('$').init(params.siteid);
								params.method='findVersionHistory';
								url.id=params.id;
								url.entityname='content';

								if(!allowAccess('content',$)){
									throw(type="authorization");
								}

								result=findVersionHistory(argumentCollection=params);
								result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'='findVersionHistory','params'=getParamsWithOutMethod(params),'data'=result});

								return result;
							} else if (listFind('comment,content,category',params.entityName) && pathInfo[4]=='crumbs'){
								var $=getBean('$').init(params.siteid);
								params.method='findCrumbArray';
								url.id=params.id;
								url.siteid=variables.siteid;
								params.siteid=variables.siteid;
								url.entityname=params.entityName;

								if(!allowAccess(params.entityName,$)){
									throw(type="authorization");
								}

								result=findCrumbArray(argumentCollection=params);
								return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'='findCrumbArray','params'=getParamsWithOutMethod(params),'data'=result});

							} else if(isDefined('application.objectmappings.#params.entityName#.properties.#pathInfo[4]#')
							&& structKeyExists(application.objectmappings[params.entityName].properties[pathInfo[4]],'cfc') ){
								var relationship=application.objectmappings[params.entityName].properties[pathInfo[4]];

								if(listFindNoCase('many-to-one,one-to-one',relationship.fieldtype)){
									var entity=getBean(params.entityName);
									params.entityname=relationship.cfc;
									params.method="findOne";
									url.method="findOne";

									if(relationship.loadkey != 'primaryKey'){
										if(params.entityName=='content'){
											var loadByArgs={
												siteid=params.siteid,
												contentid=params.id
											};
										} else {
											var loadByArgs={
												siteid=params.siteid,
												'#entity.getPrimaryKey()#'=params.id
											};
										}
									 	params.id=entity.loadBy(argumentCollection=loadByArgs).get(entity.translatePropKey(relationship.column));
								 	}

									result= findOne(entityName=params.entityName,id=params.id,siteid=params.siteid,params=params);

									return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
								} else {
									var entity=getBean(params.entityName);

									params.entityname=relationship.cfc;
									params.method="findQuery";
									url.method="findQuery";
									url.entityName=params.entityName;

									if(relationship.loadkey == 'primaryKey'){
										params[entity.translatePropKey('primarykey')]=params.id;
										url[entity.translatePropKey('primarykey')]=params.id;
										structDelete(params,'id');
										var result=findQuery(entityName=params.entityName,siteid=params.siteid,params=params,queryString='#entity.translatePropKey(relationship.loadkey)#=#params.id#' );

									} else {
										if(params.entityName=='content'){
											var loadByArgs={
												siteid=params.siteid,
												contentid=params.id
											};
										} else {
											var loadByArgs={
												siteid=params.siteid,
												'#entity.getPrimaryKey()#'=params.id
											};
										}

										entity.loadBy(argumentCollection=loadByArgs);
										params[entity.translatePropKey(relationship.loadkey)]=entity.get(entity.translatePropKey(relationship.column));
										url[entity.translatePropKey(relationship.loadkey)]=params[entity.translatePropKey(relationship.loadkey)];
										structDelete(params,'id');
										var result=findQuery(entityName=params.entityName,siteid=params.siteid,params=params,queryString='#entity.translatePropKey(relationship.loadkey)#=#entity.get(entity.translatePropKey(relationship.column))#' );
									}

									return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});

								}


							}
						} else {
							if(structKeyExists(headers,'X-HTTP-Method-Override')){
								method=headers['X-HTTP-Method-Override'];
							} else {
								method=httpRequestData.method;
							}
						}
					} else if(listFind('new,properties',pathInfo[3])){
						params.id=pathInfo[3];
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
			} else if(params.entityName=="stats"){
				var primaryKey='contentid';
			} else if(params.entityName=="contentCategoryAssign"){
				var primaryKey='notvalid';
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
						if(params.id=='new') {
							params.method='findNew';
							result=findNew(argumentCollection=params);
						} else if(params.id=='properties') {
								params.method='findProperties';
								result=findProperties(argumentCollection=params);
						} else if(listLen(params.id) > 1){
							params.ids=params.id;
							params.method='findMany';
							result=findMany(argumentCollection=params);
						} else {
							params.method='findOne';
							result=findOne(argumentCollection=params);
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

			param name="params.method" default="undefined";

			if(isDefined('result.errors') && isStruct(result.errors) && !StructIsEmpty(result.errors)){
				return serializeResponse(statusCode=405,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
			} else {
				return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
			}

		}

		catch (authorization e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'='Insufficient Account Permissions'}});
		}

		catch (invalidAccessToken e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'='Invalid Access Token'}});
		}

		catch (accessTokenExpired e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'='Access Token Expired'}});
		}

		catch (disabled e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'='The JSON API disabled'}});
		}

		catch (invalidParameters e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'='Insufficient parameters'}});
		}

		catch (invalidMethodCall e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'="Invalid method call"}});
		}

		catch (badRequest e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'="Bad Request"}});
		}

		catch (invalidTokens e){
			param name="params.method" default="undefined";
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='invalid_request','message'="Invalid CSRF tokens"}});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			param name="params.method" default="undefined";

			if(getBean('configBean').getDebuggingEnabled()){
				return serializeResponse(statusCode=500,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='server_error','message'="Unhandled Exception",'stacktrace'=e}});
			} else {
				return serializeResponse(statusCode=500,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={code='server_error','message'="Unhandled Exception"}});
			}

		}

	}

	function serializeResponse(response,statusCode=200){
		var responseObject=getpagecontext().getResponse();
		responseObject.setContentType('application/json; charset=utf-8');
		try{
			if(responseObject.getStatus() != 404){
				responseObject.setStatus(200);
			}
		} catch (Any e){}

		if(isDefined('arguments.response.data.shunter') && arguments.response.data.shunter){
			if(isDefined('arguments.response.data.layout')){
				responseObject.setContentType('application/x-shunter+json; charset=utf-8');
				arguments.response.layout=arguments.response.data.layout;
			}
		}

		return getSerializer().serialize(arguments.response);
	}

	function getApiVersion(){
		return 'v1';
	}

	function applyPropertyFormat(prop){
		arguments.prop=structCopy(prop);
		structDelete(arguments.prop,'table');
		structDelete(arguments.prop,'column');
		structDelete(arguments.prop,'nested');
		structDelete(arguments.prop,'comparable');
		structDelete(arguments.prop,'ormtype');
		structDelete(arguments.prop,'type');
		structDelete(arguments.prop,'persistent');
		arguments.prop.name=lcase(arguments.prop.name);

		if(arguments.prop.datatype=='string'){
			arguments.prop.datatype='varchar';
		} else if(listFindNoCase('integer,numeric',arguments.prop.datatype)){
			arguments.prop.datatype='int';
		} else if(listFindNoCase('timestamp',arguments.prop.datatype)){
			arguments.prop.datatype='datetime';
		}

		if(structKeyExists(arguments.prop,'cfc')){
			arguments.prop.relatesto=prop.cfc;
			structDelete(arguments.prop,'cfc');
		}

		if(arguments.prop.datatype=='varchar' && !structKeyExists(arguments.prop,'length')){
			arguments.prop.length=50;
		}

		return arguments.prop;
	}

	function findProperties(entityname,properties=''){
		var props=getBean(arguments.entityname).getProperties();
		var propArray=listToArray(arguments.properties);
		var returnArray=[];
		var prop='';

		if(arrayLen(propArray)){
			for(var p in propArray){
				if(props[p].persistent){
					arrayAppend(returnArray,applyPropertyFormat(props[p]));
				}
			}
		} else {
			for(var p in props){
				if(props[p].persistent){
					arrayAppend(returnArray,applyPropertyFormat(props[p]));
				}
			}
		}

		var result=formatArray(returnArray);
		structAppend(result,{
			entityname=arguments.entityname,
			links={
				endpoint=getEndpoint() & "/" & arguments.entityname,
				entities=getEndpoint()
			}
			});
		return result;
	};

	function getParamsWithOutMethod(params){
        var temp={};
        structAppend(temp,arguments.params);
        structDelete(temp,'method');
		structDelete(temp,'_cacheid');

        for(var p in temp){
            if(find('[',p)){
                structDelete(temp,listFirst(p,'[') & listFirst(listLast(p,'['),']'));
            }

            //Don't respond with file paths information
            if(structKeyExists(temp,'#p#') && isSimpleValue(temp['#p#']) && refind('[\\/]',temp['#p#'])){
                structDelete(temp,'#p#');
            }

        }
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
		var sessionData=getSession();
		return (isDefined('sessionData.siteid') && isDefined('sessionData.mura.requestcount') && sessionData.mura.requestcount > 1);
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
				listFind('address,user,group',entityName)
				&& !(
					$.currentUser().isAdminUser()
					|| $.currentUser().isSuperUser()
					|| $.event('id') == $.currentUser().getUserID()
					|| getBean('permUtility').getModulePerm(variables.config.entities['#entityName#'].moduleid,variables.siteid)
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

				return true;

			break;
			case 'user':
			case 'group':
			case 'address':
				if(getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid)){
					return true;
				} else if (arguments.bean.getValue('userid')==$.currentUser('userid')){
					return true;
				} else {
					return false;
				}
				break;
			default:
				if (isDefined('variables.config.entities.#arguments.bean.getEntityName()#.moduleid')) {
					return getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid);
				} else {
					return getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid);
				}
		}

		return false;

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

		if(arguments.format=='fullcalendar'){
			return calendarUtility.fullCalendarFormat(
				calendarUtility.getCalendarItems(argumentCollection=arguments)
			);
		} else {
			return $.getCalendarUtility().getCalendarItems(argumentCollection=arguments);
		}
	}

	// MURA ORM ADAPTER

	function save(siteid,entityname,id='new',expand=''){

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityName=='user'){
			if(!getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid)){
				if(!(arguments.$.currentUser().isAdminUser() || arguments.$.currentUser().isSuperUser())){
					var vals=$.event().getAllValues();
					structDelete(vals,'isPublic');
					structDelete(vals,'s2');
					structDelete(vals,'type');
					structDelete(vals,'groupID');
				}
			}
		}

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
				try{
					$.event('body',urlDecode($.event('body')));
				} catch (any e){
					$.event('body','');
				}
			}
		} else {
			var loadByparams={'#pk#'=arguments.id};
		}

		if(!request.muraSessionManagement || $.validateCSRFTokens(context=arguments.id)){
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

		var returnStruct=getFilteredValues(entity,true,entity.getEntityName(),arguments.siteid,arguments.expand,pk);

		returnStruct.saveErrors=saveErrors;
		returnStruct.errors=errors;

		return returnStruct;
	}

	function getFilteredValues(entity,expand=true,entityConfigName,siteid,expandLinks='',pk=''){
		var fields='';
		var vals={};

		if(!(isDefined('variables.config.entities.#arguments.entityConfigName#.allowfieldselect') && !variables.config.entities[entityConfigName].allowfieldselect) && (isDefined('url.fields') && len(url.fields))){
			fields=url.fields;

			if(arguments.entity.getEntityName()=='content' && !listFindNoCase(fields,'contentid')){
				fields=listAppend(fields,'contentid');
			} else if (arguments.entity.getEntityName()!='content' && !listFindNoCase(fields,arguments.entity.getPrimaryKey())){
				fields=listAppend(fields,arguments.entity.getPrimaryKey());
			}

			if(!listFindNoCase(fields,'siteid')){
				fields=listAppend(fields,'siteid');
			}
		} else if(isDefined('variables.config.entities.#arguments.entityConfigName#.fields') && len(variables.config.entities[arguments.entityConfigName].fields)){
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

		if(len(arguments.pk)){
			vals.id=arguments.entity.getValue(pk);
		}

		if(!arrayLen(fields) || arrayFind(fields,'links')){
			vals.links=getLinks(entity);
		}

		if(listFindNoCase('content,contentnav',arguments.entityConfigName)){
			if(!arrayLen(fields) || arrayFind(fields,'images')){
				vals.images=setImageURLS(entity);
			}
			if(!arrayLen(fields) || arrayFind(fields,'url')){
				vals.url=entity.getURL(complete=true);
			}
		}

		vals['entityname']=arguments.entityConfigName;

		if(len(arguments.expandLinks)){
			expandEntity(entity=arguments.entity,itemStruct=vals,siteid=arguments.siteid,expand=arguments.expandLinks);
		}

		return vals;
	}

	function findCurrentUser(entityName,id,siteid,render=false,variation=false,expand=''){
		var $=getBean('$').init(arguments.siteid);

		return findOne(
			entityName='user',
			id=$.currentUser('userid'),
			siteid=arguments.siteid,
			expand=arguments.expand,
			method='findCurrentUser'
		);
	}

	function findOne(entityName,id,siteid,render=false,variation=false,expand='',method='findOne'){
		var $=getBean('$').init(arguments.siteid);

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		if(arguments.entityName=='content'){
			var pk = 'contentid';

			if(arguments.render){
				if(arguments.variation){
					var pointer=$.getBean('remoteContentPointer').loadBy(remoteid=id);

					if(pointer.exists()){
						var content=pointer.getContent();
					} else {
						var content=$.getBean('content').loadBy(remoteid=id);
					}

					url.linkservid=content.getContentID();

					if(!content.exists()){
						content.setType('Variation');
						content.setIsNew(1);
						content.setRemoteID(id);
						content.setModuleID('00000000000000000000000000000000099');
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

		if(arguments.method !='findCurrentUser'){
			if(!allowAccess(entity,$)){
				throw(type="authorization");
			}

			if(!entity.allowRead($)){
				throw(type="authorization");
			}
		}

		var returnStruct=getFilteredValues(entity,true,arguments.entityName,arguments.siteid,arguments.expand,pk);

		if(isDefined('url.ishuman')){
			request.cffpJS=true;
			returnstruct.ishuman=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
		}

		return returnStruct;
	}

	function findNew(entityName,siteid,expand=''){

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

		var returnStruct=getFilteredValues(entity,true,entity.getEntityName(),arguments.siteid,arguments.expand,pk);

		if(isDefined('url.ishuman')){
			request.cffpJS=true;
			returnstruct.ishuman=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
		}

		return returnStruct;
	}

	function expandEntity(entity,itemStuct,siteid,expand=''){

		if(len(arguments.expand)){
			var p='';
			var expandParams={};
			var queryString='';
			var q='';

			if(arrayLen(arguments.entity.getHasManyPropArray())){
				for(p in arguments.entity.getHasManyPropArray()){
					if(arguments.expand=='all' || listFindNoCase(arguments.expand,p.name)){
						expandParams={};
						expandParams['#arguments.entity.translatePropKey(p.loadkey)#']=entity.getValue(arguments.entity.translatePropKey(p.column),createUUID());

						//try{
							arguments.itemStruct[p.name]=findQuery(entityName=p.cfc,siteid=arguments.siteid,params=expandParams,expanded=true);
						//} catch(any e){WriteDump(p); abort;}

					}
				}
			}

			if(arrayLen(arguments.entity.getHasOnePropArray())){
				for(p in arguments.entity.getHasOnePropArray()){
					if(arguments.expand=='all' || listFindNoCase(arguments.expand,p.name)){
						//try{
							if(p.name=='site'){
								arguments.itemStruct[p.name]=findOne(entityName='site',id=arguments.entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand='');
							} else {
								arguments.itemStruct[p.name]=findOne(entityName=p.cfc,id=arguments.entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand='');
							}
						//} catch(any e){WriteDump(p); abort;}
					}
				}
			}

			if(arguments.expand=='all' || listFindNoCase(arguments.expand,'crumbs')){
				if(isDefined('arguments.itemStruct.links.crumbs') && isDefined('arguments.itemStruct.path')){
					arguments.itemStruct.crumbs=findCrumbArray(arguments.itemStruct.entityName,arguments.itemStruct.id,arguments.siteid,arguments.entity.getCrumbIterator());
				}
			}

		}

	}

	function findAll(siteid,entityName,params,expand=''){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityName=='entityname'){
			var returnArray=[];
			var entityKeys=listToArray(ListSort(StructKeyList(variables.config.entities),'textnocase'));
			for(var i in entityKeys){
				if(allowAccess(i,$,false)){
					arrayAppend(returnArray,{entityname=i,links={endpoint=getEndPoint() & "/" & i,properties=getEndPoint() & "/" & i & "/properties"}});
				}
			}
			return {items=returnArray,links={self=getEndPoint()},entityname='entityname'};
		}

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		if(!entity.allowQueryParams(arguments.params,$,$)){
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
			throw(type="invalidParameters");
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
			itemStruct=getFilteredValues(item,false,entityConfigName,arguments.siteid,arguments.expand,pk);

			arrayAppend(returnArray, itemStruct);
		}

		return packageIteratorArray(iterator,returnArray,'findall');
	}

	function findMany(entityName,ids,siteid,params,expand=''){
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

			if(isDefined('item.allowRead') && !entity.allowRead($)){
				throw(type="authorization");
			}

			itemStruct=getFilteredValues(item,false,entityConfigName,arguments.siteid,arguments.expand,pk);

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

		return packageIteratorArray(iterator,finalArray,'findmany');
	}

	function findQuery(entityName,siteid,params,queryString=cgi.QUERY_STRING,expand='',expanded=false){

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

		if(!entity.allowQueryParams(arguments.params,$,$)){
			throw(type="authorization");
		}

		if(entity.getEntityName()=='user'){
			if(isDefined('arguments.params.isPublic') && isNumeric($.event('isPublic'))){
				feed.setIsPublic($.event('isPublic'));
			} else {
				feed.setIsPublic('all');
			}
		}

		var baseURL=getEndPoint() & "/#entity.getEntityName()#/?";

		if(arguments.expanded){
			var started=false;

			for(var p in arguments.params){
				if(!listFindNoCase('maxItems,pageIndex,sort,itemsPerPage,sortBy,sortDirection,contentpoolid,shownavonly,showexcludesearch,includehomepage',p)){
					feed.addParam(column=p,criteria=arguments.params[p]);

					if(started){
						baseURL=baseURL & '&';
					}

					baseURL=baseURL & p & '=' & arguments.params[p];
					started=true;
				}
			}

		} else {
			var queryParams=[];

			for(var i in listToArray(arguments.queryString,'&')){
				var checkProp=urlDecode(listFirst(i,'='));
				if(checkProp!='pageIndex'){
					ArrayAppend(queryParams, checkProp);
				}
			}

			var propName='';
			var propIndex=0;
			var relationship='and';
			var started=false;
			var advancedsort='';

			for(var p in queryParams){
				if(find('[',p)){
					propName=listFirst(p,'[');
					propIndex=listFirst(listlast(p,'['),']');
					structDelete(arguments,propName & propIndex);
				} else {
					propName=p;
				}

				if(propname=='changesetid'){
					feed.setActiveOnly(0);
				}

				if(structKeyExists(params,p)){
					if(started){
						baseURL=baseURL & '&' & esapiEncode('url',p);
					} else {
						baseURL=baseURL & esapiEncode('url',p);
						started=true;
					}

					if(len(params[p])){
						baseURL=baseURL & '=' & esapiEncode('url',params[p]);
					}

					if(!listFindNoCase('maxItems,pageIndex,itemsPerPage,sortBy,sortDirection,contentpoolid,shownavonly,showexcludesearch,includehomepage',p)){
						if(propName == 'sort'){
							advancedsort=listAppend(advancedsort,arguments.params[p]);
						} else if(!(entity.getEntityName()=='user' && propName=='isPublic')){
							if(entity.getEnityName()=='user' && propName=='groupid'){
								feed.setGroupID(arguments.params[p]);
							} else if(entity.valueExists(propName)){
								var condition="eq";
								var criteria=arguments.params[p];

								if(listLen(criteria,"^") > 1){
									condition=listFirst(criteria,'^');
									criteria=listGetAt(criteria,2,'^');
								} else if(find('*',criteria)){
									condition="like";
									criteria=replace(criteria,'*','%','all');
								}

								feed.addParam(column=propName,criteria=criteria,condition=condition,relationship=relationship);
								relationship='and';
							} else if(propName=='or'){
								relationship='or';
							} else if(listFindNoCase('openGrouping,orOpenGrouping,andOpenGrouping,closeGrouping',propName)){
								feed.addParam(relationship=p);
								relationship='and';
							} else if(propname=='innerJoin'){
								feed.innerJoin(relatedEntity=params[p]);
							} else if(propname=='leftJoin'){
								feed.leftJoin(relatedEntity=params[p]);
							}
						}
					}
				}

				if(len(advancedsort)){
					params.sort=advancedsort;
				}
			}
		}

		setFeedProps(feed,arguments.params);

		if(isdefined('arguments.params.countOnly') && isBoolean(arguments.params.countOnly) && arguments.params.countOnly){
			return {count=feed.getAvailableCount()};
		} else {
			var iterator=feed.getIterator();
			setIteratorProps(iterator=iterator);
			var returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand);
			return packageIteratorArray(iterator=iterator,itArray=returnArray,method='findQuery',baseURL=baseURL,expanded=arguments.expanded);
		}

	}

	function iteratorToArray(iterator,siteid,expand=''){
		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';
		var entityName=arguments.iterator.getEntityName();

		if(listFindNoCase('content,contentnav',entityName)){
			var pk="contentid";
		} else if (entityName== 'feed'){
			var pk="feedid";
		} else {
			var pk=application.objectMappings[entityName].primarykey;
		}

		if(entityName=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entityName;
		}

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,false,entityConfigName,arguments.siteid,arguments.expand,pk);

			arrayAppend(returnArray, itemStruct );
		}

		//writeDump(var=$.event('pageIndex'),abort=1);
		return returnArray;
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

		if(isDefined('arguments.params.contentpoolid') && len(arguments.params.contentpoolid)){
			if(arguments.params.contentpoolid == '*'){
				feed.setContentPoolID('*');
			} else {
				var poolrequest=[];
				var requestedPoolArray=listToArray(arguments.params.contentpoolid);
				var validPools=getBean('settingsManager').getSite(variables.siteid).getContentPoolID();

				for(var c in requestedPoolArray){
					if(listFindNoCase(validPools,c)){
						arrayAppend(poolrequest,c);
					}
				}

				if(arrayLen(poolrequest)){
					feed.setContentPoolID(arrayToList(poolrequest));
				}
			}
		}


		if(isDefined('params.entityname')
			&& listFind('content,contentnav',params.entityname)
		){
			if(isDefined('params.changesetid')
			&& len(params.changesetid)){
				feed.setActiveOnly(0);
			}

			if(isDefined('params.type')
				&& len(params.type)
				&& listFindNoCase('form,component,variation',params.type)
			){
				feed.setType(params.type);
			}
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

		if(isDefined('params.entityName') && listFind('content,contentnav',params.entityname)){
			if(isDefined('arguments.params.includeHomePage')){
				if(isBoolean(arguments.params.includeHomePage)){
					if(arguments.params.includeHomePage){
						arguments.feed.setIncludeHomePage(1);
					} else {
						arguments.feed.setIncludeHomePage(0);
					}
				}
			}

			if(isDefined('arguments.params.shownavonly')){
				if(isBoolean(arguments.params.shownavonly)){
					if(arguments.params.shownavonly){
						arguments.feed.setShowNavOnly(1);
					} else {
						arguments.feed.setShowNavOnly(0);
					}
				}
			}

			if(isDefined('arguments.params.showexcludesearch')){
				if(isBoolean(arguments.params.showexcludesearch)){
					if(arguments.params.showexcludesearch){
						arguments.feed.setShowExcludeSearch(1);
					} else {
						arguments.feed.setShowExcludeSearch(0);
					}
				}
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

	function findCrumbArray(entityName,id,siteid,iterator,expand=''){

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityname == 'contentnav'){
			arguments.entityname='content';
		}
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
			itemStruct=getFilteredValues(item,false,entityConfigName,arguments.siteid,arguments.expand,pk);

			arrayAppend(returnArray, itemStruct );
		}

		return packageIteratorArray(arguments.iterator,returnArray,'findCrumbArray');
	}


	function findVersionHistory(id,siteid,expand=''){

		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean('content');
		var crumbdata=getBean('contentManager').getCrumbList(arguments.id,arguments.siteid);
		var perm=getBean('permUtility').getNodePerm(crumbData);

		if(!listFindNoCase('author,editor',perm)){
			throw(type="authorization");
		}

		var iterator=entity.loadBy(contentid=arguments.id).getVersionHistoryIterator();
		setIteratorProps(iterator);
		var returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand);
		return packageIteratorArray(iterator,returnArray,'findVersionHistory');
	}


	function delete(entityName,id,siteid){

		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if($.event('entityName')=='content'){
			if(len($.event('contenthistid'))){
				var loadparams={contenthistid=$.event('contenthistid')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

					if(!request.muraSessionManagement || $.validateCSRFTokens(context=arguments.id)){
						entity.deleteVersion();
					}
				}
			} else {
				var loadparams={contentid=$.event('id')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

					if(!request.muraSessionManagement || $.validateCSRFTokens(context=arguments.id)){
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
				if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

				if(!request.muraSessionManagement || $.validateCSRFTokens(context=arguments.id)){
					entity.delete();
				} else {
					throw(type="invalidTokens");
				}
			}
		}

		return '';
	}

	function getEndPoint(mode='json'){
		if(request.muraApiRequest){
			var configBean=getBean('configBean');
			if(!isDefined('request.apiEndpoint')){

				if(getBean('configBean').getAdminSSL()){
					var protocol='https';
				} else {
					var protocol=getBean('utility').getRequestProtocol();
				}

				var domain=cgi.server_name;

				request.apiEndpoint="#protocol#://#domain##configBean.getServerPort()##configBean.getContext()#/index.cfm/_api/#request.muraAPIRequestMode#/v1/#variables.siteid#";
			}
			return request.apiEndpoint;
		}

		if(arguments.mode=='json'){
			return variables.endpoint;
		} else {
			return replace(variables.endpoint,'/json/','/rest/');
		}

	}

	function getLinks(entity){
		var links={};
		var p='';
		var baseURL=getEndPoint();
		var id='';

		links.entities=baseURL;

		/*
		if(listFindNoCase('user',entity.getEntityName())){
			links['members']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
			//links['memberships']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
		}
		*/
		links['all']="#baseurl#/#entity.getEntityName()#";
		links['properties']="#baseurl#/#entity.getEntityName()#/properties";

		if(entity.getEntityName()=='content'){
			links['self']="#baseurl#/content/#entity.getContentID()#";
			links['history']="#baseurl#/content/#entity.getContentID()#/history";
			links['rendered']="#baseurl#/content/_path/#entity.getFilename()#";
			if(entity.getType()=='Variation'){
				links['self']=links['rendered'];
			} else {
				links['crumbs']="#baseurl#/#entity.getEntityName()#/#entity.getValue('contentid')#/crumbs";
			}
			links['relatedcontent']="#baseurl#/#entity.getEntityName()#/#entity.getValue('contentid')#/relatedcontent";
		} else if(entity.getEntityName()=='category'){
			links['crumbs']="#baseurl#/#entity.getEntityName()#/#entity.getValue('categoryid')#/crumbs";
			links['self']="#baseurl#/#entity.getEntityName()#/#entity.getvalue(entity.getPrimaryKey())#";
		} else if(entity.getEntityName()=='site'){
			links['self']="#baseurl#/site";
		} else {
			links['self']="#baseurl#/#entity.getEntityName()#/#entity.getvalue(entity.getPrimaryKey())#";
		}

		if(listFindNoCase('feed,contentFeed',entity.getEntityName())){
			links['feed']="#baseurl#/content/?feedid=#entity.getFeedID()#";
		}

		if(arrayLen(entity.getHasManyPropArray())){
			try{
			for(p in entity.getHasManyPropArray()){
				links[p.name]="#baseurl#/#p.cfc#?#entity.translatePropKey(p.loadkey)#=#entity.getValue(entity.translatePropKey(p.column))#";
				//links[p.name]="#links['self']#/#p.name#";
			}
		} catch(any e){/*writeDump(var=p,abort=true);*/}
		}

		if(arrayLen(entity.getHasOnePropArray())){
			for(p in entity.getHasOnePropArray()){
				if(p.name=='site'){
					links[p.name]="#baseurl#/site";
				} else {
					if(len(entity.getValue(entity.translatePropKey(p.column)))){
						links[p.name]="#baseurl#/#p.cfc#/#entity.getValue(entity.translatePropKey(p.column))#";
					}
				}
			}
		}

		if(arrayLen(variables.config.linkMethods)){
			for(var i in variables.config.linkMethods){
				evaluate('#i#(entity=arguments.entity,links=links)');
			}
		}

		return links;
	}

	function findRelatedContent(id,siteid,params,arguments,expand=''){
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
		var returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand);
		return packageIteratorArray(iterator,returnArray,'findRelatedContent');
	}

	function applyRemoteFormat(str){

		//arguments.str=replaceNoCase(str,"/index.cfm","",'all');
		//arguments.str=replaceNoCase(str,'href="/','href="##/','all');
		//arguments.str=replaceNoCase(str,"href='/","href=''##/",'all');

		return trim(arguments.str);
	}

	function setImageURLs(entity){

		if(arguments.entity.hasImage()){
			if(!isDefined('variables.images')){
				variables.images=getBean('settingsManager').getSite(entity.getSiteID()).getCustomImageSizeIterator();
			}

			var secure=getBean('settingsManager').getSite(entity.getSiteID()).getUseSSL();

			var returnStruct={
				small=entity.getImageURL(secure=secure,complete=1,size='small'),
				medium=entity.getImageURL(secure=secure,complete=1,size='medium'),
				large=entity.getImageURL(secure=secure,complete=1,size='large'),
				source=entity.getImageURL(secure=secure,complete=1,size='source')
			};

			var image='';

			while(variables.images.hasNext()){
				image=variables.images.next();
				returnStruct['#image.getName()#']=entity.getImageURL(secure=secure,complete=1,size=image.getName());
			}
			variables.images.reset();
		} else {
			var returnStruct={};
		}

		return returnStruct;

	}

	function validate(data='{}',validations='{}') {

		arguments.data=urlDecode(arguments.data);

		if(isJSON(arguments.data)){
			arguments.data=deserializeJSON(arguments.data);
		} else {
			throw(type="invalidParameters");
		}

		arguments.validations=urlDecode(arguments.validations);

		if(isJSON(arguments.validations)){
			arguments.validations=deserializeJSON(arguments.validations);
		} else {
			throw(type="invalidParameters");
		}

		if(!isStruct(arguments.data)){
			return {invalid='Invalid validation request'};
		}

		param name="data.fields" default="";

		if(structIsEmpty(arguments.validations) && isDefined('data.entityname') && isDefined('data.siteid')){
			var bean=getBean(arguments.data.entityname);
			var args={'#bean.getPrimaryKey()#'=arguments.data[bean.getPrimaryKey()]
			};

			return bean.loadBy(argumentCollection=args).set(arguments.data).validate(arguments.data.fields).getErrors();

		}

		errors={};

		if(!structIsEmpty(arguments.validations)){

			structAppend(errors,new mura.bean.bean()
				.set(data)
				.setValidations(arguments.validations)
				.validate(arguments.data.fields)
				.getErrors()
			);
		}

		if(isDefined('arguments.data.bean') && isDefined('arguments.data.loadby')){
			structAppend(errors,
				getBean(arguments.data.bean)
				.loadBy(arguments.data.loadby=arguments.data[arguments.data.loadby],siteid=arguments.data.siteid)
				.set(arguments.data)
				.validate(arguments.data.fields)
				.getErrors()
			);
		}

		return errors;

	}

	function processAsyncObject(siteid){
		var sessionData=getSession();

		if(!isDefined('arguments.siteid')){
			if(isDefined('sessionData.siteid')){
				arguments.siteid=sessionData.siteid;
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
		$.event().getHandler('standardSetIsOnDisplay').handle($.event());

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
							if(isDefined('sessionData.mfa')){
								$.event('status','challenge');
							} else {
								$.event('status','failed');
							}
						}
					}
				}

				if(!isStruct(result)){
					result={
						html=applyRemoteFormat($.dspObject('login'))
					};
				}

				break;

			case 'search':
				result={
					html=applyRemoteFormat($.dspObject('search'))
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
						if(sessionData.mura.isLoggedIn){
							var eventStruct=$.event().getAllValues();

							structDelete(eventStruct,'isPublic');
							structDelete(eventStruct,'s2');
							structDelete(eventStruct,'type');
							structDelete(eventStruct,'groupID');
							eventStruct.userid=sessionData.mura.userID;

							$.setValue('passedProtect', $.getBean('utility').isHuman($.event()));

							$.event().setValue("userID",sessionData.mura.userID);

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
							html=applyRemoteFormat($.dspObject('editprofile'))
						};
				}

				break;

			default:

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
						cacheKey=CGI.QUERY_STRING,
						returnFormat='struct'
					};

				if(len($.event('objectparams')) && !isJson($.event('objectparams'))){
					args.params=urlDecode($.event('objectparams'));
				} else {
					args.params={};

					if(isDefined('url') && isStruct(url)){
						for(var u in url){
							if(!listFindNoCase('perm,contentid,contenthistid,object,objectid,siteid,nocache',u)){
								args.params['#u#']=url['#u#'];
							}
						}
					}

					if(isDefined('form') && isStruct(form)){
						for(var f in form){
							if(!listFindNoCase('perm,contentid,contenthistid,object,objectid,siteid,nocache',f)){
								args.params['#f#']=form['#f#'];
							}
						}
					}

				}

				if(listFindNoCase('folder,gallery,calendar,page',$.event('object'))){
					result={
						html=$.getContentRenderer().dspContentTypeBody(params=args.params)
					};
					break;
				}

				result=$.dspObject(argumentCollection=args);

				if(isdefined('request.muraJSONRedirectURL')){
					result={redirect=request.muraJSONRedirectURL};
				} else {
					if($.useLayoutManager() && isdefined('result.html') && result.render=='server'){
						result={render='server',async=true,html=trim('#$.dspObject_include(theFile='object/meta.cfm',params=args.params)#<div class="mura-object-content">#result.html#</div>')};
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

	function swagger(siteid,params){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		var result={
			"swagger"= "2.0",
			"info"= {
				"description"= "This is the JSON API for #$.siteConfig().getRootPath(complete=1)#",
				"version"= "1.0.0",
				"title"= $.siteConfig('site'),
				"termsOfService"= "http://swagger.io/terms/",
				"contact"= {
				"email"= $.siteConfig('contact')
			},
			"license"= {
				"name"= "GPL-2.0 with execptions",
				"url"= "https://github.com/blueriver/MuraCMS/blob/develop/license.txt"
			}
			},
			"host": $.siteConfig('domain'),
			"basePath"= $.siteConfig().getApi('JSON','v1').getEndPoint(),
			"tags": [
				{
					"name"= "Mura CMS",
					"description"= "Open source content management system",
					"externalDocs"= {
					"description"= "Find out more",
					"url": "http://www.getmura.com"
					}
				}
			],
			"schemes"= [
			$.getBean('utility').getRequestProtocol()
			],
			'paths'={},
			'definitions'={}
		};

		var entityKeys=listToArray(ListSort(StructKeyList(variables.config.entities),'textnocase'));

		for(var i in entityKeys){
			if(allowAccess(i,$,false)){

				result['paths']['/#lcase(i)#']={
					"post"= {
						"tags"= [
							i
						],
						"summary"= "Saves a #i#",
						"description"= "",
						"operationId"= "save#$.getBean('utility').setProperCase(i)#",
						"consumes"= [
							"application/json"
						],
						"produces"= [
							"application/json"
						],
						"parameters"= [

						],
						"responses"= {
							"405"= {
								"description": "Invalid input"
							}
						},
						"security"= [
							{
								"#$.event('siteid')#_auth"= [
									"write:#lcase(i)#",
									"read:#lcase(i)#"
								]
							}
						]

					}
				};
			}
		}

		return serializeJSON(result);
	}

}
