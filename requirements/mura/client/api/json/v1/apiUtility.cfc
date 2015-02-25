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
			publicMethods="findOne,findMany,findAll,findNew,findQuery,save,delete,findCrumbArray,generateCSRFTokens,validateEmail,login,logout,submitForm,findCalendarItems,validate,processAsyncObject,findRelatedContent",
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
	      .asString('title');

	    registerEntity('site',{
	    	public=true,
			fields="domain,siteid",
			allowfieldselect=false
		});

		registerEntity('content',{
			public=true,
			fields="parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl,isNew"
		});

		registerEntity('content',{public=true});
		registerEntity('user',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('group',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('address',{public=false,moduleid='00000000000000000000000000000000008'});
		registerEntity('changeset',{public=true,moduleid='00000000000000000000000000000000014'});
		registerEntity('feed',{public=true,moduleid='00000000000000000000000000000000011'});
		registerEntity('category',{public=true,moduleid='00000000000000000000000000000000010'});
		registerEntity('comment',{public=true,moduleid='00000000000000000000000000000000015'});

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

	function getEntityConfig(){
		if(structKeyExists(variables.config.entities,arguments.entityName)){
			return variables.config;
		} else {
			return {};
		}
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

	function processRequest(path=cgi.path_info){

		try {
			var responseObject=getpagecontext().getResponse();
			var params={};
			var result="";

			getBean('utility').suppressDebugging();

			structAppend(params,url);
			structAppend(params,form);
			structAppend(form,params);

			var paramsArray=[];
			var pathInfo=listToArray(arguments.path,'/');
			var method="GET";
			var httpRequestData=getHTTPRequestData();

			session.siteid=variables.siteid;

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

				if(!(listFindNoCase('validate,processAsyncObject',params.method) || getBean('settingsManager').getSite(variables.siteid).getJSONApi())){
					throw(type='authorization');
				}

				if(arrayLen(pathInfo) > 1){
					parseParamsFromPath(pathInfo,params,2);
				}

				if(isDefined('#params.method#')){
					result=evaluate('#params.method#(argumentCollection=params)');
					
					if(!isJson(result)){
						result=getSerializer().serialize({'data'=result});
					}

					responseObject.setContentType('application/json; charset=utf-8');
					responseObject.setStatus(200);
					return result;
				}
			}

			if(!getBean('settingsManager').getSite(variables.siteid).getJSONApi()){
				throw(type='authorization');
			}

			if(arrayLen(pathInfo)){
				params.siteid=pathInfo[1];
			}

			if(arrayLen(pathInfo) > 1){
				if(isDefined(pathInfo[2])){
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
						result=getSerializer().serialize({'data'=result});
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

			if(!isDefined("params.siteid") || !(isDefined("params.entityName") && len(params.entityName) && getServiceFactory().containsBean(params.entityName)) ){
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
					method=httpRequestData.method;
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
							method=httpRequestData.method;
						}
					} else if (params.entityName=='content') {
						params.id=pathInfo[3];
						var filenamestart=3;

						if(pathInfo[3]=='_path'){
							params.render=true;
							params.id='';
							filenamestart=4;
						} 

						if(arrayLen(pathInfo) > filenamestart){
							for(var i=filenamestart;i<=arrayLen(pathInfo);i++){
								params.id=listAppend(params.id,pathInfo[i],'/');
							}
						}

					} else{
						parseparamsFromPath(pathInfo,params,3);
					}
						
				} else {
					method=httpRequestData.method;
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
								return getSerializer().serialize({'data'=findCrumbArray(argumentCollection=params)});
							} else {
								if(!isDefined('params.relationship.cfc')){
									throw(type='invalidParameters');
								}

								params.entityName=params.relationship.cfc;

								structDelete(params,'relateEntity');
								structAppend(url,params);

								if(params.relationship.fieldtype=='one-to-many'){
									result=findQuery(argumentCollection=params);
								} else {
									if(listLen(params.id)){
										params.ids=params.id;
										result=findMany(argumentCollection=params);
									} else if(params.id=='new') {
										result=findNew(argumentCollection=params);
									} else {
										result=findOne(argumentCollection=params);
									}	
								}
								
							}
						} else {
							if(listLen(params.id) > 1){
								params.ids=params.id;
								result=findMany(argumentCollection=params);
							} else {
								result=findOne(argumentCollection=params);
							}
						}

					} else {
						if(structCount(url)){
							result=findQuery(argumentCollection=params);
						} else {
							result=findAll(argumentCollection=params);
						}
					}

				break;

				case "PUT":
				case "POST":

					result=save(argumentCollection=params);

				break;

				case "DELETE":
					result=delete(argumentCollection=params);
			}

			try{
				if(responseObject.getStatus() != 404){
					responseObject.setStatus(200);
				}
			} catch (Any e){}

			responseObject.setContentType('application/json; charset=utf-8');
			return getSerializer().serialize({'data'=result});
		} 

		catch (authorization e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(401);
			return getSerializer().serialize({'error'={'message'='Insufficient Account Permissions'}});
		}

		catch (invalidParameters e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'error'={'message'='Insufficient parameters'}});
		}

		catch (invalidMethodCall e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'error'={'message'="Invalid method call"}});
		}

		catch (badRequest e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'error'={'message'="Bad Request"}});
		}

		catch (invalidTokens e){
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(400);
			return getSerializer().serialize({'error'={'message'="Invalid CSRF tokens"}});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			responseObject.setContentType('application/json; charset=utf-8');
			responseObject.setStatus(500);
			return getSerializer().serialize({'error'={'message'="Unhandeld Exception",'stacktrace'=e}});
		}

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
			//writeDump(var= application.objectMappings['#arguments.from#'].hasMany,abort=1);
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

	function AllowAccess(bean,$){

		if(isObject(arguments.bean)){
			if(!isDefined('arguments.bean.getEntityName')){
				throw(type='invalidParameters');
			}
			var entityName=arguments.bean.getEntityName();
		} else {
			if(!getServiceFactory().containsBean(arguments.bean)){
				throw(type='invalidParameters');
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

		switch(arguments.bean.getEntityName()){
			case 'content':
				switch(arguments.bean.getType()){
					case 'Form':	
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000000',variables.siteid)){
							return false;
						}
					break;
					case 'Component':
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000003',variables.siteid)){
							return false;
						}
					break;
					default:	
						if(!getBean('permUtility').getModulePerm('00000000000000000000000000000000004',variables.siteid)){
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
				 
				if(local.currentBean.getIsNew() && len(local.currentBean.getParentID())){
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
			var response=degetSerializer().serialize(result.filecontent);
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

		var entity=$.getBean(arguments.entityName);

		if(!allowAction(entity,$)){
			throw(type="authorization");
		}

		var pk=entity.getPrimaryKey();

		if(arguments.id=='new'){
			$.event('id',createUUID());
			arguments.id=$.event('id');
			$.event(pk,arguments.id);
		}

		if(arguments.entityName=='content' && len($.event('contenthistid'))){
			var loadByparams={contenthistid=$.event('contenthistid')};
		} else {
			var loadByparams={'#pk#'=arguments.id};
		}

		if($.validateCSRFTokens(context=arguments.id)){
			entity.loadBy(argumentCollection=loadByparams)
				.set(
					$.event().getAllValues()
				)
				.save();
		} else {
			throw(type="invalidTokens");
		}

		//getpagecontext().getresponse().setHeader("Location","#getEndPoint()##entity.getEntityName()#/#arguments.id#");

		if(arguments.entityName=='content'){
			loadByparams={contenthistid=entity.getContentHistID()};
		} else {
			loadByparams={'#pk#'=entity.getValue(pk)};
		}

		entity=$.getBean(entityName).loadBy(
				argumentCollection=loadByparams
				);

		var returnStruct=getFilteredValues(entity,$);
		returnStruct.links=getLinks(entity);
		returnStruct.id=returnStruct[pk];
	
		/*
		var tokens=$.generateCSRFTokens(context=returnStruct.id);
		structAppend(returnStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
		*/
		
		return returnStruct;
	}

	function getFilteredValues(entity,$,expand=true){
		var fields='';
		var vals={};

		if(len($.event('entityConfigName'))){
			var entityConfigName=$.event('entityConfigName');
		} else {
			var entityConfigName=arguments.entity.getEntityName();
		}
		if(!(isDefined('variables.config.entities.#entityConfigName#.allowfieldselect') && !variables.config.entities[entityConfigName].allowfieldselect) && len($.event('fields'))){
			fields=$.event('fields');

			if(arguments.entity.getEntityName()=='content' && !listFindNoCase(fields,'contentid')){
				fields=listAppend(fields,'contentid');
			} else if (arguments.entity.getEntityName()!='content' && !listFindNoCase(fields,arguments.entity.getPrimaryKey())){
				fields=listAppend(fields,arguments.entity.getPrimaryKey());
			}

			if(!listFindNoCase(fields,'siteid')){
				fields=listAppend(fields,'siteid');
			}
		} else if(isDefined('variables.config.entities.#entityConfigName#.fields')){
			fields=variables.config.entities[entityConfigName].fields;
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
			vals=arguments.entity.getAllValues(expand=arguments.expand);
			structDelete(vals,'addObjects');
			structDelete(vals,'removeObjects');
			structDelete(vals,'frommuracache');
			structDelete(vals,'errors');
			structDelete(vals,'instanceid');
			structDelete(vals,'primaryKey');
			structDelete(vals,'extenddatatable');
		}

		return vals;
	}

	function findOne(entityName,id,siteid,render=false){
		var $=getBean('$').init(arguments.siteid);
		
		if(arguments.entityName=='content'){
			var pk = 'contentid';
			if(arguments.render){
				if(arguments.id=='null'){
					arguments.id='';
				}

				getBean('contentServer').renderFilename(filename=arguments.id,siteid=arguments.siteid,validateDomain=false);		
		

			} else {
				if(len($.event('contenthistid'))){
					var entity=$.getBean('content').loadBy(contenthistid=$.event('contenthistid'));	
				} else {	
					var entity=$.getBean('content').loadBy(contentid=arguments.id);	
				}
			}

		} else {
			var entity=$.getBean(arguments.entityName);

			if($.event('entityName')=='feed'){
				var pk="feedid";
			} else {
				var pk=entity.getPrimaryKey();
			}
			
			var loadparams={'#pk#'=arguments.id};
			entity.loadBy(argumentCollection=loadparams);
		}
		
		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		var returnStruct=getFilteredValues(entity,$);

		if(listFindNoCase('content,contentnav',arguments.entityName)){
			returnstruct.images=setImageURLS(entity,$);
			returnstruct.url=entity.getURL();
		}

		returnStruct.links=getLinks(entity);		
		returnStruct.id=returnStruct[pk];

		/*
		var tokens=$.generateCSRFTokens(context=returnStruct.id);
		structAppend(returnStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
		*/

		return returnStruct;
	}

	function findNew(entityName,siteid){

		var $=getBean('$').init(arguments.siteid);	
		var entity=$.getBean(arguments.entityName);

		if($.event('entityName')=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}
		
		var loadparams={'#pk#'=''};
		entity.loadBy(argumentCollection=loadparams);
	
		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		var returnStruct=getFilteredValues(entity,$);

		if(listFindNoCase('content,contentnav',arguments.entityName)){
			returnstruct.images=setImageURLS(entity,$);
			returnstruct.url=entity.getURL();
		}

		returnStruct.links=getLinks(entity);		
		returnStruct.id=returnStruct[pk];

		return returnStruct;
	}

	function findAll(siteid,entityName){
		
		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean(arguments.entityName);

		if(!allowAccess(entity,$)){
			throw(type="authorization");
		}

		var feed=entity.getFeed();
		
		if(arguments.entityName=='group'){
			feed.setType(1);
		}

		setFeedProps(feed,$);

		var iterator=feed.getIterator();

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

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			itemStruct.links=getLinks(item);

			/*
			var tokens=$.generateCSRFTokens(context=itemStruct.id);
			structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, itemStruct);
		}

		return {'items'=returnArray};
	}

	function findMany(entityName,ids,siteid){
		
		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess(entityName,$)){
			throw(type="authorization");
		}

		if($.event('entityName')=='content' && len($.event('feedid'))){
			var feed=$.getBean('feed').loadBy(feedid=$.event('feedid'));
		} else {
			var entity=$.getBean(arguments.entityName);
			var feed=entity.getFeed();

			if(arguments.entityName=='group'){
				feed.setType(1);
			}
		}

		setFeedProps(feed,$);

		if($.event('entityName')=='content'){
			var pk="contentid";
		} else if($.event('entityName')=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		feed.addParam(column=pk,criteria=arguments.ids,condition='in');
	
		var iterator=feed.getIterator();

		//writeDump(var=iterator.getQUery(),abort=1);
		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			itemStruct.links=getLinks(item);

			/*
			var tokens=$.generateCSRFTokens(context=itemStruct.id);
			structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, itemStruct );
		}

		return formatArray(returnArray);
	}

	function findQuery(entityName,siteid){
		
		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess(arguments.entityName,$)){
			throw(type="authorization");
		}

		if($.event('entityName')=='content' && len($.event('feedid'))){		
			var feed=$.getBean('feed').loadBy(feedid=$.event('feedid'));
		} else if($.event('entityName')=='content' && len($.event('feedname'))){
			var feed=$.getBean('feed').loadBy(name=$.event('feedname'));
		} else {
			var entity=$.getBean(arguments.entityName);
			var feed=entity.getFeed();

			if(arguments.entityName=='group'){
				feed.setType(1);
			}
		}

		setFeedProps(feed,$);

		if($.event('entityName')=='content'){
			var pk="contentid";
		} else if($.event('entityName')=='feed'){
			var pk="feedid";
		} else {
			var pk=entity.getPrimaryKey();
		}

		for(var p in url){

			if(entity.valueExists(p)){
				var condition="=";

				if(find('*',url[p])){
					condition="like";
				}

				feed.addParam(column=p,criteria=replace(url[p],'*','%','all'),condition=condition);
			}	
		}

		var iterator=feed.getIterator();

		//writeDump(var=iterator.getQUery(),abort=1);
		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			itemStruct.links=getLinks(item);

			/*
			var tokens=$.generateCSRFTokens(context=itemStruct.id);
			structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, itemStruct );
		}

		return formatArray(returnArray);
	}

	function setFeedProps(feed,$){
		if(len($.event('orderby'))){
			feed.setOrderBy($.event('orderby'));
		}

		if(len($.event('sortby'))){
			feed.setSortBy($.event('sortby'));
		}

		if(len($.event('sortdirection'))){
			feed.setSortDirection($.event('sortdirection'));
		}

		if(len($.event('maxitems'))){
			feed.setMaxItems($.event('maxitems'));
		}

		if(len($.event('size'))){
			feed.setMaxItems($.event('size'));
		}

		if(len($.event('limit'))){
			feed.setMaxItems($.event('limit'));
		}

		if(isNumeric($.event('isPublic'))){
			feed.setIsPublic($.event('isPublic'));
		}

		if($.event('entityName')=='content' && len($.event('type'))){
			feed.setType($.event('type'));
		}
	}

	function findCrumbArray(entityName,id,siteid){
		
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

		var params={'#pk#'=arguments.id};
		var iterator=entity.loadBy(argumentCollection=params).getCrumbIterator();
		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false);
			
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			itemStruct.links=getLinks(item);
			
			/*
			var tokens=$.generateCSRFTokens(context=itemStruct.id);
			structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
			*/
			
			arrayAppend(returnArray, itemStruct );
		}

		return formatArray(returnArray);
	}

	function delete(entityName,id,siteid){
		
		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(!allowAction(entity,$)){
			throw(type="authorization");
		}
		
		if($.event('entityName')=='content'){
			if(len($.event('contenthistid'))){
				var loadparams={contenthistid=$.event('contenthistid')};
				entity.loadBy(argumentCollection=loadparams);

				if($.validateCSRFTokens(context=arguments.id)){
					entity.deleteVersion();
				}
			} else {
				var loadparams={contentid=$.event('id')};
				entity.loadBy(argumentCollection=loadparams);

				if($.validateCSRFTokens(context=arguments.id)){
					entity.delete();
				} else {
					throw(type="invalidTokens");
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

			if($.validateCSRFTokens(context=arguments.id)){
				entity.delete();
			} else {
				throw(type="invalidTokens");
			}
		}
		
		return '';
	}

	function getEndPoint(){
		return variables.endpoint;
	}

	function getLinks(entity){
		var links={};
		var p='';
		var baseURL=getEndPoint();

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
			links['feed']="#baseurl#method=findQuery&siteid=#entity.getSiteID()#&entityName=content&deedid=#entity.getFeedID()#";	
		}

		if(entity.getEntityName()=='content'){
			links['renderered']="#baseurl#/_path/#entity.getFilename()#";
			links['crumbs']="#baseurl#?method=findCrumbArray&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('contentid')#";	
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

	function findRelatedContent(id,siteid){
		
		var $=getBean('$').init(arguments.siteid);

		if(!allowAccess('content',$)){
			throw(type="authorization");
		}

		var entity=$.getBean('content').loadBy(contentid=arguments.id);

		var args={};

		if(len($.event('sortby'))){
			args.sortBy=$.event('sortby');
		}

		if(len($.event('sortdirection'))){
			args.sortdirection=$.event('sortdirection');
		}

		if(len($.event('name'))){
			args.name=$.event('name');
		}

		if(len($.event('reverse'))){
			args.reverse=$.event('reverse');
		}

		if(len($.event('relatedContentSetID'))){
			args.relatedContentSetID=$.event('relatedContentSetID');
		}

		var iterator=entity.getRelatedContentIterator(argumentCollection=args);

		//writeDump(var=iterator.getQUery(),abort=1);
		var returnArray=[];
		var itemStruct={};
		var item='';
		var subIterator='';
		var subItem='';
		var subItemArray=[];
		var p='';
		var pk=entity.getPrimaryKey();

		while(iterator.hasNext()){
			item=iterator.next();
			itemStruct=getFilteredValues(item,$,false);
			if(len(pk)){
				itemStruct.id=itemStruct[pk];
			}

			if(listFindNoCase('content,contentnav',arguments.entityName)){
				itemStruct.images=setImageURLS(item,$);
				itemStruct.url=item.getURL();
			}

			itemStruct.links=getLinks(item);

			/*
			var tokens=$.generateCSRFTokens(context=itemStruct.id);
			structAppend(itemStruct,{csrf_token=tokens.token,csrf_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, itemStruct );
		}

		return formatArray(returnArray);
	}

	function applyRemoteFormat(str){
		
		//arguments.str=replaceNoCase(str,"/index.cfm","",'all');
		//arguments.str=replaceNoCase(str,'href="/','href="##/','all');
		//arguments.str=replaceNoCase(str,"href='/","href=''##/",'all');
	
		return arguments.str;
	}

	function setImageURLs(entity,$){
		
		if(arguments.entity.hasImage()){
			if(!isDefined('variables.images')){
				variables.images=arguments.$.siteConfig().getCustomImageSizeIterator();
			}
			
			var cm=$.getBean('contentManager');

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
		} else {
			var returnStruct={};
		}

		return returnStruct;

	}

	function validate(data={},validations={}) {

		data=deserializeJSON(urlDecode(arguments.data));
		validations=deserializeJSON(urlDecode(arguments.validations));
		
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
		session.siteid=request.siteid;
		request.servletEvent=new mura.servletEvent();
		
		var $=request.servletEvent.getValue("MuraScope");
		
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
		
		$.event('crumbdata',$.content().getCrumbArray());
		$.event().getHandler('standardSetContentRenderer').handle($.event());
		$.getContentRenderer().injectMethod('crumbdata',$.event("crumbdata"));
		$.event().getHandler('standardSetPermissions').handle($.event());
		$.event().getHandler('standardSetLocale').handle($.event());
		//$.event().getHandler('standardMobile').handle($.event());

		if($.event('object')=='comments'){
			$.event().getHandler('standardSetCommentPermissions').handle($.event());
		}

		if($.event('r').restrict){
			$.event('nocache',1);
		}

		//Turn off cfformprotext js
		request.cffpJS=true;

		switch($.event('object')){
			case 'login':
				if(getHTTPRequestData().method == 'POST' && len($.event('username')) && len($.event('password'))){

					if(getBean('loginManager').remoteLogin($.event().getAllValues(),'')){
						if(len($.event('returnurl'))){
							return {redirect=$.event('returnurl')};
						} else {
							return {redirect="./##"};
						}
					} else {
						$.event('status','failed');
					}
				}

				return {
					html=applyRemoteFormat($.dspObject_Include(theFile='dsp_login.cfm'))
				};

			break;

			case 'calendar':
				return {
					html=applyRemoteFormat($.dspObject_Include(thefile="calendar/index.cfm"))
				};

			break;

			case 'search':
				return {
					html=applyRemoteFormat($.dspObject_Include(thefile="dsp_search_results.cfm"))
				};

			break;

			case 'displayregion':
				return {
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
										return {redirect=$.event('returnurl')};
									} else {
										return {redirect="./"};
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
								return {redirect=$.event('returnurl')};

							} else if (structIsEmpty($.event().getValue('userBean').getErrors()) && $.event().valueExists('passwordNoCache') && $.event().getValue('userBean').getInactive() eq 0){
								$.event().setValue('userID',$.event().getValue('userBean').getUserID());
								$.getBean('userUtility').loginByUserID(userid=$.event('userid'),siteid=$.event('siteid'));

								if(len($.event('returnurl'))){
									return {redirect=$.event('returnurl')};
								} else {
									return {redirect="./"};
								}
							}
						}

					break;
				}

				
				return {
						html=applyRemoteFormat($.dspObject_Include(theFile='dsp_edit_profile.cfm'))
					};
			break;

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
				siteid=arguments.siteid
			};

		if(len($.event('objectparams')) && !isJson($.event('objectparams'))){
			args.params=urlDecode($.event('objectparams'));
		}

		var result={html=applyRemoteFormat($.dspObject(argumentCollection=args))};
		
		if(isdefined('request.muraJSONRedirectURL')){
			return {redirect=request.muraJSONRedirectURL};
		} else {
			return result;
		}
	
	}

	function generateCSRFTokens(siteid,context){
		var tokens=getBean('$').init(arguments.siteid).generateCSRFTokens(context=arguments.context);

		return {csrf_token=tokens.token,csrf_token_expires=tokens.expires};
	}

}