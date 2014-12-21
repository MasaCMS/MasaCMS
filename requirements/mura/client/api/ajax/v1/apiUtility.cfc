component extends="mura.cfobject" {
	/*
	GET/:siteid/:entityName/:id => /?method=findOne&entityName=:entityname&siteid=:siteid&id=:id
	GET/:siteid/:entityName/:id/:relatedEntity/$ => /?method=findMany&entityName=:relatedEntity&siteid=:siteid&:entityNameFK=:id
	GET/:siteid/:entityName/new => /?method=findOne&entityName=:entityname&siteid=:siteid&id=
	GET/:siteid/:entityName/$ => /?method=findMany&entityName=:entityname&siteid=:siteid
	POST/:siteid/:entityName/ => /?method=save&entityName=:entityname&siteid=:siteid
	DELETE/:siteid/:entityName/:id => /?method=delete&entityName=:entityname&siteid=:siteid

	200 - OK - Everything went fine.
	400s - all caused by user interaction
	400 - Bad Request - The request was malformed or the data supplied by the end user was not valid. This is also used if the user has exceeded their API usage limit.
	401 - Unauthorized - The user is not authorized to access the requested resource. Additional information is typically supplied within the response to tell the end user (API consumer) how to authorize itself (ie. BASIC Authentication).
	403 - Forbidden - The user has exceeded their post limit (not bloody likely).
	404 - Not Found - The requested resource was not found.
	405 - Method Not Allowed - The user attempted to use a verb (ex. GET, POST) on a resource that had no support for the given verb.
	406 - Not Acceptable - The user requested a return format (ex. JSON, XML) that is not currently supported.
	*/

	function init(siteid){

		variables.siteid=arguments.siteid;

		var configBean=getBean('configBean');
		var context=configBean.getContext();
		var site=getBean('settingsManager').getSite(variables.siteid);
		
		if(getBean('utility').isHTTPS()){
			var protocol="https://";
		} else {
			var protocol="http://";
		}

		if(configBean.getIndexfileinurls()){
			variables.endpoint="#protocol##site.getDomain()##configBean.getContext()#/index.cfm/_api/ajax/v1/";	
		} else {
			variables.endpoint="#protocol##site.getDomain()##configBean.getContext()#/_api/ajax/v1/";	
		}

		variables.config={
			linkMethods=[],
			publicMethods="findOne,findMany,findAll,findQuery,save,delete,findCrumbArray,generateCSRFTokens,validateEmail,login,logout,submitForm",
			entities={
				site={
					fields="domain,siteid",
					allowfieldselect=false
				},
				contentnav={
					fields="parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl"
				},
				content={
					fields="parentid,moduleid,path,contentid,contenthistid,changesetid,siteid,active,approved,title,menutitle,summary,tags,type,subtype,displayStart,displayStop,display,filename,url,assocurl"
				}
			}
		};

		variables.serializer = new mura.jsonSerializer()
	      .asString('expires')
	      .asString('token');

		return this;
	}

	function getConfig(){
		return variables.config;
	}

	function setConfig(conifg){
		variables.config=arguments.config;
		return this;
	}

	function registerPublicMethod(methodName, method){
		if(!listFindNoCase(variables.config.publicMethods,arguments.methodName)){
			variables.config.publicMethods=listAppend(variables.config.publicMethods,arguments.methodName);
		}

		if(isDefined('arguments.method')){
			injectMethod(arguments.methodName,arguments.method);
		}

		return this;
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

	function processRequest(){

		try {
			var responseObject=getpagecontext().getresponse();
			var params={};
			var result="";

			structAppend(params,url);
			structAppend(params,form);
			structAppend(form,params);

			var paramsArray=[];
			var pathInfo=listToArray(cgi.path_info,'/');
			var method="GET";
			var httpRequestData=getHTTPRequestData();

			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);
			arrayDeleteAt(pathInfo,1);

			//writeDump(var=pathInfo,abort=1);
			responseObject.setcontenttype('application/json; charset=utf-8');

			if(!getBean('settingsManager').getSite(variables.siteid).getJSONApi()){
				throw(type='authorization');
			}

			if (!isDefined('params.method') && arrayLen(pathInfo) && isDefined('#pathInfo[1]#')){
				params.method=pathInfo[1];
			}

			if (isDefined('params.method') && isDefined('#params.method#')){

				if(!listFindNoCase(variables.config.publicMethods, params.method) ){
					throw(type="invalidMethodCall");
				}

				if(arrayLen(pathInfo) > 1){
					parseParamsFromPath(pathInfo,params,2);
				}

				if(isDefined('#params.method#')){
					result=evaluate('#params.method#(argumentCollection=params)');
					
					if(!isJson(result)){
						result=serializeJSON(result);
					}
					getpagecontext().getresponse().setStatus(200);
					return result;
				}
			}

			
			if(arrayLen(pathInfo)){
				params.siteid=pathInfo[1];
			}

			if(arrayLen(pathInfo) > 1){
				params.entityName=pathInfo[2];
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
								return serializeJSON(findCrumbArray(argumentCollection=params));
							} else {
								if(!isDefined('params.relationship.cfc')){
									throw(type='invalidParameters');
								}

								params.entityName=params.relationship.cfc;

								structDelete(params,'relateEntity');
								structAppend(url,params);

								if(params.relationship.fieldtype=='one-to-many'){
									result=serializeJSON(findQuery(argumentCollection=params));
								} else {
									if(listLen(params.id)){
										params.ids=params.id;
										result=serializeJSON(findMany(argumentCollection=params));
									} else {
										result=serializeJSON(findOne(argumentCollection=params));
									}	
								}
								
							}
						} else {
							if(listLen(params.id)){
								params.ids=params.id;
								result=serializeJSON(findMany(argumentCollection=params));
							} else {
								result=serializeJSON(findOne(argumentCollection=params));
							}
						}

					} else {
						if(structCount(url)){
							result=serializeJSON(findQuery(argumentCollection=params));
						} else {
							result=serializeJSON(findAll(argumentCollection=params));
						}
					}

				break;

				case "PUT":
				case "POST":

					result=serializeJSON(save(argumentCollection=params));

				break;

				case "DELETE":
					result=serializeJSON(delete(argumentCollection=params));
			}

			try{
				if(responseObject.getStatus() != 404){
					responseObject.setStatus(200);
				}
			} catch (Any e){}

			return result;
		} 

		catch (authorization e){
			responseObject.setStatus(401);
			return serializeJSON({'error'='Insufficient Account Permissions'});
		}

		catch (invalidParameters e){
			responseObject.setStatus(400);
			return serializeJSON({'error'='Insufficient parameters'});
		}

		catch (invalidMethodCall e){
			responseObject.setStatus(400);
			return serializeJSON({error="Invalid method call"});
		}

		catch (badRequest e){
			responseObject.setStatus(400);
			return serializeJSON({error="Bad Request"});
		}

		catch (invalidTokens e){
			responseObject.setStatus(400);
			return serializeJSON({error="Invalid CSRF tokens"});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			responseObject.getresponse().setStatus(500);
			return serializeJSON(e);
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
	
	function saveForm(){
		
		if(!isValidRequest()){
			throw(type="badRequest");
		}

		var $=getBean('$').init(form);

		$.event(
			'formDataBean',
			$.getBean('dataCollectionBean')
				.set($.event().getAllValues())
				.save($)
				.sendNotification($)
		);
	
		var formBean=$.event('formDataBean').getFormBean();

		$.announceEvent('onAfterFormSubmitSave');
		$.announceEvent('onAfterForm#formBean.getSubType()#SubmitSave');

		return this;
	}

	function isValidRequest(){
		return (isDefined('session.siteid') && isDefined('session.mura.requestcount') && session.mura.requestcount > 1);
	}

	function AllowAction(bean){

		if(isDefined('arguments.bean')){
			switch(arguments.bean.getEntityName()){
				case 'content':
					switch(arguments.bean.getType()){
						case 'Form':	
							if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000000',session.siteid)){
								return false;
							}
						break;
						case 'Component':
							if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000003',session.siteid)){
								return false;
							}
						break;
						default:	
							if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000004',session.siteid)){
								return false;
							}
						break;
					}

					local.currentBean=getBean("content").loadBy(contentID=arguments.bean.getContentID(), siteID= arguments.bean.getSiteID()); 
					
					if(not local.currentBean.getIsNew()){
						local.crumbData=arguments.bean.getCrumbArray(); 
						local.perm=getBean('permUtility').getNodePerm(local.crumbData);
					}
					 
					if(local.currentBean.getIsNew() && len(arguments.rc.parentID)){
						local.crumbData=getBean('contentGateway').getCrumblist(arguments.bean.getParentID(), arguments.bean.getSiteID());
						local.perm=etBean('permUtility').getNodePerm(local.crumbData);  
					}
					 
					if(!listFindNoCase('author,editor',local.perm)){
						return false;
					}

					if(local.perm=='author'){
						arguments.bean.setApproved(0);
					}

				break;
				case 'user':
				case 'address':
					if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000008',session.siteid)){
						return false;
					}
				break;
				case 'category':
					if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000010',session.siteid)){
						return false;
					}
				break;
				case 'feed':
					if(not (getBean('permUtility').getModulePerm('00000000000000000000000000000000000',session.siteid) && getBean('permUtility').getModulePerm('00000000000000000000000000000000011',session.siteid))){
						return false;
					}
				break;
				case 'changeset':
					if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000014',session.siteid)){
						return false;
					}
				break;
				case 'comment':
					if(not getBean('permUtility').getModulePerm('00000000000000000000000000000000015',session.siteid)){
						return false;
					}
				break;
				default:
					if(not (getBean('permUtility').getModulePerm('00000000000000000000000000000000000',session.siteid) && isDefined('variables.pluginid') && getBean('permUtility').getModulePerm(getBean('pluginManager').getConfig(variables.pluginid).getValue('plugnid'),session.siteid))){
						return false;
					}
			}

			return true;
		} else {
			if(not (getBean('permUtility').getModulePerm('00000000000000000000000000000000000',session.siteid) && isDefined('variables.pluginid') && getBean('permUtility').getModulePerm(getBean('pluginManager').getConfig(variables.pluginid).getValue('plugnid'),session.siteid))){
				return false;
			} else {
				return true;
			}
		}
	}
	
	function validateEmail() {
			
		if(!isValidRequest()){
			throw(type="badRequest");
		}

		var $=getBean('$').init(session.siteid);
		var result='invalid';


		var httpService = new http(); 
		httpService.setMethod("get"); 
		httpService.setCharset("utf-8"); 
		httpService.setUrl("https://bpi.briteverify.com/emails.json?address=#arguments.email#&apikey=#$.siteConfig('mmpBrightVerifyAPIKey')#"); 
		var result=httpService.send().getPrefix();

		try{
			var response=deserializeJSON(result.filecontent);
		} catch(any e){
			var response={status='invalid'};
		}

		return response;
	}

	function login(username,password,siteid,lockdownCheck=false,lockdownExpires=''){
		var result=getBean('userUtility').login(argumentCollection=arguments);

		if(result){
			return {status="success"};
		} else {
			return {status="failed"};
		}
	}

	function logout(){
		var $=getBean('loginManager').logout();
		return {status="success"};
	}

	
	// MURA ORM ADAPTER

	function save(siteid,entityname,id='new'){

		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(!allowAction(entity)){
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
		structAppend(returnStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
		*/
		
		return setLowerCaseKeys(returnStruct);
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
				if(len(prop)){
					temp['#f#']=prop;
				}
			}

			vals=temp;
		} else {
			vals=arguments.entity.getAllValues(expand=arguments.expand);
		}

		return vals;
	}
	function findOne(entityName,id,siteid,process=false){

		var $=getBean('$').init(arguments.siteid);

		if(arguments.entityName=='content'){
			var pk="contentid";

			if(len($.event('contenthistid'))){
				var entity=$.getBean('content').loadBy(contenthistid=$.event('contenthistid'));	
			} else if(isValid('uuid',arguments.id) || arguments.id=='00000000000000000000000000000000001' || arguments.id=='new'){	
				var entity=$.getBean('content').loadBy(contentid=arguments.id);	
			} else {
				if(arguments.id=='null'){
					arguments.id='';
				}

				request.returnFormat='JSON';

				getBean('contentServer').renderFilename(filename=arguments.id,siteid=arguments.siteid,validateDomain=false);
				
			}
			
		} else {
			var entity=$.getBean(arguments.entityName);
			var pk=entity.getPrimaryKey();
			var loadparams={'#pk#'=arguments.id};
			entity.loadBy(argumentCollection=loadparams);
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
		structAppend(returnStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
		*/

		return setLowerCaseKeys(returnStruct);
	}

	function findAll(siteid,entityName){
		
		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean(arguments.entityName);
		var feed=entity.getFeed();
		
		if(arguments.entityName=='group'){
			feed.setType(1);
		}

		setFeedProps(feed,$);

		var iterator=feed.getIterator();

		if($.event('entityName')=='content'){
			var pk="contentid";
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
			structAppend(itemStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, setLowerCaseKeys(itemStruct) );
		}

		return {'items'=returnArray};
	}

	function findMany(entityName,ids,siteid){
		
		var $=getBean('$').init(arguments.siteid);

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
		} else {
			var pk=entity.getPrimaryKey();
		}

		feed.addParam(column=pk,criteria=arguments.ids,condition='in');
		
		if(len($.event('orderby'))){
			feed.setOrderBy($.event('orderby'));
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
			structAppend(itemStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, setLowerCaseKeys(itemStruct) );
		}

		return formatArray(returnArray);
	}

	function findQuery(entityName,siteid){
		
		var $=getBean('$').init(arguments.siteid);

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

		if(len($.event('orderby'))){
			feed.setOrderBy($.event('orderby'));
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
			structAppend(itemStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
			*/

			arrayAppend(returnArray, setLowerCaseKeys(itemStruct) );
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
	}

	function findCrumbArray(entityName,id,siteid){
		
		var $=getBean('$').init(arguments.siteid);
		var entity=$.getBean(arguments.entityName);
		
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
			structAppend(itemStruct,{mura_token=tokens.token,mura_token_expires='#tokens.expires#'});
			*/
			
			arrayAppend(returnArray, setLowerCaseKeys(itemStruct) );
		}

		return formatArray(returnArray);
	}

	function delete(entityName,id,siteid){
		
		var $=getBean('$').init(arguments.siteid);

		var entity=$.getBean(arguments.entityName);

		if(!allowAction(entity)){
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
			var pk=entity.getPrimaryKey();

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
			links['processed']="#baseurl#?method=findOne&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('filename')#";
			links['crumbs']="#baseurl#?method=findCrumbArray&siteid=#entity.getSiteID()#&entityName=#entity.getEntityName()#&id=#entity.getValue('contentid')#";	
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

	function setLowerCaseKeys(data){
		var returnStruct={};

		for(var i in arguments.data){

			if(isStruct(arguments.data[i])){
				returnStruct[lcase(i)]=setLowerCaseKeys(arguments.data[i]);
			} else {
				returnStruct[lcase(i)]=arguments.data[i];
			}
		}

		return returnStruct;
	}

	function applyRemoteFormat(str){
		arguments.str=replaceNoCase(str,"/index.cfm/","index.html##/",'all');
		arguments.str=replaceNoCase(str,'href="/','href="##/','all');
		arguments.str=replaceNoCase(str,"href='/","href=''##/",'all');
		arguments.str=replaceNoCase(str,"validateForm(this)","validateForm(this,remoteSubmit)",'all');
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

	function generateCSRFTokens(siteid,context){
		return variables.serializer.serialize(setLowerCaseKeys(getBean('$').init(arguments.siteid).generateCSRFTokens(context=arguments.context)));
	}

}