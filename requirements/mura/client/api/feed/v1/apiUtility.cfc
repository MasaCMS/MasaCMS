<cfcomponent extends="mura.cfobject">
	<cfscript>

	/*
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
		
		/*
		if( getBean('utility').isHTTPS() || YesNoFormat(site.getUseSSL()) ) {
			var protocol="https://";
		} else {
			var protocol="http://";
		}
		*/
		
		//if(configBean.getIndexfileinurls()){
			variables.endpoint="#site.getResourcePath(complete=1)#/index.cfm/_api/feed/v1/#variables.siteid#";	
		/*
		} else {
			variables.endpoint="#site.getResourcePath(complete=1)#/_api/feed/v1/#variables.siteid#";	
		}
		*/

		variables.config={
			publicMethods="feed"
		};

	
		return this;
	}

	function getEndPoint(){
		return variables.endpoint;
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

	function setEntityConfig(enitytName,config={}){
		registerPublicEntity(argumentCollection=arguments);
		return this;
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

	function processRequest(){

		try {
			var responseObject=getpagecontext().getresponse();
			var params={};
			var result="";

			getBean('utility').suppressDebugging();

			structAppend(params,url);
			structAppend(params,form);
			structAppend(form,params);

			var paramsArray=[];
			var pathInfo=listToArray(cgi.path_info,'/');
			var method="GET";
			var httpRequestData=getHTTPRequestData();

			session.siteid=variables.siteid;	

			if(arrayLen(pathInfo)){
				if(pathInfo[1]=='tasks'){
					arrayDeleteAt(pathInfo,1);
					arrayDeleteAt(pathInfo,1);
				} else {
					arrayDeleteAt(pathInfo,1);
					arrayDeleteAt(pathInfo,1);
					arrayDeleteAt(pathInfo,1);
				}
			}
		
			if(cgi.user_agent contains "Mozilla"){
				responseObject.setcontenttype('text/xml');
			} else {
				responseObject.setcontenttype('application/rss+xml');
			}
					
			if(arrayLen(pathInfo) && pathInfo[1]==variables.siteid){
				arrayDeleteAt(pathInfo,1);
			}
			
			if (!isDefined('params.method') && arrayLen(pathInfo) > 1 && isDefined('#pathInfo[2]#')){
				params.method=pathInfo[2];
			}
			
			if (isDefined('params.method') && isDefined('#params.method#')){

				if(!listFindNoCase(variables.config.publicMethods, params.method) ){
					throw(type="invalidMethodCall");
				}

				if(arrayLen(pathInfo) > 2){
					parseParamsFromPath(pathInfo,params,3);
				}

				if(isDefined('#params.method#')){
					result=evaluate('#params.method#(argumentCollection=params)');
					
					if(!isXML(result)){
						result=_serializeWDDX({'data'=result});
					}

					getpagecontext().getresponse().setStatus(200);
					return result;
				}
			}

			return feed(params=params);

		} 

		catch (authorization e){
			responseObject.setStatus(401);
			return _serializeWDDX({'error'={'message'='Insufficient Account Permissions'}});
		}

		catch (invalidParameters e){
			responseObject.setStatus(400);
			return _serializeWDDX({'error'={'message'='Insufficient parameters'}});
		}

		catch (invalidMethodCall e){
			responseObject.setStatus(400);
			return _serializeWDDX({'error'={'message'="Invalid method call"}});
		}

		catch (badRequest e){
			responseObject.setStatus(400);
			return _serializeWDDX({'error'={'message'="Bad Request"}});
		}

		catch (invalidTokens e){
			responseObject.setStatus(400);
			return _serializeWDDX({'error'={'message'="Invalid CSRF tokens"}});
		}

		catch (Any e){
			writeLog(type="Error", file="exception", text="#e.stacktrace#");
			responseObject.getresponse().setStatus(500);
			return _serializeWDDX({'error'={'message'="Unhandeld Exception",'stacktrace'=e}});
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

	</cfscript>

	<cffunction name="feed" output="false">
		<cfargument name="params">
		<cfset var is404=false>
		<cfparam name="arguments.params.username" default="" />
		<cfparam name="arguments.params.password" default="" />
		<cfparam name="arguments.params.filter" default="" />
		<cfparam name="arguments.params.feedID" default="" />
		<cfparam name="arguments.params.contentID" default="" />
		<cfparam name="arguments.params.categoryID" default="" />
		<cfparam name="arguments.params.siteid" default=""/>
		<cfparam name="arguments.params.maxItems" default="20"/>
		<cfparam name="arguments.params.tag" default=""/>
		<cfif application.configBean.getValue(property='allowOpenFeeds',defaultValue=false)>
			<cfif arguments.params.feedID neq "">
				<cfset var feedBean=application.feedManager.read(arguments.params.feedID) />
				<cfif feedBean.getRestricted() and application.settingsManager.getSite(feedBean.getSiteID()).getextranetssl() and  cgi.https eq 'Off'>
					<cfif cgi.query_string eq ''>
						<cfset var location='#cgi.script_name#'>
					<cfelse>
						<cfset var location='#cgi.script_name#?#cgi.QUERY_STRING#'>
					</cfif>
					<cflocation addtoken="no" url="https://#request.rspage.domain##location#">
				</cfif>
				<cfif feedBean.getIsNew()>
					<cfset is404=true>
				</cfif>
			<cfelseif arguments.params.siteid neq "">
				<cfset var feedBean=application.feedManager.read("") />
				<cfset feedBean.set(url)/>
			<cfelse>
				<cfset is404=true>
			</cfif>
		<cfelse>
			<cfif arguments.params.feedID neq "">
				<cfset var feedBean=application.feedManager.read(arguments.params.feedID) />
				<cfif feedBean.getRestricted() and application.settingsManager.getSite(feedBean.getSiteID()).getextranetssl() and  cgi.https eq 'Off'>
					<cfif cgi.query_string eq ''>
						<cfset location='#cgi.script_name#'>
					<cfelse>
						<cfset location='#cgi.script_name#?#cgi.QUERY_STRING#'>
					</cfif>
					<cflocation addtoken="no" url="https://#request.rspage.domain##location#">
				</cfif>
				<cfif feedBean.getIsNew()>
					<cfset is404=true>
				</cfif>
			<cfelse>
				<cfset is404=true>
			</cfif>	
		</cfif>
		<cfif isDefined("feedBean") and not is404>
			<cfset var rs=application.feedManager.getFeed(feedBean=feedBean,tag=arguments.params.tag) />
		</cfif>
		<cfif is404>
			<cfreturn getBean('contentServer').render404()>
		</cfif>
		<cfif isDefined("feedBean")>
			<cfif not application.configBean.getValue(property='allowOpenFeeds',defaultValue=false) and not application.feedManager.allowFeed(feedBean,arguments.params.username,arguments.params.password) >
				<cfthrow type="authorization">
			</cfif>
			<cfset request.muraFrontEndRequest=true>
			<cfset request.siteid=feedBean.getSiteID()>
			<cfset var feedIt = application.serviceFactory.getBean("contentIterator").setQuery(rs)>
			<cfset setLocale(application.settingsManager.getSite(feedBean.getSiteID()).getJavaLocale()) />
			<cfswitch expression="#feedBean.getVersion()#">
				<cfcase value="RSS 0.920">
					<cfreturn rss092(feed=feedBean,iterator=feedIt)>
				</cfcase>
				<cfcase value="RSS 2.0">
					<cfreturn rss20(feed=feedBean,iterator=feedIt)>
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="rss20" output="false">
		<cfargument name="feed">
		<cfargument name="iterator">
		<cfset var item=''>
		<cfset var $=''>
		<cfset var itemdescription=''>
		<cfset var itemcontent=''>
		<cfset var pubdate=''>
		<cfset var rscats=''>
		<cfset var filemeta=''>
		<cfset var thelink=''>
		<cfset var returnString=''>
		
		<cfcontent reset="true"><cfheader name="content-type" value="text/xml;charset=UTF-8">
		<cfsavecontent variable="returnString"><cfoutput><?xml version="1.0" ?>
		<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" >
			<channel>
				<title>#XMLFormat(arguments.feed.renderName())#</title> 
				<link>#application.settingsManager.getSite(arguments.feed.getSiteID()).getScheme()#://#application.settingsManager.getSite(arguments.feed.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#</link> 
				<description>#XMLFormat(arguments.feed.getDescription())#</description> 
				<webMaster>#application.settingsManager.getSite(arguments.feed.getSiteID()).getContact()#</webMaster>
				<generator>http://www.getmura.com</generator>
				<pubDate>#GetHttpTimeString(now())#</pubDate> 
				<language>#XMLFormat(arguments.feed.getLang())#</language>
			<cfloop condition="arguments.iterator.hasNext()">
			<cfsilent>
				<cfset item=arguments.iterator.next()>
				<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
				<cfset $=request.servletEvent.getValue('MuraScope')>
				<!---
				<cfset request.currentFilename=item.getFilename()>
				<cfset request.currentFilenameAdjusted=item.getFilename()>
				<cfset request.muraDynamicContentError=false>
				<cfset $.announceEvent('onSiteRequestStart')>
				<cfset $.event('contentBean',item) />
				<cfset $.event('crumbdata',item.getCrumbArray()) />
				<cfset $.getHandler("standardSetContentRenderer").handle($)>
				<cfset $.getContentREnderer().showInlineEditor=false>
				<cfset $.getHandler("standardSetPermissions").handle($)>		
				<cfset $.getHandler("standardSetIsOnDisplay").handle($)>
				<cfset $.announceEvent('onRenderStart')>
				<cfset r=$.event('r')>
				<cfset r.allow=1>

				<cfif not r.restrict or (r.restrict and r.allow)>
					<cftry>
						<cfset itemcontent=trim($.addCompletePath($.dspBody(pageTitle='',bodyAttribute='body', crumblist=0,showMetaImage=0),item.getSiteID()))>
						<cfif request.muraDynamicContentError>
							<cfset itemcontent="">
						<cfelse>
							<cfset itemcontent = $.addCompletePath(itemcontent,item.getSiteID())>
						</cfif>
						<cfcatch><cfset itemcontent=""></cfcatch>
					</cftry>
				<cfelse>
					<cfset itemcontent="">
				</cfif>
				--->
				<cfset itemdescription=trim($.setDynamicContent(item.getValue('summary')))>
				
				<cfif feed.getallowhtml() eq 0>
					<cfset itemdescription = $.stripHTML(itemdescription)>
					<cfset itemdescription=left(itemdescription,200) & "...">
				<cfelse>
					<cfset itemdescription = $.addCompletePath(itemdescription,item.getSiteID())>
				</cfif>

				<cfif isDate(item.getValue('releaseDate'))>
					<cfset thePubDate=item.getValue('releaseDate')>
				<cfelse>
					<cfset thePubDate=item.getValue('lastUpdate')>
				</cfif>

				<cfset rsCats=application.contentManager.getCategoriesByHistID(item.getContentHistID())>

				<cfset theLink=XMLFormat(item.getURL(complete=true)) />		
				</cfsilent>
				<item>
					<title>#XMLFormat(item.getValue('menuTitle'))#</title>
					<link>#theLink#</link><!---<cfif item.getType() neq 'File' and item.getType() neq 'Link'>
					<comments>#theLink###comments</comments>
					</cfif>---><guid isPermaLink="false">#item.getValue('contentID')#</guid>
					<pubDate>#GetHttpTimeString(thePubDate)#</pubDate>
					<description>#XMLFormat(itemdescription)#</description>
					<cfloop query="rsCats"><category>#XMLFormat(rsCats.name)#</category>	
					</cfloop><!---<cfif item.getType() eq "Page" and len(itemcontent)><content:encoded><![CDATA[#itemcontent#]]></content:encoded>
					</cfif>---><cfif len(item.getFileID())><cfset fileMeta=application.serviceFactory.getBean("fileManager").readMeta(item.getValue('fileID'))><enclosure url="#XMLFormat('#application.settingsManager.getSite(item.getValue('siteid')).getScheme()#://#application.settingsManager.getSite(item.getValue('siteID')).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#item.getValue('fileID')#&fileEXT=.#item.getValue('fileEXT')#')#" length="#item.getValue('fileSize')#" type="#fileMeta.ContentType#/#fileMeta.ContentSubType#" /></cfif>
				</item>
		</cfloop></channel>
		</rss></cfoutput>
		</cfsavecontent>

		<cfreturn returnString>
	</cffunction>

	<cffunction name="rss092" output="false">
		<cfargument name="feed">
		<cfargument name="iterator">
		<cfset var item=''>
		<cfset var itemdescription=''>
		<cfset var itemcontent=''>
		<cfset var pubdate=''>
		<cfset var rscats=''>
		<cfset var filemeta=''>
		<cfset var thelink=''>
		<cfset var returnString=''>
		<cfset var $=application.serviceFactory.getBean('$').init(arguments.feed.getSiteID())>

		<cfcontent reset="true"><cfheader name="content-type" value="text/xml;charset=UTF-8">
		<cfsavecontent variable="returnString"><cfoutput><?xml version="1.0" ?>
		<rss version="0.92"
			xmlns:dc="http://purl.org/dc/elements/1.1/">
			<channel>
				<title>#XMLFormat(arguments.feed.renderName())#</title> 
				<link>http://#listFirst(cgi.http_host,":")#</link> 
				<description>#XMLFormat(arguments.feed.getDescription())#</description> 
				<webMaster>#application.settingsManager.getSite(arguments.feed.getSiteID()).getContact()#</webMaster> 
				<language>#arguments.feed.getLang()#</language>
			<cfloop condition="arguments.iterator.hasNext()">
				<cfsilent>
				<cfset item=arguments.iterator.next()>
				<cfset itemdescription=item.getValue('summary')>
				<cfif feed.getallowhtml() eq 0>
					<cfif not len(itemdescription)>
						<cfset itemdescription=item.getValue('body')>
					</cfif>	
					<cfset itemdescription = $.stripHTML($.setDynamicContent(itemdescription))>
					<cfset itemdescription=left(itemdescription,200) & "...">
				<cfelse>
					<cfset itemdescription = $.addCompletePath($.setDynamicContent(itemdescription),feed.getSiteID())>
				</cfif>
				<cfif isDate(item.getValue('releaseDate'))>
					<cfset thePubDate=item.getValue('releaseDate')>
				<cfelse>
					<cfset thePubDate=item.getValue('lastUpdate')>
				</cfif>
				<cfset rsCats=application.contentManager.getCategoriesByHistID(item.getValue('contentHistID'))>

				<cfset theLink=XMLFormat(item.getURL(complete=true)) />
				</cfsilent>
					<item>
						<title>#XMLFormat(item.getMenuTitle())#</title>
						<description><![CDATA[#itemdescription# ]]></description> 
						<link>#theLink#</link>
						<guid isPermaLink="true">#theLink#</guid>
						<dc:date>#GetHttpTimeString(thePubDate)#</dc:date>
						<cfif item.getValue('type') eq "File"><cfset fileMeta=application.serviceFactory.getBean("fileManager").readMeta(item.getValue('fileID'))><enclosure url="#XMLFormat('http://#application.settingsManager.getSite(item.getValue('siteID')).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#item.getValue('fileID')#&fileEXT=.#item.getValue('fileExt')#')#" length="#fileMeta.filesize#" type="#fileMeta.ContentType#/#fileMeta.ContentSubType#" /></cfif>
					</item>
			</cfloop>
			</channel>
		</rss></cfoutput>
		</cfsavecontent>

		<cfreturn returnString>
	</cffunction>

	<cffunction name="_serializeWDDX" output="false">
		<cfargument name="input">

		<cfwddx action="cfml2wddx" input="#arguments.input#" output="local.output">
		<cfreturn local.output>
	</cffunction>
</cfcomponent>