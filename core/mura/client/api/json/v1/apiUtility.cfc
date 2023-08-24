component extends="mura.cfobject" hint="This provides JSON/REST API functionality" {

	function init(siteid){
		var tracepoint=initTracePoint("Instantiating API Utility for: #siteid#");
		variables.siteid=arguments.siteid;

		var configBean=getBean('configBean');
		var context=configBean.getContext();
		var site=getBean('settingsManager').getSite(variables.siteid);
		var renderer=site.getContentRenderer();
		variables.useDataNamespaceForAPI=configBean.getValue(property='useDataNamespaceForAPI',defaultValue=true);

		if(isDefined('renderer.useDataNamespaceForAPI') && isBoolean(renderer.useDataNamespaceForAPI)){
			variables.useDataNamespaceForAPI=renderer.useDataNamespaceForAPI;
		}

		/*
		if( getBean('utility').isHTTPS() || YesNoFormat(site.getUseSSL()) ){
			var protocol="https://";
		} else {
			var protocol=©"http://";
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
			publicMethods="undeclareEntity,declareEntity,checkSchema,findOne,findMany,findAll,findPermissions,findProperties,findNew,findQuery,save,delete,findCrumbArray,generateCSRFTokens,validateEmail,login,logout,submitForm,findCalendarItems,validate,processAsyncObject,findRelatedContent,getURLForImage,findVersionHistory,findCurrentUser,swagger",
			entities={
				'contentnav'={
					public=true,
					moduleid='00000000000000000000000000000000000',
					fields="links,images,parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew,remoteid,remoteurl"
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
	      	.asBoolean('saveErrors')
			.asBoolean('scaffold')
			.asBoolean('dynamic')
			.asInteger('expires_at')
			.asInteger('expires_in');

	    registerEntity('site',{
	    	public=true,
			fields="links,links,domain,siteid",
			allowfieldselect=false
		});

		registerEntity('content',{
			public=true,
			fields="links,images,parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew,remoteid,remoteurl"
		});

		registerEntity('comment',{
			public=true,
			moduleid='00000000000000000000000000000000015',
			fields="links,entered,isspam,flagcount,parentid,name,isapproved,kids,isdeleted,userid,subscribe,isnew,contentid,path,siteid,id,remoteid,contenthistid"
		});

		registerEntity('user',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('group',{
			public=false,
			moduleid='00000000000000000000000000000000008',
			fields="links,userid,groupname,ispublic,siteid,type,subtype,remoteid"
		});
		registerEntity('address',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('changeset',{public=false,moduleid='00000000000000000000000000000000014'});
		registerEntity('feed',{public=false,moduleid='00000000000000000000000000000000011'});
		registerEntity('category',{public=true,moduleid='00000000000000000000000000000000010'});
		registerEntity('contentCategoryAssign',{public=true,moduleid='00000000000000000000000000000000000'});
		registerEntity('file',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('fileMetaData',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('changesetCategoryAssignment',{public=false,moduleid='00000000000000000000000000000000000'});
		registerEntity('stats',{public=false,moduleid='00000000000000000000000000000000000'});
		//registerEntity('entity',{public=false,moduleid='00000000000000000000000000000000000',fields="entityid,name,dynamic,scaffold,bundleable,displayname",allowfieldselect=false});

		if(getBean('configBean').getValue(property='variations',defaultValue=false)){
			registerEntity('variationTargeting',{public=false,moduleid='00000000000000000000000000000000000'});
		}

		commitTracePoint(tracepoint);
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

	function declareEntity(entityConfig){
			var $=getBean('$').init(variables.siteid);

			if(!request.muraSessionManagement || $.validateCSRFTokens()){
				if(!getCurrentUser().isSuperUser()){
					throw(type="authorization");
				}

				if(!isJSON(arguments.entityConfig)){
					arguments.entityConfig=URLDecode(arguments.entityConfig);

					if(!isJSON(arguments.entityConfig)){
						throw(type="invalidParameters");
					}
				}

				var obj=deserializeJSON(arguments.entityConfig);

				if(!StructKeyExists(obj, "entityName")){
					throw(type="invalidParameters");
				}

				if(getServiceFactory().containsBean(obj.entityname) && !getBean(obj.entityname).getDynamic()){
					throw(type="invalidParameters");
				}

				param name="obj.public" default=false;
				var rsSites=getBean('settingsManager').getList();
				getServiceFactory().declareBean(json=arguments.entityConfig,siteid=valueList(rsSites.siteid));
				//application.appInitialized=false;

				return findProperties(obj.entityName);
			} else {
				throw(type="invalidTokens");
			}
	}

	function undeclareEntity(entityname,deleteSchema=false){
			var $=getBean('$').init(variables.siteid);

			if(!request.muraSessionManagement || $.validateCSRFTokens()){
				if(!getCurrentUser().isSuperUser()){
					throw(type="authorization");
				}
				if(getServiceFactory().containsBean(arguments.entityname) && getBean(arguments.entityname).getDynamic()){
					getServiceFactory().undeclareBean(arguments.entityname,arguments.deleteSchema);
					structDelete(getConfig(),arguments.entityname);
					//application.appInitialized=false;
					return {success:true};
				} else {
					return {success:false};
				}
			} else {
				throw(type="invalidTokens");
			}
	}

	function checkSchema(entityname){
			var $=getBean('$').init(variables.siteid);

			if(!request.muraSessionManagement || $.validateCSRFTokens()){
				if(!getCurrentUser().isSuperUser()){
					throw(type="authorization");
				}
				if(getServiceFactory().containsBean(arguments.entityname)){
					getBean(arguments.entityname).checkSchema();
					return {success:true};
				} else {
					return {success:false};
				}
			} else {
				throw(type="invalidTokens");
			}
	}

	function registerEntity(entityName, config={public=false,fields=''},beanInstance=''){

		if(!isDefined('arguments.config.public')){
			arguments.config.public=false;
		}

		if(isDefined('arguments.config.fields')
			&&len(arguments.config.fields)
			&& !listFindNoCase(arguments.config.fields,'links')){
			arguments.config.fields=listAppend(arguments.config.fields,'links');
		}

		variables.config.entities['#arguments.entityName#']=arguments.config;

		if(!(isDefined('arguments.beanInstance') && isObject(arguments.beanInstance))){
			arguments.beanInstance=getBean(arguments.entityName);
		}

		if(arguments.entityName=='group'){
			beanInstance.setType(1);
			beanInstance.getProperties();
		}

		beanInstance.registerAsEntity();

		if(!isDefined('arguments.config.displayname')){
			arguments.config.displayname=arguments.beanInstance.getEntityDisplayName();
		}

		if(!structKeyExists(variables.config.entities['#arguments.entityName#'],'moduleid')){
			variables.config.entities['#arguments.entityName#'].moduleid='00000000000000000000000000000000000';  //beanInstance.getRegisteredEntity().getEntityid();
		}

		var properties=arguments.beanInstance.getProperties();
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

	function packageIteratorArray(iterator,itArray,method,expanded=0){
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

		if(isAggregateQuery()){
			result['entityname']='bean';
		} else {
			result['entityname']=iterator.getEntityName();
		}

		if(!arguments.expanded &&
			!(isDefined('arguments.baseURL')) || !len(arguments.baseURL)){
			arguments.baseURL=getEndPoint() & "/?";
			var params={};
			structAppend(params,url,true);
			structAppend(params,form,true);

			param name="params.method" default=arguments.method;

			if(find('.',arguments.method)){
				params.method=arguments.method;
			}

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

		if(!listFindNoCase('bean',iterator.getEntityName())){
				result.links['properties']='#getEndpoint()#/#iterator.getEntityName()#/properties';
				result.links['permissions']='#getEndpoint()#/#iterator.getEntityName()#/permissions';
		}

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

			  	var origin =  headers['Origin'];
					var originDomain =reReplace(origin, "^\w+://([^\/:]+)[\w\W]*$", "\1", "one");

			  	// If the Origin is okay, then echo it back, otherwise leave out the header key
					for(var domain in application.settingsManager.getAccessControlOriginDomainArray() ){
						if( domain == originDomain || len(originDomain) > len(domain) && right(originDomain,len(domain)+1)=='.' & domain ){
							responseObject.setHeader( 'Access-Control-Allow-Origin', origin );
				   		responseObject.setHeader( 'Access-Control-Allow-Credentials', 'true' );
						}
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
				&& len(headers['Content-Type']) >= 16
				&& left(headers['Content-Type'], 16) == 'application/json'
				&& isJSON(httpRequestData.content)){
				structAppend(params,deserializeJSON(httpRequestData.content));
			}

			if(structKeyExists(params,'muraPointInTime')){
				params.muraPointInTime=parseDateTime(muraPointInTime);
				if(isDate(params.muraPointInTime)){
					request.muraPointInTime=param.muraPointInTime;
				}
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

				if( structKeyExists( headers, 'X-client-id' )){
					params['client_id']=headers['X-client-id'];
				}

				if( structKeyExists( headers, 'X-client-secret' )){
					params['client_secret']=headers['X-client-secret'];
				}

				if( structKeyExists( headers, 'X-access-token' )){
					params['access_token']=headers['X-access-token'];
				}

				var isBasicAuth=false;
				var isBasicAuthDirect=false;

				request.muraHasOAuthBearerTokenHeader=false;

				if( structKeyExists( headers, 'Authorization' )){
					var tokentype=listFirst(headers['Authorization'],' ');
					var tokenvalue=listLast(headers['Authorization'],' ');

					if(tokentype=='Basic'){
						tokenvalue=ToString( ToBinary( tokenvalue ) );
						params['client_id']=listFirst(tokenvalue,":");
						params['client_secret']=listLast(tokenvalue,":");
						isBasicAuth=true;
						if(len(params['client_id']) && !isValid('uuid',params['client_id'])){
							isBasicAuthDirect=true;
						}
					} else if(tokentype=='Bearer') {
						params['access_token']=tokenvalue;
						request.muraHasOAuthBearerTokenHeader=true;
					}
				}

				if(isBasicAuth && isBasicAuthDirect){
					var userUtility=getBean('userUtility');
					var rsuser=userUtility.lookupByCredentials(params['client_id'],params['client_secret'],variables.siteid);
					structDelete(params,'client_id');
					structDelete(params,'client_secret');
					if(rsuser.recordcount){
						userUtility.loginByUserID(rsuser.userid,rsuser.siteid);
					} else {
						responseObject.setHeader( 'WWW-Authenticate', 'Basic' );
						throw(type="authorization");
					}
				} else {
					if(isDefined('params.access_token')){
						var tokenInfoRequest=isDefined('url.access_token') && isDefined('url.client_id') && (arrayLen(pathInfo) == 5 && pathInfo[5]=='tokeninfo'
							|| arrayLen(pathInfo) == 6 && pathInfo[6]=='tokeninfo'
						);

						var token=getBean('oauthToken').loadBy(token=params.access_token);
						if(!tokenInfoRequest){
							structDelete(params,'access_token');
							structDelete(url,'access_token');
						}
						if(!token.exists() || !listFind('client_credentials,authorization_code,password,implicit',token.getGrantType())){
							params.method='Not Available';
							responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_access_token"' );
							responseObject.setHeader( 'WWW-Authenticate', 'Bearer' );
							throw(type='invalidAccessToken');
						} else if (token.isExpired()){
							params.method='Not Available';
							responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_access_token"' );
							throw(type='accessTokenExpired');
						} else {
							if(isJSON(token.getData())){
								structAppend(getSession(), deserializeJSON(token.getData()), true);
							} else {
								var oauthclient=token.getClient();

								if(!oauthclient.exists()){
									params.method='undefined';
									responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_access_token"' );
									throw(type='invalidAccessToken');
								} else {
									var clientAccount=token.getUser();

									if(!clientAccount.exists()){
										params.method='undefined';
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_access_token"' );
										throw(type='invalidAccessToken');
									} else {
										clientAccount.login();
										token.setData(serializeJSON(getSession())).save();
									}
								}
							}
						}

						if(tokenInfoRequest){
							params.access_token=url.access_token;
							return serializeResponse(
								statusCode=200,
								response= getOAuthTokenInfo(argumentCollection=params)
							);
						}
					} else if(!(isDefined('params.client_id') || isDefined('params.refresh_token'))){
						params.method='Not Available';
						structDelete(params,'client_id');
						structDelete(params,'client_secret');
						structDelete(params,'refresh_token');
						structDelete(url,'client_id');
						structDelete(url,'client_secret');
						structDelete(url,'refresh_token');

						if(arrayLen(pathInfo) == 6
							&& listFind('oauth,oauth2',pathInfo[5])
							||
								arrayLen(pathInfo) == 5
								&& (
									listFind('oauth,oauth2',pathInfo[4]) || listFind('oauth,oauth2',pathInfo[5])
								)
						){
							responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
						} else {
							responseObject.setHeader( 'WWW-Authenticate', 'Basic' );
						}

						throw(type='authorization');
					} else {
						var oauthclient=getBean('oauthClient').loadBy(clientid=params.client_id);

						if(!oauthclient.exists()){
							params.method='Not Available';
							params={
								method='getOAuthToken'
							};
							responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
							throw(type='authorization');
						} else {

							if(arrayLen(pathInfo) == 6
								&& listFind('oauth,oauth2',pathInfo[5])
								||
									arrayLen(pathInfo) == 5
									&& (
										listFind('oauth,oauth2',pathInfo[4]) || listFind('oauth,oauth2',pathInfo[5])
									)
								){

								var oauth2=(arrayLen(pathInfo) == 6
									&& listFind('oauth2',pathInfo[5])
									||
										arrayLen(pathInfo) == 5
										&& (
											listFind('oauth2',pathInfo[4]) || listFind('oauth2',pathInfo[5])
										)
									);

								param name="params.grant_type" default="invalid";

								params.method='getOAuthToken';

								if(params.grant_type == 'authorization_code'){
									if(oauthclient.getGrantType()!='authorization_code' || oauthclient.getClientSecret() != params.client_secret){
										structDelete(params,'client_id');
										structDelete(params,'client_secret');
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_authorization_code"' );
										throw(type='authorization');
									}

									param name="params.code" default="invalid";
									param name="params.redirect_uri" default="invalid";
									var token=getBean('oauthToken').loadBy(clientid=params.client_id,accessCode=params.code);
									var clientAccount=token.getUser();

									if(!token.exists() || token.isExpired() || !clientAccount.exists() || !oauthclient.isValidRedirectURI(params.redirect_uri)){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_authorization_code"' );
										throw(type='authorization');
									} else {

										if(!isJSON(token.getData())){
											clientAccount.login();
											token.setData(serializeJSON(getSession())).save();
										}

										result=serializeResponse(
											statusCode=200,
											response={
												'token_type'='Bearer',
												'access_token'=token.getToken(),
												'expires_in'=token.getExpiresIn(),
												'expires_at'=token.getExpiresAt(),
												'refresh_token'=oauthclient.generateToken(granttype='refresh_token',userid=clientAccount.getUserID()).getToken(),
												'info'=token.getTokenInfo()
											 });

										return result;
									}
								} else if(params.grant_type == 'password'){

									if(oauthclient.getGrantType()!='password'){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
										throw(type='authorization');
									}

									param name="params.username" default="";
									param name="params.password" default="";

									var rsUser=getBean('userUtility').lookupByCredentials(username=params.username,password=params.password,siteid=variables.siteid);

									if(!rsUser.recordcount){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
										throw(type='authorization');
									} else {
										var token=oauthclient.generateToken(granttype='password',userid=rsUser.userid);

										if(!isJSON(token.getData())){
											token.getUser().login();
											token.setData(serializeJSON(getSession())).save();
										}

										if(oauth2){
										result=serializeResponse(
											statusCode=200,
											response={
												'token_type'='Bearer',
												'access_token'=token.getToken(),
												'expires_in'=token.getExpiresIn(),
												'expires_at'=token.getExpiresAt(),
												'refresh_token'=oauthclient.generateToken(granttype='refresh_token',userid=rsUser.userid).getToken(),
												'info'=token.getTokenInfo()
											 });
										} else {
											result=serializeResponse(
											statusCode=200,
											response={'apiversion'=getApiVersion(),
											'method'=params.method,
											'data'={
												'token_type'='Bearer',
												'access_token'=token.getToken(),
												'expires_in'=token.getExpiresIn(),
												'expires_at'=token.getExpiresAt(),
												'refresh_token'=oauthclient.generateToken(granttype='refresh_token',userid=rsUser.userid).getToken(),
												'info'=token.getTokenInfo()
											 }});
										}

										return result;
									}
								} else if(params.grant_type == 'client_credentials'){
									if(oauthclient.getGrantType()!='client_credentials' || oauthclient.getClientSecret() != params.client_secret){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
										throw(type='authorization');
									}

									var token=oauthclient.generateToken(granttype='client_credentials');
									var clientAccount=token.getUser();

									if(!clientAccount.exists()){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
										throw(type='authorization');
									} else {

										if(!isJSON(token.getData())){
											clientAccount.login();
											token.setData(serializeJSON(getSession())).save();
										}

										if(oauth2){
										result=serializeResponse(
											statusCode=200,
											response={
												'token_type'='Bearer',
												'access_token'=token.getToken(),
												'expires_in'=token.getExpiresIn(),
												'expires_at'=token.getExpiresAt(),
												'refresh_token'=oauthclient.generateToken(granttype='refresh_token',userid=clientAccount.getUserID()).getToken(),
												'info'=token.getTokenInfo()
											 });
										 } else {
											result=serializeResponse(
	 											statusCode=200,
	 											response={'apiversion'=getApiVersion(),
	 											'method'=params.method,
	 											'data'={
													'token_type'='Bearer',
													'access_token'=token.getToken(),
													'expires_in'=token.getExpiresIn(),
													'expires_at'=token.getExpiresAt(),
													'refresh_token'=oauthclient.generateToken(granttype='refresh_token',userid=clientAccount.getUserID()).getToken(),
													'info'=token.getTokenInfo()
												 }});
										 }

										return result;
									}
								} else if(params.grant_type == 'refresh_token'){
									//IF REFRESH_TOKEN WAS NOT SUBMITTED THROW AN ERROR
									if(!isDefined('params.refresh_token')){
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_refresh_token"' );
										throw(type='authorization');
									}

									var refreshToken=getBean('oauthToken').loadBy(token=params.refresh_token,granttype='refresh_token');
									var clientAccount=refreshToken.getUser();

									//IF THE REFRESH_TOKEN OR ASSOCIATED USER DOES NOT EXIST OR IS EXPIRED THROW AN ERROR
									if(!clientAccount.exists() || !refreshToken.exists() || refreshToken.isExpired()){
										if(refreshToken.exists() && refreshToken.isExpired()){
											refreshToken.delete();
										}
										params={
											method='getOAuthToken'
										};
										responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
										throw(type='invalid_token');
									}

									var token=oauthclient.generateToken(granttype='client_credentials',userid=clientAccount.getUserID());

									if(!isJSON(token.getData())){
										clientAccount.login();
										token.setData(serializeJSON(getSession())).save();
									}

									if(oauth2){
									result=serializeResponse(
										statusCode=200,
										response={
											'token_type'='Bearer',
											'access_token'=token.getToken(),
											'expires_in'=token.getExpiresIn(),
											'expires_at'=token.getExpiresAt(),
											'refresh_token'=refreshToken.getToken(),
											'info'=token.getTokenInfo()
										 });
									 } else {
										 result=serializeResponse(
											 statusCode=200,
											 response={'apiversion'=getApiVersion(),
											 'method'=params.method,
											 'data'={
	 											'token_type'='Bearer',
	 											'access_token'=token.getToken(),
	 											'expires_in'=token.getExpiresIn(),
	 											'expires_at'=token.getExpiresAt(),
	 											'refresh_token'=refreshToken.getToken(),
												'info'=token.getTokenInfo()
	 										 }});
									 }


									return result;
								} else {
									//IF VALID GRANT_TYPE WAS NOT SUBMITTED THROW AN ERROR
									params={
										method='getOAuthToken'
									};
									responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_grant_type' );
									throw(type='authorization');
								}
							} else {
								//USING CLIENT_ID AND CLIENT_SECRET AS BASIC AUTH
								//ONLY WORKS WITH CLIENTS WITH CLIENT_CREDENTIALS GRANTTYPE

								if(!isBasicAuth){
									params={
										method='getOAuthToken'
									};
									structDelete(params,'client_id');
									structDelete(params,'client_secret');
									responseObject.setHeader( 'WWW-Authenticate', 'Bearer error="invalid_client_credentials"' );
									throw(type='authorization');
								}

								if(oauthclient.getGrantType()=='basic' && oauthclient.getClientSecret()==params.client_secret){
									structDelete(params,'client_id');
									structDelete(params,'client_secret');
									oauthclient.getUser().login();
								} else {
									structDelete(params,'client_id');
									structDelete(params,'client_secret');
									responseObject.setHeader( 'WWW-Authenticate', 'Basic' );
									throw(type="authorization");
								}
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

			if (isDefined('params.method') && isValid('variableName',params.method) && isDefined('#params.method#')){

				if(!(listFindNoCase('validate,processAsyncObject,generateCSRFTokens',params.method) || apiEnabled)){
					throw(type='disabled');
				}

				if(arrayLen(pathInfo) > 1){
					parseParamsFromPath(pathInfo,params,2);
				}

				if(!listFindNoCase(variables.config.publicMethods, params.method) ){
					throw(type="invalidMethodCall");
				}

				param name="params.siteid" default=variables.siteid;

				if(!getBean('settingsManager').siteExists(params.siteid)){
					throw(type="invalidParameters");
				}

				if(isDefined('#params.method#')){

					var result=invoke(this,params.method,params);

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
			} else {
				throw(type="invalidParameters");
			}

			var siteManager=getBean('settingsManager');
			if(!siteManager.siteExists(params.siteid)){
				throw(type="invalidParameters");
			} else if (isdefined('url.siteid') && !siteManager.siteExists(url.siteid)) {
				throw(type="invalidParameters");
			} else if (isdefined('form.siteid') && !siteManager.siteExists(form.siteid)) {
				throw(type="invalidParameters");
			}

			if(arrayLen(pathInfo) > 1){
				if(isDefined(pathInfo[2]) && pathInfo[2] != 'file'){
					params.method=pathInfo[2];

					if(!(listFindNoCase('validate,processAsyncObject',params.method) || apiEnabled)){
						throw(type='disabled');
					}

					if(arrayLen(pathInfo) > 2){
						parseParamsFromPath(pathInfo,params,3);
					}

					if(!listFindNoCase(variables.config.publicMethods, params.method)){
						throw(type="invalidMethodCall");
					}

					var result=invoke(this,params.method,params);

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

			if(find('.',params.method)){
				params.entityName=listFirst(params.method,'.');
				params.method=listLast(params.method,'.');
				pathInfo=[
					pathInfo[1],
					params.entityName,
					params.method
				];
			}

			if(isDefined('params.entityName') && listFIndNoCase('contentnavs,contentnav',params.entityName)){
				params.entityName="content";
				params.entityConfigName="contentnav";
			}

			if(isDefined("params.siteid") && !isDefined('params.entityName')){
				params.entityName='entity';
				params.method='findall';
			} else if(!isDefined("params.siteid") || !(isDefined("params.entityName") && len(params.entityName) && getServiceFactory().containsBean(params.entityName)) ){
				if(isDefined('params.entityName') && right(params.entityName,1) == 's'){
					var entitycheck=left(params.entityName,len(params.entityName)-1);

					if( getServiceFactory().containsBean(entitycheck)){
						params.entityName=entitycheck;
					} else { 
						doubleCheckEntityName(params.entityName);
					}
				} else {
					doubleCheckEntityName(params.entityName);
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
						if(arrayLen(pathInfo) == 4 && pathInfo[4]=='permissions'){
							result=findPermissions(argumentCollection=params);
							result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'='findPermissions','data'=result});
							return result;

						} else if(arrayLen(pathInfo) >= 4 && params.entityName=='content' && pathInfo[4]=='relatedcontent'){
							var $=getBean('$').init(params.siteid);
							params.method='findRelatedContent';
							url.id=params.id;
							url.siteid=variables.siteid;
							params.siteid=variables.siteid;
							url.entityname=params.entityName;

							if(arrayLen(pathInfo) == 5){
								params.relatedcontentsetid=pathInfo[5];
							} else {
								param name='params.relatedcontentsetid' default=$.globalConfig().getValue(property='relatedcontentsetid', defaultValue="*");
							}

							if(!allowAccess(params.entityName,$)){
								throw(type="authorization");
							}

							result=findRelatedContent(argumentCollection=params);
							result=serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'='findRelatedContent','data'=result});
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

							} else if (isValid('variableName',pathInfo[4]) && isDefined('application.objectmappings.#params.entityName#.remoteFunctions.#pathInfo[4]#')) {
								params.method=pathInfo[4];
								url.method=pathInfo[4];
								var entity=getBean(params.entityName);

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

								structDelete(params,'id');

								var result=invoke(entity,pathInfo[4],params);
								return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});

							} else if(isValid('variableName',pathInfo[4]) && isDefined('application.objectmappings.#params.entityName#.properties.#pathInfo[4]#')
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
					} else if(listFind('new,properties,permissions',pathInfo[3])){
						params.id=pathInfo[3];
					} else if (isValid('variableName',pathInfo[3]) && isDefined('application.objectmappings.#params.entityName#.remoteFunctions.#pathInfo[3]#')) {
						params.method=pathInfo[3];
						url.method=pathInfo[3];

						var entity=getBean(params.entityName);
						var result=invoke(entity,pathInfo[3],params);
						return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
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
				if(isValid('variableName',params.entityName)){
					if(isDefined('application.objectMappings.#params.entityName#.primaryKey')){
						var primaryKey=application.objectMappings['#params.entityName#'].primaryKey;
					} else if (getServiceFactory().containsBean(params.entityname)){
						var primaryKey=getBean(params.entityname).getPrimaryKey();
					} else {
						var primaryKey='undefined';
					}
				} else {
					var primaryKey='undefined';
				}
			}

			if(httpRequestData.method=='GET' && isValid('variableName',primaryKey) && isDefined('params.#primaryKey#') && len(params['#primaryKey#'])){
				params.id=params['#primaryKey#'];
			}

			structAppend(form,params);
		
			switch(method){
				case "GET":
				
					if((isDefined('params.id') || (params.entityName=='content') && isDefined('params.contenthistid'))){
						if(!isDefined('params.id') && (params.entityName=='content' && isDefined('params.contenthistid'))){
							params.id=params.contenthistid;
						}
						if(params.id=='new') {
							params.method='findNew';
							result=findNew(argumentCollection=params);
						} else if(params.id=='properties') {
								params.method='findProperties';
								result=findProperties(argumentCollection=params);
						} else if(params.id=='permissions') {
								params.method='findPermissions';
								result=findPermissions(argumentCollection=params);
						} else if(listLen(params.id) > 1){
						
							params.ids=params.id;
							params.method='findMany';
							result=findMany(argumentCollection=params);
						} else {
							if(isValid('uuid',params.id) || params.id=='00000000000000000000000000000000001'){
								params.method='findOne';
								result=findOne(argumentCollection=params);
							} else {
								result=doubleCheckEntityMethod(params.entityname,params.id,params,false);
							}
							
						}
						
					} else {
						if(arrayLen(pathInfo) == 3 
							&& !(
								isValid('uuid',pathInfo[3]) 
								|| pathInfo[3]=='00000000000000000000000000000000001'
								)
						){
							result=doubleCheckEntityMethod(params.entityname,pathInfo[3],params,true);
						} else {
							if(structCount(url)){
								params.method='findQuery';
								result=findQuery(argumentCollection=params);
							} else {
								params.method='findAll';
								result=findAll(argumentCollection=params);
							}
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
				return serializeResponse(statusCode=403,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
			} else {
				return serializeResponse(statusCode=200,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'data'=result});
			}

		}

		catch (authorization e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'='Insufficient Account Permissions'}});
		}

		catch (invalidAccessToken e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_token','message'='Invalid Access Token'}});
		}

		catch (accessTokenExpired e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=401,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_token','message'='Access Token Expired'}});
		}

		catch (disabled e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'='The JSON API disabled'}});
		}

		catch (invalidParameters e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'='Invalid parameters'}});
		}

		catch (invalidEntityCall e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'='Invalid reference to persisted entity'}});
		}

		catch (invalidMethodCall e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'="Invalid method call"}});
		}

		catch (badRequest e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'="Bad Request"}});
		}

		catch (invalidTokens e){
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			return serializeResponse(statusCode=400,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='invalid_request','message'="Invalid CSRF tokens"}});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			param name="params.method" default="undefined";
			if(!isValid('variableName',params.method) || !isDefined('#params.method#')){
				params.method='invalid';
			}
			if(getBean('configBean').getDebuggingEnabled()){
				return serializeResponse(statusCode=500,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='server_error','message'="Unhandled Exception",'stacktrace'=e}});
			} else {
				return serializeResponse(statusCode=500,response={'apiversion'=getApiVersion(),'method'=params.method,'params'=getParamsWithOutMethod(params),'error'={'code'='server_error','message'="Unhandled Exception"}});
			}

		}

	}

	variables.entityChecks={};

	function doubleCheckEntityName(entityName){
		arguments.entityName=REReplace(arguments.entityName,"[^0-9A-Za-z_,\-\*]","","all");

		if(!isValid('variableName',arguments.entityName)){
			throw(type="invalidEntityCall");
		}

		var found=false;
		
		if(!structKeyExists(variables.entityChecks,'#arguments.entityname#')
			|| DateDiff('n', variables.entityChecks['#arguments.entityname#'], now())
		){
			var lookupdata=getBean('settingsManager').getDeferredModuleAssets();
			
			variables.entityChecks['#arguments.entityname#']=now();

			for(var asset in lookupdata.assets){
				if(structKeyExists(asset,'modelDir') and len(asset.modelDir)){
					if(fileExists(asset.modelDir & "/" & arguments.entityName & ".cfc") 
					|| fileExists(asset.modelDir & "/beans/" & arguments.entityName & ".cfc")
						|| fileExists(asset.modelDir & "/entities/" & arguments.entityName & ".cfc")
						|| fileExists(asset.modelDir & "/services/" & arguments.entityName & ".cfc")
					){
						var rsSites=getBean('settingsManager').getList(clearCache=true);
						getBean('configBean').registerBeanDir(dir=asset.modelDir,package=asset.package,siteid=valueList(rsSites.siteid),forceSchemaCheck=true);
						found=true;
						break;
					}
				}
			}
		}
		if(!found){
			throw(type="invalidEntityCall");
		}
	}

	function doubleCheckEntityMethod(entityName,method,params,throwError=false){
		//This fires when the entity does exists, but the method doesn't
		if(isValid('variableName',arguments.method)){
			var entity=getBean(arguments.entityName);
			entity.getProperties(rebuild=true);

			if(isDefined('application.objectmappings.#arguments.entityName#.remoteFunctions.#arguments.method#')) {
				url.method=arguments.method;
				arguments.params.method=arguments.method;

				structDelete(params,'id');

				return invoke(entity,arguments.method,arguments.params);
			} else if (arguments.throwError){
				throw(type="invalidMethodCall");
			} else {
				params.method='findOne';
				return findOne(argumentCollection=arguments.params);
			}
		} else if (arguments.throwError){
			throw(type="invalidMethodCall");
		} else {
			params.method='findOne';
			return findOne(argumentCollection=arguments.params);
		}
	}

	function serializeResponse(response,statusCode=200){
		var responseObject=getpagecontext().getResponse();
		responseObject.setContentType('application/json; charset=utf-8');
		try{
			if(request.mura404){
				responseObject.setStatus(404);
			} else {
				responseObject.setStatus(arguments.statusCode);
			}
		} catch (Any e){}

		if(application.configBean.getValue(property='suppressAPIParams',defaultValue=true) && isDefined('response.params')){
			structDelete(response,'params');
		}

		if(structKeyExists(arguments.response,'data') && isStruct(arguments.response.data)){
			var $=getBean('$').init(variables.siteid);
			if(isBoolean($.event('useDataNamespace')) ){
				if(!$.event('useDataNamespace')){
					structAppend(arguments.response,arguments.response.data);
					structDelete(arguments.response,'data');
				}
			} else if(!variables.useDataNamespaceForAPI){
				structAppend(arguments.response,arguments.response.data);
				structDelete(arguments.response,'data');
			}
		}

		if(isDefined('arguments.response.data.shunter') && arguments.response.data.shunter){
			if(isDefined('arguments.response.data.layout')){
				responseObject.setContentType('application/x-shunter+json; charset=utf-8');
				arguments.response.layout=arguments.response.data.layout;
			}
		}

		var result= getSerializer().serialize(arguments.response);

		cfheader( name="ETag", value=hash(result));

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
		var exampleEntity=getBean(arguments.entityname);

		if(arguments.entityName=='group'){
			exampleEntity.setType(1);
		}

		var props=exampleEntity.getProperties();
		var propArray=listToArray(arguments.properties);
		var returnArray=[];
		var prop='';
		var config=getEntityConfig(arguments.entityname);

		param name="config.public" default=false;
		param name="config.fields" default="";

		if(arrayLen(propArray)){
			for(var p in propArray){
				p=lcase(p);
				if(!len(config.fields) || listFindNoCase(config.fields,p)){
					if(props[p].persistent || structKeyExists(props[p],'cfc')){
						arrayAppend(returnArray,applyPropertyFormat(props[p]));
					}
				}
			}
		} else {
			for(var p in props){
				p=lcase(p);
				if(!len(config.fields) || listFindNoCase(config.fields,p)){
					if(props[p].persistent || structKeyExists(props[p],'cfc')){
						arrayAppend(returnArray,applyPropertyFormat(props[p]));
					}
				}
			}
		}

		var result=formatArray(returnArray);

		structAppend(result,{
			entityname=exampleEntity.getEntityName(),
			bundleable=exampleEntity.getBundleable(),
			orderby=exampleEntity.getOrderBy(),
			historical=exampleEntity.getIsHistorical(),
			dynamic=exampleEntity.getDynamic(),
			scaffold=exampleEntity.getscaffold(),
			displayname=exampleEntity.getEntityDisplayName(),
			primarykey=lcase(exampleEntity.getPrimaryKey()),
			public=config.public,
			links={
				entities=getEndpoint()
			}
		});

		if(arguments.entityname == 'entity'){
			result.links.endpoint=getEndpoint();
		} else {
			result.links.endpoint=getEndpoint() & "/" & arguments.entityname;
		}

		result.links.swagger_json=getEndpoint() & "/swagger?mode=json&entities=" & arguments.entityname;
		result.links.swagger_rest=getEndpoint() & "/swagger?mode=rest&entities=" & arguments.entityname;
		result.links.self="#getEndPoint()#/#arguments.entityname#/properties";

		if(getCurrentUser().isAdminUser() || getCurrentUser().isSuperUser()){
			result.table=exampleEntity.getTable();
		}

		result.properties=result.items;
		structDelete(result,'items');
		return result;
	};

	function getParamsWithOutMethod(params){
        var temp={};
        structAppend(temp,arguments.params);
        structDelete(temp,'method');
				structDelete(temp,'_cacheid');
				structDelete(temp,'cacheid');

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
			if(paramsArray[i]=='method'){
				throw(type="invalidMethodCall");
			} else {				
				if(i mod 2){
					params['# REReplace(paramsArray[i],"[^0-9A-Za-z\._,\-\*]","","all")#']='';
				} else {
					var previous=i-1;
					params['# REReplace(paramsArray[previous],"[^0-9A-Za-z\._,\-\*]","","all")#']=paramsArray[i];
				}
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
		return true;
	}

	function AllowAccess(bean,$,throwError=true){

		if(isObject(arguments.bean)){
			if(!isDefined('arguments.bean.getEntityName')){
				if(!isDefined('arguments.bean.get') || !len(arguments.bean.get('entityName'))){
					throw(type='invalidParameters');
				}
			}
			var entityName=arguments.bean.getEntityName();
		} else {
			if(!getServiceFactory().containsBean(arguments.bean)){
				if(arguments.throwError){
					throw(type='invalidEntityCall');
				}
				return false;
			}
			var entityName=arguments.bean;
			arguments.bean=arguments.$.getBean(entityName);
		}

		if(entityName == 'entity'){
			return true;
		}

		if(isDefined('arguments.bean.allowAccess') && arguments.bean.allowAccess(m=$,$=$,mura=$)){
			return true;
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
			if(!isDefined('arguments.bean.get') || !len(arguments.bean.get('entityName'))){
				throw(type='invalidParameters');
			}
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
			case 'site':
				if(getCurrentUser().isSuperUser()){
					return true;
				} else {
					return false;
				}
				break;
			case 'user':
			case 'group':
			case 'address':
				if(getBean('permUtility').getModulePerm(variables.config.entities['#arguments.bean.getEntityName()#'].moduleid,variables.siteid)){
					return true;
				} else if (arguments.bean.getValue('userid')==getCurrentUser().get('userid')){
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
		var $=getBean('$').init(arguments.siteid);

		if($.validateCSRFTokens(context='login')){
			var result=getBean('userUtility').login(argumentCollection=arguments);

			if(result){
				return {'status'='success'};
			} else {
				return {'status'='failed'};
			}
		} else {
			return {'status'='Invalid CSFR Tokens'};
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

	// Masa CMS ORM ADAPTER

	function save(siteid,entityname,id='new',expand=''){

		var $=getBean('$').init(arguments.siteid);
		var csrfcontext=arguments.id;

		if(arguments.entityname=='contentnav'){
			arguments.entityname='content';
			$.event('entityname','content');
		}

		if(listFindNoCase('user,group',arguments.entityName)){
			var vals=$.event().getAllValues();
			var hasUserModuleAcces=getBean('permUtility').getModulePerm(variables.config.entities.user.moduleid,arguments.siteid);

			if(!($.currentUser().isAdminUser() || $.currentUser().isSuperUser())){
				structDelete(vals,'isPublic');
				structDelete(vals,'type');

				if(!hasUserModuleAcces){
					structDelete(vals,'groupID');
				}
			}

			if(!$.currentUser().isSuperUser()){
				structDelete(vals,'s2');
			}

			if(isdefined('vals.groupname') && vals.groupname == 'admin'){
				structDelete(vals,'groupname');
			}

			if(isdefined('vals.userid') && vals.userid != $.currentUser('userid')){
				structDelete(vals,'email');
			}
		}

		var entity=$.getBean(arguments.entityName).set($.event().getAllValues());
		var saveErrors=false;
		var errors={};

		if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			if(arguments.entityName=='content'){
				 if(!len($.event('contenthistid')) && len($.event('contentid'))){
						var pk='contentid';
				} else {
						var pk='contenthistid';
				}
			} else {
				var pk=entity.getPrimaryKey();
			}
		}

		if(len($.event(pk)) && (isValid('uuid',$.event(pk)) || $.event(pk)=='00000000000000000000000000000000001') ){
			arguments.id=$.event(pk);
		}

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

		if(!request.muraSessionManagement || $.validateCSRFTokens(context=csrfcontext)){
			if(arguments.entityName=='content' && $.event('type')=='Variation'){
				entity.loadBy(argumentCollection=loadByparams);

				if(arguments.entityName=='content' && isBoolean($.event('removecategories')) && $.event('removecategories')){
						var currentCategories=entity.getCategoriesIterator();

						if(currentCategories.hasNext()){
							while(currentCategories.hasNext()){
								entity.removeCategory(currentCategories.next().get('categoryid'));
							}
						}
				}

				entity.set(
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
				entity.loadBy(argumentCollection=loadByparams);

				if(arguments.entityName=='content' && isBoolean($.event('removecategories')) && $.event('removecategories')){
						var currentCategories=entity.getCategoriesIterator();

						if(currentCategories.hasNext()){
							while(currentCategories.hasNext()){
								entity.removeCategory(currentCategories.next().get('categoryid'));
							}
						}
				}

				entity.set(
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

		if(!(isBoolean(saveErrors) && saveErrors) && !StructIsEmpty(errors)){
			var instance=entity.getAllValues();
			var eventData=$.event().getAllValues();
			for(var p in eventData){
				if(StructKeyExists(instance, "#p#")){
					entity.set(p,$.event(p));
				}
			}
		}

		var returnStruct=getFilteredValues(entity=entity,expanded=true,entityConfigName=entity.getEntityName(),siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,$=$);

		returnStruct.saveErrors=saveErrors;
		returnStruct.errors=errors;

		if( request.muraAPIRequestMode=='json'
			&& entity.getEntityName()=='User'
			&& !entity.hasErrors()
			&& $.currentUser().isLoggedIn()
			&& $.currentUser('userid') == entity.getUserID()){
			$.getBean('userUtility').loginByUserID(userid=entity.getUserID(),siteid=entity.getSiteID());
		}

		return returnStruct;
	}

	function getFilteredValues(entity,expanded=0,entityConfigName,siteid,expandLinks='',pk='',editablecheck=false,expandedProp='',$){
		var fields='';
		var vals={};

		if(!isDefined('arguments.$')){
			arguments.$=getBean('$').init(arguments.siteid);
		}

		if(isAggregateQuery()){
			arguments.expanded=0;
		}

		var doFields=!arguments.expanded || (
				arguments.expandedProp != 'crumbs'
				&& arguments.expandedProp != 'relatedcontent'
				&& isdefined('url.entityname') && len(url.entityname) && (
					url.entityname==entity.getEntityName() || url.entityname==entityConfigName

					)
			);

		if(!(isDefined('variables.config.entities.#arguments.entityConfigName#.allowfieldselect') && !variables.config.entities[entityConfigName].allowfieldselect) && (doFields && isDefined('url.fields') && len(url.fields))){
			fields=url.fields;

			if(!isAggregateQuery()){
				if(arguments.entity.getEntityName()=='content' && !listFindNoCase(fields,'contentid')){
					fields=listAppend(fields,'contentid');
				} else if (arguments.entity.getEntityName()!='content' && !listFindNoCase(fields,arguments.entity.getPrimaryKey())){
					fields=listAppend(fields,arguments.entity.getPrimaryKey());
				}

				if(!listFindNoCase(fields,'siteid')){
					fields=listAppend(fields,'siteid');
				}

				if(listFindNoCase('content,contentnav,comment,category,contentCategoryAssign',arguments.entity.getEntityName())){
					if(listFindNoCase('*,all',arguments.expandlinks) || listFindNoCase(arguments.expandlinks,'crumbs')){
						if(!listFindNoCase(fields,'links')){
							fields=listAppend(fields,'links');
						}
						if(!listFindNoCase(fields,'path')){
							fields=listAppend(fields,'path');
						}
					}
				}
			}
		} else if(isDefined('variables.config.entities.#arguments.entityConfigName#.fields') && len(variables.config.entities[arguments.entityConfigName].fields)){
			fields=variables.config.entities[arguments.entityConfigName].fields;
		}

		if(len(fields) && !listFindNoCase(fields,'isnew')){
			fields=listAppend(fields,'isnew');
		}

		fields=listToArray(fields);

		var allFields=!arrayLen(fields) || arrayFind(fields,'*') || arrayFind(fields,'all');

		if(!allFields){
			var temp={};

			for(var f in fields){
				if(f=='extendeddata'){
					var extendData=arguments.entity.getExtendedData();
					if(!isSimpleValue(extendData)){
						extendData=extendData.getAllExtendSetData();
						if(isDefined('extendData.data')){
							structAppend(temp,extendData.data);
						}
					}
				} else {
					if(f=='displayInterval'){
						var prop=arguments.entity.getDisplayInterval().getAll();
						structDelete(prop,'addObjects');
						structDelete(prop,'removeObjects');
						structDelete(prop,'sourceiterator');
						structDelete(prop,'frommuracache');
						structDelete(prop,'errors');
						structDelete(prop,'instanceid');
						structDelete(prop,'primaryKey');
						structDelete(prop,'isNew');
					} else{
						var prop=arguments.entity.getValue(property=listLast(f,'.'));
					}

					temp['#f#']=prop;
				}
			}

			vals=temp;
			structDelete(vals,'password');
		} else {
			vals=structCopy(arguments.entity.getAllValues(expand=true));
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
			structDelete(vals,'password');
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

		if(allFields || arrayFind(fields,'links')){
			arguments.editablecheck=(isDefined('url.id') && vals.id==url.id || arguments.editablecheck)? true :false;
			vals.links=getLinks(entity,arguments.editablecheck);
		}

		if(listFindNoCase('content,contentnav',arguments.entityConfigName)){
			if(allFields || arrayFind(fields,'images')){
				vals.images=setImageURLS(entity);
			}
			if(allFields || arrayFind(fields,'url')){
				vals.url=entity.getURL(complete=true);
			}

			var imageAttributes=(isdefined('renderer.imageAttributesArray') && isArray(renderer.imageAttributesArray)) ? renderer.editableAttributesArray : [];
			for(var imgAttr in imageAttributes){
				if(structKeyExists(vals,'#imgAttr#') && isValid('uuid',vals['#imgAttr#'])){
					vals['#imgAttr#images']=setImageURLS(entity,imgAttr,$);
				}
			}
		}

		if(listFindNoCase('group,user',arguments.entityConfigName)){
			vals.type=(entity.getType()==1) ? 'group' : 'user';
		}

		vals['entityname']=arguments.entityConfigName;

		if(vals.entityName=='contentnav'){
			vals.entityName='content';
		}

		param name="url.expanddepth" default=1;

		if(!isNumeric(url.expanddepth)){
			url.expanddepth=1;
		}

		if(arguments.expanded < url.expanddepth && len(arguments.expandLinks)){
			expandEntity(entity=arguments.entity,itemStruct=vals,siteid=arguments.siteid,expand=arguments.expandLinks,expanded=arguments.expanded);
		}

		return vals;
	}

	function findPermissions(entityName,id,siteid){
		var $=getBean('$').init(arguments.siteid);
		var entity=getBean(arguments.entityName);

		if(isValid('UUID',arguments.id)|| len(arguments.id)==35){
			if(arguments.entityName=='content'){
				var pk = 'contentid';
			} else {
				var pk = entity.getPrimaryKey();
			}

			var loadArgs={
				'#pk#'=arguments.id,
				'siteid'=arguments.siteid
			};

			entity.loadBy(argumentCollection=loadArgs);
		}

		var result=entity.getPermissions();

		result.read=(result.read)?true:false;
		result.delete=(result.delete)?true:false;
		result.save=(result.save)?true:false;

		return result;
	}

	function findCurrentUser(entityName,id,siteid,render=false,variation=false,expand=''){
		var $=getBean('$').init(arguments.siteid);
		var user=findOne(
			entityName='user',
			id=$.currentUser('userid'),
			siteid=arguments.siteid,
			expand=arguments.expand,
			method='findCurrentUser'
		);
		var sessionData=getSession();

		if(isDefined("sessionData.mura")){
			user.memberships=listToArray(sessionData.mura.memberships);
			user.membershipids=listToArray(sessionData.mura.membershipids);
			user.isloggedin=sessionData.mura.isLoggedIn;
		} else {
			user.memberships=[];
			user.membershipids=[];
			user.isloggedin=false;
		}

		return user;
	}

	function findOne(entityName,id,siteid,render=false,variation=false,expand='',method='findOne',expanded=0){
		var $=getBean('$').init(arguments.siteid);

		if(!isDefined('url.entityname')){
			url.entityname=arguments.entityname;
		}

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
				} else if(len($.event('contentid'))){
					var entity=$.getBean('content').loadBy(contentid=$.event('contentid'));
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

		var returnStruct=getFilteredValues(entity=entity,expanded=arguments.expanded,entityConfigName=arguments.entityName,siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,editablecheck=true,$=$);

		if(isDefined('url.ishuman')){
			request.cffpJS=true;
			returnstruct.ishuman=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
		}

		return returnStruct;
	}

	function findNew(entityName,siteid,expand=''){

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityname=='contentnav'){
			arguments.entityname='content';
			$.event('entityname','content');
		}

		var entity=$.getBean(arguments.entityName);

		if(arguments.entityName=='group'){
			entity.setType(1);
		}

		if(arguments.entityName=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		var loadparams={'#pk#'=createUUID()};
		entity.loadBy(argumentCollection=loadparams);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		var returnStruct=getFilteredValues(entity=entity,expanded=true,entityConfigName=entity.getEntityName(),siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,editablecheck=true,$=$);

		if(isDefined('url.ishuman')){
			request.cffpJS=true;
			returnstruct.ishuman=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
		}

		return returnStruct;
	}

	function expandEntity(entity,itemStuct,siteid,expand='',expanded=0){
		arguments.expanded=arguments.expanded+1;
		if(len(arguments.expand)){
			var p='';
			var expandParams={};
			var queryString='';
			var q='';
			var expandAll=(arguments.expand=='all' || arguments.expand=='*');

			if(arrayLen(arguments.entity.getHasManyPropArray())){
				for(p in arguments.entity.getHasManyPropArray()){
					if(expandAll|| listFindNoCase(arguments.expand,p.name)){
						expandParams={};
						expandParams['#arguments.entity.translatePropKey(p.loadkey)#']=entity.getValue(arguments.entity.translatePropKey(p.column),createUUID());

						if(p.cfc=='content'){
							if(isDefined('url.showexcludesearch')){
								expandParams.showexcludesearch=url.showexcludesearch;
							}
							if(isDefined('url.includeHomePage')){
								expandParams.includeHomePage=url.includeHomePage;
							}
							if(isDefined('url.shownavonly')){
								expandParams.shownavonly=url.shownavonly;
							}

							expandParams.sortBy=entity.get('sortBy');
							expandParams.sortDirection=entity.get('sortDirection');
						}

						if(isDefined('url.maxitems')){
							expandParams.maxitems=url.maxitems;
						}
						if(isDefined('url.cachedWithin')){
							expandParams.cachedWithin=url.cachedWithin;
						}
						if(isDefined('url.itemsPerPage')){
							expandParams.itemsPerPage=url.itemsPerPage;
						}

						//try{
							arguments.itemStruct[p.name]=findQuery(entityName=p.cfc,siteid=arguments.siteid,params=expandParams,expand=arguments.expand,expanded=arguments.expanded,expandedProp=p.name);
						//} catch(any e){WriteDump(p); abort;}

					}
				}
			}

			if(arrayLen(arguments.entity.getHasOnePropArray())){
				for(p in arguments.entity.getHasOnePropArray()){
					if(expandAll || listFindNoCase(arguments.expand,p.name)){
						//try{
							if(p.name=='site'){
								arguments.itemStruct[p.name]=findOne(entityName='site',id=arguments.entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand=arguments.expand,expanded=arguments.expanded,expandedProp=p.name);
							} else {
								arguments.itemStruct[p.name]=findOne(entityName=p.cfc,id=arguments.entity.getValue(entity.translatePropKey(p.column)),siteid=arguments.siteid,render=false,variation=false,expand=arguments.expand,expanded=arguments.expanded,expandedProp=p.name);
							}
						//} catch(any e){WriteDump(p); abort;}
					}
				}
			}

			if(expandAll || listFindNoCase(arguments.expand,'crumbs')){
				if(isDefined('arguments.itemStruct.links.crumbs') && isDefined('arguments.itemStruct.path')){
					arguments.itemStruct.crumbs=findCrumbArray(entityName=arguments.itemStruct.entityName,id=arguments.itemStruct.id,siteid=arguments.siteid,iterator=arguments.entity.getCrumbIterator(),expand='',expanded=arguments.expanded,expandedProp='crumbs');
				}
			}

			if(listFindNoCase('content,contentnav',arguments.entity.getEntityName()) && (expandAll || listFindNoCase(arguments.expand,'relatedcontent')) ){
				arguments.itemStruct.relatedcontent=findRelatedContent(entity=arguments.entity,siteid=arguments.siteid,expand='',expanded=arguments.expanded,expandedProp='relatedcontent');
			}

		}

	}

	function getPrimaryEntityStruct(entity,$){

		var i=entity.getName();

		try{
			if(i == 'contentnav'){
				i='content';
				var exampleEntity=getBean('content');
			} else {
				var exampleEntity=getBean(i);
			}

			if(i=='group'){
				exampleEntity.setType(1);
			}

			exampleEntity.getEntityName();
		} catch(any e){
			WriteDump(e);abort;
		}

		var itemStruct={
			entityname=i,
			displayname=exampleEntity.getEntityDisplayName(),
			dynamic=exampleEntity.getDynamic(),
			scaffold=exampleEntity.getScaffold(),
			orderby=exampleEntity.getOrderBy(),
			links={
				endpoint=getEndPoint() & "/" & i,
				properties=getEndPoint() & "/" & i & "/properties",
				permissions=getEndPoint() & "/" & i & "/permissions"
			}
		};

		if($.getCurrentUser().isAdminUser()){
			itemStruct.table=exampleEntity.getTable();
		}

		return itemStruct;

	}

	function findAll(siteid,entityName,params,expand='',expanded=0){
		param name="arguments.params" default=url;

		if(!isDefined('url.entityname')){
			url.entityname=arguments.entityname;
		}

		var $=getBean('$').init(arguments.siteid);
		var item='';

		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(arguments.entityName=='group'){
			entity.setType(1);
		}

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		if(!entity.allowQueryParams(arguments.params,$,$,$)){
			throw(type="authorization");
		}

		var feed=entity.getFeed();

		if(arguments.entityName=='group'){
			entity.setType(1);
			feed.setType(1);
		}

		if(arguments.entityName=='entity'){
			var allowedEntities=[];

			for(var i in variables.config.entities){
				if(allowAccess(i,$,false) && ($.event('scaffold')=='' || $.event('scaffold')==1 && allowAction($.getBean(i),$)) ){
					arrayAppend(allowedEntities,i);
				}
			}

			feed.where().prop('name').isIn(arrayToList(allowedEntities));
		}

		setFeedProps(feed,arguments.params);

		if(isDefined('arguments.params.countOnly') && isBoolean(arguments.params.countOnly) && arguments.params.countOnly){
			return {count=feed.getAvailableCount()};
		} else {
			var iterator=feed.getIterator(applyPermFilter=$.siteConfig('extranet'));
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
		var item='';

		if(entity.getEntityName()=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entity.getEntityName();
		}

		while(iterator.hasNext()){
			item=iterator.next();

			if(item.getEntityName() == 'entity'){
				arrayAppend(returnArray, getPrimaryEntityStruct(item,$));
			} else {
				arrayAppend(returnArray, getFilteredValues(entity=item,expanded=arguments.expanded,entityConfigName=entityConfigName,siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,$=$));
			}

		}

		return packageIteratorArray(iterator,returnArray,'findall');
	}

	function findMany(entityName,ids,siteid,params,expand='',expanded=0){
		param name="arguments.params" default=url;

		if(!isDefined('url.entityname')){
			url.entityname=arguments.entityname;
		}

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
		var iterator=feed.getIterator(applyPermFilter=$.siteConfig('extranet'));
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

			itemStruct=getFilteredValues(entity=item,expanded=arguments.expanded,entityConfigName=entityConfigName,siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,$=$);

			arrayAppend(returnArray, itemStruct );

		}

		if(!(isDefined('arguments.params.sort') && len(arguments.params.sort))){
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

	function findQuery(entityName,siteid,params,queryString=cgi.QUERY_STRING,expand='',expanded=0){

		param name="arguments.params" default=url;

		if(!isDefined('url.entityname')){
			url.entityname=arguments.entityname;
		}

		var $=getBean('$').init(arguments.siteid);
		var tempArgs={};

		if(!allowAccess(arguments.entityName,$)){
			throw(type="authorization");
		}
		
		checkForChangesetRequest(arguments.entityName,arguments.siteid);

		var propName='';
		var propIndex=0;
		var p='';
		var i='';
		var checkProp='';
		var feedIDParam='';
		var queryArray=listToArray(arguments.queryString,'&');
		var started=false;

		if(arguments.entityName=='content'){
			for(p in queryArray){
				if(left(p,6)=='feedid'){
					checkProp=urlDecode(listFirst(p,'='));
					if(find('[',checkProp)){
						propName=listFirst(checkProp,'[');
						propIndex=listFirst(listlast(checkProp,'['),']');
						structDelete(arguments,propName & propIndex);
					} else {
						propName=p;
					}
					if(propName=='feedid'){
						$.event('feedid',listLast(p,'='));
						feedIDParam=p;
					}
				}
			}
		}

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
				entity.setType(1);
			}
		}

		if(!entity.allowQueryParams(arguments.params,$,$,$)){
			throw(type="authorization");
		}

		if(entity.getEntityName()=='user'){
			if(isDefined('arguments.params.isPublic') && isNumeric($.event('isPublic'))){
				feed.setIsPublic($.event('isPublic'));
			} else {
				feed.setIsPublic('all');
			}
		}

		if(arguments.entityName=='entity'){
			var allowedEntities=[];

			for(var i in variables.config.entities)
			if(allowAccess(i,$,false) && ($.event('scaffold')=='' || $.event('scaffold')==1 && allowAction($.getBean(i),$)) ){
				arrayAppend(allowedEntities,i);
			}
			feed.where().prop('name').isIn(arrayToList(allowedEntities));
		}

		var baseURL=getEndPoint() & "/#entity.getEntityName()#/?";

		if(arguments.expanded){
			var started=false;

			for(var p in arguments.params){
				if(!listFindNoCase('expanddepth,muraPointInTime,liveOnly,feedid,maxItems,pageIndex,sort,itemsPerPage,sortBy,sortDirection,contentpoolid,shownavonly,showexcludesearch,includehomepage,feedname,expand,useCategoryIntersect,useDataNamespace',p)){
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

			for(i in queryArray){
				checkProp=urlDecode(listFirst(i,'='));
				if(checkProp!='pageIndex'){
					ArrayAppend(queryParams, checkProp);
				}
			}

			var relationship='and';
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

					if(!listFindNoCase('expanddepth,expand,muraPointInTime,liveOnly,feedid,cacheid,_cacheid,distinct,fields,entityname,method,maxItems,pageIndex,itemsPerPage,sortBy,sortDirection,contentpoolid,shownavonly,showexcludesearch,includehomepage,feedname,useCategoryIntersect,useDataNamespace',propName)){
						if(propName == 'sort'){
							advancedsort=listAppend(advancedsort,arguments.params[p]);
						} else if(!(entity.getEntityName()=='user' && propName=='isPublic')){
								if(entity.getEntityName()=='user' && propName=='groupid'){
									feed.setGroupID(arguments.params[p]);
								} else if(propName=='or'){
									relationship='or';
								} else if(listFindNoCase('openGrouping,orOpenGrouping,andOpenGrouping,closeGrouping',propName)){
									feed.addParam(relationship=p);
									relationship='and';
								} else if(listFindNoCase('sum,avg,count,max,min,groupBy',propName)){
									feed.aggregate(propName,params[p]);
								} else if(propname=='innerJoin'){
									feed.innerJoin(relatedEntity=params[p]);
								} else if(propname=='leftJoin'){
									feed.leftJoin(relatedEntity=params[p]);
								} else if(propName=='id' || entity.valueExists(propName) || entity.valueExists('extendData')){
									var condition="eq";
									var criteria=arguments.params[p];

									if(listLen(criteria,"^") > 1){
										condition=listFirst(criteria,'^');
										criteria=listGetAt(criteria,2,'^');
									} else if(find('*',criteria)){
										condition="like";
										criteria=replace(criteria,'*','%','all');
									}

									if(propname=='id'){
										if(entity.getEntityName()=='content'){
											propname='contentid';
										} else {
											propname=entity.getPrimaryKey();
										}
									}

									if(entity.valueExists('extendData') || entity.hasProperty(propName)){
										feed.addParam(column=propName,criteria=criteria,condition=condition,relationship=relationship);
									} else {
										throw(type="invalidParameters");
									}

									relationship='and';
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
			var iterator=feed.getIterator(applyPermFilter=$.siteConfig('extranet'));

			setIteratorProps(iterator=iterator);

			var returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand,$=$,expanded=arguments.expanded);
			return packageIteratorArray(iterator=iterator,itArray=returnArray,method='findQuery',baseURL=baseURL,expanded=arguments.expanded);
		}

	}

	function iteratorToArray(iterator,siteid,expand='',$,expanded=0){
		var returnArray=[];
		var item='';
		var entityName=arguments.iterator.getEntityName();

		if(listFindNoCase('content,contentnav',entityName)){
			var pk="contentid";
		} else if (entityName== 'feed'){
			var pk="feedid";
		} else if(StructKeyExists(application.objectMappings, entityName)) {
			var pk=application.objectMappings[entityName].primarykey;
		} else {
			var pk="";
		}

		if(entityName=='content'){
			var entityConfigName='contentnav';
		} else {
			var entityConfigName=entityName;
		}

		while(iterator.hasNext()){
			item=iterator.next();

			if(item.getEntityName() == 'entity'){
				arrayAppend(returnArray, getPrimaryEntityStruct(item,$));
			} else {
				arrayAppend(returnArray, getFilteredValues(entity=item,expanded=arguments.expanded,entityConfigName=entityConfigName,siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,$=$));
			}
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

		if(listFind('content,contentnav',arguments.feed.getEntityName())
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

			if(isDefined('params.liveOnly')
				&& isBoolean(params.liveOnly)
				&& getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid)){
				feed.setLiveOnly(params.liveOnly);
			}
		}

		var isContent=listFindNoCase('content,contentnav',arguments.feed.getEntityName());

		if(len(sort)){
			var prefix='';
			var prop='';
			var useOrderby=true;

			sort=listToArray(sort);

			var orderby=[];

			for(var s in sort){
				if(len(s) > 1){
					var prefix=left(s,1);

					if(listFind("+,-",prefix)){
						var prop=right(s,len(s)-1);
					} else {
						var prop=s;
						prefix="+";
					}

					if(isContent && listFindNoCase('comments,random,rating',prop)){
						arguments.feed.setSortBy(prop);
						if(prefix=='-'){
							feed.setSortDirection('desc');
						}
						break;
						useOrderby=false;
					}

					if(listLen(prop,'.')==1){
						if(isContent){
							prop="tcontent." & prop;
						} else {
							prop=feed.getEntity().getTable() & "." & prop;
						}
					}

					if(prefix=='+'){
						arrayAppend(orderby,prop & " asc");
					} else if(prefix=="-"){
						arrayAppend(orderby,prop & " desc");
					} else {
						arrayAppend(orderby,s);
					}
				} else {

					if(isContent && listFindNoCase('comments,random,rating',prop)){
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

		if(isContent){
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

			if(isDefined('arguments.params.useCategoryIntersect')){
				arguments.feed.setUseCategoryIntersect(arguments.params.useCategoryIntersect);
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

		for(var i in ['sortdirection','sortby','type']){
			if(structKeyExists(arguments.params,i) && len(arguments.params[i])){
				arguments.feed.setValue(i,arguments.params[i]);
			}
		}

		if(isDefined('arguments.params.distinct') && isBoolean(arguments.params.distinct)){
			arguments.feed.setDistinct(arguments.params.distinct);
		}

		if(isDefined('arguments.params.fields') && len(arguments.params.fields)){
			if(!isAggregateQuery()){
				if(listFind('content,contentnav',arguments.feed.getEntityName())){
					var primarykey='contentid';
				} else {
					var primarykey=getBean(arguments.feed.getEntityName()).getPrimaryKey();
				}

				if(!listFindNoCase(arguments.params.fields,primarykey)){
					arguments.params.fields=listAppend(arguments.params.fields,primarykey);
				}
			}

			arguments.feed.setfields(arguments.params.fields);
		}

		if(isDefined('arguments.params.maxitems')){
			if(isNumeric(arguments.params.maxitems)){
				arguments.feed.setMaxItems(arguments.params.maxitems);
			} else if(arguments.params.maxitems=='*'){
				arguments.feed.setMaxItems(0);
			}
		}

		if(isDefined('arguments.params.size') && isNumeric(arguments.params.size)){
			arguments.feed.setMaxItems(arguments.params.size);
		}

		if(isDefined('arguments.params.limit') && isNumeric(arguments.params.limit)){
			arguments.feed.setMaxItems(arguments.params.limit);
		}

		if(isDefined('arguments.params.cachedWithin') && isNumeric(arguments.params.cachedWithin)){
			feed.setCachedWithin(createTimeSpan(0,0,0,arguments.params.cachedWithin));
		}

	}

	function setIteratorProps(iterator,params){
		param name="arguments.params" default=url;

		if(isDefined('arguments.params.itemsPerPage')){
			if(isNumeric(arguments.params.itemsPerPage)){
				arguments.iterator.setNextN(arguments.params.itemsPerPage);
			} else if(arguments.params.itemsPerPage=='*'){
				arguments.iterator.setNextN(0);
			}
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

	function findCrumbArray(entityName,id,siteid,iterator,expand='',expanded=0,expandedProp=''){

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
			itemStruct=getFilteredValues(entity=item,expanded=arguments.expanded,entityConfigName=entityConfigName,siteid=arguments.siteid,expandLinks=arguments.expand,pk=pk,$=$);

			arrayAppend(returnArray, itemStruct );
		}

		return packageIteratorArray(arguments.iterator,returnArray,'findCrumbArray');
	}


	function findVersionHistory(id,siteid,expand='',expanded=0){

		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean('content');
		var crumbdata=getBean('contentManager').getCrumbList(arguments.id,arguments.siteid);
		var perm=getBean('permUtility').getNodePerm(crumbData);

		if(!listFindNoCase('author,editor',perm)){
			throw(type="authorization");
		}

		var iterator=entity.loadBy(contentid=arguments.id).getVersionHistoryIterator();
		setIteratorProps(iterator);
		var returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand,$=$,expanded=arguments.expanded);

		for(var i in returnArray){
				i.links.self=i.links.self & "?contenthistid=" & i.contenthistid;
		}

		return packageIteratorArray(iterator,returnArray,'findVersionHistory');
	}


	function delete(entityName,id,siteid){

		var $=getBean('$').init(arguments.siteid);
		var csrfcontext=arguments.id;

		if(arguments.entityName=='contentnav'){
			arguments.entityName='content';
			$.event('entityName','content');
		}

		var entity=$.getBean(arguments.entityName);

		if($.event('entityName')=='content'){
			if(len($.event('contenthistid'))){
				var loadparams={contenthistid=$.event('contenthistid')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

					if(!request.muraSessionManagement || $.validateCSRFTokens(context=csrfcontext)){
						entity.deleteVersion();
					}
				}
			} else {
				if(len($.event('contentid')) && isValid('uuid',$.event('contentid'))){
					$.event('id',$.event(pk));
				}

				var loadparams={contentid=$.event('id')};
				entity.loadBy(argumentCollection=loadparams);

				if(entity.exists()){
					if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

					if(!request.muraSessionManagement || $.validateCSRFTokens(context=csrfcontext)){
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

			if(len($.event(pk)) && isValid('uuid',$.event(pk))){
				$.event('id',$.event(pk));
			}

			var loadparams={'#pk#'=$.event('id')};
			entity.loadBy(argumentCollection=loadparams);

			if(entity.exists()){
				if(!(entity.allowDelete($) || allowAction(entity,$))){
						throw(type="authorization");
					}

				if(!request.muraSessionManagement || $.validateCSRFTokens(context=csrfcontext)){
					entity.delete();
				} else {
					throw(type="invalidTokens");
				}
			}
		}

		return '';
	}

	function getEndPoint(mode='json',useProtocol=true){
		if(request.muraApiRequest){
			var configBean=getBean('configBean');
			if(!isDefined('request.apiEndpoint')){

				if(useProtocol){
					if(configBean.getAdminSSL()){
						var protocol='https:';
					} else {
						var protocol=getBean('utility').getRequestProtocol() & ":";
					}
				} else {
					var protocol='';
				}

				var domain=cgi.server_name;

				//Rigged to always have index.cfm until some issues are figured out
				if(true || configBean.getValue('indexFileInURLS')){
					var indexFile="/index.cfm";
				} else {
					var indexFile="";
				}

				request.apiEndpoint="#protocol#//#domain##configBean.getServerPort()##configBean.getContext()##indexFile#/_api/#request.muraAPIRequestMode#/v1/#variables.siteid#";
			}
			return request.apiEndpoint;
		}

		if(arguments.mode=='json'){
			return variables.endpoint;
		} else {
			return replace(variables.endpoint,'/json/','/rest/');
		}

	}

	function getLinks(entity,editablecheck=false){
		var links={};
		var p='';
		var baseURL=getEndPoint();
		var id='';
		var translatedPropKey='';
		links.entities=baseURL;

		/*
		if(listFindNoCase('user',entity.getEntityName())){
			links['members']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
			//links['memberships']="#baseurl#?method=findQuery&siteid=#entity.getSiteID()#&entityName=user&groupid=#entity.getUserID()#";
		}
		*/

		if(entity.getEntityName() != 'bean'){
			if(arguments.editablecheck &&  getCurrentUser().isLoggedIn() && getCurrentUser().isSystemUser()){
				if(allowAction(entity,getBean('m').init(entity.getSiteid()))){
					var editURL=entity.getEditURL();
					if(len(editURL)){
						links['edit']=editURL;
					}
				}
			}
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

			if(entity.getEntityName()=='content'){
				links['permissions']="#baseurl#/#entity.getEntityName()#/#entity.get('contentid')#/permissions";
			} else if(len(entity.getPrimaryKey()) )  {
				links['permissions']="#baseurl#/#entity.getEntityName()#/#entity.get(entity.getPrimaryKey())#/permissions";
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
						translatedPropKey=entity.translatePropKey(p.column);
						if(len(entity.getValue(translatedPropKey))){
							if(p.cfc=='content' && translatedPropKey=='contenthistid'){
								links[p.name]="#baseurl#/#p.cfc#/?contenthistid=#entity.getValue(translatedPropKey)#";
							} else {
								links[p.name]="#baseurl#/#p.cfc#/#entity.getValue(translatedPropKey)#";
							}

						}
					}
				}
			}

			if(arrayLen(variables.config.linkMethods)){
				for(var i in variables.config.linkMethods){
					if(isDefined('#i#') && isValid('variableName',i)){
						var params={
							entity=arguments.entity,
							links=links
						};
						invoke(this,i,params);
					}
				}
			}
		}
		return links;
	}

	function findRelatedContent(id='',siteid,params,arguments,expand='',expanded=0,entity='',relatedContentSetID='',expandedProp=''){
		param name="arguments.params" default=url;

		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess('content',$)){
			throw(type="authorization");
		}

		var args={};

		if(isSimpleValue(arguments.entity)){
			checkForChangesetRequest('content',arguments.siteid);
			arguments.entity=$.getBean('content').loadBy(contentid=arguments.id);

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
		} else {
			args.relatedContentSetID=arguments.relatedContentSetID;
		}

		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';
		var pk=entity.getPrimaryKey();
		var iterator='';
		var returnArray=[];
		var setArray=[];
		var packagedItems={};
		if(arguments.relatedContentSetID=='' || arguments.relatedContentSetID=='*' || arguments.relatedContentSetID=='all'){

			var subtype=getBean('configBean').getClassExtensionManager().getSubTypeByName(siteid=arguments.siteid,type=entity.getType(),subtype=entity.getSubType());
			var rssets=subType.getRelatedContentSets(includeInheritedSets=true);

			for(var i=1;i<=arrayLen(rssets);i++){
				args.relatedContentSetID=rssets[i].getRelatedContentSetID();
				args.name=rssets[i].getName();
				iterator=arguments.entity.getRelatedContentIterator(argumentCollection=args);
				setIteratorProps(iterator,arguments.params);
				packagedItems=packageIteratorArray(
					iterator,
					iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand,$=$,expanded=arguments.expanded,expandedProp=arguments.expandedProp),
					'findRelatedContent'
				);
				structDelete(packagedItems,'links');
				packagedItems.name=rssets[i].getName();
				packagedItems.entityname=rssets[i].getEntityType();
				packagedItems.relatedcontentsetid=rssets[i].getRelatedContentSetID();
				packagedItems.siteid=arguments.siteid;

				arrayAppend(returnArray,packagedItems);
			}

			var result=packageIteratorArray(getBean('beanIterator').setArray(returnArray).setEntityName('relatedcontentset'),returnArray,'findRelatedContent');

			StructDelete(result,'links');

			return result;

		} else {
			iterator=entity.getRelatedContentIterator(argumentCollection=args);
			setIteratorProps(iterator,arguments.params);
			returnArray=iteratorToArray(iterator=iterator,siteid=arguments.siteid,expand=arguments.expand,$=$,expanded=arguments.expanded,expandedProp='relatedcontent');
			var packagedItems=packageIteratorArray(iterator,returnArray,'findRelatedContent');
			structDelete(packagedItems,'links');
			packagedItems.name=arguments.relatedcontentsetid;
			return packagedItems;
		}

	}

	function applyRemoteFormat(str){

		//arguments.str=replaceNoCase(str,"/index.cfm","",'all');
		//arguments.str=replaceNoCase(str,'href="/','href="##/','all');
		//arguments.str=replaceNoCase(str,"href='/","href=''##/",'all');

		return trim(arguments.str);
	}

	function getCustomImageSizeIterator(siteid){
		if(!isDefined('variables.images')){
			variables.images=getBean('settingsManager').getSite(arguments.siteid).getCustomImageSizeIterator();
		}
		if(!isdefined('request.muracustomimageiterator')){
			request.muraCustomImageIterator=duplicate(variables.images);
		}

		request.muraCustomImageIterator.reset();

		return request.muraCustomImageIterator;
	}

	function setImageURLs(entity,attr="fileid",$){

		if(arguments.attr == 'fileid' && arguments.entity.hasImage()){
			if(!isDefined('variables.images')){
				variables.images=getBean('settingsManager').getSite(entity.getSiteID()).getCustomImageSizeIterator();
			}


			var secure=getBean('settingsManager').getSite(entity.getSiteID()).getUseSSL();

			var returnStruct={
				small=arguments.entity.getImageURL(secure=secure,complete=1,size='small'),
				medium=arguments.entity.getImageURL(secure=secure,complete=1,size='medium'),
				large=arguments.entity.getImageURL(secure=secure,complete=1,size='large'),
				source=arguments.entity.getImageURL(secure=secure,complete=1,size='source')
			};

			var image='';
			var images=getCustomImageSizeIterator(arguments.entity.getSiteID());

			while(images.hasNext()){
				image=images.next();
				returnStruct['#image.getName()#']=arguments.entity.getImageURL(secure=secure,complete=1,size=image.getName());
			}

			variables.images.reset();
		} else if (arguments.attr != 'fileid' && isValid('uuid',entity.get(arguments.attr)) ){
			 var fileEXT=getBean("fileManager").readMeta(arguments.entity.get(arguments.attr)).fileEXT;
			 if(ListFindNoCase('jpg,jpeg,png,gif,svg', fileEXT)){
				 if(!isDefined('arguments.$')){
					 arguments.$=getBean('$').init(arguments.entity.getSiteid());
				 }

				 if(!isDefined('variables.images')){
					 variables.images=getBean('settingsManager').getSite(entity.getSiteID()).getCustomImageSizeIterator();
				 }

				 var image='';
				 var images=getCustomImageSizeIterator(arguments.entity.getSiteID());
				 var secure=getBean('settingsManager').getSite(arguments.entity.getSiteID()).getUseSSL();
				 var renderer=arguments.$.getContentRenderer();

				 var returnStruct={
	 				small=renderer.getURLForImage(fileid=arguments.entity.get(arguments.attr),secure=secure,complete=1,size='small'),
	 				medium=renderer.getURLForImage(fileid=arguments.entity.get(arguments.attr),secure=secure,complete=1,size='medium'),
	 				large=renderer.getURLForImage(fileid=arguments.entity.get(arguments.attr),secure=secure,complete=1,size='large'),
	 				source=renderer.getURLForImage(fileid=arguments.entity.get(arguments.attr),secure=secure,complete=1,size='source')
	 			};

				 while(images.hasNext()){
					 image=images.next();
					 returnStruct['#image.getName()#']=renderer.getURLForImage(fileid=arguments.entity.get(arguments.attr),secure=secure,complete=1,size=image.getName(),fileExt=fileEXT);
				 }
				 variables.images.reset();
			 } else {
				 return returnStruct;
			 }
		} else {
			var returnStruct={};
		}

		return returnStruct;

	}

	/* 	
		If it's a defined entity, then only allow validation on defined properties
		If it's not a defined entity, then only allow validation on properties that don't match to defined methods
	*/
	function lockdownValidations(bean,validations){
		var sanitizedValidations={};
		if(structKeyExists(arguments.validations,'properties') && isStruct(arguments.validations.properties)){
			for(var key in arguments.validations.properties){
				if(isValid('variableName',key)){
					if(arguments.bean.getEntityName() != 'bean'){
						if(arguments.bean.hasProperty(key)){
							sanitizedValidations.properties[key]=arguments.validations.properties[key];
						}
					} else {
						if(!isDefined('arguments.bean.get#key#')){
							sanitizedValidations.properties[key]=arguments.validations.properties[key];
						}
					}
				}
			}
		}
		if(structKeyExists(arguments.validations,'conditions') && isStruct(arguments.validations.conditions)){
			sanitizedValidations.conditions={};
			for(var condition in arguments.validations.conditions){
				for(var key in arguments.validations.conditions['#condition#']){
					if(isValid('variableName',key)){
						if(arguments.bean.getEntityName() != 'bean'){
							if(arguments.bean.hasProperty(key)){
								if(!structKeyExists(sanitizedValidations.conditions,'#condition#')){
									sanitizedValidations.conditions['#condition#']={};
								}
								sanitizedValidations.conditions['#condition#'][key]=arguments.validations.conditions['#condition#'][key];
							}
						} else {
							if(!isDefined('arguments.bean.get#key#')){
								if(!structKeyExists(sanitizedValidations.conditions,'#condition#')){
									sanitizedValidations.conditions['#condition#']={};
								}
								sanitizedValidations.conditions['#condition#'][key]=arguments.validations.conditions['#condition#'][key];
							}
						}
					}
				}
				
			}
		}

		return sanitizedValidations;
	}

	function validate(data='{}',validations='{}',siteid) {
		
		if(isSimpleValue(arguments.data)){
			arguments.data=urlDecode(arguments.data);

			if(isJSON(arguments.data)){
				arguments.data=deserializeJSON(arguments.data);
			} else {
				throw(type="invalidParameters");
			}
		}

		if(isSimpleValue(arguments.validations)){
			arguments.validations=urlDecode(arguments.validations);
		
			if(isJSON(arguments.validations)){
				arguments.validations=deserializeJSON(arguments.validations);
			} else {
				throw(type="invalidParameters");
			}
		} 

		if(!isStruct(arguments.data) || !isStruct(arguments.validations)){
			return {invalid='Invalid validation request'};
		}

		param name="arguments.data.fields" default="";
		param name="arguments.data.siteid" default=arguments.siteid;

		var $=getBean('Mura').init(arguments.data.siteid);

		param name="request.muraValidationContext" default={};

		var validationContextID=createUUID();

		request.muraValidationContext['#validationContextID#']=arguments.data;

		if(isDefined('arguments.data.entityname') && arguments.data.entityname != 'bean'){

			if(data.entityName=='content'){
				if(!structKeyExists(arguments.data,'contentid')){
					arguments.data.contentid=createUUID();
				}
			}

			var bean=getBean(arguments.data.entityname);

			if(!structKeyExists(arguments.data,'#bean.getPrimaryKey()#')){
				arguments.data[bean.getPrimaryKey()]=createUUID();
			}
			
			var args={'#bean.getPrimaryKey()#'=arguments.data[bean.getPrimaryKey()]};
			
			if(!allowAccess(bean,$)){
				throw(type="authorization");
			}

			bean.loadBy(argumentCollection=args);
			bean.set('siteid',arguments.data.siteid);
			bean.set('validationContextID',validationContextID);
			bean.set(bean.getPrimaryKey(),arguments.data[bean.getPrimaryKey()]);

			errors=bean.validate(arguments.data.fields).getErrors();
		
			return errors;
		}

		errors={};

		if(!structIsEmpty(arguments.validations)){
			var bean=new mura.bean.bean();

			bean.set('validationContextID',validationContextID);
			bean.setValidations(lockdownValidations(bean,arguments.validations))
			bean.validate(arguments.data.fields)
			
			structAppend(errors,bean.getErrors());
		}
	
		if(isDefined('arguments.data.bean') && isDefined('arguments.data.loadby') && arguments.data.bean != 'bean'){

			var bean=getBean(arguments.data.bean);
			var args={
				'#arguments.data.loadby#'=arguments.data[arguments.data.loadby],
				siteid=arguments.data.siteid
			};

			if(!allowAccess(bean,$)){
				throw(type="authorization");
			}

			bean.loadBy(argumentCollection=args);
			bean.set('validationContextID',validationContextID);
			bean.validate(arguments.data.fields)
				
			structAppend(errors,bean.getErrors());
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

				/*
				if(listFindNoCase('folder,gallery,calendar,page',$.event('object'))){
					result={
						html=$.getContentRenderer().dspContentTypeBody(params=args.params)
					};
					break;
				}
				*/

				result=$.dspObject(argumentCollection=args);

				if(isdefined('request.muraJSONRedirectURL')){
					result={redirect=request.muraJSONRedirectURL};
				} else {
					if($.useLayoutManager() && isdefined('result.html') && result.render=='server'){
						result={render='server',async=true,html=trim('#$.dspObject_include(theFile='object/meta.cfm',params=args.params)#<div class="mura-object-content">#result.html#</div>')};
						if(listFindNoCase('component,form',args.object)){
							param name="args.params.perm" default=0;
							result.perm=args.params.perm;
						}
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

	function getSwaggerPropertyDataType(datatype){

		switch(arguments.datatype){
			case 'int':
			case 'integer':
			case 'numeric':
				var result= {
					'type'='integer',
					'format'='int64'
				};
				break;
			case 'smallint':
			case 'tinyint':
			case 'meduimint':
			case 'bit':
				var result= {
					'type'='integer',
					'format'='int32'
				};
				break;
			case 'boolean':
				var result= {
					'type'='boolean'
				};
				break;
			case 'float':
				var result= {
					'type'='float'
				};
				break;
			case 'double':
				var result= {
					'type'='double'
				};
				break;
			case 'date':
				var result= {
					"type"= "string",
					"format"= "date"
				};
				break;
			case 'datetime':
			case 'timestamp':
				var result={
					"type": "string",
					"format": "date-time"
				};
				break;
			default:
				var result= {
					'type'='string'
				};
		}

		return result;

	}

	function getSwaggerEntityParams(entity,_in="query",idInPath=false,method='get',mode='',csrf=true){
		var response=[];
		var item='';
		var p='';
		var properties=arguments.entity.getProperties();
		var map={};

		if(entity.getEntityName()=='content'){
			var primarykey='contentid';
		} else {
			var primarykey=lcase(entity.getPrimaryKey());
		}

		if(arguments.idInPath){
			arrayAppend(response,{
					"name"= primarykey,
					"in"= "path",
					"required"= true,
					"type"= "string"
				});

		}

		if(arguments.mode=='JSON' && arguments.csrf){
			arrayAppend(response,{
					"name"= 'csrf_token',
					"in"= "formData",
					"description"= "Value returned from generateCSRFTokens, context of '#primarykey#'",
					"required"= true,
					"type"= "string"
				});

			arrayAppend(response,{
					"name"= 'csrf_token_expires',
					"in"= "formData",
					"description"= "Value returned from generateCSRFTokens, context of '#primarykey#'",
					"required"= true,
					"type"= "string"
				});
		}

		if(arguments.mode=='JSON' && arguments._in=='query'){
			if(entity.getEntityName()=='content'){

				arrayAppend(response,{
						"name"= 'contentPoolID',
						"in"= "query",
						"description"= "A list of SiteIDs that would like to query. (Each must be assigned in site settings)",
						"required"= false,
						"type"= "string"
					});

					arrayAppend(response,{
							"name"= 'feedID',
							"in"= "query",
							"description"= "A feedID of a collection defined in the the Masa CMS admin",
							"required"= false,
							"type"= "string"
						});

					arrayAppend(response,{
							"name"= 'feedName',
							"in"= "query",
							"description"= "A the name of a collection defined in the the Masa CMS admin",
							"required"= false,
							"type"= "string"
						});

					arrayAppend(response,{
							"name"= 'showExcludeSearch',
							"in"= "query",
							"description"= "Whether to include content that has set to not be in site search",
							"required"= false,
							"type"= "boolean"
						});

					arrayAppend(response,{
							"name"= 'includeHomePage',
							"in"= "query",
							"description"= "Whether to include the home page in query results",
							"required"= false,
							"type"= "boolean"
						});

					arrayAppend(response,{
							"name"= 'showNavOnly',
							"in"= "query",
							"description"= "Whether to include content that has been set to not be included in site navigation",
							"required"= false,
							"type"= "boolean"
						});
			}
			arrayAppend(response,{
					"name"= 'fields',
					"in"= "query",
					"description"= "A comma separated list of fields or links that you would like return. Use * for all",
					"required"= false,
					"type"= "string"
				});

			arrayAppend(response,{
					"name"= 'expand',
					"in"= "query",
					"description"= "A list of relationships links that you would like pre-fetched. Use * for all",
					"required"= false,
					"type"= "string"
				});

			arrayAppend(response,{
					"name"= 'expandDepth',
					"in"= "query",
					"description"= "The number of level that you want to expand",
					"required"= false,
					"type"= "number",
					"format"= "int64"
				});

			arrayAppend(response,{
					"name"= 'maxItems',
					"in"= "query",
					"description"= "The maximum items that you would like to retrieve",
					"required"= false,
					"type"= "integer",
					"format"= "int64"
				});

			arrayAppend(response,{
					"name"= 'itemsPerPage',
					"in"= "query",
					"description"= "The number of items per page",
					"required"= false,
					"type"= "integer",
					"format"= "int64"
				});

			arrayAppend(response,{
					"name"= 'pageIndex',
					"in"= "query",
					"description"= "The page index to return",
					"required"= false,
					"type"= "integer",
					"format"= "int64"
				});
		}

		var entityConfig=getEntityConfig(entity.getEntityName());
		var allowedFields='';

		if(isDefined('entityConfig.fields')){
			allowedFields=entityConfig.fields;
		}

		for(p in properties){
			if(!len(allowedFields) || listFindNoCase(allowedFields,p)){
				if(properties['#p#'].persistent
					&& (
						!structKeyExists(properties['#p#'],'fkcolumn')
						 || properties['#p#'].fkcolumn != 'primarykey'
						 )
					&& !(arguments.idInPath && p==arguments.entity.getPrimaryKey())
					){

					item={};

					if(structKeyExists(properties['#p#'],'fkcolumn')){
						item["name"]=lcase(properties['#p#'].fkcolumn);
					} else {
						item["name"]=lcase(properties['#p#'].name);
					}

					if(!structKeyExists(map,item.name)){
						item["in"]= arguments._in;

						if(arguments.method=='save'){
							item["required"]= properties['#p#'].required;
						} else {
							item["required"]= false;
						}

						structAppend(item,getSwaggerPropertyDataType(properties['#p#'].datatype),true);
						arrayAppend(response,item);

						map['#item.name#']=true;
					}
				}
			}
		}

		return response;
	}

	function getSwaggerEntityProps(entity){
		var response={
			"links"={
				"$ref"= "##/definitions/links"
			}
		};
		var p='';
		var properties=arguments.entity.getProperties();

		for(p in properties){

			var entityConfig=getEntityConfig(entity.getEntityName());
			var allowedFields='';

			if(isDefined('entityConfig.fields')){
				allowedFields=entityConfig.fields;
			}

			if(!len(allowedFields) || listFindNoCase(allowedFields,p)){
				if(properties['#p#'].persistent
					&& (
						!structKeyExists(properties['#p#'],'fkcolumn')
						 || properties['#p#'].fkcolumn != 'primarykey'
					)){

					if(structKeyExists(properties['#p#'],'fkcolumn')){
						response['#lcase(properties['#p#'].fkcolumn)#']=getSwaggerPropertyDataType(properties['#p#'].datatype);
					} else {
						response['#lcase(properties['#p#'].name)#']=getSwaggerPropertyDataType(properties['#p#'].datatype);
					}
				}
			}
		}

		return response;
	}

	function swagger(siteid,params){
		param name="arguments.params" default=url;
		param name="arguments.params.entities" default="";
		param name="arguments.params.mode" default=request.muraAPIRequestMode;

		var $=getBean('$').init(arguments.siteid);
		var entity='';
		var primarykey='';

		if(!listFindNoCase('json,rest',arguments.params.mode)){
			arguments.params.mode=request.muraAPIRequestMode;
		}

		//Rigged to always have index.cfm until some issues are figured out
		if(true || $.globalConfig('indexFileInURLS')){
			var indexFile="/index.cfm";
		} else {
			var indexFile="";
		}

		var result={
			"swagger"= "2.0",
			"info"= {
				"description"= "This is the JSON API for #$.siteConfig().getRootPath(complete=1)#",
				"version"= "1.0.0",
				"title"= $.siteConfig('site'),
				"termsOfService"= "https://www.masacms.com",
				"contact"= {
				"email"= $.siteConfig('contact')
			},
			"license"= {
				"name"= "GPL-2.0 with execptions",
				"url"= "https://github.com/MasaCMS/MasaCMS/blob/main/license.txt"
			}
			},
			"host"= $.siteConfig('domain') & $.siteConfig('serverPort'),
			"basePath"= "#indexFile#/_api/#arguments.params.mode#/v1/#$.siteConfig('siteid')#",
			"tags"= [
				{
					"name"= "Masa CMS",
					"description"= "Open source content management system",
					"externalDocs"= {
					"description"= "Find out more",
					"url"= "https://www.masacms.com"
					}
				}
			],
			"schemes"= [
			$.getBean('utility').getRequestProtocol()
			],
			'paths'={},
			'definitions'={}
		};

		if(arguments.params.mode == 'JSON'){
			var appliedSecurity=[];
		} else {
			var appliedSecurity=[
				{"oauth2_code"=[]},
				{"oauth2_credentials"=[]},
				{"oauth2_password"=[]},
				{"apiKey"= []}
			];
		}

		var entityKeys=listToArray(ListSort(StructKeyList(variables.config.entities),'textnocase'));

		for(var i in entityKeys){
			if(i != 'contentnav'){
				if($.getServiceFactory().containsBean(i)){
					entity=$.getBean(i);

					if(i=='group'){
						entity.setType(1);
					}

					if((!len(arguments.params.entities) || listFindNoCase(arguments.params.entities,i)) && len(entity.getPrimaryKey()) && allowAccess(entity,$,false)){

						if(entity.getEntityName()=='content'){
							primarykey='contentid';
						} else {
							primarykey=lcase(entity.getPrimaryKey());
						}

						result['paths']['/#lcase(i)#']={
							"get"= {
								"tags"= [
									lcase(i)
								],
								"summary"= "List #i#s",
								"description"= "",
								"operationId"= "list#$.getBean('utility').setProperCase(i)#",
								"consumes"= [
									"application/json"
								],
								"produces"= [
									"application/json"
								],
								"parameters"= getSwaggerEntityParams(entity=entity,_in="query",idInPath=false,method='findQuery',mode=arguments.params.mode,csrf=false),
								"responses"= {
									"200"= {
										"description"= "Collection of #i#",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#collection"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},
								"security"= appliedSecurity

							}

							,
							"post"= {
								"tags"= [
									i
								],
								"summary"= "Creates or Updates a #i#",
								"description"= "",
								"operationId"= "save#$.getBean('utility').setProperCase(i)#",
								"consumes"= [
									"multipart/form-data"
								],
								"produces"= [
									"application/json"
								],
								"parameters"= getSwaggerEntityParams(entity=entity,_in='formData',idInPath=false,method='save',mode=arguments.params.mode),
								"responses"= {
									"200"= {
										"description"= "#i# entity",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},
								"security"= appliedSecurity

							}
							/*,
							"delete"= {
								"tags"= [
									i
								],
								"summary"= "Deletes a #i#",
								"description"= "",
								"operationId"= "delete#$.getBean('utility').setProperCase(i)#",
								"consumes"= [
									"multipart/form-data"
								],
								"produces"= [
									"application/json"
								],
								"parameters"= [
									{
										"name"= lcase(entity.getPrimaryKey()),
										"in"= "formData",
										"description"= "#i# id to delete",
										"required"= true,
										"type"= "string"
									},
									{
										"in"= "formData",
										"description"= "Value returned from generateCSRFTokens, context of 'login'",
										"required"= false,
										"type"= "string",
										"name"= "csrf_token"
									},
									{
										"in"= "formData",
										"description"= "Value returned from generateCSRFTokens, context of 'login'",
										"required"= false,
										"type"= "string",
										"name"= "csrf_token_expires"
									}
								],
								"responses"= {
									"200"= {
										"description"= "#i# entity",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},

								"security"= appliedSecurity
							}	*/
						};

						result['paths']['/#lcase(i)#/{#primaryKey#}']={
							"get"= {
								"tags"= [
									i
								],
								"summary"= "Reads a #i#",
								"description"= "",
								"operationId"= "read#$.getBean('utility').setProperCase(i)#ByPath",
								"consumes"= [],
								"produces"= [
									"application/json"
								],
								"parameters"= [
										{
											"name"= primarykey,
											"in"= "path",
											"description"= "#i# id to get",
											"required"= true,
											"type"= "string"
										}
									],
								"responses"= {
									"200"= {
										"description"= "#i# entity",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},
								"security"= appliedSecurity

							},
							"post"= {
								"tags"= [
									i
								],
								"summary"= "Updates a #i#",
								"description"= "",
								"operationId"= "save#$.getBean('utility').setProperCase(i)#ByPath",
								"consumes"= [
									"multipart/form-data"
								],
								"produces"= [
									"application/json"
								],
								"parameters"= getSwaggerEntityParams(entity=entity,_in='formData',idInPath=true, method='save',mode=arguments.params.mode),
								"responses"= {
									"200"= {
										"description"= "#i# entity",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},
								"security"= appliedSecurity

							},
							"delete"= {
								"tags"= [
									i
								],
								"summary"= "Deletes a #i#",
								"description"= "",
								"operationId"= "delete#$.getBean('utility').setProperCase(i)#ByPath",
								"consumes"= [],
								"produces"= [
									"application/json"
								],
								"parameters"= [
									{
										"name"= primarykey,
										"in"= "path",
										"description"= "#i# id to delete",
										"required"= true,
										"type"= "string"
									}
								],
								"responses"= {
									"200"= {
										"description"= "#i# entity",
										"schema"= {
											"type"="object",
											"properties"={
												"data"={
													"$ref"="##/definitions/#lcase(i)#"
												}
											}
										}
									},
									"405"= {
										"description"= "Invalid input"
									}
								},
								"security"= appliedSecurity

							}
						};

						result["definitions"]["#lcase(i)#"]={
							"type"="object",
							"properties"=getSwaggerEntityProps(entity)
						};

						result["definitions"]["#lcase(i)#collection"]={
							"type"="object",
							"properties"={
								"links"={
									"$ref"= "##/definitions/links"
								},
								"entityname"={"type"="string"},
								"items"={
									"type"="array",
									"items"={
										"$ref"= "##/definitions/#lcase(i)#"
									}
								}
							}
						};

					}
				}
			}
		}

		result["definitions"]["links"]={"type"="object","properties"={}};
		result["definitions"]["user"]={
			"type"="object",
			"properties"=getSwaggerEntityProps($.getBean('user'))
		};


		result['paths']['/findCurrentUser']={
			"get"= {
				"tags"= ['user'],
				"summary"= "Finds current user",
				"description"= "",
				"operationId"= "findCurrentUser",
				"consumes"= [],
				"produces"= [
					"application/json"
				],
				"parameters"= [],
				"responses"= {
					"200"= {
						"description"= "Status",
						"schema"= {
							"type"="object",
							"properties"={
								"data"={
									"$ref"="##/definitions/user"
								}
							}
						}
					},
					"405"= {
						"description"= "Invalid input"
					}
				},
				"security"= appliedSecurity
			}
		};

		if(arguments.params.mode == 'REST'){
			result['securityDefinitions']=
			{
				"oauth2_code"={
				  "type"= "oauth2",
					"scopes": {},
					"flow":"accessCode",
		      "authorizationUrl"= $.createHREF(filename='authorize',complete=true),
					"tokenUrl"= $.siteConfig().getRootPath(complete=1)  & result.basePath & "/oauth2"
				},
				"oauth2_credentials"={
				  "type"= "oauth2",
					"scopes": {},
					"flow":"application",
					"tokenUrl"= $.siteConfig().getRootPath(complete=1)  & result.basePath & "/oauth2"
				},
				"oauth2_password"={
				  "type"= "oauth2",
					"scopes": {},
					"flow":"password",
					"tokenUrl"= $.siteConfig().getRootPath(complete=1)  & result.basePath & "/oauth2"
				},
				"apiKey"= {
					"type"= "apiKey",
					"name"= "Authorization",
					"in"= "header"
				}
			};
		} else {

			result["definitions"]["csrf_tokens"]={
				"type"="object",
				"properties"={
					"csrf_token"= {
						"type"= "string"
						},
					"csrf_token_expires"= {
						"type"= "string"
						}
				}
			};

			result['paths']['/login']={
				"post"= {
					"tags"= ['security'],
					"summary"= "Log in user",
					"description"= "",
					"operationId"= "login",
					"consumes"= [
						"multipart/form-data"
					],
					"produces"= [
						"application/json"
					],
					"parameters"= [
						{
							"in"= "formData",
							"description"= "username of account",
							"required"= true,
							"type"= "string",
							"name"= "username"
						},
						{
							"in"= "formData",
							"description"= "password of account",
							"required"= true,
							"type"= "string",
							"name"= "password"
						},
						{
							"in"= "formData",
							"description"= "siteid of site to log into",
							"required"= false,
							"type"= "string",
							"name"= "siteid"
						},
						{
							"in"= "formData",
							"description"= "Value returned from generateCSRFTokens, context of login",
							"required"= false,
							"type"= "string",
							"name"= "csrf_token"
						},
						{
							"in"= "formData",
							"description"= "Value returned from generateCSRFTokens, context of login",
							"required"= false,
							"type"= "string",
							"name"= "csrf_token_expires"
						}
					],
					"responses"= {
						"200"= {
							"description"= "Status"
						},
						"405"= {
							"description"= "Invalid input"
						}
					},
					"security"= appliedSecurity
				}
			};

			result['paths']['/logout']={
				"post"= {
					"tags"= ['security'],
					"summary"= "Log out user",
					"description"= "",
					"operationId"= "logout",
					"consumes"= [
						"multipart/form-data"
					],
					"produces"= [
						"application/json"
					],
					"parameters"= [],
					"responses"= {
						"200"= {
							"description"= "Status"
						},
						"405"= {
							"description"= "Invalid input"
						}
					},
					"security"= appliedSecurity
				}
			};

			result['paths']['/generateCSRFTokens']={
				"post"= {
					"tags"= ['security'],
					"summary"= "Generate CSFR tokens",
					"description"= "",
					"operationId"= "generateCSRFTokens",
					"consumes"= [
						"multipart/form-data"
					],
					"produces"= [
						"application/json"
					],
					"parameters"= [
						{
							"in"= "formData",
							"description"= "Unique key to identify transaction, most often the primary key of entity.",
							"required"= true,
							"type"= "string",
							"name"= "content"
						},

						{
							"in"= "formData",
							"description"= "siteid of site to log into",
							"required"= false,
							"type"= "string",
							"name"= "siteid"
						}
					],
					"responses"= {
						"200"= {
							"description"= "",
							"schema"= {
								"type"="object",
								"properties"={
									"data"={
										"$ref"="##/definitions/csrf_tokens"
									}
								}
							}
						},
						"405"= {
							"description"= "Invalid input"
						}
					},
					"security"= appliedSecurity
				}
			};
		}
		//result["paths"]=StructSort(result["paths"],"text","asc");

		result=serializeJSON(result);
		result=replace(result,'"swagger":2.0','"swagger":"2.0"');
		return result;
	}

	function isAggregateQuery() {

			if(isDefined('url.fields') && len(url.fields)){
				return false;
			}

			var checkArray=['sum','avg','count','max','min','groupBy','distinct'];

			for(var i in checkArray){
				if(structKeyExists(url,i) || len(cgi.query_string) && find("=#i#[",cgi.query_string)){
					return true;
				}
			}

			return false;
	}

	function getOAuthTokenInfo(siteid,clientid,access_token){
		if(request.muraAPIRequestMode!='rest'){
			throw(type="invalidParameters");
		}

		var token=getBean('oauthToken').loadBy(token=arguments.access_token);

		if(!token.exists() || token.isExpired()){
			throw(type="invalidParameters");
		}

		var $currentuser=getCurrentUser();

		var response={
			'token_type'='Bearer',
			'access_token'=token.getToken(),
			'expires_in'=token.getExpiresIn(),
			'expires_at'=token.getExpiresAt(),
			'info'=token.getTokenInfo()
		};

		if(request.muraHasOAuthBearerTokenHeader && isJSON(token.getData()) && ( $currentuser.isAdminUser() || $currentuser.isSuperUser() || $currentuser.getUserID() == token.getUserID() ) ) {
			response['info']=token.getTokenInfo();
		}

		return response;
	}

}
