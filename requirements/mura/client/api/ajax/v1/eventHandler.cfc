component output="false" extends="mura.cfobject" {

	function standardTranslationHandler($){
		param name="request.returnFormat" default="HTML";

		if(!listFindNoCase("HTML,JSON",request.returnFormat)){
			request.returnFormat="HTML";
		}

		arguments.event.getTranslator('standard#request.returnFormat#').translate(arguments.$);
	}

	function standardJSONTranslator($){
		
		var result=$.content().getAllValues();
		var renderer=$.getContentRenderer();
		var apiUtility=getBean('apiUtility');
		
		renderer.injectMethod('showInlineEditor',false);
		renderer.injectMethod('showAdminToolBar',false);
		renderer.injectMethod('showMemberToolBar',false);
		renderer.injectMethod('showEditableObjects',false);

		request.cffpJS=true;
			
		result.body=apiUtility.applyRemoteFormat($.dspBody(body=$.content('body'),crumblist=false,renderKids=false));
	
		result.displayRegions={};

		for(var r =1;r<=ListLen($.siteConfig('columnNames'),'^');r++){
			result.displayRegions['#replace(listGetAt($.siteConfig('columnNames'),r,'^'),' ','','all')#']=$.dspObjects(columnid=r);
		}

		for(r in result.displayRegions){
			result.displayRegions[r]=apiUtility.applyRemoteFormat(result.displayRegions[r]);
		}

		result.HTMLHeadQueue=$.renderHTMLQueue('head');
		result.HTMLFootQueue=$.renderHTMLQueue('foot');

		result.id=result.contentid;
		result.links=getLinks($.content());
		result.images=setImageUrls($.content(),$);

		getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8');
		$.event('__MuraResponse__',serializeJSON(setLowerCaseKeys(result)));
	}
	
	function standard404Handler($){
		if($.content('isNew')){
			$.announceEvent('onSite404');
		}

		if($.content('isNew')){
			$.event('contentBean',$.getBean('contentManager').getActiveContentByFilename("404",$.event('siteid'),true));
			if(len($.event('previewID'))){
				$.content('Body','The requested version of this content could not be found.');
			}
			$.noIndex();
		}
		
	}	

	function standardForceSSLHandler($){}
	function standardWrongFilenameHandler($){}
	function standardPostLogoutHandler($){}
	function standardRequireLoginHandler($){}
}